# TP Evaluativo 1 — Métodos de Raíces

Programa interactivo en Octave que resuelve `F(x) = 0` con tres métodos: punto fijo, Newton-Raphson y aceleración de Aitken. Todos los datos se ingresan por teclado y el resultado se grafica.

## Quick path

```bash
cd tp-evaluativo-1-metodos-de-raices
octave principal.m
```

Después: elegís método → ingresás la función → opcionalmente hacés tanteo → ingresás `x0` y tolerancia → definís el rango del gráfico.

## Flujo de `principal.m`

| Paso | Qué pasa | Detalle |
| :--- | :--- | :--- |
| 1 | Elegís método | Menú con 1 (punto fijo), 2 (Newton-Raphson), 3 (Aitken). Rechaza valores inválidos. |
| 2 | Cargás la función | Newton pide solo `F(x)`. Punto fijo y Aitken piden **dos**: `g(x)` de iteración y `F(x)` original. |
| 3 | Tanteo (opcional) | Si respondés `s`, llama a `tanteo(F)`, separa las raíces y propone el `x0` más cercano. |
| 4 | `x0` | Si hubo tanteo, `Enter` acepta el sugerido. Si no, escribís el número. |
| 5 | Tolerancia | Número positivo. |
| 6 | Cálculo | Corre el método elegido. Si no converge, avisa y termina. |
| 7 | Resultado | Imprime raíz e iteraciones. |
| 8 | Gráfico | Pedís el rango de `x` y se dibuja `F(x)` contra `y = 0` con la raíz marcada. |

El script queda bloqueado en el último paso (`waitfor`) hasta que cierres la ventana del gráfico.

## Los tres métodos

| Opción | Método | Pide | Condición de convergencia |
| :--- | :--- | :--- | :--- |
| 1 | Punto fijo | `g(x)` y `F(x)` | \|g'(x0)\| < 1 |
| 2 | Newton-Raphson | `F(x)` | `F'(x) ≠ 0`; elegir `x0` por Fourier |
| 3 | Aitken (Steffensen) | `g(x)` y `F(x)` | Denominador `Δ²` no nulo |

Todos devuelven la misma tupla: `(x_raiz, iter, convergio)`.

**Newton no exige `F(a)*F(b) < 0`.** Esa condición es para bisección. Para Newton lo que importa es elegir `x0` donde `F(x0)*F''(x0) > 0`, porque ahí la parábola tangente no toca el eje antes de la raíz.

**Aitken no exige `|g'(x0)| < 1`.** Steffensen acelera y puede converger donde el punto fijo simple diverge. Solo pide que el denominador no se anule.

## Ejemplo — el caso de la guía

```text
Elija el metodo (1-3): 2
Ingrese F(x) en terminos de x: 5*x - 200*log(400./(500-x)) - 1000
¿Hacer tanteo para ubicar la raiz? (s/n): s
Ingrese el extremo inferior del intervalo (a): 0
Ingrese el extremo superior del intervalo (b): 300
Ingrese el valor del incremento delta_x: 10
Ingrese x0 (Enter para usar el sugerido 215.0000):
Ingrese la tolerancia: 0.0001
```

Nótese el `400./(500-x)`: es obligatorio. `fplot` evalúa la función sobre vectores, y con `/` escala en vez de dividir elemento a elemento.

## Archivos

| Archivo | Rol |
| :--- | :--- |
| `principal.m` | Conductor. Toda la entrada por teclado, el despacho y el gráfico. |
| `tanteo.m` | Separa raíces barriendo `[a, b]` con paso `delta_x`, detectando cambios de signo. |
| `iteracion.m` | Punto fijo. Verifica `\|g'(x0)\| < 1` antes de arrancar. |
| `newton_raphson.m` | Newton-Raphson con `F'` por diferencia central (`h = 1e-4`). |
| `aceleracion.m` | Steffensen: `x1 = g(x)`, `x2 = g(x1)`, `x_sig = x - (x1-x)² / (x2 - 2·x1 + x)`. |

Las tres funciones de método **no imprimen ni grafican**: solo calculan y devuelven. Todo eso vive en `principal.m`.

## Detalles que importan

- **Firmas estrictas.** Las tres funciones de método validan `nargin == 3` y fallan con `error()` si les pasás menos o más argumentos. `iteracion.m` y `aceleracion.m` no tienen `max_iter` opcional; los parámetros por defecto viven dentro del cuerpo.
- **Sin tope de iteraciones.** Ninguna de las tres tiene `max_iter`. Si no converge, el script queda colgado en loop infinito. Elegí `x0` con criterio y una tolerancia razonable.
- **Precaución con `x0`.** En punto fijo, arrancá cerca del punto fijo o dentro del intervalo que dio el tanteo. En Newton, `x0` debe cumplir la condición de Fourier; si arrancás mal puede saltar a otra raíz o al punto donde `F'` se anula.
- **`tanteo` puede no encontrar nada.** Si `F` no cambia de signo en el rango, avisa y sigue; vas a tener que cargar `x0` a mano.

## Requisitos

- Octave (probado en 6.4.0) o MATLAB.
- Para el gráfico hace falta display gráfico. Con `octave-cli` en un entorno sin servidor gráfico, la figura no abre y `waitfor` queda esperando.