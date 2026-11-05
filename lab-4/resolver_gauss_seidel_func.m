% resolver_gauss_seidel_func.m
% =========================================================================
% FUNCIÓN: resolver_gauss_seidel_func
% DESCRIPCIÓN: Resuelve Ax = b mediante el método iterativo de Gauss-Seidel.
% PARÁMETROS DE ENTRADA:
%   - A        : Matriz de coeficientes (n x n)
%   - b        : Vector de términos independientes (n x 1)
%   - x0       : Vector de aproximación inicial (n x 1)
%   - tol      : Tolerancia de error relativa deseada
%   - max_iter : Número máximo de iteraciones permitidas
% PARÁMETROS DE SALIDA:
%   - x      : Vector solución aproximada (n x 1)
%   - iter   : Número de iteraciones realizadas hasta converger
%   - tiempo : Tiempo de ejecución en segundos
% =========================================================================

function [x, iter, tiempo] = resolver_gauss_seidel_func(A, b, x0, tol, max_iter)
    if isrow(b)
        b = b';
    end
    if isrow(x0)
        x0 = x0';
    end

    [n, m] = size(A);
    if n ~= m || length(b) ~= n || length(x0) ~= n
        error("Dimensiones incompatibles.");
    end

    x = x0;
    iter = 0;
    error_calc = tol + 1;

    tic;
    while error_calc > tol && iter < max_iter
        iter = iter + 1;
        x_ant = x;

        for i = 1:n
            suma1 = A(i, 1:i-1) * x(1:i-1);
            suma2 = A(i, i+1:n) * x_ant(i+1:n);
            x(i) = (b(i) - suma1 - suma2) / A(i, i);
        end

        error_calc = norm(x - x_ant, inf) / max(norm(x, inf), 1e-12);
    end
    tiempo = toc;
end
