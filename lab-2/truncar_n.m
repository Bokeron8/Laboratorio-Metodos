function resultado = truncar_n(numero, n)
  % TRUNCAR_N - Trunca un número a n dígitos SIGNIFICATIVOS, SIN NORMALIZAR.
  % Entradas:
  %   numero - valor a truncar
  %   n      - cantidad de dígitos significativos a conservar
  % Salidas:
  %   resultado - número conservando n dígitos significativos
  %
  % A diferencia de truncar.m, no renormaliza el resultado: lo deja en la forma
  % cruda que sale de operar sobre la mantisa. Es lo que pide el punto 5.a con
  % "sin normalizar".
  %
  % No mira el dígito siguiente: truncar_n(104.487111, 3) = 104 y no 105.

  if (nargin != 2)
    error("truncar_n: se requieren exactamente 2 argumentos (numero, n)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("truncar_n: numero debe ser un escalar finito");
  endif
  if (!isnumeric(n) || !isscalar(n) || !isfinite(n) || n != fix(n) || n < 1)
    error("truncar_n: n debe ser un entero positivo (n >= 1)");
  endif

  % El cero no tiene digitos significativos que conservar.
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

  % Escalar la mantisa a un número entero de n dígitos.
  escalado = mantisa * 10^(n - 1);

  % Corrección de error de representación: las potencias de 10 no son exactas
  % en punto flotante, así que el escalado puede quedar apenas por debajo del
  % entero verdadero. truncar_n(0.149, 3), por ejemplo, produce 148.99999999999997
  % y fix se lleva un dígito de más. Si el valor está a unas pocas unidades de
  % error de máquina de un entero, se lo considera ese entero; el margen es
  % relativo y un truncamiento genuino nunca se ve afectado.
  if (abs(escalado - round(escalado)) <= 10 * eps(abs(escalado)))
    escalado = round(escalado);
  endif

  % Se trunca la mantisa conservando n dígitos y se reescribe el número sin
  % renormalizar. fix trunca hacia cero, que es justamente el truncamiento de
  % cifras: no mira el dígito descartado.
  resultado = fix(escalado) / 10^(n - 1) * 10^exponente;
endfunction