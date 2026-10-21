#!/usr/bin/env python3
"""Pagina el .docx con LibreOffice y ubica cada título y figura en su página.

El índice de Word es un campo: su contenido visible es un resultado cacheado que
solo cambia cuando el lector actualiza campos. Para que el informe se lea bien
sin depender de ese paso, se genera el .docx, se pagina con LibreOffice y se
vuelve a generar el .docx con las entradas y sus páginas reales ya cacheadas.

Uso:
  paginar.py informe.docx        # imprime el índice medido en JSON
"""
import json
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import unicodedata

from docx import Document

# Títulos de las páginas de índice: no cuentan como contenido.
CAMPOS_INDICE = ("Índice", "Índice de figuras")


def _normalizar(texto):
    texto = unicodedata.normalize("NFC", texto)
    return re.sub(r"\s+", " ", texto).strip().casefold()


def pagina_de_contenido(paginas):
    """Índice (0-based) de la primera página de contenido.

    La carátula y las dos páginas de índice van antes; la última página de
    índice es la que lleva el título "Índice de figuras".
    """
    for i, pagina in enumerate(paginas):
        if "índice de figuras" in _normalizar(pagina):
            return i + 1
    return 0


def ubicar(entradas, paginas, desde=0):
    """Devuelve [(nivel, texto, página)] buscando en orden de documento.

    Cada entrada se busca desde la página donde apareció la anterior, así un
    título que se repite en el texto no roba la página de otro.
    """
    normalizadas = [_normalizar(p) for p in paginas]
    resultado = []
    cursor = max(desde, 0)
    for nivel, texto in entradas:
        clave = _normalizar(texto)
        pagina = None
        if clave:
            for i in range(cursor, len(normalizadas)):
                if clave in normalizadas[i]:
                    pagina = i + 1
                    cursor = i
                    break
        resultado.append((nivel, texto, pagina))
    return resultado


def titulos(docx_path):
    doc = Document(str(docx_path))
    salida = []
    for p in doc.paragraphs:
        if not p.style.name.startswith("Heading"):
            continue
        texto = p.text.strip()
        if texto in CAMPOS_INDICE:
            continue
        salida.append((int(p.style.name.split()[-1]), texto))
    return salida


def figuras(docx_path):
    doc = Document(str(docx_path))
    salida = []
    for p in doc.paragraphs:
        if p.style.name != "Caption":
            continue
        texto = p.text.strip()
        pie = texto.split(":", 1)[1].strip() if ":" in texto else texto
        salida.append((1, f"Figura {len(salida) + 1}: {pie}"))
    return salida


def paginas(docx_path, perfil=None):
    """Convierte a PDF y devuelve el texto de cada página, en orden."""
    docx_path = pathlib.Path(docx_path).resolve()
    with tempfile.TemporaryDirectory(prefix="paginar-") as tmp:
        tmp = pathlib.Path(tmp)
        copia = tmp / docx_path.name
        shutil.copy2(docx_path, copia)
        perfil = pathlib.Path(perfil) if perfil else tmp / "perfil"
        perfil.mkdir(parents=True, exist_ok=True)
        subprocess.run(
            ["soffice", f"-env:UserInstallation={perfil.as_uri()}",
             "--headless", "--convert-to", "pdf", "--outdir", str(tmp), str(copia)],
            check=True, capture_output=True, timeout=600,
        )
        texto = subprocess.run(
            ["pdftotext", "-layout", str(copia.with_suffix(".pdf")), "-"],
            check=True, capture_output=True, text=True, timeout=120,
        ).stdout
    partes = texto.split("\f")
    if partes and not partes[-1].strip():
        partes.pop()
    return partes


def medir(docx_path, perfil=None):
    pags = paginas(docx_path, perfil)
    desde = pagina_de_contenido(pags)
    return {
        "titulos": ubicar(titulos(docx_path), pags, desde),
        "figuras": ubicar(figuras(docx_path), pags, desde),
    }


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    print(json.dumps(medir(sys.argv[1]), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
