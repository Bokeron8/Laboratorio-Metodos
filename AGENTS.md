# AGENTS.md

Guía para agentes de IA que trabajan en este repositorio.

## Qué es

Soluciones en **GNU Octave 6.4.0** de las guías de laboratorio de Métodos
Computacionales (FaCENA – UNNE). Cada carpeta trae las consignas y el código que
las resuelve, más el generador de informes.

## Estructura

| Carpeta | Contenido |
| :--- | :--- |
| `lab-1/` … `lab-6/` | Guías 1 a 6, con `consignas.md` y los scripts que las resuelven |
| `tp-evaluativo-1-metodos-de-raices/` | TP evaluativo 1: tanteo, Newton-Raphson, Aitken, con informe `.docx` |
| `tp-evaluativo-2-gauss-interpolacion/` | TP evaluativo 2: Gauss-Jordan e interpolación inversa lineal |
| `herramientas/informe/` | Pipeline de informes: capturas de Octave, inyección de código, PDF y DOCX |

## Convenciones de código

- **Scripts**: `NN-problema.m` — un script por ejercicio; el nombre dice qué
  problema resuelve (`01-tanque-esferico.m`).
- **Funciones**: el nombre dice qué método implementan, en `snake_case`
  (`newton_raphson.m`, `simpson_13.m`, `resolver_gauss.m`).
- **Comentarios en español**, explicando qué hace el código para una persona que
  lo lee. Nada de meta-comentarios sobre decisiones del agente.
- **Los scripts imprimen resultados crudos; el informe interpreta.** No metas
  teoría ni conclusiones en el código.
- **Las validaciones viven en el método**, no duplicadas en el script o menú que
  lo llama.
- Los `.m` deben correr en Octave 6.4.0, no sólo en MATLAB.

## Cómo correr

```bash
cd lab-5
octave-cli 01-intervalos-espaciados.m
```

Octave resuelve las funciones por el **directorio actual**, no por la ubicación
del script. Si invocás desde la raíz del repo, el script falla con
`nombre_de_funcion undefined`. Corré siempre desde la carpeta del laboratorio.

## Informes

Hay dos pipelines y **los dos usan los mismos archivos fuente**: un
`informe-plantilla.md` escrito a mano con marcadores (`{{CODE:archivo.m}}`,
`{{IMG:tag}}`), que se expande a partir del código real. Si cambiás un `.m`,
regenerás y el informe queda al día.

| Destino | Comando |
| :--- | :--- |
| Lab → PDF A4 | `python3 herramientas/informe/generar_informe.py herramientas/informe/lab-3.json` |
| TP → DOCX | `herramientas/informe/.venv/bin/python tp-evaluativo-1-metodos-de-raices/informe/generar.py` |

- El pipeline de PDF necesita el `python3` del sistema (PIL + WeasyPrint).
- El pipeline de DOCX necesita `herramientas/informe/.venv/bin/python`
  (python-docx).
- `informe.md`, `informe.pdf` e `informe.docx` son **generados**: se regeneran,
  no se editan. Lo único que se edita a mano es `informe-plantilla.md`.
- Detalle completo, marcadores y trampas ya resueltas: `herramientas/informe/README.md`.
- Tests del pipeline: `herramientas/informe/.venv/bin/python -m unittest discover -s herramientas/informe -p "test_*.py"`.

## Skills del proyecto

`.opencode/skills/generar-informe/SKILL.md` — cargala con el tool `skill` (ID
`generar-informe`) cuando haya que armar o regenerar un informe. Tiene los pasos
y las trampas del pipeline.

## Commits

- **Conventional Commits en español**: `feat(lab-5): agregar interpolación numérica`.
- Sin atribución a IA ni `Co-Authored-By`.
- No commitees ni pushees sin que te lo pidan.

## Estado conocido

- `lab-4/`, `lab-5/`, `lab-6/` y `tp-evaluativo-2-gauss-interpolacion/` todavía
  no tienen informe generado.
- `herramientas/informe/lab-4.json` es un stub: título equivocado («Guía 6») y
  `capturas` vacío. No lo uses como plantilla sin corregirlo.
- El `README.md` de la raíz está desactualizado: no menciona `lab-4/` a `lab-6/`
  ni `tp-evaluativo-2-gauss-interpolacion/`.
- `odd/` y `.atl/` están en `.gitignore`: son documentos de trabajo, no parte de
  la entrega.
