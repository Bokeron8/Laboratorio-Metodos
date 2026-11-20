# Informe — Guía 6: Derivación e integración numérica

**Alumnos:** Franco Zambrano · Gabriel Bazzola

Métodos Computacionales · Laboratorio 6 · Octave 6.4.0

---

## Introducción

El laboratorio trabaja sobre dos operaciones que no se pueden hacer exactamente con
tablas de datos: derivar e integrar. La derivación se aproxima con las fórmulas de
Newton-Gregory (ascendente y descendente) sobre la tabla de diferencias finitas, y
la integración con las reglas de Trapecios, Simpson 1/3 y Simpson 3/8, combinadas
cuando la cantidad de intervalos no permite aplicar una sola.

Todos los scripts piden los datos por teclado y, si se presiona **Enter**, usan los
valores del enunciado. Las capturas de consola corresponden a una ejecución no
interactiva con esos valores; por eso se omite la línea de preguntas de `input`.

Una advertencia que aparece en las capturas de este laboratorio: el ingreso de
vectores por teclado necesita los corchetes (`[12 13 14 15 16 17]`), porque Octave
lee la línea con `input` como una expresión.

---

## Ejercicio 1 — Derivación con Newton-Gregory

### Consigna

Con la tabla

| x | 12 | 13 | 14 | 15 | 16 | 17 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| y | 0,96262 | 0,94718 | 0,93108 | 0,92221 | 0,91181 | 0,90151 |

a) construir la tabla de diferencias; b) calcular `f'(12)` con la fórmula
ascendente; c) calcular `f'(12,4)` y comparar ambas fórmulas; d) calcular `f''(17)`
con la fórmula descendente.

### Código — `01-derivacion-newton-gregory.m`

{{CODE:01-derivacion-newton-gregory.m}}

### Salida de ejecución

![Salida del ejercicio 1]({{IMG:ej1-consola}})

### Análisis

**Tabla de diferencias.** El script construye la tabla hacia adelante y la imprime
en forma triangular: las diferencias descendentes se leen sobre la diagonal
inferior derecha (`nabla^1 y = −0,0103`, `nabla^2 y = 0,0001`, y así hasta
`nabla^5 y = 0,02704`).

**b) `f'(12)` ascendente.** El resultado es `f'(12) = −0,00290950`. El script
además muestra la sensibilidad a la cantidad de puntos:

| Puntos | `f'(12)` |
| :---: | :---: |
| 2 | −0,01544000 |
| 3 | −0,01511000 |
| 4 | −0,01248000 |
| 5 | −0,00831750 |
| 6 | −0,00290950 |

Con dos puntos la derivada es simplemente el cociente incremental
`(y₂ − y₁)/h = −0,01544`, y cada punto adicional la corrige. Con los seis puntos
el valor cae a −0,00291: el polinomio de grado 5 se aparta mucho de la recta
secante, así que el resultado depende fuertemente de cuántos términos se usan.
Esa es la limitación de derivar con diferencias finitas sobre una tabla corta.

**c) `f'(12,4)` con ambas fórmulas.** Ascendente y descendente dan exactamente el
mismo valor, `−0,01575864`, con una diferencia de `1,56e−16` (cero en precisión de
máquina). No es casualidad: con una tabla equidistante, el polinomio de Newton
ascendente y el descendente son el **mismo polinomio** expresado en potencias de
`p = (x − x₁)/h` o de `p = (x − xₙ)/h`. Cambiar de fórmula no cambia el
polinomio interpolante, sólo el punto desde donde se lo escribe.

La comparación pedida entre `f'(12)` y `f'(12,4)` da `1,28e−02`: la derivada
cambia de signo magnitud en ese tramo, lo que confirma que la función tiene
curvatura apreciable.

**d) `f''(17)` descendente.** Resultado: `f''(17) = 0,03378750`. La sensibilidad
vuelve a ser grande: con 3 puntos `f'' = 0,0001`, con 4 puntos `0,00173`, con 5
puntos `0,01125` y con 6 puntos `0,03379`. La segunda derivada es más sensible que
la primera, porque cada diferencia dividida amplifica el error de los datos: acá
`f''` se obtiene de la segunda diferencia dividida por `h²`, y `h = 1` no atenúa
nada.

---

## Ejercicio 2 — Integral de la tabla de corriente

### Consigna

Calcular `∫ f(x) dx` sobre la tabla

| t | 0 | 0,1 | 0,2 | 0,3 | 0,4 | 0,5 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| i | 0,0 | 0,15 | 0,3 | 0,55 | 0,73 | 0,81 |

seleccionando adecuadamente entre Trapecios y Simpson, y combinando fórmulas.

### Código — `02-integral-tabla-corriente.m`

{{CODE:02-integral-tabla-corriente.m}}

### Salida de ejecución

