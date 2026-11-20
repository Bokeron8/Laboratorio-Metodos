% leer_vector.m
% =========================================================================
% FUNCIÓN: leer_vector
% DESCRIPCIÓN: Solicita por teclado un vector fila. Si el usuario presiona
%              Enter sin escribir nada, devuelve el vector por defecto.
% PARÁMETROS DE ENTRADA:
%   - mensaje : Texto que se muestra al pedir el dato
%   - defecto : Vector a utilizar si no se ingresa un valor
% PARÁMETROS DE SALIDA:
%   - v       : Vector fila ingresado (o el valor por defecto)
% =========================================================================

function v = leer_vector(mensaje, defecto)
    v = input(mensaje);
    if isempty(v)
        v = defecto;
    end
    v = v(:)';
end
