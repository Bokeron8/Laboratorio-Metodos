% fadeev_leverrier.m
% Implementación del Método de Faddeev-LeVerrier

clc;
clear;

disp("=== MÉTODO DE FADDEEV-LEVERRIER ===");
disp("Ejemplo de matriz A: [3 2 -1; 1 -2 3; 2 0 4]");
A = input("Ingrese la matriz cuadrada A: ");

[n, m] = size(A);
if n ~= m
    error("La matriz debe ser cuadrada.");
end

% Coeficientes p_k y matrices B_k
p = zeros(1, n);
B = eye(n);

fprintf("\n--- ITERACIONES DEL ALGORITMO ---\n");
tic;
for k = 1:n
    if k == 1
        A_k = A;
    else
        A_k = A * B;
    end

    p(k) = trace(A_k) / k;
    B = A_k - p(k) * eye(n);

    fprintf("\nIteración k = %d:\n", k);
    fprintf("  Traza(B_%d) = %.4f\n", k, trace(A_k));
    fprintf("  b_%d = %.4f\n", k, p(k));
end
tiempo = toc;

% El vector de coeficientes para roots() en Octave: [1, -p1, -p2, ..., -pn]
coef_polinomio = [1, -p];
autovalores = roots(coef_polinomio);

fprintf("\n--- RESULTADOS FINALES ---\n");
fprintf("Tiempo de cómputo: %e segundos\n", tiempo);

fprintf("\nEcuación característica:\n");
fprintf("P(lambda) = lambda^%d", n);
for k = 1:n
    signo = "-";
    if p(k) < 0
        signo = "+";
    end
    fprintf(" %s %.4f*lambda^%d", signo, abs(p(k)), n-k);
end
fprintf(" = 0\n");

fprintf("\nAutovalores (raíces del polinomio):\n");
for i = 1:n
    fprintf("  lambda_%d = %.4f\n", i, autovalores(i));
end

fprintf("\nAutovectores asociados (normalizados):\n");
for i = 1:n
    lambda_i = autovalores(i);
    % Resolver el sistema homogéneo (A - lambda*I)v = 0 usando null()
    M = A - lambda_i * eye(n);
    v = null(M);

    if isempty(v)
        % Alternativa numérica si null() es muy estricto con el cero
        [~, ~, V_svd] = svd(M);
        v = V_svd(:, end);
    end

    % Normalizar con respecto a la primera componente distinta de cero para verlo entero si es posible
    idx_no_cero = find(abs(v) > 1e-5, 1);
    v_escala = v / v(idx_no_cero);

    fprintf("Para lambda_%d = %.4f:\n", i, lambda_i);
    fprintf("  v_%d = [", i);
    fprintf(" %.4f", v_escala);
    fprintf(" ]'\n");
end
