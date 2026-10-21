% 01-error-absoluto-relativo.m - Ejercicio 1 de la Guía 2: errores de aproximación.
%
% Problema: calcular el error absoluto y el error relativo en seis
% aproximaciones de p por p*:
%   a) p = pi,      p* = 22/7
%   b) p = pi,      p* = 3.1416
%   c) p = e,       p* = 2.718
%   d) p = raiz(2), p* = 1.414
%   e) p = e^10,    p* = 22000
%   f) p = 8!,      p* = 39900
%
%   error absoluto = |p - p*|
%   error relativo = |p - p*| / |p|
% El absoluto mide la distancia en las unidades del problema; el relativo la
% divide por el propio valor, así que es adimensional y comparable entre
% problemas de distinta magnitud.

clc;

% ----------------------------------------------------------------------
% Datos de los seis casos
% ----------------------------------------------------------------------
% Cada fila es [valor_exacto, aproximacion].
% El valor exacto se evalúa con la función de Octave correspondiente.
casos = [ pi,     22 / 7;
          pi,     3.1416;
          exp(1), 2.718;
          sqrt(2), 1.414;
          exp(10), 22000;
          factorial(8), 39900 ];

etiquetas = {'a) p = pi', 'b) p = pi', 'c) p = e', ...
             'd) p = raiz(2)', 'e) p = e^10', 'f) p = 8!'};

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 1 - ERROR ABSOLUTO Y ERROR RELATIVO\n');
fprintf('========================================================\n');

% ----------------------------------------------------------------------
% a-f) Cálculo de los seis casos
% ----------------------------------------------------------------------
fprintf('\n--- Resultados de los seis casos ---\n\n');
fprintf('%-4s %-14s %-14s %-14s %-14s\n', ...
        'caso', 'p (exacto)', 'p* (aprox.)', 'Error absoluto', 'Error relativo');

errores_absolutos = zeros(rows(casos), 1);
errores_relativos = zeros(rows(casos), 1);

for k = 1:rows(casos)
  exacto = casos(k, 1);
  aproximado = casos(k, 2);

  errores_absolutos(k) = error_absoluto(exacto, aproximado);
  errores_relativos(k) = error_relativo(exacto, aproximado);

  fprintf('%-4s %-14.10g %-14.10g %-14.6e %.6e\n', ...
          etiquetas{k}(1:1), exacto, aproximado, ...
          errores_absolutos(k), errores_relativos(k));
endfor

% ----------------------------------------------------------------------
% Ordenamiento por error relativo
% ----------------------------------------------------------------------
% Los casos se ordenan de peor a mejor error relativo: así se ve que el error
% absoluto y el relativo no coinciden en el orden.
fprintf('\n--- Ordenamiento por error relativo (de peor a mejor) ---\n\n');
fprintf('%-14s %-16s %-16s\n', 'caso', 'Error absoluto', 'Error relativo');

[~, orden] = sort(errores_relativos, 'descend');
for j = 1:numel(orden)
  k = orden(j);
  fprintf('%-14s %-16.6e %.6e\n', etiquetas{k}, ...
          errores_absolutos(k), errores_relativos(k));
endfor

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('El error relativo es la métrica adecuada para comparar aproximaciones\n');
fprintf('de distinta magnitud. A menor cantidad de cifras significativas, mayor error relativo.\n');