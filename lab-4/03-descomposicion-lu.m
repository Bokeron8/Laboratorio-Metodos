% 03-descomposicion-lu.m - Ejercicio 3 de la Guía 4: Descomposición LU
clc;
clear;

fprintf('========================================================\n');
fprintf('  EJERCICIO 3 - FACTORIZACIÓN LU (DOOLITTLE)\n');
fprintf('========================================================\n');

A = [2, 3, 4;
     4, 5, 10;
     4, 8, 2];

b = [6; 16; 2];

fprintf('Matriz A:\n');
disp(A);
fprintf('Vector b:\n');
disp(b');

[x, L, U, y, tiempo] = resolver_lu_func(A, b);

fprintf('\n--- Resultados ---\n');
fprintf('Tiempo de ejecución: %.6f segundos\n', tiempo);
fprintf('Matriz L:\n');
disp(L);
fprintf('Matriz U:\n');
disp(U);
fprintf('Vector intermedio y (L*y = b):\n');
disp(y');
fprintf('Solución x (U*x = y):\n');
fprintf('  x1 = %.4f\n', x(1));
fprintf('  x2 = %.4f\n', x(2));
fprintf('  x3 = %.4f\n', x(3));
