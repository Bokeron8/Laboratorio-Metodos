% resolver_gauss_seidel_func.m
% Función auxiliar para resolver Ax = b por Gauss-Seidel

function [x, iter, tiempo] = resolver_gauss_seidel_func(A, b, x0, tol, max_iter)
    if isrow(b)
        b = b';
    end
    if isrow(x0)
        x0 = x0';
    end

    [n, m] = size(A);
    if n ~= m || length(b) ~= n || length(x0) ~= n
        error("Dimensiones incompatibles.");
    end

    x = x0;
    iter = 0;
    error_calc = tol + 1;

    tic;
    while error_calc > tol && iter < max_iter
        iter = iter + 1;
        x_ant = x;

        for i = 1:n
            suma1 = A(i, 1:i-1) * x(1:i-1);
            suma2 = A(i, i+1:n) * x_ant(i+1:n);
            x(i) = (b(i) - suma1 - suma2) / A(i, i);
        end

        error_calc = norm(x - x_ant, inf) / max(norm(x, inf), 1e-12);
    end
    tiempo = toc;
end
