function error_rel = error_relativo(valor_exacto, valor_calculado)
  % ERROR_RELATIVO - Error relativo de una aproximacion.
  % Entradas:
  %   valor_exacto    - valor de referencia p
  %   valor_calculado - aproximacion p*
  % Salidas:
  %   error_rel - |p - p*| / |p|
  %
  % El error absoluto depende de las unidades del problema: un error de 0.01 es
  % muchísimo en milimetros y muy poco en kilómetros. El error relativo divide
  % por el propio valor y por eso es adimensional y comparable entre problemas
  % de distinta magnitud.
  %
  % El denominador va con valor absoluto. La version anterior de este repositorio
  % dividia por el valor exacto con signo, lo que hacia que el error relativo
  % de una aproximacion de un numero NEGATIVo saliera negativo, y un error no
  % puede ser negativo. Con el valor absoluto el resultado es siempre >= 0.
  %
  % Si el valor exacto es cero el error relativo no esta definido (seria una
  % division por cero), asi que se avisa y se devuelve Inf en lugar de dejar que
  % la maquina produzca un NaN silencioso.

  if (nargin != 2)
    error("error_relativo: se requieren exactamente 2 argumentos (valor_exacto, valor_calculado)");
  endif
  if (!isnumeric(valor_exacto) || !isnumeric(valor_calculado) || ...
      !isscalar(valor_exacto) || !isscalar(valor_calculado))
    error("error_relativo: los dos argumentos deben ser escalares numéricos");
  endif

  if (valor_exacto == 0)
    warning("error_relativo: el valor exacto es cero, el error relativo no está definido");
    error_rel = Inf;
    return;
  endif

  error_rel = abs(valor_exacto - valor_calculado) / abs(valor_exacto);
endfunction