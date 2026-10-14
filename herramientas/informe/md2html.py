#!/usr/bin/env python3
"""Markdown -> HTML con estructura válida (listas, thead, blockquote) y CSS de impresión."""
import re
import html
import sys
import pathlib

RE_OL = re.compile(r"^\s*\d+\.\s+")
RE_UL = re.compile(r"^\s*[-*]\s+")
RE_LISTA = re.compile(r"^\s*(\d+\.|[-*])\s+")


def inline(s):
    s = html.escape(s, quote=False)
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    s = re.sub(r"!\[(.*?)\]\((.*?)\)", r'<img src="\2" alt="\1">', s)
    s = re.sub(r"\[(.*?)\]\((.*?)\)", r'<a href="\2">\1</a>', s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", s)
    s = re.sub(r"(?<![\*\w])\*([^*\n]+)\*(?!\*)", r"<em>\1</em>", s)
    return s


def es_tabla_delimitador(cells):
    return bool(cells) and all(re.fullmatch(r":?-{2,}:?", c) for c in cells)


def convertir(md):
    lineas = md.split("\n")
    out = []
    i = 0
    lista_abierta = None   # 'ul' | 'ol'
    bloque_cita = False

    def cerrar_lista():
        nonlocal lista_abierta
        if lista_abierta:
            out.append(f"</{lista_abierta}>")
            lista_abierta = None

    def cerrar_cita():
        nonlocal bloque_cita
        if bloque_cita:
            out.append("</blockquote>")
            bloque_cita = False

    while i < len(lineas):
        ln = lineas[i]

        # Bloque de código
        if ln.startswith("```"):
            cerrar_lista(); cerrar_cita()
            lang = ln[3:].strip()
            i += 1
            buf = []
            while i < len(lineas) and not lineas[i].startswith("```"):
                buf.append(lineas[i]); i += 1
            i += 1
            clase = f' class="language-{html.escape(lang)}"' if lang else ""
            out.append(f"<pre><code{clase}>{html.escape(chr(10).join(buf))}</code></pre>")
            continue

        # Tabla
        if ln.startswith("|"):
            cerrar_lista(); cerrar_cita()
            filas = []
            while i < len(lineas) and lineas[i].startswith("|"):
                filas.append([c.strip() for c in lineas[i].strip().strip("|").split("|")])
                i += 1
            if len(filas) >= 2 and es_tabla_delimitador(filas[1]):
                out.append("<table><thead><tr>" +
                           "".join(f"<th>{inline(c)}</th>" for c in filas[0]) +
                           "</tr></thead><tbody>")
                for f in filas[2:]:
                    out.append("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in f) + "</tr>")
                out.append("</tbody></table>")
            continue

        # Encabezado
        m = re.match(r"(#{1,6})\s+(.*)", ln)
        if m:
            cerrar_lista(); cerrar_cita()
            n = len(m.group(1))
            out.append(f"<h{n}>{inline(m.group(2))}</h{n}>")
            i += 1
            continue

        # Imagen suelta
        m = re.fullmatch(r"!\[(.*?)\]\((.*?)\)", ln.strip())
        if m:
            cerrar_lista(); cerrar_cita()
            out.append(f'<p class="figura"><img src="{m.group(2)}" alt="{m.group(1)}">'
                       f'<span class="pie">{inline(m.group(1))}</span></p>')
            i += 1
            continue

        # Cita
        if ln.strip().startswith("> "):
            cerrar_lista()
            if not bloque_cita:
                out.append("<blockquote>"); bloque_cita = True
            buf = []
            while i < len(lineas) and lineas[i].strip().startswith("> "):
                buf.append(inline(lineas[i].strip()[2:])); i += 1
            out.append("<p>" + "<br>".join(buf) + "</p>")
            cerrar_cita()
            continue

        # Listas. Un ítem puede ocupar varias líneas: hay que seguir consumiendo
        # las líneas de continuación antes de cerrar el <li>, o cada renglón se
        # convierte en una lista nueva que vuelve a numerar desde 1.
        if RE_OL.match(ln) or RE_UL.match(ln):
            cerrar_cita()
            actual = "ol" if RE_OL.match(ln) else "ul"
            if lista_abierta != actual:
                cerrar_lista()
                out.append(f"<{actual}>"); lista_abierta = actual
            buf = [RE_LISTA.sub("", ln).strip()]
            i += 1
            while i < len(lineas) and lineas[i].strip() and not re.match(
                    r"^(#{1,6}\s|\||>|```|-{3,}$)", lineas[i]) \
                    and not RE_OL.match(lineas[i]) and not RE_UL.match(lineas[i]):
                buf.append(lineas[i].strip()); i += 1
            out.append(f"<li>{inline(' '.join(buf))}</li>")
            continue

        # Línea en blanco: NO cierra la lista. En markdown una línea en blanco
        # entre ítems no corta la lista; cerrarla ahí reiniciaría la numeración
        # y todos los ítems saldrían como "1.". La lista se cierra recién cuando
        # aparece contenido que no es de lista.
        if not ln.strip():
            i += 1
            continue

        cerrar_lista(); cerrar_cita()

        # Línea horizontal
        if re.fullmatch(r"-{3,}", ln.strip()):
            out.append("<hr>"); i += 1; continue

        # Párrafo
        buf = [ln.strip()]
        i += 1
        while i < len(lineas) and lineas[i].strip() and not re.match(
                r"^(#{1,6}\s|\||>|```|-{3,}$)", lineas[i]) \
                and not RE_OL.match(lineas[i]) and not RE_UL.match(lineas[i]):
            buf.append(lineas[i].strip()); i += 1
        out.append(f"<p>{inline(' '.join(buf))}</p>")

    cerrar_lista(); cerrar_cita()
    return "\n".join(out)


CSS = """
@page {
  size: A4;
  margin: 14mm 16mm 16mm 16mm;
  @bottom-center { content: counter(page) " / " counter(pages);
               font: 8pt sans-serif; color: #888; }
}
body { font-family: "DejaVu Sans", sans-serif; font-size: 9.5pt;
       line-height: 1.5; color: #1a1a1a; }
h1 { font-size: 19pt; border-bottom: 2px solid #2c3e50; padding-bottom: 6pt;
     margin: 0 0 12pt; break-after: avoid; }
h2 { font-size: 13.5pt; color: #1f3a5f; border-bottom: 1px solid #ccd;
     padding-bottom: 3pt; margin: 20pt 0 8pt; break-before: page; break-after: avoid; }
h3 { font-size: 11pt; color: #2c3e50; margin: 13pt 0 5pt; break-after: avoid; }
h2:first-of-type { break-before: auto; }
p { margin: 5pt 0; text-align: justify; hyphens: auto; }
ul, ol { margin: 5pt 0 5pt 16pt; padding: 0; }
li { margin: 3pt 0; }
code { font-family: "DejaVu Sans Mono", monospace; font-size: 8.5pt;
       background: #f0f2f5; padding: 0.5pt 3pt; border-radius: 2pt; }
pre { background: #f7f8fa; border: 1px solid #dfe3e8; border-left: 3px solid #4a7ebb;
      border-radius: 3pt; padding: 7pt 9pt; margin: 7pt 0; break-inside: auto;
      orphans: 4; widows: 4;
      font-size: 7.6pt; line-height: 1.35; }
pre code { background: none; padding: 0; font-size: 7.6pt;
           white-space: pre-wrap; word-wrap: break-word; }
table { border-collapse: collapse; width: 100%; margin: 9pt 0; font-size: 8.5pt;
        break-inside: avoid; }
th { background: #eaf0f7; border: 1px solid #c5d0dd; padding: 4pt 6pt;
     text-align: left; }
td { border: 1px solid #d8dee6; padding: 4pt 6pt; vertical-align: top; }
tr:nth-child(even) td { background: #fafbfc; }
blockquote { border-left: 3px solid #f0ad4e; background: #fffaf0;
             margin: 9pt 0; padding: 6pt 11pt; break-inside: avoid; }
blockquote p { margin: 3pt 0; text-align: left; }
img { max-width: 100%; }
p.figura { text-align: center; margin: 9pt 0; break-inside: avoid; }
p.figura img { border: 1px solid #d8dee6; border-radius: 3pt;
               max-width: 100%; max-height: 232mm; width: auto; height: auto; }
p.figura .pie { display: block; font-size: 8pt; color: #666; margin-top: 3pt; }
a { color: #1f3a5f; }
hr { border: none; border-top: 1px solid #ddd; margin: 10pt 0; }
strong { color: #111; }
"""

def a_html(md):
    """Convierte markdown a un documento HTML completo con el CSS de impresion."""
    cuerpo = convertir(md)
    return ('<!DOCTYPE html><html lang="es"><head><meta charset="utf-8">'
            f"<title>Informe</title><style>{CSS}</style></head>"
            f"<body>{cuerpo}</body></html>")


def main():
    md = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
    salida = pathlib.Path(sys.argv[2])
    doc = a_html(md)
    salida.write_text(doc, encoding="utf-8")
    print(f"{salida}: {len(doc.splitlines())} lineas de HTML")


if __name__ == "__main__":
    main()
