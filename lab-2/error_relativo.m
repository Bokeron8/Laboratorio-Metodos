function error_rel = error_relativo(valor_exacto, valor_calculado)
  % ERROR_RELATIVO - Error relativo de una aproximación.
  % Entradas:
  %   valor_exacto    - valor de referencia p
  %   valor_calculado - aproximación p*
  % Salidas:
  %   error_rel - |p - p*| / |p|
  %
  % Es adimensional, porque divide por el propio valor de referencia, y por eso
  % es comparable entre problemas de distinta magnitud. El denominador va en
  % valor absoluto para que el error de un valor negativo también sea positivo.
  %
  % Si el valor exacto es cero el error no está definido: se avisa y se devuelve
  % Inf en lugar de un NaN silencioso.

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