% resolver_potencias_func.m
% =========================================================================
% FUNCIÓN: resolver_potencias_func
% DESCRIPCIÓN: Aplica el Método de las Potencias para aproximar el autovalor
%              dominante (de mayor magnitud) y su autovector asociado.
% PARÁMETROS DE ENTRADA:
%   - A        : Matriz cuadrada (n x n)
%   - x0       : Vector inicial de aproximación (n x 1)
%   - max_iter : Número de iteraciones a realizar
% PARÁMETROS DE SALIDA:
%   - lambda_k : Autovalor dominante aproximado
%   - x        : Autovector normalizado aproximado (n x 1)
%   - tiempo   : Tiempo de ejecución en segundos
% =========================================================================

function [lambda_k, x, tiempo] = resolver_potencias_func(A, x0, max_iter)
    if isrow(x0)
        x0 = x0';
    end

    [n, m] = size(A);
    if n ~= m || length(x0) ~= n
        error("Dimensiones incompatibles.");
    end

    x = x0;
    lambda_k = 0;

    tic;
    for k = 1:max_iter
        y = A * x;
        [~, idx] = max(abs(y));
        lambda_k = y(idx);
        x = y / lambda_k;
    end
    tiempo = toc;
end
