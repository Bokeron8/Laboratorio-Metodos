function [x_raiz, iter, convergio] = aceleracion(g, F, x0, tol)
  % ACELERACION - Aceleracion de Aitken delta-cuadrado.
  % Acelera la iteracion de punto fijo x_{k+1} = g(x_k) con:
  %   x1 = g(x_act), x2 = g(x1)
  %   x_sig = x_act - (x1 - x_act)^2 / (x2 - 2*x1 + x_act)
  % Entradas:
  %   g   - funcion de iteracion, ej: @(x) 200 + 40*log(400/(500-x))
  %   F   - funcion original F(x)
  %   x0  - valor inicial
  %   tol - tolerancia de parada, se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion del punto fijo acelerada
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - false si el denominador se anula (no se puede acelerar)

  if (nargin == 3)
    tol = x0;
    x0 = F;
    F = @(x) x - g(x);
  elseif (nargin != 4)
    error("aceleracion: se requieren 3 o 4 argumentos (g, x0, tol o g, F, x0, tol)");
  endif

  if (!isa(g, "function_handle"))
    error("aceleracion: g debe ser un function_handle");
  endif
  if (!isa(F, "function_handle"))
    error("aceleracion: F debe ser un function_handle");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("aceleracion: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("aceleracion: tol debe ser un numero positivo");
  endif

  h = 1e-4;
  dg = @(x) (g(x + h) - g(x - h)) / (2 * h);

  x_act = x0;
  iter = 0;

  fprintf('\n--- Tabla de Iteraciones (Aitken) ---\n');
  fprintf('%-6s %-18s %-14s %-14s %-14s\n', 'Iter', 'Cond. |g''(x)|', 'x', 'f(x)', 'Error');
  fprintf('%-6d %-18.4f %-14.4f %-14.4f %-14s\n', 0, abs(dg(x0)), x0, F(x0), '-');

  while (true)
    x1 = g(x_act);
    x2 = g(x1);
    den = x2 - 2 * x1 + x_act;

    if (den == 0)
      disp("Denominador nulo en Aitken, el metodo se detiene");
      convergio = false;
      x_raiz = x_act;
      return;
    endif

    x_sig = x_act - ((x1 - x_act)^2) / den;
    iter++;
    error_k = abs(x_sig - x_act);
    cond_k = abs(dg(x_act));
    fx_sig = F(x_sig);

    fprintf('%-6d %-18.4f %-14.4f %-14.4f %-14.4f\n', iter, cond_k, x_sig, fx_sig, error_k);

    if (error_k < tol)
      break;
    endif
    x_act = x_sig;
  endwhile

  x_raiz = x_sig;
  convergio = true;
endfunction
