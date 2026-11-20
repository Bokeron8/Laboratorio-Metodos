% runge_kutta_2.m
% =========================================================================
% FUNCIÓN: runge_kutta_2
% DESCRIPCIÓN: Resuelve el problema de valor inicial y' = f(x, y) con
%              y(x0) = y0 aplicando el método de Runge-Kutta de segundo
%              orden en la forma que deduce la cátedra (Heun):
%
%                  y(i+1) = y(i) + (k1 + k2) / 2
%                  k1     = h * f(x(i), y(i))
%                  k2     = h * f(x(i) + h, y(i) + k1)
%
%              Es una sola pasada: no itera el corrector. Equivale al método
%              modificado de Euler cuando se omiten las iteraciones sucesivas.
% PARÁMETROS DE ENTRADA:
%   - f       : Función de la ecuación diferencial, con la forma @(x, y)
%   - x0      : Abscisa inicial
%   - y0      : Ordenada inicial
%   - h       : Tamaño de paso
%   - x_final : Abscisa final del intervalo
% PARÁMETROS DE SALIDA:
%   - x       : Vector de abscisas
%   - y       : Vector de ordenadas aproximadas
% =========================================================================

function [x, y] = runge_kutta_2(f, x0, y0, h, x_final)
    if h <= 0
        error("runge_kutta_2: el paso h debe ser positivo.");
    end
    if x_final <= x0
        error("runge_kutta_2: la abscisa final debe ser mayor que la inicial.");
    end

    pasos = round((x_final - x0) / h);
    if abs(x0 + pasos * h - x_final) > 1e-10
        error("runge_kutta_2: el intervalo no es múltiplo del paso h.");
    end

    x = x0 + (0:pasos) * h;
    y = zeros(1, pasos + 1);
    y(1) = y0;

    for i = 1:pasos
        k1 = h * f(x(i), y(i));
        k2 = h * f(x(i) + h, y(i) + k1);
        y(i + 1) = y(i) + (k1 + k2) / 2;
    end
end
