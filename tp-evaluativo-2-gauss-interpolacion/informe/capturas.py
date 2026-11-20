#!/usr/bin/env python3
"""Captura la salida de consola de principal.m y menu_metodos.m.

Ninguno de los dos algoritmos dibuja figuras: la entrega pide el código y las
capturas de la ejecución, así que acá sólo se generan imágenes de consola.

Las corridas del Gauss-Jordan imprimen el paso a paso completo (decenas de
renglones por iteración). Una captura única quedaría más alta que la hoja A4,
así que se parte en dos: el planteo y la primera iteración, y el sistema final
con la solución. El texto del informe lo indica.

Uso: capturas.py
"""
import pathlib
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
TP = HERE.parent
sys.path.insert(0, str(TP.parent / "herramientas" / "informe"))

from capturar import quitar_aviso_gnuplot  # noqa: E402
from render_consola import main as render_main  # noqa: E402

# Datos del ejercicio resuelto de la práctica 06 (principal.m) y del Ejercicio 1
# de la Guía 4 (sistema 4x4, ingresado por teclado en el menú).
A_3 = "[18.72 8.2 8.76; 6.4 15.9 7.18; 5.22 6.4 14.31]"
B_3 = "[121.28; 126.321; 118.522]"
A_4 = "[80 15 35 60; 28 72 57 25; 20 20 12 20; 50 10 20 60]"
B_4 = "[230; 180; 80; 160]"
X_TABLA = "[15 25 35 45 55 65]"
Y_TABLA = "[0.965926 0.906308 0.819152 0.707107 0.573576 0.422618]"
Y_OBJETIVO = "0.90728517"

ENTRADAS = {
    "principal": "",
    "gj": f"1\n{A_4}\n{B_4}\n3\n",
    "inv": f"2\n{X_TABLA}\n{Y_TABLA}\n{Y_OBJETIVO}\n3\n",
}

CORRIDAS = {
    "principal": ("principal.m", ""),
    "gj": ("menu_metodos.m", ENTRADAS["gj"]),
    "inv": ("menu_metodos.m", ENTRADAS["inv"]),
}


def correr(script, entrada):
    cmd = ["octave-cli", "--no-window-system", "--eval", f"source('{script}');"]
    proc = subprocess.run(cmd, input=entrada, capture_output=True, text=True,
                          timeout=180, cwd=str(TP))
    if proc.returncode != 0:
        print(f"  AVISO: {script} terminó con {proc.returncode}", file=sys.stderr)
    salida = quitar_aviso_gnuplot(proc.stdout).strip()
    errores = quitar_aviso_gnuplot(proc.stderr).strip()
    return salida + ("\n" + errores if errores else "")


def hasta(texto, marca, desde=0):
    """Devuelve las líneas desde `desde` hasta antes de la que contiene `marca`."""
    lineas = texto.splitlines()
    fin = next((i for i in range(desde, len(lineas)) if marca in lineas[i]), len(lineas))
    return "\n".join(lineas[desde:fin])


def desde(texto, marca):
    """Devuelve las líneas desde la que contiene `marca` hasta el final."""
    lineas = texto.splitlines()
    inicio = next((i for i, ln in enumerate(lineas) if marca in ln), None)
    if inicio is None:
        raise SystemExit(f"No aparece el marcador: {marca}")
    return "\n".join(lineas[inicio:])


def acortar_prompts(texto):
    """Corta la línea de prompts concatenados para que la imagen no sea enorme.

    Con stdin redirigido, Octave no imprime salto de línea después de cada
    `input`: los tres mensajes quedan en un solo renglón de más de 120 caracteres
    y ensanchan la captura hasta hacer ilegible el texto en la hoja A4. Se
    conserva el primer mensaje, que acredita que el dato se pide por teclado.
    """
    lineas = []
    for ln in texto.splitlines():
        posiciones = [i for i in range(len(ln)) if ln.startswith("Ingrese ", i)]
        if len(posiciones) > 1:
            ln = ln[:posiciones[1]].rstrip()
        lineas.append(ln)
    return "\n".join(lineas)


def guardar(texto, nombre, titulo):
    carpeta = HERE / "img"
    carpeta.mkdir(parents=True, exist_ok=True)
    base = carpeta / nombre
    temporal = carpeta / f"{nombre}.txt"
    temporal.write_text(acortar_prompts(texto).strip() + "\n", encoding="utf-8")
    sys.argv = ["render_consola", str(temporal), f"{base}-consola.png", titulo]
    render_main()
    temporal.unlink(missing_ok=True)


def main():
    salidas = {}
    for clave, (script, entrada) in CORRIDAS.items():
        print(f"  corriendo {script} ({clave})")
        salidas[clave] = correr(script, entrada)

    guardar(hasta(salidas["principal"], "Iteración 2 (columna 2)"),
            "principal-1", "Gauss-Jordan: planteo y primera iteración")
    guardar(desde(salidas["principal"], "Sistema final:"),
            "principal-2", "Gauss-Jordan: sistema final y verificación")

    guardar(hasta(salidas["gj"], "GAUSS-JORDAN"),
            "menu-gj-inicio", "Menú de métodos e ingreso por teclado del sistema 4x4")
    iteracion = desde(salidas["gj"], "GAUSS-JORDAN")
    guardar(hasta(iteracion, "Normalización (6.11)"),
            "menu-gj-iter1", "Gauss-Jordan 4x4: pivoteo y eliminación")
    guardar(hasta(desde(iteracion, "Normalización (6.11)"),
                  "Iteración 2 (columna 2)"),
            "menu-gj-norm", "Gauss-Jordan 4x4: normalización y sistema reducido")
    guardar(hasta(desde(salidas["gj"], "Sistema final:"),
                  "MENÚ DE MÉTODOS NUMÉRICOS"),
            "menu-gj-final", "Gauss-Jordan 4x4: sistema final y solución")

    inv = desde(salidas["inv"], "--- INGRESO DE DATOS: INTERPOLACIÓN INVERSA LINEAL ---")
    guardar(hasta(inv, "MENÚ DE MÉTODOS NUMÉRICOS"),
            "menu-inv", "Interpolación inversa lineal: resultado")

    for png in sorted((HERE / "img").glob("*.png")):
        print(f"  {png.name}")


if __name__ == "__main__":
    main()
