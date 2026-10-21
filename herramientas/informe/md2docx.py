#!/usr/bin/env python3
"""Convierte markdown a .docx con el formato del informe del TP evaluativo.

Formato fijado (pautas de entrega):
  - A4, márgenes 3 cm superior y 2,5 cm izquierdo, derecho e inferior.
  - Texto Arial 11 ptos justificado, interlineado 1,5, espaciado anterior 3 ptos.
  - Títulos Arial 14 ptos.
  - Carátula en página propia, índice e índice de figuras como campos automáticos.

Markdown soportado: `#` a `###`, párrafos, listas con `-` y `1.`, tablas con
alineación por `:---`, bloques ``` (monoespaciado), imágenes `![pie](ruta)`,
citas `>`, y `---` como salto de página.

Marcadores resueltos antes de convertir:
  {{CODE:archivo.m}}        -> bloque de código con el contenido del archivo
  {{IMG:ruta.png|Epígrafe}} -> figura con epígrafe numerado
  {{INCLUIR:archivo.md}}    -> el markdown del archivo, tal cual

Uso:
  md2docx.py <entrada.md> <salida.docx> [config.json]
"""
import json
import pathlib
import re
import sys

from docx import Document
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.text import (WD_ALIGN_PARAGRAPH, WD_BREAK, WD_TAB_ALIGNMENT,
                            WD_TAB_LEADER)
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor

HERE = pathlib.Path(__file__).resolve().parent

ARIAL = "Arial"
MONO = "Courier New"
ANCHO_UTIL = Cm(16)  # 21 cm de hoja - 2,5 - 2,5 de márgenes

RE_OL = re.compile(r"^\s*\d+\.\s+")
RE_UL = re.compile(r"^\s*[-*]\s+")
RE_LISTA = re.compile(r"^\s*(\d+\.|[-*])\s+")
RE_INLINE = re.compile(r"(\*\*[^*]+\*\*|\*[^*\n]+\*|`[^`]+`)")


# ---------------------------------------------------------------- utilidades


def _fuente(objeto, nombre=ARIAL, tam=None, bold=None, italic=None):
    """Fija la familia tipográfica en las cuatro variantes de rFonts.

    Sin tocar w:rFonts ascii/hAnsi/cs/eastAsia, Word ignora el nombre en las
    corridas con caracteres no latinos y en algunos estilos heredados.
    """
    objeto.font.name = nombre
    if tam is not None:
        objeto.font.size = Pt(tam)
    if bold is not None:
        objeto.font.bold = bold
    if italic is not None:
        objeto.font.italic = italic
    rpr = objeto.element.get_or_add_rPr()
    rfonts = rpr.find(qn("w:rFonts"))
    if rfonts is None:
        rfonts = OxmlElement("w:rFonts")
        rpr.append(rfonts)
    for attr in ("w:ascii", "w:hAnsi", "w:cs", "w:eastAsia"):
        rfonts.set(qn(attr), nombre)


def _campo(parrafo, instruccion, texto=""):
    """Inserta un campo de Word (TOC, PAGE, SEQ) que se calcula al actualizar."""
    for tipo in ("begin", "separate", "end"):
        run = parrafo.add_run()
        if tipo == "begin":
            fld = OxmlElement("w:fldChar")
            fld.set(qn("w:fldCharType"), "begin")
            fld.set(qn("w:dirty"), "true")
            run._r.append(fld)
        elif tipo == "separate":
            fld = OxmlElement("w:fldChar")
            fld.set(qn("w:fldCharType"), "separate")
            run._r.append(fld)
            if texto:
                run.add_text(texto)
        else:
            fld = OxmlElement("w:fldChar")
            fld.set(qn("w:fldCharType"), "end")
            run._r.append(fld)
    # La instrucción va entre begin y separate, dentro de su propio run:
    # fuera de w:r el campo es XML inválido y Word/LibreOffice lo ignoran,
    # dejando el resultado cacheado para siempre.
    instr = OxmlElement("w:instrText")
    instr.set(qn("xml:space"), "preserve")
    instr.text = f" {instruccion} "
    run_instr = OxmlElement("w:r")
    run_instr.append(instr)
    runs = parrafo.runs
    runs[-2]._r.addprevious(run_instr)


