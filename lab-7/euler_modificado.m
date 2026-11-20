% euler_modificado.m
% =========================================================================
% FUNCIÓN: euler_modificado
% DESCRIPCIÓN: Resuelve el problema de valor inicial y' = f(x, y) con
%              y(x0) = y0 aplicando el método modificado de Euler
%              (predictor-corrector). Para cada paso, con y'i = f(x(i), y(i)):
%
%              (a) P(y(i+1))  = y(i) + y'i * h                (predictor)
%              (b) P(y'(i+1)) = f(x(i+1), P(y(i+1)))
%              (c) C(y(i+1))  = y(i) + (y'i + P(y'(i+1))) / 2 * h
%              (d) C(y'(i+1)) = f(x(i+1), C(y(i+1)))
%              (e) C(y(i+1))  = y(i) + (y'i + C(y'(i+1))) / 2 * h
%
%              Los incisos (d) y (e) se repiten hasta que dos correcciones
%              consecutivas difieran en valor absoluto menos que E.
% PARÁMETROS DE ENTRADA:
%   - f       : Función de la ecuación diferencial, con la forma @(x, y)
%   - x0      : Abscisa inicial
%   - y0      : Ordenada inicial
%   - h       : Tamaño de paso
%   - x_final : Abscisa final del intervalo
%   - E       : Tolerancia del corrector (por defecto 0,001)
% PARÁMETROS DE SALIDA:
%   - x           : Vector de abscisas
%   - y           : Vector de ordenadas aproximadas
%   - iteraciones : Cantidad de correcciones aplicadas en cada paso
% =========================================================================

function [x, y, iteraciones] = euler_modificado(f, x0, y0, h, x_final, E)
    if nargin < 6
        E = 0.001;
    end
    if E <= 0
        error("euler_modificado: la tolerancia E debe ser positiva.");
    end
    if h <= 0
        error("euler_modificado: el paso h debe ser positivo.");
    end
    if x_final <= x0
        error("euler_modificado: la abscisa final debe ser mayor que la inicial.");
    end

    pasos = round((x_final - x0) / h);
    if abs(x0 + pasos * h - x_final) > 1e-10
        error("euler_modificado: el intervalo no es múltiplo del paso h.");
    end

    x = x0 + (0:pasos) * h;
    y = zeros(1, pasos + 1);
    y(1) = y0;
    iteraciones = zeros(1, pasos);

    for i = 1:pasos
        yp_i = f(x(i), y(i));

        % (a) Predictor
        P = y(i) + yp_i * h;
        % (b) Derivada evaluada en el predictor
        Pp = f(x(i + 1), P);
        % (c) Primera corrección
        C = y(i) + (yp_i + Pp) / 2 * h;

        % (d)-(e) Iteración del corrector
        it = 1;
        while true
            Cp = f(x(i + 1), C);
            C_nuevo = y(i) + (yp_i + Cp) / 2 * h;
            it = it + 1;
            if abs(C_nuevo - C) < E
                C = C_nuevo;
                break;
            end
            C = C_nuevo;
            if it > 10000
                error("euler_modificado: el corrector no converge en x = %g.", x(i + 1));
            end
        end

        y(i + 1) = C;
        iteraciones(i) = it;
    end
end
