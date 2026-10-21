% 02-suma-pares.m - Ejercicio 2 de la Guía 1: suma de los valores pares.
%
% Problema: dados 200 números positivos X1, X2, ..., X200, hallar la suma de
% todos los valores pares de la sucesión y reportar el tiempo de ejecución.
%
% El predicado de pertenencia es mod(Xi, 2) == 0. Una sola pasada, con una
% comparación y una posible adición por dato: O(N).
%
% Los datos se generan con una secuencia determinista, no aleatoria, para que la
% suma y el tiempo sean reproducibles entre corridas.

clc;

% ----------------------------------------------------------------------
% Generador de los datos del problema
% ----------------------------------------------------------------------
% Secuencia determinista de enteros positivos: (i * 7919) mod 1000 + 1.
generar_valor = @(i) mod(i * 7919, 1000) + 1;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
N = 200;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 2 - SUMA DE LOS VALORES PARES\n');
fprintf('========================================================\n');
fprintf('N = %d números positivos\n', N);

% ----------------------------------------------------------------------
% a) Suma de los valores pares
% ----------------------------------------------------------------------
fprintf('\n--- Suma de los valores pares ---\n');

cpu_inicio = cputime;
tic;
total = 0;
cantidad_pares = 0;
for i = 1:N
  % Reemplazar por "x = input('Ingrese el valor a sumar: ')" para el modo interactivo.
  x = generar_valor(i);

  if (x > 0 && mod(x, 2) == 0)
    total = total + x;
    cantidad_pares = cantidad_pares + 1;
  endif
endfor
tiempo = toc;
cpu = cputime - cpu_inicio;

fprintf('Cantidad de valores pares encontrados: %d de %d\n', cantidad_pares, N);
fprintf('Suma de los valores pares = %d\n', total);
fprintf('Tiempo de ejecución: %.6f s (tic/toc), %.6f s de CPU (cputime)\n', tiempo, cpu);

% ----------------------------------------------------------------------
% Verificación
% ----------------------------------------------------------------------
% Contraste: la misma suma se recalcula vectorizada, sin recorrer el lazo.
valores = generar_valor(1:N);
total_verificado = sum(valores(mod(valores, 2) == 0));

fprintf('\n--- Verificación ---\n');
fprintf('Suma por lazo      = %d\n', total);
fprintf('Suma vectorizada   = %d\n', total_verificado);
fprintf('Ambas coinciden: %s\n', mat2str(total == total_verificado));

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('El filtrado por lazo recorre la secuencia una vez con complejidad O(N).\n');
fprintf('Es más costoso que la vectorización pero evita reservar memoria adicional.\n');