# 1. Introducción

El presente trabajo tiene por objeto analizar, comparar y aplicar tres métodos numéricos
para la resolución de ecuaciones no lineales: el método de iteración de punto fijo, su
aceleración mediante el método de Aitken y el método de Newton-Raphson. Los tres
pertenecen al Tema 3 de la asignatura y comparten el mismo objetivo: obtener una
aproximación de la raíz de una ecuación de la forma *F(x) = 0* partiendo de un valor
inicial *x0* y refinando la estimación hasta que el error entre dos aproximaciones
sucesivas resulte menor que una tolerancia prefijada.

La comparación se realiza sobre un mismo problema, tomado del Ejercicio 3 de la Guía de
Actividades N° 3, de modo que las diferencias observadas en la cantidad de iteraciones,
en la precisión alcanzada y en el tiempo de ejecución provengan exclusivamente del
método empleado y no de un cambio de problema. Los algoritmos se implementaron en
Octave 6.4.0 y reciben todos los datos por teclado, tal como exige la cátedra: función,
valor inicial, tolerancia y rango de graficación.

El informe se organiza en cuatro partes. La primera presenta el problema y el análisis
teórico de cada método con su condición de convergencia. La segunda incluye el código
fuente completo. La tercera expone los resultados de la ejecución y el barrido de
tolerancias. La cuarta presenta los gráficos y las conclusiones.

---

# 2. Desarrollo

## 2.1 Métodos asignados. Análisis y comparación

### Problema planteado

Una compañía gasta semanalmente *A = 200·ln(400/(500 − x))* pesos en publicidad para
vender *x* unidades de su producto. Cada unidad se vende a $5, por lo que la utilidad
neta semanal es:

*R(x) = 5x − 200·ln(400/(500 − x))*

Se desea determinar cuántas unidades debe vender la compañía para obtener una utilidad
neta de $1000. Planteado como búsqueda de raíz, el problema consiste en resolver
*F(x) = 0* con:

*F(x) = 5x − 200·ln(400/(500 − x)) − 1000*

El dominio de la función está restringido a *0 < x < 500*, porque el argumento del
logaritmo debe ser positivo. Fuera de ese intervalo la expresión no está definida y
ningún método puede operar.

La raíz del problema tiene una lectura concreta: es la cantidad de unidades que hay que
vender para cubrir exactamente la inversión publicitaria y alcanzar los $1000 de
utilidad. Los demás números que arroja la ejecución también se interpretan en ese
marco: la columna de error mide la diferencia entre dos aproximaciones consecutivas y
es el criterio de corte; la cantidad de iteraciones mide cuántos pasos necesitó el
método para alcanzar la tolerancia, y el tiempo de ejecución mide el costo de ese
trabajo. Comparar métodos, entonces, es comparar cuánto tardan en llegar al mismo
número con la misma exigencia de precisión.

### Método de iteración de punto fijo

El método transforma la ecuación *F(x) = 0* en una equivalente de la forma *x = g(x)* y
la resuelve por iteración sucesiva: *x(k+1) = g(x(k))*. Para este problema, despejando
*x* de *F(x) = 0*:

*5x = 200·ln(400/(500 − x)) + 1000*

*x = 200 + 40·ln(400/(500 − x)) = g(x)*

La convergencia depende de la derivada de la función de iteración en el entorno del
punto fijo. Si *|g'(x)| < 1*, la iteración converge y lo hace en forma lineal, con un
factor de reducción del error cercano a *|g'(x)|*; si *|g'(x)| > 1*, diverge. Para este
problema *g'(x) = 40/(500 − x)*, de modo que en *x0 = 200* resulta *|g'(200)| = 0.1333*.
Al ser menor que uno, la convergencia está asegurada y el error se reduce
aproximadamente en ese factor en cada paso: se gana algo menos de una cifra decimal por
iteración. Esa es la razón por la que el método necesita más pasos que los otros dos.

El algoritmo implementado verifica la condición antes de comenzar y, si no se cumple,
informa que el método no converge en lugar de iterar sin sentido. La derivada se evalúa
por diferencia central con *h = 1e−4*, porque el programa recibe *g(x)* como expresión
simbólica y no dispone de su derivada analítica.

### Aceleración de Aitken

La aceleración de Aitken trabaja sobre la misma iteración de punto fijo, pero en lugar
de aceptar cada valor de *g(x)* calcula dos pasos y corrige el resultado. Si *x1 = g(x0)*
y *x2 = g(x1)*, y si el error se comporta geométricamente con razón *q*, es decir
*(x1 − r) = q·(x0 − r)* y *(x2 − r) = q·(x1 − r)*, despejando *r* de ambas relaciones se
obtiene:

