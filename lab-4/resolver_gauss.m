% resolver_gauss.m
% Función auxiliar para resolver Ax = b por Eliminación de Gauss con Pivoteo Parcial

function [x, tiempo, Ab] = resolver_gauss(A, b)
    if isrow(b)
        b = b';
    end

    [n, m] = size(A);
    if n ~= m
        error("La matriz A debe ser cuadrada.");
    end
    if length(b) ~= n
        error("Las dimensiones de A y b no coinciden.");
    end

    Ab = [A, b];

    tic;
    for k = 1:n-1
        [max_val, p] = max(abs(Ab(k:n, k)));
        p = p + k - 1;

        if max_val < 1e-12
            error("El sistema no tiene solución única (matriz singular).");
        end

        if p ~= k
            Ab([k, p], :) = Ab([p, k], :);
        end

        for i = k+1:n
            factor = Ab(i, k) / Ab(k, k);
            Ab(i, k:n+1) = Ab(i, k:n+1) - factor * Ab(k, k:n+1);
        end
    end

    if abs(Ab(n, n)) < 1e-12
        error("El sistema no tiene solución única.");
    end

    x = zeros(n, 1);
    x(n) = Ab(n, n+1) / Ab(n, n);

    for i = n-1:-1:1
        suma = Ab(i, i+1:n) * x(i+1:n);
        x(i) = (Ab(i, n+1) - suma) / Ab(i, i);
    end
    tiempo = toc;
end
