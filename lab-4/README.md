# Laboratorio 4: Resolución de Sistemas de Ecuaciones Lineales y Autovalores

Este directorio contiene los scripts y funciones en **GNU Octave / MATLAB** correspondientes a la **Guía de Actividades N° 4** de la materia Métodos Computacionales.

---

## 📂 Estructura de Archivos

### 1. Scripts por Ejercicio (Guía de Trabajos Prácticos)
Cada script resuelve un ejercicio específico de la guía utilizando los datos planteados en el enunciado:

* **`01-agronomia.m`**: Resuelve el **Ejercicio 1 (Sistemas No Homogéneos)** sobre la fórmula alimenticia para ganado (maíz, desperdicio, alfalfa y cebada) aplicando el **Método de Eliminación de Gauss** con pivoteo parcial e informando el costo total.
* **`02-gauss-seidel.m`**: Resuelve el **Ejercicio 2 (Sistemas No Homogéneos)** aplicando el **Método de Gauss-Seidel**, verificando previamente la dominancia diagonal y partiendo del vector inicial $(1, 1, 1)^T$.
* **`03-descomposicion-lu.m`**: Resuelve el **Ejercicio 3 (Sistemas No Homogéneos)** mediante la **Factorización LU (Doolittle)** ($A = L \cdot U$), mostrando las matrices $L$ y $U$, el vector intermedio $y$ y la solución final $x$.
* **`04-componentes-electronicos.m`**: Resuelve el **Ejercicio 4 (Sistemas No Homogéneos)** sobre la producción semanal de transistores, resistores y chips, presentando una **tabla comparativa** del tiempo de ejecución y resultados entre Gauss, Gauss-Jordan, Descomposición LU y Gauss-Seidel.
* **`05-fadeev-leverrier.m`**: Resuelve el **Ejercicio 1 (Sistemas Homogéneos)** utilizando el **Método de Faddeev-LeVerrier** para obtener los coeficientes del polinomio característico, los autovalores y sus autovectores asociados.
* **`06-metodo-potencias.m`**: Resuelve el **Ejercicio 2 (Sistemas Homogéneos)** utilizando el **Método de las Potencias** para determinar el autovalor dominante y su autovector tras 4 iteraciones a partir del vector inicial $(1, 1, -0.5)^T$.

---

### 2. Funciones Auxiliares Modulares
Implementaciones reutilizables de cada método numérico:

* `resolver_gauss.m`: Eliminación de Gauss con pivoteo parcial y sustitución regresiva.
* `resolver_gauss_jordan_func.m`: Método de Gauss-Jordan con pivoteo parcial y reducción a matriz identidad.
* `resolver_lu_func.m`: Factorización LU (Doolittle) con sustitución progresiva y regresiva.
* `resolver_gauss_seidel_func.m`: Método iterativo de Gauss-Seidel con control de tolerancia y número máximo de iteraciones.
* `resolver_fadeev_func.m`: Algoritmo de Faddeev-LeVerrier para trazas, coeficientes, raíces y autovectores.
* `resolver_potencias_func.m`: Iteración de potencias para autovalor dominante.

---

## ▶️ Ejecución

Para ejecutar cualquiera de los scripts en GNU Octave o MATLAB:

```octave
% Ejemplo para ejecutar el ejercicio 1:
01_agronomia
```
*(Asegúrese de encontrarse posicionado en el directorio `lab-4/`).*
