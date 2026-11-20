% 03-runge-kutta.m
% =========================================================================
% SCRIPT: Ejercicio 3 - Runge-Kutta de 2do y 4to orden
%   Toma la ecuación del ejercicio 1: y' = x^2 + y^2, y(0) = 1, h = 0,2
%   Intervalo (0; 0,6).
%   Compara el resultado de 3.a con el Euler modificado del 1.b, que itera el
%   corrector hasta E < 0,001.
% =========================================================================

clear; clc;

printf("=== EJERCICIO 3: Runge-Kutta de 2do y 4to orden ===\n\n");
printf("Ecuación diferencial: y' = x^2 + y^2\n");
printf("Condiciones iniciales: x0 = 0, y0 = 1, h = 0,2\n");
printf("Intervalo: (0; 0,6)\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

f  = @(x, y) x^2 + y^2;
x0 = leer_escalar("x0 [0]: ", 0);
y0 = leer_escalar("y0 [1]: ", 1);
h  = leer_escalar("Paso h [0.2]: ", 0.2);
xf = leer_escalar("Extremo final del intervalo [0.6]: ", 0.6);
E  = leer_escalar("Tolerancia del Euler modificado E [0.001]: ", 0.001);

% -------------------------------------------------------------------------
% a) Runge-Kutta de segundo orden
% -------------------------------------------------------------------------
[x_2, y_2] = runge_kutta_2(f, x0, y0, h, xf);
printf("\n--- a) Runge-Kutta de 2do orden (Heun, una sola pasada) ---\n");
printf("%10s %14s\n", "x", "y");
for i = 1:length(x_2)
    printf("%10.4f %14.6f\n", x_2(i), y_2(i));
end

% -------------------------------------------------------------------------
% b) Runge-Kutta de cuarto orden
% -------------------------------------------------------------------------
[x_4, y_4] = runge_kutta_4(f, x0, y0, h, xf);
printf("\n--- b) Runge-Kutta de 4to orden ---\n");
printf("%10s %14s\n", "x", "y");
for i = 1:length(x_4)
    printf("%10.4f %14.6f\n", x_4(i), y_4(i));
end

% -------------------------------------------------------------------------
% Comparación 3.a contra 1.b
% -------------------------------------------------------------------------
% El Euler modificado del 1.b se recalcula acá para poder comparar en la misma
% tabla. Con el corrector iterado converge al mismo valor que RK2 sin iterar.
[x_m, y_m, it_m] = euler_modificado(f, x0, y0, h, xf, E);

printf("\n--- Comparación 3.a (RK2) con 1.b (Euler modificado, E < %g) ---\n", E);
printf("%10s %14s %14s %14s %14s\n", "x", "RK2", "E. modificado", "RK2 - E.mod", "RK4");
for i = 1:length(x_2)
    printf("%10.4f %14.6f %14.6f %14.6e %14.6f\n", x_2(i), y_2(i), y_m(i), ...
           y_2(i) - y_m(i), y_4(i));
end

printf("\nCorrecciones del corrector en el Euler modificado por paso:\n");
for i = 1:length(it_m)
    printf("  paso %d: %d\n", i, it_m(i));
end

printf("\nRK2 coincide exactamente con la primera corrección del Euler modificado:\n");
printf("es el mismo esquema sin iterar el corrector. Al iterarlo hasta E = %g\n", E);
printf("(1.b) se resuelve la ecuación implícita del trapecio, que tiene otra\n");
printf("constante de error, y con h = %g el resultado se separa.\n", h);
printf("RK4 es el más preciso de los tres y sirve de referencia, porque esta\n");
printf("ecuación no tiene solución exacta elemental.\n");
printf("\nDiferencias contra RK4 en x = %g:\n", x_2(end));
printf("  RK2 - RK4:              %+.6e\n", y_2(end) - y_4(end));
printf("  Euler modificado - RK4: %+.6e\n", y_m(end) - y_4(end));
