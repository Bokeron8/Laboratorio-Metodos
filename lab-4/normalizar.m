function [exponente, resultado] = normalizar(numero)
  % NORMALIZAR - Lleva un número a la forma normalizada 0.d1d2d3... x 10^exponente.
  % Entradas:
  %   numero - valor a normalizar
  % Salidas:
  %   exponente - exponente decimal del número
  %   resultado - mantisa normalizada, con el valor absoluto en [0.1, 1)

  if (nargin != 1)
    error("normalizar: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("normalizar: numero debe ser un escalar finito");
  endif

  exponente = 0;
  resultado = 0;

  if (numero == 0)
    return;
  endif

  resultado = numero;

  while (abs(resultado) >= 1)
    exponente = exponente + 1;
    resultado = resultado / 10;
  endwhile

  while (abs(resultado) < 0.1)
    exponente = exponente - 1;
    resultado = resultado * 10;
  endwhile
endfunction
