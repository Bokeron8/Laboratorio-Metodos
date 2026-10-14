% 01-error-absoluto-relativo.m - Ejercicio 1 de la Guía 2: errores de aproximación.
%
% Problema: calcular el error absoluto y el error relativo en seis
% aproximaciones de p por p*.
%
% Estructura de la consigna:
%   a) p = pi,    p* = 22/7
%   b) p = pi,    p* = 3.1416
%   c) p = e,     p* = 2.718
%   d) p = raiz(2), p* = 1.414
%   e) p = e^10,  p* = 22000
%   f) p = 8!,    p* = 39900
%
% Modelo matemático:
%   error absoluto  = |p - p*|
%   error relativo  = |p - p*| / |p|
% El absoluto mide la distancia en las unidades del problema; el relativo lo
% divide por el propio valor, con lo que es adimensional y comparable entre
% problemas de distinta magnitud. Esa es exactamente la diferencia que se ve en
% los casos e) y f) del enunciado: 22000 y 39900 son aproximaciones bastante
% relativo en términos absolutos, pero no tanto en términos relativos.
%
% Las dos fórmulas viven en error_absoluto.m y error_relativo.m; este script
% arma la tabla y las conclusions.

clc;

% ----------------------------------------------------------------------
% Datos de los seis casos
% ----------------------------------------------------------------------
% Los casos se guardan en una matriz de 6x3 con [valor_exacto, aproximacion].
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

  % Las dos llamadas van a los archivos de metodo, no a formulas sueltas aca.
  errores_absolutos(k) = error_absoluto(exacto, aproximado);
  errores_relativos(k) = error_relativo(exacto, aproximado);

  fprintf('%-4s %-14.10g %-14.10g %-14.6e %.6e\n', ...
          etiquetas{k}(1:1), exacto, aproximado, ...
          errores_absolutos(k), errores_relativos(k));
endfor

% ----------------------------------------------------------------------
% Ordenamiento por error relativo
% ----------------------------------------------------------------------
% La consigna pide comparar los resultados. La tabla ordena los casos de
% peor a mejor aproximacion, que es la lectura que deja en claro que el error
% absoluto y el relativo cuentan historias distintas.
fprintf('\n--- Ordenamiento por error relativo (de peor a mejor) ---\n\n');
fprintf('%-14s %-16s %-16s\n', 'caso', 'Error absoluto', 'Error relativo');

[~, orden] = sort(errores_relativos, 'descend');
for j = 1:numel(orden)
  k = orden(j);
  fprintf('%-14s %-16.6e %.6e\n', etiquetas{k}, ...
          errores_absolutos(k), errores_relativos(k));
endfor

% ----------------------------------------------------------------------
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
[~, peor] = max(errores_relativos);
[~, mejor] = min(errores_relativos);

fprintf('La peor aproximacion en terminos relativos es %s, con %.4e.\n', ...
        etiquetas{peor}, errores_relativos(peor));
fprintf('La mejor es %s, con %.4e.\n', etiquetas{mejor}, errores_relativos(mejor));

fprintf('\nEl caso e) es el que mejor muestra para que sirve cada error: p* = 22000\n');
fprintf('contra un valor exacto de %.4f tiene un error absoluto de %.1f, enorme\n', ...
        casos(5, 1), errores_absolutos(5));
fprintf('comparado con los demas casos, pero su error relativo es de %.4e, el mas\n', ...
        errores_relativos(5));
fprintf('bajo de los seis. Mismo fenómeno en el caso f). O sea: para comparar\n');
fprintf('aproximaciones de magnitudes distintas hay que mirar el error RELATIVO;\n');
fprintf('el absoluto solo tiene sentido cuando las unidades son comparables.\n');
fprintf('Para un mismo problema, en cambio, el error relativo siempre es el\n');
fprintf('absoluto dividido por una constante, asi que dan la misma informacion.\n');

fprintf('\nTodos los casos salen de truncar o redondear el valor exacto, asi que\n');
fprintf('el error absoluto no supera la mitad de la ultima cifra escrita. En los\n');
fprintf('casos a) a d) se ve ademas que el error relativo crece a medida que baja\n');
fprintf('la cantidad de cifras, que es la forma cuantitativa de "menos cifras,\n');
fprintf('menos exactitud": 22/7 conserva nueve cifras y es mucho mejor que\n');
fprintf('3.1416, que solo conserva cinco.\n');