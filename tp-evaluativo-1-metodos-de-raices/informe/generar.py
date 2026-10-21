#!/usr/bin/env python3
"""Genera el informe del TP Evaluativo 1 en .docx.

Pipeline:
  1. Capturas -> corre principal.m por método y deja consola y figuras en PNG.
  2. Barrido   -> corre los tres métodos con tres tolerancias y emite la tabla.
  3. Docx      -> inyecta código, figuras y tabla en el markdown y lo convierte.

Uso:
  generar.py [--sin-capturas] [--sin-barrido]

Se puede invocar desde cualquier directorio.
"""
import argparse
import json
import pathlib
import shutil
import subprocess
import sys
import tempfile

HERE = pathlib.Path(__file__).resolve().parent
TP = HERE.parent
sys.path.insert(0, str(TP.parent / "herramientas" / "informe"))

from md2docx import construir  # noqa: E402
from paginar import medir  # noqa: E402


def log(msg):
    print(msg, flush=True)


def capturas():
    proc = subprocess.run([sys.executable, str(HERE / "capturas.py")],
                          capture_output=True, text=True)
    for linea in (proc.stdout + proc.stderr).splitlines():
        log("  " + linea)
    if proc.returncode != 0:
        raise SystemExit("error en capturas.py")


def barrido():
    """Corre barrido.m y guarda la tabla markdown que escribe por stderr.

    El stdout va a /dev/null porque las funciones de método imprimen su tabla de
    iteraciones en cada una de las 20000 repeticiones.
    """
    proc = subprocess.run(["octave-cli", "--no-window-system", str(HERE / "barrido.m")],
                          stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
                          text=True, cwd=str(HERE), timeout=600)
    tabla = [ln for ln in proc.stderr.splitlines() if ln.startswith("|")]
    if len(tabla) < 3:
        raise SystemExit(f"barrido.m no devolvio tabla:\n{proc.stderr[-800:]}")
    (HERE / "tabla-tolerancias.md").write_text("\n".join(tabla) + "\n", encoding="utf-8")
    log(f"  tabla-tolerancias.md: {len(tabla) - 2} filas")


def docx(indice=None):
    cfg = json.loads((HERE / "informe.json").read_text(encoding="utf-8"))
    md = (HERE / "informe.md").read_text(encoding="utf-8")
    salida = construir(md, cfg, HERE / "informe.docx", base_dir=HERE, indice=indice)
    log(f"  {salida.name}: {salida.stat().st_size} bytes")
    return salida


def docx_con_indice():
    """Genera el .docx repaginando hasta que los índices quedan estables.

    Cada pasada escribe los índices con las páginas medidas en la anterior: al
    llenarse, el índice puede ocupar más páginas y correr el contenido, así que
    se repite hasta que dos mediciones seguidas coinciden.
    """
    perfil = pathlib.Path(tempfile.mkdtemp(prefix="informe-lo-"))
    indice = None
    try:
        for intento in range(1, 5):
            docx(indice)
            medido = medir(HERE / "informe.docx", perfil)
            entradas = len(medido["titulos"]) + len(medido["figuras"])
            if medido == indice:
                log(f"  índices: {entradas} entradas, estables en la pasada {intento}")
                return
            log(f"  índices: {entradas} entradas, repaginando")
            indice = medido
        docx(indice)
        log("  índices: no se estabilizaron en 4 pasadas; queda la última medición")
    finally:
        shutil.rmtree(perfil, ignore_errors=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sin-capturas", action="store_true")
    ap.add_argument("--sin-barrido", action="store_true")
    args = ap.parse_args()

    log("Informe TP1 — Métodos de Raíces de Ecuaciones")
    if args.sin_capturas:
        log("[1/3] Capturas: omitidas")
    else:
        log("[1/3] Capturas")
        capturas()

    if args.sin_barrido:
        log("[2/3] Barrido: omitido (reutilizando tabla-tolerancias.md)")
    else:
        log("[2/3] Barrido de tolerancias")
        barrido()

    log("[3/3] Documento")
    try:
        docx_con_indice()
    except (FileNotFoundError, subprocess.SubprocessError) as e:
        log(f"  aviso: no se pudo paginar ({e}); los índices quedan como campo a actualizar")
        docx()


if __name__ == "__main__":
    main()
