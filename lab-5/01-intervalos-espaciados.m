% 01-intervalos-espaciados.m
% =========================================================================
% SCRIPT: Ejercicio 1 - Interpolación en intervalos regularmente espaciados
% =========================================================================

clear; clc;

printf("=== EJERCICIO 1: Interpolación en intervalos regularmente espaciados ===\n\n");

x = [15, 25, 35, 45, 55, 65];
y = [0.965926, 0.906308, 0.819152, 0.707107, 0.573576, 0.422618];

disp("Tabla de datos (x e y):");
disp([x; y]');

% a. Newton-Gregory Ascendente para x = 17
x_eval_1 = 17;
[y_eval_1, tabla_asc] = newton_gregory_ascendente(x, y, x_eval_1);
printf("\n--- Apartado a: Newton-Gregory Ascendente ---\n");
printf("Para x = %.2f, el valor interpolado y = %.6f\n", x_eval_1, y_eval_1);

% b. Newton-Gregory Descendente para x = 60
x_eval_2 = 60;
[y_eval_2, tabla_desc] = newton_gregory_descendente(x, y, x_eval_2);
printf("\n--- Apartado b: Newton-Gregory Descendente ---\n");
printf("Para x = %.2f, el valor interpolado y = %.6f\n", x_eval_2, y_eval_2);

% c. Interpolación Inversa Lineal y Cuadrática para y = 0.90728517
y_target = 0.90728517;
x_inv_lin = interpolacion_inversa_lineal(x, y, y_target);
x_inv_quad = interpolacion_inversa_cuadratica(x, y, y_target);

printf("\n--- Apartado c: Interpolación Inversa para y = %.8f ---\n", y_target);
printf("Valor de x (Interpolación Inversa Lineal)    = %.6f\n", x_inv_lin);
printf("Valor de x (Interpolación Inversa Cuadrática) = %.6f\n", x_inv_quad);
