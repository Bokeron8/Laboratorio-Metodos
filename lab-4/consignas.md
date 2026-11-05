# METODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 4

### Competencias:
* Modela problemas reales planteando correctamente los sistemas de ecuaciones y seleccionando los métodos de resolución adecuados.
* Aplica los métodos numéricos para resolver sistemas de ecuaciones lineales, utilizando técnicas como la eliminación de Gauss y Gauss-Seidel, y evalúa la convergencia de estas soluciones.
* Identifica los conceptos fundamentales de autovalores y autovectores, así como la relación de estos con sistemas de ecuaciones homogéneos.
* Reconoce los métodos numéricos específicos, como el método de Fadeev-Leverrier y el método de las potencias, utilizados para resolver sistemas homogéneos.
* Justifica la elección de un método sobre otro en función de la estructura del sistema y de los resultados obtenidos.
* Diseña, codifica y procesa los algoritmos de solución de los diferentes problemas con el apoyo de una herramienta de programación.

### Contenidos:
* Sistemas de Ecuaciones:
  * Sistemas No homogéneos: Método de Eliminación de Gauss. Método de Gauss Jordan. Método de descomposición de LU. Método de Gauss Seidel.
  * Sistemas Homogéneos: Autovalores. Autovectores. Ecuación característica - Método de Fadeev Leverrier. Método de las potencias.

---

## Consignas
Realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados.

### 1. Instrucciones Generales para los Algoritmos

a. Diseñar los algoritmos correspondientes para aplicar los siguientes métodos:
   * **Sistemas no Homogéneos:**
     * Método de Eliminación de Gauss
     * Método de Gauss Jordan
     * Método de Gauss Seidel
     * Método de descomposición de LU.
   * **Sistemas Homogéneos:**
     * Método de Fadeev Leverrier.
     * Método de las potencias.

b. Para cada uno de los métodos se deberá ingresar los datos por teclado e informar los resultados con leyendas apropiadas.

c. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.

d. Ejecutar los algoritmos diseñados con datos de diferentes problemas propuestos.

e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.

f. Evaluar y debatir los resultados obtenidos analizando el tiempo de proceso, convergencia y error cometido.

g. Probar los algoritmos diseñados correspondientes a los Sistemas No Homogéneos con diferentes dimensiones de la matriz.

h. Presentar el trabajo realizado al resto de la clase.

i. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios.

j. Compartir el trabajo realizado en el foro del aula virtual.

---

### Comandos y estructuras de Octave sugeridos
* **Fichero de definición de funciones:** `function`
* **Ingreso de datos:** `input`
* **Uso de matrices** para trabajar con sistema de ecuaciones
* **Salida de datos:** `printf`, `disp`
* **Sentencia:** `for`
* **Comando `size()`** para determinar las dimensiones de una matriz
* **Comando `eye()`** para determinar la matriz identidad
* **Comando `inv()`** para calcular la inversa de una matriz
* **Tiempo de ejecución:** `cputime`, `tictoc`

---

## Ejercicios

### Sistemas no homogéneos

#### Ejercicio 1
Un ingeniero agrónomo desea preparar una fórmula alimenticia para engordar ganado. Dispone de maíz, desperdicios, alfalfa y cebada, cada uno con ciertas unidades de ingredientes nutritivos, de acuerdo con la tabla siguiente:

| Ingrediente nutritivo | Maíz | Desperdicio | Alfalfa | Cebada | Requerimiento diario Unidades/kg |
|---|---|---|---|---|---|
| Carbohidrato | 80 | 15 | 35 | 60 | 230 |
| Proteína | 28 | 72 | 57 | 25 | 180 |
| Vitamina | 20 | 20 | 12 | 20 | 80 |
| Celulosa | 50 | 10 | 20 | 60 | 160 |
| Costo $ | 18 | 5 | 7 | 20 | - |

a. Plantear el sistema de ecuaciones que modela el problema para:
   * Determinar los kilogramos necesarios de cada material para satisfacer el requerimiento diario (presentado en la última columna).
   * Determinar el costo de la mezcla.
   * *Nota:* La fórmula alimenticia debe contener los cuatro alimentos.
b. Resolver aplicando el Método de Eliminación de Gauss. (Utilice aritmética de tres dígitos.)

---

#### Ejercicio 2
Resolver aplicando el Método de Gauss-Seidel, previamente analice la convergencia del método. Considere la solución inicial $(1; 1; 1)$.

$$0.1x_1 + 7.0x_2 - 0.3x_3 = -19.30$$
$$3.0x_1 - 0.1x_2 - 0.2x_3 = 7.85$$
$$0.3x_1 - 0.2x_2 - 10.3x_3 = -19.30$$

---

#### Ejercicio 3
Dado el siguiente sistema de ecuaciones:

$$2x_1 + 3x_2 + 4x_3 = 6$$
$$4x_1 + 5x_2 + 10x_3 = 16$$
$$4x_1 + 8x_2 + 2x_3 = 2$$

a. Encuentre la factorización LU de la matriz de coeficientes.
b. Resuelva el sistema de ecuaciones utilizando la descomposición anterior.

---

#### Ejercicio 4
Una compañía electrónica produce transistores, resistores y chips de computadoras. Cada transistor requiere 4.3 unidades de cobre, una de zinc y dos de vidrio. Cada resistor requiere tres, tres y una unidad de dichos materiales, respectivamente, y cada chip de computadora requiere dos, una y tres unidades de los materiales, respectivamente. En forma de tabla, esta información queda así:

| Componente | Cobre | Zinc | Vidrio |
|---|---|---|---|
| Transistores | 4.3 | 1 | 2 |
| Resistores | 3 | 3 | 1 |
| Chips de computadora | 2 | 1 | 3 |

Los suministros de estos materiales varían de una semana a la otra, de modo que la compañía necesita determinar una corrida de producción diferente cada semana. Por ejemplo, cierta semana las cantidades disponibles de los materiales son 960 unidades de cobre, 510 unidades de zinc y 610 unidades de vidrio.

a. Plantee el sistema de ecuaciones lineales que modela la situación.
b. Aplique los diferentes métodos de resolución de sistemas de ecuaciones lineales y analice los resultados obtenidos.

---

### Sistemas homogéneos

#### Ejercicio 1
Resolver el siguiente sistema utilizando el método de Fadeev-Leverrier. Hallar los autovalores y los eigenvectores asociados.
*(Nota: El sistema se encuentra definido en los apuntes teóricos/prácticos de la cátedra).*

---

#### Ejercicio 2
En el estudio de las vibraciones de un sistema consistente en 3 masas insertadas en una varilla, la ecuación del movimiento tiene que ver con la formulación de valores propios:

a. Muestre el sistema a resolver: $Ax = \lambda x$.
b. Obtener todos los valores propios y el vector propio correspondiente al valor propio intermedio.
c. Aplique el método de las potencias para obtener el máximo autovalor y su vector propio correspondiente. Realice 4 iteraciones partiendo de $(1, 1, -0.5)^T$ y muestre el error de $\lambda$ y $x$, comparado con los exactos obtenidos en b).
