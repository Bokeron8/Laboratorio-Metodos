function resultado = redondear(numero, digitos)
  % REDONDEAR - Redondea un número a n dígitos SIGNIFICATIVOS, normalizando.
  % Entradas:
  %   numero  - valor a redondear
  %   digitos - cantidad de dígitos significativos a conservar (opcional, 3 por
  %             defecto; el ejercicio 4 pide 4)
  % Salidas:
  %   resultado - número conservando n dígitos significativos
  %
  % Los n dígitos se cuentan desde la primera cifra no nula. Se normaliza el
  % número a 0.d1d2d3... x 10^e, se redondea la mantisa a n dígitos y se vuelve
  % a armar:
  %   [e, m] = normalizar(numero)
  %   resultado = round(m * 10^n) / 10^n * 10^e
  %
  % Ejemplo: redondear(133.921) = 134, porque 0.133921 redondeado a tres dígitos
  % es 0.134 y 0.134 x 10^3 = 134. Con cuatro dígitos da 133.9.
  %
  % Para redondear sin normalizar existe redondear_n.m.

  if (nargin != 1 && nargin != 2)
    error("redondear: se requiere 1 o 2 argumentos (numero, digitos)");
  endif
  if (nargin < 2)
    digitos = 3;
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("redondear: numero debe ser un escalar finito");
  endif
  if (!isnumeric(digitos) || !isscalar(digitos) || !isfinite(digitos) || ...
      digitos != fix(digitos) || digitos < 1)
    error("redondear: digitos debe ser un entero positivo (digitos >= 1)");
  endif

  [exponente, mantisa] = normalizar(numero);

  redondeado = round(mantisa * 10^digitos) / 10^digitos;
  resultado = redondeado * 10^exponente;
endfunction