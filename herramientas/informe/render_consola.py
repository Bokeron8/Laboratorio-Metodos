#!/usr/bin/env python3
"""Renderiza la salida de consola de Octave a una imagen PNG estilo terminal.

La imagen debe mostrar SOLO resultados de ejecución: se eliminan los avisos del
entorno (gnuplot sin display), los artefactos de render de ejes que gnuplot
escribe en stdout, y las secciones de prosa que en el informe se explican aparte.

Uso:
  render_consola.py <entrada.txt> <salida.png> <titulo> [--drop-desde MARCADOR]... [--drop-bloque MARCADOR N]...
"""
import argparse
import re
from PIL import Image, ImageDraw, ImageFont

# Paleta estilo terminal oscuro
BG = (24, 26, 32)
FG = (208, 212, 220)
DIM = (110, 116, 128)
CYAN = (86, 182, 194)
GREEN = (126, 199, 122)
YELLOW = (229, 192, 123)
MAGENTA = (198, 120, 221)
BORDER = (48, 52, 62)

FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"
FONT_BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"

# Artefactos de gnuplot: ejes dibujados con +, | y - que se cuelan en stdout.
RE_ARTEFACTO = re.compile(r"^[\s|+]*-[\s|+]*-[|+]{2,}")
RE_AVISO = re.compile(r"gnuplot|window system|fontconfig|qt toolkit", re.I)


def es_artefacto(linea):
    """True si la línea es un eje/leyenda dibujado por gnuplot, no salida real."""
    if RE_ARTEFACTO.match(linea):
        return True
    # Bloque de warning de gnuplot ("warning: using the gnuplot..." + continuación)
    if RE_AVISO.search(linea):
        return True
    # Líneas de prosa del aviso, que no contienen el keyword.
    if re.match(r"^\s*(uses a one-directional|will not be reflected|example, if the plot"
                r"|not be notified|We recommend using)", linea):
        return True
    return False


def limpiar(texto, drop_desde, drop_bloque):
    # 0. Borrado por bloque del aviso de gnuplot: va desde la línea que menciona
    #    el toolkit hasta la que recomienda usar el qt. Es más preciso que
    #    filtrar línea por línea, porque el texto del aviso no lleva keywords.
    lineas = texto.splitlines()
    inicio = next((i for i, ln in enumerate(lineas) if "gnuplot graphics toolkit" in ln), None)
    if inicio is not None:
        fin = next((i for i in range(inicio, len(lineas)) if "qt toolkit instead" in lineas[i]), None)
        del lineas[inicio:(fin + 1) if fin is not None else inicio + 1]

    # 1. Quitar bloques de prosa indicados por marcador.
    salida, i = [], 0
    while i < len(lineas):
        ln = lineas[i]
        if any(ln.strip().startswith(m) for m in drop_desde):
            break  # desde acá hasta el final va al informe
        if any(m in ln for m, _ in drop_bloque):
            # La línea del marcador más las N siguientes son prosa que va al informe.
            n = next(n for m, n in drop_bloque if m in ln)
            i += 1 + n
            continue
        salida.append(ln.rstrip())
        i += 1

    # 2. Quitar artefactos de render y avisos del entorno.
    salida = [ln for ln in salida if not es_artefacto(ln)]

    # 3. Colapsar renglones en blanco de más ytrimar.
    limpio = []
    for ln in salida:
        if not ln.strip() and limpio and not limpio[-1].strip():
            continue
        limpio.append(ln.rstrip())
    while limpio and not limpio[0].strip():
        limpio.pop(0)
    while limpio and not limpio[-1].strip():
        limpio.pop()
    return limpio


def cargar(path, size):
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


def clasificar(linea):
    """Devuelve (color, negrita) según el tipo de línea."""
    s = linea.strip()
    if not s:
        return DIM, False
    if re.match(r"^[=]{3,}", s) or re.match(r"^-{3,}", s):
        return CYAN, True
    if s.startswith(">>>") or "Raíz separada" in s:
        return GREEN, False
    if re.search(r"(Raíz aproximada|Raiz aproximada|punto de equilibrio|Cantidad de|"
                 r"Iteraciones:|iteraciones =|Diferencia entre|Tiempo de ejecución|"
                 r"-> |Se detect)", s):
        return GREEN, False
    if re.match(r"^(Ingrese|Seleccione|\¿Desea|Opci)", s):
        return YELLOW, False
    if re.search(r"(Ojo con|atención|CUIDADO|no converg|DIVERGE|Supera|supera|"
                 r"pero cae|imposible)", s):
        return YELLOW, False
    if re.match(r"^([-\d\[])", s) and len(s) < 120:
        return FG, False
    return FG, False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("entrada")
    ap.add_argument("salida")
    ap.add_argument("titulo")
    ap.add_argument("--drop-desde", action="append", default=[])
    ap.add_argument("--drop-bloque", action="append", nargs=2, default=[],
                    metavar=("MARCADOR", "N"))
    args = ap.parse_args()

    with open(args.entrada, encoding="utf-8", errors="replace") as fh:
        crudo = fh.read()

    drop_bloque = [(m, int(n)) for m, n in args.drop_bloque]
    lineas = limpiar(crudo, args.drop_desde, drop_bloque)

    font = cargar(FONT_PATH, 15)
    font_bold = cargar(FONT_BOLD, 15)
    font_titulo = cargar(FONT_BOLD, 17)

    tmp = Image.new("RGB", (10, 10))
    d_tmp = ImageDraw.Draw(tmp)

    pad, lh = 22, 22
    ancho_max = max((int(d_tmp.textlength(ln, font=font)) for ln in lineas), default=600)
    alto_titulo = (font_titulo.size + 14) if args.titulo else 0

    ancho = min(max(ancho_max + pad * 2, 700), 1500)
    alto = pad * 2 + alto_titulo + lh * len(lineas)

    img = Image.new("RGB", (ancho, alto), BG)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, ancho - 1, alto - 1], outline=BORDER, width=1)

    y = pad
    if args.titulo:
        d.text((pad, y), args.titulo, font=font_titulo, fill=CYAN)
        y += alto_titulo
        d.line([pad, y - 6, ancho - pad, y - 6], fill=BORDER, width=1)

    for ln in lineas:
        color, bold = clasificar(ln)
        d.text((pad, y), ln, font=font_bold if bold else font, fill=color)
        y += lh

    img.save(args.salida, "PNG", optimize=True)
    print(f"{args.salida}: {ancho}x{alto}, {len(lineas)} lineas")


if __name__ == "__main__":
    main()
