# 1. Introducción

El presente trabajo tiene por objeto analizar, aplicar y comparar dos métodos
numéricos correspondientes a los temas 4 y 5 de la asignatura: el método de
Gauss-Jordan con pivoteo parcial para la resolución de sistemas de ecuaciones
lineales, y la interpolación lineal inversa para la determinación de una abscisa
a partir de un valor de ordenada tabulado.

Ambos métodos resuelven lo que, en sentido amplio, son problemas inversos. El
primero parte de una matriz de coeficientes y de un vector de términos
independientes y devuelve el vector de incógnitas. El segundo parte de una tabla
de valores y de una ordenada buscada y devuelve la abscisa que la produce. En los
dos casos la consigna exige que los datos se ingresen por teclado y que los
resultados se informen con leyendas apropiadas, condiciones que cumplen los
programas desarrollados.

La comparación no se hace sobre un único problema, sino sobre tres ejemplos
concretos: el sistema de tres ecuaciones del ejercicio resuelto de la práctica
06, el sistema de cuatro ecuaciones del Ejercicio 1 de la Guía de Actividades N°
4 y la tabla del Ejercicio 1 de la Guía N° 5. Así se puede observar, además, el
comportamiento del algoritmo de Gauss-Jordan frente a matrices de distinta
dimensión, tal como pide la consigna general de la guía.

Los algoritmos se implementaron en GNU Octave 6.4.0. El código se organiza en
dos funciones de método y dos archivos conductores: uno con un ejercicio fijo y
otro con un menú interactivo que pide los datos por teclado, valida las entradas
y captura los errores para volver al menú sin cerrar el programa.

El informe se organiza en cinco partes. La primera presenta los problemas y el
análisis teórico de cada método. La segunda incluye el código fuente completo.
La tercera expone los resultados de la ejecución con sus capturas. La cuarta
señala que no corresponde incluir gráficos. La quinta presenta las conclusiones
y la bibliografía.

---

# 2. Desarrollo

## 2.1 Métodos asignados. Análisis y comparación

### Problemas planteados

**Sistema de tres ecuaciones (práctica 06).** Se resolvió el sistema
`A·x = b` con

```
A = [18.72   8.20   8.76]        b = [121.280]
    [ 6.40  15.90   7.18]            [126.321]
    [ 5.22   6.40  14.31]            [118.522]
```

La matriz es dominante diagonal en sus tres filas, condición que favorece la
estabilidad numérica de cualquier método de eliminación. El resultado se
verificó sustituyendo en el sistema original.

**Sistema de cuatro ecuaciones (Guía 4, Ejercicio 1).** Corresponde al modelo
de la fórmula alimenticia para ganado. Las ecuaciones imponen los requerimientos
diarios de carbohidrato, proteína, vitamina y celulosa, y las incógnitas son los
kilogramos de maíz, desperdicio, alfalfa y cebada. Se ingresó por teclado la
matriz del enunciado para probar el algoritmo con otra dimensión.

**Problema inverso (Guía 5, Ejercicio 1.c).** Dada la tabla

| x | 15 | 25 | 35 | 45 | 55 | 65 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| y | 0.965926 | 0.906308 | 0.819152 | 0.707107 | 0.573576 | 0.422618 |

se pide el valor de `x` que corresponde a `y = 0.90728517`. Los datos son
`y = cos(x)` con `x` en grados, de modo que el valor buscado se puede contrastar
con `arccos(0.90728517)` expresado en grados.

### Método de Gauss-Jordan con pivoteo parcial

El método trabaja sobre la matriz ampliada `[A | b]` y transforma la matriz de
coeficientes en la identidad. Cuando termina, la última columna de la matriz
ampliada es directamente la solución: a diferencia de la eliminación de Gauss,
no hace falta una etapa de sustitución regresiva.

Para cada columna `k` se realizan tres operaciones. Primero se elige, entre las
filas que aún no se usaron como pivote, la de mayor valor absoluto en esa
columna. Este **pivoteo parcial** evita dividir por un coeficiente pequeño, que
amplificaría los errores de redondeo. Si el mayor valor absoluto es menor que
`1e−12`, la función informa que no existe solución única.

Luego se normaliza la fila pivote, dividiéndola por el coeficiente `a(kk)`, y se
elimina la incógnita `k` de **todas** las demás filas. La implementación sigue
las dos fórmulas que aparecen en el código:

