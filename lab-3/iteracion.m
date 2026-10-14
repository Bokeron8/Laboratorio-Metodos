function [x_raiz, iter, convergio] = iteracion(g, x0, tol)
  % ITERACION - Metodo de punto fijo: resuelve x = g(x) iterando x_{k+1} = g(x_k).
  % Entradas:
  %   g   - funcion de iteracion, ej: @(x) 200 + 40*log(400/(500-x))
  %   x0  - valor inicial
  %   tol - tolerancia de parada, se frena cuando |x_sig - x_act| < tol
  % Salidas:
  %   x_raiz    - aproximacion del punto fijo
  %   iter      - cantidad de iteraciones realizadas
  %   convergio - true si |g'(x0)| < 1 y se alcanzo la tolerancia
  % Ejemplo (usar ./ elemento a elemento para que fplot evalue vectores):
  %   g = @(x) 200 + 40*log(400./(500-x));
  %   [x, it, ok] = iteracion(g, 0, 1e-4);

  % Validacion de tipos: g handle, x0 escalar finito, tol positiva.
  if (nargin != 3)
    error("iteracion: se requieren 3 argumentos (g, x0, tol)");
  endif
  if (!isa(g, "function_handle"))
    error("iteracion: g debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif
  if (!isnumeric(x0) || !isscalar(x0) || !isfinite(x0))
    error("iteracion: x0 debe ser un numero escalar");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("iteracion: tol debe ser un numero positivo");
  endif

  % Paso para aproximar la derivada primera por diferencia central.
  h = 1e-4;

  % Derivada aproximada de g: sirve para chequear la condicion de convergencia |g'(x0)| < 1.
  dg = @(x) (g(x + h) - g(x - h)) / (2 * h);

  % Si no se cumple la condicion de convergencia, se avisa y se sale sin iterar.
  if (abs(dg(x0)) >= 1)
    disp("El metodo no converge");
    convergio = false;
    x_raiz = x0;
    iter = 0;
    return;
  endif

  % Inicializacion: se parte de x0.
  x_act = x0;
  iter = 0;

  % Bucle principal: en cada paso se calcula x_sig = g(x_act) una sola vez
  % y se frena cuando dos aproximaciones sucesivas difieran menos que tol.
  while (true)
    x_sig = g(x_act); % nuevo valor a partir del actual
    iter++;
    if (abs(x_sig - x_act) < tol)
      break;
    endif
    x_act = x_sig; % se avanza al siguiente punto
  endwhile

  % Resultado: el ultimo x_sig es la raiz aproximada y se marca como convergido.
  % Nota: esta funcion no imprime ni grafica, solo calcula y devuelve.
  % El que llama decide si mostrar o graficar (ver principal.m).
  x_raiz = x_sig;
  convergio = true;
endfunction