def _campo_inicio(parrafo, instruccion):
    """Abre un campo de varios párrafos: begin + instrucción + separate."""
    run = parrafo.add_run()
    fld = OxmlElement("w:fldChar")
    fld.set(qn("w:fldCharType"), "begin")
    fld.set(qn("w:dirty"), "true")
    run._r.append(fld)

    instr = OxmlElement("w:instrText")
    instr.set(qn("xml:space"), "preserve")
    instr.text = f" {instruccion} "
    run_instr = OxmlElement("w:r")
    run_instr.append(instr)
    run._r.addnext(run_instr)

    run_sep = parrafo.add_run()
    fld = OxmlElement("w:fldChar")
    fld.set(qn("w:fldCharType"), "separate")
    run_sep._r.append(fld)


def _campo_fin(parrafo):
    """Cierra un campo de varios párrafos."""
    run = parrafo.add_run()
    fld = OxmlElement("w:fldChar")
    fld.set(qn("w:fldCharType"), "end")
    run._r.append(fld)


def _indice(doc, instruccion, entradas):
    """Índice como campo real cuyas entradas ya vienen paginadas.

    El resultado cacheado del campo son las entradas con su número de página,
    así el documento se lee bien sin que el lector tenga que actualizar campos;
    el campo sigue siendo válido si igual quiere hacerlo.
    """
    inicio = doc.add_paragraph()
    inicio.paragraph_format.space_before = Pt(0)
    _campo_inicio(inicio, instruccion)

    for nivel, texto, pagina in entradas:
        e = doc.add_paragraph()
        pf = e.paragraph_format
        pf.alignment = WD_ALIGN_PARAGRAPH.LEFT
        pf.line_spacing = 1.0
        pf.space_before = Pt(0)
        pf.left_indent = Cm(0.6 * (nivel - 1))
        pf.tab_stops.add_tab_stop(ANCHO_UTIL, WD_TAB_ALIGNMENT.RIGHT,
                                  WD_TAB_LEADER.DOTS)
        e.add_run(texto)
        e.add_run("\t")
        e.add_run("" if pagina is None else str(pagina))

    fin = doc.add_paragraph()
    fin.paragraph_format.space_before = Pt(0)
    _campo_fin(fin)


def _campo_simple(parrafo, instruccion, texto=""):
    """Campo simple (w:fldSimple), el que usa Word para los SEQ de epígrafes."""
    fld = OxmlElement("w:fldSimple")
    fld.set(qn("w:instr"), instruccion)
    run = OxmlElement("w:r")
    t = OxmlElement("w:t")
    t.text = texto
    run.append(t)
    fld.append(run)
    parrafo._p.append(fld)


def _sombreado(parrafo, relleno="F4F5F7"):
    ppr = parrafo._p.get_or_add_pPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:fill"), relleno)
    ppr.append(shd)


def _borde(parrafo, color="D8DEE6", tam=6):
    ppr = parrafo._p.get_or_add_pPr()
    pbdr = OxmlElement("w:pBdr")
    for lado in ("top", "left", "bottom", "right"):
        el = OxmlElement(f"w:{lado}")
        el.set(qn("w:val"), "single")
        el.set(qn("w:sz"), str(tam))
        el.set(qn("w:space"), "4")
        el.set(qn("w:color"), color)
        pbdr.append(el)
    ppr.append(pbdr)


def _borde_inferior(style):
    """Línea inferior en un estilo de párrafo: separa los títulos de nivel 1."""
    ppr = style.element.get_or_add_pPr()
    pbdr = OxmlElement("w:pBdr")
    el = OxmlElement("w:bottom")
    el.set(qn("w:val"), "single")
    el.set(qn("w:sz"), "8")
    el.set(qn("w:space"), "4")
    el.set(qn("w:color"), "808080")
    pbdr.append(el)
    ppr.append(pbdr)


def _resolver(ruta, base_dir):
    """Busca la ruta en la carpeta del informe, su padre y la de la herramienta.

    El padre está en la lista porque el markdown de un informe vive en su propia
    carpeta y cita el código fuente que está un nivel arriba.
    """
    p = pathlib.Path(ruta)
    if p.is_absolute() and p.exists():
        return p
    base = pathlib.Path(base_dir)
    for raiz in (base, base.parent, HERE, pathlib.Path.cwd()):
        cand = raiz / ruta
        if cand.exists():
            return cand
    return None


# ------------------------------------------------------------ estilo del doc


