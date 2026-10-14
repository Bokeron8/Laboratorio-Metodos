% 03-fibonacci.m - Ejercicio 3 de la Guía 1: los N primeros términos de Fibonacci.
%
% Problema: obtener los N primeros números de la sucesión de Fibonacci, con la
% recurrencia
%   F(1) = 0,  F(2) = 1,  F(n) = F(n-1) + F(n-2)   para n > 2.
%
% Estructura de la consigna:
%   a) Calcular los N primeros términos.
%   b) Probar con N = 200.
%
% Modelo matemático: sucesión recursiva lineal. El algoritmo tiene dos versiones
% posibles y la diferencia de complejidad es brutal:
%   - Recursión ingenua: T(n) = T(n-1) + T(n-2) + O(1), que resuelve a
%     T(n) = O(phi^n) con phi = (1 + sqrt(5))/2 ≈ 1.618. El número de llamadas
%     crece exponencialmente.
%   - Versión iterativa con memorización: cada término se calcula una sola vez,
%     de modo que T(n) = O(n).
% Por ejemplo, el término 30 ya se demora alrededor de 8 segundos con la
% recursión ingenua; el término 200 exigiría del orden de 5.6e41 llamadas. La
% consigna pide N = 200, así que solo la versión lineal es viable.
%
% El algoritmo vive en fibonacci.m. Este script solo lo invoca.

clc;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 3 - LOS N PRIMEROS TÉRMINOS DE FIBONACCI\n');
fprintf('========================================================\n');

% ----------------------------------------------------------------------
% a) Número de términos a calcular
% ----------------------------------------------------------------------
N = 0;
entrada_valida = false;
intentos_maximos = 5;    % tope para no quedar repreguntando si se agota la entrada
for intento = 1:intentos_maximos
  texto = input(sprintf('\nIngrese la cantidad de términos a calcular (la consigna pide N = 200): '), 's');
  N = str2double(texto);
  if (isscalar(N) && isfinite(N) && N == fix(N) && N >= 1)
    entrada_valida = true;
    break;
  endif
  fprintf('N debe ser un entero positivo.\n');
endfor

if (!entrada_valida)
  fprintf('Se agotaron los %d intentos sin recibir un valor válido.\n', intentos_maximos);
  return;
endif

fprintf('\n--- a) Cálculo de los primeros N = %d términos ---\n', N);

% ----------------------------------------------------------------------
% b) Barrido de los N primeros términos
% ----------------------------------------------------------------------
% Se mide el tiempo porque la consigna pide evaluar el costo del proceso.
tic;
terminos = zeros(1, N);
for i = 1:N
  terminos(i) = fibonacci(i);
endfor
tiempo = toc;

% ----------------------------------------------------------------------
% Los términos calculados
% ----------------------------------------------------------------------
% Con N grande no tiene sentido imprimir 200 filas: se muestran los primeros
% términos y los últimos cinco, que son los que crecen.
fprintf('\nPrimeros términos de la sucesión: ');
fprintf('%d ', terminos(1:min(10, N)));
fprintf('\n');

fprintf('\nÚltimos %d términos calculados:\n', min(5, N));
fprintf('  %-6s %s\n', 'i', 'F(i)');
inicio_tabla = max(1, N - 4);
for i = inicio_tabla:N
  fprintf('  %-6d %.0f\n', i, terminos(i));
endfor

fprintf('\nTiempo de ejecución del barrido completo: %.6f s\n', tiempo);

% ----------------------------------------------------------------------
% Verificación
% ----------------------------------------------------------------------
% Se comprueba que la sucesión cumple la recurrencia en cada paso.
fprintf('\n--- Verificación de la recurrencia ---\n');
if (N >= 3)
 Fallos = 0;
  for i = 3:N
    if (terminos(i) != terminos(i - 1) + terminos(i - 2))
      Fallos = Fallos + 1;
    endif
  endfor
  fprintf('Pasos verificados: %d | pasos que incumplen F(i) = F(i-1) + F(i-2): %d\n', ...
          N - 2, Fallos);
else
  fprintf('N es demasiado chico para verificar la recurrencia (hace falta N >= 3).\n');
endif

% ----------------------------------------------------------------------
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('El barrido completo con N = %d se resuelve en %.6f s: es viable porque\n', N, tiempo);
fprintf('fibonacci.m memoriza los términos ya calculados y cada uno se obtiene\n');
fprintf('exactamente una vez, con lo que el costo total es lineal en N.\n');
fprintf('A partir de F(78) los términos superan 2^53 y dejan de ser enteros\n');
fprintf('exactamente representables en un double; a partir de ahí el resultado es\n');
fprintf('el double más cercano al entero verdadero.\n');
fprintf('El crecimiento de la sucesión es exponencial (razón asintótica phi ≈ 1.618),\n');
fprintf('que es justamente lo que vuelve inviable la recursión ingenua.\n');