![Salida del ejercicio 2]({{IMG:ej2-consola}})

### Análisis

La tabla tiene **5 intervalos** (n = 5), un número impar: Simpson 1/3 necesita un
número par y Simpson 3/8 un múltiplo de 3, así que ninguna de las dos se puede
aplicar sobre todo el intervalo. El script lo informa y pasa a las combinaciones.

| Método | Integral |
| :--- | :---: |
| Trapecios (todo el intervalo) | 0,21350000 |
| Simpson 3/8 en [0; 0,3] + Simpson 1/3 en [0,3; 0,5] | 0,21391667 |
| Simpson 1/3 en [0; 0,4] + Trapecios en [0,4; 0,5] | 0,21466667 |

Las tres difieren en menos de `1,2e−3` (0,5 %), lo que muestra que la integral
está bien determinada por los datos y que la elección de la combinación cambia
poco. La combinación automática del script (3/8 + 1/3) queda entre las otras dos.

Trapecios resulta el valor más bajo: al aproximar con rectas un tramo donde la
curva es convexa, la regla del trapecio queda por debajo. Eso es consistente con
la forma de los datos, que crecen cada vez más lento.

---

## Ejercicio 3 — Integral de la tabla del Ejercicio 1

### Consigna

Con la tabla del Ejercicio 1, calcular `∫₁₂¹⁷ f(x) dx` seleccionando adecuadamente
entre Trapecios y Simpson.

### Código — `03-integral-tabla-ejercicio1.m`

{{CODE:03-integral-tabla-ejercicio1.m}}

### Salida de ejecución

![Salida del ejercicio 3]({{IMG:ej3-consola}})

### Análisis

De nuevo 5 intervalos, así que Simpson 1/3 no aplica sobre todo el intervalo y el
script prueba las dos ubicaciones posibles para el intervalo que queda fuera:

| Combinación | Integral |
| :--- | :---: |
| Trapecios (todo el intervalo) | 4,64434500 |
| Simpson 1/3 en [12; 16] + Trapecios en [16; 17] | 4,64471000 |
| Trapecios en [12; 13] + Simpson 1/3 en [13; 17] | 4,64312333 |

La diferencia entre las dos opciones es `1,59e−3`, el 0,03 % del valor: ambas son
igualmente defendibles y la consigna no determina cuál usar. La Opción A deja el
intervalo corto al final, donde la tabla termina; la Opción B lo deja al principio.

Trapecios puro da 4,64435, apenas por encima de la Opción B y por debajo de la A.
Con una función suave como esta, el error de Trapecios compuesto es del orden de
`h²` con `h = 1`, o sea del orden de la décima: los tres valores coinciden en las
primeras tres cifras.

---

## Ejercicio 4 — Combinación de las dos fórmulas de Simpson

### Consigna

Resolver la misma integral del ejercicio anterior combinando las dos fórmulas de
Simpson y comparar con lo obtenido antes.

### Código — `04-combinacion-simpson.m`

{{CODE:04-combinacion-simpson.m}}

### Salida de ejecución

![Salida del ejercicio 4]({{IMG:ej4-consola}})

### Análisis

Con 5 intervalos, la partición natural es 3 + 2: tres intervalos para Simpson 3/8
y dos para Simpson 1/3, en cualquiera de los dos órdenes.

| Combinación | Integral |
| :--- | :---: |
| Simpson 3/8 en [12; 15] + Simpson 1/3 en [15; 17] | 4,64350708 |
| Simpson 1/3 en [12; 14] + Simpson 3/8 en [14; 17] | 4,64463375 |

La diferencia entre los dos órdenes es `1,13e−3`, y la Opción B coincide con la
combinación de Simpson 1/3 + Trapecios del ejercicio anterior con una diferencia de
`7,6e−5`. El valor de referencia, si se toma el promedio de todos los métodos, es
`4,6441`, y todos los resultados caen dentro de `±1,6e−3`.

Lo importante es que con los **mismos datos** y **el mismo número de intervalos**
cambiar la fórmula o el orden de la partición mueve el resultado en la cuarta
cifra. No hay un "valor correcto" de la tabla: lo que se compara es la
**consistencia** entre métodos, y acá es del orden del 0,03 %.

---

## Pruebas de verificación

### Código — `05-pruebas.m`

{{CODE:05-pruebas.m}}

### Salida de ejecución

![Salida de las pruebas]({{IMG:pruebas-consola}})

### Análisis

El script verifica los algoritmos contra funciones de valor conocido:

