# METODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 5

### Competencias:
* Emplea tablas de diferencias para la resolución de problemas de interpolación numérica en datos equidistantes, aplicando las fórmulas de Newton-Gregory ascendente y descendente según corresponda.
* Utiliza la interpolación parabólica progresiva y reconoce su utilidad para aproximar valores desconocidos en casos específicos donde los datos se presentan de manera progresiva.
* Manipula la fórmula de Lagrange para la interpolación con valores no equidistantes, comprendiendo sus ventajas y desventajas en comparación con el polinomio de Newton.
* Aplica los diferentes métodos de interpolación para resolver una variedad de problemas prácticos en distintos campos de la ciencia y la ingeniería, adoptando la técnica más adecuada según el tipo de datos y las características del problema.
* Diseña, codifica y procesa los algoritmos de solución de los diferentes problemas con el apoyo de una herramienta de programación.

### Contenidos:
* Interpolación Numérica:
  * Problema general.
  * Valores equidistantes. Tabla de diferencias.
  * Fórmula de Newton Gregory Ascendente y Descendente.
  * Interpolación Lineal y cuadrática.
  * Valores no equidistantes: Fórmula de Lagrange, Interpolación parabólica progresiva.
  * Problema inverso.

---

## Consignas
Realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados.

### 1. Instrucciones Generales para los Algoritmos

a. Diseñar los algoritmos correspondientes para aplicar:
   * Fórmula de Newton Gregory Ascendente
   * Fórmula de Newton Gregory Descendente
   * Interpolación Inversa Lineal
   * Interpolación Inversa Cuadrática
   * Método de Lagrange

b. Para cada uno de los métodos se deberá ingresar los datos por teclado e informar los resultados con leyendas apropiadas.

c. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.

d. Ejecutar los algoritmos diseñados con los datos de los diferentes problemas propuestos.

e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.

f. Evaluar y debatir los resultados obtenidos analizando el tiempo de proceso, convergencia y error cometido.

g. Presentar el trabajo realizado al resto de la clase.

h. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios.

i. Compartir el trabajo realizado en el foro del aula virtual.

j. Probar los algoritmos diseñados con diferentes ejercicios.

---

### Comandos y estructuras de Octave sugeridos
* **Fichero de definición de funciones:** `function`
* **Ingreso de datos:** `input`
* **Uso de matrices** para trabajar con las tablas de diferencias.
* **Salida de datos:** `printf`, `disp`
* **Sentencia:** `for`
* **Comando `size()`** para determinar las dimensiones de una matriz
* **Tiempo de ejecución:** `cputime`, `tictoc`

---

## Ejercicios

### Ejercicio 1
Interpolación en intervalos regularmente espaciados. Dada la siguiente tabla de valores:

| x | 15 | 25 | 35 | 45 | 55 | 65 |
|---|---|---|---|---|---|---|
| y | 0.965926 | 0.906308 | 0.819152 | 0.707107 | 0.573576 | 0.422618 |

a. Utilice la fórmula de Newton-Gregory Ascendente para hallar el valor de $x = 17$.
b. Aplique la fórmula de Newton-Gregory Descendente y hallar el valor de $x = 60$.
c. Determine el valor de $x$ que corresponde a $y = 0.90728517$ usando Interpolación Inversa - Lineal y Cuadrática.

---

### Ejercicio 2
Cada 10 años se levanta un censo de población en Estados Unidos. En la siguiente tabla se incluyen datos de la población, en miles de habitantes, de 1940 a 1990.

| Año | 1940 | 1950 | 1960 | 1970 | 1980 | 1990 |
|---|---|---|---|---|---|---|
| Población en miles de habitantes | 132,165 | 151,326 | 179,323 | 203,302 | 226,542 | 249,633 |

a. Use la interpolación de Lagrange para aproximar la población en el año 1965.
b. La población de 1965 fue aproximadamente de 189 703 000 habitantes. ¿Qué exactitud, a su juicio, tienen sus cifras correspondientes al año 1965?

---

### Ejercicio 3
Dada la siguiente tabla:

| x | 0 | 0.4 | 0.75 | 1.5 | 2.0 |
|---|---|---|---|---|---|
| y | 1 | 1.63246 | 1.86603 | 2.22474 | 2.41421 |

a. Exprese la forma del polinomio interpolante de Lagrange. Interpolar el valor correspondiente $x = 1$.
b. Determine el valor de $y$ correspondiente a $x = 0.45$ aplicando el método de Lagrange.

---

### Ejercicio 4
Se tiene un conjunto de puntos, que se han obtenido en forma experimental midiendo diferentes densidades del sodio a diferentes temperaturas:

| Temperatura | 102 | 245 | 327 | 423 | 565 |
|---|---|---|---|---|---|
| Densidad | 0.564642 | 0.644218 | 0.717356 | 0.783327 | 0.853329 |

a. Aplique la fórmula de Lagrange para la temperatura igual a $275^\circ$.
b. Aplique la fórmula de Interpolación parabólica progresiva para la temperatura igual a $275^\circ$ y estime el error cometido.
c. A partir de los resultados anteriores extraiga conclusiones.
