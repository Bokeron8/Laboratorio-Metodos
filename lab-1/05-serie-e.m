% 05-serie-e.m - Ejercicio 5 de la Guía 1: el número e como serie.
%
% Problema: calcular e como suma de la serie
%   e = 1 + 1/1! + 1/2! + 1/3! + ... + 1/N!
% con N entero positivo, y observar que la precisión mejora cuanto mayor es N.
%
% Modelo matemático: es el desarrollo de Taylor de e^x en el origen evaluado
% en x = 1. El algoritmo es de clase O(N): un acumulado por iteración, con un
% factorial por término, calculado con la función factorial de Octave.
%
% Sobre el factorial: para N grande, factorial(N) se desborda a Inf. Eso NO
% arruina el resultado, porque 1/Inf vale exactamente 0 y los términos con N
% mayor a 170 están muy por debajo de la precisión de un double, así que
% sumarles cero es lo correcto. Se comprobó que reemplazar 1/factorial(i) por
% un término iterativo t = t/i da un resultado idéntico para N = 20, 50, 170,
% 171, 200 y 250, de modo que se conserva la expresión original.
%
% Estructura de la consigna:
%   a) Calcular la serie con un N ingresado por el usuario.
%   b) Comparar contra el valor exacto exp(1) y reportar el error.
%   c) Probar con distintas cantidades de sumandos y sacar conclusiones.

clc;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 5 - EL NÚMERO e COMO SERIE DE TAYLOR\n');
fprintf('========================================================\n');
fprintf('Serie:  e = 1 + 1/1! + 1/2! + ... + 1/N!\n');

% ----------------------------------------------------------------------
% a) Cálculo de la serie con el N pedido por el usuario
% ----------------------------------------------------------------------
N = 0;
entrada_valida = false;
intentos_maximos = 5;    % tope para no quedar repreguntando si se agota la entrada
for intento = 1:intentos_maximos
  texto = input(sprintf('\nIngrese la cantidad de sumandos a utilizar: '), 's');
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

fprintf('\n--- a) Serie evaluada en N = %d ---\n', N);

tic;
total = 1;          % el primer término de la serie es 1/0! = 1
for i = 1:N
  total = total + 1 / factorial(i);
endfor
tiempo = toc;

% El valor exacto contra el que se mide el error.
exacto = exp(1);

fprintf('Resultado de la serie = %s\n', sprintf('%.16f', total));
fprintf('Valor exacto exp(1)   = %s\n', sprintf('%.16f', exacto));
fprintf('Error absoluto        = %.6e\n', abs(exacto - total));
fprintf('Error relativo        = %.6e\n', abs(exacto - total) / exacto);
fprintf('Tiempo de ejecución: %.6f s\n', tiempo);

% ----------------------------------------------------------------------
% b) Barrido de distintas cantidades de sumandos
% ----------------------------------------------------------------------
% La consigna pide probar con diferentes cantidades de sumandos. El barrido
% muestra cómo el error decrece a medida que crece N.
fprintf('\n--- b) Comportamiento según la cantidad de sumandos ---\n');
fprintf('%-10s %-22s %-14s %s\n', 'N', 'e por la serie', 'Error abs.', 'Error rel.');

valores_N = [1, 2, 5, 10, 15, 20, 25, 30, 40, 50, 100, 171, 200];
for N_actual = valores_N
  total = 1;
  for i = 1:N_actual
    total = total + 1 / factorial(i);
  endfor
  fprintf('%-10d %-22.15f %-14.6e %.6e\n', N_actual, total, ...
          abs(exacto - total), abs(exacto - total) / exacto);
endfor

% ----------------------------------------------------------------------
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('La serie es una aproximación de la velocidad máxima de convergencia entre\n');
fprintf('las series elementales: cada término es del orden del factorial del anterior,\n');
fprintf('de modo que la cola de la suma se reduce casi por mitades en cada paso y la\n');
fprintf('precisión de un double se alcanza en apenas unos veinte sumandos.\n');
fprintf('En contraste, la serie de Leibniz del ejercicio 6 avanza a velocidad 1/n y\n');
fprintf('necesita del orden de 130000 términos para cinco decimales: toda serie\n');
fprintf('converge, pero no todas convergen al mismo ritmo, y acá la elección del\n');
fprintf('desarrollo pesa mucho más que la cantidad de términos.\n');