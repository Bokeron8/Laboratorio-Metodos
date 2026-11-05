% resolver_gauss_jordan_func.m
% =========================================================================
% FUNCIÓN: resolver_gauss_jordan_func
% DESCRIPCIÓN: Resuelve Ax = b utilizando el Método de Gauss-Jordan con
%              Pivoteo Parcial, transformando la matriz en la identidad.
% PARÁMETROS DE ENTRADA:
%   - A : Matriz de coeficientes (n x n)
%   - b : Vector de términos independientes (n x 1 o 1 x n)
% PARÁMETROS DE SALIDA:
%   - x       : Vector solución (n x 1)
%   - tiempo  : Tiempo de ejecución en segundos
%   - Ab      : Matriz aumentada final [I | x]
% =========================================================================

function [x, tiempo, Ab] = resolver_gauss_jordan_func(A, b)
    if isrow(b)
        b = b';
    end

    [n, m] = size(A);
    if n ~= m || length(b) ~= n
        error("Dimensiones incompatibles.");
    end

    Ab = [A, b];

    tic;
    for k = 1:n
        [max_val, p] = max(abs(Ab(k:n, k)));
        p = p + k - 1;

        if max_val < 1e-12
            error("Matriz singular o casi singular.");
        end

        if p ~= k
            Ab([k, p], :) = Ab([p, k], :);
        end

        Ab(k, :) = Ab(k, :) / Ab(k, k);

        for i = 1:n
            if i ~= k
                factor = Ab(i, k);
                Ab(i, :) = Ab(i, :) - factor * Ab(k, :);
            end
        end
    end
    tiempo = toc;

    x = Ab(:, n+1);
end