* `b(i−1, j−1) = a(i, j) − a(1, j)·a(i, 1)/a(11)` para la eliminación, y
* `b(n, j−1) = a(1, j)/a(11)` para la normalización.

A medida que cada fila pivote se procesa, se reordena la matriz: las filas ya
resueltas se van a la parte inferior y las activas quedan arriba. Al finalizar,
la matriz reducida tiene la identidad en los primeros `n` renglones.

El costo del algoritmo es del orden de `n³` operaciones. En el sistema 3×3 el
paso a paso ocupa tres iteraciones; en el 4×4, cuatro, y cada iteración imprime
el valor de cada operación, razón por la cual las capturas se presentan en dos
partes. En aritmética exacta el método es directo: la solución obtenida no
depende de una tolerancia ni de una condición de convergencia, sino de que la
matriz sea invertible.

### Interpolación lineal inversa

La interpolación inversa invierte el papel de las variables: se conoce la
ordenada y se busca la abscisa. Dada una tabla `(x_i, y_i)` y un valor objetivo
`y*`, el algoritmo recorre los tramos consecutivos hasta encontrar el que
contiene a `y*` entre sus dos extremos. La comparación se hace con los dos
órdenes, porque la tabla puede ser creciente o decreciente.

En el tramo elegido se une con una recta a los puntos `(x_i, y_i)` y
`(x_{i+1}, y_{i+1})`. Con `h = x_{i+1} − x_i` y `delta_y = y_{i+1} − y_i`, se
despeja `x` de la semejanza de triángulos:

* `(x − x_i)/h = (y* − y_i)/delta_y`, de donde
* `x = x_i + h·(y* − y_i)/delta_y`.

El método es **local**: usa solamente dos puntos de la tabla, los del tramo que
contiene al valor buscado. No requiere que los datos estén equidistantes ni que
la tabla tenga un polinomio interpolante global.

Dos restricciones están implementadas como errores explícitos. Si `y*` cae
fuera del rango de la tabla, la función se niega a extrapolar, porque el
resultado no tendría respaldo en los datos. Si los dos valores de `y` del tramo
son iguales (`|delta_y| < 1e−12`), la recta es vertical y no se puede despejar
`x`. La validación vive en la función de método, no en el menú que la llama.

La exactitud depende de la curvatura de la función inversa dentro del tramo: si
la tabla creciera en forma casi lineal entre los dos puntos, el resultado sería
casi exacto; si tuviera mucha curvatura, la recta se apartaría de la curva real.
El error disminuye al achicar `h`.

### Análisis y comparación

| Aspecto | Gauss-Jordan | Interpolación inversa lineal |
| :--- | :--- | :--- |
| Tipo de problema | Sistema lineal `A·x = b` | Tabla de datos y ordenada dada |
| Naturaleza | Directo | Local sobre dos puntos |
| Datos de entrada | Matriz `A` y vector `b` | Vectores `x`, `y` y `y*` |
| Operación central | Pivoteo, eliminación y normalización | Despeje de `x` en la recta del tramo |
| Costo | Del orden de `n³` | Búsqueda lineal y una operación |
| Fuente de error | Redondeo acumulado | Curvatura de la tabla en el tramo |
| Condición de falla | Matriz singular o pivote nulo | `y*` fuera de rango o `delta_y = 0` |
| Resultado | Vector solución completo | Un solo valor de `x` |

La diferencia principal es el alcance: Gauss-Jordan produce todas las
incógnitas de una vez y su error está gobernado por la aritmética; la
interpolación inversa produce un solo número y su error está gobernado por los
datos. En esta última, mejorar el resultado no depende de iterar más, sino de
tener puntos más cercanos al valor buscado.

---

## 2.2 Código fuente

El programa se organiza en cuatro archivos. `principal.m` es una demostración
fija del sistema 3×3: define `A` y `b`, llama a la función, mide el tiempo con
`tic`/`toc`, imprime la matriz resultante y verifica la solución multiplicando
`A·x`. `menu_metodos.m` es el conductor interactivo: muestra las opciones, pide
los datos con valores por defecto y delega el cálculo a las funciones.

Las funciones de método no contienen interacción con el usuario ni dibujan:
reciben los datos, validan las dimensiones y las condiciones necesarias,
imprimen el paso a paso y devuelven sus resultados. Esa separación permite que
la misma función se use desde el menú y desde cualquier otro script. En el menú,
los errores se capturan con `try`/`catch` para informar el problema y volver a
mostrar las opciones.

