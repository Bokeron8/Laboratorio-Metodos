% 02-gauss-seidel.m - Ejercicio 2 de la Guía 4: Método de Gauss-Seidel
clc;
clear;

fprintf('========================================================\n');
fprintf('  EJERCICIO 2 - SISTEMA CON GAUSS-SEIDEL\n');
fprintf('========================================================\n');

% Sistema dado en la guía (reordenado para asegurar dominancia diagonal)
A = [3.0, -0.1, -0.2;
     0.1,  7.0, -0.3;
     0.3, -0.2, -10.3];

b = [7.85; -19.30; -19.30];

x0 = [1; 1; 1];
tol = 1e-5;
max_iter = 100;

fprintf('Matriz A:\n');
disp(A);
fprintf('Vector b:\n');
disp(b');
fprintf('Vector inicial x0: [%.1f, %.1f, %.1f]''\n', x0);

[x, iter, tiempo] = resolver_gauss_seidel_func(A, b, x0, tol, max_iter);

fprintf('\n--- Resultados ---\n');
fprintf('Iteraciones: %d\n', iter);
fprintf('Tiempo de ejecución: %.6f segundos\n', tiempo);
fprintf('Solución:\n');
fprintf('  x1 = %.6f\n', x(1));
fprintf('  x2 = %.6f\n', x(2));
fprintf('  x3 = %.6f\n', x(3));
