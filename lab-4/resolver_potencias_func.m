% resolver_potencias_func.m
% Función auxiliar para el Método de las Potencias

function [lambda_k, x, tiempo] = resolver_potencias_func(A, x0, max_iter)
    if isrow(x0)
        x0 = x0';
    end

    [n, m] = size(A);
    if n ~= m || length(x0) ~= n
        error("Dimensiones incompatibles.");
    end

    x = x0;
    lambda_k = 0;

    tic;
    for k = 1:max_iter
        y = A * x;
        [~, idx] = max(abs(y));
        lambda_k = y(idx);
        x = y / lambda_k;
    end
    tiempo = toc;
end
