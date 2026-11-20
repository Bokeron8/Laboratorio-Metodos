# Informe — Guía 5: Interpolación numérica

**Alumnos:** Franco Zambrano · Gabriel Bazzola

Métodos Computacionales · Laboratorio 5 · Octave 6.4.0

---

## Introducción

El laboratorio resuelve el problema inverso de la tabla: dado un conjunto de
puntos, hallar el valor de la función en un punto intermedio (interpolación) o el
valor de la variable que produce un valor dado (problema inverso). Se trabaja con
datos equidistantes (fórmulas de Newton-Gregory ascendente y descendente) y con
datos no equidistantes (Lagrange e interpolación parabólica progresiva).

Los scripts no piden datos por teclado: cada uno trae la tabla del enunciado
definida en el código. Por eso las capturas de consola salen completas con una
ejecución directa.

Un dato útil para leer los resultados: las tablas de los ejercicios 1, 2, 3 y 4
provienen de funciones conocidas. En el ejercicio 1, `y = cos(x)` con `x` en
grados; en el 3, `y = 1 + √x`. Conocer el valor exacto permite medir el error de
cada método, no sólo compararlos entre sí.

---

## Ejercicio 1 — Interpolación en intervalos regularmente espaciados

### Consigna

Con la tabla

| x | 15 | 25 | 35 | 45 | 55 | 65 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| y | 0,965926 | 0,906308 | 0,819152 | 0,707107 | 0,573576 | 0,422618 |

a) Newton-Gregory Ascendente para `x = 17`; b) Newton-Gregory Descendente para
`x = 60`; c) interpolación inversa lineal y cuadrática para `y = 0,90728517`.

### Código — `01-intervalos-espaciados.m`

{{CODE:01-intervalos-espaciados.m}}

### Salida de ejecución

![Salida del ejercicio 1]({{IMG:ej1-consola}})

### Análisis

**a) Ascendente en `x = 17`.** Resultado `y(17) = 0,956305`. Como la tabla es
`y = cos(x)` en grados, el valor exacto es `cos(17°) = 0,9563048`: el error es
`2,4e−7`. La fórmula ascendente es la correcta aquí, porque 17 está cerca del
primer nodo (`x₁ = 15`) y `p = (17 − 15)/10 = 0,2` es pequeño.

**b) Descendente en `x = 60`.** Resultado `y(60) = 0,499999`, contra un exacto de
`cos(60°) = 0,5`: error `1,0e−6`. De nuevo la elección es la adecuada: 60 está
cerca del último nodo (`x₆ = 65`) y la fórmula descendente trabaja con
`p = (60 − 65)/10 = −0,5`.

**c) Interpolación inversa.** Para `y = 0,90728517`, el valor exacto de la
variable es `arccos(0,90728517) = 24,8672°`.

| Método | x hallado | Error |
| :--- | :---: | :---: |
| Inversa lineal | 24,836095 | 0,0311 |
| Inversa cuadrática | 24,856786 | 0,0104 |

La cuadrática reduce el error a un tercio. El motivo: la inversa lineal usa dos
puntos y asume que la función es recta entre ellos, mientras que la cuadrática
usa tres y reproduce la curvatura de `cos(x)`.

---

## Ejercicio 2 — Censo de población

### Consigna

Con los datos censales de Estados Unidos (1940-1990), usar Lagrange para estimar
la población de 1965 y comparar con el valor real, 189 703 000 habitantes.

| Año | 1940 | 1950 | 1960 | 1970 | 1980 | 1990 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Población (miles) | 132,165 | 151,326 | 179,323 | 203,302 | 226,542 | 249,633 |

### Código — `02-censo-poblacion.m`

{{CODE:02-censo-poblacion.m}}

### Salida de ejecución

![Salida del ejercicio 2]({{IMG:ej2-consola}})

### Análisis

Lagrange estima `191 767,359` miles de habitantes para 1965, contra un valor real
de `189 703,000`:

| | Población 1965 (miles) |
| :--- | :---: |
| Lagrange (grado 5) | 191 767,359 |
| Valor real | 189 703,000 |
| Error absoluto | 2 064,359 |
| Error relativo | 1,0882 % |

El error es del 1 %, razonable para una estimación con datos decenales, pero no
despreciable: el polinomio de grado 5 pasa exactamente por los seis puntos y
oscila entre ellos. 1965 cae en el medio de 1960 y 1970, justamente donde la
oscilación más puede apartarse de la tendencia real.

Dos razones explican el resultado. Primera, el crecimiento de la población no es
polinómico: entre 1940 y 1990 la población creció un 89 %, con una desaceleración
en los años 60 que un polinomio de grado 5 no reproduce. Segunda, con puntos
equidistantes y una función suave, el método de Newton-Gregory daría lo mismo que
Lagrange (son el mismo polinomio); la ventaja de Lagrange acá es sólo que no
require previa equidistancia, y no la hay.

---

## Ejercicio 3 — Polinomio de Lagrange en datos no equidistantes

### Consigna

Con la tabla

| x | 0 | 0,4 | 0,75 | 1,5 | 2,0 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| y | 1 | 1,63246 | 1,86603 | 2,22474 | 2,41421 |

a) interpolar en `x = 1`; b) interpolar en `x = 0,45`.

### Código — `03-polinomio-lagrange.m`

{{CODE:03-polinomio-lagrange.m}}

### Salida de ejecución

![Salida del ejercicio 3]({{IMG:ej3-consola}})

### Análisis

La tabla responde a `y = 1 + √x`, así que los valores exactos son conocidos.

