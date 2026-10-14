% 01-tanque-esferico.m - Ejercicio 1 de la Guía 3: raíces de una ecuación.
%
% Problema: tanque esférico de radio R = 3 m que debe contener V = 30 m^3.
%   V = pi * h^2 * (3R - h)/3   con h = profundidad del agua en metros.
% Se busca la profundidad h que cumple V = 30, es decir la raíz de
%   f(h) = pi * h^2 * (3R - h)/3 - V = 0.
%
% Estructura de la consigna:
%   a) Evaluación gráfica de las raíces con fplot.
%   b) Separación de todas las raíces con el Método de Tanteo.
%   c) Aproximación con Intervalo Medio e Interpolación Lineal, E < 0.001.
%   d) Comparación de convergencia y tiempo de ejecución entre ambos métodos.
%
% Este script entrega los resultados crudos de cada método (raíz, f(raíz),
% iteraciones y tiempo). La comparación entre ellos y las conclusiones van en
% el informe, no acá.
%
% Los algoritmos viven en archivos aparte (tanteo.m, intervalo_medio.m,
% interpolacion_lineal.m).

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
R = 3;   % radio del tanque en metros
V = 30;  % volumen objetivo en metros cubicos

% f(h) = volumen que hay a profundidad h, menos el volumen buscado.
% Los operadores element-wise (.*, ./) son obligatorios: fplot evalúa vectores.
f = @(h) pi * (h.^2) .* ((3 * R - h) / 3) - V;

% Rango de búsqueda. h va de 0 (vacío) hasta 2R = 6 (lleno hasta el ecuador),
% que es el rango donde la fórmula describe un volumen de agua real. Más allá del
% ecuador el polinomio sigue dando valores, pero ya no son volúmenes posibles.
h_min = 0;
h_max = 2 * R;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 1 - TANQUE ESFÉRICO\n');
fprintf('  V = pi*h^2*(3R - h)/3   con   R = %.1f m,  V = %.1f m^3\n', R, V);
fprintf('========================================================\n');

% ----------------------------------------------------------------------
% a) Evaluación gráfica de las raíces con fplot
% ----------------------------------------------------------------------
figure('Name', 'Ejercicio 1 - Tanque esférico');
fplot(f, [h_min, h_max], 'b-', 'LineWidth', 2);
grid on;
hold on;

% Eje horizontal en y = 0: los cruces con esta recta son las raíces.
plot([h_min, h_max], [0, 0], 'r--', 'LineWidth', 1.5);

title('Evaluación gráfica: f(h) = V(h) - 30');
xlabel('Profundidad h (m)');
ylabel('f(h)');
legend({'f(h)', 'y = 0'}, 'Location', 'northeast');

fprintf('\n--- a) Evaluación gráfica ---\n');
fprintf('f(h) vale %.4f en h = %.1f y %.4f en h = %.1f.\n', ...
        f(h_min), h_min, f(h_max), h_max);

% ----------------------------------------------------------------------
% b) Separación de las raíces con el Método de Tanteo
% ----------------------------------------------------------------------
fprintf('\n--- b) Separación de raíces con Tanteo ---\n');
intervalos = tanteo(f, h_min, h_max);

if (isempty(intervalos))
  fprintf('\nNo se separó ninguna raíz: revise el incremento delta_x.\n');
  return;
endif

fprintf('\nSe separaron %d raíz/raíces.\n', rows(intervalos));

% ----------------------------------------------------------------------
% c) Aproximación con Intervalo Medio e Interpolación Lineal
% ----------------------------------------------------------------------
tol = input(sprintf('\nIngrese la cota de error a usar (la consigna pide 0.001): '));

for k = 1:rows(intervalos)
  a = intervalos(k, 1);
  b = intervalos(k, 2);

  fprintf('\n=========== Intervalo %d: [%.4f, %.4f] ===========\n', k, a, b);

  % --- Método de Intervalo Medio (bisección) ---
  tic;
  [raiz_im, iter_im] = intervalo_medio(f, a, b, tol);
  tiempo_im = toc;

  fprintf('\nMétodo de Intervalo Medio:\n');
  fprintf('  raíz = %.6f m | f(raíz) = %.3e | iteraciones = %d | tiempo = %.6f s\n', ...
          raiz_im, f(raiz_im), iter_im, tiempo_im);

  % --- Método de Interpolación Lineal (falsa posición) ---
  tic;
  [raiz_il, iter_il, tabla_il] = interpolacion_lineal(f, a, b, tol);
  tiempo_il = toc;

  fprintf('\nMétodo de Interpolación Lineal:\n');
  fprintf('  %-6s %-12s %-12s %-12s\n', 'Iter', 'a', 'b', 'c');
  for i = 1:rows(tabla_il)
    fprintf('  %-6d %-12.6f %-12.6f %-12.6f\n', tabla_il(i, 1), tabla_il(i, 2), ...
            tabla_il(i, 3), tabla_il(i, 4));
  endfor
  fprintf('  raíz = %.6f m | f(raíz) = %.3e | iteraciones = %d | tiempo = %.6f s\n', ...
          raiz_il, f(raiz_il), iter_il, tiempo_il);

  % Se marcan ambas raíces sobre el gráfico del punto a.
  plot(raiz_im, f(raiz_im), 'go', 'MarkerSize', 8, 'LineWidth', 2);
  plot(raiz_il, f(raiz_il), 'ms', 'MarkerSize', 8, 'LineWidth', 2);
endfor

hold off;

