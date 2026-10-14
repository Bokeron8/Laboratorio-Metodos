function resultado = truncar(numero)
  % TRUNCAR - Trunca un numero a tres digitos SIGNIFICATIVOS, normalizando.
  % Entradas:
  %   numero - valor a truncar
  % Salidas:
  %   resultado - numero conservando tres digitos significativos
  %
  % Que significa "tres digitos" aca
  % ------------------------------
  % Los tres digitos son los tres primeros digitos significativos, contados
  % desde la primera cifra no nula. El numero se normaliza a la forma
  % 0.d1d2d3... x 10^e, se trunca esa mantisa a tres digitos y se vuelve a
  % armar el numero:
  %   [e, m] = normalizar(numero)
  %   resultado = fix(m * 10^3) / 10^3 * 10^e
  %
  % El truncamiento NO mira el digito siguiente: 133.921 se trunca a 133
  % directamente, mientras que redondear.m llevaria ese mismo numero a 134.
  % Esa diferencia entre mirar o no mirar el digito descartado es justamente lo
  % que el ejercicio 3 pide comparar con el ejercicio 2.
  %
  % Esta es la version NORMALIZADA, que es la que piden los ejercicios 2 y 3 de
  % la Guía 2. Para trabajar SIN normalizar, que es lo que pide el ejercicio 5,
  % hay que usar truncar_n.m: son operaciones distintas y confundirlas cambia
  % el resultado, asi que van en archivos separados a proposito.

  if (nargin != 1)
    error("truncar: se requiere exactamente 1 argumento (numero)");
  endif
  if (!isnumeric(numero) || !isscalar(numero) || !isfinite(numero))
    error("truncar: numero debe ser un escalar finito");
  endif

  [exponente, mantisa] = normalizar(numero);

  % Escalar la mantisa a un numero entero de tres digitos.
  escalado = mantisa * 10^3;

  % Correccion de error de representacion.
  %
  % Las potencias de 10 no son exactas en punto flotante, de modo que el
  % escalado puede dar un entero que quedó apenas por debajo del entero
  % verdadero, y fix se lleva un digito de mas. El caso tipico es
  % truncar(-28): normalizar divide dos veces y produce -0.27999999999999997,
  % que al escalar por 1000 da -279.99999999999994 y fix devuelve -279 en
  % lugar de -280. Cuando el valor esta dentro de unas pocas unidades de error
  % de maquina de un entero, se lo considera ESE entero: el margen es relativo,
  % asi que un truncamiento genuino nunca se ve afectado.
  if (abs(escalado - round(escalado)) <= 10 * eps(abs(escalado)))
    escalado = round(escalado);
  endif

  truncado = fix(escalado) / 10^3;
  resultado = truncado * 10^exponente;
endfunction