*x = x0 − (x1 − x0)² / (x2 − 2·x1 + x0)*

El denominador es la segunda diferencia hacia adelante, de ahí el nombre de
aceleración delta cuadrado. La corrección elimina el término dominante del error y
convierte una sucesión linealmente convergente en una cuadráticamente convergente, sin
necesidad de conocer ninguna derivada.

El precio que se paga es que cada iteración requiere dos evaluaciones de *g* en lugar de
una, y que el método se detiene si el denominador se anula, situación que ocurre cuando
la sucesión ya es constante o cuando la corrección no está definida. En este problema el
denominador se mantiene lejos de cero en todo el recorrido.

Conviene señalar una diferencia importante con el punto fijo clásico: la aceleración
puede converger incluso en zonas donde la iteración simple diverge, porque la corrección
no depende de que *|g'| < 1*. En este caso particular la condición favorable ya se
cumplía, de modo que la ganancia se observa en la cantidad de iteraciones y no en la
posibilidad misma de converger.

### Método de Newton-Raphson

El método de Newton-Raphson parte de un valor inicial y reemplaza la función por su
recta tangente en ese punto, tomando como nueva aproximación la intersección de la
tangente con el eje de abscisas:

*x(k+1) = x(k) − F(x(k)) / F'(x(k))*

Para este problema, la derivada analítica es *F'(x) = 5 − 200/(500 − x)*. El programa no
la recibe: la aproxima por diferencia central con *h = 1e−4* y utiliza la misma técnica
para la segunda derivada, que emplea únicamente para verificar la condición de Fourier.

La convergencia es cuadrática, es decir que el error de cada paso es aproximadamente
proporcional al cuadrado del error del paso anterior: las cifras decimales correctas se
duplican en cada iteración. La condición suficiente de convergencia en un entorno de la
raíz es la de Fourier, *F(x0)·F''(x0) > 0*, que garantiza que la tangente en *x0* no
cruza el eje antes de la raíz y que la sucesión no se aleja de ella. Para *x0 = 200*,
*F(200) = −57.536414* y *F''(200) = −0.002228*, con lo cual
*F(x0)·F''(x0) = 0.128206 > 0* y la condición se cumple.

La contrapartida es la sensibilidad al valor inicial y la necesidad de que la derivada
no se anule: si *F'(x) = 0* en algún punto de la sucesión, el método no puede continuar.
Es el único de los tres que utiliza información de la pendiente, y por eso su iteración
resulta más costosa que las otras, aunque necesite muy pocos pasos.

### Comparación de los métodos

| Método | Orden de convergencia | Condición suficiente | Requiere derivada | Evaluaciones por iteración |
| :--- | :--- | :--- | :--- | :--- |
| Punto fijo | Lineal | *\|g'(x0)\| < 1* | No | 1 de *g*, 1 de *F* |
| Aitken | Cuadrática | Denominador no nulo | No | 2 de *g*, 1 de *F* |
| Newton-Raphson | Cuadrática | *F(x0)·F''(x0) > 0* | Sí, aproximada | 3 de *F* |

Los tres métodos comparten el mismo criterio de corte: se detienen cuando la diferencia
en valor absoluto entre dos aproximaciones sucesivas resulta menor que la tolerancia
ingresada. Esa elección hace comparables los resultados, pero conviene tener presente
que mide el paso y no el error real respecto de la raíz: un método puede detenerse con
un paso pequeño y un error verdadero algo mayor, sobre todo cuando la convergencia es
lenta.

---

## 2.2 Código fuente

El programa se organiza en un archivo conductor y cuatro archivos de funciones. El
conductor *principal.m* concentra toda la interacción con el usuario: muestra el menú,
valida cada dato ingresado, despacha al método elegido, mide el tiempo con *tic* y
*toc*, imprime el resultado y dibuja los gráficos. Las funciones de método no imprimen
ni grafican: sólo calculan y devuelven la terna *(raíz, iteraciones, convergió)*, de modo
que la presentación queda en un solo lugar y las funciones pueden reutilizarse.

