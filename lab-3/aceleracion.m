function [x_raiz, iter, convergio] = aceleracion(g, x0, tol)
  % ACELERACION - Aceleracion de Aitken delta-cuadrado.
  % Acelera la iteracion de punto fijo x_{k+1} = g(x_k) con:
  %   x1 = g(x_act), x2 = g(x1)
  %   x_sig = x_act - (x1 - x_act)^2 / (x2 - 2*x1 + x_act)
  % Entradas:
  %   g   - funcion de iteracion, ej: @(x) 200 + 40*log(400/(500-x))
  %   x0  - valor inicial
  %   tol - tolerancia de parada, se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion del punto fijo acelerada
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - false si el denominador se anula (no se puede acelerar)
  % Ejemplo (usar ./ elemento a elemento para que fplot evalue vectores):
  %   g = @(x) 200 + 40*log(400./(500-x));
  %   [x, it, ok] = aceleracion(g, 0, 1e-4);
  % Nota: no se exige |g'(x0)| < 1 como en punto fijo simple, porque este metodo
  % converge (cuadraticamente) aun donde el punto fijo diverge; solo pide den != 0.

  % Validacion de tipos: g handle, x0 escalar finito, tol positiva.
  if (nargin != 3)
    error("aceleracion: se requieren 3 argumentos (g, x0, tol)");
  endif
  if (!isa(g, "function_handle"))
    error("aceleracion: g debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("aceleracion: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("aceleracion: tol debe ser un numero positivo");
  endif

  % Inicializacion: se parte de x0.
  x_act = x0;
  iter = 0;

  % Bucle principal: en cada paso se evalua g dos veces (x1 y x2)
  % y se aplica la formula de Aitken para saltar mas cerca de la raiz.
  while (true)
    x1 = g(x_act); % primera iterada de punto fijo
    x2 = g(x1);    % segunda iterada de punto fijo
    den = x2 - 2 * x1 + x_act; % denominador de Aitken

    % Si el denominador se anula, la aceleracion no esta definida.
    if (den == 0)
      disp("Denominador nulo en Aitken, el metodo se detiene");
      convergio = false;
      x_raiz = x_act;
      return;
    endif

    x_sig = x_act - ((x1 - x_act)^2) / den; % valor acelerado
    iter++;
    if (abs(x_sig - x_act) < tol)
      break;
    endif
    x_act = x_sig; % se avanza al valor acelerado
  endwhile

  % Resultado: el ultimo x_sig es la raiz aproximada y se marca como convergido.
  % Nota: esta funcion no imprime ni grafica, solo calcula y devuelve.
  x_raiz = x_sig;
  convergio = true;
endfunction
