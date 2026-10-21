#!/usr/bin/env python3
"""Captura la salida de consola y las figuras de principal.m, sin display.

Por qué hace falta una copia del script:
  principal.m termina con `waitfor(gcf)`. Sin ventana gráfica ese waitfor no
  retorna nunca, así que el capturador se cuelga y no llega a exportar el PNG.
  La solución es correr una copia generada con los `waitfor` removidos y dejar
  principal.m intacto: el informe inyecta el original prístino, sin el parche.

Cada método se corre DOS veces, igual que capturar.py: una pasada sin dibujar
para capturar la consola y otra con gnuplot para exportar las figuras.

Uso:
  capturas.py [--solo pf|newton|aitken]
"""
import argparse
import pathlib
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
TP = HERE.parent
sys.path.insert(0, str(HERE.parent.parent / "herramientas" / "informe"))

from capturar import quitar_aviso_gnuplot  # noqa: E402

EXPR_G = "200 + 40*log(400./(500-x))"
EXPR_F = "5*x - 200*log(400./(500-x)) - 1000"
X0 = "200"
TOL = "0.0001"
RANGO = ("0", "400")

METODOS = {
    "pf": {"opcion": "1", "titulo": "Método de punto fijo", "figuras": 2},
    "newton": {"opcion": "2", "titulo": "Método de Newton-Raphson", "figuras": 1},
    "aitken": {"opcion": "3", "titulo": "Aceleración de Aitken", "figuras": 2},
}


def copia_sin_waitfor():
    """Genera _principal_captura.m a partir de principal.m, sin los waitfor."""
    original = (TP / "principal.m").read_text(encoding="utf-8")
    lineas = [ln for ln in original.splitlines() if "waitfor(" not in ln]
    if len(lineas) == len(original.splitlines()):
        raise SystemExit("principal.m no tiene waitfor: revisá si el script cambió")
    destino = TP / "_principal_captura.m"
    destino.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    return destino


def entradas(metodo):
    m = METODOS[metodo]
    lineas = [m["opcion"]]
    if m["opcion"] == "2":
        lineas.append(EXPR_F)
    else:
        lineas += [EXPR_G, EXPR_F]
    lineas += ["n", X0, TOL, *RANGO]
    return "\n".join(lineas) + "\n"


def correr(script, texto_entrada, evaluar=""):
    cmd = ["octave-cli", "--no-window-system", "--eval", evaluar + f"source('{script.name}');"]
    proc = subprocess.run(cmd, input=texto_entrada, capture_output=True, text=True,
                          timeout=120, cwd=str(script.parent))
    salida = quitar_aviso_gnuplot(proc.stdout)
    limpio = quitar_aviso_gnuplot(proc.stderr).strip()
    if limpio:
        salida += "\n" + limpio
    return salida


def exportar_figuras(script, texto_entrada, base, cuantas):
    lineas = [
        "graphics_toolkit('gnuplot');",
        f"source('{script.name}');",
        "hs = sort(findobj('type','figure'));",
        f"if numel(hs) < {cuantas}",
        f"  error('se esperaban {cuantas} figuras y hay %d', numel(hs));",
        "end",
        "for k = 1:numel(hs)",
        "  print(hs(k), '-dpngcairo', sprintf('-S1150,700', k),"
        f" sprintf('{base}-grafico%d.png', k));",
        "end",
    ]
    subprocess.run(["octave-cli", "--no-window-system", "--eval", "\n".join(lineas)],
                   input=texto_entrada, capture_output=True, text=True,
                   timeout=120, cwd=str(script.parent))


def recortar(texto):
    """Deja solo el análisis, la tabla y el resultado.

    La pasada 1 también ejecuta los fplot, así que gnuplot vuelca el gráfico
    ASCII a stdout y los prompts de input() quedan concatenados en una línea.
    Nada de eso es "resultado de la ejecución": se corta desde el análisis
    hasta la pregunta del rango de gráfico.
    """
    lineas = texto.splitlines()
    inicio = next((i for i, ln in enumerate(lineas) if ln.strip().startswith("--- Análisis")), None)
    fin = next((i for i, ln in enumerate(lineas) if "Ingrese el limite inferior" in ln), len(lineas))
    if inicio is None:
        return texto
    return "\n".join(lineas[inicio:max(fin, inicio + 1)])


def capturar(metodo, script):
    m = METODOS[metodo]
    base = HERE / "img" / metodo
    base.parent.mkdir(parents=True, exist_ok=True)
    texto = entradas(metodo)

    consola = recortar(correr(script, texto))
    (HERE / "img" / f"{metodo}.consola.txt").write_text(consola, encoding="utf-8")

    exportar_figuras(script, texto, base, m["figuras"])

    from render_consola import main as render_main
    sys.argv = ["render_consola", str(HERE / "img" / f"{metodo}.consola.txt"),
                str(base) + "-consola.png", m["titulo"]]
    render_main()
    (HERE / "img" / f"{metodo}.consola.txt").unlink(missing_ok=True)

    faltan = [f"{base}-grafico{k}.png" for k in range(1, m["figuras"] + 1)
              if not pathlib.Path(f"{base}-grafico{k}.png").exists()]
    if faltan:
        print(f"  AVISO: faltan figuras {faltan}", file=sys.stderr)
    print(f"  {metodo}: consola + {m['figuras']} figura(s)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--solo", choices=sorted(METODOS), action="append")
    args = ap.parse_args()

    script = copia_sin_waitfor()
    try:
        for metodo in args.solo or ["pf", "newton", "aitken"]:
            capturar(metodo, script)
    finally:
        script.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
