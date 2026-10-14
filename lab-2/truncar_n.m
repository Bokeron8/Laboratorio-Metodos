function resultado = truncar_n(numero, n)
  % TRUNCAR_N - Trunca un numero a n digitos SIGNIFICATIVOS, SIN NORMALIZAR.
  % Entradas:
  %   numero - valor a truncar
  %   n      - cantidad de digitos significativos a conservar
  % Salidas:
  %   resultado - numero conservando n digitos significativos
  %
  % Por que esta funcion existe, separada de truncar.m
  % ---------------------------------------------------
  % Son dos operaciones distintas:
  %   truncar.m    trunca a tres digitos significativos NORMALIZANDO, y es lo
  %                que piden los ejercicios 2 y 3 de la Guia 2.
  %   truncar_n.m  trunca a n digitos significativos SIN normalizar, y es lo
  %                que pide explicitamente el punto 5.a: "usando la
  %                aritmetica de tres digitos y consignar los valores en la
  %                siguiente tabla, sin normalizarlos".
  %
  % Que significa "sin normalizar"
  % -----------------------------
  % El numero se escribe en notacion cientifica, se trunca la mantisa
  % conservando n digitos y se reescribe, pero NO se vuelve a renormalizar el
  % resultado, igual que en redondear_n.m.
  %
  % El truncamiento NO mira el digito siguiente, a diferencia del redondeo:
  % truncar_n(104.487111, 3) = 104 y no 105, porque el 4 decimal se descarta
  % en lugar de redondear el 104 hacia arriba. Esa diferencia entre mirar o no
  % mirar el digito descartado es el objeto del ejercicio 3.

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

  % Notacion cientifica: numero = mantisa * 10^exponente, con 1 <= |mantisa| < 10.
  % En esa forma la mantisa ya tiene UNA cifra entera, asi que los n digitos
  % significativos se obtienen reteniendo las n - 1 cifras decimales de la
  % mantisa. Retener n decimales de la mantisa seria guardar n + 1 digitos.
  exponente = floor(log10(abs(numero)));
  mantisa = numero / 10^exponente;

  % Escalar la mantiza a un numero entero de n digitos.
  escalado = mantisa * 10^(n - 1);

  % Correccion de error de representacion.
  %
  % Las potencias de 10 no son exactas en punto flotante, de modo que el
  % escalado puede dar un entero que quedó apenas por debajo del entero
  % verdadero. El caso típico es truncar_n(0.149, 3): 0.149 / 10^(-1) da
  % 1.4899999999999998, que al escalar por 100 da 148.99999999999997 y
  % fix se lleva un dígito de más. Cuando el valor está dentro de unas pocas
  % unidades de error de maquina de un entero, se lo considera ESE entero: el
  % margen es relativo, así que un truncamiento genuino nunca se ve afectado.
  if (abs(escalado - round(escalado)) <= 10 * eps(abs(escalado)))
    escalado = round(escalado);
  endif

  % Se trunca la mantisa conservando n digitos, y se reescribe el numero sin
  % renormalizar. fix trunca hacia cero, que es justamente el truncamiento de
  % cifras: no mira el digito descartado.
  resultado = fix(escalado) / 10^(n - 1) * 10^exponente;
endfunction