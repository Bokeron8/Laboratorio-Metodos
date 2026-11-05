function [x, t] = resolver_gauss(A, b)
    if isrow(b); b = b'; end
    n = size(A, 1);
    Ab = [A, b];

    tic;
    for k = 1:n-1
        [~, p] = max(abs(Ab(k:n, k)));
        p = p + k - 1;
        if p ~= k
            Ab([k, p], :) = Ab([p, k], :);
        end
        for i = k+1:n
            factor = Ab(i, k) / Ab(k, k);
            Ab(i, k:n+1) = Ab(i, k:n+1) - factor * Ab(k, k:n+1);
        end
    end

    x = zeros(n, 1);
    x(n) = Ab(n, n+1) / Ab(n, n);
    for i = n-1:-1:1
        x(i) = (Ab(i, n+1) - Ab(i, i+1:n) * x(i+1:n)) / Ab(i, i);
    end
    t = toc;
end
