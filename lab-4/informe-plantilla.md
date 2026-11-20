# Informe — Guía 4: Resolución de sistemas de ecuaciones lineales y autovalores

**Alumnos:** Franco Zambrano · Gabriel Bazzola

Métodos Computacionales · Laboratorio 4 · Octave 6.4.0

---

## Introducción

El laboratorio trabaja con dos familias de problemas. Los **sistemas no
homogéneos** `Ax = b` se resuelven con eliminación de Gauss, Gauss-Jordan,
descomposición LU y el método iterativo de Gauss-Seidel. Los **sistemas
homogéneos** se tratan como problema de autovalores `Ax = λx`, con el método de
Fadeev-Leverrier (que construye el polinomio característico) y el método de las
potencias (que busca el autovalor dominante).

Los scripts traen los datos de cada ejercicio definidos en el código, así que las
capturas de consola salen completas con una ejecución directa, sin preguntas por
teclado.

---

## Ejercicio 1 — Fórmula alimenticia (Eliminación de Gauss)

### Consigna

Un ingeniero agrónomo debe preparar una fórmula con maíz, desperdicio, alfalfa y
cebada. Plantear el sistema que determina los kilogramos de cada material para
cumplir el requerimiento diario, resolverlo con eliminación de Gauss usando
**aritmética de 3 dígitos significativos** y calcular el costo de la mezcla.

### Código — `01-agronomia.m`

{{CODE:01-agronomia.m}}

### Salida de ejecución

![Salida del ejercicio 1]({{IMG:ej1-consola}})

### Análisis

El sistema tiene 4 ecuaciones (carbohidrato, proteína, vitamina y celulosa) y 4
incógnitas (maíz, desperdicio, alfalfa y cebada):

```
A = [80  15  35  60]      b = [230
     28  72  57  25]           180
     20  20  12  20]            80
     50  10  20  60]           160]
```

Con aritmética de 3 dígitos el resultado es:

| Material | kg |
| :--- | :---: |
| Maíz (x1) | 1,86 |
| Desperdicio (x2) | 1,03 |
| Alfalfa (x3) | 0,62 |
| Cebada (x4) | 0,732 |

El costo total de la mezcla es **$57,61**, calculado como
`sum(x .* costos)` con costos 18, 5, 7 y 20 $/kg.

El punto importante del ejercicio es la **pérdida de dígitos**. Con aritmética
exacta el sistema da `x = (1,852467; 1,031812; 0,617796; 0,745044)` y un costo de
`$57,7289`. Con tres cifras significativas en cada operación los resultados se
redondean a 1,86 / 1,03 / 0,62 / 0,732 y el costo cae a `$57,61`, un 0,2 % menos.
El mayor desvío es el de la cebada: 0,732 contra 0,745, un 1,75 %. Es el costo de
simular una calculadora de 3 dígitos, y la consigna lo pide expresamente.

Verificando el resultado contra los requerimientos: la primera ecuación da
`80·1,86 + 15·1,03 + 35·0,62 + 60·0,732 = 229,87`, contra 230 pedido. La diferencia
es el efecto del redondeo a 3 dígitos, no un error del método.

---

## Ejercicio 2 — Gauss-Seidel

### Consigna

Resolver con Gauss-Seidel el sistema

```
0,1·x1 + 7,0·x2 − 0,3·x3 = −19,30
3,0·x1 − 0,1·x2 − 0,2·x3 =  7,85
0,3·x1 − 0,2·x2 − 10,3·x3 = −19,30
```

analizando previamente la convergencia y partiendo de `(1; 1; 1)`.

### Código — `02-gauss-seidel.m`

{{CODE:02-gauss-seidel.m}}

### Salida de ejecución

![Salida del ejercicio 2]({{IMG:ej2-consola}})

### Análisis

**Convergencia.** Tal como está escrito, el sistema **no** es dominante
diagonal: en la primera fila `|0,1| < |7,0| + |0,3|`. Gauss-Seidel no está
garantizado en ese orden. El script reordena las filas (la segunda primero) para
obtener la dominancia:

```
A = [3,0  −0,1  −0,2]      b = [ 7,85
     0,1   7,0  −0,3]          −19,30
     0,3  −0,2 −10,3]          −19,30]
```

Ahora cada diagonal domina su fila (`3 > 0,3`, `7 > 0,4`, `10,3 > 0,5`), y el
método converge por el teorema de dominancia diagonal. Reordenar filas no cambia
el sistema: es la misma ecuación, escrita en otro orden.

**Resultado.** Con `tol = 1e−5` y `x0 = (1, 1, 1)` converge en **4 iteraciones**:

| Incógnita | Valor |
| :---: | :---: |
| x1 | 2,659949 |
| x2 | −2,709262 |
| x3 | 2,003868 |

