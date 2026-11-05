% eliminacion_gauss.m
% Resuelve Ax = b mediante Eliminación de Gauss con Pivoteo Parcial

clc;
clear;

disp("=== MÉTODO DE ELIMINACIÓN DE GAUSS ===");
disp("Ejemplo de entrada para matriz A: [80 15 35 60; 28 72 57 25; 20 20 12 20; 50 10 20 60]");
A = input("Ingrese la matriz de coeficientes A: ");
b = input("Ingrese el vector de términos independientes b (como columna o fila): ");

% Asegurar que b sea vector columna
if isrow(b)
    b = b';
end

[n, m] = size(A);
if n ~= m
    error("La matriz A debe ser cuadrada.");
end
if length(b) ~= n
    error("Las dimensiones de A y b no coinciden.");
end

% Construcción de la matriz aumentada
Ab = [A, b];

% --- FASE 1: ELIMINACIÓN HACIA ADELANTE (Triangulación) ---
tic; % Medir tiempo de ejecución
for k = 1:n-1
    % Pivoteo parcial
    [max_val, p] = max(abs(Ab(k:n, k)));
    p = p + k - 1;

    if max_val < 1e-12
        error("El sistema no tiene solución única (matriz singular o casi singular).");
    end

    if p ~= k
        % Intercambio de filas
        Ab([k, p], :) = Ab([p, k], :);
    end

    % Eliminación
    for i = k+1:n
        factor = Ab(i, k) / Ab(k, k);
        Ab(i, k:n+1) = Ab(i, k:n+1) - factor * Ab(k, k:n+1);
    end
end

% Verificar el último pivote
if abs(Ab(n, n)) < 1e-12
    error("El sistema no tiene solución única.");
end

% --- FASE 2: SUSTITUCIÓN REGRESIVA ---
x = zeros(n, 1);
x(n) = Ab(n, n+1) / Ab(n, n);

for i = n-1:-1:1
    suma = Ab(i, i+1:n) * x(i+1:n);
    x(i) = (Ab(i, n+1) - suma) / Ab(i, i);
end
tiempo = toc;

% --- SALIDA DE RESULTADOS ---
fprintf("\nTiempo de ejecución: %e segundos\n", tiempo);
fprintf("Matriz triangular superior aumentada final:\n");
disp(Ab);

fprintf("Solución del sistema (x):\n");
for i = 1:n
    fprintf("  x%d = %.4f\n", i, x(i));
end

% Cálculo específico para el Ejercicio 1 si n == 4
if n == 4
    costos_unitarios = [18; 5; 7; 20];
    costo_total = sum(x .* costos_unitarios);
    fprintf("\n--- Resultados del Ejercicio 1 ---\n");
    fprintf("Cebada (x4): %.4f kg\n", x(4));
    fprintf("Alfalfa (x3): %.4f kg\n", x(3));
    fprintf("Desperdicio (x2): %.4f kg\n", x(2));
    fprintf("Maíz (x1): %.4f kg\n", x(1));
    fprintf("Costo total de la mezcla: $%.2f\n", costo_total);
end
