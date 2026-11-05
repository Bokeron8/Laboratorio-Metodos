% descomposicion_lu.m
% Factorización A = LU (Doolittle) y resolución de Ax = b

clc;
clear;

disp("=== DESCOMPOSICIÓN LU (DOOLITTLE) ===");
disp("Ejemplo matriz A: [2 3 4; 4 5 10; 4 8 2]");
disp("Ejemplo vector b: [6; 16; 2]");

A = input("Ingrese la matriz cuadrada A: ");
b = input("Ingrese el vector b: ");

if isrow(b)
    b = b';
end

[n, m] = size(A);
if n ~= m || length(b) ~= n
    error("Dimensiones inconsistentes.");
end

L = eye(n);
U = zeros(n);

tic;
% Factorización LU
for i = 1:n
    % Elementos de U
    for k = i:n
        suma = L(i, 1:i-1) * U(1:i-1, k);
        U(i, k) = A(i, k) - suma;
    end

    % Verificar si el pivote es nulo
    if abs(U(i, i)) < 1e-12
        error("El pivote U(%d,%d) es cero. Se requeriría pivoteo (PA = LU).", i, i);
    end

    % Elementos de L
    for k = i+1:n
        suma = L(k, 1:i-1) * U(1:i-1, i);
        L(k, i) = (A(k, i) - suma) / U(i, i);
    end
end

% Paso 1: Sustitución progresiva L*y = b
y = zeros(n, 1);
for i = 1:n
    y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
end

% Paso 2: Sustitución regresiva U*x = y
x = zeros(n, 1);
for i = n:-1:1
    x(i) = (y(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
end
tiempo = toc;

fprintf("\n--- RESULTADOS ---\n");
fprintf("Tiempo de ejecución: %e segundos\n\n", tiempo);

disp("Matriz L:");
disp(L);

disp("Matriz U:");
disp(U);

disp("Vector intermedio y (L*y = b):");
disp(y);

disp("Vector solución x (U*x = y):");
disp(x);
