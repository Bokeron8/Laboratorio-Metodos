% euler.m
% =========================================================================
% FUNCIÓN: euler
% DESCRIPCIÓN: Resuelve el problema de valor inicial y' = f(x, y) con
%              y(x0) = y0 aplicando el método de Euler explícito:
%                  y(i+1) = y(i) + h * f(x(i), y(i))
% PARÁMETROS DE ENTRADA:
%   - f       : Función de la ecuación diferencial, con la forma @(x, y)
%   - x0      : Abscisa inicial
%   - y0      : Ordenada inicial
%   - h       : Tamaño de paso
%   - x_final : Abscisa final del intervalo
% PARÁMETROS DE SALIDA:
%   - x       : Vector de abscisas (x0, x0+h, ..., x_final)
%   - y       : Vector de ordenadas aproximadas
% =========================================================================

function [x, y] = euler(f, x0, y0, h, x_final)
    if h <= 0
        error("euler: el paso h debe ser positivo.");
    end
    if x_final <= x0
        error("euler: la abscisa final debe ser mayor que la inicial.");
    end

    pasos = round((x_final - x0) / h);
    if abs(x0 + pasos * h - x_final) > 1e-10
        error("euler: el intervalo no es múltiplo del paso h.");
    end

    x = x0 + (0:pasos) * h;
    y = zeros(1, pasos + 1);
    y(1) = y0;

    for i = 1:pasos
        y(i + 1) = y(i) + h * f(x(i), y(i));
    end
end
