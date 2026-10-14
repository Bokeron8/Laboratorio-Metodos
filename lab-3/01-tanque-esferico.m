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
% Los algoritmos viven en archivos aparte (tanteo.m, intervalo_medio.m,
% interpolacion_lineal.m). Este script solo arma el problema y compara.

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

% El volumen crece hasta h = 2R/3 y después decrece, así que el tanque puede
% contener 30 m^3 solo si ese máximo los supera. Si no alcanza, hay una sola raíz
% (el tanque se llena antes de llegar a ese volumen y nunca lo alcanza).
h_maximo = 2 * R / 3;
vol_maximo = pi * (h_maximo^2) * ((3 * R - h_maximo) / 3);
fprintf('El volumen es máximo en h = 2R/3 = %.4f m, donde vale %.4f m^3.\n', ...
        h_maximo, vol_maximo);
fprintf('Objetivo V = %.4f m^3 -> ', V);
if (vol_maximo >= V)
  fprintf('el objetivo es alcanzable, hay DOS raíces en el rango físico.\n');
else
  fprintf('el objetivo SUPERA al máximo del tanque, hay UNA sola raíz física.\n');
  fprintf(['Ojo con el enunciado: el barrido se limita a [0, %.0f] porque más allá\n' ...
           '  del ecuador (h = 2R) la fórmula ya no describe un volumen de agua.\n'], h_max);

  % Para dejar en claro dónde está la raíz "extraña": el corchete es directo,
  % porque f(2R) > 0 y f(3R) = -V < 0. No hace falta volver a barrer con Tanteo.
  if (f(h_max) * f(3 * R) < 0)
    raiz_extra = intervalo_medio(f, h_max, 3 * R, 1e-4);
    fprintf(['  Como polinomio, f tiene otra raíz cerca de h = %.4f m, pero cae\n' ...
             '  fuera del rango físico: %.1f m de "columna de agua" en un tanque\n' ...
             '  de %.0f m de radio es imposible.\n'], ...
            raiz_extra, raiz_extra, R);
  endif
endif

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

% Cada fila guarda los resultados de un intervalo para la comparación del punto d:
%   | intervalo | raíz IM | iter IM | tiempo IM | raíz IL | iter IL | tiempo IL |
resultados = zeros(rows(intervalos), 7);

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

  resultados(k, :) = [k, raiz_im, iter_im, tiempo_im, raiz_il, iter_il, tiempo_il];
endfor

% ----------------------------------------------------------------------
% d) Comparación de convergencia y tiempo de ejecución
% ----------------------------------------------------------------------
fprintf('\n================== COMPARACIÓN (d) ==================\n');
fprintf('%-14s %-16s %-8s %-16s %-8s\n', ...
        'Intervalo', 'Raíz Int. Medio', 'Iter', 'Raíz Interp. Lineal', 'Iter');
for k = 1:rows(resultados)
  fprintf('[%.2f, %.2f]%s%-16.6f %-8d %-16.6f %-8d\n', ...
          intervalos(k, 1), intervalos(k, 2), repmat(' ', 1, 3), ...
          resultados(k, 2), resultados(k, 3), resultados(k, 5), resultados(k, 6));
endfor

fprintf('\nTiempo de ejecución con tol = %g:\n', tol);
for k = 1:rows(resultados)
  fprintf('  Intervalo %d: Intervalo Medio %.6f s | Interpolación Lineal %.6f s\n', ...
          k, resultados(k, 4), resultados(k, 7));
endfor

% Reflexión: el cálculo real, no una conclusión escrita a mano.
fprintf('\n--- Conclusiones ---\n');
dif_raiz = abs(resultados(:, 2) - resultados(:, 5));
fprintf('Diferencia entre las raíces de ambos métodos: %s\n', ...
        strjoin(arrayfun(@(d) sprintf('%.2e', d), dif_raiz, 'UniformOutput', false), ', '));
if (all(resultados(:, 3) <= resultados(:, 6)))
  fprintf('Intervalo Medio necesitó menos o igual iteraciones en todos los intervalos.\n');
else
  fprintf('Interpolación Lineal necesitó menos iteraciones en al menos un intervalo.\n');
endif
fprintf('Ojo: comparar solo iteraciones no alcanza. Bisección parte el intervalo a la mitad\n');
fprintf('y garantiza (b-a)/2 <= tol sin importar qué tan extraña sea f. Falsa posición da\n');
fprintf('pasos más grandes, pero puede quedar pegada en un extremo si f es muy curva.\n');

hold off;
