% =========================================================================
% SCRIPT PRINCIPAL: principal.m
% DESCRIPCIÓN: Ejecución del método de Gauss / Gauss-Jordan aplicado al
%              ejercicio resuelto de la práctica (06 - Método de Gauss-Jordan.pdf).
% =========================================================================

clear;
clc;

disp('=================================================================');
disp('   MÉTODO DE GAUSS-JORDAN - EJERCICIO PRÁCTICO (FaCENA - UNNE)     ');
disp('=================================================================');

% Definición del sistema de ecuaciones del PDF resuelto:
matriz_A = [
    18.72,  8.20,  8.76;
     6.40, 15.90,  7.18;
     5.22,  6.40, 14.31
];

vector_b = [121.280; 126.321; 118.522];

disp('Matriz de coeficientes (A):');
disp(matriz_A);

disp('Vector de términos independientes (b):');
disp(vector_b');

% Ejecución del algoritmo
tic;
[vector_x, matriz_resultado] = gauss_jordan(matriz_A, vector_b);
tiempo_proceso = toc;

disp('-----------------------------------------------------------------');
disp('RESULTADOS OBTENIDOS:');
fprintf('x1 = %.4f\n', vector_x(1));
fprintf('x2 = %.4f\n', vector_x(2));
fprintf('x3 = %.4f\n', vector_x(3));
fprintf('\nTiempo de ejecución: %.6f segundos\n', tiempo_proceso);
disp('-----------------------------------------------------------------');

disp('Matriz resultante del proceso:');
disp(matriz_resultado);

% Verificación por sustitución
disp('Verificación (A * x):');
verificacion = matriz_A * vector_x;
disp(verificacion');
disp('=================================================================');
