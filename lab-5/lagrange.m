% lagrange.m
% =========================================================================
% FUNCIÓN: lagrange
% DESCRIPCIÓN: Calcula el polinomio interpolador de Lagrange evaluado en x_eval.
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas
%   - y_vals : Vector de ordenadas
%   - x_eval : Valor de x a evaluar
% PARÁMETROS DE SALIDA:
%   - y_eval : Valor interpolado en x_eval
%   - L      : Polinomios base de Lagrange evaluados
% =========================================================================

function [y_eval, L] = lagrange(x_vals, y_vals, x_eval)
    n = length(x_vals);
    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end

    y_eval = 0;
    L = zeros(1, n);

    for i = 1:n
        l_i = 1;
        for j = 1:n
            if j ~= i
                l_i = l_i * (x_eval - x_vals(j)) / (x_vals(i) - x_vals(j));
            end
        end
        L(i) = l_i;
        y_eval = y_eval + y_vals(i) * l_i;
    end
end
