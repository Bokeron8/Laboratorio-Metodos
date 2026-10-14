function [exponente, resultado] = normalizar(numero)
  % NORMALIZAR - Lleva un numero a la forma normalizada d1.d2d3... x 10^exponente.
  % Entradas:
  %   numero - valor a normalizar
  % Salidas:
  %   exponente  - exponente decimal del numero
  %   resultado  - mantisa normalizada, con el valor absoluto en el intervalo
  %                 [0.1, 1)
  % Relación:
  %   numero = resultado * 10^exponente
  %
  % Ejemplo: normalizar(133.921) devuelve exponente = 3 y resultado = 0.133921.
  %
  % La consigna de la Guía 2 distingue dos cosas que suelen confundirse:
  %   - Trabajar con valores NORMALIZADOS (lo piden los ejercicios 2 y 4).
  %   - Trabajar SIN NORMALIZARLOS (lo pide el ejercicio 5).
  % Esta función es la que permite distinguir ambas cosas. Ver tambien
  % redondear_n.m y truncar_n.m, que operan sin normalizar.
  %
  % El cero es un caso particular: no se puede escribir como mantisa de tres
  % dígitos, así que se devuelve exponente = 0 y resultado = 0.

  if (nargin != 1)
    error("normalizar: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("normalizar: numero debe ser un escalar finito");
  endif

  exponente = 0;
  resultado = 0;

  % El cero no se puede normalizar; se devuelve tal cual.
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