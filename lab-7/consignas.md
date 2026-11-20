# METODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 7

### Competencia:
* Comprenda las representaciones visuales de los métodos de Euler, modificado de Euler y Runge Kutta.
* Identifique el orden y la dependencia del tamaño de paso respecto de los errores de truncamiento global, para todos los métodos descritos; y cómo dichos errores tienen que ver con la exactitud de las técnicas.
* Conozca la forma general de los métodos de Runge-Kutta; y la deducción del método Runge-Kutta de segundo orden.
* Detecte la diferencia entre problemas de valor inicial y de valores en la frontera.
* Diseña, codifica y procesa los algoritmos de solución de los diferentes problemas con el apoyo de una herramienta de programación.

### Contenidos:
* Ecuaciones Diferenciales: Integración numérica de ecuaciones diferenciales. Problemas de valores iniciales. Métodos que empiezan por sí mismos. Método de Euler y su modificado. Método de Runge Kutta de 2do y 4to orden.
* Métodos que no comienzan por sí mismos: Método de Milne. Estabilidad y error: análisis comparativo.

---

## Consignas

Realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados.

a. Diseñar los algoritmos correspondientes para aplicar:
   * Método de Euler y Método Modificado de Euler.
   * Método de Runge Kutta de 2° Orden.
   * Método de Milne.
b. Para cada uno de los métodos se deberá ingresar los datos por teclado e informar los resultados con leyendas apropiadas.
c. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.
d. Ejecutar los algoritmos diseñados con los datos de los diferentes problemas propuestos.
e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.
f. Presentar el trabajo realizado al resto de la clase.
g. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios sobre los trabajos presentados.
h. Compartir el trabajo realizado en el foro del aula virtual.
i. Probar los algoritmos diseñados con diferentes ejercicios.

### Comandos y estructuras de Octave

* Fichero de definición de funciones: `function`
* Ingreso de datos: `input`
* Salida de datos: `printf`, `disp`
* Sentencia `for`
* Comando `size()` para determinar las dimensiones de una matriz
* Tiempo de ejecución: `cputime`, `tic`/`toc`

---

## Ejercicios

### Métodos que se inician por sí mismos

**1.** Dada la siguiente ecuación diferencial

$$y' = x^2 + y^2$$

con las condiciones iniciales $x_0 = 0$ e $y_0 = 1$, $h = 0{,}2$:

a) Resolver en el intervalo $(0; 0{,}6)$ utilizando el Método de Euler.

b) Ídem anterior utilizando Método Modificado de Euler con $E < 0{,}001$.

**2.** La ecuación del crecimiento de una población se modela frecuentemente mediante la siguiente ecuación diferencial:

$$P'(t) = \gamma \, P(t) - \tau \, P(t)^2 \qquad \text{y} \qquad P(0) = P_0$$

Donde $P(t)$ denota la población, $\gamma$ es la tasa de nacimiento y $\tau$ es la mortalidad de la población. La solución exacta de la ecuación diferencial es:

$$P(t) = \frac{\gamma}{\tau + \left( \frac{\gamma}{P(0)} - \tau \right) e^{-\gamma t}}$$

a) Resolver la ecuación diferencial en el intervalo $(0; 2)$ y para los parámetros $\gamma = 3$, $\tau = 0{,}1$, $P(0) = 5$ utilizando el Método de Euler con los pasos $h = 0{,}5$ y $h = 0{,}25$.

b) Comparar con la solución exacta.

**3.** Tomar la ecuación diferencial planteada en el ítem 1, con las mismas condiciones iniciales y:

a) Hallar la solución de la misma en el intervalo $(0; 0{,}6)$, utilizando el Método de Runge Kutta de 2do Orden.

b) Hallar la solución de la misma en el intervalo $(0; 0{,}6)$, utilizando el Método de Runge Kutta de 4to Orden.

b) Compare los resultados de 3.a con los obtenidos en 1.b y emitir conclusiones con respecto a los errores calculados.

> Nota: el original repite la letra «b)» en el tercer inciso; es el que compara los resultados.

### Ejercicio complementario

**4.** Si se drena el agua desde un tanque cilíndrico vertical por medio de abrir una válvula en la base, el líquido fluirá rápido cuando el tanque esté lleno y despacio conforme se drene. Como se ve, la tasa a la que el nivel del agua disminuye es:

$$\frac{dy}{dt} = -k\sqrt{y}$$

donde $k$ es una constante que depende de la forma del agujero y del área de la sección transversal del tanque y agujero de drenaje. La profundidad del agua $y$ se mide en metros y el tiempo $t$ en minutos. Si $k = 0{,}06$, determine cuánto tiempo se requiere para vaciar el tanque si el nivel del fluido se encuentra en un inicio a 3 m.

a) Aplique el método de Euler con un paso de 0,5 minutos.

### Métodos que no se inician por sí mismos

**5.** En función a los resultados obtenidos en 3.a complete la siguiente tabla:

| x | y | y' |
| :---: | :---: | :---: |
| 0 | | |
| 0,2 | | |
| 0,4 | | |
| 0,6 | | |

a) Calcule la solución en los puntos $x = 0{,}8$ y $x = 1$, aplicando el Método de Milne.

**6.** Resuelva la siguiente ecuación diferencial en el intervalo $(0; 0{,}3)$:

$$y' = 3x + 3y \qquad \text{con} \qquad y(0) = 1$$

a) Utilizar pasos $h = 0{,}1$ y $h = 0{,}05$ aplicando el Método Modificado de Euler para hallar los valores iniciales.

b) Aplique el Método de Milne para calcular $y$ en $x = 0{,}20$ y $x = 0{,}25$.

c) Dado que se conoce la solución exacta, calcular los errores cometidos en cada paso de integración.

$$y = \frac{4}{3} e^{3x} - x - \frac{1}{3}$$
