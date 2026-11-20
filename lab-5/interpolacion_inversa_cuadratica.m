% interpolacion_inversa_cuadratica.m
% =========================================================================
% FUNCIÓN: interpolacion_inversa_cuadratica
% DESCRIPCIÓN: Determina el valor de x correspondiente a un valor dado y_eval
%              mediante interpolación inversa cuadrática utilizando los 3
%              puntos cuyos valores de y son más cercanos a y_eval.
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas
%   - y_vals : Vector de ordenadas
%   - y_eval : Valor de y del cual se quiere hallar x
% PARÁMETROS DE SALIDA:
%   - x_eval : Valor de x interpolado
% =========================================================================

function [x_eval] = interpolacion_inversa_cuadratica(x_vals, y_vals, y_eval)
    n = length(x_vals);
    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 3
        error("Se requieren al menos 3 puntos para interpolación cuadrática.");
    end

    [~, idx_sort] = sort(abs(y_vals - y_eval));
    indices = idx_sort(1:3);
    indices = sort(indices);

    x_sub = x_vals(indices);
    y_sub = y_vals(indices);

    x_eval = 0;
    for i = 1:3
        term = x_sub(i);
        for j = 1:3
            if j ~= i
                term = term * (y_eval - y_sub(j)) / (y_sub(i) - y_sub(j));
            end
        end
        x_eval = x_eval + term;
    end
end