def configurar_documento(doc):
    s = doc.sections[0]
    s.page_width = Cm(21)
    s.page_height = Cm(29.7)
    s.top_margin = Cm(3)
    s.bottom_margin = Cm(2.5)
    s.left_margin = Cm(2.5)
    s.right_margin = Cm(2.5)

    normal = doc.styles["Normal"]
    _fuente(normal, ARIAL, 11)
    pf = normal.paragraph_format
    pf.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    pf.line_spacing = 1.5
    pf.space_before = Pt(3)
    pf.space_after = Pt(0)

    for nombre, bold, italic in (
        ("Heading 1", True, False),
        ("Heading 2", True, False),
        ("Heading 3", True, True),
    ):
        st = doc.styles[nombre]
        _fuente(st, ARIAL, 14, bold=bold, italic=italic)
        st.font.color.rgb = RGBColor(0, 0, 0)
        pf = st.paragraph_format
        pf.space_before = Pt(12)
        pf.space_after = Pt(6)
        pf.line_spacing = 1.5
        pf.keep_with_next = True
        pf.alignment = WD_ALIGN_PARAGRAPH.LEFT

    _borde_inferior(doc.styles["Heading 1"])
    _borde_inferior(doc.styles["Heading 2"])

    if "Codigo" not in [x.name for x in doc.styles]:
        cod = doc.styles.add_style("Codigo", WD_STYLE_TYPE.PARAGRAPH)
    else:
        cod = doc.styles["Codigo"]
    cod.base_style = doc.styles["Normal"]
    _fuente(cod, MONO, 8.5)
    pf = cod.paragraph_format
    pf.alignment = WD_ALIGN_PARAGRAPH.LEFT
    pf.line_spacing = 1.0
    pf.space_before = Pt(0)
    pf.space_after = Pt(0)
    pf.left_indent = Cm(0.3)

    cap = doc.styles["Caption"]
    _fuente(cap, ARIAL, 10, bold=False, italic=True)
    cap.font.color.rgb = RGBColor(0x44, 0x44, 0x44)
    cap.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    cap.paragraph_format.space_before = Pt(3)
    cap.paragraph_format.line_spacing = 1.0

    _pie_de_pagina(doc)
    # Word actualiza índices y numeración al abrir el documento.
    upd = OxmlElement("w:updateFields")
    upd.set(qn("w:val"), "true")
    doc.settings.element.append(upd)
    return doc


def _pie_de_pagina(doc):
    pie = doc.sections[0].footer.paragraphs[0]
    pie.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = pie.add_run("Página ")
    _fuente(run, ARIAL, 9)
    _campo(pie, "PAGE", "1")
    run = pie.add_run(" de ")
    _fuente(run, ARIAL, 9)
    _campo(pie, "NUMPAGES", "1")
    for r in pie.runs:
        _fuente(r, ARIAL, 9)


# ------------------------------------------------------------------ carátula


def caratula(doc, cfg, base_dir):
    c = cfg.get("caratula", {})

    if c.get("logo"):
        logo = _resolver(c["logo"], base_dir)
        if logo:
            doc.add_picture(str(logo), width=Cm(3.6))
            doc.paragraphs[-1].alignment = WD_ALIGN_PARAGRAPH.CENTER
            doc.paragraphs[-1].paragraph_format.space_before = Pt(0)

    def linea(texto, tam, bold=False, italic=False, antes=0, despues=0):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_before = Pt(antes)
        p.paragraph_format.space_after = Pt(despues)
        p.paragraph_format.line_spacing = 1.15
        run = p.add_run(texto)
        _fuente(run, ARIAL, tam, bold=bold, italic=italic)
        return p

    linea(c.get("universidad", ""), 13, bold=True, antes=10)
    linea(c.get("facultad", ""), 12, bold=True)
    linea(c.get("asignatura", ""), 12)
    for tema in c.get("temas", []):
        linea(tema, 11)
    linea("", 11, antes=30)
    linea(c.get("titulo", ""), 14, bold=True, antes=18)
    linea("", 11, antes=40)

    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(12)
    run = p.add_run("Integrantes")
    _fuente(run, ARIAL, 12, bold=True)
    for quien in c.get("integrantes", []):
        linea(quien, 11)

    for clave in ("comision", "anio"):
        if c.get(clave):
            linea(c[clave], 11, antes=14 if clave == "comision" else 1)

    doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)


# ------------------------------------------------------------------ bloques


