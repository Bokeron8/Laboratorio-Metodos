% 03-terreno.m - Problema 3: Cálculo de área de un terreno (TP 06)
%
% Calcula el área de una parcela de terreno delimitada por un río y bordes rectos
% utilizando mediciones de offsets (desplazamientos) transversales a lo largo de una línea base.

clc;

% Posiciones sobre la línea base (m) y desplazamientos (offsets y en metros)
x = [0, 10, 20, 30, 40, 50, 60];
y = [0, 1.5, 3.2, 4.8, 5.5, 4.0, 2.1];
h = x(2) - x(1); % espaciamiento constante

fprintf('========================================================\n');
fprintf('  PROBLEMA 3 - CÁLCULO DE ÁREA DE TERRENO\n');
fprintf('========================================================\n');
fprintf('x (m): '); fprintf('%6.1f ', x); fprintf('\n');
fprintf('y (m): '); fprintf('%6.1f ', y); fprintf('\n');
fprintf('Espaciamiento h = %.1f m\n\n', h);

% ----------------------------------------------------------------------
% a) Regla del Trapecio
% ----------------------------------------------------------------------
Area_trap = (h / 2) * (y(1) + 2*sum(y(2:end-1)) + y(end));
fprintf('Área (Regla del Trapecio): %.4f m^2\n', Area_trap);

% ----------------------------------------------------------------------
% b) Regla de Simpson 1/3 (requiere número par de subintervalos -> 6 subintervalos / 7 puntos)
% ----------------------------------------------------------------------
% y tiene 7 puntos (6 subintervalos, que es par)
Area_simpson13 = (h / 3) * (y(1) + 4*sum(y(2:2:end-1)) + 2*sum(y(3:2:end-2)) + y(end));
fprintf('Área (Regla de Simpson 1/3): %.4f m^2\n', Area_simpson13);

% ----------------------------------------------------------------------
% c) Regla de Simpson 3/8 (para 3 subintervalos o combinada)
% ----------------------------------------------------------------------
% Primeros 4 puntos (3 subintervalos): Simpson 3/8
Area_simpson38 = (3 * h / 8) * (y(1) + 3*y(2) + 3*y(3) + y(4));
% Últimos 4 puntos (3 subintervalos): Simpson 3/8
Area_simpson38_2 = (3 * h / 8) * (y(4) + 3*y(5) + 3*y(6) + y(7));
Area_simpson38_total = Area_simpson38 + Area_simpson38_2;
fprintf('Área (Regla de Simpson 3/8 combinada): %.4f m^2\n', Area_simpson38_total);

% ----------------------------------------------------------------------
% Gráfico
% ----------------------------------------------------------------------
figure('Name', 'Problema 3 - Área de Terreno');
plot(x, y, 'go-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
title('Perfil del Terreno (Offsets y vs x)');
xlabel('Distancia en línea base x (m)');
ylabel('Desplazamiento y (m)');
legend({'Límite irregular y(x)'}, 'Location', 'northeast');
