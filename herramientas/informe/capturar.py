#!/usr/bin/env python3
"""Captura la salida de consola y la figura de un script de Octave.

Ejecuta el script DOS veces a proposito:

  1. Una pasada SIN dibujar, para capturar la salida de consola. gnuplot vuelca
     el plot ASCII a stdout, asi que si se dibujara en la misma pasada el
     grafico terminaria mezclado entre los resultados de la corrida.
  2. Una pasada CON print, descartando stdout, solo para generar el PNG.

Usa -dpngcairo en vez de -dpng: el terminal `png` de gnuplot no interpreta
UTF-8 y los acentos de los titulos salen como "EvaluaciÃ³n".

Uso:
  capturar.py <script.m> <salida_base> [--entradas "0.5,0.001"] [--titulo TXT]
              [--ancho 1000] [--alto 700] [--drop-desde MARCADOR]
              [--drop-bloque MARCADOR N]
"""
import argparse
import subprocess
import sys
import pathlib

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))


def quitar_aviso_gnuplot(texto):
    """Saca el bloque de warning de gnuplot, que va del anuncio a la recomendacion.

    Importante: NO se puede concatenar stderr tal cual. El bloque arranca con
    "warning: using the gnuplot graphics toolkit..." y termina en "...qt toolkit
    instead". Si queda en medio del texto, el filtro por bloque del renderizador
    corta desde ahi hasta el final y se lleva casi todo el stdout.
    """
    lineas = texto.splitlines()
    inicio = next((i for i, ln in enumerate(lineas)
                   if "gnuplot graphics toolkit" in ln), None)
    if inicio is None:
        return "\n".join(lineas)
    fin = next((i for i in range(inicio, len(lineas))
                if "qt toolkit instead" in lineas[i]), None)
    del lineas[inicio:(fin + 1) if fin is not None else inicio + 1]
    return "\n".join(lineas)


def correr(script, entradas, evaluar=""):
    """Corre el script con Octave y devuelve stdout limpio + stderr relevante.

    Se fuerza cwd = carpeta del script porque Octave resuelve las FUNCIONES
    (tanteo, intervalo_medio, ...) por el directorio actual y no por la
    ubicacion del script. Sin esto, invocar la herramienta desde la raiz del
    repo hace que el script aborte con "tanteo undefined".
    """
    cmd = ["octave-cli", "--no-window-system", "--eval", evaluar + f"source('{script}');"]
    proc = subprocess.run(cmd, input=entradas, capture_output=True,
                          text=True, timeout=300, cwd=str(pathlib.Path(script).parent))
    limpio = quitar_aviso_gnuplot(proc.stderr).strip()
    salida = quitar_aviso_gnuplot(proc.stdout)
    if limpio:
        salida += "\n" + limpio
    return salida


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("script")
    ap.add_argument("salida_base")
    ap.add_argument("--entradas", default="",
                    help="valores separados por coma, uno por cada input del script")
    ap.add_argument("--titulo", default="")
    ap.add_argument("--ancho", type=int, default=1000)
    ap.add_argument("--alto", type=int, default=700)
    ap.add_argument("--drop-desde", action="append", default=[],
                    help="descartar desde esta linea hasta el final")
    ap.add_argument("--drop-bloque", action="append", nargs=2, default=[],
                    metavar=("MARCADOR", "N"),
                    help="descartar MARCADOR y las N lineas siguientes")
    args = ap.parse_args()

    script = pathlib.Path(args.script)
    base = pathlib.Path(args.salida_base)
    base.parent.mkdir(parents=True, exist_ok=True)
    # Cada valor de "entradas" es una linea: input() de Octave lee linea a linea.
    lineas_entrada = [x.strip() for x in args.entradas.split(",") if x.strip()]
    entradas = ("\n".join(lineas_entrada) + "\n") if lineas_entrada else ""

    # Pasada 1: consola, sin dibujar.
    texto = correr(script, entradas)

    # Pasada 2: figura, descartando stdout.
    evaluar = (f"graphics_toolkit('gnuplot'); source('{script}'); "
               f"print(gcf, '-dpngcairo', '-S{args.ancho},{args.alto}', "
               f"'{base}-grafico.png');")
    try:
        subprocess.run(["octave-cli", "--no-window-system", "--eval", evaluar],
                       input=entradas, capture_output=True, text=True, timeout=300,
                       cwd=str(script.parent))
    except subprocess.TimeoutExpired:
        print(f"  AVISO: timeout dibujando {script}", file=sys.stderr)

    if not pathlib.Path(f"{base}-grafico.png").exists():
        print(f"  AVISO: no se genero {base}-grafico.png", file=sys.stderr)

    # Render de la consola a PNG.
    tmp = base.with_suffix(".consola.txt")
    tmp.write_text(texto, encoding="utf-8")

    from render_consola import main as render_main
    argv = ["render_consola", str(tmp), f"{base}-consola.png",
            args.titulo or script.stem]
    for d in args.drop_desde:
        argv += ["--drop-desde", d]
    for m, n in args.drop_bloque:
        argv += ["--drop-bloque", m, n]
    sys.argv = argv
    render_main()

    tmp.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
