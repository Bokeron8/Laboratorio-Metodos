% =========================================================================
% interpolacion_inversa_lineal
% Interpolación lineal inversa: dado y_objetivo, devuelve la x correspondiente
% sobre el tramo de la tabla que lo contiene.
%
% Entradas: x_tabla, y_tabla (misma longitud, al menos 2 puntos), y_objetivo
% Salidas:  x_interpolada
%           i_tramo  (índice del primer punto del tramo)
%           h   (paso en x del tramo)
%           delta_y  (diferencia en y del tramo)
% =========================================================================

function [x_interpolada, i_tramo, h, delta_y] = ...
        interpolacion_inversa_lineal(x_tabla, y_tabla, y_objetivo)
    
    num_puntos = length(x_tabla);
    
    if length(y_tabla) ~= num_puntos
        error("x_tabla e y_tabla deben tener la misma longitud.");
    end
    
    if num_puntos < 2
        error("Se necesitan al menos 2 puntos para interpolar.");
    end
    
    % Buscar el tramo [y(i), y(i+1)] que contiene a y_objetivo. La tabla
    % puede ser creciente o decreciente, así que se comparan los dos extremos.
    % i_tramo = 0 significa que no se encontró ningún tramo.
    i_tramo = 0;
    for i = 1:(num_puntos - 1)
        if entre_extremos(y_objetivo, y_tabla(i), y_tabla(i + 1))
            i_tramo = i;
            break;
        end
    end
    
    % Fuera de la tabla no se extrapola: el resultado quedaría fuera del
    % dominio de los datos.
    if i_tramo == 0
        error("El valor de y está fuera del rango de la tabla (extrapolación).");
    end
    
    % Extremos del tramo elegido.
    x_ini = x_tabla(i_tramo);
    x_fin = x_tabla(i_tramo + 1);
    y_ini = y_tabla(i_tramo);
    y_fin = y_tabla(i_tramo + 1);
    
    % Paso en x y diferencia en y del tramo.
    h = x_fin - x_ini;
    delta_y = y_fin - y_ini;
    
    % Sin diferencia en y no se puede despejar x (recta vertical).
    if abs(delta_y) < 1e-12
        error("División por cero: los dos valores de y del tramo son iguales.");
    end
    
    % Interpolación lineal inversa: se despeja x de
    %   (x - x_ini) / h = (y_objetivo - y_ini) / delta_y
    x_interpolada = x_ini + (h / delta_y) * (y_objetivo - y_ini);
    
    % --- Salida por pantalla ---
    fprintf("Tabla de datos:\n");
    fprintf("  i     X(i)         Y(i)\n");
    for i = 1:num_puntos
        fprintf(" %2d  %10.4f  %12.6f\n", i, x_tabla(i), y_tabla(i));
    end
    
    fprintf("\ny objetivo: %.8f\n", y_objetivo);
    fprintf("Tramo: filas %d y %d\n", i_tramo, i_tramo + 1);
    fprintf("  x_ini = %.4f   x_fin = %.4f\n", x_ini, x_fin);
    fprintf("  y_ini = %.6f  y_fin = %.6f\n", y_ini, y_fin);
    fprintf("  h = %.4f  delta_y = %.6f\n", h, delta_y);
    
    fprintf("\nx = x_ini + h*(y - y_ini)/delta_y\n");
    fprintf("x = %.4f + %.4f*(%.8f - %.6f)/(%.6f)\n", ...
            x_ini, h, y_objetivo, y_ini, delta_y);
    fprintf("x = %.6f\n", x_interpolada);
    
end

% -------------------------------------------------------------------------
% entre_extremos
% Devuelve true si valor cae entre a y b, sin importar el orden.
% -------------------------------------------------------------------------
function contenido = entre_extremos(valor, a, b)
    contenido = (valor >= a && valor <= b) || ...
                (valor <= a && valor >= b);
end