Verificación con la primera ecuación del sistema original:
`0,1·2,659949 + 7·(−2,709262) − 0,3·2,003868 = −19,30`. La solución satisface
las ecuaciones con el error de la tolerancia.

---

## Ejercicio 3 — Factorización LU

### Consigna

Dado el sistema

```
2·x1 + 3·x2 + 4·x3 =  6
4·x1 + 5·x2 + 10·x3 = 16
4·x1 + 8·x2 + 2·x3 =  2
```

a) hallar la factorización LU de la matriz de coeficientes; b) resolver el sistema
con esa descomposición.

### Código — `03-descomposicion-lu.m`

{{CODE:03-descomposicion-lu.m}}

### Salida de ejecución

![Salida del ejercicio 3]({{IMG:ej3-consola}})

### Análisis

La factorización (Doolittle, con `L` unidad inferior) es:

```
L = [1  0  0]      U = [2   3   4]
    [2  1  0]          [0  −1   2]
    [2 −2  1]          [0   0  −2]
```

Se obtiene sin pivoteo: el primer pivote es 2, los multiplicadores son 4/2 = 2 y
4/2 = 2, y el segundo pivote queda −1. La verificación es inmediata:
`L·U` reproduce `A`.

La resolución se hace en dos pasos: `L·y = b` da `y = (6, 4, −2)` y `U·x = y` da

| Incógnita | Valor |
| :---: | :---: |
| x1 | 4,0000 |
| x2 | −2,0000 |
| x3 | 1,0000 |

Comprobando en la tercera ecuación: `4·4 + 8·(−2) + 2·1 = 2`. ✓

La ventaja de LU sobre eliminación directa no se ve en un solo sistema, sino
cuando hay varios vectores `b` con la misma `A`: la factorización se hace una sola
vez y después sólo hay dos sustituciones triangulares.

---

## Ejercicio 4 — Componentes electrónicos

### Consigna

Una compañía produce transistores, resistores y chips. Cada uno consume cobre,
zinc y vidrio según la tabla; con 960 unidades de cobre, 510 de zinc y 610 de
vidrio disponibles, plantear el sistema y resolverlo con los diferentes métodos.

### Código — `04-componentes-electronicos.m`

{{CODE:04-componentes-electronicos.m}}

### Salida de ejecución

![Salida del ejercicio 4]({{IMG:ej4-consola}})

### Análisis

| Método | x1 (transistores) | x2 (resistores) | x3 (chips) | Tiempo (s) |
| :--- | :---: | :---: | :---: | :---: |
| Eliminación Gauss | 106,54 | 101,68 | 98,41 | 3,34e−04 |
| Gauss-Jordan | 106,54 | 101,68 | 98,41 | 1,89e−04 |
| Descomposición LU | 106,54 | 101,68 | 98,41 | 3,24e−04 |
| Gauss-Seidel | 106,54 | 101,68 | 98,41 | 1,52e−03 (14 it) |

Los cuatro métodos dan **el mismo resultado** (106,54 / 101,68 / 98,41), lo que
es la mejor validación posible: si alguno estuviera mal, los valores se
separarían. Verificando la primera ecuación:
`4,3·106,54 + 3·101,68 + 2·98,41 = 960,0`. ✓

Los tiempos muestran el orden de costo: Gauss-Jordan es el más rápido en este
sistema 3×3, y Gauss-Seidel es el más lento (14 iteraciones para la misma
solución). En sistemas pequeños el costo de la iteración no se compensa;
Gauss-Seidel sirve cuando el sistema es grande y disperso, que es donde la
eliminación se vuelve cara.

---

## Ejercicio 5 — Fadeev-Leverrier

### Consigna

Resolver el sistema homogéneo con el método de Fadeev-Leverrier, hallando los
autovalores y los autovectores asociados.

### Código — `05-fadeev-leverrier.m`

{{CODE:05-fadeev-leverrier.m}}

### Salida de ejecución

![Salida del ejercicio 5]({{IMG:ej5-consola}})

### Análisis

Con `A = [3 2 −1; 1 −2 3; 2 0 4]` el método halla:

| Autovalor | Valor |
| :---: | :---: |
| λ1 | 4,0000 |
| λ2 | 3,0000 |
| λ3 | −2,0000 |

Se pueden verificar con las dos invariantes del polinomio característico:

- **Traza**: `λ1 + λ2 + λ3 = 4 + 3 − 2 = 5`, y `trace(A) = 3 − 2 + 4 = 5`. ✓
- **Determinante**: `λ1·λ2·λ3 = 4·3·(−2) = −24`, y `det(A) = −24`. ✓

Fadeev-Leverrier construye el polinomio característico a partir de las trazas de
las potencias de `A` y después halla sus raíces; es un método que no necesita
descomponer la matriz ni iterar. La desventaja es que el grado del polinomio crece
con el tamaño del sistema y hallar las raíces deja de ser práctico para `n`
grande.

