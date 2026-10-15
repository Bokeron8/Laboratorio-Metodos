% 03-publicidad-utilidad.m - Ejercicio 3 de la Guía 3: iteración y Aitken.
%
% Problema: una compañía gasta A = 200*ln(400/(500 - x)) pesos semanales en
% publicidad para vender x unidades. Las unidades se venden a $5, así que la
% utilidad neta es R(x) = 5x - A. Hay que vender las x que den R(x) = $1000:
%   F(x) = 5x - 200*ln(400/(500 - x)) - 1000 = 0
%
% Reordenando para convertirla en ecuación de punto fijo:
%   5x = 1000 + 200*ln(400/(500 - x))
%   x  = 200 + 40*ln(400/(500 - x))
% es decir g(x) = 200 + 40*ln(400/(500 - x)), con x0 = 200.
%
% El problema pide aplicar el método de iteración Y el mismo método acelerado
% con Aitken, ambos con E < 1e-4, y graficar ambas curvas en un mismo gráfico.
%
% Este script entrega los resultados crudos de cada método (raíz, iteraciones,
% tiempo) y el valor de |g'(x0)|. La comparación entre ambos y las conclusiones
% van en el informe, no acá.
%
% Los algoritmos viven en iteracion.m y aceleracion.m.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Operadores element-wise (./) obligatorios: fplot evalúa vectores.
F = @(x) 5 * x - 200 * log(400 ./ (500 - x)) - 1000;  % raíz a buscar
g = @(x) 200 + 40 * log(400 ./ (500 - x));            % función de iteración

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 3 - PUBLICIDAD Y UTILIDAD NETA\n');
fprintf('  A(x) = 200*ln(400/(500 - x)),  R(x) = 5x - A\n');
fprintf('  Buscar R(x) = 1000\n');
fprintf('========================================================\n');

% Paso para aproximar g' por diferencia central.
h = 1e-4;
dg = @(x) (g(x + h) - g(x - h)) / (2 * h);

fprintf('\n');
x0      = input('Ingrese el valor inicial x0 (el problema propone 200): ');
tol     = input('Ingrese la cota de error a usar (se sugiere 0.0001): ');

% Condición de convergencia del punto fijo simple: |g'(x0)| < 1.
% g'(x) = 40/(500 - x), que en x0 = 200 vale 0.133: converge, pero solo porque
% x0 quedó en el lado izquierdo de x = 500. Cerca de 500 la derivada se dispara
% y el método diverge, así que conviene mostrar el valor antes de correrlo.
g_primo_x0 = dg(x0);
fprintf("\n|g'(x0)| = |%.6f| = %.6f -> %s\n", g_primo_x0, abs(g_primo_x0), ...
        merge(abs(g_primo_x0) < 1, ...
              'punto fijo CONVERGE desde este x0', ...
              'punto fijo DIVERGE desde este x0 (|g''(x0)| >= 1)'));

% ----------------------------------------------------------------------
% Método de iteración simple
% ----------------------------------------------------------------------
fprintf('\n--- a) Método de Iteración (punto fijo simple) ---\n');
tic;
[x_simple, iter_simple, ok_simple] = iteracion(g, x0, tol);
tiempo_simple = toc;

if (ok_simple)
  fprintf('Raíz aproximada: x = %.6f unidades (aprox. %d)\n', x_simple, ceil(x_simple));
  fprintf('Iteraciones: %d | Tiempo: %.6f s | F(raíz) = %.3e\n', ...
          iter_simple, tiempo_simple, F(x_simple));
else
  fprintf('El punto fijo no convergió desde x0 = %.4f: |g''(x0)| >= 1.\n', x0);
  x_simple = NaN;
  iter_simple = NaN;
  tiempo_simple = NaN;
endif

% ----------------------------------------------------------------------
% Método de iteración acelerado con Aitken
% ----------------------------------------------------------------------
fprintf('\n--- b) Método de Iteración con Aceleración de Aitken ---\n');

tic;
[x_aitken, iter_aitken, ok_aitken] = aceleracion(g, x0, tol);
tiempo_aitken = toc;

if (ok_aitken)
  fprintf('Raíz aproximada: x = %.6f unidades (aprox. %d)\n', x_aitken, ceil(x_aitken));
  fprintf('Iteraciones: %d | Tiempo: %.6f s | F(raíz) = %.3e\n', ...
          iter_aitken, tiempo_aitken, F(x_aitken));
else
  fprintf('Aitken no pudo acelerar: se anuló el denominador.\n');
  x_aitken = NaN;
  iter_aitken = NaN;
  tiempo_aitken = NaN;
endif

% ----------------------------------------------------------------------
% Gráfico: y = x contra y = g(x), las dos curvas en la misma figura
% ----------------------------------------------------------------------
figure('Name', 'Ejercicio 3 - Punto fijo');

% Rango centrado en x0, acotado para que se vea bien el punto fijo.
rango = [max(1, x0 - 60), x0 + 60];

% Recta y = x: sus cruces con g son los puntos fijos.
fplot(@(x) x, rango, 'r--', 'LineWidth', 1.5);
hold on;
grid on;

% Curva y = g(x).
fplot(g, rango, 'b-', 'LineWidth', 2);

% Punto fijo encontrado.
if (ok_simple)
  plot(x_simple, x_simple, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
endif

title('Punto Fijo: Intersección entre y = x  e  y = g(x)');
xlabel('x (unidades semanales)');
ylabel('y');
leyenda = {'y = x', 'y = g(x)'};
if (ok_simple)
  leyenda = [leyenda, {sprintf('Punto fijo (%.2f)', x_simple)}];
endif
legend(leyenda, 'Location', 'NorthWest');
hold off;
