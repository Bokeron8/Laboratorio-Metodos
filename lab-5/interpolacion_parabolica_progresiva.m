% interpolacion_parabolica_progresiva.m
% =========================================================================
% FUNCIÓN: interpolacion_parabolica_progresiva
% DESCRIPCIÓN: Realiza interpolación parabólica progresiva seleccionando
%              3 puntos consecutivos cercanos al valor de evaluación.
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas
%   - y_vals : Vector de ordenadas
%   - x_eval : Valor de x a evaluar
% PARÁMETROS DE SALIDA:
%   - y_eval        : Valor interpolado en x_eval
%   - puntos_usados : Matriz con los 3 puntos [x; y] utilizados
% =========================================================================

function [y_eval, puntos_usados] = interpolacion_parabolica_progresiva(x_vals, y_vals, x_eval)
    n = length(x_vals);
    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 3
        error("Se requieren al menos 3 puntos.");
    end

    idx = -1;
    for i = 1:n-2
        if x_vals(i) <= x_eval && x_eval <= x_vals(i+2)
            idx = i;
            break;
        end
    end

    if idx == -1
        if x_eval < x_vals(1)
            idx = 1;
        else
            idx = n - 2;
        end
    end

    indices = idx:(idx+2);
    x_sub = x_vals(indices);
    y_sub = y_vals(indices);
    puntos_usados = [x_sub; y_sub];

    [y_eval, ~] = lagrange(x_sub, y_sub, x_eval);
end
