# Laboratorio 6: Derivación e Integración Numérica

Este directorio contiene los scripts y funciones en **GNU Octave / MATLAB** correspondientes a la **Guía de Actividades N° 6** de la materia Métodos Computacionales.

---

## 📂 Estructura de Archivos

### 1. Scripts por Ejercicio

* **`01-derivacion-newton-gregory.m`**: Resuelve el **Ejercicio 1**. Construye la tabla de diferencias finitas y calcula:
  * $f'(12)$ con la fórmula de **Newton-Gregory Ascendente**.
  * $f'(12.4)$ con las fórmulas **Ascendente** y **Descendente**, comparando ambos resultados.
  * $f''(17)$ con la fórmula de **Newton-Gregory Descendente**.
  * Muestra además la sensibilidad de cada derivada a la cantidad de términos utilizados.

* **`02-integral-tabla-corriente.m`**: Resuelve el **Ejercicio 2**. Calcula la integral de la tabla de corriente con la **regla de los Trapecios** y analiza las combinaciones posibles con las fórmulas de **Simpson 1/3** y **Simpson 3/8**.

* **`03-integral-tabla-ejercicio1.m`**: Resuelve el **Ejercicio 3**. Calcula la integral $\int_{12}^{17} f(x)\,dx$ con **Trapecios** y con las combinaciones posibles de **Trapecios** y **Simpson 1/3**, dado que la tabla tiene un número impar de intervalos.

* **`04-combinacion-simpson.m`**: Resuelve el **Ejercicio 4**. Combina las dos fórmulas de **Simpson 1/3** y **Simpson 3/8** sobre la misma integral del Ejercicio 3 y compara los resultados obtenidos con los del ejercicio anterior.

* **`05-pruebas.m`**: Prueba los algoritmos con funciones de valor conocido (polinomios, exponencial y seno) para verificar su correcto funcionamiento.

---

### 2. Funciones Auxiliares Modulares

* `tabla_diferencias.m`: Construye la tabla de diferencias finitas hacia adelante. Las diferencias descendentes se leen sobre la diagonal inferior derecha.
* `mostrar_tabla_diferencias.m`: Imprime la tabla de diferencias en forma triangular.
* `newton_gregory_derivada.m`: Deriva el polinomio de Newton-Gregory en la variable auxiliar $p$ y devuelve la derivada de orden indicado. Permite elegir entre fórmula ascendente y descendente.
* `trapecios.m`: Regla compuesta de los Trapecios.
* `simpson_13.m`: Regla compuesta de Simpson 1/3 (requiere un número par de intervalos).
* `simpson_38.m`: Regla compuesta de Simpson 3/8 (requiere un número de intervalos múltiplo de 3).
* `integrar.m`: Selecciona la regla de integración o combina automáticamente Simpson 3/8 y Simpson 1/3 según la cantidad de intervalos.
* `leer_vector.m` y `leer_escalar.m`: Lectura de datos por teclado con valor por defecto al presionar **Enter**.

---

## 🧮 Fórmulas Utilizadas

### Derivación con Newton-Gregory

Con $p = \dfrac{x - x_1}{h}$ (ascendente) o $p = \dfrac{x - x_n}{h}$ (descendente), el polinomio de Newton se expresa en potencias de $p$. La derivada respecto de $x$ se obtiene derivando respecto de $p$:

$$
f^{(k)}(x) = \frac{1}{h^k}\,\frac{d^k P(p)}{dp^k}
$$

### Integración numérica

* **Trapecios:** $\displaystyle I = \frac{h}{2}\left[y_1 + 2\sum_{i=2}^{n-1} y_i + y_n\right]$
* **Simpson 1/3:** $\displaystyle I = \frac{h}{3}\left[y_1 + 4\sum_{\text{impares}} y_i + 2\sum_{\text{pares}} y_i + y_n\right]$
* **Simpson 3/8:** $\displaystyle I = \frac{3h}{8}\left[y_1 + 3\!\!\sum_{\substack{i=2\\ i\not\equiv 0\,(3)}}^{n-1}\!\! y_i + 2\!\!\sum_{\substack{i=4\\ i\equiv 0\,(3)}}^{n-1}\!\! y_i + y_n\right]$

Cuando la cantidad de intervalos no permite aplicar una sola fórmula, se combinan las reglas sobre subintervalos contiguos.

---

## ▶️ Ejecución

Para ejecutar cualquiera de los scripts en GNU Octave o MATLAB:

```octave
% Ejemplo para ejecutar el ejercicio 1:
run('01-derivacion-newton-gregory.m')
```

*(Asegúrese de encontrarse posicionado en el directorio `lab-6/`.)*

Cada script solicita los datos por teclado. Al presionar **Enter** sin ingresar un valor se utilizan los datos del enunciado, de modo que el script puede ejecutarse de forma directa.

---

## ✅ Requisitos

* GNU Octave 6.x o superior, o MATLAB.
* No se requieren paquetes adicionales.
