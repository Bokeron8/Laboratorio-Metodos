% newton_gregory_ascendente.m
% =========================================================================
% FUNCIÓN: newton_gregory_ascendente
% DESCRIPCIÓN: Calcula el valor interpolado usando la fórmula de 
%              Newton-Gregory Ascendente (diferencias finitas hacia adelante)
%              para puntos equidistantes.
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
%   - x_eval : Valor de x a evaluar
% PARÁMETROS DE SALIDA:
%   - y_eval : Valor interpolado en x_eval
%   - tabla  : Tabla de diferencias finitas generada
% =========================================================================

function [y_eval, tabla] = newton_gregory_ascendente(x_vals, y_vals, x_eval)
    n = length(x_vals);
    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    
    h = x_vals(2) - x_vals(1);
    if max(abs(diff(x_vals) - h)) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end

    tabla = zeros(n, n + 2);
    tabla(:, 1) = x_vals(:);
    tabla(:, 2) = y_vals(:);

    for j = 1:n-1
        for i = 1:n-j
            tabla(i, j + 2) = tabla(i+1, j + 1) - tabla(i, j + 1);
        end
    end

    p = (x_eval - x_vals(1)) / h;

    y_eval = tabla(1, 2);
    p_term = 1;
    factorial_k = 1;

    for k = 1:n-1
        p_term = p_term * (p - (k - 1));
        factorial_k = factorial_k * k;
        y_eval = y_eval + (p_term * tabla(1, k + 2)) / factorial_k;
    end
end
