# METODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 3

### Competencias:
* Desarrolla modelos matemáticos para problemas de la realidad.
* Analiza las diferencias entre los métodos numéricos empleados para resolver problemas específicos.
* Analiza las condiciones de convergencia de los métodos numéricos en diferentes intervalos.
* Justifica la elección de un método numérico en función de los resultados obtenidos y las características del problema analizado.
* Compara los resultados obtenidos con diferentes métodos numéricos, elaborando conclusiones sobre su eficiencia.
* Diseña, codifica y procesa los algoritmos de solución de los diferentes problemas con el apoyo de una herramienta de programación.

### Contenidos:
* Raíces de Ecuaciones.
* Método de Tanteo, Intervalo Medio, Interpolación Lineal.
* Newton Raphson.
* Iteración.
* Aceleración de la convergencia: Método de Aitken.
* Convergencia y error de los métodos.

---

## Consignas
Realizar los puntos que se detallan a continuación. Trabajar en los grupos conformados.

### 1. Instrucciones Generales para los Algoritmos

a. Diseñar los algoritmos para aplicar los siguientes métodos:
   * **Método de Intervalo Medio:** Informar la cantidad de iteraciones necesarias.
   * **Interpolación Lineal**
   * **Newton Raphson:** Aplicar y mostrar las condiciones de Fourier.
   * **Método de Iteración:** El algoritmo debe tener la opción para que el usuario pueda elegir aplicar el método conjuntamente con la **Aceleración de Aitken**. Graficar las funciones aplicando los comandos correspondientes de tal forma que las dos curvas se visualicen en un mismo gráfico.

b. Para cada uno de los métodos se deberá ingresar los datos por teclado e informar los resultados con leyendas apropiadas y los gráficos correspondientes según los datos ingresados. Probar con diferentes cotas de error.

c. Codificar cada algoritmo en Octave u otro lenguaje de programación apropiado para cálculo científico.

d. Ejecutar el algoritmo diseñado con los datos de los diferentes problemas propuestos.

e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.

f. Evaluar y debatir los resultados obtenidos analizando el tiempo de proceso, convergencia y error cometido.

g. Presentar el trabajo realizado al resto de la clase.

h. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios.

i. Compartir el trabajo realizado en el foro del aula virtual.

---

### Comandos de Octave sugeridos
* **Fichero de definición de funciones:** `function`
* **Ingreso de datos:** `input`
* **Salida de datos:** `printf`, `disp`
* **Sentencia:** `for`
* **Comando de gráfico:** `fplot`
* **Cálculo de derivada:** `diff`
* **Tiempo de ejecución:** `cputime`, `tictoc`

---

## Ejercicios

### Ejercicio 1
Supóngase que se ha diseñado un tanque esférico en un pequeño pueblo. El volumen del líquido que puede contener se calcula como:

$$V = \pi h^{2} \left( \frac{3R - h}{3} \right)$$

donde $V$ es el volumen en $\text{m}^3$, $h$ es la profundidad del agua en el tanque en metros y $R$ el radio del tanque también en metros. Considerando $R = 3\text{ m}$ y $V = 30\text{ m}^3$:

a. Desarrollar un algoritmo que permita evaluar gráficamente las raíces de una ecuación. Utilizar el comando `fplot` de Octave. Aplicarlo al problema enunciado.
b. Separar todas las raíces aplicando el Método de Tanteo. Para esto, desarrollar un algoritmo que permita aplicar este método ingresando por teclado diferentes valores del incremento.
c. Aproxime a qué profundidad debe llenarse el tanque de modo que contenga $30\text{ m}^3$ utilizando el Método de Intervalo Medio y el Método de Interpolación Lineal con $E < 0.001$.
   * i. Aplicar los algoritmos diseñados para resolver estos métodos.
d. Comparar la aplicación de los métodos aplicados anteriormente teniendo en cuenta la convergencia de los mismos y el tiempo de ejecución en ambos casos (puede utilizar los comandos `cputime`, `oclock` u otro que considere apropiado). Emitir conclusiones.

---

### Ejercicio 2
a. Utilice el algoritmo desarrollado en el punto 1.a para hallar las raíces del siguiente problema en forma gráfica:
   > Un analista de mercado, que trabaja para un fabricante de dispositivos informáticos, encuentra que si la compañía produce y vende $x$ impresoras al mes, su utilidad total (en pesos) es:
   > $$P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372$$
   > ¿Cuántas impresoras debe producir la compañía para alcanzar el punto de equilibrio (no pierde ni gana)? Existen dos puntos.

b. Aplicar el algoritmo diseñado del Método de Newton Raphson para aproximar los dos puntos con $E < 10^{-3}$, previamente analizando las condiciones de convergencia del método en los intervalos iniciales: $[24; 26]$ y $[250; 252]$.

---

### Ejercicio 3
Para vender $x$ unidades de su producto semanalmente, una compañía debe gastar $A$ pesos semanales en publicidad, donde:

$$A = 200 \ln\left(\frac{400}{500 - x}\right)$$

Los objetos se venden a $\$5$ cada uno. La utilidad neta es entonces $R(x) = 5x - A$.

Calcular el número de unidades $x$ que debe de vender para tener una utilidad neta de $R(x) = \$1000$ pesos. En un entorno de $x = 200$:

a. Resolver el ejercicio anterior aplicando el algoritmo del Método de Iteración con $E < 10^{-4}$. Aplicar el método conjuntamente con la Aceleración de Aitken con $E < 10^{-4}$.