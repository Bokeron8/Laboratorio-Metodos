% gauss_seidel.m
% Resuelve Ax = b mediante el Método Iterativo de Gauss-Seidel

clc;
clear;

disp("=== MÉTODO DE GAUSS-SEIDEL ===");
disp("Ejemplo reordenado A: [3.0 -0.1 -0.2; 0.1 7.0 -0.3; 0.3 -0.2 -10.3]");
disp("Ejemplo reordenado b: [7.85; -19.30; -19.30]");

A = input("Ingrese la matriz de coeficientes A: ");
b = input("Ingrese el vector de términos independientes b: ");

if isrow(b)
    b = b';
end

[n, m] = size(A);
if n ~= m || length(b) ~= n
    error("Dimensiones inconsistentes.");
end

x0 = input("Ingrese el vector inicial (ej. [1; 1; 1]): ");
if isrow(x0)
    x0 = x0';
end

tol = input("Ingrese la tolerancia de error (ej. 1e-4): ");
max_iter = input("Ingrese el número máximo de iteraciones (ej. 100): ");

% --- VERIFICACIÓN DE DIAGONAL DOMINANTE ---
fprintf("\n--- ANÁLISIS DE CONVERGENCIA PREVIO ---\n");
es_edd = true;
for i = 1:n
    diag_val = abs(A(i, i));
    suma_otros = sum(abs(A(i, :))) - diag_val;
    if diag_val <= suma_otros
        es_edd = false;
        fprintf("Fila %d: |a_%d%d| = %.2f <= suma otros (%.2f) -> NO cumple dominancia.\n", i, i, i, diag_val, suma_otros);
    else
        fprintf("Fila %d: |a_%d%d| = %.2f > suma otros (%.2f) -> Cumple.\n", i, i, i, diag_val, suma_otros);
    end
end

if es_edd
    fprintf("Resultado: La matriz es estrictamente diagonal dominante. La convergencia está asegurada.\n\n");
else
    warning("La matriz NO es estrictamente diagonal dominante. El método podría divergir o requerir reordenamiento de filas.");
end

% --- ITERACIÓN DE GAUSS-SEIDEL ---
x = x0;
iter = 0;
error_calc = tol + 1;

fprintf("%-6s", "Iter");
for i = 1:n
    fprintf("%-12s", sprintf("x%d", i));
end
fprintf("%-12s\n", "Error");
fprintf("%s\n", repmat('-', 1, 6 + 12*n + 12));

tic;
while error_calc > tol && iter < max_iter
    iter = iter + 1;
    x_ant = x;

    for i = 1:n
        suma1 = A(i, 1:i-1) * x(1:i-1);         % Valores ya actualizados en k
        suma2 = A(i, i+1:n) * x_ant(i+1:n);     % Valores aún en k-1
        x(i) = (b(i) - suma1 - suma2) / A(i, i);
    end

    % Error relativo de norma infinito
    error_calc = norm(x - x_ant, inf) / max(norm(x, inf), 1e-12);

    % Imprimir fila
    fprintf("%-6d", iter);
    for i = 1:n
        fprintf("%-12.6f", x(i));
    end
    fprintf("%-12.6e\n", error_calc);
end
tiempo = toc;

fprintf("\n--- RESULTADOS FINALES ---\n");
fprintf("Tiempo de cómputo: %e segundos\n", tiempo);
if iter >= max_iter && error_calc > tol
    fprintf("Se alcanzó el número máximo de iteraciones sin converger a la tolerancia deseada.\n");
else
    fprintf("El método convergió exitosamente en %d iteraciones.\n", iter);
end

for i = 1:n
    fprintf("  x%d = %.6f\n", i, x(i));
end
