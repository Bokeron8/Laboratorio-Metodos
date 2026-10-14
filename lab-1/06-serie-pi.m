% 06-serie-pi.m - Ejercicio 6 de la Guía 1: la constante pi por la serie de Leibniz.
%
% Problema: calcular pi con n cifras exactas a partir del desarrollo en serie
%   pi = 4 * (1 - 1/3 + 1/5 - 1/7 + ...)
%   - i.   Calcular la cantidad de términos necesarios para alcanzar 3 dígitos exactos.
%   - ii.  Calcular la cantidad necesaria para 4 dígitos, y luego para 5.
%          Comparar con el punto anterior teniendo en cuenta la convergencia y
%          controlar los tiempos de ejecución.
%
% Modelo matemático: la serie de Leibniz, que converge a velocidad 1/n. Si S_n
% es la suma parcial de n términos, el resto está acotado por el primer término
% omitido, así que el error absoluto de la aproximación 4*S_n satisface
%   |pi - 4*S_n| <= 4 / (2n + 1)
% es decir, el error decae como 1/n. Para ganar un dígito decimal hace falta
% multiplicar n por 10. Esa es la razón de que el punto ii pida tanto tiempo de
% cómputo y es lo que la consigna pide comparar.
%
% Criterio de "dígitos exactos"
% -----------------------------
% El enunciado dice "3 dígitos exactos", y la frase es ambigua: puede referirse
% a dígitos DECIMALES (3.142...) o a CIFRAS SIGNIFICATIVAS (mantisa entera).
% Se presentan las dos lecturas y el script dice explícitamente cuál está usando
% en cada tabla.
%
% Ambas se resuelven con el mismo predicado: la aproximación coincide con el
% valor de referencia una vez redondeada a esa precisión,
%   redondeo(p, d) == redondeo(pi, d)
% Para un número como pi, cuya primera cifra significativa es la de las
% unidades, tener d decimales correctos equivale a tener d + 1 cifras
% significativas correctas. Por eso las dos tablas salen desplazadas una
% posición, y el script se apoya en esa equivalencia para no calcular dos veces
% la misma cosa.
%
% Correcciones respecto de la versión original
% -------------------------------------------
% El código anterior no podía ejecutarse: el lazo "for i = 1:1:n" usaba la
% variable n, pero la línea "n = input(...)" estaba comentada, de modo que
% fallaba con 'n' undefined. Además la aritmética era incoherente: aplicaba
% fix al denominador de un término pero no al del otro, de modo que la serie no
% era la de Leibniz, y calculaba una variable valor_pi que nunca se usaba.
%
% Advertencia sobre los comentarios heredados
% ------------------------------------------
% La versión anterior anotaba a mano "3 digito 613", "4 digito 1690" y
% "5 digitos 10800". Ninguno de esos tres números coincide con ninguna de las
% dos lecturas, y tampoco se los puede reproducir con esta implementación. No
% se los fuerza: abajo se reportan los valores efectivamente medidos, que son
% los que se pueden defender.

clc;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 6 - LA CONSTANTE pi POR LA SERIE DE LEIBNIZ\n');
fprintf('========================================================\n');
fprintf('Serie:  pi = 4 * (1 - 1/3 + 1/5 - 1/7 + ...)\n');

% ----------------------------------------------------------------------
% Búsqueda de la cantidad de términos para cada precisión
% ----------------------------------------------------------------------
% Se acumulan los términos una sola vez y, en cada paso, se registra en qué
% momento se cumple por primera vez cada criterio. Es la forma más barata de
% obtener las seis respuestas: el costo es el de la corrida más exigente, no
% la suma de las seis.
%
% Los criterios están anidados: si la aproximación coincide con pi redondeada a
% d decimales, también coincide redondeada a d-1, porque redondear a menos
% decimales es redondear el redondeo más fino. Por eso basta con vigilar la
% precisión pendiente más gruesa: es la única que puede volverse verdadera, y
% las más finas se irán registrando a continuación sin volver a evaluarlas.
%
% Se cubre d = 1 a 5 decimales. Con eso alcanzan las dos lecturas: la de
% dígitos decimales usa d = 3, 4, 5 y la de cifras significativas usa
% d = 2, 3, 4, porque pi empieza con "3.". El máximo es 5 justamente para que
% la búsqueda termine en el último caso pedido y no siga de más.
% ----------------------------------------------------------------------
% Redondeo al dígito d-ésimo decimal, sin depender de round(X, n), que no
% existe en Octave: se escala, se redondea y se desescala. La escala y el
% valor de referencia redondeado se precalculan una vez, fuera del lazo, para
% que el tiempo que se mide sea el de la serie y no el de la instrumentación.
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
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('Los dos puntos de la consigna piden 3, 4 y 5 dígitos. Da igual cuál de las\n');
fprintf('dos lecturas se tome, porque el patrón es el mismo: pasar de un dígito al\n');
fprintf('siguiente multiplica la cantidad de términos por un factor cercano a 10, y\n');
fprintf('el tiempo de cómputo crece con esa misma proporción, de forma lineal.\n');
fprintf('Eso es la firma de una convergencia de orden 1/n: el error decae como\n');
fprintf('1/n, que es exactamente lo que predice el resto acotado por el primer\n');
fprintf('término omitido. La serie converge, pero es de las más lentas que se\n');
fprintf('conoce para pi.\n');
fprintf('El contraste con el ejercicio 5 es el punto: la serie de e converge a\n');
fprintf('velocidad factorial y alcanza toda la precisión de un double con unos 20\n');
fprintf('términos, mientras que esta necesita del orden de 10^5 para cinco\n');
fprintf('decimales. Elegir un desarrollo que converja rápido importa mucho más que\n');
fprintf('agregar términos.\n');
fprintf('Nota sobre los valores heredados: los comentarios de la versión anterior\n');
fprintf('mencionaban 613, 1690 y 10800 términos. Ninguno coincide con los valores\n');
fprintf('medidos arriba ni con ninguna de las dos lecturas del enunciado, así que\n');
fprintf('no se los reproduce.\n');