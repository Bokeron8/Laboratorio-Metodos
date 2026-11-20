% interpolacion_inversa_lineal.m
% =========================================================================
% FUNCIÓN: interpolacion_inversa_lineal
% DESCRIPCIÓN: Determina el valor de x correspondiente a un valor dado y_eval
%              mediante interpolación lineal inversa (invirtiendo roles x, y).
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas
%   - y_vals : Vector de ordenadas
%   - y_eval : Valor de y del cual se quiere hallar x
% PARÁMETROS DE SALIDA:
%   - x_eval : Valor de x interpolado
% =========================================================================

function [x_eval] = interpolacion_inversa_lineal(x_vals, y_vals, y_eval)
    n = length(x_vals);
    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end

    idx = -1;
    for i = 1:n-1
        if (y_vals(i) <= y_eval && y_eval <= y_vals(i+1)) || ...
           (y_vals(i) >= y_eval && y_eval >= y_vals(i+1))
            idx = i;
            break;
        end
    end

    if idx == -1
        [~, idx_sort] = sort(abs(y_vals - y_eval));
        idx1 = idx_sort(1);
        idx2 = idx_sort(2);
        if idx1 > idx2
            [idx1, idx2] = deal(idx2, idx1);
        end
        idx = idx1;
    else
        idx1 = idx;
        idx2 = idx + 1;
    end

    x0 = x_vals(idx1); x1 = x_vals(idx2);
    y0 = y_vals(idx1); y1 = y_vals(idx2);

    if y1 == y0
        error("División por cero en interpolación inversa lineal (y1 == y0).");
    end

    x_eval = x0 + ((y_eval - y0) / (y1 - y0)) * (x1 - x0);
end