*iteracion.m* implementa el punto fijo con la verificación previa de *|g'(x0)| < 1*.
*aceleracion.m* implementa la corrección delta cuadrado con control del denominador.
*newton_raphson.m* implementa Newton-Raphson con derivadas por diferencia central y la
verificación de la condición de Fourier. *tanteo.m* recorre un intervalo con un paso
dado y separa las raíces por cambio de signo; el conductor lo usa para sugerir un valor
inicial, aunque en este trabajo se ingresó *x0 = 200* en forma directa para que los tres
métodos partieran del mismo punto.

Las tres funciones de método validan la cantidad y el tipo de sus argumentos y fallan
con un mensaje explícito si reciben algo distinto de lo esperado. Ninguna tiene un tope
de iteraciones: si la sucesión no converge, el programa continúa hasta que el usuario
interrumpe la ejecución. Esa decisión mantiene el código simple, pero exige elegir el
valor inicial con criterio.

### `principal.m`

{{CODE:principal.m}}

### `tanteo.m`

{{CODE:tanteo.m}}

### `iteracion.m`

{{CODE:iteracion.m}}

### `newton_raphson.m`

{{CODE:newton_raphson.m}}

### `aceleracion.m`

{{CODE:aceleracion.m}}

---

## 2.3 Resultado de la ejecución

Los datos ingresados fueron los mismos en los tres casos: *x0 = 200*, tolerancia
*0.0001* y rango de graficación *[0, 400]*. La función de iteración fue
*g(x) = 200 + 40·ln(400/(500 − x))* y la función original
*F(x) = 5x − 200·ln(400/(500 − x)) − 1000*.

### Punto fijo

{{IMG:img/pf-consola.png|Salida de consola del método de punto fijo con x0 = 200 y tolerancia 0.0001}}

El método necesitó siete iteraciones para cumplir la tolerancia y llegó a
*213.3245*. La tabla muestra el comportamiento lineal esperado: cada paso reduce el
error en un factor cercano a *0.13*, que es el valor de *|g'(200)|*. El error pasa de
*11.5073* en la primera iteración a *0.0001* en la séptima.

### Newton-Raphson

{{IMG:img/newton-consola.png|Salida de consola del método de Newton-Raphson con x0 = 200 y tolerancia 0.0001}}

El método necesitó tres iteraciones y llegó a *213.3246*. La convergencia cuadrática se
observa en la columna de error: *13.2776*, luego *0.0469*, luego *0.0000*. El salto de la
primera a la segunda iteración concentra la mayor parte de la corrección. El programa
informó además que la condición de Fourier se cumple, con
*F(x0)·F''(x0) = 0.1282*.

### Aceleración de Aitken

{{IMG:img/aitken-consola.png|Salida de consola de la aceleración de Aitken con x0 = 200 y tolerancia 0.0001}}

El método necesitó tres iteraciones y llegó a *213.3246*, con la misma cantidad de pasos
que Newton-Raphson pero sin utilizar derivadas. La columna de error muestra el mismo
patrón cuadrático: *13.3180*, *0.0066*, *0.0000*.

### Barrido de tolerancias

Para comparar el comportamiento de los tres métodos frente a distintas exigencias de
precisión se repitió cada corrida veinte mil veces y se promedió el tiempo, con el fin de
que el resultado no quedara dominado por el ruido de una medición aislada. Las
tolerancias elegidas fueron *0.05*, *0.002* y *0.0001*.

{{INCLUIR:tabla-tolerancias.md}}

La lectura de la tabla es consistente con el análisis teórico. El punto fijo es el único
método cuya cantidad de iteraciones cambia con la tolerancia: pasa de cuatro a siete
iteraciones, porque su convergencia lineal obliga a recorrer el intervalo de error paso
a paso. Newton-Raphson y Aitken se estabilizan en tres iteraciones para las dos
tolerancias más finas: la convergencia cuadrática hace que el último paso ya esté muy
por debajo de la exigencia, de modo que endurecer la tolerancia no agrega iteraciones.

El tiempo de ejecución acompaña ese comportamiento, aunque con un matiz que conviene
explicitar: la diferencia entre métodos no proviene de un costo distinto por operación
aritmética, que es despreciable, sino de la cantidad de iteraciones y de evaluaciones
que cada uno realiza. El punto fijo es el más barato por iteración, porque evalúa *g*
una sola vez por paso, pero es el más lento en total porque necesita más pasos. Aitken
resulta el más rápido en el cómputo total, porque combina pocas iteraciones con
evaluaciones simples de *g*. Newton-Raphson iguala a Aitken en cantidad de iteraciones
pero paga más por cada una, ya que aproxima *F* y sus dos derivadas por diferencias
centrales.

