% =========================================================================
% gauss_jordan
% Resuelve Ax = b por Gauss-Jordan con pivoteo parcial.
%
% En cada paso elimina la incógnita de todas las demás ecuaciones:
%     b(i-1,j-1) = a(i,j) - a(1,j)*a(i,1)/a(11)        (6.10)
% y después normaliza la fila pivote:
%     b(n,j-1) = a(1,j)/a(11)                          (6.11)
%
% Entradas: matriz_coeficientes (n x n), vector_independiente (n x 1)
% Salidas:  vector_solucion, matriz_reducida
% =========================================================================

function [vector_solucion, matriz_reducida] = ...
        gauss_jordan(matriz_coeficientes, vector_independiente)
    
    [num_ecuaciones, num_columnas] = size(matriz_coeficientes);
    
    if num_ecuaciones ~= num_columnas
        error("La matriz de coeficientes debe ser cuadrada (n x n).");
    end
    
    if numel(vector_independiente) ~= num_ecuaciones
        error("El vector b debe tener la misma dimensión que A.");
    end
    
    tolerancia_pivote = 1e-12;
    
    m_col_ampliada = num_ecuaciones + 1;
    matriz_ampliada = [matriz_coeficientes, vector_independiente(:)];
    
    fprintf("\nGAUSS-JORDAN\n\n");
    fprintf("Matriz ampliada inicial:\n");
    imprimir_matriz(matriz_ampliada, num_ecuaciones);
    
    % orden(t): fila de matriz_ampliada que ocupa la posición t del sistema.
    orden = 1:num_ecuaciones;
    num_activas = num_ecuaciones;
    
    for columna = 1:num_ecuaciones
        
        fprintf("Iteración %d (columna %d)\n", columna, columna);
        
        % Pivoteo parcial entre las filas activas.
        valores_pivote = abs(matriz_ampliada(orden(1:num_activas), columna));
        [max_valor, posicion_pivote] = max(valores_pivote);
        
        fprintf("Pivoteo parcial: |a(i,%d)| =", columna);
        fprintf(" %.4f", valores_pivote);
        fprintf(" => fila %d\n", posicion_pivote);
        
        if max_valor < tolerancia_pivote
            error("No existe solución única.");
        end
        
        if posicion_pivote ~= 1
            fprintf("Intercambio: fila 1 <-> fila %d\n", posicion_pivote);
            
            orden([1 posicion_pivote]) = orden([posicion_pivote 1]);
            
            imprimir_matriz(matriz_ampliada(orden, :), num_ecuaciones);
        end
        
        fila_pivote = orden(1);
        a_kk = matriz_ampliada(fila_pivote, columna);
        
        fprintf("Eliminación (6.10): b(i-1,j-1) = a(i,j) - a(1,j)*a(i,1)/a(11)\n");
        
        % (6.10) en todas las filas, incluidas las ya procesadas.
        for t = 2:num_ecuaciones
            i = orden(t);
            a_ik = matriz_ampliada(i, columna);
            
            fprintf("  Fila %d:\n", t);
            
            for j = columna:m_col_ampliada
                valor_anterior = matriz_ampliada(i, j);
                valor_pivote = matriz_ampliada(fila_pivote, j);
                nuevo_valor = valor_anterior - (valor_pivote * a_ik) / a_kk;
                
                fprintf("    Col %d: %.4f - %.4f*%.4f/%.4f = %.4f\n", ...
                            j, valor_anterior, valor_pivote, a_ik, a_kk, nuevo_valor);
                
                matriz_ampliada(i, j) = nuevo_valor;
            end
        end
        
        fprintf("Normalización (6.11): b(n,j-1) = a(1,j)/a(11)\n");
        
        % (6.11): la fila pivote se divide por a_kk.
        for j = columna:m_col_ampliada
            valor_anterior = matriz_ampliada(fila_pivote, j);
            nuevo_valor = valor_anterior / a_kk;
            
            fprintf("  Col %d: %.4f/%.4f = %.4f\n", ...
                    j, valor_anterior, a_kk, nuevo_valor);
            
            matriz_ampliada(fila_pivote, j) = nuevo_valor;
        end
        
        % La fila pivote pasa al final del sistema reducido.
        ecuaciones_activas = orden(2:num_activas);
        ecuaciones_procesadas = orden(num_activas + 1:end);
        orden = [ecuaciones_activas, ecuaciones_procesadas, fila_pivote];
        num_activas = num_activas - 1;
        
        fprintf("Sistema reducido:\n");
        imprimir_matriz(matriz_ampliada(orden, :), num_ecuaciones);
    end
    matriz_reducida = matriz_ampliada(orden, :);
    vector_solucion = matriz_reducida(:, m_col_ampliada);
    
    fprintf("Sistema final:\n");
    imprimir_matriz(matriz_reducida, num_ecuaciones);
    
    fprintf("Solución:\n");
    for i = 1:num_ecuaciones
        fprintf("  x%d = %.6f\n", i, vector_solucion(i));
    end
    
end

% Imprime la matriz ampliada [A | b] alineada por columnas.
function imprimir_matriz(M, n)
    for i = 1:n
        for j = 1:n
            fprintf("%10.4f ", M(i, j));
        end
        fprintf(" | %10.4f\n", M(i, n + 1));
    end
    fprintf("\n");
end
