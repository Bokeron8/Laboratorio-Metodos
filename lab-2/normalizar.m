function [exponente, resultado] = normalizar(numero)
  % NORMALIZAR - Lleva un número a la forma normalizada 0.d1d2d3... x 10^exponente.
  % Entradas:
  %   numero - valor a normalizar
  % Salidas:
  %   exponente - exponente decimal del número
  %   resultado - mantisa normalizada, con el valor absoluto en [0.1, 1)
  % Relación:
  %   numero = resultado * 10^exponente
  %
  % Ejemplo: normalizar(133.921) devuelve exponente = 3 y resultado = 0.133921.
  % El cero no se puede escribir como mantisa: devuelve exponente = 0 y
  % resultado = 0.
  %
  % truncar_n.m y redondear_n.m operan sin pasar por acá.

  if (nargin != 1)
    error("normalizar: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("normalizar: numero debe ser un escalar finito");
  endif

  exponente = 0;
  resultado = 0;

  % El cero no se puede normalizar.
  if (numero == 0)
    return;
  endif

  resultado = numero;

  % Se divide por 10 hasta que la mantisa entre en [0.1, 1).
  while (abs(resultado) >= 1)
    exponente = exponente + 1;
    resultado = resultado / 10;
  endwhile

  % Si el número era menor que 0.1, el lazo anterior no corrió y hay que
  % multiplicar en vez de dividir, bajando el exponente en consecuencia.
  while (abs(resultado) < 0.1)
    exponente = exponente - 1;
    resultado = resultado * 10;
  endwhile
endfunction