def _inline(parrafo, texto, tam=None):
    """Agrega texto con **negrita**, *cursiva* y `código` a un párrafo."""
    texto = texto.replace("\\|", "|")
    for trozo in RE_INLINE.split(texto):
        if not trozo:
            continue
        if trozo.startswith("**") and trozo.endswith("**"):
            run = parrafo.add_run(trozo[2:-2])
            _fuente(run, ARIAL, tam, bold=True)
        elif trozo.startswith("*") and trozo.endswith("*") and len(trozo) > 2:
            run = parrafo.add_run(trozo[1:-1])
            _fuente(run, ARIAL, tam, italic=True)
        elif trozo.startswith("`") and trozo.endswith("`"):
            run = parrafo.add_run(trozo[1:-1])
            _fuente(run, MONO, (tam or 11) - 1.5)
        else:
            run = parrafo.add_run(trozo)
            _fuente(run, ARIAL, tam)


def _sin_corte_de_palabra(parrafo):
    """Prohíbe el corte a nivel de carácter: sin esto, "Tolerancia" se parte."""
    ppr = parrafo._p.get_or_add_pPr()
    wrap = OxmlElement("w:wordWrap")
    wrap.set(qn("w:val"), "false")
    ppr.append(wrap)


def _celdas(linea):
    """Separa una fila de tabla por pipes no escapados.

    Un pipe escapado (`\\|`) es parte del contenido, no un separador: sin esto,
    una condición como `|g'(x0)| < 1` se parte en tres celdas.
    """
    cuerpo = linea.strip()
    if cuerpo.startswith("|"):
        cuerpo = cuerpo[1:]
    if cuerpo.endswith("|") and not cuerpo.endswith("\\|"):
        cuerpo = cuerpo[:-1]
    return [c.strip().replace("\\|", "|") for c in re.split(r"(?<!\\)\|", cuerpo)]


MARGEN_CELDA_CM = 0.19  # margen interno por lado que usan Word y LibreOffice
FUENTES = {
    False: "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    True: "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
}


def _ancho_palabra_cm(palabra, tam=11, negrita=False):
    """Ancho real de una palabra en Arial 11.

    Liberation Sans es métricamente compatible con Arial, así que medir con ella
    reproduce el ancho que usa Word. Sin Pillow o sin la fuente, se estima con
    el ancho medio de una letra.
    """
    try:
        from PIL import ImageFont
        fuente = ImageFont.truetype(FUENTES[negrita], tam * 96 / 72)
        caja = fuente.getbbox(palabra)
        return (caja[2] - caja[0]) / 96 * 2.54
    except (ImportError, OSError):
        return 0.23 * len(palabra) * (1.05 if negrita else 1.0)


def _anchos_de_columna(datos, total_cm=16.0):
    """Reparte el ancho útil según el contenido.

    Con anchos fijos iguales, "convergencia" y "Evaluaciones" se partían a mitad
    de palabra, y con una estimación por cantidad de letras "Tiempo" quedaba
    apenas por debajo de su ancho real ("Tiemp/o"). El mínimo de cada columna es
    el ancho medido de su palabra más larga más los márgenes de celda; el resto
    se reparte según el texto más largo de la columna.
    """
    columnas = list(zip(*datos))
    minimos, pesos = [], []
    for j, celdas in enumerate(columnas):
        ancho_max = 0.0
        for i, celda in enumerate(celdas):
            for palabra in re.sub(r"[*`]|\\\|", "", celda).split():
                # Los encabezados van en negrita: ocupan un poco más.
                ancho_max = max(ancho_max, _ancho_palabra_cm(
                    palabra, negrita=(i == 0)))
        minimos.append(ancho_max + 2 * MARGEN_CELDA_CM)
        pesos.append(max((len(re.sub(r"[*`]", "", c)) for c in celdas), default=1))

    suma = sum(minimos)
    if suma >= total_cm:
        return [total_cm * m / suma for m in minimos]
    resto = total_cm - suma
    total_peso = sum(pesos) or 1
    return [m + resto * p / total_peso for m, p in zip(minimos, pesos)]


