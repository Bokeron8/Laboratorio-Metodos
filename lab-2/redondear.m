function resultado = redondear(numero)
  % REDONDEAR - Redondea un numero a tres digitos SIGNIFICATIVOS, normalizando.
  % Entradas:
  %   numero - valor a redondear
  % Salidas:
  %   resultado - numero conservando tres digitos significativos
  %
  % Que significa "tres digitos" aca
  % ------------------------------
  % Los tres digitos son los tres primeros digitos significativos, contados
  % desde la primera cifra no nula. El numero se normaliza a la forma
  % 0.d1d2d3... x 10^e, se redondea esa mantisa a tres digitos y se vuelve a
  % armar el numero:
  %   [e, m] = normalizar(numero)
  %   resultado = round(m * 10^3) / 10^3 * 10^e
  %
  % Ejemplo: redondear(133.921) = 134, porque 1.33921 redondeado a tres
  % digitos es 1.34 y 1.34 x 10^2 = 134.
  %
  % Esta es la version NORMALIZADA, que es la que piden los ejercicios 2 y 4 de
  % la Guía 2. Para trabajar SIN normalizar, que es lo que pide el ejercicio 5,
  % hay que usar redondear_n.m: son operaciones distintas y confundirlas cambia
  % el resultado, asi que van en archivos separados a proposito.

  if (nargin != 1)
    error("redondear: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("redondear: numero debe ser un escalar finito");
  endif

  [exponente, mantisa] = normalizar(numero);

  redondeado = round(mantisa * 10^3) / 10^3;
  resultado = redondeado * 10^exponente;
endfunction