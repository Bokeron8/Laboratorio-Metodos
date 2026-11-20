# Informe — Guía 7: Integración numérica de ecuaciones diferenciales

**Alumnos:** Franco Zambrano · Gabriel Bazzola

Métodos Computacionales · Laboratorio 7 · Octave 6.4.0

---

## Introducción

El objetivo del laboratorio es resolver problemas de valor inicial con métodos
numéricos de un paso (Euler, Euler modificado, Runge-Kutta de 2do y 4to orden) y
con un método de pasos múltiples que no arranca por sí mismo (Milne), y analizar
cómo influyen el orden del método y el tamaño de paso en el error de
truncamiento global.

Todos los scripts piden los datos por teclado y muestran los resultados con
leyendas. Si se presiona **Enter** sin escribir nada, se usan los valores del
enunciado. Las capturas de consola de este informe corresponden a una ejecución
no interactiva con esos mismos valores, por eso no se ve la línea de preguntas de
`input`.

Convenciones adoptadas, siguiendo la teoría de la cátedra:

- **Euler modificado**: predictor-corrector, con el corrector iterado hasta que
  dos correcciones consecutivas difieran en menos que la tolerancia `E`.
- **Runge-Kutta de 2do orden**: forma de Heun, una sola pasada. Es el mismo
  esquema que el Euler modificado cuando no se itera el corrector.
- **Milne**: predictor 10.5 y corrector 10.6, con el corrector iterado hasta
  `E`. Necesita los cuatro primeros valores ya calculados por otro método.

Cuando la ecuación no tiene solución exacta elemental (`y' = x² + y²`), se usa
Runge-Kutta de 4to orden con paso muy fino como referencia.


## Ejercicio 1 — Euler y Euler modificado

### Consigna

Resolver `y' = x² + y²` con `x0 = 0`, `y0 = 1` y `h = 0,2` en el intervalo
`(0; 0,6)`:

a) con el método de Euler;
b) con el método modificado de Euler, con `E < 0,001`.

### Código — `01-euler-y-euler-modificado.m`

{{CODE:01-euler-y-euler-modificado.m}}

### Salida de ejecución

![Salida del ejercicio 1]({{IMG:ej1-consola}})

### Análisis

La comparación con la referencia de Runge-Kutta 4 de paso fino (`h = 0,0005`)
muestra el signo y la magnitud del error de cada método:

| x | Euler | E. modificado | Referencia RK4 | Error de Euler | Error de E. modificado |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 0,0 | 1,000000 | 1,000000 | 1,000000 | 0,000000 | 0,000000 |
| 0,2 | 1,200000 | 1,263440 | 1,253017 | −0,053017 | +0,010423 |
| 0,4 | 1,496000 | 1,748681 | 1,696111 | −0,200111 | +0,052570 |
| 0,6 | 1,975603 | 3,015107 | 2,644000 | −0,668397 | +0,371107 |

Euler se queda corto en todo el intervalo: el error crece de 0,05 a 0,67 a
medida que avanza `x`. El modificado, en cambio, se pasa, porque el corrector
iterado resuelve la ecuación implícita del trapecio y sobrecorrige cuando la
derivada crece rápido. En valor absoluto el modificado es más exacto en el
último punto (0,371 contra 0,668), pero con el signo cambiado.

El número de correcciones que necesita el corrector por paso (4, 6 y 12) es una
señal de lo mismo: cuanto más rápido crece `y`, más lejos queda el predictor del
valor corregido y más iteraciones hacen falta para bajar de `E = 0,001`.

La causa de fondo es que esta ecuación no tiene solución exacta elemental y su
solución desarrolla una asíntota vertical cerca de `x ≈ 0,97`. Un paso de 0,2 es
muy grueso para una función que crece de forma explosiva, así que el error de
truncamiento se amplifica en cada paso.


## Ejercicio 2 — Crecimiento de una población

### Consigna

Resolver `P'(t) = γ·P(t) − τ·P(t)²` con `P(0) = P0` en el intervalo `(0; 2)`,
para `γ = 3`, `τ = 0,1` y `P(0) = 5`:

a) con el método de Euler, con `h = 0,5` y `h = 0,25`;
b) comparar con la solución exacta
`P(t) = γ / (τ + (γ/P0 − τ)·e^(−γ·t))`.

### Código — `02-crecimiento-poblacional.m`

