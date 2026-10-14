# Métodos Computacionales — Soluciones de Laboratorios

Soluciones en Octave de las guías de laboratorio de Métodos Computacionales. Cada carpeta contiene las consignas (`consignas.md`) junto al código que las resuelve.

## Quick path

1. Abrí la carpeta del laboratorio que te corresponda.
2. Corré el script del ejercicio en Octave.
3. Ingresá los datos por teclado cuando los pida.

Los tres labs resueltos usan la misma convención: **un script por ejercicio**,
un archivo `.m` con el número y el problema que resuelve.

```bash
cd lab-1
octave-cli 01-suma-n-numeros.m          # pregunta N
octave-cli 02-suma-pares.m              # pregunta N
octave-cli 03-fibonacci.m               # pregunta N
octave-cli 04-ecuacion-segundo-grado.m   # sin datos
octave-cli 05-serie-e.m                 # pregunta N
octave-cli 06-serie-pi.m                # pregunta N

cd lab-2
octave-cli 01-error-absoluto-relativo.m  # sin datos
octave-cli 02-aritmetica-redondeo.m      # sin datos
octave-cli 03-aritmetica-truncamiento.m  # sin datos
octave-cli 04-raices-cuadraticas.m      # sin datos
octave-cli 05-evaluacion-polinomio.m    # sin datos

cd lab-3
octave-cli 01-tanque-esferico.m             # pregunta el incremento y la cota de error
octave-cli 02-punto-equilibrio-impresoras.m # pregunta el incremento y la cota de error
octave-cli 03-publicidad-utilidad.m         # pregunta x0 y la cota de error
```

## Estructura

| Carpeta | Contenido | Entry point |
| :--- | :--- | :--- |
| `lab-1/` | Guide 1 — aritmética básica, sucesiones, series | `01-` a `06-*.m` |
| `lab-2/` | Guide 2 — errores, redondeo y truncamiento | `01-` a `05-*.m` |
| `lab-3/` | Guide 3 — métodos numéricos de raíces | `01-`, `02-`, `03-*.m` |
| `lab-4/` | Guide 4 — sin consignas cargadas todavía | — |
| `herramientas/informe/` | Generador de informes con capturas y PDF | `generar_informe.py` |
| `tp-evaluativo-1-metodos-de-raices/` | Evaluación: punto fijo, Newton-Raphson, Aitken | `principal.m` |

## Detalle por laboratorio

Los tres labs resueltos comparten la misma convención de nombres: **los scripts
llevan el número y el problema que resuelven**, las **funciones llevan el
método que implementan**, en `snake_case`.

### `lab-1/` — Guide 1

**Ejercicios resueltos** — un script por ejercicio de la guía.

| Archivo | Qué resuelve |
| :--- | :--- |
| `01-suma-n-numeros.m` | Suma de N positivos, con el rango 0–255 y N = 10000 |
| `02-suma-pares.m` | Suma de los pares entre 200 positivos |
| `03-fibonacci.m` | Los N primeros términos de la sucesión, N = 200 |
| `04-ecuacion-segundo-grado.m` | `3x² + 2x − 1 = 0`, raíces `1/3` y `−1` |
| `05-serie-e.m` | `e` como serie, con el error contra `exp(1)` |
| `06-serie-pi.m` | Serie de Leibniz: términos y tiempo para 3, 4 y 5 dígitos |

**Método** — `fibonacci.m` es la única función, memoizada con cache
persistente. Antes era recursión ingenua y no podía resolver la consigna: pedía
N = 200, y `fib(30)` tardaba 8 segundos, o sea que `fib(200)` era
prácticamente infinito.

### `lab-2/` — Guide 2

**Ejercicios resueltos** — un script por ejercicio de la guía.

| Archivo | Qué resuelve |
| :--- | :--- |
| `01-error-absoluto-relativo.m` | Error absoluto y relativo de los seis casos a–f |
| `02-aritmetica-redondeo.m` | Redondeo a tres dígitos, valores normalizados |
| `03-aritmetica-truncamiento.m` | Truncamiento a tres dígitos, con la comparación que pide la consigna |
| `04-raices-cuadraticas.m` | Raíces de `x² + 62.10x + 1 = 0`, directa y "racionalizada" |
| `05-evaluacion-polinomio.m` | `f(x) = x³ − 6x² + 3x − 0.149` con tres dígitos, forma directa y anidada |

**Métodos** — funciones reutilizables.

