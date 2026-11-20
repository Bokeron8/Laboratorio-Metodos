% trapecios.m
% =========================================================================
% FUNCIÓN: trapecios
% DESCRIPCIÓN: Aproxima la integral definida de una función tabulada en
%              puntos equidistantes mediante la regla compuesta de los
%              Trapecios.
%              I = h/2 * [ y_1 + 2*(y_2 + ... + y_{n-1}) + y_n ]
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
% PARÁMETROS DE SALIDA:
%   - I      : Valor aproximado de la integral
% =========================================================================

function I = trapecios(x_vals, y_vals)
    x_vals = x_vals(:);
    y_vals = y_vals(:);
    n = length(x_vals);

    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 2
        error("Se necesitan al menos dos puntos.");
    end

    h = diff(x_vals);
    if max(abs(h - h(1))) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end
    h = h(1);

    I = (h / 2) * (y_vals(1) + 2 * sum(y_vals(2:end-1)) + y_vals(end));
end
