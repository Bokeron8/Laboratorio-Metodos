% newton_gregory_derivada.m
% =========================================================================
% FUNCIÓN: newton_gregory_derivada
% DESCRIPCIÓN: Aproxima la derivada de orden indicado de una función tabulada
%              en puntos equidistantes, utilizando el polinomio de
%              Newton-Gregory Ascendente o Descendente.
%              El polinomio se expresa en la variable auxiliar p:
%                 Ascendente : p = (x - x_1) / h  (diferencias hacia adelante)
%                 Descendente: p = (x - x_n) / h  (diferencias hacia atrás)
%              y se deriva analíticamente respecto de p. El factor 1/h^orden
%              convierte la derivada en p a la derivada respecto de x.
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
%   - x_eval : Punto donde se evalúa la derivada
%   - orden  : Orden de la derivada (1 por defecto)
%   - tipo   : "ascendente" (por defecto) o "descendente"
% PARÁMETROS DE SALIDA:
%   - d      : Valor aproximado de la derivada
%   - P      : Coeficientes del polinomio de Newton en p (potencias
%              descendentes)
% =========================================================================

function [d, P] = newton_gregory_derivada(x_vals, y_vals, x_eval, orden, tipo)
    if nargin < 4
        orden = 1;
    end
    if nargin < 5
        tipo = "ascendente";
    end

    x_vals = x_vals(:);
    y_vals = y_vals(:);
    n = length(x_vals);

    if length(y_vals) ~= n
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if orden < 0 || orden ~= fix(orden)
        error("El orden de derivación debe ser un entero no negativo.");
    end
    if n < orden + 1
        error("Se necesitan al menos %d puntos para derivar de orden %d.", orden + 1, orden);
    end

    h = x_vals(2) - x_vals(1);
    if max(abs(diff(x_vals) - h)) > 1e-10
        error("Los puntos x_vals deben ser equidistantes.");
    end

    T = tabla_diferencias(x_vals, y_vals);

    tipo = lower(tipo);
    if strcmp(tipo, "ascendente")
        % Fila superior de la tabla: y_1, D y_1, D^2 y_1, ...
        delta = T(1, 2:n+1);
        p = (x_eval - x_vals(1)) / h;
    elseif strcmp(tipo, "descendente")
        % Diagonal inferior derecha: y_n, nabla y_n, nabla^2 y_n, ...
        delta = zeros(1, n);
        delta(1) = y_vals(n);
        for k = 1:n-1
            delta(k + 1) = T(n - k, k + 2);
        end
        p = (x_eval - x_vals(n)) / h;
    else
        error("El tipo debe ser 'ascendente' o 'descendente'.");
    end

    % Polinomio de Newton en p con coeficientes en potencias descendentes.
    P = zeros(1, n);
    P(n) = delta(1);
    B = 1;
    for k = 1:n-1
        if strcmp(tipo, "ascendente")
            B = conv(B, [1, -(k - 1)]) / k;
        else
            B = conv(B, [1, (k - 1)]) / k;
        end
        Bpad = [zeros(1, n - length(B)), B];
        P = P + delta(k + 1) * Bpad;
    end

    D = P;
    for j = 1:orden
        D = polyder(D);
    end
    d = polyval(D, p) / h^orden;
end
