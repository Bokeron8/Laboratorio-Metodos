function error_abs = error_absoluto(valor_exacto, valor_calculado)
  % ERROR_ABSOLUTO - Error absoluto de una aproximacion.
  % Entradas:
  %   valor_exacto    - valor de referencia p
  %   valor_calculado - aproximacion p*
  % Salidas:
  %   error_abs - |p - p*|
  %
  % El error absoluto mide la distancia entre el valor verdadero y el
  % calculado, en las mismas unidades del problema. Como es una distancia, nunca
  % es negativo: por eso se devuelve el valor absoluto de la diferencia y no la
  % diferencia con signo.
  %
  % Ojo con la division por el valor exacto: si el valor de referencia es cero,
% el error relativo no esta definido. Eso se resuelve en error_relativo.m, que
% avisa en lugar de devolver Inf silencioso.

  if (nargin != 2)
    error("error_absoluto: se requieren exactamente 2 argumentos (valor_exacto, valor_calculado)");
  endif
  if (!isnumeric(valor_exacto) || !isnumeric(valor_calculado) || ...
      !isscalar(valor_exacto) || !isscalar(valor_calculado))
    error("error_absoluto: los dos argumentos deben ser escalares numéricos");
  endif

  error_abs = abs(valor_exacto - valor_calculado);
endfunction