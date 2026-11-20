% leer_escalar.m
% =========================================================================
% FUNCIÓN: leer_escalar
% DESCRIPCIÓN: Solicita por teclado un valor escalar. Si el usuario presiona
%              Enter sin escribir nada, devuelve el valor por defecto.
% PARÁMETROS DE ENTRADA:
%   - mensaje : Texto que se muestra al pedir el dato
%   - defecto : Valor a utilizar si no se ingresa un valor
% PARÁMETROS DE SALIDA:
%   - v       : Valor escalar ingresado (o el valor por defecto)
% =========================================================================

function v = leer_escalar(mensaje, defecto)
    v = input(mensaje);
    if isempty(v)
        v = defecto;
    end
    % Octave interpreta "0,2" como el vector [0 2]: el separador decimal es
    % el punto, así que se avisa en lugar de seguir con un valor equivocado.
    if ~isscalar(v)
        error("leer_escalar: se esperaba un solo número. Use punto decimal (0.2).");
    end
end