| Archivo | Firma | Qué hace |
| :--- | :--- | :--- |
| `normalizar.m` | `(x)` → `(exponente, resultado)` | Lleva el número a la forma `0.1 ≤ \|r\| < 1` |
| `redondear.m` | `(x)` | Redondeo a tres dígitos **normalizado** |
| `truncar.m` | `(x)` | Truncamiento a tres dígitos **normalizado** |
| `redondear_n.m` | `(x, n)` | Redondeo a n dígitos **sin normalizar** |
| `truncar_n.m` | `(x, n)` | Truncamiento a n dígitos **sin normalizar** |
| `error_absoluto.m` | `(exacto, calculado)` | `\|exacto − calculado\|` |
| `error_relativo.m` | `(exacto, calculado)` | `error_absoluto / \|exacto\|` |

`redondear_n` / `truncar_n` están aparte de `redondear` / `truncar` a propósito:
son operaciones distintas. La consigna del ejercicio 5 pide la tabla
explícitamente **sin normalizar**, y usar las que normalizan cambia los
números. Ojo igual: en los ejercicios de esta guía las dos parejas coinciden,
porque normalizar a tres dígitos *es* tres dígitos. La diferencia es de
representación, no de resultado acá.

Estas funciones antes vivían al tope de un solo script, donde eran
*script-locales*: desde cualquier otro archivo `redondear` daba `undefined`.
Por eso ahora son archivos propios.

### `lab-3/` — Guide 3

Dos capas, separadas por nombre: los scripts llevan el número y el problema que resuelven, las funciones llevan el método que implementan.

**Ejercicios resueltos** — un script por ejercicio de la guía.

| Archivo | Qué resuelve | Resultado con los datos de la consigna |
| :--- | :--- | :--- |
| `01-tanque-esferico.m` | Tanque esférico: gráfico, tanteo, intervalo medio vs interpolación lineal | `h ≈ 2.0269 m` |
| `02-punto-equilibrio-impresoras.m` | Punto de equilibrio: gráfico, tanteo, Fourier + Newton-Raphson | `x ≈ 25.23` y `x ≈ 250.76` |
| `03-publicidad-utilidad.m` | Publicidad: punto fijo y punto fijo acelerado con Aitken | `x ≈ 213.32` unidades |

**Métodos numéricos** — funciones reutilizables.

| Archivo | Firma | Qué hace |
| :--- | :--- | :--- |
| `tanteo.m` | `(f, a, b)` → matriz Nx2 | Separa raíces barriendo `[a, b]`; el paso se pide por teclado |
| `intervalo_medio.m` | `(f, a, b, tol)` → `(raiz, iter)` | Bisección, frena con `(b-a)/2 <= tol` |
| `interpolacion_lineal.m` | `(f, a, b, tol)` → `(raiz, iter, tabla)` | Interpolación lineal, frena con `\|c_n - c_(n-1)\| <= tol` |
| `newton_raphson.m` | `(F, x0, tol)` → `(x_raiz, iter, convergio)` | Newton con derivada por diferencia central |
| `iteracion.m` | `(g, x0, tol)` → `(x_raiz, iter, convergio)` | Punto fijo, exige \|g'(x0)\| < 1 |
| `aceleracion.m` | `(g, x0, tol)` → `(x_raiz, iter, convergio)` | Aceleración de Aitken (Δ²) |

`newton_raphson.m`, `iteracion.m` y `aceleracion.m` son la implementación de referencia: validan entradas, están documentadas y devuelven un flag `convergio`.

La tolerancia **siempre es argumento**, no está fija en el cuerpo de ninguna función. La consigna pide probar con distintas cotas de error y comparar, así que el caller decide cuánto error acepta.

**Informe** — `lab-3/informe.md` y `lab-3/informe.pdf` se generan con las herramientas de `herramientas/informe/`. Ver esa carpeta.

### `herramientas/informe/`

Genera el informe de cada laboratorio: captura la salida de consola y las figuras de los scripts de Octave, inyecta el código real en el markdown y renderiza un PDF A4 paginado.

```bash
python3 herramientas/informe/generar_informe.py herramientas/informe/lab-3.json
```

El markdown fuente (`lab-3/informe-plantilla.md`) lleva marcadores `{{CODE:archivo.m}}` y `{{IMG:tag-consola}}`, así que el informe nunca puede quedar desactualizado respecto del código: se edita el `.m`, se regenera, y el PDF se actualiza. La [guía completa](herramientas/informe/README.md) está en esa carpeta.

Requiere Octave, Python con Pillow, WeasyPrint, y gnuplot con terminal `pngcairo`.

### `tp-evaluativo-1-metodos-de-raices/`

Programa autónomo con menú de tres métodos. `newton_raphson.m`, `iteracion.m` y `aceleracion.m` son idénticos a los de `lab-3/`; `tanteo.m` **no**, porque acá toma `a` y `b` por teclado (`tanteo(f)`) mientras que el de `lab-3/` los recibe como argumentos. Cada carpeta mantiene su propia copia a propósito: son dos entregables separados. Ver su [README](tp-evaluativo-1-metodos-de-raices/README.md) para el detalle de uso.

