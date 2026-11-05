% 02-transito.m - Problema 2: Tránsito vehicular en hora pico (TP 06)
%
% Calcula el número total de vehículos que pasan por un punto de control
% entre las 7:30 y las 9:15 integrando la tasa q(t) [vehículos/min].

clc;

% Tiempos en minutos desde las 7:30 (t = 0)
t = [0, 15, 30, 45, 75, 105]; 
% Tasas en vehículos por minuto
q = [4.5, 6.0, 6.5, 5.0, 4.5, 2.25];

fprintf('========================================================\n');
fprintf('  PROBLEMA 2 - TRÁNSITO VEHICULAR EN HORA PICO\n');
fprintf('========================================================\n');
fprintf('Hora:       7:30   7:45   8:00   8:15   8:45   9:15\n');
fprintf('t (min):    '); fprintf('%6.0f ', t); fprintf('\n');
fprintf('q (veh/min):'); fprintf('%6.2f ', q); fprintf('\n\n');

% ----------------------------------------------------------------------
% a) Integración por Regla del Trapecio
% ----------------------------------------------------------------------
N_veh_trap = 0;
for i = 1:(length(t) - 1)
    dt = t(i+1) - t(i);
    area_trap = (q(i) + q(i+1)) / 2 * dt;
    N_veh_trap = N_veh_trap + area_trap;
    fprintf('Intervalo t=[%3d, %3d] min (dt=%3d): Trapecio = %.2f veh\n', t(i), t(i+1), dt, area_trap);
endfor

fprintf('\nTotal de vehículos (Regla del Trapecio): %.2f vehículos\n', N_veh_trap);

% ----------------------------------------------------------------------
% b) Métodos Combinados (Simpson y Trapecio)
% ----------------------------------------------------------------------
% Tramo 1: t = 0 a 45 min (3 intervalos de dt = 15 min -> Simpson 3/8)
h1 = 15;
N_simpson38 = (3 * h1 / 8) * (q(1) + 3*q(2) + 3*q(3) + q(4));

% Tramo 2: t = 45 a 105 min (2 intervalos de dt = 30 min -> Simpson 1/3 con h = 30)
h2 = 30;
N_simpson13 = (h2 / 3) * (q(4) + 4*q(5) + q(6));

N_veh_combinado = N_simpson38 + N_simpson13;

fprintf('Tramo [0, 45] min (Simpson 3/8): %.2f veh\n', N_simpson38);
fprintf('Tramo [45, 105] min (Simpson 1/3): %.2f veh\n', N_simpson13);
fprintf('Total de vehículos (Métodos Combinados): %.2f vehículos\n', N_veh_combinado);

% ----------------------------------------------------------------------
% Gráfico
% ----------------------------------------------------------------------
figure('Name', 'Problema 2 - Tránsito Vehicular');
plot(t, q, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
title('Tasa de Flujo Vehicular q(t)');
xlabel('Tiempo t (min desde las 7:30)');
ylabel('Tasa q(t) (veh/min)');
legend({'Tasa de vehículos'}, 'Location', 'northeast');
