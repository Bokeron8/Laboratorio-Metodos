% 01-euler-y-euler-modificado.m
% =========================================================================
% SCRIPT: Ejercicio 1 - Euler y método modificado de Euler
%   y' = x^2 + y^2,  y(0) = 1,  h = 0,2,  intervalo (0; 0,6)
% =========================================================================

clear; clc;

printf("=== EJERCICIO 1: Euler y Euler modificado ===\n\n");
printf("Ecuación diferencial: y' = x^2 + y^2\n");
printf("Condiciones iniciales: x0 = 0, y0 = 1\n");
printf("Intervalo: (0; 0,6) con h = 0,2\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

f  = @(x, y) x^2 + y^2;
x0 = leer_escalar("x0 [0]: ", 0);
y0 = leer_escalar("y0 [1]: ", 1);
h  = leer_escalar("Paso h [0.2]: ", 0.2);
xf = leer_escalar("Extremo final del intervalo [0.6]: ", 0.6);
E  = leer_escalar("Tolerancia del corrector E [0.001]: ", 0.001);

% -------------------------------------------------------------------------
% a) Método de Euler
% -------------------------------------------------------------------------
[x_e, y_e] = euler(f, x0, y0, h, xf);
printf("\n--- a) Método de Euler ---\n");
printf("%10s %14s\n", "x", "y");
for i = 1:length(x_e)
    printf("%10.4f %14.6f\n", x_e(i), y_e(i));
end

% -------------------------------------------------------------------------
% b) Método modificado de Euler
% -------------------------------------------------------------------------
[x_m, y_m, it_m] = euler_modificado(f, x0, y0, h, xf, E);
printf("\n--- b) Método modificado de Euler (E < %g) ---\n", E);
printf("%10s %14s %12s\n", "x", "y", "correcciones");
printf("%10.4f %14.6f %12s\n", x_m(1), y_m(1), "-");
for i = 2:length(x_m)
    printf("%10.4f %14.6f %12d\n", x_m(i), y_m(i), it_m(i - 1));
end

% -------------------------------------------------------------------------
% Comparación de los dos métodos
% -------------------------------------------------------------------------
printf("\n--- Comparación Euler vs Euler modificado ---\n");
printf("%10s %14s %14s %14s\n", "x", "Euler", "E. modificado", "diferencia");
for i = 1:length(x_e)
    printf("%10.4f %14.6f %14.6f %14.6e\n", x_e(i), y_e(i), y_m(i), y_m(i) - y_e(i));
end