### `principal.m`

{{CODE:principal.m}}

### `menu_metodos.m`

{{CODE:menu_metodos.m}}

### `gauss_jordan.m`

{{CODE:gauss_jordan.m}}

### `interpolacion_inversa_lineal.m`

{{CODE:interpolacion_inversa_lineal.m}}

---

## 2.3 Resultado de la ejecución

### Gauss-Jordan sobre el sistema de la práctica

El algoritmo se aplicó al sistema 3×3 definido en `principal.m`. La primera
captura muestra el planteo, la matriz ampliada inicial y la primera iteración
completa, incluido el pivoteo y la eliminación fila por fila.

{{IMG:img/principal-1-consola.png|Matriz ampliada inicial y primera iteración de Gauss-Jordan en el sistema 3x3}}

La matriz ampliada arranca con los coeficientes del sistema y el vector `b` a la
derecha de la barra. En la primera columna el pivote es `18.7200`, que es el de
mayor valor absoluto, así que no hay intercambio de filas. La eliminación anula
las dos posiciones inferiores de esa columna y la normalización deja un `1` en
la posición del pivote. La matriz reducida que se imprime al final de la
iteración ya muestra la incógnita `x1` resuelta en la última fila.

Las iteraciones 2 y 3 repiten el mismo esquema. La segunda captura muestra el
sistema final, ya reducido a la identidad, y la verificación:

{{IMG:img/principal-2-consola.png|Sistema final, solución y verificación por sustitución del sistema 3x3}}

La solución es `x1 = 1.836279`, `x2 = 4.721494` y `x3 = 5.500983`. La matriz
final tiene la identidad en la parte izquierda, lo que confirma que el proceso
de eliminación terminó correctamente. La verificación `A·x` devuelve
`(121.28, 126.32, 118.52)`, es decir, el vector `b` original.

### Gauss-Jordan con datos ingresados por teclado

Para verificar la condición de que los datos se ingresen por teclado y probar
otra dimensión de matriz se usó el menú, opción 1, con el sistema 4×4 de la
Guía 4. Se escribieron la matriz y el vector de requerimientos como expresiones
de Octave, con corchetes y punto y coma para separar filas.

{{IMG:img/menu-gj-inicio-consola.png|Menú de métodos e ingreso por teclado del sistema 4x4}}

{{IMG:img/menu-gj-iter1-consola.png|Pivoteo y eliminación en la primera iteración del sistema 4x4}}

{{IMG:img/menu-gj-norm-consola.png|Normalización y sistema reducido al final de la primera iteración}}

{{IMG:img/menu-gj-final-consola.png|Sistema final y solución del sistema 4x4}}

La solución obtenida es `x1 = 1.852467`, `x2 = 1.031812`, `x3 = 0.617796` y
`x4 = 0.745044`: maíz, desperdicio, alfalfa y cebada, respectivamente, en
kilogramos. El mismo sistema resuelto con aritmética exacta da
`(1.852467; 1.031812; 0.617796; 0.745044)`, de modo que los seis dígitos
mostrados coinciden.

La comparación entre la corrida 3×3 y la 4×4 muestra que el algoritmo no cambia
de naturaleza al crecer el sistema: cambia la cantidad de iteraciones y el
número de operaciones por iteración. El tiempo informado, del orden de los
milisegundos, corresponde a una sola ejecución y sirve sólo como referencia; no
es una medida estadística ni se usa para comparar métodos.

### Interpolación inversa lineal

Se eligió la opción 2 del menú y se ingresaron los vectores `x` e `y` de la
tabla junto con el valor objetivo `y = 0.90728517`.

{{IMG:img/menu-inv-consola.png|Tabla de datos, tramo elegido y resultado de la interpolación inversa lineal}}

El valor buscado cae entre `y(1) = 0.965926` y `y(2) = 0.906308`, es decir,
entre las abscisas 15 y 25. Con `h = 10` y `delta_y = −0.059618`, la fórmula da
`x = 24.836095`. El tramo se detectó automáticamente recorriendo la tabla, sin
que el usuario tuviera que indicar en qué intervalo buscar.

