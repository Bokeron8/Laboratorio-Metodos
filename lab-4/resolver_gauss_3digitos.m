% resolver_gauss_3digitos.m
% =========================================================================
% FUNCIÓN: resolver_gauss_3digitos
% DESCRIPCIÓN: Resuelve un sistema de ecuaciones lineales Ax = b mediante
%              el Método de Eliminación de Gauss con Pivoteo Parcial,
%              utilizando aritmética de 3 dígitos significativos (redondeo).
% =========================================================================

function [x, tiempo, Ab] = resolver_gauss_3digitos(A, b)
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

    % Redondear elementos iniciales de A y b a 3 dígitos significativos
    A_r = zeros(size(A));
    for i = 1:n
        for j = 1:m
            A_r(i,j) = redondear(A(i,j), 3);
        end
    end

    b_r = zeros(size(b));
    for i = 1:n
        b_r(i) = redondear(b(i), 3);
    end

    Ab = [A_r, b_r];

    tic;
    % Fase 1: Eliminación hacia adelante con aritmética de 3 dígitos
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
            num = redondear(Ab(i, k), 3);
            den = redondear(Ab(k, k), 3);
            factor = redondear(num / den, 3);
            
            for j = k:n+1
                term = redondear(factor * redondear(Ab(k, j), 3), 3);
                Ab(i, j) = redondear(redondear(Ab(i, j), 3) - term, 3);
            endfor
        end
    end

    if abs(Ab(n, n)) < 1e-12
        error("El sistema no tiene solución única.");
    end

    % Fase 2: Sustitución regresiva con aritmética de 3 dígitos
    x = zeros(n, 1);
    num_x = redondear(Ab(n, n+1), 3);
    den_x = redondear(Ab(n, n), 3);
    x(n) = redondear(num_x / den_x, 3);

    for i = n-1:-1:1
        suma = 0;
        for j = i+1:n
            prod = redondear(redondear(Ab(i, j), 3) * redondear(x(j), 3), 3);
            suma = redondear(suma + prod, 3);
        endfor
        rhs = redondear(redondear(Ab(i, n+1), 3) - suma, 3);
        diag_el = redondear(Ab(i, i), 3);
        x(i) = redondear(rhs / diag_el, 3);
    end
    tiempo = toc;
end
