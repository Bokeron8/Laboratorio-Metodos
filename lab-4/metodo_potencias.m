% metodo_potencias.m
% Método de las Potencias para calcular el autovalor dominante y su autovector

clc;
clear;

disp("=== MÉTODO DE LAS POTENCIAS ===");
disp("Ejemplo de matriz A: [2 -1 0; -0.5 1 -0.5; 0 -1/3 2/3]");
A = input("Ingrese la matriz cuadrada A: ");

disp("Ejemplo vector inicial x0: [1; 1; -0.5]");
x0 = input("Ingrese el vector inicial x0: ");
if isrow(x0); x0 = x0'; end

max_iter = input("Ingrese el número de iteraciones (ej. 4): ");

[n, m] = size(A);
if n ~= m || length(x0) ~= n
    error("Dimensiones incompatibles.");
end

% Cálculo de valores exactos con Octave para comparar
[V_exact, D_exact] = eig(A);
autovalores_exactos = diag(D_exact);
[lambda_max_exact, idx_max] = max(abs(autovalores_exactos));
lambda_exact = autovalores_exactos(idx_max);
v_exact = V_exact(:, idx_max);
v_exact = v_exact / v_exact(1); % Normalizar con la primera componente en 1

fprintf("\n--- VALORES EXACTOS (Referencia Octave) ---\n");
fprintf("Autovalor dominante exacto: %.5f\n", lambda_exact);
fprintf("Autovector asociado (normalizado):\n");
disp(v_exact);

% Bucle de iteraciones
x = x0;
lambda_k = 0;

fprintf("\n%-6s %-14s %-32s %-12s\n", "Iter", "Lambda (aprox)", "Vector propio x^T", "Error Abs Lambda");
fprintf("%s\n", repmat('-', 1, 68));

tic;
for k = 1:max_iter
    % Multiplicación por la matriz
    y = A * x;

    % Encontrar la componente de mayor magnitud
    [~, idx] = max(abs(y));
    lambda_k = y(idx);

    % Normalizar el vector
    x = y / lambda_k;

    err_lambda = abs(lambda_exact - lambda_k);

    % Formateo de vector para imprimir
    vec_str = sprintf("%.4f  ", x);
    fprintf("%-6d %-14.5f [%-28s] %-12.5f\n", k, lambda_k, strtrim(vec_str), err_lambda);
end
tiempo = toc;

fprintf("\nTiempo de ejecución: %e segundos\n", tiempo);

% Error final del vector propio
err_vector = norm(abs(x) - abs(v_exact), inf);
fprintf("\nError norma infinito en el vector propio (iter %d): %.5f\n", max_iter, err_vector);
