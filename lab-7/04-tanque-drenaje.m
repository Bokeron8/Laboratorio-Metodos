% 04-tanque-drenaje.m
% =========================================================================
% SCRIPT: Ejercicio complementario - Vaciado de un tanque
%   dy/dt = -k * sqrt(y),  y(0) = 3 m,  k = 0,06,  h = 0,5 min
%   Solución exacta (mientras queda agua):
%       y(t) = ( sqrt(y0) - k*t/2 )^2
%   El tanque se vacía en t = 2*sqrt(y0)/k.
% =========================================================================

clear; clc;

printf("=== EJERCICIO 4 (complementario): Vaciado de un tanque ===\n\n");
printf("Ecuación diferencial: dy/dt = -k*sqrt(y)\n");
printf("Datos del enunciado: k = 0.06, y(0) = 3 m, h = 0.5 min\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

k  = leer_escalar("k [0.06]: ", 0.06);
y0 = leer_escalar("Nivel inicial y(0) [3]: ", 3);
h  = leer_escalar("Paso h en minutos [0.5]: ", 0.5);

% Se integra un poco más allá del vaciado para poder ubicar el cruce por cero.
% max(y, 0) evita que el radical reciba valores negativos cuando el tanque ya
% está vacío.
tope = 60;
f = @(t, y) -k * sqrt(max(y, 0));
exacta = @(t) max(0, sqrt(y0) - k * t / 2).^2;

[t, y] = euler(f, 0, y0, h, tope);

% -------------------------------------------------------------------------
% a) Método de Euler
% -------------------------------------------------------------------------
printf("\n--- a) Método de Euler con h = %g min ---\n", h);
printf("%10s %14s %14s\n", "t (min)", "y (m)", "exacta (m)");
for i = 1:length(t)
    if mod(i - 1, 10) == 0
        printf("%10.4f %14.6f %14.6f\n", t(i), y(i), exacta(t(i)));
    end
end

% -------------------------------------------------------------------------
% Instante en que el tanque queda vacío
% -------------------------------------------------------------------------
cruce = find(y <= 0, 1);
if isempty(cruce)
    error("Con este paso el tanque no se vació dentro de %g minutos.", tope);
end

% Interpolación lineal entre el último nivel positivo y el primero no positivo
t_vacia = t(cruce - 1) + (0 - y(cruce - 1)) * h / (y(cruce) - y(cruce - 1));
t_exacta = 2 * sqrt(y0) / k;

printf("\n--- Tiempo de vaciado ---\n");
printf("Con Euler (h = %g):      %.4f min\n", h, t_vacia);
printf("Solución exacta:         %.4f min\n", t_exacta);
printf("Error absoluto:          %.4f min\n", abs(t_vacia - t_exacta));
printf("\nEl último nivel positivo calculado es y = %.6f m en t = %.2f min;\n", ...
       y(cruce - 1), t(cruce - 1));
printf("el cruce por cero se estima interpolando linealmente ese paso.\n");

% -------------------------------------------------------------------------
% Gráfico
% -------------------------------------------------------------------------
t_fino = linspace(0, tope, 300);

figure;
plot(t_fino, exacta(t_fino), "k-", "linewidth", 1.5);
hold on;
plot(t, y, "o-", "markersize", 3);
plot(t_vacia, 0, "r*", "markersize", 10);
hold off;
grid on;
xlim([0, tope]);
ylim([-0.2, y0 + 0.2]);
xlabel("t (minutos)");
ylabel("y (metros)");
title(sprintf("Vaciado del tanque: Euler h = %g vs exacta", h));
legend("Exacta", "Euler", "Vaciado estimado", "location", "northeast");
