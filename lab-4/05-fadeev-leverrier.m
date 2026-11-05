% 05-fadeev-leverrier.m - Sistemas Homogéneos Ejercicio 1: Faddeev-LeVerrier
clc;
clear;

fprintf('========================================================\n');
fprintf('  SISTEMAS HOMOGÉNEOS - MÉTODO DE FADDEEV-LEVERRIER\n');
fprintf('========================================================\n');

A = [3,  2, -1;
     1, -2,  3;
     2,  0,  4];

fprintf('Matriz A:\n');
disp(A);

[autovalores, autovectores, coefs, tiempo] = resolver_fadeev_func(A);

fprintf('\n--- Resultados ---\n');
fprintf('Tiempo de ejecución: %.6f segundos\n', tiempo);
fprintf('Autovalores hallados:\n');
for i = 1:length(autovalores)
    fprintf('  lambda_%d = %.4f\n', i, autovalores(i));
end
