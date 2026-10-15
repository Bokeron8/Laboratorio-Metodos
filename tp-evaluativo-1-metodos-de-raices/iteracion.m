function [x_raiz, iter, convergio] = iteracion(g, F, x0, tol)
  % ITERACION - Metodo de punto fijo: resuelve x = g(x) iterando x_{k+1} = g(x_k).
  % Entradas:
  %   g   - funcion de iteracion, ej: @(x) 200 + 40*log(400/(500-x))
  %   F   - funcion original F(x) para evaluar f(x), ej: @(x) 5*x - 200*log(...)
  %   x0  - valor inicial
  %   tol - tolerancia de parada, se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion del punto fijo
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - true si |g'(x0)| < 1 y se alcanzo la tolerancia

  if (nargin == 3)
    tol = x0;
    x0 = F;
    F = @(x) x - g(x);
  elseif (nargin != 4)
    error("iteracion: se requieren 3 o 4 argumentos (g, x0, tol o g, F, x0, tol)");
  endif

  if (!isa(g, "function_handle"))
    error("iteracion: g debe ser un function_handle");
  endif
  if (!isa(F, "function_handle"))
    error("iteracion: F debe ser un function_handle");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("iteracion: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("iteracion: tol debe ser un numero positivo");
  endif

  h = 1e-4;
  dg = @(x) (g(x + h) - g(x - h)) / (2 * h);

  if (abs(dg(x0)) >= 1)
    disp("El metodo no converge (|g'(x0)| >= 1)");
    convergio = false;
    x_raiz = x0;
    iter = 0;
    return;
  endif

  x_act = x0;
  iter = 0;

  fprintf('\n--- Tabla de Iteraciones (Punto Fijo) ---\n');
  fprintf('%-6s %-18s %-14s %-14s %-14s\n', 'Iter', 'Cond. |g''(x)|', 'x', 'f(x)', 'Error');
  fprintf('%-6d %-18.4f %-14.4f %-14.4f %-14s\n', 0, abs(dg(x0)), x0, F(x0), '-');

  while (true)
    x_sig = g(x_act);
    iter++;
    error_k = abs(x_sig - x_act);
    cond_k = abs(dg(x_act));
    fx_k = F(x_sig);

    fprintf('%-6d %-18.4f %-14.4f %-14.4f %-14.4f\n', iter, cond_k, x_sig, fx_k, error_k);

    if (error_k < tol)
      break;
    endif
    x_act = x_sig;
  endwhile

  x_raiz = x_sig;
  convergio = true;
endfunction