{{CODE:02-crecimiento-poblacional.m}}

### Salida de ejecución

![Salida del ejercicio 2]({{IMG:ej2-consola}})

### Gráfico

![Solución numérica y error absoluto del ejercicio 2]({{IMG:ej2-grafico}})

### Análisis

| h | Error máximo en el intervalo |
| :---: | :---: |
| 0,5 | 2,930034 |
| 0,25 | 1,611674 |

Al reducir el paso a la mitad, el error máximo se reduce a la mitad
(`2,93 / 1,61 ≈ 1,8`): el método de Euler es de **primer orden**, su error de
truncamiento global es proporcional a `h`.

Con `h = 0,5` el error es grande en el tramo de crecimiento rápido y se nota
también en la forma de la curva: Euler llega a `t = 2` con `P = 29,604`, mientras
que la exacta vale `29,633`. Con `h = 0,25` la curva numérica se pega a la exacta
y el error máximo baja a 1,61.

Las dos soluciones tienden al mismo valor de equilibrio `γ/τ = 30`, que es el
punto donde `P' = 0`. Eso no lo aporta el método: es una propiedad del modelo
logístico, y sirve de control de que la integración no se está yendo a cualquier
lado.


## Ejercicio 3 — Runge-Kutta de 2do y 4to orden

### Consigna

Sobre la misma ecuación del ejercicio 1 (`y' = x² + y²`, `y(0) = 1`, `h = 0,2`,
intervalo `(0; 0,6)`):

a) resolver con Runge-Kutta de 2do orden;
b) resolver con Runge-Kutta de 4to orden;
c) comparar 3.a con el Euler modificado de 1.b y sacar conclusiones sobre los
errores.

### Código — `03-runge-kutta.m`

{{CODE:03-runge-kutta.m}}

### Salida de ejecución

![Salida del ejercicio 3]({{IMG:ej3-consola}})

### Análisis

| x | RK2 | Euler modificado (1.b) | RK4 | Referencia fina | Error RK2 | Error RK4 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 0,2 | 1,248000 | 1,263440 | 1,252991 | 1,253017 | −0,005017 | −0,000026 |
| 0,4 | 1,669456 | 1,748681 | 1,695920 | 1,696111 | −0,026655 | −0,000191 |
| 0,6 | 2,510415 | 3,015107 | 2,642110 | 2,644000 | −0,133585 | −0,001890 |

RK2 se queda corto y el Euler modificado iterado se pasa: en `x = 0,6` la
diferencia entre ambos es `−0,504691`, mucho mayor que el error de cualquiera de
los dos contra la referencia. La razón es la que imprime el propio script: RK2
es el Euler modificado con **una sola** corrección, mientras que 1.b itera el
corrector hasta `E < 0,001` y termina resolviendo otra ecuación, la del trapecio,
con otra constante de error.

RK4 es el más preciso de los tres con el mismo paso: su error en `x = 0,6` es
`−0,001890`, unas 70 veces menor que el de RK2 y unas 200 veces menor que el del
Euler modificado. Ese es el efecto del orden: RK4 es de cuarto orden y su error
global va como `h⁴`, así que con `h = 0,2` ya compite con métodos de menor orden
usando pasos mucho más chicos.


## Ejercicio 4 — Vaciado de un tanque (complementario)

### Consigna

La tasa a la que baja el nivel de agua en un tanque cilíndrico es
`dy/dt = −k·√y`, con `k = 0,06`, nivel inicial `y(0) = 3 m` y `t` en minutos.
Determinar cuánto tarda en vaciarse aplicando el método de Euler con paso de
0,5 minutos.

### Código — `04-tanque-drenaje.m`

{{CODE:04-tanque-drenaje.m}}

### Salida de ejecución

![Salida del ejercicio 4]({{IMG:ej4-consola}})

### Gráfico

![Vaciado del tanque: Euler contra la solución exacta]({{IMG:ej4-grafico}})

### Análisis

La ecuación se integra analíticamente:

```
y(t) = ( √y0 − k·t/2 )²      →      se vacía en t = 2·√y0 / k = 57,7350 min
```

El script no integra hasta ese instante sino hasta que el nivel calculado cruza
cero, y estima el instante de vaciado interpolando linealmente entre el último
nivel positivo y el primero no positivo:

