# Laboratorio 5: Interpolación Numérica

Este directorio contiene los scripts y funciones en **GNU Octave / MATLAB** correspondientes a la **Guía de Actividades N° 5** de la materia Métodos Computacionales.

---

## 📂 Estructura de Archivos

### 1. Scripts por Ejercicio (Guía de Trabajos Prácticos)
Cada script resuelve un ejercicio específico de la guía utilizando los datos planteados en el enunciado:

* **`01-intervalos-espaciados.m`**: Resuelve el **Ejercicio 1** aplicando la **Fórmula de Newton-Gregory Ascendente** ($x=17$), la **Fórmula de Newton-Gregory Descendente** ($x=60$), e **Interpolación Inversa Lineal y Cuadrática** ($y=0.90728517$).
* **`02-censo-poblacion.m`**: Resuelve el **Ejercicio 2** sobre el censo de población de EE.UU. aplicando el **Método de Lagrange** para estimar la población en 1965 y realizando un análisis de exactitud y error.
* **`03-polinomio-lagrange.m`**: Resuelve el **Ejercicio 3** utilizando el **Polinomio Interpolador de Lagrange** en datos no equidistantes para evaluar en $x = 1.0$ y $x = 0.45$.
* **`04-densidad-sodio.m`**: Resuelve el **Ejercicio 4** sobre la densidad del sodio a distintas temperaturas aplicando **Lagrange** e **Interpolación Parabólica Progresiva** para $T = 275^\circ$, estimando el error y emitiendo conclusiones.

---

### 2. Funciones Auxiliares Modulares
Implementaciones reutilizables de cada método numérico:

* `newton_gregory_ascendente.m`: Tabla de diferencias finitas hacia adelante y evaluación polinómica.
* `newton_gregory_descendente.m`: Tabla de diferencias finitas hacia atrás y evaluación polinómica.
* `interpolacion_inversa_lineal.m`: Búsqueda de x dado y mediante interpolación lineal inversa.
* `interpolacion_inversa_cuadratica.m`: Búsqueda de x dado y utilizando los 3 puntos más cercanos (Lagrange inverso).
* `lagrange.m`: Polinomio interpolador de Lagrange para datos no equidistantes.
* `interpolacion_parabolica_progresiva.m`: Interpolación cuadrática local usando 3 puntos consecutivos.

---

## ▶️ Ejecución

Para ejecutar cualquiera de los scripts en GNU Octave o MATLAB:

```octave
% Ejemplo para ejecutar el ejercicio 1:
01_intervalos_espaciados
```
*(Asegúrese de encontrarse posicionado en el directorio `lab-5/`).*
