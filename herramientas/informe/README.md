# Herramientas de informe

Generan el informe de cada laboratorio: **capturan la salida de consola y las
figuras de los scripts de Octave, inyectan el código real en el markdown y
renderizan un PDF A4 con paginación**.

La idea es que el informe no pueda quedar desactualizado respecto del código.
El markdown fuente tiene marcadores `{{CODE:archivo.m}}`, y al generar se
reemplazan por el contenido real leído del disco. Si editás un `.m`,
regenerás, y el informe queda al día.

## Requisitos

| Herramienta | Para qué | Estado en esta máquina |
| :--- | :--- | :--- |
| Octave 6.x | correr los scripts y dibujar | `octave-cli` |
| Python 3 + Pillow | renderizar consola a PNG | `PIL` |
| Python 3 + WeasyPrint | markdown → PDF | `weasyprint` |
| gnuplot con `pngcairo` | figuras PNG con acentos | `gnuplot 5.4` |

Sin `pngcairo` las figuras salen con los acentos rotos (`EvaluaciÃ³n`).

## Uso rápido

```bash
# regenerar todo (vuelve a correr Octave)
python3 herramientas/informe/generar_informe.py herramientas/informe/lab-3.json

# solo el markdown y el PDF, reutilizando los PNG ya capturados
python3 herramientas/informe/generar_informe.py herramientas/informe/lab-3.json --sin-capturas

# solo el markdown, sin PDF
python3 herramientas/informe/generar_informe.py herramientas/informe/lab-3.json --sin-pdf
```

Se puede invocar desde cualquier directorio: la herramienta resuelve las rutas
con respecto a la ubicación del archivo de configuración.

## Qué produce

```
lab-3/
├── informe-plantilla.md   # fuente: se edita a mano, lleva los marcadores
├── informe.md             # generado: markdown con el código ya inyectado
├── informe.pdf            # generado: PDF A4 paginado
└── informe/
    ├── ej1-consola.png    # captura de la salida de consola
    ├── ej1-grafico.png    # figura
    └── ...
```

`informe-plantilla.md` es lo único que se edita a mano. `informe.md` e
`informe.pdf` se regeneran; no hay que tocarlos.

## Cómo armar un laboratorio nuevo

### 1. Copiar la plantilla base

```bash
cp herramientas/informe/informe-base.md lab-1/informe-plantilla.md
```

### 2. Escribir el markdown con marcadores

```markdown
# Informe — Guía 1

## Ejercicio 1 — Suma de N números

### `01-suma-n-numeros.m`

{{CODE:01-suma-n-numeros.m}}

### Salida de ejecución

{{IMG:ej1-consola}}

### Gráfico

{{IMG:ej1-grafico}}
```

Marcadores disponibles:

| Marcador | Se reemplaza por |
| :--- | :--- |
| `{{CODE:archivo.m}}` | el contenido del archivo entre cercas ```` ```octave ```` |
| `{{IMG:tag-consola}}` | `carpeta_figuras/tag-consola.png` |
| `{{IMG:tag-grafico}}` | `carpeta_figuras/tag-grafico.png` |

### 3. Crear el archivo de configuración

```json
{
  "laboratorio": "lab-1",
  "plantilla": "informe-plantilla.md",
  "salida_md": "informe.md",
  "salida_pdf": "informe.pdf",
  "figuras": "informe",

  "capturas": [
    {
      "tag": "ej1",
      "script": "01-suma-n-numeros.m",
      "titulo": "Ejercicio 1 - Suma de N numeros",
      "entradas": "5,10,0.001"
    }
  ]
}
```

### 4. Generar

```bash
python3 herramientas/informe/generar_informe.py herramientas/informe/lab-1.json
```

## Referencia de la configuración

| Clave | Tipo | Default | Qué hace |
| :--- | :--- | :--- | :--- |
| `laboratorio` | string | — | Carpeta del lab, relativa al archivo de config |
| `plantilla` | string | — | Markdown fuente con los marcadores |
| `salida_md` | string | `informe.md` | Markdown generado |
| `salida_pdf` | string | `informe.pdf` | PDF generado |
| `figuras` | string | `informe` | Carpeta de las capturas |
| `capturas[].tag` | string | — | Prefijo de los PNG (`{{IMG:<tag>-consola}}`) |
| `capturas[].script` | string | — | Script de Octave a correr |
| `capturas[].titulo` | string | `tag` | Título arriba de la captura |
| `capturas[].entradas` | string | `""` | Valores para los `input`, separados por coma |
| `capturas[].ancho` | int | `1000` | Ancho del PNG de la figura, en píxeles |
| `capturas[].alto` | int | `700` | Alto del PNG de la figura |
| `capturas[].drop_desde` | lista | `[]` | Descartar desde esa línea hasta el final |
| `capturas[].drop_bloque` | lista | `[]` | `[marcador, n]`: descartar esa línea y las n siguientes |

## Herramientas por separado

Cada pieza se puede usar sola.

### `capturar.py` — consola y figura de un script

```bash
python3 herramientas/informe/capturar.py lab-3/01-tanque-esferico.m informe/ej1 \
    --entradas "0.5,0.001" --titulo "Ejercicio 1" --ancho 1000 --alto 700
```

Genera `informe/ej1-consola.png` e `informe/ej1-grafico.png`.

### `render_consola.py` — texto a PNG de terminal

```bash
python3 herramientas/informe/render_consola.py salida.txt captura.png "Título" \
    --drop-desde "--- Conclusiones ---"
```

### `md2html.py` — markdown a HTML con CSS de impresión

```bash
python3 herramientas/informe/md2html.py informe.md informe.html
```

## Trampas que ya están resueltas

Estas son las que costaron tiempo. Si tocás el código, no las rompas.

**Las figuras se capturan con `-dpngcairo`, no `-dpng`.** El terminal `png` de
gnuplot no interpreta UTF-8 y los acentos de los títulos salen como
`EvaluaciÃ³n`. Además `-r` no funciona con pngcairo: el tamaño se controla con
`-S<ancho>,<alto>`.

**Cada script se corre DOS veces.** gnuplot vuelca el plot ASCII a stdout, así
que si se dibujara en la misma pasada el gráfico terminaría mezclado entre los
resultados. La primera pasada captura la consola sin dibujar; la segunda dibuja
el PNG descartando stdout.

**Octave resuelve las funciones por el directorio actual**, no por la ubicación
del script. Por eso la herramienta fuerza `cwd` a la carpeta del script. Sin
eso, invocar desde la raíz del repo hace que el script aborte con
`tanteo undefined` y la captura sale vacía.

**stderr no se concatena crudo.** El warning de gnuplot empieza en
`"warning: using the gnuplot graphics toolkit..."` y termina en
`"...qt toolkit instead"`. Si queda en medio del texto, el filtro por bloque
corta desde ahí hasta el final y se lleva casi todo el stdout.

**`--entradas` se separa por comas y se convierte a líneas.** El `input` de
Octave lee línea a línea; pasar `"0.5,0.001"` tal cual hace que el primer input
se quede con los dos valores y el segundo no reciba nada.

## Cambios de estilo en el PDF

El CSS de impresión está en `md2html.py`, en la constante `CSS`. Los puntos
que más se tocan:

| Regla | Qué controla |
| :--- | :--- |
| `@page` | tamaño, márgenes y encabezado/pie con número de página |
| `h2 { break-before: page }` | cada sección arranca en página nueva |
| `pre { orphans: 4; widows: 4 }` | evita páginas con una sola línea suelta de código |
| `p.figura img { max-height: 232mm }` | impide que una figura alta se separe de su título |
