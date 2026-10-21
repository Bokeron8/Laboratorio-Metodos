function resultado = fibonacci(n)
  % FIBONACCI - n-esimo termino de la sucesion de Fibonacci.
  % Entradas:
  %   n - posicion del termino, entero positivo (1 o mayor)
  % Salidas:
  %   resultado - valor del termino n
  %
  % Convencion: fibonacci(1) = 0 y fibonacci(2) = 1, es decir la sucesion es
  % 0, 1, 1, 2, 3, 5, 8, ...
  %
  % El calculo es iterativo y con cache persistente: cada termino se resuelve una
  % sola vez y las consultas posteriores lo reutilizan, de modo que un barrido
  % i = 1:N cuesta O(N). El cache se reinicia con "clear fibonacci".
  %
  % Los terminos son enteros exactos mientras fibonacci(n) < 2^53 (n <= 78). A
  % partir de ahi el resultado es el double mas cercano al entero: es una
  % limitacion de la aritmetica de punto flotante, no de esta implementacion.

  if (nargin != 1)
    error("fibonacci: se requiere exactamente 1 argumento (n)");
  endif

  if (!isnumeric(n) || !isscalar(n) || !isfinite(n) || n != fix(n) || n < 1)
    error("fibonacci: n debe ser un entero positivo (n >= 1)");
  endif

  % Cache persistente: memo(i) guarda el termino i. Empieza con los dos
  % terminos que fijan la convencion.
  persistent memo

  if (isempty(memo))
    memo = [0, 1];
  endif

  % Si el termino ya fue calculado en una llamada anterior, se devuelve directo.
  if (n <= numel(memo))
    resultado = memo(n);
    return;
  endif

  % Caso general: se sigue la recurrencia hacia adelante desde el cache.
  for k = (numel(memo) + 1):n
    memo(end + 1) = memo(end) + memo(end - 1);
  endfor

  resultado = memo(n);
endfunction