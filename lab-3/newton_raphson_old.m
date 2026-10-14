% newton_raphson.m
function [x, iter] = newton_raphson(f, df, d2f, a, b, tol, max_iter)
    if nargin < 7, max_iter = 100; end
    
    % Verificación de condiciones de Fourier
    fprintf('--- Verificación de Condiciones de Fourier en [%.2f, %.2f] ---\n', a, b);
    cond1 = f(a) * f(b) < 0;
    fprintf('1. f(a)*f(b) < 0: %s\n', mat2str(cond1));
    
    % Evaluación en una malla para f' y f''
    xs = linspace(a, b, 100);
    dfs = df(xs);
    d2fs = d2f(xs);
    
    cond2 = all(dfs > 0) || all(dfs < 0);
    fprintf('2. f''(x) != 0 y no cambia de signo: %s\n', mat2str(cond2));
    
    cond3 = (all(d2fs > 0) || all(d2fs < 0));
    fprintf('3. f''''(x) no cambia de signo: %s\n', mat2str(cond3));
    
    % Selección de x0 (Fourier)
    if f(a) * d2f(a) > 0
        x0 = a;
    else
        x0 = b;
    end
    fprintf('Punto inicial elegido por Fourier: x0 = %.4f\n\n', x0);
    
    % Proceso iterativo
    x = x0;
    iter = 0;
    error_est = tol + 1;
    
    while error_est > tol && iter < max_iter
        iter = iter + 1;
        x_sig = x - f(x) / df(x);
        error_est = abs(x_sig - x);
        x = x_sig;
    end
end