## Gotchas conocidos

Estos no son errores de tipeo, son trampas reales del código:

- **Usá `./` y `.*` en las funciones que se pasan a `fplot`.** `fplot` evalúa vectores; con `/` y `*` escalar Octave explota. Todos los scripts de `lab-3/` ya lo hacen bien, pero es la trampa más fácil de reintroducir al escribir una función nueva.
- **`input` no interpreta `\n` en strings de comillas simples.** Octave lo trata como los dos caracteres literales. `fprintf` sí lo interpreta. Si querés un salto de línea antes de un prompt, hacé `fprintf('\n')` aparte.
- **El escapado de comilla simple dentro de `fprintf` es confuso.** `''` produce una comilla simple y `\'` **rompe el parseo** dentro de comillas simples. Para texto con apóstrofos (como `g'(x0)`), usá comillas dobles: `fprintf("|g'(x0)| = %.4f\n", x)`.
- **El tanque esférico del ejercicio 1 tiene una sola raíz física, no dos.** Con `R = 3` y `V = 30`, el volumen máximo del tanque es `V(2R/3) = 29.32 m³ < 30 m³`. Como polinomio, `f` tiene una segunda raíz cerca de `h = 8.61 m`, pero está más allá del ecuador y la fórmula ya no describe un volumen de agua. El barrido se limita a `[0, 2R]` a propósito.
- **El chequeo de convergencia es local, no global.** `iteracion.m`, `newton_raphson.m` y `aceleracion.m` verifican `|g'(x0)| < 1` (o `F'(x) ≠ 0`) **una sola vez, en `x0`**. Eso es una afirmación sobre un punto, no sobre toda la trayectoria: las iteradas pueden salirse de la región donde la condición se cumple. Y ninguna de las tres tiene `max_iter`, así que si eso pasa el script queda colgado en loop infinito. Para las funciones de estas guías el riesgo es bajo: los puntos fijos están donde `|g'| < 1` siempre y convergen en pocas iteraciones. Cuidado igual si cargás un `x0` raro a mano — `03-publicidad-utilidad.m` imprime `|g'(x0)|` antes de correr justamente para que se vea.
- **Entrá a la carpeta antes de correr un script.** Octave resuelve las funciones contra el *directorio de trabajo*, no contra el directorio del script. `cd lab-3 && octave-cli 01-tanque-esferico.m` funciona; `octave-cli lab-3/01-tanque-esferico.m` desde la raíz muere con `'tanteo' undefined`. Los tres labs se comportan igual.
- **`ezplot` e `inline` son legado.** Octave 6.4 los soporta con warnings; en Octave 9+ fueron eliminados. Ya no quedan: `lab-1/04-ecuacion-segundo-grado.m` usa `@(x)` y `fplot`. Si escribís una función nueva para graficar, no los reintroduzcas.
- **Las funciones definidas al final de un script no existen para nadie más.** Octave no las hoistea a un scope global cuando el script corre con `octave-cli archivo.m`. Por eso los métodos de `lab-2/` son archivos propios y no van pegados al final de un script.
- **Escalar por potencias de diez en punto flotante puede perder un dígito.** `fix(x * 10^k)` se come un dígito cuando el escalado cae apenas por debajo del entero: `truncar_n(0.149, 3)` daba `0.148` y `truncar(-28)` daba `-27.9`. `redondear_n.m` y `truncar_n.m` corrigen con un margen relativo al tamaño del valor; los truncamientos genuinos no se ven afectados.
- **"Tres dígitos" en las consignas son tres dígitos *significativos*, no tres decimales.** Es la convención de Burden & Faires, y es lo que hace el ejercicio 5 de `lab-2/`. Con `x = 4.71`, `x³` redondeado da `105` y truncado da `104`. Si tu docente lo interpreta distinto, el cambio queda aislado en `lab-2/05-evaluacion-polinomio.m` y en `redondear_n.m` / `truncar_n.m`.
- **La serie de Leibniz converge como 1/n, no como el orden que uno espera.** Para 5 decimales necesita del orden de 10⁵ términos y casi 1.4 s en Octave. La consigna pide "3 dígitos exactos", que es ambiguo entre decimales y cifras significativas; `lab-1/06-serie-pi.m` calcula las dos lecturas y lo dice. Los comentarios de la versión anterior delinear 613 / 1690 / 10800 términos no coinciden con ninguna de las dos.

## Requisitos

- Octave (probado en 6.4.0) o MATLAB.
- Las funciones de graficado necesitan display gráfico; con `octave-cli` sin servidor gráfico, las figuras no abren.