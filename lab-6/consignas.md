# METODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 6

### Competencias:
* Aplica las fórmulas que permiten obtener valores aproximados de la derivada de una función en un punto.
* Aproxima el valor de una integral definida utilizando las reglas de Trapecios y Simpson.
* Diseña, codifica y procesa los algoritmos de solución de los diferentes problemas con el apoyo de una herramienta de programación.

### Contenidos:
* Derivación a partir de las fórmulas de Newton Gregory. Estimación de los errores cometidos.
* Integración numérica:
  * Fórmulas de los Trapecios.
  * Fórmula de Simpson: 1/3 y 3/8.
  * Combinación de fórmulas.

---

## Consignas
Realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados.

### 1. Instrucciones Generales para los Algoritmos

a. Diseñar los algoritmos correspondientes para aplicar:
   * Derivación a partir de la fórmula de Newton Gregory Ascendente y Descendente
   * Fórmulas de los Trapecios.
   * Fórmula de Simpson: 1/3 y 3/8

b. Para cada uno de los métodos se deberá ingresar los datos por teclado e informar los resultados con leyendas apropiadas.

c. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.

d. Ejecutar los algoritmos diseñados con los datos de los diferentes problemas propuestos en el Práctico N° 6.

e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.

f. Presentar el trabajo realizado al resto de la clase.

g. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios sobre los trabajos presentados.

h. Compartir el trabajo realizado en el foro del aula virtual.

i. Probar los algoritmos diseñados con diferentes ejercicios.

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
Dada la siguiente tabla de valores:

| x | 12 | 13 | 14 | 15 | 16 | 17 |
|---|---|---|---|---|---|---|
| y | 0.96262 | 0.94718 | 0.93108 | 0.92221 | 0.91181 | 0.90151 |

a. Construir la tabla de diferencias.
b. Calcular $f'(12)$ con la fórmula de Gregory Newton Ascendente.
c. Calcular $f'(12.4)$ ¿cuál es la diferencia al utilizar la fórmula en ambos casos?
d. Utilizar la fórmula de Gregory Newton descendente para calcular $f''(17)$.

---

### Ejercicio 2
Dada la siguiente tabla de valores, calcular la $\int f(x)dx$ seleccionando adecuadamente entre las fórmulas de Trapecios y la fórmula de Simpson. Ver la posibilidad de combinar fórmulas para obtener mejores resultados.

| t | 0 | 0.1 | 0.2 | 0.3 | 0.4 | 0.5 |
|---|---|---|---|---|---|---|
| i | 0.0 | 0.15 | 0.3 | 0.55 | 0.73 | 0.81 |

---

### Ejercicio 3
Con la misma tabla de ejercicio 1 calcular $\int_{12}^{17} f(x)dx$ seleccionando adecuadamente entre las fórmulas de Trapecio y la de Simpson.

---

### Ejercicio 4
Resolver la misma integral del ejercicio anterior combinando las dos fórmulas de Simpson. Comparar los resultados obtenidos en ambos casos.
