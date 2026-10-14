% intervalo_medio_old.m
function [c, iter, t_exec] = intervalo_medio(f, a, b, tol, max_iter)
    if nargin < 5, max_iter = 100; end
    t_start = tic;
    
    if f(a) * f(b) > 0
        error('f(a) y f(b) deben tener signos opuestos.');
    end
    
    iter = 0;
    error_est = (b - a) / 2;
    
    while error_est > tol && iter < max_iter
        iter = iter + 1;
        c = (a + b) / 2;
        fc = f(c);
        
        if fc == 0
            break;
        elseif f(a) * fc < 0
            b = c;
        else
            a = c;
        end
        error_est = (b - a) / 2;
    end
    c = (a + b) / 2;
    t_exec = toc(t_start);
end