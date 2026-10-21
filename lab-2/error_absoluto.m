function error_abs = error_absoluto(valor_exacto, valor_calculado)
  % ERROR_ABSOLUTO - Error absoluto de una aproximación.
  % Entradas:
  %   valor_exacto    - valor de referencia p
  %   valor_calculado - aproximación p*
  % Salidas:
  %   error_abs - |p - p*|
  %
  % Es una distancia, así que nunca es negativa, y se mide en las mismas
  % unidades del problema.

  if (nargin != 2)
    error("error_absoluto: se requieren exactamente 2 argumentos (valor_exacto, valor_calculado)");
  endif
  if (!isnumeric(valor_exacto) || !isnumeric(valor_calculado) || ...
      !isscalar(valor_exacto) || !isscalar(valor_calculado))
    error("error_absoluto: los dos argumentos deben ser escalares numéricos");
  endif

  error_abs = abs(valor_exacto - valor_calculado);
endfunction