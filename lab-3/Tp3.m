% tp3.m
clc;

R = 3;
V = 30;
a = 0;
b = 10;
inc = input('Ingrese el valor del incremento delta_h (ej. 0.5 o 0.1): ');
f = @(h) pi * (h.^2) .* ((3*R - h)/3) - V;

% Graficación de la curva principal
figure('Name', 'Evaluación Gráfica del Tanque Esférico');
fplot(f, [0, 10], 'b-', 'LineWidth', 2);
grid on;
hold on;

% Eje horizontal en y = 0
plot([0, 10], [0, 0], 'r--', 'LineWidth', 1.5);

% Búsqueda de intervalos y cálculo de raíces
intervalos = tanteo_old(f, a, b, inc);
num_intervalos = size(intervalos, 1);

for i = 1:num_intervalos
  % Extraer los extremos del intervalo actual
  x_inf = intervalos(i, 1);
  x_sup = intervalos(i, 2);
  
  % Corrección: era x_sup (no x_su[])
  [raiz_aproximada, iter, inferior, superior] = intervalo_medio(f, x_inf, x_sup);
  y_raiz = f(raiz_aproximada);
  
  % Graficar cada punto encontrado
  plot(raiz_aproximada, y_raiz, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
  
  % Texto junto a cada punto en el gráfico
  text(raiz_aproximada, y_raiz, sprintf('  h_%.0f = %.3f', i, raiz_aproximada), ...
       'VerticalAlignment', 'bottom', 'FontSize', 9);
  
  printf('\n--- Intervalo %d: [%.4f, %.4f] ---\n', i, x_inf, x_sup);
  printf('Raíz aproximada: %.4f, y: %.4f\n', raiz_aproximada, y_raiz);
  printf('Cantidad de iteraciones: %d\n', iter);
end

title('Evaluación gráfica: f(h) = V(h) - 30');
xlabel('Profundidad h (m)');
ylabel('f(h)');
legend('f(h)', 'f(h) = 0', 'Raíces aproximadas', 'Location', 'northeast');

hold off;
pause();