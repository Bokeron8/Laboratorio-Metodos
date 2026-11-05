% 01-agronomia.m - Ejercicio 1 de la Guía 4: Sistemas No Homogéneos (Eliminación de Gauss)
clc;
clear;

fprintf('========================================================\n');
fprintf('  EJERCICIO 1 - FÓRMULA ALIMENTICIA (ELIMINACIÓN DE GAUSS)\n');
fprintf('========================================================\n');

% Matriz de coeficientes A (Carbohidratos, Proteínas, Vitaminas, Celulosa)
% Variables: x1 = Maíz, x2 = Desperdicio, x3 = Alfalfa, x4 = Cebada
A = [80, 15, 35, 60;
     28, 72, 57, 25;
     20, 20, 12, 20;
     50, 10, 20, 60];

% Vector de requerimientos diarios b
b = [230; 180; 80; 160];

% Costos unitarios por kg
costos = [18; 5; 7; 20];

fprintf('Matriz de coeficientes A:\n');
disp(A);
fprintf('Vector de requerimientos b:\n');
disp(b');

% Resolver usando eliminación de Gauss (con pivoteo parcial)
[x, tiempo, Ab] = resolver_gauss(A, b);

fprintf('\n--- Resultados ---\n');
fprintf('Tiempo de ejecución: %.6f segundos\n', tiempo);
fprintf('Cantidad necesaria de cada material:\n');
fprintf('  • Maíz (x1):        %.4f kg\n', x(1));
fprintf('  • Desperdicio (x2): %.4f kg\n', x(2));
fprintf('  • Alfalfa (x3):     %.4f kg\n', x(3));
fprintf('  • Cebada (x4):      %.4f kg\n', x(4));

costo_total = sum(x .* costos);
fprintf('\nCosto total de la mezcla: $%.2f\n', costo_total);
