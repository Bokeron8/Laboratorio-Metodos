% 02-suma-pares.m - Ejercicio 2 de la Guía 1: suma de los valores pares.
%
% Problema: dados 200 números positivos X1, X2, ..., X200, hallar la suma de
% todos los valores pares de la sucesión.
%
% Estructura del problema:
%   a) Recorrer los 200 valores y acumular solo los que son pares.
%   b) Reportar la suma y el tiempo de ejecución.
%
% Modelo matemático: S = sum sobre { i : Xi par } de Xi. El predicado de
% pertenencia es "mod(Xi, 2) == 0", es decir, divisible por 2. El algoritmo es
% de clase O(N): una sola pasada, con una comparación y una posible adición por
% dato. Igual que en el ejercicio 1, no hay forma de evitar recorrer los datos.
%
% Corrección respecto de la versión original: el enunciado dice 200 números y el
% código anterior tenía N = 5 hardcodeado, de modo que no resolvía lo pedido.
%
% Sobre los datos: la versión original los pedía por teclado. Acá se generan con
% una secuencia determinista para poder ejecutar el script no interactivo y que
% el tiempo sea reproducible. La línea marcada se puede reemplazar por
% "x = input(...)" para el modo interactivo.

clc;

% ----------------------------------------------------------------------
% Generador de los datos del problema
% ----------------------------------------------------------------------
% Secuencia determinista de enteros positivos: (i * 7919) mod 1000 + 1.
generar_valor = @(i) mod(i * 7919, 1000) + 1;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Se fija la cantidad de datos en 200.
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

  % Un valor es par si es divisible por 2. El enunciado pide sumar los positivos,
  % así que además se descarta cualquier valor no positivo.
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
% Se recalcula la suma con una expresión vectorizada, que no usa el mismo
% recorrido que el lazo. Si ambos caminos coinciden, el lazo está bien.
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