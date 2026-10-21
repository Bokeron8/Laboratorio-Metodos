function [x_raiz, iter, convergio] = newton_raphson(F, x0, tol)
  % NEWTON_RAPHSON - Metodo de Newton-Raphson: x_{k+1} = x_k - F(x_k)/F'(x_k).
  % Entradas:
  %   F   - funcion a la que se le busca la raiz, ej: @(x) x.^2 - 2
  %   x0  - valor inicial (elegir segun Fourier: F(x0)*F''(x0) > 0)
  %   tol - tolerancia de parada: se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion de la raiz
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - false si la derivada se anula (no se puede continuar)
  % Ejemplo:
  %   F = @(x) x.^2 - 2;  [x, it, ok] = newton_raphson(F, 1, 1e-4);

  if (nargin != 3)
    error("newton_raphson: se requieren 3 argumentos (F, x0, tol)");
  endif
  if (!isa(F, "function_handle"))
    error("newton_raphson: F debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("newton_raphson: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("newton_raphson: tol debe ser un numero positivo");
  endif

  % F'(x) se aproxima por diferencia central, con paso h.
  h = 1e-4;

  dF = @(x) (F(x + h) - F(x - h)) / (2 * h);

  x_act = x0;
  iter = 0;

  % Chequeo inicial: si la derivada se anula en x0 no se puede avanzar.
  if (dF(x_act) == 0)
    disp("Derivada nula en x0, el metodo no puede continuar");
    convergio = false;
    x_raiz = x_act;
    return;
  endif

  % error_k arranca en 1 para entrar al bucle y se actualiza con |x_sig - x_act|.
  error_k = 1;
  while (error_k > tol)
    fx = F(x_act);
    dfx = dF(x_act);

    % Si la derivada se anula a mitad de camino, se sale sin romper todo.
    if (dfx == 0)
      disp("Derivada nula durante la iteracion, el metodo se detiene");
      convergio = false;
      x_raiz = x_act;
      return;
    endif

    x_sig = x_act - (fx / dfx); % paso de Newton-Raphson
    error_k = abs(x_sig - x_act); % medida del avance
    x_act = x_sig; % se avanza al siguiente punto
    iter++;
  endwhile

  x_raiz = x_act;
  convergio = true;
endfunction