---

## Ejercicio 6 — Método de las potencias

### Consigna

En el problema de vibraciones de tres masas, obtener los valores propios y aplicar
el método de las potencias para hallar el autovalor dominante y su autovector,
con 4 iteraciones desde `(1, 1, −0,5)ᵀ`.

### Código — `06-metodo-potencias.m`

{{CODE:06-metodo-potencias.m}}

### Salida de ejecución

![Salida del ejercicio 6]({{IMG:ej6-consola}})

### Análisis

Con `A = [2 −1 0; −0,5 1 −0,5; 0 −0,3333 0,6667]` y `x0 = (1, 1, −0,5)`, después de
4 iteraciones el script informa:

| | Valor |
| :--- | :---: |
| Autovalor dominante aproximado | 1,84058 |
| Autovector aproximado | (1, −0,091864, −0,153106) |

El script normaliza por el componente de mayor módulo de `y = A·x`: por eso la
primera componente del vector queda 1 y el autovalor estimado es ese componente.

Comparando con los valores exactos, obtenidos con `eig`:

| | λ dominante | Autovector |
| :--- | :---: | :--- |
| Potencias (4 iteraciones) | 1,84058 | (1, −0,091864, −0,153106) |
| Exacto | 2,387424 | (1, −0,387424, 0,075043) |
| Error | 0,547 (23 %) | la tercera componente con signo cambiado |

Con 4 iteraciones el resultado no converge: la convergencia del método es
geométrica a la tasa `|λ₂/λ₁| = 1/2,39 ≈ 0,42` por iteración, de modo que el error
se reduce aproximadamente a la mitad en cada paso. Es la comparación que pide el
inciso c) de la consigna: 4 iteraciones muestran el método andando, no el
resultado final.

El script implementa el inciso c) de la consigna; los autovalores exactos de
referencia (2,3874; 1,0000; 0,2793) se verificaron aparte con `eig`. El método de
las potencias sólo halla el autovalor de mayor módulo (y su autovector): para el
segundo autovalor haría falta deflación u otro método.

---

## Conclusiones

1. **Reordenar no cambia el sistema.** En el ejercicio 2, el sistema tal como
   viene no es dominante diagonal y Gauss-Seidel no está garantizado; al reordenar
   las filas sí lo es y converge en 4 iteraciones. La convergencia de un método
   iterativo depende del orden de las ecuaciones, cosa que no pasa con los
   directos.

2. **Los métodos directos coinciden.** En el ejercicio 4, Gauss, Gauss-Jordan, LU
   y Gauss-Seidel dan el mismo vector `(106,54; 101,68; 98,41)`. Con un sistema
   pequeño el criterio de elección no es la exactitud sino el costo: Gauss-Seidel
   fue el más lento aquí.

3. **La aritmética acotada cambia el resultado.** En el ejercicio 1, trabajar con
   3 dígitos significativos deja la primera ecuación en 229,6 en lugar de 230. Es
   el efecto pedido por la consigna, no un defecto del método.

4. **LU se justifica con varios `b`.** La factorización del ejercicio 3 deja `L` y
   `U` para resolver cualquier término independiente con dos sustituciones
   triangulares; para un único `b` no aporta nada frente a Gauss.

5. **Dos formas de hallar autovalores.** Fadeev-Leverrier da todos de una vez a
   partir del polinomio característico (ejercicio 5: 4, 3, −2, verificados con
   traza y determinante); el método de las potencias sólo da el dominante y
   necesita iteraciones (ejercicio 6: λ ≈ 1,84 con 4 iteraciones).

---

## Anexo — Funciones

### `resolver_gauss.m`

Eliminación de Gauss con pivoteo parcial y sustitución regresiva.

{{CODE:resolver_gauss.m}}

### `resolver_gauss_3digitos.m`

Eliminación de Gauss con pivoteo parcial y aritmética de 3 dígitos significativos.

{{CODE:resolver_gauss_3digitos.m}}

### `resolver_gauss_jordan_func.m`

Método de Gauss-Jordan con pivoteo parcial y reducción a la matriz identidad.

{{CODE:resolver_gauss_jordan_func.m}}

### `resolver_lu_func.m`

Factorización LU (Doolittle) con sustitución progresiva y regresiva.

{{CODE:resolver_lu_func.m}}

### `resolver_gauss_seidel_func.m`

Método iterativo de Gauss-Seidel, con tolerancia y número máximo de iteraciones.

{{CODE:resolver_gauss_seidel_func.m}}

### `resolver_fadeev_func.m`

Faddeev-Leverrier: trazas, coeficientes del polinomio característico, raíces y
autovectores.

{{CODE:resolver_fadeev_func.m}}

### `resolver_potencias_func.m`

Iteración de potencias para el autovalor dominante y su autovector.

{{CODE:resolver_potencias_func.m}}
