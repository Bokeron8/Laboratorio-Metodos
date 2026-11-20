% simpson_38.m
% =========================================================================
% FUNCIÓN: simpson_38
% DESCRIPCIÓN: Aproxima la integral definida de una función tabulada en
%              puntos equidistantes mediante la regla compuesta de Simpson 3/8.
%              Requiere un número de intervalos múltiplo de 3.
%              I = 3h/8 * [ y_1 + 3*(y_2 + y_3 + y_5 + y_6 + ...)
%                             + 2*(y_4 + y_7 + ...) + y_n ]
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
% PARÁMETROS DE SALIDA:
%   - I      : Valor aproximado de la integral
% =========================================================================

function I = simpson_38(x_vals, y_vals)
    x_vals = x_vals(:);
    y_vals = y_vals(:);
    n = length(x_vals);

    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 4
        error("Se necesitan al menos cuatro puntos.");
    end

    h = diff(x_vals);
    if max(abs(h - h(1))) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end
    h = h(1);

    if mod(n - 1, 3) ~= 0
        error("Simpson 3/8 requiere un número de intervalos múltiplo de 3.");
    end

    suma_3 = sum(y_vals(2:3:n-1)) + sum(y_vals(3:3:n-1));
    suma_2 = sum(y_vals(4:3:n-1));

    I = (3 * h / 8) * (y_vals(1) + 3 * suma_3 + 2 * suma_2 + y_vals(end));
end
