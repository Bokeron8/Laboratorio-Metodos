% tabla_diferencias.m
% =========================================================================
% FUNCIÓN: tabla_diferencias
% DESCRIPCIÓN: Construye la tabla de diferencias finitas hacia adelante para
%              un conjunto de puntos equidistantes. La columna 1 contiene las
%              abscisas, la columna 2 las ordenadas y las columnas 3..n+1 las
%              diferencias de orden 1..n-1.
%              Las diferencias hacia atrás se leen sobre la diagonal inferior
%              derecha de la tabla: nabla^k(y_n) = T(n-k, k+2).
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
% PARÁMETROS DE SALIDA:
%   - T      : Matriz (n x n+1) con la tabla de diferencias
% =========================================================================

function T = tabla_diferencias(x_vals, y_vals)
    x_vals = x_vals(:);
    y_vals = y_vals(:);
    n = length(x_vals);

    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n < 2
        error("Se necesitan al menos dos puntos.");
    end

    h = x_vals(2) - x_vals(1);
    if max(abs(diff(x_vals) - h)) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end

    T = nan(n, n + 1);
    T(:, 1) = x_vals;
    T(:, 2) = y_vals;

    for k = 1:n-1
        for i = 1:n-k
            T(i, k + 2) = T(i + 1, k + 1) - T(i, k + 1);
        end
    end
end
