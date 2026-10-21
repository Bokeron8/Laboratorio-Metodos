% 06-serie-pi.m - Ejercicio 6 de la Guía 1: la constante pi por la serie de Leibniz.
%
% Problema: calcular pi con n cifras exactas a partir del desarrollo
%   pi = 4 * (1 - 1/3 + 1/5 - 1/7 + ...)
%   i.  Cantidad de términos necesarios para 3 dígitos exactos.
%   ii. La misma cuenta para 4 y 5 dígitos, comparando el costo.
%
% La serie converge como 1/n: el resto queda acotado por el primer término
% omitido, |pi - 4*S_n| <= 4/(2n + 1). Ganar un dígito decimal exige multiplicar
% la cantidad de términos por 10.
%
% El script informa el resultado con dos lecturas de "n dígitos exactos":
%   A) n dígitos decimales: la aproximación redondeada a n decimales.
%   B) n cifras significativas: como pi empieza en 3, equivale a n-1 decimales.
% En ambos casos se compara contra pi redondeado a esa misma precisión.

clc;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 6 - LA CONSTANTE pi POR LA SERIE DE LEIBNIZ\n');
fprintf('========================================================\n');
fprintf('Serie:  pi = 4 * (1 - 1/3 + 1/5 - 1/7 + ...)\n');

% ----------------------------------------------------------------------
% Búsqueda de la cantidad de términos para cada precisión
% ----------------------------------------------------------------------
% La serie se acumula una sola vez y en cada paso se anota el primer n que
% cumple cada criterio, así el costo es el de la corrida más exigente.
%
% Los criterios están anidados: coincidir con d decimales implica coincidir con
% d-1, así que alcanza con vigilar la precisión pendiente más gruesa.
%
% Se cubren d = 1 a 5 decimales, que alcanzan para las dos lecturas.
%
% El escalado reemplaza a round(X, n), que Octave no tiene: se multiplica por
% 10^d, se redondea y se divide. Escalas y referencia se calculan una sola vez,
% fuera del lazo.
pi_referencia = pi;
maximo_decimales = 5;
escalas = 10 .^ (1:maximo_decimales);
referencia_redondeada = round(pi_referencia * escalas) ./ escalas;

% Cada fila guarda: [decimales, n alcanzado, error absoluto, tiempo acumulado].
resultados = zeros(maximo_decimales, 4);

fprintf('\n--- Búsqueda de la cantidad de términos ---\n');
fprintf('Se acumula la serie término a término y se anota el primer n para el que\n');
fprintf('la aproximación redondeada coincide con pi redondeada.\n');

tic;
suma_parcial = 0;
n = 0;
d_pendiente = 1;                       % precisión todavía no alcanzada
cpu_inicio = cputime;
while (n < 200000 && d_pendiente <= maximo_decimales)
  n = n + 1;

  % Término n-ésimo de la serie: signo alternado y denominador 2n - 1.
  if (mod(n, 2) == 1)
    suma_parcial = suma_parcial + 1 / (2 * n - 1);
  else
    suma_parcial = suma_parcial - 1 / (2 * n - 1);
  endif

  aproximacion = 4 * suma_parcial;

  if (round(aproximacion * escalas(d_pendiente)) / escalas(d_pendiente) ...
      == referencia_redondeada(d_pendiente))
    resultados(d_pendiente, :) = [d_pendiente, n, ...
                                  abs(aproximacion - pi_referencia), toc];
    d_pendiente = d_pendiente + 1;
  endif
endwhile
tiempo_total = toc;
cpu_total = cputime - cpu_inicio;

% ----------------------------------------------------------------------
% Lectura A: dígitos decimales exactos
% ----------------------------------------------------------------------
fprintf('\n--- Lectura A: dígitos DECIMALES exactos ---\n');
fprintf('Se busca el primer n tal que el valor redondeado a d decimales coincide\n');
fprintf('con el de pi redondeado a la misma cantidad de decimales.\n\n');
fprintf('%-14s %-14s %-16s %s\n', 'Dígitos', 'Términos', 'Error absoluto', 'Tiempo');
for d = 3:5
  fila = resultados(d, :);
  fprintf('%-14d %-14d %-16.6e %.6f s\n', d, fila(2), fila(3), fila(4));
endfor

% ----------------------------------------------------------------------
% Lectura B: cifras significativas
% ----------------------------------------------------------------------
fprintf('\n--- Lectura B: CIFRAS SIGNIFICATIVAS ---\n');
fprintf('Como la primera cifra significativa de pi es la de las unidades, tener\n');
fprintf('d cifras significativas equivale a tener d - 1 decimales correctos. Se\n');
fprintf('listan los valores ya medidos con ese desplazamiento.\n\n');
fprintf('%-14s %-14s %-16s %s\n', 'Cifras sig.', 'Términos', 'Error absoluto', 'Tiempo');
for c = 3:5
  fila = resultados(c - 1, :);
  fprintf('%-14d %-14d %-16.6e %.6f s\n', c, fila(2), fila(3), fila(4));
endfor

% ----------------------------------------------------------------------
% Convergencia
% ----------------------------------------------------------------------
fprintf('\n--- Comparación y convergencia ---\n');
fprintf('%-14s %-14s %-14s %s\n', 'Dígitos', 'Términos', 'Cociente', 'Tiempo acumulado');
for d = 3:5
  fila = resultados(d, :);
  cociente = fila(2) / resultados(d - 1, 2);
  fprintf('%-14d %-14d %-14.2f %.6f s\n', d, fila(2), cociente, fila(4));
endfor

fprintf('\nCosto total de la búsqueda: %.6f s (tic/toc), %.6f s de CPU (cputime)\n', ...
        tiempo_total, cpu_total);
fprintf('El último caso, el de cinco decimales, es con diferencia el más caro:\n');
fprintf('requiere %d términos y por sí solo consume %.6f s de los %.6f s totales.\n', ...
        resultados(5, 2), resultados(5, 4), tiempo_total);

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('La serie de Leibniz para pi tiene convergencia lenta O(1/n): ganar un dígito\n');
fprintf('exige multiplicar los términos por ~10, evidenciando que elegir un método\n');
fprintf('de rápida convergencia es fundamental frente a la fuerza bruta.\n');