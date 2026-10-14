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
% La consigna pide aplicar el método de iteración Y el mismo método acelerado
% con Aitken, ambos con E < 1e-4, y graficar ambas curvas en un mismo gráfico.
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
x0      = input('Ingrese el valor inicial x0 (la consigna propone 200): ');
tol     = input('Ingrese la cota de error a usar (la consigna pide 0.0001): ');

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
% Método de iteración acelerado con Aitken (Steffensen)
% ----------------------------------------------------------------------
fprintf('\n--- b) Método de Iteración con Aceleración de Aitken ---\n');
fprintf('En cada paso se evalúa g dos veces y se extrapola:\n');
fprintf('  x1 = g(x),  x2 = g(x1),  x_acel = x - (x1 - x)^2 / (x2 - 2*x1 + x)\n\n');

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

% ----------------------------------------------------------------------
% Comparación
% ----------------------------------------------------------------------
fprintf('\n================== COMPARACIÓN ==================\n');
fprintf('%-32s %-16s %-10s %-12s\n', 'Método', 'Raíz', 'Iteraciones', 'Tiempo (s)');
fprintf('%-32s %-16.6f %-10d %-12.6f\n', 'Iteración simple', ...
        x_simple, iter_simple, tiempo_simple);
fprintf('%-32s %-16.6f %-10d %-12.6f\n', 'Iteración con Aitken', ...
        x_aitken, iter_aitken, tiempo_aitken);

fprintf('\n--- Conclusiones ---\n');
if (ok_simple && ok_aitken)
  fprintf('Diferencia entre ambas raíces: %.3e\n', abs(x_simple - x_aitken));
  if (iter_simple > 0)
    fprintf('Aitken necesitó %.2f veces menos iteraciones (%d contra %d).\n', ...
            iter_simple / iter_aitken, iter_simple, iter_aitken);
  endif
endif
fprintf(['Steffensen/Aitken es cuadrático porque corrige a mano el error lineal de\n' ...
         'la iteración: en vez de dar un paso g(x) - x y repetir, extrapola usando\n' ...
         'TRES valores. Cuesta el doble de evaluaciones de g por paso, pero como la\n' ...
         'convergencia es lineal en el punto fijo simple y cuadrática en Aitken, el\n' ...
         'número total de evaluaciones termina siendo menor. El detalle es que solo\n' ...
         'funciona si g es "regular" cerca de la raíz: si el denominador x2-2*x1+x\n' ...
         'se acerca a cero, la aceleración se desarma.\n']);
if (ok_aitken)
  fprintf(['Ojo con el gráfico: y = g(x) tiene pendiente g''(x) = 40/(500 - x) en la\n' ...
           'raíz. Como vale %.4f, es una pendiente SUAVE: por eso la intersección con\n' ...
           'y = x es transversal y el punto fijo es estable. Si el problema tuviera\n' ...
           'una pendiente más empinada, la curva cruzaría la recta de lado y el punto\n' ...
           'fijo sería inestable, que es justo lo que hace divergir la iteración.\n'], ...
          dg(x_aitken));
else
  fprintf('Sin raíz no hay gráfico del punto fijo que comentar.\n');
endif
