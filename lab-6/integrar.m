% integrar.m
% =========================================================================
% FUNCIÓN: integrar
% DESCRIPCIÓN: Aproxima la integral definida de una función tabulada en
%              puntos equidistantes, seleccionando la regla de integración.
%              El método "auto" elige la combinación más conveniente según la
%              cantidad de intervalos:
%                - 1 intervalo                         : Trapecios
%                - intervalos pares                    : Simpson 1/3
%                - intervalos múltiplos de 3           : Simpson 3/8
%                - intervalos impares (n >= 5)         : Simpson 3/8 en los
%                  primeros 3 intervalos + Simpson 1/3 en los restantes
% PARÁMETROS DE ENTRADA:
%   - x_vals : Vector de abscisas (equidistantes)
%   - y_vals : Vector de ordenadas
%   - metodo : "trapecios", "simpson13", "simpson38" o "auto" (por defecto)
% PARÁMETROS DE SALIDA:
%   - I      : Valor aproximado de la integral
%   - tramos : Arreglo de estructuras con los tramos aplicados
%              (campos: metodo, xa, xb, valor)
% =========================================================================

function [I, tramos] = integrar(x_vals, y_vals, metodo)
    if nargin < 3
        metodo = "auto";
    end

    x_vals = x_vals(:)';
    y_vals = y_vals(:)';
    n_puntos = length(x_vals);

    if length(y_vals) ~= n_puntos
        error("x_vals y y_vals deben tener la misma longitud.");
    end
    if n_puntos < 2
        error("Se necesitan al menos dos puntos.");
    end

    n = n_puntos - 1;   % cantidad de intervalos
    tramos = struct('metodo', {}, 'xa', {}, 'xb', {}, 'valor', {});

    switch lower(metodo)
        case "trapecios"
            I = trapecios(x_vals, y_vals);
            tramos(end + 1) = struct('metodo', 'Trapecios', ...
                'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);

        case "simpson13"
            I = simpson_13(x_vals, y_vals);
            tramos(end + 1) = struct('metodo', 'Simpson 1/3', ...
                'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);

        case "simpson38"
            I = simpson_38(x_vals, y_vals);
            tramos(end + 1) = struct('metodo', 'Simpson 3/8', ...
                'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);

        case "auto"
            if n == 1
                I = trapecios(x_vals, y_vals);
                tramos(end + 1) = struct('metodo', 'Trapecios', ...
                    'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);
            elseif mod(n, 2) == 0
                I = simpson_13(x_vals, y_vals);
                tramos(end + 1) = struct('metodo', 'Simpson 1/3', ...
                    'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);
            elseif mod(n, 3) == 0
                I = simpson_38(x_vals, y_vals);
                tramos(end + 1) = struct('metodo', 'Simpson 3/8', ...
                    'xa', x_vals(1), 'xb', x_vals(end), 'valor', I);
            else
                % n impar >= 5: 3/8 sobre los primeros 3 intervalos y 1/3
                % sobre los n-3 intervalos restantes (que son pares).
                I1 = simpson_38(x_vals(1:4), y_vals(1:4));
                I2 = simpson_13(x_vals(4:end), y_vals(4:end));
                I = I1 + I2;
                tramos(end + 1) = struct('metodo', 'Simpson 3/8', ...
                    'xa', x_vals(1), 'xb', x_vals(4), 'valor', I1);
                tramos(end + 1) = struct('metodo', 'Simpson 1/3', ...
                    'xa', x_vals(4), 'xb', x_vals(end), 'valor', I2);
            end

        otherwise
            error("Método desconocido: use 'trapecios', 'simpson13', 'simpson38' o 'auto'.");
    end
end
