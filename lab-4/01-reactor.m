% 01-reactor.m - Problema 1: Balance de masa en un reactor (TP 06)
%
% Calcula la masa total que sale de un reactor utilizando integracion numerica
% sobre datos tabulados con espaciamientos variables:
%   M = integral_{t1}^{t2} Q(t) * c(t) dt

clc;

% Datos del problema
t = [0, 10, 20, 30, 35, 40, 45, 50]; % minutos
Q = [4, 4.8, 5.2, 5.0, 4.6, 4.3, 4.3, 5.0]; % m^3/min
C = [10, 35, 55, 52, 40, 37, 32, 34]; % mg/m^3

% Flujo de masa f(t) = Q(t) * C(t) [mg/min]
f = Q .* C;

fprintf('========================================================\n');
fprintf('  PROBLEMA 1 - BALANCE DE MASA EN UN REACTOR\n');
fprintf('========================================================\n');
fprintf('t (min):     '); fprintf('%6.1f ', t); fprintf('\n');
fprintf('Q (m3/min):  '); fprintf('%6.1f ', Q); fprintf('\n');
fprintf('C (mg/m3):   '); fprintf('%6.1f ', C); fprintf('\n');
fprintf('f(t)=Q*C:    '); fprintf('%6.1f ', f); fprintf('\n\n');

% ----------------------------------------------------------------------
% a) Integracion por la Regla del Trapecio (aplicada por intervalos variables)
% ----------------------------------------------------------------------
M_trap = 0;
for i = 1:(length(t) - 1)
    dt = t(i+1) - t(i);
    area_trap = (f(i) + f(i+1)) / 2 * dt;
    M_trap = M_trap + area_trap;
    fprintf('Intervalo [%d, %d] min (dt = %d): Trapecio = %.2f\n', t(i), t(i+1), dt, area_trap);
endfor

fprintf('\nMasa total (Regla del Trapecio): %.4f mg\n', M_trap);

% ----------------------------------------------------------------------
% b) Combinacion de metodos (Simpson 3/8 y 1/3 + Trapecio)
% ----------------------------------------------------------------------
h1 = 10;
M_simpson38 = (3 * h1 / 8) * (f(1) + 3*f(2) + 3*f(3) + f(4));

h2 = 5;
M_simpson13_1 = (h2 / 3) * (f(4) + 4*f(5) + f(6));
M_simpson13_2 = (h2 / 3) * (f(6) + 4*f(7) + f(8));

M_combinado = M_simpson38 + M_simpson13_1 + M_simpson13_2;

fprintf('\nMasa total (Metodos Combinados): %.4f mg\n', M_combinado);

% ----------------------------------------------------------------------
% Grafico
% ----------------------------------------------------------------------
figure('Name', 'Problema 1 - Balance de Masa en Reactor');
plot(t, f, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
title('Flujo de Masa f(t) = Q(t) * C(t)');
xlabel('Tiempo t (min)');
ylabel('f(t) (mg/min)');
legend({'f(t) = Q * C'}, 'Location', 'northeast');
