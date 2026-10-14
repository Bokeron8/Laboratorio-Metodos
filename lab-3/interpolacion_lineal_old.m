% interpolacion_lineal_old.m
function [c, iter, t_exec] = interpolacion_lineal(f, a, b, tol, max_iter)
    if nargin < 5, max_iter = 100; end
    t_start = tic;
    
    if f(a) * f(b) > 0
        error('f(a) y f(b) deben tener signos opuestos.');
    end
    
    iter = 0;
    c = a;
    error_est = tol + 1;
    
    while error_est > tol && iter < max_iter
        iter = iter + 1;
        c_ant = c;
        fa = f(a);
        fb = f(b);
        c = (a * fb - b * fa) / (fb - fa);
        fc = f(c);
        
        if iter > 1
            error_est = abs(c - c_ant);
        end
        
        if fc == 0
            break;
        elseif fa * fc < 0
            b = c;
        else
            a = c;
        end
    end
    t_exec = toc(t_start);
end