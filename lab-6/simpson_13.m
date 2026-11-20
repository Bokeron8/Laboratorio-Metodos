% simpson_13.m
% =========================================================================
% FUNCIÓN: simpson_13
% DESCRIPCIÓN: Aproxima la integral definida de una función tabulada en
%              puntos equidistantes mediante la regla compuesta de Simpson 1/3.
%              Requiere un número par de intervalos (cantidad impar de puntos).
%              I = h/3 * [ y_1 + 4*(y_2 + y_4 + ...) + 2*(y_3 + y_5 + ...) + y_n ]
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
% PARÁMETROS DE SALIDA:
%   - I      : Valor aproximado de la integral
% =========================================================================

function I = simpson_13(x_vals, y_vals)
    x_vals = x_vals(:);
    y_vals = y_vals(:);
    n = length(x_vals);

    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 3
        error("Se necesitan al menos tres puntos.");
    end

    h = diff(x_vals);
    if max(abs(h - h(1))) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end
    h = h(1);

    if mod(n - 1, 2) ~= 0
        error("Simpson 1/3 requiere un número par de intervalos.");
    end

    suma_impares = sum(y_vals(2:2:n-1));
    suma_pares = sum(y_vals(3:2:n-2));

    I = (h / 3) * (y_vals(1) + 4 * suma_impares + 2 * suma_pares + y_vals(end));
end
