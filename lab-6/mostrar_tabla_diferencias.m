% mostrar_tabla_diferencias.m
% =========================================================================
% FUNCIÓN: mostrar_tabla_diferencias
% DESCRIPCIÓN: Imprime en pantalla la tabla de diferencias finitas generada
%              por tabla_diferencias, omitiendo las posiciones no definidas
%              (triángulo superior de la matriz).
% PARÁMETROS DE ENTRADA:
%   - T : Matriz devuelta por tabla_diferencias
% =========================================================================

function mostrar_tabla_diferencias(T)
    [n, m] = size(T);
    n_dif = m - 2;

    printf("%8s %12s", "x", "y");
    for k = 1:n_dif
        printf(" %14s", sprintf("D^%d", k));
    end
    printf("\n");

    for i = 1:n
        printf("%8.3f %12.6f", T(i, 1), T(i, 2));
        for k = 1:n_dif
            if isnan(T(i, k + 2))
                printf(" %14s", "");
            else
                printf(" %14.6f", T(i, k + 2));
            end
        end
        printf("\n");
    end
end
