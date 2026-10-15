% 01-suma-n-numeros.m - Ejercicio 1 de la Guía 1: suma de N números positivos.
%
% Problema: dado N números positivos X1, X2, ..., XN, hallar
%   S = X1 + X2 + ... + XN.
%
% Estructura del problema:
%   a) Probar con N comprendido en el rango de representación de enteros
%      de 0 a 255.
%   b) Luego repetir la prueba con N = 10000 y comparar los tiempos.
%
% Modelo matemático: el acumulado es una suma que crece de a un término por
% iteración, así que el número de operaciones crece linealmente con N: el
% algoritmo es de clase O(N). No se puede obtener la suma con menos de N
% adiciones, porque cada dato tiene que recorrerse una vez.
%
% Sobre los datos: el enunciado dice "dado N números positivos", y la versión
% original de este ejercicio los pedía uno por uno por teclado. Acá se generan
% con una secuencia determinista para que el script se pueda ejecutar no
% interactivo y el tiempo sea reproducible entre corridas. Reemplazando la
% línea marcada abajo por "x = input(...)" se recupera el comportamiento
% interactivo original.

clc;

% ----------------------------------------------------------------------
% Generador de los datos del problema
% ----------------------------------------------------------------------
% Secuencia determinista de enteros positivos: (i * 7919) mod 1000 + 1.
% No usa el estado del generador aleatorio, de modo que la suma es siempre la
% misma y el tiempo de ejecución depende solo de N.
generar_valor = @(i) mod(i * 7919, 1000) + 1;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 1 - SUMA DE N NÚMEROS POSITIVOS\n');
fprintf('========================================================\n');

N = 0;
entrada_valida = false;
intentos_maximos = 5;    % tope para no quedar repreguntando si se agota la entrada
for intento = 1:intentos_maximos
  texto = input(sprintf('\nIngrese la cantidad de números a sumar (se requiere un N entre 0 y 255): '), 's');
  N = str2double(texto);
  if (isscalar(N) && isfinite(N) && N == fix(N) && N >= 0 && N <= 255)
    entrada_valida = true;
    break;
  endif
  fprintf('El valor debe ser un entero entre 0 y 255.\n');
endfor

if (!entrada_valida)
  fprintf('Se agotaron los %d intentos sin recibir un valor válido.\n', intentos_maximos);
  return;
endif

% ----------------------------------------------------------------------
% a) Primer caso: N dentro del rango de representación de 0 a 255
% ----------------------------------------------------------------------
N_primer_caso = N;

fprintf('\n--- a) Primer caso: N dentro del rango de 0 a 255 ---\n');
fprintf('N = %d\n', N);

% cputime devuelve tiempo de CPU consumido por el proceso; se toma antes y
% después para medir lo que realmente costó la suma.
cpu_inicio = cputime;
tic;
total = 0;
for i = 1:N
  % Reemplazar por "x = input('Ingrese el valor a sumar: ')" para el modo interactivo.
  x = generar_valor(i);
  total = total + x;
endfor
tiempo_a = toc;
cpu_a = cputime - cpu_inicio;

fprintf('Suma total = %d\n', total);
fprintf('Tiempo de ejecución: %.6f s (tic/toc), %.6f s de CPU (cputime)\n', tiempo_a, cpu_a);

% ----------------------------------------------------------------------
% b) Segundo caso: N = 10000
% ----------------------------------------------------------------------
N = 10000;

fprintf('\n--- b) Segundo caso: N = 10000 ---\n');
fprintf('N = %d\n', N);

cpu_inicio = cputime;
tic;
total = 0;
for i = 1:N
  x = generar_valor(i);
  total = total + x;
endfor
tiempo_b = toc;
cpu_b = cputime - cpu_inicio;

fprintf('Suma total = %d\n', total);
fprintf('Tiempo de ejecución: %.6f s (tic/toc), %.6f s de CPU (cputime)\n', tiempo_b, cpu_b);

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('El algoritmo es lineal en N (O(N)). Al crecer N, los costos fijos del\n');
fprintf('intérprete se amortizan y el tiempo escala proporcionalmente a los datos.\n');
