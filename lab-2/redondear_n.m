function resultado = redondear_n(numero, n)
  % REDONDEAR_N - Redondea un número a n dígitos SIGNIFICATIVOS, SIN NORMALIZAR.
  % Entradas:
  %   numero - valor a redondear
  %   n      - cantidad de dígitos significativos a conservar
  % Salidas:
  %   resultado - número conservando n dígitos significativos
  %
  % A diferencia de redondear.m, no renormaliza el resultado: si el redondeo
  % produce un acarreo, lo deja en la forma cruda. Por ejemplo, 999 redondeado a
  % dos dígitos da 100 y no 1.00 x 10^3. Eso es lo que pide el punto 5.a con
  % "sin normalizar".
  %
  % Ejemplo: redondear_n(104.487111, 3) = 105 y redondear_n(0.0000123456, 3) =
  % 1.23e-05; la operación se aplica a la mantisa.

  if (nargin != 2)
    error("redondear_n: se requieren exactamente 2 argumentos (numero, n)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("redondear_n: numero debe ser un escalar finito");
  endif
  if (!isnumeric(n) || !isscalar(n) || !isfinite(n) || n != fix(n) || n < 1)
    error("redondear_n: n debe ser un entero positivo (n >= 1)");
  endif

  % El cero no tiene dígitos significativos que conservar.
  if (numero == 0)
    resultado = 0;
    return;
  endif

  % Notación científica: numero = mantisa * 10^exponente, con 1 <= |mantisa| < 10.
  % En esa forma la mantisa ya tiene UNA cifra entera, así que los n dígitos
  % significativos se obtienen reteniendo las n - 1 cifras decimales de la
  % mantisa. Retener n decimales sería guardar n + 1 dígitos.
  exponente = floor(log10(abs(numero)));
  mantisa = numero / 10^exponente;

  % Se redondea la mantisa conservando n dígitos y se reescribe el número sin
  % renormalizar.
  resultado = round(mantisa * 10^(n - 1)) / 10^(n - 1) * 10^exponente;
endfunction