| x | Lagrange | Exacto (`1 + √x`) | Error |
| :---: | :---: | :---: | :---: |
| 1,0 | 1,978755 | 2,000000 | 0,021245 |
| 0,45 | 1,677126 | 1,670820 | 0,006306 |

El error en `x = 1` es 3,4 veces mayor que en `x = 0,45`. La causa es la posición
del punto respecto de los datos: 0,45 está entre 0,4 y 0,75, muy cerca del nodo
0,4, mientras que 1 está entre 0,75 y 1,5, en un intervalo más ancho y más
alejado de los extremos. El polinomio de Lagrange usa los cinco puntos, pero su
error depende de dónde se evalúe.

Un detalle de método: Lagrange no necesita que los datos sean equidistantes, y por
eso es el método indicado en este ejercicio. El precio es que cada evaluación
combina los cinco puntos; con datos equidistantes, Newton-Gregory construye el
mismo polinomio con una tabla de diferencias y menos cuentas.

---

## Ejercicio 4 — Densidad del sodio

### Consigna

Con las densidades experimentales del sodio, aplicar Lagrange y interpolación
parabólica progresiva para `T = 275°` y estimar el error.

| Temperatura | 102 | 245 | 327 | 423 | 565 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Densidad | 0,564642 | 0,644218 | 0,717356 | 0,783327 | 0,853329 |

### Código — `04-densidad-sodio.m`

{{CODE:04-densidad-sodio.m}}

### Salida de ejecución

![Salida del ejercicio 4]({{IMG:ej4-consola}})

### Análisis

| Método | Densidad en 275° | Puntos usados |
| :--- | :---: | :--- |
| Lagrange | 0,671670 | los 5 (grado 4) |
| Parabólica progresiva | 0,668650 | 102, 245 y 327 (grado 2) |
| Diferencia | 0,003020 | — |

La diferencia es `0,00302`, el 0,45 % del valor: los dos métodos coinciden en las
primeras dos cifras y se separan en la tercera.

La interpolación parabólica progresiva toma los tres puntos consecutivos que
contienen al 275 (102, 245 y 327) y ajusta una parábola local. Lagrange, en
cambio, usa los cinco puntos y ajusta un polinomio de grado 4 que también reproduce
la zona de 423 y 565, donde la densidad sigue subiendo. Si los datos tienen error
experimental, el polinomio de grado 4 lo arrastra y puede oscilar; la parábola
local es más robusta porque sólo mira la zona del punto pedido.

El resultado de la parábola (0,66865) está más cerca de la tendencia de los datos
inmediatos; el de Lagrange (0,67167) queda arrastrado por los puntos altos. Sin un
valor de referencia no se puede decir cuál es "el correcto", pero la comparación
es la que pide la consigna y sirve para estimar el orden del error.

---

## Conclusiones

1. **Elegir el método según la estructura de los datos.** Con valores
   equidistantes, Newton-Gregory (ascendente cerca del primer nodo, descendente
   cerca del último) es directo y barato; con valores no equidistantes, Lagrange.
   En el ejercicio 1, la elección de ascendente o descendente no cambió el
   resultado (ambos dieron el valor exacto con error `1e−6`), pero sí importa
   mantener `p` pequeño.

2. **La interpolación inversa necesita monotonicidad local.** Para hallar `x` a
   partir de `y` se busca el tramo donde la función cruza el valor pedido; en el
   ejercicio 1 la inversa cuadrática mejoró la lineal de 0,031 a 0,010 grados.

3. **El error depende de dónde se evalúe.** En el ejercicio 3 el error en
   `x = 0,45` (cerca de un nodo) fue 0,0063 y en `x = 1` (en un intervalo ancho)
   0,0212, con el mismo polinomio. Interpolar cerca de los datos es más seguro que
   interpolar en huecos grandes.

4. **Grado alto no siempre ayuda.** En el ejercicio 2, el polinomio de grado 5
   dio un error del 1 % en 1965; en el 4, el grado 4 de Lagrange se separó un
   0,45 % de la parábola local de grado 2. Un polinomio que pasa por todos los
   puntos puede oscilar entre ellos si los datos tienen ruido.

5. **La comparación entre métodos es la única referencia disponible.** Cuando no
   se conoce la función (como en el ejercicio 4), comparar dos métodos de distinto
   grado da un orden de magnitud del error: acá `3e−3`.

---

## Anexo — Funciones

### `newton_gregory_ascendente.m`

Tabla de diferencias finitas hacia adelante y evaluación del polinomio de Newton
en `p = (x − x₁)/h`.

{{CODE:newton_gregory_ascendente.m}}

### `newton_gregory_descendente.m`

Tabla de diferencias finitas hacia atrás y evaluación en `p = (x − xₙ)/h`.

{{CODE:newton_gregory_descendente.m}}

### `interpolacion_inversa_lineal.m`

Busca el tramo donde `y` cruza el valor pedido y resuelve la recta entre los dos
puntos.

{{CODE:interpolacion_inversa_lineal.m}}

### `interpolacion_inversa_cuadrática.m`

Busca los tres puntos más cercanos al valor pedido y resuelve la parábola que pasa
por ellos.

{{CODE:interpolacion_inversa_cuadratica.m}}

### `lagrange.m`

Polinomio interpolador de Lagrange para datos no equidistantes.

{{CODE:lagrange.m}}

### `interpolacion_parabolica_progresiva.m`

Interpolación cuadrática local con tres puntos consecutivos.

{{CODE:interpolacion_parabolica_progresiva.m}}
