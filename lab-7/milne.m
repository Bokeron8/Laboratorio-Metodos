% milne.m
% =========================================================================
% FUNCIÓN: milne
% DESCRIPCIÓN: Resuelve el problema de valor inicial y' = f(x, y) aplicando
%              el método de Milne, que no empieza por sí mismo: necesita los
%              cuatro primeros valores y0, y1, y2, y3 (y sus derivadas) ya
%              calculados por otro método. Para cada paso siguiente:
%
%              (10.5) Predicción:
%                  P(y(i+1)) = y(i-3) + 4/3 * h * [2*y'i - y'(i-1) + 2*y'(i-2)]
%
%              (10.6) Corrección:
%                  C(y(i+1)) = y(i-1) + h/3 * [y'(i-1) + 4*y'i + P(y'(i+1))]
%
%              La corrección se itera hasta que dos valores consecutivos
%              difieran en valor absoluto menos que E.
% PARÁMETROS DE ENTRADA:
%   - f       : Función de la ecuación diferencial, con la forma @(x, y)
%   - x_ini   : Vector con los cuatro puntos iniciales de x
%   - y_ini   : Vector con los cuatro valores iniciales de y
%   - h       : Tamaño de paso
%   - x_final : Abscisa final del intervalo
%   - E       : Tolerancia del corrector (por defecto 0,001)
% PARÁMETROS DE SALIDA:
%   - x           : Vector de abscisas, desde el primero hasta x_final
%   - y           : Vector de ordenadas aproximadas
%   - iteraciones : Cantidad de correcciones aplicadas en cada paso nuevo
% =========================================================================

function [x, y, iteraciones] = milne(f, x_ini, y_ini, h, x_final, E)
    if nargin < 6
        E = 0.001;
    end
    if E <= 0
        error("milne: la tolerancia E debe ser positiva.");
    end
    if h <= 0
        error("milne: el paso h debe ser positivo.");
    end

    x_ini = x_ini(:)';
    y_ini = y_ini(:)';
    if length(x_ini) ~= 4 || length(y_ini) ~= 4
        error("milne: se necesitan exactamente cuatro puntos iniciales.");
    end
    if max(abs(diff(x_ini) - h)) > 1e-10
        error("milne: los cuatro puntos iniciales deben estar separados por h.");
    end
    if x_final <= x_ini(4)
        error("milne: la abscisa final debe ser mayor que el último punto inicial.");
    end

    pasos = round((x_final - x_ini(4)) / h);
    if abs(x_ini(4) + pasos * h - x_final) > 1e-10
        error("milne: el intervalo restante no es múltiplo del paso h.");
    end

    x = [x_ini, x_ini(4) + (1:pasos) * h];
    y = zeros(1, length(x));
    y(1:4) = y_ini;

    % Derivadas en los cuatro puntos conocidos
    yp = zeros(1, length(x));
    for k = 1:4
        yp(k) = f(x(k), y(k));
    end

    iteraciones = zeros(1, pasos);

    for j = 5:length(x)
        % (10.5) Predicción
        P = y(j - 4) + (4 / 3) * h * (2 * yp(j - 1) - yp(j - 2) + 2 * yp(j - 3));
        Pp = f(x(j), P);

        % (10.6) Corrección
        C = y(j - 2) + (h / 3) * (yp(j - 2) + 4 * yp(j - 1) + Pp);

        it = 1;
        while true
            Cp = f(x(j), C);
            C_nuevo = y(j - 2) + (h / 3) * (yp(j - 2) + 4 * yp(j - 1) + Cp);
            it = it + 1;
            if abs(C_nuevo - C) < E
                C = C_nuevo;
                break;
            end
            C = C_nuevo;
            if it > 10000
                error("milne: el corrector no converge en x = %g.", x(j));
            end
        end

        y(j) = C;
        yp(j) = f(x(j), y(j));
        iteraciones(j - 4) = it;
    end
end
