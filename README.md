# Métodos Computacionales — Soluciones de Laboratorios

Soluciones en Octave de las guías de laboratorio de Métodos Computacionales. Cada carpeta contiene las consignas (`consignas.md`) junto al código que las resuelve.

## Quick path

1. Abrí la carpeta del laboratorio que te corresponda.
2. Corré el script principal en Octave.
3. Ingresá los datos por teclado cuando los pida.

```bash
cd lab-1 && octave-cli Tp1.m
```

## Estructura

| Carpeta | Contenido | Entry point |
| :--- | :--- | :--- |
| `lab-1/` | Guide 1 — aritmética básica, sucesiones, series | `Tp1.m` |
| `lab-2/` | Guide 2 — errores, redondeo y truncamiento | `Tp2.m` |
| `lab-3/` | Guide 3 — métodos numéricos de raíces | `Tp3.m`, `Ejercicio1-3.m` |
| `lab-4/` | Guide 4 — sin consignas cargadas todavía | — |
| `tp-evaluativo-1-metodos-de-raices/` | Evaluación: punto fijo, Newton-Raphson, Aitken | `principal.m` |

## Detalle por laboratorio

### `lab-1/` — Guide 1

`Tp1.m` cubre los 6 ejercicios: suma de N números, suma de pares, Fibonacci, ecuación de segundo grado, serie de `e` y serie de `π`. `fibonacci.m` es la función recursiva que usa el ejercicio 3.

Casi todo el código está comentado con `#`/`#{` para ir destapando de a un ejercicio. Sacá el bloque que necesites.

### `lab-2/` — Guide 2

`Tp2.m` implementa error absoluto/relativo, aritmética normalizada con redondeo y truncamiento a 3 dígitos, y las raíces cuadráticas del ejercicio 4 (incluye la versión "racionalizada" del numerador).

Las funciones auxiliares (`normalizar`, `redondear`, `truncar`) están defined arriba del todo, fuera de los bloques comentados: se usan desde varios ejercicios.

### `lab-3/` — Guide 3

Contiene dos capas de archivos:

**Ejercicios resueltos** — un script por ejercicio de la guía.

| Archivo | Qué resuelve |
| :--- | :--- |
| `Ejercicio1.m` | Tanque esférico: tanteo, intervalo medio e interpolación lineal |
| `Ejercicio2.m` | Punto de equilibrio de impresoras: gráfico + Newton-Raphson con Fourier |
| `Ejercicio3.m` | Publicidad y utilidad: punto fijo y aceleración de Aitken |
| `Tp3.m` | Integración de tanteo + intervalo medio con marcado de raíces |

**Métodos numéricos** — funciones reutilizables.

| Archivo | Firma | Qué hace |
| :--- | :--- | :--- |
| `intervalo_medio.m` | `(f, a, b)` → `(raiz, iter, a, b)` | Bisección con tolerancia fija de `0.001` |
| `iteracion_punto_fijo.m` | `(g, x0, tol, max_iter, usar_aitken)` → `(x, iter)` | Punto fijo simple o acelerado en un solo archivo |
| `tanteo.m` | `(f)` → matriz Nx2 | Separa raíces barriendo el rango |
| `newton_raphson.m` | `(F, x0, tol)` → `(x_raiz, iter, convergio)` | Newton con derivada por diferencia central |
| `iteracion.m` | `(g, x0, tol)` → `(x_raiz, iter, convergio)` | Punto fijo, exige \|g'(x0)\| < 1 |
| `aceleracion.m` | `(g, x0, tol)` → `(x_raiz, iter, convergio)` | Steffensen (Aitken Δ²) |
| `principal.m` | script | Conductor que pregunta todo por teclado y grafica |

`tanteo.m`, `newton_raphson.m`, `iteracion.m`, `aceleracion.m` y `principal.m` vienen copiados del `tp-evaluativo-1-metodos-de-raices/` y son la implementación de referencia: tienen validación de entradas, documentación y devuelven un flag `convergio`. Preferilos sobre las versiones `_old`.

**Versiones `_old`** — `tanteo_old.m`, `Tanteo_old.m`, `newton_raphson_old.m`, `aceleracion_old.m`, `intervalo_medio_old.m`, `interpolacion_lineal_old.m`. Se conservan porque están acopladas a un ejercicio concreto (hacen sus propios `input` y `printf`). Los scripts de ejercicio igual las llaman explícitamente.

`interpolacion_lineal_old.m` es la única implementación de interpolación lineal aislada en un archivo propio. `Ejercicio1.m` la resuelve inline, así que ese es el único lugar donde compararla lado a lado con intervalo medio.

### `tp-evaluativo-1-metodos-de-raices/`

Programa autónomo con menú de tres métodos. Mismas funciones que la capa canónica de `lab-3/`. Ver su [README](tp-evaluativo-1-metodos-de-raices/README.md) para el detalle de uso.

## Gotchas conocidos

Estos no son errores de tipeo, son trampas reales del código:

- **Usá `./` y `.*` en las funciones que se pasan a `fplot`.** `fplot` evalúa vectores; con `/` y `*` escala Octave explota. `principal.m` lo advierte en pantalla.
- **El chequeo de convergencia es local, no global.** `iteracion.m`, `newton_raphson.m` y `aceleracion.m` verifican `|g'(x0)| < 1` (o `F'(x) ≠ 0`) **una sola vez, en `x0`**. Eso es una afirmación sobre un punto, no sobre toda la trayectoria: las iteradas pueden salirse de la región donde la condición se cumple. Y ninguna de las tres tiene `max_iter`, así que si eso pasa el script queda colgado en loop infinito. Para las funciones de estas guías el riesgo es bajo: los puntos fijos están donde `|g'| < 1` siempre y convergen en pocas iteraciones. Cuidado igual si cargás un `x0` raro a mano.
- **`ezplot` e `inline` son legado.** Se usan en `lab-1/Tp1.m` (ejercicio 4) y `lab-3/prueba.m`. Octave 6.4 los soporta con warnings; en Octave 9+ fueron eliminados. Si actualizás Octave, migrá esas partes a `fplot` y `@(x)`.
- **`intervalo_medio.m` tiene la tolerancia fija en `0.001`** dentro del cuerpo de la función, no como argumento.
- **`Tanteo_old.m` y `tanteo_old.m` son dos archivos distintos**, con firmas distintas: la primera pide los datos por teclado, la segunda los recibe como argumentos. No son duplicados.

## Requisitos

- Octave (probado en 6.4.0) o MATLAB.
- Las funciones de graficado necesitan display gráfico; con `octave-cli` sin servidor gráfico, las figuras no abren.