# Laboratorio 7: Ecuaciones Diferenciales

Soluciones en **GNU Octave / MATLAB** de la Guía de Actividades N° 7 de Métodos
Computacionales: integración numérica de ecuaciones diferenciales con problemas
de valor inicial.

Los métodos siguen la teoría de la cátedra: el método modificado de Euler es
predictor-corrector con el corrector **iterado** hasta una tolerancia `E`, y el
Runge-Kutta de segundo orden es la forma de Heun (una sola pasada), que equivale
al Euler modificado cuando se omiten las iteraciones.

---

## 📂 Estructura de Archivos

### 1. Scripts por Ejercicio

| Archivo | Qué resuelve |
| :--- | :--- |
| `01-euler-y-euler-modificado.m` | Ejercicio 1: `y' = x^2 + y^2` en `(0; 0,6)` con Euler y con Euler modificado (`E < 0,001`) |
| `02-crecimiento-poblacional.m` | Ejercicio 2: modelo logístico `P' = γP - τP²` con `h = 0,5` y `h = 0,25`, comparado con la solución exacta |
| `03-runge-kutta.m` | Ejercicio 3: Runge-Kutta de 2do y 4to orden sobre la ecuación del 1, y comparación de 3.a con 1.b |
| `04-tanque-drenaje.m` | Ejercicio 4 (complementario): vaciado del tanque, `dy/dt = -k√y`, y tiempo de vaciado |
| `05-milne-tabla.m` | Ejercicio 5: tabla `x / y / y'` con los valores de 3.a y Milne en `x = 0,8` y `x = 1` |
| `06-milne-edo-lineal.m` | Ejercicio 6: `y' = 3x + 3y`, arranque con Euler modificado y Milne en `x = 0,20` y `0,25` |

Cada script pide los datos por teclado y, si se presiona **Enter** sin escribir
nada, usa los valores del enunciado.

### 2. Funciones Auxiliares Modulares

| Archivo | Método |
| :--- | :--- |
| `euler.m` | Euler explícito |
| `euler_modificado.m` | Euler modificado (predictor-corrector con corrector iterado hasta `E`) |
| `runge_kutta_2.m` | Runge-Kutta de segundo orden (Heun, una sola pasada) |
| `runge_kutta_4.m` | Runge-Kutta de cuarto orden |
| `milne.m` | Milne (predicción 10.5 y corrección 10.6, con corrector iterado hasta `E`) |
| `leer_escalar.m` | Lectura de un dato escalar por teclado, con valor por defecto |
| `leer_vector.m` | Lectura de un vector por teclado, con valor por defecto |

---

## 🧮 Fórmulas Utilizadas

### Euler

```
y(i+1) = y(i) + h * f(x(i), y(i))
```

### Euler modificado (predictor-corrector)

```
P(y(i+1))  = y(i) + y'(i) * h
P(y'(i+1)) = f(x(i+1), P(y(i+1)))
C(y(i+1))  = y(i) + (y'(i) + P(y'(i+1))) / 2 * h
C(y'(i+1)) = f(x(i+1), C(y(i+1)))
C(y(i+1))  = y(i) + (y'(i) + C(y'(i+1))) / 2 * h
```

Las dos últimas se repiten hasta que dos correcciones consecutivas difieran en
menos que `E`.

### Runge-Kutta de segundo orden (Heun)

```
y(i+1) = y(i) + (k1 + k2) / 2
k1 = h * f(x(i), y(i))
k2 = h * f(x(i) + h, y(i) + k1)
```

### Runge-Kutta de cuarto orden

```
k1 = h * f(x(i), y(i))
k2 = h * f(x(i) + h/2, y(i) + k1/2)
k3 = h * f(x(i) + h/2, y(i) + k2/2)
k4 = h * f(x(i) + h,   y(i) + k3)
y(i+1) = y(i) + (k1 + 2k2 + 2k3 + k4) / 6
```

### Milne

```
P(y(i+1)) = y(i-3) + 4/3 * h * [2y'(i) - y'(i-1) + 2y'(i-2)]
C(y(i+1)) = y(i-1) + h/3 * [y'(i-1) + 4y'(i) + P(y'(i+1))]
```

No empieza por sí mismo: necesita los cuatro primeros valores ya calculados por
otro método (en el laboratorio, Euler modificado o Runge-Kutta).

---

## ▶️ Ejecución

```bash
cd lab-7
octave-cli 01-euler-y-euler-modificado.m
octave-cli 02-crecimiento-poblacional.m
octave-cli 03-runge-kutta.m
octave-cli 04-tanque-drenaje.m
octave-cli 05-milne-tabla.m
octave-cli 06-milne-edo-lineal.m
```

Correr siempre desde la carpeta `lab-7/`: Octave resuelve las funciones por el
directorio actual.

Los scripts 2, 4 y 6 abren una figura con la solución numérica contra la exacta.

---

## ✅ Requisitos

- GNU Octave 6.4.0 (o MATLAB).
- Ninguna librería adicional.