---

## 2.4 Gráfico

{{IMG:img/pf-grafico1.png|Función original F(x) con la raíz marcada sobre el eje}}

El primer gráfico muestra la función original en el intervalo *[0, 400]*. La curva cruza
el eje de abscisas una sola vez, en el entorno de *213*, lo que confirma que la raíz
hallada es la única solución del problema dentro del dominio válido. El cruce es
transversal, con pendiente positiva, condición que favorece la convergencia de todos
los métodos.

{{IMG:img/pf-grafico2.png|Función de iteración g(x) y la recta y = x; la intersección es el punto fijo}}

El segundo gráfico corresponde a la función de iteración y a la recta *y = x*. El punto
fijo es la intersección de ambas curvas, y su cercanía a la raíz del problema confirma
que la transformación *x = g(x)* es equivalente a *F(x) = 0*. La pendiente de *g* en el
entorno del punto fijo es marcadamente menor que uno, que es la representación gráfica
de la condición *|g'| < 1* verificada numéricamente. Newton-Raphson no requiere este
segundo gráfico, porque no construye una función de iteración sino que trabaja
directamente sobre la tangente de *F*.

---

# 3. Conclusión

La aplicación de los tres métodos al mismo problema arrojó la misma raíz, *x ≈ 213.32*
unidades, con diferencias de pocas diezmilésimas entre ellos. Esa coincidencia es la
primera conclusión: los tres algoritmos son correctos y convergen al mismo resultado
cuando se cumplen sus condiciones, de modo que la elección entre ellos no depende de la
exactitud sino del costo y de la información disponible.

El punto fijo resultó el método más simple y el más lento: necesitó siete iteraciones
frente a tres de los otros dos, y su cantidad de pasos crece cuando se endurece la
tolerancia. Su virtud es que sólo requiere despejar *x* de la ecuación, sin derivadas, y
que la condición de convergencia es fácil de verificar antes de empezar. Su límite es
que esa condición es restrictiva: si *|g'|* supera la unidad en el entorno del punto
fijo, el método diverge y no hay corrección posible dentro del esquema.

La aceleración de Aitken fue el método más eficiente en este problema. Alcanzó la misma
cantidad de iteraciones que Newton-Raphson y el menor tiempo total, sin necesidad de
conocer derivadas. La corrección delta cuadrado transformó una sucesión linealmente
convergente en una cuadráticamente convergente a cambio de una evaluación adicional de
*g* por paso, un costo que resultó ampliamente compensado. Su limitación es que la
corrección puede no estar definida si el denominador se anula, situación que el
algoritmo detecta y reporta.

Newton-Raphson confirmó la convergencia cuadrática y la validez de la condición de
Fourier en *x0 = 200*, pero fue el más costoso por iteración: aproximar la función y sus
dos derivadas por diferencias centrales implica tres evaluaciones por paso, frente a una
o dos de los otros métodos. Su ventaja decisiva aparece cuando la derivada analítica está
disponible, porque entonces el costo por iteración baja y conserva la convergencia
cuadrática.

Respecto del tiempo de ejecución, la conclusión que se sostiene con los datos es que la
diferencia entre métodos sigue a la cantidad de iteraciones y de evaluaciones, no a una
mayor o menor eficiencia del procesador: las operaciones aritméticas involucradas son
despreciables frente al costo de iterar. Por ese motivo, en problemas de este tamaño el
criterio práctico para elegir un método es la información disponible —si se conoce la
derivada— y la facilidad para construir una función de iteración convergente, más que la
diferencia de tiempos medida en una corrida aislada.

Finalmente, una limitación del programa que conviene dejar asentada: ninguna de las tres
funciones tiene un tope de iteraciones. Si el valor inicial es inadecuado o la condición
de convergencia no se cumple, la ejecución no termina por sí sola. Agregar un máximo de
iteraciones y un mensaje de error explícito sería la mejora más directa del código.

---

# 4. Bibliografía

Burden, R. L. y Faires, J. D. *Análisis Numérico*. 10ª edición. Cengage Learning,
2017.

Chapra, S. C. y Canale, R. P. *Métodos Numéricos para Ingenieros*. 5ª edición.
McGraw-Hill, 2007.

Cátedra de Métodos Computacionales. *Guía de Actividades N° 3: Raíces de Ecuaciones*.
Facultad de Ciencias Exactas y Naturales y de Agrimensura, Universidad Nacional del
Nordeste, 2026.
