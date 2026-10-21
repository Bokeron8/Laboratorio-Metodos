% 02-punto-equilibrio-impresoras.m - Ejercicio 2 de la Guía 3: Newton-Raphson.
%
% Utilidad total de un fabricante de impresoras, en pesos:
%   P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372
% Los puntos de equilibrio son las raíces de P(x) = 0. Se grafican con fplot,
% se separan con Tanteo y se aproximan con Newton-Raphson hasta E < 1e-3,
% eligiendo x0 según las condiciones de convergencia.

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

% Separación de las raíces con Tanteo sobre el rango graficado.
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
  % Se necesitan las tres para que Newton-Raphson converja hacia la raíz de [a, b]:
  %   1. F(a)*F(b) < 0            (Bolzano: hay una raíz adentro).
  %   2. F'(x) != 0 en [a, b]      (se puede dividir por la derivada).
  %   3. F''(x) no cambia de signo (la raíz es simple, la tangente no oscila).
  fprintf('\nAnálisis de las condiciones de Fourier:\n');

  fa = F(a);
  fb = F(b);
  fprintf('  1. F(a)*F(b) = %.4f -> %s\n', fa * fb, ...
          merge(fa * fb < 0, 'cambio de signo: la raíz está en el intervalo', ...
                'SIN cambio de signo: no hay raíz garantizada'));

  % F' muestreada sobre el intervalo para ver si se anula.
  malla = linspace(a, b, 100);
  df_malla = dF(malla);
  derivada_nula = any(abs(df_malla) < 1e-8);
  fprintf('  2. F''(x) en [%.2f, %.2f]: min = %.4f, max = %.4f -> %s\n', ...
          a, b, min(df_malla), max(df_malla), ...
          merge(derivada_nula, 'F'' SE ANULA: no se puede dividir', ...
                'F'' no se anula: se puede dividir'));

  % F'' muestreada para ver si cambia de signo en [a, b].
  d2f_malla = d2F(malla);
  d2f_cambio_signo = (min(d2f_malla) < 0 && max(d2f_malla) > 0);
  fprintf('  3. F''''(x) en [%.2f, %.2f]: min = %.4f, max = %.4f -> %s\n', ...
          a, b, min(d2f_malla), max(d2f_malla), ...
          merge(d2f_cambio_signo, 'CAMBIA de signo: no se cumple', ...
                'no cambia de signo: se cumple'));

  % --- Elección de x0 ---
  % Se arranca en el extremo donde F(x0)*F''(x0) > 0: ahí la tangente apunta
  % hacia la raíz y la iteración no se escapa del intervalo.
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
