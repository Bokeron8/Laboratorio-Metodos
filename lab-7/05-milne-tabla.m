% 05-milne-tabla.m
% =========================================================================
% SCRIPT: Ejercicio 5 - Milne a partir de los valores de Runge-Kutta 2
%   Toma la ecuación del ejercicio 1: y' = x^2 + y^2, y(0) = 1, h = 0,2.
%   Completa la tabla x / y / y' con los cuatro primeros valores de 3.a y
%   aplica el método de Milne para obtener y en x = 0,8 y x = 1.
%
%   ATENCIÓN: la solución de y' = x^2 + y^2 con y(0) = 1 tiene una asíntota
%   vertical en x ≈ 0,97, así que y(1) no existe. El script calcula lo que sí
%   existe y documenta el motivo por el que el segundo valor pedido no puede
%   obtenerse.
% =========================================================================

clear; clc;

printf("=== EJERCICIO 5: Método de Milne (no empieza por sí mismo) ===\n\n");
printf("Ecuación diferencial: y' = x^2 + y^2\n");
printf("Los cuatro primeros valores se toman de 3.a (Runge-Kutta de 2do orden).\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

f  = @(x, y) x^2 + y^2;
h  = leer_escalar("Paso h [0.2]: ", 0.2);
xf = leer_escalar("Extremo final del intervalo [0.8]: ", 0.8);
E  = leer_escalar("Tolerancia del corrector E [0.001]: ", 0.001);

% -------------------------------------------------------------------------
% Los cuatro puntos iniciales salen de 3.a: Runge-Kutta 2 en (0; 0,6)
% -------------------------------------------------------------------------
[x_rk, y_rk] = runge_kutta_2(f, 0, 1, h, 0.6);

% -------------------------------------------------------------------------
% a) Milne en los puntos que la solución permite alcanzar
% -------------------------------------------------------------------------
[x, y, it] = milne(f, x_rk, y_rk, h, xf, E);

printf("\n--- Tabla: x, y, y' ---\n");
printf("%10s %16s %16s %14s\n", "x", "y", "y'", "origen");
for i = 1:length(x)
    if i <= 4
        origen = "RK2 (3.a)";
    else
        origen = "Milne";
    end
    printf("%10.4f %16.8f %16.8f %14s\n", x(i), y(i), f(x(i), y(i)), origen);
end

printf("\nCorrecciones del corrector de Milne por paso:\n");
for i = 1:length(it)
    printf("  x = %.4f: %d\n", x(i + 4), it(i));
end

% -------------------------------------------------------------------------
% b) El valor en x = 1 no existe: la solución tiene una asíntota vertical
% -------------------------------------------------------------------------
printf("\n--- El valor pedido en x = 1 ---\n");
try
    [x_1, y_1] = milne(f, x_rk, y_rk, h, 1, E);
    printf("y(1) = %.6f\n", y_1(end));
catch err
    printf("Milne no converge hacia x = 1: %s\n", err.message);
    printf("\nLa ecuación y' = x^2 + y^2 con y(0) = 1 tiene una asíntota vertical\n");
    printf("antes de x = 1: la solución crece sin límite y y(1) no existe.\n");
    printf("Referencia calculada con RK4 de paso fino (h = 0,0005):\n");
    for x_ref = [0.90, 0.95, 0.96]
        [~, y_ref] = runge_kutta_4(f, 0, 1, 0.0005, x_ref);
        printf("  y(%.2f) = %14.4f\n", x_ref, y_ref(end));
    end
    printf("\nEl intervalo de la consigna excede el dominio de la solución, así\n");
    printf("que el segundo punto pedido no se puede calcular.\n");
end
