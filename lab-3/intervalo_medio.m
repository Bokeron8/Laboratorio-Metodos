function [raiz, iter] = intervalo_medio(f, a, b, tol, max_iter)
  % INTERVALO_MEDIO - Bisección: parte el intervalo a la mitad y se queda con
  % la mitad donde f cambia de signo. Converge siempre que haya cambio de signo.
  % Entradas:
  %   f        - función a la que se le busca la raíz, ej: @(x) x.^2 - 2
  %   a, b     - extremos del intervalo inicial (se pasa un valor por referencia)
  %   tol      - cota de error: se frena cuando (b - a)/2 <= tol
  %   max_iter - tope de iteraciones para que no quede en loop infinito
  % Salidas:
  %   raiz - punto medio del intervalo final, aproximación de la raíz
  %   iter - cantidad de iteraciones realizadas
  % Nota: el método es INDEPENDIENTE de la velocidad de f, pero converge lento
  % (~log2((b-a)/tol) iteraciones). Ese contraste con interpolación lineal es
  % justamente lo que pide comparar la consigna.

  if (nargin < 4)
    error("intervalo_medio: se requieren al menos 4 argumentos (f, a, b, tol)");
  endif
  if (nargin < 5)
    max_iter = 1000;
  endif
  if (!isa(f, "function_handle"))
    error("intervalo_medio: f debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("intervalo_medio: tol debe ser un numero positivo");
  endif

  % Teorema de Bolzano: sin cambio de signo no se puede garantizar la raíz.
  if (f(a) * f(b) > 0)
    error('f(a) y f(b) deben tener signos opuestos.');
  endif

  iter = 0;

  while ((b - a) / 2 > tol && iter < max_iter)
    c = (a + b) / 2;
    f_c = f(c);

    % Caso exacto: se cayó justo en la raíz, no hay nada más que refinar.
    if (f_c == 0)
      a = c;
      b = c;
      iter++;
      break;
    endif

    % Se descarta la mitad donde f no cambia de signo.
    if (f(a) * f_c < 0)
      b = c;
    else
      a = c;
    endif

    iter++;
  endwhile

  % La aproximación es siempre el punto medio del intervalo que quedó.
  raiz = (a + b) / 2;
endfunction
