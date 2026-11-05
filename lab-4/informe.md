# Informe Técnico: Integración Numérica (TP 06)

**Alumnos:** Franco Zambrano · Gabriel Bazzola  
**Asignatura:** Métodos Computacionales · FaCENA – UNNE (2026)  

---

## 1. Introducción

La integración numérica constituye una herramienta fundamental en la ingeniería y las ciencias aplicadas para aproximar el valor de integrales definidas cuando la función analítica no se conoce, es sumamente compleja, o cuando únicamente se dispone de un conjunto discreto de mediciones experimentales o datos tabulados.

Según la teoría de **Fórmulas de Newton-Cotes** desarrollada en la cátedra, los métodos de integración numérica se basan en reemplazar una función complicada o un conjunto de datos discretos por un polinomio de aproximación de grado n que resulta fácil de integrar analíticamente:

Integral [a, b] f(x) dx ≈ Integral [a, b] fn(x) dx

En este informe se abordan y resuelven en detalle los tres problemas de aplicación de la sección de **Resolución de Problemas del Trabajo Práctico N° 6**:
1. **Balance de masa en un reactor químico:** Estimación de la masa total de reactivo que entra o sale del sistema a partir de mediciones simultáneas de caudal y concentración (Q(t) y C(t)) con espaciamientos temporales variables.
2. **Estudio de transporte y tránsito vehicular:** Determinación del número de vehículos que cruzan un punto de control durante la hora pico mediante la integración de tasas de flujo vehicular registradas a distintos intervalos horarios.
3. **Cálculo de área de un terreno irregular:** Evaluación de la superficie de una parcela de terreno acotada por un río y bordes rectos utilizando perfiles de desplazamiento (offsets) sobre una línea base.

---

## 2. Marco Teórico y Métodos Utilizados

### 2.1. Regla Trapezoidal
La regla del trapecio representa el área bajo la función aproximándola mediante un polinomio de primer grado (una línea recta) en cada subintervalo. La fórmula general para n subintervalos es:

I ≈ Suma [ desde i=0 hasta n-1 ] de [ (f(xi) + f(xi+1)) / 2 ] * (xi+1 - xi)

*Condición de aplicabilidad:* Es universalmente aplicable y resulta ideal cuando los datos tabulados presentan espaciamientos irregulares o variables (Δt ≠ constante).

### 2.2. Regla de Simpson 1/3
Se basa en la utilización de segmentos de parábola (polinomio de segundo grado) para aproximar los arcos de curva entre tres puntos consecutivos con espaciamiento constante h:

I ≈ (h / 3) * [ f(x0) + 4*f(x1) + f(x2) ]

*Condición de aplicabilidad:* Requiere un número **par** de subintervalos (número impar de puntos) igualmente espaciados.

### 2.3. Regla de Simpson 3/8
Utiliza un polinomio interpolador de tercer grado sobre cuatro puntos consecutivos (tres subintervalos de ancho constante h):

I ≈ (3*h / 8) * [ f(x0) + 3*f(x1) + 3*f(x2) + f(x3) ]

---

## 3. Resolución de Problemas Aplicados

### Ejercicio 1 — Balance de masa en un reactor químico

**Enunciado:** La integración proporciona un medio para calcular cuánta masa entra o sale de un reactor durante un periodo específico de tiempo:
M = Integral [t1, t2] Q(t) * c(t) dt

A partir de las mediciones experimentales tabuladas:

| T (min) | 0 | 10 | 20 | 30 | 35 | 40 | 45 | 50 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Q (m3/min)** | 4.0 | 4.8 | 5.2 | 5.0 | 4.6 | 4.3 | 4.3 | 5.0 |
| **C (mg/m3)** | 10 | 35 | 55 | 52 | 40 | 37 | 32 | 34 |
| **f(t) = Q * C** | 40 | 168 | 286 | 260 | 184 | 159.1 | 137.6 | 170 |

#### Desarrollo paso a paso (Regla del Trapecio por intervalos variables):
1. Intervalo [0, 10] min (Δt = 10):  
   Área_1 = ((40 + 168) / 2) * 10 = 1040.00
2. Intervalo [10, 20] min (Δt = 10):  
   Área_2 = ((168 + 286) / 2) * 10 = 2270.00
3. Intervalo [20, 30] min (Δt = 10):  
   Área_3 = ((286 + 260) / 2) * 10 = 2730.00
4. Intervalo [30, 35] min (Δt = 5):  
   Área_4 = ((260 + 184) / 2) * 5 = 1110.00
5. Intervalo [35, 40] min (Δt = 5):  
   Área_5 = ((184 + 159.1) / 2) * 5 = 857.75
6. Intervalo [40, 45] min (Δt = 5):  
   Área_6 = ((159.1 + 137.6) / 2) * 5 = 741.75
