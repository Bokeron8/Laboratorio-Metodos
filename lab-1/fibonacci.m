function resultado = fibonacci(n)
  % FIBONACCI - n-esimo termino de la sucesion de Fibonacci.
  % Entradas:
  %   n - posicion del termino, entero positivo (1 o mayor)
  % Salidas:
  %   resultado - valor del termino n
  %
  % Convencion del repositorio: fibonacci(1) = 0 y fibonacci(2) = 1, es decir
  % la sucesion es 0, 1, 1, 2, 3, 5, 8, ... (el termino 0 seria 1).
  %
  % La consigna del Guia 1 pide los N primeros terminos con N = 200. Con la
  % recursion ingenua esa cuenta no es viable: el numero de llamadas crece como
  % phi^n y para n = 30 ya se demora alrededor de 8 segundos, de modo que
  % n = 200 exigiria del orden de 5.6e41 llamadas.
  %
  % Por eso el termino se calcula de forma iterativa y se guarda en un cache
  % persistente: cada termino se resuelve una sola vez y las consultas
  % posteriores reutilizan el resultado. Asi la funcion es O(n) y el barrido
  % for i = 1:N del script 03-fibonacci.m es O(N) en total.
  %
  % El cache se reinicia con "clear fibonacci".
  %
  % Sobre la precision: los terminos son enteros exactos mientras que
  % fibonacci(n) < 2^53 (aproximadamente n <= 78). A partir de ahi los enteros
  % ya no son representables exactamente por un double, y el resultado es el
  % double mas cercano al entero vrai. Esto no es una limitacion de esta
  % implementacion sino de la aritmetica de punto flotante en general.

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