| | Tiempo de vaciado |
| :--- | :---: |
| Euler con `h = 0,5` min | 56,3032 min |
| Solución exacta | 57,7350 min |
| Error absoluto | 1,4318 min (2,5 %) |

El último nivel positivo calculado es `y = 0,000331 m` en `t = 56,00 min`, así
que el cruce se interpola en ese último paso.

El error tiene signo definido: Euler subestima el nivel del agua en todo el
recorrido y por eso el tanque se vacía **antes** de lo que corresponde. La
explicación está en la curvatura: como `y'' = k²/2 > 0`, la solución exacta es
convexa, y cada recta de Euler (la tangente) queda por debajo de la curva. Como
`|y'| = k·√y` es menor cuanto menor es `y`, el método drena cada vez más despacio
de lo que debería, pero el déficit acumulado hace que llegue a cero antes.

Con `h = 0,5` sobre un intervalo de casi 58 minutos se dan más de 110 pasos, y el
error final del 2,5 % es coherente con un método de primer orden.


## Ejercicio 5 — Milne a partir de Runge-Kutta 2

### Consigna

Completar la tabla `x / y / y'` con los resultados de 3.a y, a partir de ellos,
calcular con el método de Milne la solución en `x = 0,8` y en `x = 1`.

### Código — `05-milne-tabla.m`

{{CODE:05-milne-tabla.m}}

### Salida de ejecución

![Salida del ejercicio 5]({{IMG:ej5-consola}})

### Análisis

| x | y | y' = x² + y² | Origen |
| :---: | :---: | :---: | :--- |
| 0,0 | 1,00000000 | 1,00000000 | RK2 (3.a) |
| 0,2 | 1,24800000 | 1,59750400 | RK2 (3.a) |
| 0,4 | 1,66945628 | 2,94708426 | RK2 (3.a) |
| 0,6 | 2,51041548 | 6,66218589 | RK2 (3.a) |
| 0,8 | 6,50765178 | 42,98953173 | Milne |

Milne calcula `y(0,8) = 6,50765178` y necesita **35** correcciones del corrector
para bajar de `E = 0,001`. Ese número es la evidencia más clara del
comportamiento del método en este problema: el predictor se aleja muchísimo del
valor correcto porque la derivada ya vale casi 43 en `x = 0,8` y cambia muy
rápido de un punto al siguiente.

El segundo valor pedido, `y(1)`, **no existe**. La solución de `y' = x² + y²` con
`y(0) = 1` tiene una asíntota vertical antes de `x = 1`: el script lo verifica
con RK4 de paso fino y obtiene `y(0,90) ≈ 14,30`, `y(0,95) ≈ 50,47` y
`y(0,96) ≈ 101,93`, valores que se disparan. El corrector de Milne no converge y
el script documenta el motivo en lugar de imprimir un número sin sentido. El
intervalo de la consigna excede el dominio de la solución.


## Ejercicio 6 — Euler modificado y Milne sobre una ecuación lineal

### Consigna

Resolver `y' = 3x + 3y` con `y(0) = 1` en `(0; 0,3)`:

a) con el método modificado de Euler y pasos `h = 0,1` y `h = 0,05`, para hallar
los valores iniciales;
b) con el método de Milne para calcular `y` en `x = 0,20` y `x = 0,25`;
c) calcular los errores cometidos, sabiendo que
`y = (4/3)·e^(3x) − x − 1/3`.

### Código — `06-milne-edo-lineal.m`

{{CODE:06-milne-edo-lineal.m}}

### Salida de ejecución

![Salida del ejercicio 6]({{IMG:ej6-consola}})

### Gráfico

![Solución numérica y error absoluto del ejercicio 6]({{IMG:ej6-grafico}})

### Análisis

Con `h = 0,1` los cuatro primeros valores llegan sólo hasta `x = 0,3`, que es el
extremo del intervalo: Milne necesita cuatro puntos previos y el primero que
calcularía quedaría fuera del intervalo pedido. Por eso el arranque se toma del
cálculo con `h = 0,05`, que da los cuatro valores hasta `x = 0,15`.

Errores del arranque (Euler modificado):

| x | h = 0,1 | h = 0,05 |
| :---: | :---: | :---: |
| 0,10 | 4,074090e−03 | 1,000210e−03 |
| 0,20 | 1,101134e−02 | 2,701036e−03 |
| 0,30 | 2,232088e−02 | 5,470545e−03 |

