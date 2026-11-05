function [x, L, U, t] = resolver_lu(A, b)
    if isrow(b); b = b'; end
    n = size(A, 1);
    L = eye(n);
    U = zeros(n);

    tic;
    for i = 1:n
        for k = i:n
            U(i, k) = A(i, k) - L(i, 1:i-1) * U(1:i-1, k);
        end
        for k = i+1:n
            L(k, i) = (A(k, i) - L(k, 1:i-1) * U(1:i-1, i)) / U(i, i);
        end
    end

    % Ly = b (progresiva)
    y = zeros(n, 1);
    for i = 1:n
        y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    end

    % Ux = y (regresiva)
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (y(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
    end
    t = toc;
end
