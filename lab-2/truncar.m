function resultado = truncar(numero)
  % TRUNCAR - Trunca un número a tres dígitos SIGNIFICATIVOS, normalizando.
  % Entradas:
  %   numero - valor a truncar
  % Salidas:
  %   resultado - número conservando tres dígitos significativos
  %
  % Los tres dígitos se cuentan desde la primera cifra no nula. Se normaliza el
  % número a 0.d1d2d3... x 10^e, se trunca la mantisa a tres dígitos y se vuelve
  % a armar:
  %   [e, m] = normalizar(numero)
  %   resultado = fix(m * 10^3) / 10^3 * 10^e
  %
  % A diferencia del redondeo, no mira el dígito siguiente: truncar(133.921) =
  % 133, mientras que redondear(133.921) = 134.
  %
  % Para truncar sin normalizar existe truncar_n.m.

  if (nargin != 1)
    error("truncar: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("truncar: numero debe ser un escalar finito");
  endif

  [exponente, mantisa] = normalizar(numero);

  % Escalar la mantisa a un número entero de tres dígitos.
  escalado = mantisa * 10^3;

  % Corrección de error de representación: las potencias de 10 no son exactas
  % en punto flotante, así que el escalado puede quedar apenas por debajo del
  % entero verdadero y fix se lleva un dígito de más. truncar(-28), por ejemplo,
  % produce -279.99999999999994. Si el valor está a unas pocas unidades de error
  % de máquina de un entero, se lo considera ese entero; el margen es relativo y
  % un truncamiento genuino nunca se ve afectado.
  if (abs(escalado - round(escalado)) <= 10 * eps(abs(escalado)))
    escalado = round(escalado);
  endif

  truncado = fix(escalado) / 10^3;
  resultado = truncado * 10^exponente;
endfunction