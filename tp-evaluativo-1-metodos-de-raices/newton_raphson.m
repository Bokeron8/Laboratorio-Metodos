function [x_raiz, iter, convergio] = newton_raphson(F, x0, tol)
  % NEWTON_RAPHSON - Metodo de Newton-Raphson: x_{k+1} = x_k - F(x_k)/F'(x_k).
  % Entradas:
  %   F   - funcion a la que se le busca la raiz, ej: @(x) x.^2 - 2
  %   x0  - valor inicial (elegir segun Fourier: F(x0)*F''(x0) > 0)
  %   tol - tolerancia de parada, se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion de la raiz
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - false si la derivada se anula (no se puede continuar)

  if (nargin != 3)
    error("newton_raphson: se requieren 3 argumentos (F, x0, tol)");
  endif
  if (!isa(F, "function_handle"))
    error("newton_raphson: F debe ser un function_handle");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("newton_raphson: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("newton_raphson: tol debe ser un numero positivo");
  endif

  h = 1e-4;
  dF = @(x) (F(x + h) - F(x - h)) / (2 * h);
  d2F = @(x) (F(x + h) - 2 * F(x) + F(x - h)) / (h ^ 2);

  x_act = x0;
  iter = 0;
  
  if (dF(x_act) == 0)
    disp("Derivada nula en x0, el metodo no puede continuar");
    convergio = false;
    x_raiz = x_act;
    return;
  endif

  fprintf('\n--- Tabla de Iteraciones (Newton-Raphson) ---\n');
  fprintf('%-6s %-20s %-14s %-14s %-14s\n', 'Iter', 'Fourier F(x)*F''(x)', 'x', 'f(x)', 'Error');
  fprintf('%-6d %-20.4f %-14.4f %-14.4f %-14s\n', 0, F(x0) * d2F(x0), x0, F(x0), '-');

  error_k = 1;
  while (error_k > tol)
    fx = F(x_act);
    dfx = dF(x_act);
    d2fx = d2F(x_act);

    if (dfx == 0)
      disp("Derivada nula durante la iteracion, el metodo se detiene");
      convergio = false;
      x_raiz = x_act;
      return;
    endif

    x_sig = x_act - (fx / dfx);
    error_k = abs(x_sig - x_act);
    cond_k = fx * d2fx; % Condicion de Fourier F(x)*F''(x)
    fx_sig = F(x_sig);

    iter++;
    fprintf('%-6d %-20.4f %-14.4f %-14.4f %-14.4f\n', iter, cond_k, x_sig, fx_sig, error_k);

    x_act = x_sig;
  endwhile

  x_raiz = x_act;
  convergio = true;
endfunction
