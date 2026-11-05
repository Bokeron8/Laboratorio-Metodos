% resolver_lu_func.m
% =========================================================================
% FUNCIÓN: resolver_lu_func
% DESCRIPCIÓN: Resuelve Ax = b mediante Factorización LU (Método de Doolittle),
%              factorizando A en L (triangular inferior) y U (triangular superior).
% PARÁMETROS DE ENTRADA:
%   - A : Matriz cuadrada de coeficientes (n x n)
%   - b : Vector de términos independientes (n x 1 o 1 x n)
% PARÁMETROS DE SALIDA:
%   - x       : Vector solución final (n x 1)
%   - L       : Matriz triangular inferior (n x n)
%   - U       : Matriz triangular superior (n x n)
%   - y       : Vector intermedio de sustitución progresiva L*y = b
%   - tiempo  : Tiempo de ejecución en segundos
% =========================================================================

function [x, L, U, y, tiempo] = resolver_lu_func(A, b)
    if isrow(b)
        b = b';
    end

    [n, m] = size(A);
    if n ~= m || length(b) ~= n
        error("Dimensiones incompatibles.");
    end

    L = eye(n);
    U = zeros(n);

    tic;
    for i = 1:n
        for k = i:n
            suma = L(i, 1:i-1) * U(1:i-1, k);
            U(i, k) = A(i, k) - suma;
        end

        if abs(U(i, i)) < 1e-12
            error("Pivote nulo en U. Se requiere pivoteo.");
        end

        for k = i+1:n
            suma = L(k, 1:i-1) * U(1:i-1, i);
            L(k, i) = (A(k, i) - suma) / U(i, i);
        end
    end

    % Sustitución progresiva L*y = b
    y = zeros(n, 1);
    for i = 1:n
        y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    end

    % Sustitución regresiva U*x = y
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (y(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
    end
    tiempo = toc;
end
