% 06-metodo-potencias.m - Sistemas Homogéneos Ejercicio 2: Método de las Potencias
clc;
clear;

fprintf('========================================================\n');
fprintf('  SISTEMAS HOMOGÉNEOS - MÉTODO DE LAS POTENCIAS\n');
fprintf('========================================================\n');

A = [2,   -1,    0;
    -0.5,  1, -0.5;
     0,   -1/3,  2/3];

x0 = [1; 1; -0.5];
max_iter = 4;

fprintf('Matriz A:\n');
disp(A);
fprintf('Vector inicial x0: [%.1f, %.1f, %.1f]''\n', x0);
fprintf('Número de iteraciones: %d\n', max_iter);

[lambda_k, x_k, tiempo] = resolver_potencias_func(A, x0, max_iter);

fprintf('\n--- Resultados ---\n');
fprintf('Tiempo de ejecución: %.6f segundos\n', tiempo);
fprintf('Autovalor dominante aproximado (iter %d): %.5f\n', max_iter, lambda_k);
fprintf('Autovector aproximado:\n');
disp(x_k');
