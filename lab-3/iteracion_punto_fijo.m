% iteracion_punto_fijo.m
function [x, iter] = iteracion_punto_fijo(g, x0, tol, max_iter, usar_aitken)
    if nargin < 5, usar_aitken = false; end
    if nargin < 4, max_iter = 100; end
    
    iter = 0;
    x = x0;
    error_est = tol + 1;
    
    if ~usar_aitken
        while error_est > tol && iter < max_iter
            iter = iter + 1;
            x_next = g(x);
            error_est = abs(x_next - x);
            x = x_next;
        end
    else
        % Método Delta^2 de Aitken
        while error_est > tol && iter < max_iter
            iter = iter + 1;
            x1 = g(x);
            x2 = g(x1);
            denom = x2 - 2*x1 + x;
            if abs(denom) < 1e-12
                x = x2;
                break;
            end
            x_hat = x - ((x1 - x)^2) / denom;
            error_est = abs(x_hat - x);
            x = x_hat;
        end
    end
end