# Métodos Computacionales — Soluciones de Laboratorios

Soluciones en Octave de las guías de laboratorio de Métodos Computacionales. Cada carpeta contiene las consignas (`consignas.md`) junto al código que las resuelve.

## Quick path

1. Abrí la carpeta del laboratorio que te corresponda.
2. Corré el script del ejercicio en Octave.
3. Ingresá los datos por teclado cuando los pida.

```bash
cd lab-1 && octave-cli Tp1.m
```

En `lab-3/` hay tres entry points, uno por ejercicio:

```bash
cd lab-3
octave-cli 01-tanque-esferico.m             # pregunta el incremento y la cota de error
octave-cli 02-punto-equilibrio-impresoras.m # pregunta el incremento y la cota de error
octave-cli 03-publicidad-utilidad.m         # pregunta x0 y la cota de error
```

## Estructura

| Carpeta | Contenido | Entry point |
| :--- | :--- | :--- |
| `lab-1/` | Guide 1 — aritmética básica, sucesiones, series | `Tp1.m` |
| `lab-2/` | Guide 2 — errores, redondeo y truncamiento | `Tp2.m` |
| `lab-3/` | Guide 3 — métodos numéricos de raíces | `01-`, `02-`, `03-*.m` |
| `lab-4/` | Guide 4 — sin consignas cargadas todavía | — |
| `herramientas/informe/` | Generador de informes con capturas y PDF | `generar_informe.py` |
| `tp-evaluativo-1-metodos-de-raices/` | Evaluación: punto fijo, Newton-Raphson, Aitken | `principal.m` |

## Detalle por laboratorio

### `lab-1/` — Guide 1

`Tp1.m` cubre los 6 ejercicios: suma de N números, suma de pares, Fibonacci, ecuación de segundo grado, serie de `e` y serie de `π`. `fibonacci.m` es la función recursiva que usa el ejercicio 3.

Casi todo el código está comentado con `#`/`#{` para ir destapando de a un ejercicio. Sacá el bloque que necesites.

### `lab-2/` — Guide 2

`Tp2.m` implementa error absoluto/relativo, aritmética normalizada con redondeo y truncamiento a 3 dígitos, y las raíces cuadráticas del ejercicio 4 (incluye la versión "racionalizada" del numerador).

Las funciones auxiliares (`normalizar`, `redondear`, `truncar`) están defined arriba del todo, fuera de los bloques comentados: se usan desde varios ejercicios.

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
- **`ezplot` e `inline` son legado.** Quedan solo en `lab-1/Tp1.m` (ejercicio 4). Octave 6.4 los soporta con warnings; en Octave 9+ fueron eliminados. Si actualizás Octave, migrá esas partes a `fplot` y `@(x)`.

## Requisitos

- Octave (probado en 6.4.0) o MATLAB.
- Las funciones de graficado necesitan display gráfico; con `octave-cli` sin servidor gráfico, las figuras no abren.