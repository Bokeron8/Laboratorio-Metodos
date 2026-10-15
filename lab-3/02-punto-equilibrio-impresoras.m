% 02-punto-equilibrio-impresoras.m - Ejercicio 2 de la Guía 3: Newton-Raphson.
%
% Problema: un fabricante de impresoras tiene como utilidad total (en pesos)
%   P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372
% Se pide el punto de equilibrio, es decir las raíces de
%   F(x) = P(x) = 0.
% Estructura del problema:
%   a) Hallar las raíces en forma gráfica (fplot) y separarlas con Tanteo.
%   b) Aproximar los dos puntos con Newton-Raphson y E < 1e-3, analizando antes
%      las condiciones de convergencia en los intervalos iniciales.
%
% El enunciado propone los intervalos [24; 26] y [250; 252]. Tanteo los confirma.
%
% Este script entrega los resultados crudos (raíz, iteraciones, tiempo) y el
% estado de cada condición de Fourier. La comparación entre intervalos y las
% conclusiones van en el informe, no acá.
%
% Los algoritmos viven en tanteo.m y newton_raphson.m.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Operadores element-wise (.*, .^) obligatorios: fplot evalúa vectores.
F = @(x) 8 * x + 0.3 * (x.^2) - 0.0013 * (x.^3) - 372;

% Rango de graficado: alcanza para ver las dos raíces y el máximo.
x_min = 0;
x_max = 300;

% Paso para aproximar derivadas por diferencias finitas.
h = 1e-4;
dF  = @(x) (F(x + h) - F(x - h)) / (2 * h);                 % F'(x)  por diferencia central
d2F = @(x) (F(x + h) - 2 * F(x) + F(x - h)) / (h ^ 2);      % F''(x) por diferencias centradas

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 2 - PUNTO DE EQUILIBRIO DE IMPRESORAS\n');
fprintf('  P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372\n');
fprintf('========================================================\n');

% ----------------------------------------------------------------------
% a) Raíces en forma gráfica
% ----------------------------------------------------------------------
figure('Name', 'Ejercicio 2 - Punto de equilibrio');
fplot(F, [x_min, x_max], 'b-', 'LineWidth', 2);
grid on;
hold on;

% Eje horizontal en y = 0: los cruces son los puntos de equilibrio.
plot([x_min, x_max], [0, 0], 'r--', 'LineWidth', 1.5);

title('Punto de equilibrio: F(x) = P(x) = 0');
xlabel('x (impresoras por mes)');
ylabel('P(x) (pesos)');
legend({'P(x)', 'y = 0'}, 'Location', 'northeast');

fprintf('\n--- a) Evaluación gráfica ---\n');
fprintf('P(0) = %.2f pesos.\n', F(0));
fprintf('P(300) = %.2f pesos.\n', F(300));

% Separación de las raíces con Tanteo. El incremento se pide por teclado:
% con uno chico se pueden separar las dos raíces en un solo barrido.
fprintf('\n--- Separación de raíces con Tanteo ---\n');
intervalos = tanteo(F, x_min, x_max);

if (isempty(intervalos))
  fprintf('\nNo se separó ninguna raíz: revise el incremento delta_x.\n');
  return;
endif

fprintf('\nSe separaron %d punto(s) de equilibrio.\n', rows(intervalos));
fprintf('Compare con los intervalos del problema: [24, 26] y [250, 252].\n');

% ----------------------------------------------------------------------
% b) Newton-Raphson con análisis previo de las condiciones de Fourier
% ----------------------------------------------------------------------
tol = input(sprintf('\nIngrese la cota de error a usar (se sugiere 0.001): '));

for k = 1:rows(intervalos)  a = intervalos(k, 1);
  b = intervalos(k, 2);

  fprintf('\n============ Intervalo %d: [%.2f, %.2f] ============\n', k, a, b);

  % --- Condiciones de Fourier ---
  % Son tres, y las tres tienen que cumplirse para que Newton-Raphson converja
  % desde x0 hacia la raíz que hay dentro de [a, b]:
  %   1. F(a)*F(b) < 0            -> la raíz está dentro del intervalo (Bolzano).
  %   2. F'(x) != 0 en todo [a, b] -> se puede dividir por la derivada.
  %   3. F''(x) no cambia de signo  -> la función es cóncava o convexa en el
  %                                   intervalo, así que la raíz es simple.
  fprintf('\nAnálisis de las condiciones de Fourier:\n');

  fa = F(a);
  fb = F(b);
  fprintf('  1. F(a)*F(b) = %.4f -> %s\n', fa * fb, ...
          merge(fa * fb < 0, 'cambio de signo: la raíz está en el intervalo', ...
                'SIN cambio de signo: no hay raíz garantizada'));

  % F' se muestrea en el intervalo para verificar que no se anula.
  malla = linspace(a, b, 100);
  df_malla = dF(malla);
  derivada_nula = any(abs(df_malla) < 1e-8);
  fprintf('  2. F''(x) en [%.2f, %.2f]: min = %.4f, max = %.4f -> %s\n', ...
          a, b, min(df_malla), max(df_malla), ...
          merge(derivada_nula, 'F'' SE ANULA: no se puede dividir', ...
                'F'' no se anula: se puede dividir'));

  % F'' también se muestrea para verificar que no cambia de signo.
  d2f_malla = d2F(malla);
  d2f_cambio_signo = (min(d2f_malla) < 0 && max(d2f_malla) > 0);
  fprintf('  3. F''''(x) en [%.2f, %.2f]: min = %.4f, max = %.4f -> %s\n', ...
          a, b, min(d2f_malla), max(d2f_malla), ...
          merge(d2f_cambio_signo, 'CAMBIA de signo: no se cumple', ...
                'no cambia de signo: se cumple'));

  % --- Elección de x0 ---
  % La condición de Fourier que elige dónde arrancar es F(x0)*F''(x0) > 0:
  % se arranca en el extremo donde la función está más "hacia afuera" de la
  % raíz, para que las tangentes no empujen la iteración al lado equivocado.
  if (fa * d2F(a) > 0)
    x0 = a;
  else
    x0 = b;
  endif
  fprintf('\nF(x0)*F''''(x0) > 0 en x0 = %.4f (F = %.4f, F'''' = %.4f) -> se arranca en %s\n\n', ...
          x0, F(x0), d2F(x0), merge(x0 == a, 'a', 'b'));

  % --- Newton-Raphson ---
  tic;
  [raiz, iter, convergio] = newton_raphson(F, x0, tol);
  tiempo = toc;

  if (!convergio)
    fprintf('Newton-Raphson no convergió desde x0 = %.4f.\n', x0);
    continue;
  endif

  fprintf('>>> Punto de equilibrio: x = %.4f impresoras (aprox. %d).\n', raiz, ceil(raiz));
  fprintf('>>> Iteraciones: %d | Tiempo: %.6f s | F(raíz) = %.3e\n', iter, tiempo, F(raiz));

  % Se marca la raíz sobre el gráfico del punto a.
  plot(raiz, 0, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
  text(raiz, 0, sprintf('  x_%.0f = %.2f', k, raiz), ...
       'VerticalAlignment', 'bottom', 'FontSize', 9);
endfor

hold off;
