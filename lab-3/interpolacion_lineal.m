function [raiz, iter, tabla] = interpolacion_lineal(f, a, b, tol, max_iter)
  % INTERPOLACION_LINEAL - Método de interpolación lineal.
  % Aproxima la raíz con la intersección de la cuerda entre (a, f(a)) y (b, f(b))
  % con el eje x, en vez de con el punto medio como hace la bisección:
  %   c = b - f(b)*(b - a)/(f(b) - f(a))
  % Entradas:
  %   f        - función a la que se le busca la raíz, ej: @(x) x.^2 - 2
  %   a, b     - extremos del intervalo inicial (se pasa un valor por referencia)
  %   tol      - cota de error: se frena cuando |c_n - c_(n-1)| <= tol
  %   max_iter - tope de iteraciones para que no quede en loop infinito
  % Salidas:
  %   raiz  - última intersección con el eje x calculada
  %   iter  - cantidad de iteraciones realizadas
  %   tabla - matriz Nx4 con [iter, a, b, c] por iteración, para mostrar el avance
  % Suele converger más rápido que la bisección, pero si f es muy curva un extremo
  % se queda pegado; por eso el error se mide como |c_n - c_(n-1)| y no como (b-a)/2.

  if (nargin < 4)
    error("interpolacion_lineal: se requieren al menos 4 argumentos (f, a, b, tol)");
  endif
  if (nargin < 5)
    max_iter = 1000;
  endif
  if (!isa(f, "function_handle"))
    error("interpolacion_lineal: f debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif
  if (!isnumeric(tol) || !isscalar(tol) || !isfinite(tol) || !(tol > 0))
    error("interpolacion_lineal: tol debe ser un numero positivo");
  endif

  % Teorema de Bolzano: sin cambio de signo no se puede garantizar la raíz.
  if (f(a) * f(b) > 0)
    error('f(a) y f(b) deben tener signos opuestos.');
  endif

  iter = 0;
  raiz = a;
  c_anterior = [];
  filas = [];

  while (true)
    f_a = f(a);
    f_b = f(b);

    % c = a - f(a)*(b-a)/(f(b)-f(a)): la misma cuerda, pero sin cancelar
    % cuando f(a) y f(b) son grandes y b - a es chico.
    raiz = a - f_a * (b - a) / (f_b - f_a);
    f_raiz = f(raiz);

    iter++;
    filas(end + 1, :) = [iter, a, b, raiz]; %#ok<AGROW>

    % Caso exacto: se cayó justo en la raíz.
    if (f_raiz == 0)
      break;
    endif

    % Se descarta el tramo donde f no cambia de signo.
    if (f_a * f_raiz < 0)
      b = raiz;
    else
      a = raiz;
    endif

    % Criterio de parada: dos intersecciones sucesivas difieren menos que la cota.
    if (!isempty(c_anterior) && abs(raiz - c_anterior) <= tol)
      break;
    endif
    c_anterior = raiz;

    if (iter >= max_iter)
      disp('Se alcanzó el tope de iteraciones sin cumplir la cota de error.');
      break;
    endif
  endwhile

  tabla = filas;
endfunction
