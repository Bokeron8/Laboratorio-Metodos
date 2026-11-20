#!/usr/bin/env python3
"""Genera el informe del 2° Trabajo de Evaluación en .docx.

Pipeline:
  1. Capturas -> corre principal.m y menu_metodos.m, deja las consolas en PNG.
  2. Docx     -> arma carátula, índices y contenido a partir de informe.md.

Se invoca con el intérprete del venv (python-docx):
  herramientas/informe/.venv/bin/python \
      tp-evaluativo-2-gauss-interpolacion/informe/generar.py
"""
import json
import pathlib
import shutil
import subprocess
import sys
import tempfile

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "herramientas" / "informe"))

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


def docx(indice=None):
    cfg = json.loads((HERE / "informe.json").read_text(encoding="utf-8"))
    md = (HERE / "informe.md").read_text(encoding="utf-8")
    salida = construir(md, cfg, HERE / "informe.docx", base_dir=HERE, indice=indice)
    log(f"  {salida.name}: {salida.stat().st_size} bytes")
    return salida


def docx_con_indice():
    """Repagina hasta que los índices quedan estables (ver TP1)."""
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
    if "--sin-capturas" in sys.argv:
        log("[1/2] Capturas: omitidas")
    else:
        log("[1/2] Capturas")
        capturas()

    log("[2/2] Documento")
    try:
        docx_con_indice()
    except (FileNotFoundError, subprocess.SubprocessError) as e:
        log(f"  aviso: no se pudo paginar ({e}); los índices quedan como campo a actualizar")
        docx()


if __name__ == "__main__":
    main()
