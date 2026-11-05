function [x, t] = resolver_gauss_jordan(A, b)
    if isrow(b); b = b'; end
    n = size(A, 1);
    Ab = [A, b];

    tic;
    for k = 1:n
        [~, p] = max(abs(Ab(k:n, k)));
        p = p + k - 1;
        if p ~= k
            Ab([k, p], :) = Ab([p, k], :);
        end
        Ab(k, :) = Ab(k, :) / Ab(k, k);
        for i = 1:n
            if i ~= k
                Ab(i, :) = Ab(i, :) - Ab(i, k) * Ab(k, :);
            end
        end
    end
    x = Ab(:, n+1);
    t = toc;
end
