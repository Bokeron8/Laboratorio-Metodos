function resultado = redondear_n(numero, n)
  % REDONDEAR_N - Redondea un numero a n digitos SIGNIFICATIVOS, SIN NORMALIZAR.
  % Entradas:
  %   numero - valor a redondear
  %   n      - cantidad de digitos significativos a conservar
  % Salidas:
  %   resultado - numero conservando n digitos significativos
  %
  % Por que esta funcion existe, separada de redondear.m
  % -----------------------------------------------------
  % Son dos operaciones distintas:
  %   redondear.m    redondea a tres digitos significativos NORMALIZANDO, y es
  %                  lo que piden los ejercicios 2 y 4 de la Guia 2.
  %   redondear_n.m  redondea a n digitos significativos SIN normalizar, y es
  %                  lo que pide explicitamente el punto 5.a: "usando la
  %                  aritmética de tres digitos y consignar los valores en la
  %                  siguiente tabla, sin normalizarlos".
  %
  % Que significa "sin normalizar"
  % -----------------------------
  % El numero se escribe en notacion cientifica, se redondea la mantisa
  % conservando n digitos y se reescribe, pero NO se vuelve a renormalizar el
  % resultado. Renormalizar significaria corregir el caso en que el redondeo
% genera un acarreo en la primera cifra, por ejemplo al redondear 999 con dos
% digitos: el resultado crudo es 100 y la forma normalizada seria 1.00 x 10^3.
% Esta funcion devuelve el 100 tal cual, sin volver a renormalizar. Ese matiz
% importa porque en una maquina de aritmetica de punto flotante de k digitos el
% exponente y la mantisa son campos separados, y cambiarlos es una operacion
% adicional.
  %
  % Ejemplo: redondear_n(104.487111, 3) = 105. El mismo numero con
  % redondear.m tambien da 105, pero con redondear_n(0.0000123456, 3) = 1.23e-05
  % se ve que la operacion se aplica a la mantisa y no se arrastra el decimal.

  if (nargin != 2)
    error("redondear_n: se requieren exactamente 2 argumentos (numero, n)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("redondear_n: numero debe ser un escalar finito");
  endif
  if (!isnumeric(n) || !isscalar(n) || !isfinite(n) || n != fix(n) || n < 1)
    error("redondear_n: n debe ser un entero positivo (n >= 1)");
  endif

  % El cero no tiene digitos significativos que conservar.
  if (numero == 0)
    resultado = 0;
    return;
  endif

  % Notacion cientifica: numero = mantisa * 10^exponente, con 1 <= |mantisa| < 10.
  % En esa forma la mantisa ya tiene UNA cifra entera, asi que los n digitos
  % significativos se obtienen reteniendo las n - 1 cifras decimales de la
  % mantisa. Retener n decimales de la mantisa seria guardar n + 1 digitos.
  exponente = floor(log10(abs(numero)));
  mantisa = numero / 10^exponente;

  % Se redondea la mantisa conservando n digitos, y se reescribe el numero sin
  % renormalizar.
  resultado = round(mantisa * 10^(n - 1)) / 10^(n - 1) * 10^exponente;
endfunction