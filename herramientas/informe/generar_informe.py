#!/usr/bin/env python3
"""Genera el informe completo de un laboratorio a partir de su configuracion.

Pipeline:
  1. Captura   -> corre cada script de Octave y produce las capturas de consola
                  y las figuras en PNG.
  2. Inyecta   -> reemplaza los marcadores {{CODE:archivo}} del informe fuente
                  con el codigo real leido del disco, para que el informe nunca
                  pueda quedar desactualizado respecto del codigo.
  3. HTML      -> convierte el markdown a HTML con CSS de impresion.
  4. PDF       -> renderiza con WeasyPrint.

Uso:
  generar_informe.py <config.json> [--salida-capturas-only] [--sin-pdf]
"""
import argparse
import json
import pathlib
import re
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
RAIZ_REPO = HERE.parent.parent


def log(msg):
    print(msg, flush=True)


def capturar(cfg, lab_dir):
    """Corre las capturas declaradas en la configuracion."""
    for cap in cfg.get("capturas", []):
        tag = cap["tag"]
        destino = lab_dir / cfg.get("figuras", "informe") / tag
        log(f"  capturando {cap['script']} -> {tag}")

        cmd = [sys.executable, str(HERE / "capturar.py"),
               str(lab_dir / cap["script"]), str(destino),
               "--entradas", cap.get("entradas", ""),
               "--titulo", cap.get("titulo", tag),
               "--ancho", str(cap.get("ancho", 1000)),
               "--alto", str(cap.get("alto", 700))]
        for d in cap.get("drop_desde", []):
            cmd += ["--drop-desde", d]
        for bloque in cap.get("drop_bloque", []):
            cmd += ["--drop-bloque", bloque[0], str(bloque[1])]

        proc = subprocess.run(cmd, capture_output=True, text=True)
        for linea in proc.stdout.splitlines():
            log(linea)
        if proc.returncode != 0:
            log(f"  ERROR en {cap['script']}:\n{proc.stderr}")


def inyectar(cfg, lab_dir):
    """Reemplaza los marcadores {{CODE:x}} y {{IMG:tag}} del informe fuente."""
    fuente = lab_dir / cfg["plantilla"]
    destino = lab_dir / cfg.get("salida_md", "informe.md")
    texto = fuente.read_text(encoding="utf-8")

    faltantes = []

    def code(m):
        nombre = m.group(1)
        ruta = lab_dir / nombre
        if not ruta.exists():
            faltantes.append(nombre)
            return f"<!-- FALTA {nombre} -->"
        return "```octave\n" + ruta.read_text(encoding="utf-8").rstrip("\n") + "\n```"

    def img(m):
        tag = m.group(1)
        sufijo = m.group(2)
        return f"{cfg.get('figuras', 'informe')}/{tag}{sufijo}.png"

    texto = re.sub(r"\{\{CODE:([^}]+)\}\}", code, texto)
    texto = re.sub(r"\{\{IMG:([^}]+?)(-(?:consola|grafico))\}\}", img, texto)
    destino.write_text(texto, encoding="utf-8")

    if faltantes:
        log(f"  ERROR: archivos de codigo inexistentes: {faltantes}")
        return None
    return destino


def a_pdf(md_path, lab_dir, salida_pdf):
    sys.path.insert(0, str(HERE))
    from md2html import convertir, CSS  # noqa: E402
    import weasyprint  # noqa: E402

    cuerpo = convertir(md_path.read_text(encoding="utf-8"))
    html_tmp = HERE / ".informe_tmp.html"
    html_tmp.write_text(
        f'<!DOCTYPE html><html lang="es"><head><meta charset="utf-8">'
        f"<title>Informe</title><style>{CSS}</style></head>"
        f"<body>{cuerpo}</body></html>", encoding="utf-8")

    destino = lab_dir / salida_pdf
    weasyprint.HTML(filename=str(html_tmp),
                    base_url=lab_dir.resolve().as_uri() + "/").write_pdf(str(destino))
    html_tmp.unlink(missing_ok=True)
    return destino


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("config")
    ap.add_argument("--sin-capturas", action="store_true",
                    help="no volver a correr Octave, reutilizar los PNG existentes")
    ap.add_argument("--sin-pdf", action="store_true")
    args = ap.parse_args()

    cfg_path = pathlib.Path(args.config).resolve()
    cfg = json.loads(cfg_path.read_text(encoding="utf-8"))
    lab_dir = (cfg_path.parent / cfg["laboratorio"]).resolve()
    if not lab_dir.is_dir():
        lab_dir = RAIZ_REPO / cfg["laboratorio"]
    log(f"Informe de {cfg['laboratorio']}  ({lab_dir})")

    if not args.sin_capturas:
        log("\n[1/3] Capturas")
        capturar(cfg, lab_dir)
    else:
        log("\n[1/3] Capturas: omitidas (reutilizando PNG existentes)")

    log("\n[2/3] Inyectando codigo")
    md = inyectar(cfg, lab_dir)
    if md is None:
        sys.exit(1)
    log(f"  {md.name}: {len(md.read_text(encoding='utf-8').splitlines())} lineas")

    if args.sin_pdf:
        log("\n[3/3] PDF: omitido")
        return

    log("\n[3/3] PDF")
    pdf = a_pdf(md, lab_dir, cfg.get("salida_pdf", "informe.pdf"))
    log(f"  {pdf.name}: {pdf.stat().st_size} bytes")


if __name__ == "__main__":
    main()