La tabla proviene de `y = cos(x)` con `x` en grados, de modo que el valor exacto
es `arccos(0.90728517) = 24.867163°`. El error absoluto es `0.0311`, con un
error relativo del `0,12 %`. Ese error es esperable para una interpolación
lineal con un paso de 10 grados sobre una función curva: la recta entre 15 y 25
queda por debajo de la curva del coseno en ese tramo.

### Análisis de los resultados

Los tres ejemplos permiten sacar conclusiones que no saldrían de una sola
corrida. En los sistemas lineales, la coincidencia de los resultados con la
sustitución directa y con la aritmética exacta valida la implementación del
pivoteo y de las dos fórmulas de eliminación y normalización. En el problema
inverso, la comparación con el valor exacto conocido cuantifica el error que
introduce la linealización.

También se verificaron los caminos de error: la función de interpolación rechaza
un valor de `y` fuera del rango de la tabla y un tramo con `delta_y` nulo, y la
función de Gauss-Jordan rechaza una matriz no cuadrada, un vector `b` de
dimensión distinta y un pivote menor que la tolerancia. El menú captura esos
errores y vuelve a mostrar las opciones.

---

## 2.4 Gráfico

No corresponde incluir gráficos en este trabajo. Ninguno de los dos algoritmos
asignados genera una figura: Gauss-Jordan produce una matriz y un vector, y la
interpolación inversa produce un número. La representación visual de esta última
sería la recta que une los dos puntos del tramo elegido, pero el programa no la
dibuja y la consigna pide el gráfico sólo «si corresponde». Las figuras del
apartado anterior son capturas de la salida de ejecución, no gráficos de
resultados.

---

# 3. Conclusión

Los dos métodos resolvieron los problemas planteados y sus resultados se
verificaron de manera independiente. Gauss-Jordan llegó a la misma solución en
los sistemas 3×3 y 4×4, y la sustitución `A·x` reprodujo el vector de términos
independientes. La interpolación inversa lineal obtuvo `x = 24.836095` para
`y = 0.90728517`, con un error del 0,12 % frente al valor exacto conocido.

Gauss-Jordan es un método directo, sin condiciones de convergencia: funciona
siempre que la matriz sea invertible, y el pivoteo parcial es lo que lo protege
contra pivotes pequeños. Su costo crece con el cubo de la dimensión y su
precisión está limitada por el redondeo acumulado en las operaciones. La ventaja
de que la matriz ampliada termine en la identidad es que la solución se lee
directamente, sin una etapa posterior de sustitución.

La interpolación inversa lineal es un método local y de bajo costo: sólo busca
el tramo y despeja `x` de una recta. No necesita equidistancia ni un polinomio
global, pero su precisión depende por completo de los datos: con una tabla de
paso amplio sobre una función curva, el error crece. En este trabajo ese error
fue de tres centésimas, y la mejora natural sería achicar el paso de la tabla o
usar un polinomio de grado superior en el tramo.

La comparación entre ambos métodos muestra que no son alternativas entre sí:
resuelven problemas distintos. La elección no depende de cuál sea «más preciso»,
sino de qué incógnita se busque y de qué información se disponga. En cambio, sí
comparten una exigencia: validar los datos de entrada antes de calcular. Las dos
funciones implementadas lo hacen y devuelven mensajes explícitos en lugar de
producir resultados sin sentido.

Como mejora posible del código queda registrar los tiempos de ejecución con
varias repeticiones si se quisiera hacer un análisis de desempeño; una sola
medición, como la que muestran las capturas, sólo acredita que el programa
corrió.

---

# 4. Bibliografía

Burden, R. L. y Faires, J. D. *Análisis Numérico*. 10ª edición. Cengage
Learning, 2017.

Chapra, S. C. y Canale, R. P. *Métodos Numéricos para Ingenieros*. 5ª edición.
McGraw-Hill, 2007.

Cátedra de Métodos Computacionales. *Guía de Actividades N° 4: Sistemas de
Ecuaciones*. Facultad de Ciencias Exactas y Naturales y de Agrimensura,
Universidad Nacional del Nordeste, 2026.

Cátedra de Métodos Computacionales. *Guía de Actividades N° 5: Interpolación
Numérica*. Facultad de Ciencias Exactas y Naturales y de Agrimensura,
Universidad Nacional del Nordeste, 2026.

Cátedra de Métodos Computacionales. *Práctico 06: Método de Gauss-Jordan*.
Facultad de Ciencias Exactas y Naturales y de Agrimensura, Universidad Nacional
del Nordeste, 2026.
