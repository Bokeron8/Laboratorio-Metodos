---
name: generar-informe
description: "Trigger: generar informe, regenerar informe, informe de laboratorio, PDF del lab, docx del TP, capturas de consola. Arma o regenera el informe de un laboratorio o TP con el pipeline de herramientas/informe."
license: Apache-2.0
metadata:
  author: "Bokeron8"
  version: "1.0"
---

# Generar informe

## Activation Contract

Usá esta skill cuando haya que crear o regenerar el informe de un laboratorio o
de un TP evaluativo: capturas de Octave, markdown con el código inyectado, PDF o
DOCX.

## Hard Rules

- Editá sólo `informe-plantilla.md`. `informe.md`, `informe.pdf` e `informe.docx`
  son salidas generadas: se regeneran, nunca se editan a mano.
- El código del informe sale del disco vía `{{CODE:archivo.m}}`. Si el `.m` está
  mal, el informe está mal: arreglá el `.m` y regenerá.
- No toques `md2docx.py`, `paginar.py` ni `capturar.py` sin correr antes
  `herramientas/informe/.venv/bin/python -m unittest discover -s herramientas/informe -p "test_*.py"`.
- Las rutas de esta skill son relativas a la raíz del repo.

## Decision Gates

| Pedido | Pipeline |
| :--- | :--- |
| Lab → PDF A4 | `generar_informe.py <config>.json` |
| TP → DOCX con pautas de entrega | `tp-evaluativo-*/informe/generar.py` |
| Sólo markdown, sin PDF | agregá `--sin-pdf` |
| Reutilizar los PNG ya capturados | agregá `--sin-capturas` |

## Execution Steps

1. Confirmá el destino: lab (PDF) o TP (DOCX).
2. Leé `herramientas/informe/README.md` antes de crear un informe nuevo: tiene
   los marcadores, las claves de configuración y las trampas del pipeline.
3. Para un lab nuevo: copiá `herramientas/informe/informe-base.md` a
   `<lab>/informe-plantilla.md`, escribí las secciones con `{{CODE:...}}` y
   `{{IMG:...}}`, y creá `herramientas/informe/<lab>.json` con `laboratorio`,
   `plantilla`, `salidas` y `capturas[]` (tag, script, titulo, entradas).
4. Generá con el intérprete correcto: `python3` del sistema para PDF (PIL +
   WeasyPrint); `herramientas/informe/.venv/bin/python` para DOCX (python-docx).
5. Verificá la salida: el PDF/DOCX existe, tiene las páginas o figuras
   esperadas, y el código mostrado coincide con el `.m` actual.
6. Reportá qué se regeneró y cualquier captura que haya fallado.

## Output Contract

Devolvé: archivos generados con su ruta, comando exacto usado, y qué falló (por
ejemplo, un script que se colgó esperando un `input` no declarado en `entradas`).

## References

- `herramientas/informe/README.md` — referencia completa del pipeline.
- `herramientas/informe/informe-base.md` — plantilla vacía.
- `herramientas/informe/lab-1.json` … `lab-3.json` — configuraciones que funcionan.