def _tabla(doc, filas):
    alinear = []
    datos = list(filas)
    if len(filas) >= 2 and all(re.fullmatch(r":?-{2,}:?", c) for c in filas[1]):
        alinear = filas[1]
        datos = [f for i, f in enumerate(filas) if i != 1]

    t = doc.add_table(rows=len(datos), cols=len(datos[0]))
    t.style = "Table Grid"
    t.autofit = False
    anchos = [Cm(a) for a in _anchos_de_columna(datos)]
    for j, columna in enumerate(t.columns):
        ancho = anchos[j] if j < len(anchos) else Cm(16 / len(datos[0]))
        columna.width = ancho  # actualiza w:gridCol
        for celda in columna.cells:
            celda.width = ancho  # actualiza w:tcW

    for i, fila in enumerate(datos):
        for j, celda in enumerate(fila[: len(datos[0])]):
            par = t.cell(i, j).paragraphs[0]
            par.paragraph_format.line_spacing = 1.0
            par.paragraph_format.space_before = Pt(1)
            par.paragraph_format.space_after = Pt(1)
            par.paragraph_format.keep_with_next = i < len(datos) - 1
            _sin_corte_de_palabra(par)
            if i == 0:
                par.alignment = WD_ALIGN_PARAGRAPH.CENTER
                _inline(par, f"**{celda}**")
            else:
                marca = alinear[j] if j < len(alinear) else ""
                if marca.endswith(":") and marca.startswith(":"):
                    par.alignment = WD_ALIGN_PARAGRAPH.CENTER
                elif marca.endswith(":"):
                    par.alignment = WD_ALIGN_PARAGRAPH.RIGHT
                else:
                    par.alignment = WD_ALIGN_PARAGRAPH.LEFT
                _inline(par, celda)

    # Una fila no se corta entre páginas y el encabezado se repite si la tabla
    # igual se parte: sin esto, la última fila queda sola en la página siguiente.
    for i, fila in enumerate(t.rows):
        trpr = fila._tr.get_or_add_trPr()
        trpr.append(OxmlElement("w:cantSplit"))
        if i == 0:
            trpr.append(OxmlElement("w:tblHeader"))

    doc.add_paragraph().paragraph_format.space_before = Pt(3)


def _imagen(doc, ruta, pie, base_dir, numero):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(6)
    p.paragraph_format.keep_with_next = True
    p.add_run().add_picture(str(ruta), width=ANCHO_UTIL)

    cap = doc.add_paragraph(style="Caption")
    run = cap.add_run("Figura ")
    _fuente(run, ARIAL, 10, italic=True)
    _campo_simple(cap, r"SEQ Figura \* ARABIC", str(numero))
    run = cap.add_run(f": {pie}")
    _fuente(run, ARIAL, 10, italic=True)


def _codigo(doc, lineas):
    if not lineas:
        lineas = [""]
    for i, linea in enumerate(lineas):
        p = doc.add_paragraph(style="Codigo")
        _sombreado(p)
        if i == 0:
            _borde(p)
            p.paragraph_format.space_before = Pt(3)
        if i == len(lineas) - 1:
            p.paragraph_format.space_after = Pt(6)
        p.add_run(linea.replace("\t", "    "))
        _fuente(p.runs[-1], MONO, 8.5)


# ---------------------------------------------------------------- conversor


def convertir(md, doc, base_dir):
    lineas = md.split("\n")
    i = 0
    figura = 0

    while i < len(lineas):
        ln = lineas[i]

        if ln.startswith("```"):
            i += 1
            buf = []
            while i < len(lineas) and not lineas[i].startswith("```"):
                buf.append(lineas[i])
                i += 1
            i += 1
            _codigo(doc, buf)
            continue

        if ln.startswith("|"):
            filas = []
            while i < len(lineas) and lineas[i].startswith("|"):
                filas.append(_celdas(lineas[i]))
                i += 1
            _tabla(doc, filas)
            continue

        m = re.match(r"(#{1,6})\s+(.*)", ln)
        if m:
            nivel = min(len(m.group(1)), 3)
            p = doc.add_paragraph(style=f"Heading {nivel}")
            _inline(p, m.group(2), tam=14)
            i += 1
            continue

        m = re.fullmatch(r"!\[(.*?)\]\((.*?)\)", ln.strip())
        if m:
            ruta = _resolver(m.group(2), base_dir)
            if ruta:
                figura += 1
                _imagen(doc, ruta, m.group(1), base_dir, figura)
            else:
                doc.add_paragraph(f"[FALTA IMAGEN: {m.group(2)}]")
            i += 1
            continue

        if re.fullmatch(r"-{3,}", ln.strip()):
            doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)
            i += 1
            continue

        if ln.strip().startswith("> "):
            buf = []
            while i < len(lineas) and lineas[i].strip().startswith("> "):
                buf.append(lineas[i].strip()[2:])
                i += 1
            p = doc.add_paragraph()
            p.paragraph_format.left_indent = Cm(0.8)
            p.paragraph_format.right_indent = Cm(0.5)
            _inline(p, " ".join(buf))
            for run in p.runs:
                run.font.italic = True
            continue

        if RE_OL.match(ln) or RE_UL.match(ln):
            estilo = "List Number" if RE_OL.match(ln) else "List Bullet"
            while i < len(lineas) and (RE_OL.match(lineas[i]) or RE_UL.match(lineas[i])):
                texto = RE_LISTA.sub("", lineas[i]).strip()
                i += 1
                while i < len(lineas) and lineas[i].strip() and not re.match(
                        r"^(#{1,6}\s|\||>|```|-{3,}$)", lineas[i]) \
                        and not RE_OL.match(lineas[i]) and not RE_UL.match(lineas[i]):
                    texto += " " + lineas[i].strip()
                    i += 1
                p = doc.add_paragraph(style=estilo)
                p.paragraph_format.line_spacing = 1.5
                p.paragraph_format.space_before = Pt(3)
                _inline(p, texto)
            continue

        if not ln.strip():
            i += 1
            continue

        buf = [ln.strip()]
        i += 1
        while i < len(lineas) and lineas[i].strip() and not re.match(
                r"^(#{1,6}\s|\||>|```|-{3,}$)", lineas[i]) \
                and not RE_OL.match(lineas[i]) and not RE_UL.match(lineas[i]) \
                and not re.fullmatch(r"!\[.*?\]\(.*?\)", lineas[i].strip()):
            buf.append(lineas[i].strip())
            i += 1
        p = doc.add_paragraph()
        _inline(p, " ".join(buf))


