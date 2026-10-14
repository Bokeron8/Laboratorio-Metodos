# MÉTODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 2

### Competencias
* Interpreta los conceptos de cifras significativas, exactitud y precisión y cómo se representan en la computadora.
* Diferencia entre error relativo y absoluto y cómo se aplican para finalizar un cálculo iterativo.
* Analiza los tipos de errores y su impacto en los resultados obtenidos.

### Contenidos
* Aproximaciones Numéricas - Errores. Propagación del error.
* Errores en la representación de los números.
* Cifras significativas, exactitud y precisión. Errores por redondeo y por truncamiento.

---

### Consignas Generales
Para cada uno de los problemas enunciados, realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados:

a. Diseñar un algoritmo que resuelva el problema.  
b. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.  
c. Ejecutar el algoritmo diseñado con los datos de los diferentes problemas propuestos.  
d. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.  
e. Evaluar y debatir los resultados obtenidos analizando el tiempo de proceso, convergencia, error cometido.  
f. Presentar el trabajo realizado al resto de la clase.  
g. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios.  
h. Compartir el trabajo realizado en el foro del aula virtual.  

---

### Comandos de Octave Recomendados
* Fichero de definición de funciones: `function`
* Ingreso de datos: `input`
* Salida de datos: `printf`, `disp`
* Sentencia: `for`
* Comando: `format`
* Comando: `abs()`
* Tiempo de ejecución: `cputime`, `tic`/`toc`

---

### Ejercicios

#### Ejercicio 1
Calcule el error absoluto y relativo en las siguientes aproximaciones de $p$ por $p^*$:

a. $p = \pi$, $p^* = \frac{22}{7}$  
b. $p = \pi$, $p^* = 3.1416$  
c. $p = e$, $p^* = 2.718$  
d. $p = \sqrt{2}$, $p^* = 1.414$  
e. $p = e^{10}$, $p^* = 22000$  
f. $p = 8!$, $p^* = 39900$  

---

#### Ejercicio 2
Usando aritmética con redondeo a 3 dígitos, realice los siguientes cálculos. Considerando como valor exacto el resultado con 5 dígitos decimales, obtenga el error absoluto y error relativo. Trabajar con los valores normalizados.

a. $133 + 0.921$  
b. $133 - 0.499$  
c. $(121 - 119) - 0.327$  
d. $(121 - 0.327) - 119$  
e. $\left(\frac{2}{9}\right) \cdot \left(\frac{9}{7}\right)$  

---

#### Ejercicio 3
Repita el ejercicio anterior utilizando aritmética con truncamiento a tres dígitos. Compare los resultados obtenidos en 2 y 3.

---

#### Ejercicio 4
La fórmula para resolver ecuaciones cuadráticas establece que las raíces de $ax^2 + bx + c = 0$, cuando $a \neq 0$, son:

$$x_1 = \frac{-b + \sqrt{b^2 - 4ac}}{2a}, \quad x_2 = \frac{-b - \sqrt{b^2 - 4ac}}{2a}$$

Considere que: $x^2 + 62.10x + 1 = 0$, hallar las raíces aproximadas sabiendo que los valores de referencia son $x_1 = -0.01610723$ y $x_2 = -62.08390$:

a. Calcular $x_1$ y $x_2$ con redondeo a cuatro dígitos, normalizando los valores con que se trabaja. Calcular los errores absolutos y relativos cometidos en su determinación.  
b. A fin de obtener una aproximación más precisa redondeada a cuatro cifras para $x_1$, cambiar la expresión de la fórmula cuadrática "racionalizando el numerador", y aplicarla también para obtener una forma alternativa para $x_2$. Comparar los errores obtenidos a partir de las nuevas aproximaciones logradas.  

---

#### Ejercicio 5

##### 5.a
Evaluar $f(x) = x^3 - 6x^2 + 3x - 0.149$ en $x = 4.71$ usando la aritmética de tres dígitos y consignar los valores en la siguiente tabla, sin normalizarlos. Calcular el error absoluto y el error relativo.

| Método / Caso | $x$ | $x^2$ | $x^3$ | $6x^2$ | $3x$ | $f(x)$ | Error Absoluto | Error Relativo |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Exacto** | 4.71 | | | | | | | |
| **Tres dígitos (truncados)** | 4.71 | | | | | | | |
| **Tres dígitos (redondeados)** | 4.71 | | | | | | | |

##### 5.b
Reescribir la fórmula en forma anidada y recalcule los errores. Analizar el crecimiento/disminución de los mismos. Emitir conclusión.