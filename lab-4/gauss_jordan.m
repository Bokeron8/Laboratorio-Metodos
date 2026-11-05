% gauss_jordan.m
% Resuelve Ax = b mediante el Método de Gauss-Jordan con Pivoteo Parcial

clc;
clear;

disp("=== MÉTODO DE GAUSS-JORDAN ===");
disp("Ejemplo matriz A: [2 3 4; 4 5 10; 4 8 2]");
disp("Ejemplo vector b: [6; 16; 2]");

A = input("Ingrese la matriz de coeficientes A: ");
b = input("Ingrese el vector de términos independientes b: ");

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

% Construcción de la matriz aumentada [A | b]
Ab = [A, b];

tic; % Medir tiempo de ejecución
for k = 1:n
    % 1. Pivoteo parcial: seleccionar el elemento máximo en la columna k
    [max_val, p] = max(abs(Ab(k:n, k)));
    p = p + k - 1;

    if max_val < 1e-12
        error("El sistema no tiene solución única (matriz singular o casi singular).");
    end

    % Intercambio de filas si es necesario
    if p ~= k
        Ab([k, p], :) = Ab([p, k], :);
    end

    % 2. Normalización de la fila pivote para que el pivote sea 1
    Ab(k, :) = Ab(k, :) / Ab(k, k);

    % 3. Eliminación en todas las demás filas (arriba y abajo del pivote)
    for i = 1:n
        if i ~= k
            factor = Ab(i, k);
            Ab(i, :) = Ab(i, :) - factor * Ab(k, :);
        end
    end
end
tiempo = toc;

% El vector solución se encuentra directamente en la última columna
x = Ab(:, n+1);

% --- SALIDA DE RESULTADOS ---
fprintf("\nTiempo de ejecución: %e segundos\n", tiempo);

disp("Matriz final reducida [I | x]:");
disp(Ab);

fprintf("Solución del sistema (x):\n");
for i = 1:n
    fprintf("  x%d = %.6f\n", i, x(i));
end
