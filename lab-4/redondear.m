function resultado = redondear(numero, digitos)
  % REDONDEAR - Redondea un número a n dígitos SIGNIFICATIVOS, normalizando.
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