# ----------------------------------------------------------------- marcadores


def resolver_marcadores(md, base_dir):
    def code(m):
        ruta = _resolver(m.group(1), base_dir)
        if not ruta:
            return f"`[FALTA CÓDIGO: {m.group(1)}]`"
        return "```octave\n" + ruta.read_text(encoding="utf-8").rstrip("\n") + "\n```"

    def img(m):
        return f"![{m.group(2)}]({m.group(1)})"

    def incluir(m):
        ruta = _resolver(m.group(1), base_dir)
        if not ruta:
            return f"`[FALTA ARCHIVO: {m.group(1)}]`"
        return ruta.read_text(encoding="utf-8")

    md = re.sub(r"\{\{CODE:([^}]+)\}\}", code, md)
    md = re.sub(r"\{\{IMG:([^|]+)\|([^}]+)\}\}", img, md)
    md = re.sub(r"\{\{INCLUIR:([^}]+)\}\}", incluir, md)
    return md


# ------------------------------------------------------------------- público


def construir(md, cfg, salida, base_dir=None, indice=None):
    """Genera el .docx completo: carátula, índice, contenido e índice de figuras.

    `indice` es el resultado de `paginar.medir`: si viene, los dos índices se
    escriben con sus entradas y páginas ya cacheadas.
    """
    base_dir = pathlib.Path(base_dir or pathlib.Path.cwd())
    titulos = (indice or {}).get("titulos")
    figuras = (indice or {}).get("figuras")
    doc = Document()
    configurar_documento(doc)
    caratula(doc, cfg, base_dir)

    p = doc.add_paragraph(style="Heading 1")
    p.add_run("Índice")
    p.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    if titulos:
        _indice(doc, r'TOC \o "1-3" \h \z \u', titulos)
    else:
        aviso = doc.add_paragraph()
        _campo(aviso, r'TOC \o "1-3" \h \z \u', "Actualizá el índice con F9.")
    doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)

    p = doc.add_paragraph(style="Heading 1")
    p.add_run("Índice de figuras")
    p.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    if figuras:
        _indice(doc, r'TOC \h \z \c "Figura"', figuras)
    else:
        aviso = doc.add_paragraph()
        _campo(aviso, r'TOC \h \z \c "Figura"', "Actualizá el índice con F9.")
    doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)

    convertir(resolver_marcadores(md, base_dir), doc, base_dir)

    salida = pathlib.Path(salida)
    salida.parent.mkdir(parents=True, exist_ok=True)
    doc.save(str(salida))
    return salida


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    entrada = pathlib.Path(sys.argv[1])
    salida = pathlib.Path(sys.argv[2])
    cfg = json.loads(pathlib.Path(sys.argv[3]).read_text(encoding="utf-8")) \
        if len(sys.argv) > 3 else {}
    ruta = construir(entrada.read_text(encoding="utf-8"), cfg, salida,
                     base_dir=entrada.parent)
    print(f"{ruta}: {ruta.stat().st_size} bytes")


if __name__ == "__main__":
    main()
