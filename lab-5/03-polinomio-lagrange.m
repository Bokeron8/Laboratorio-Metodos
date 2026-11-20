% 03-polinomio-lagrange.m
% =========================================================================
% SCRIPT: Ejercicio 3 - Polinomio interpolador de Lagrange
% =========================================================================

clear; clc;

printf("=== EJERCICIO 3: Polinomio de Lagrange en datos no equidistantes ===\n\n");

x = [0, 0.4, 0.75, 1.5, 2.0];
y = [1, 1.63246, 1.86603, 2.22474, 2.41421];

disp("Tabla de datos (x e y):");
disp([x; y]');

% a. Interpolar el valor x = 1
x_eval_1 = 1.0;
[y_eval_1, L1] = lagrange(x, y, x_eval_1);

printf("\n--- Apartado a: Interpolación para x = 1.0 ---\n");
printf("Valor interpolado y(1.0) = %.6f\n", y_eval_1);

% b. Interpolar el valor x = 0.45
x_eval_2 = 0.45;
[y_eval_2, L2] = lagrange(x, y, x_eval_2);

printf("\n--- Apartado b: Interpolación para x = 0.45 ---\n");
printf("Valor interpolado y(0.45) = %.6f\n", y_eval_2);