Al dividir el paso por dos el error baja aproximadamente cuatro veces
(`1,10e−2 / 2,70e−3 ≈ 4,1`): el Euler modificado con corrector iterado es de
**segundo orden**.

Errores de Milne en los puntos pedidos:

| x | Milne | Exacta | Error | Correcciones |
| :---: | :---: | :---: | :---: | :---: |
| 0,20 | 1,89763066 | 1,89615840 | 1,472259e−03 | 2 |
| 0,25 | 2,24156929 | 2,23933336 | 2,235936e−03 | 2 |

En este problema, lineal y suave, Milne funciona bien: necesita sólo 2
correcciones por paso y en `x = 0,20` su error (`1,47e−3`) es casi la mitad del
que deja el arranque de Euler modificado con el mismo paso (`2,70e−3`). La
diferencia con el ejercicio 5 es la derivada: acá crece suave y acotada, allá
explota.


## Conclusiones

1. **Orden del método.** El error de truncamiento global de Euler se reduce a la
   mitad cuando el paso se reduce a la mitad (ejercicio 2: 2,93 → 1,61), lo que
   confirma el primer orden. El Euler modificado con corrector iterado es de
   segundo orden (ejercicio 6: el error se divide por 4 al dividir `h` por 2) y
   RK4 es de cuarto orden: con el mismo `h = 0,2` del ejercicio 3 su error es
   unas 70 veces menor que el de RK2.

2. **Costo contra precisión.** RK4 logra esa exactitud con cuatro evaluaciones
   de `f` por paso; el Euler modificado iterado necesita entre 4 y 35
   correcciones según el problema. Cuando la derivada crece rápido, el costo del
   corrector se dispara y no compensa: en el ejercicio 1 el modificado terminó
   con más error que RK2 pese a iterar más.

3. **Métodos que no arrancan por sí mismos.** Milne necesita cuatro valores
   previos, y esos valores condicionan todo lo que sigue: en el ejercicio 6 el
   arranque con `h = 0,05` fue obligatorio porque con `h = 0,1` no quedaban
   puntos dentro del intervalo. El error del arranque se propaga a los pasos
   posteriores.

4. **El dominio de la solución manda.** Ningún método arregla una solución que no
   existe: `y' = x² + y²` con `y(0) = 1` tiene una asíntota vertical cerca de
   `x ≈ 0,97`, y por eso `y(1)` no se puede calcular (ejercicio 5) y los errores
   de todos los métodos crecen fuerte al acercarse a ese punto (ejercicios 1 y
   3). Antes de elegir el paso hay que saber hasta dónde la solución está
   definida.

5. **Interpretación física.** En el tanque (ejercicio 4) el error de Euler tiene
   signo predecible por la convexidad de la solución, y el tiempo de vaciado sale
   2,5 % corto. En el modelo logístico (ejercicio 2) los dos pasos convergen al
   mismo equilibrio `γ/τ = 30`, que es una propiedad del modelo y no del método:
   sirve como control de la integración.


## Anexo — Funciones de los métodos

### `euler.m`

Euler explícito: `y(i+1) = y(i) + h·f(x(i), y(i))`.

{{CODE:euler.m}}

### `euler_modificado.m`

Predictor-corrector: predice con Euler, corrige con el promedio de las pendientes
y repite la corrección hasta que dos iteraciones difieran en menos que `E`.
Devuelve además cuántas correcciones necesitó cada paso.

{{CODE:euler_modificado.m}}

### `runge_kutta_2.m`

Runge-Kutta de segundo orden en la forma de Heun, una sola pasada.

{{CODE:runge_kutta_2.m}}

### `runge_kutta_4.m`

Runge-Kutta de cuarto orden clásico, con los cuatro `k` evaluados en el paso.

{{CODE:runge_kutta_4.m}}

### `milne.m`

Predictor de Milne (fórmula 10.5) y corrector (fórmula 10.6), con el corrector
iterado hasta `E`. Recibe los cuatro primeros valores ya calculados.

{{CODE:milne.m}}

### `leer_escalar.m`

Lee un escalar por teclado y devuelve el valor por defecto si se presiona Enter.
Rechaza un vector, para que `0,2` no se interprete como `[0 2]`.

{{CODE:leer_escalar.m}}

### `leer_vector.m`

Lee un vector fila por teclado, con valor por defecto.

{{CODE:leer_vector.m}}