| Función | Método | Valor | Error |
| :--- | :--- | :---: | :---: |
| `x³` | `f'(1)` ascendente | 3,0000000000 | 1,16e−14 |
| `x³` | `f''(1)` ascendente | 6,0000000000 | 2,72e−13 |
| `e^x` | `f'(0)` ascendente | 1,0000020692 | 2,07e−06 |
| `x²` en [0; 1] | Trapecios | 0,3350000000 | 1,67e−03 |
| `x²` en [0; 1] | Simpson 1/3 | 0,3333333333 | 0 |
| `x²` en [0; 1] | Simpson 3/8 | 0,2430000000 | 8,33e−17 |
| `sen(x)` en [0; π] | Trapecios | 1,9885637766 | 1,14e−02 |
| `sen(x)` en [0; π] | Simpson 1/3 | 2,0000526243 | 5,26e−05 |
| `sen(x)` en [0; π] | Simpson 3/8 | 2,0001193864 | 1,19e−04 |

Dos conclusiones:

1. **Las derivadas son exactas para polinomios de grado suficiente.** Con `x³` el
   error es de redondeo (`1e−14`), porque el polinomio de Newton de grado 3
   interpola exactamente a `x³` y su derivada también es exacta. Con `e^x`, que no
   es polinomio, el error sube a `2,07e−06`: es el error de truncamiento.
2. **Para integrar, Simpson gana por mucho.** En `sen(x)` el error de Trapecios es
   `1,14e−2` y el de Simpson 1/3 es `5,26e−5`: 200 veces menor con el mismo número
   de intervalos. Y Simpson 1/3 integra `x²` con error cero, como corresponde a
   una regla exacta hasta grado 3.

La última prueba combina las reglas sobre 11 intervalos de `x²` (3 + 8): el total
es `0,3333333333` con error `1,1e−16`. La combinación automática funciona.

---

## Conclusiones

1. **Derivar con una tabla corta es inestable.** En el ejercicio 1, `f'(12)` pasa
   de −0,01544 con dos puntos a −0,00291 con seis, y `f''(17)` de 0,0001 a 0,03379.
   La derivada segunda es la más sensible, porque usa diferencias divididas de
   orden superior. Con 6 datos, la derivada primera es defendible; la segunda
   depende demasiado de cuántos términos se tomen.

2. **Ascendente y descendente dan lo mismo.** Con datos equidistantes, ambas
   fórmulas construyen el mismo polinomio (ejercicio 1.c: diferencia `1,56e−16`).
   La elección entre una y otra importa por estabilidad numérica y por dónde cae el
   punto de evaluación, no por el resultado.

3. **La cantidad de intervalos manda en la integración.** Con 5 intervalos, ni
   Simpson 1/3 ni 3/8 aplican solas; hay que combinarlas o combinar con Trapecios.
   Las combinaciones posibles difieren entre sí en `1,6e−3` sobre un valor de 4,64
   (ejercicios 3 y 4), y Trapecios puro cae entre medio.

4. **El orden de la partición cambia la cuarta cifra.** En el ejercicio 4, poner
   Simpson 3/8 primero o segundo mueve el resultado en `1,13e−3`. Con los mismos
   datos no hay un valor "el correcto": lo que se evalúa es la consistencia entre
   métodos.

5. **Las reglas se ordenan por exactitud.** Las pruebas con valor conocido lo
   confirman: Simpson 1/3 tiene error `5,26e−5` donde Trapecios tiene `1,14e−2`, y
   ambas son exactas para polinomios del grado que corresponde. Elegir la regla
   según la suavidad de los datos y la cantidad de intervalos es lo que aporta
   precisión, no la cantidad de puntos.

---

## Anexo — Funciones

### `tabla_diferencias.m`

Construye la tabla de diferencias finitas hacia adelante a partir de `x` e `y`.

{{CODE:tabla_diferencias.m}}

### `mostrar_tabla_diferencias.m`

Imprime la tabla en forma triangular, con las diferencias de cada orden en su
columna.

{{CODE:mostrar_tabla_diferencias.m}}

### `newton_gregory_derivada.m`

Deriva el polinomio de Newton-Gregory en la variable auxiliar `p` y devuelve la
derivada del orden pedido, eligiendo la fórmula ascendente o descendente.

{{CODE:newton_gregory_derivada.m}}

### `trapecios.m`

Regla compuesta de los Trapecios.

{{CODE:trapecios.m}}

### `simpson_13.m`

Regla compuesta de Simpson 1/3; requiere un número par de intervalos.

{{CODE:simpson_13.m}}

### `simpson_38.m`

Regla compuesta de Simpson 3/8; requiere un número de intervalos múltiplo de 3.

{{CODE:simpson_38.m}}

### `integrar.m`

Selecciona la regla adecuada o combina Simpson 3/8 y Simpson 1/3 automáticamente
según la cantidad de intervalos.

{{CODE:integrar.m}}

### `leer_escalar.m`

Lee un escalar por teclado con valor por defecto al presionar Enter.

{{CODE:leer_escalar.m}}

### `leer_vector.m`

Lee un vector fila por teclado con valor por defecto.

{{CODE:leer_vector.m}}