7. Intervalo [45, 50] min (Δt = 5):  
   Área_7 = ((137.6 + 170) / 2) * 5 = 769.00

**Masa total acumulada (M):**
M = 1040 + 2270 + 2730 + 1110 + 857.75 + 741.75 + 769 = **9518.50 mg**

---

### Ejercicio 2 — Tránsito vehicular en hora pico

**Enunciado:** Determinar el número total de vehículos que pasan por un punto de control entre las 7:30 y las 9:15, dada la tasa de flujo q(t) en vehículos por minuto:

| Hora | 7:30 | 7:45 | 8:00 | 8:15 | 8:45 | 9:15 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **t (min desde 7:30)** | 0 | 15 | 30 | 45 | 75 | 105 |
| **q (veh/min)** | 4.5 | 6.0 | 6.5 | 5.0 | 4.5 | 2.25 |

#### Desarrollo paso a paso:
- **Tramo 1: de 7:30 a 8:15 ([0, 45] min, h = 15, 3 subintervalos).**  
  Aplicando la regla de **Simpson 3/8**:
  N_1 = (3 * 15 / 8) * [ 4.5 + 3*(6.0) + 3*(6.5) + 5.0 ] = 5.625 * [4.5 + 18 + 19.5 + 5.0] = **262.69 vehículos**

- **Tramo 2: de 8:15 a 9:15 ([45, 105] min, h = 30, 2 subintervalos).**  
  Aplicando la regla de **Simpson 1/3**:
  N_2 = (30 / 3) * [ 5.0 + 4*(4.5) + 2.25 ] = 10 * [5.0 + 18.0 + 2.25] = **252.50 vehículos**

**Número total de vehículos en la hora pico:**
N_total = 262.69 + 252.50 = **515.19 vehículos**

---

### Ejercicio 3 — Cálculo de área de terreno (Levantamiento topográfico)

**Enunciado:** Calcular el área de la parcela delimitada por una línea base y un cauce de agua irregular, a partir de los desplazamientos (y) medidos cada h = 10 m:

| x (m) | 0 | 10 | 20 | 30 | 40 | 50 | 60 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **y (m)** | 0 | 1.5 | 3.2 | 4.8 | 5.5 | 4.0 | 2.1 |

#### Desarrollo paso a paso (Regla de Simpson 1/3 con h = 10 m):
Área = (h / 3) * [ y0 + 4*(y1 + y3 + y5) + 2*(y2 + y4) + y6 ]
Área = (10 / 3) * [ 0 + 4*(1.5 + 4.8 + 4.0) + 2*(3.2 + 5.5) + 2.1 ]
Área = (10 / 3) * [ 0 + 4*(10.3) + 2*(8.7) + 2.1 ] = (10 / 3) * [ 0 + 41.2 + 17.4 + 2.1 ] = (10 / 3) * [ 60.7 ] = **202.33 m^2**

---

## 4. Análisis de Resultados y Discusión

1. **Manejo de intervalos irregulares:** En el Ejercicio 1, la variación en el paso temporal (Δt = 10 frente a Δt = 5 min) demostró la versatilidad de la regla del Trapecio, la cual permite calcular integrales sin restricciones sobre la uniformidad de la malla de datos.
2. **Selección del método de cuadratura:** La utilización de fórmulas de Newton-Cotes de orden superior (como Simpson 1/3 y Simpson 3/8) en los Ejercicios 2 y 3 proporciona una aproximación más precisa al modelar el contorno real mediante arcos de parábola y cúbicas, minimizando el error de truncamiento en comparación con la interpolación lineal simple.
3. **Contexto ingenieril:** Los resultados obtenidos permiten dimensionar con precisión magnitudes físicas clave (masa de reactivo, caudal acumulado de tránsito y superficie de terreno), cumpliendo con los estándares requeridos en proyectos de ingeniería.

---

## 5. Conclusiones

Se concluye que el dominio de las fórmulas de integración numérica (Trapecio, Simpson 1/3 y Simpson 3/8) es esencial para la resolución de problemas prácticos en ingeniería donde los datos se presentan en forma discreta. La elección criteriosa del método —según el espaciamiento de los datos y el comportamiento de la función— garantiza resultados precisos y confiables.

---

## 6. Referencias Bibliográficas

- Chapra, S. C., & Canale, R. P. (2015). *Métodos Numéricos para Ingenieros* (7ª ed.). McGraw-Hill.
- Pacce, G. (1997). *Métodos Numéricos*. Editorial EUDENE.
- Cátedra de Métodos Computacionales (2026). *Unidad 6: Integración numérica* y *Guía de Trabajos Prácticos - TP 06*. FaCENA – UNNE.
