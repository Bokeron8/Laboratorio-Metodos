# MÉTODOS COMPUTACIONALES
## LABORATORIO - Guía de Actividades N° 1

---

### Pautas generales para cada problema

Para cada uno de los problemas enunciados, realizar los puntos que se detallan a continuación:

a. Formular el modelo matemático que lo represente.  
b. Diseñar un algoritmo que resuelva el problema y clasificarlo.  
c. Codificar cada algoritmo, en Octave u otro lenguaje de programación apropiado para cálculo científico.  
d. Ejecutar el algoritmo diseñado con los datos de los diferentes problemas propuestos por el docente.  
e. Observar los resultados obtenidos y emitir conclusiones al respecto según los fundamentos teóricos y prácticos.  
f. Evaluar y debatir los resultados obtenidos analizando el tiempo de proceso, convergencia y error cometido.  
g. Presentar el trabajo realizado al resto de la clase.  
h. Participar durante la presentación de los trabajos de los otros equipos, analizando y realizando diferentes preguntas o comentarios.

---

### Ejercicios

1. **Dado $N$ números positivos**, hallar la suma de todos los valores de $X_{1}$ a $X_{N}$. Probar con $N$ comprendido en el rango de representación de números enteros de $0$ a $255$. Luego probar con $N = 10000$.

2. **Dados 200 números positivos**, hallar la suma de todos los valores pares desde $X_{1}$ a $X_{N}$.

3. **Obtener los $N$ primeros números de la sucesión de Fibonacci.** Probar con $N = 200$.

4. **Si al quíntuple de un número se le suma el triple de su cuadrado**, se obtiene el triple del mismo más $1$. Armar la ecuación de segundo grado correspondiente y encontrar los valores numéricos que cumplen esa condición.

5. **Calcular e imprimir el valor del número $e$** como suma de la serie:
   $$e = 1 + \frac{1}{1!} + \frac{1}{2!} + \frac{1}{3!} + \dots + \frac{1}{N!}$$
   Teniendo en cuenta que la precisión será mayor cuanto mayor sea el dato de entrada $N$ (entero positivo), probar con diferentes cantidades de sumandos y sacar conclusiones.

6. **Calcular el valor de la constante absoluta $\pi$** con $n$ cifras decimales exactas deducida a partir de un desarrollo en serie de Taylor. Utilizar la expresión dada por la serie:
   $$\pi = 4 \cdot \left(1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \dots\right)$$
   
   - **i.** Calcular la cantidad de términos de la serie necesarios para alcanzar 3 dígitos exactos.
   - **ii.** Calcular la cantidad de términos de la serie necesarios para alcanzar 4 dígitos decimales y luego la cantidad de términos necesarios para alcanzar 5 dígitos decimales exactos. Comparar los resultados con el obtenido en el punto anterior teniendo en cuenta la convergencia. Controlar los tiempos de ejecución utilizando los comandos `cputime`, `clock` u otro que considere apropiado. Emitir conclusiones.

---

### Ejercicios Complementarios

1. Si se sabe que $1/17$ es el último término de una sucesión cuyo término general es:
   $$\frac{(-1)^i}{2i+1}$$
   ¿Cuántos términos tiene la solución?

2. Hallar los $n$ primeros términos de la serie de $e^x$:
   $$e^x = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \frac{x^4}{4!} + \dots + \frac{x^{n-1}}{(n-1)!}$$