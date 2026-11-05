% resolver_fadeev_func.m
% Función auxiliar para Faddeev-LeVerrier

function [autovalores, autovectores, coefs, tiempo] = resolver_fadeev_func(A)
    [n, m] = size(A);
    if n ~= m
        error("La matriz debe ser cuadrada.");
    end

    p = zeros(1, n);
    B = eye(n);

    tic;
    for k = 1:n
        if k == 1
            A_k = A;
        else
            A_k = A * B;
        end
        p(k) = trace(A_k) / k;
        B = A_k - p(k) * eye(n);
    end
    tiempo = toc;

    coefs = [1, -p];
    autovalores = roots(coefs);

    autovectores = zeros(n, n);
    for i = 1:n
        lambda_i = autovalores(i);
        M = A - lambda_i * eye(n);
        v = null(M);
        if isempty(v)
            [~, ~, V_svd] = svd(M);
            v = V_svd(:, end);
        end
        idx = find(abs(v) > 1e-5, 1);
        if ~isempty(idx)
            v = v / v(idx);
        end
        autovectores(:, i) = v;
    end
end
