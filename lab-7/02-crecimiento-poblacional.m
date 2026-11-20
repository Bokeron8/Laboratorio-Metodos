% 02-crecimiento-poblacional.m
% =========================================================================
% SCRIPT: Ejercicio 2 - Crecimiento de una población
%   P'(t) = gamma * P - tau * P^2,  P(0) = P0
%   Solución exacta:
%       P(t) = gamma / ( tau + (gamma/P0 - tau) * e^(-gamma*t) )
%   Datos del enunciado: gamma = 3, tau = 0,1, P0 = 5, intervalo (0; 2)
% =========================================================================

clear; clc;

printf("=== EJERCICIO 2: Crecimiento de una población ===\n\n");
printf("Ecuación diferencial: P'(t) = gamma*P - tau*P^2\n");
printf("Parámetros del enunciado: gamma = 3, tau = 0.1, P(0) = 5\n");
printf("Intervalo: (0; 2)\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

gamma = leer_escalar("gamma [3]: ", 3);
tau   = leer_escalar("tau [0.1]: ", 0.1);
P0    = leer_escalar("P(0) [5]: ", 5);
xf    = leer_escalar("Extremo final del intervalo [2]: ", 2);
h1    = leer_escalar("Primer paso h [0.5]: ", 0.5);
h2    = leer_escalar("Segundo paso h [0.25]: ", 0.25);

f = @(t, P) gamma * P - tau * P^2;
exacta = @(t) gamma ./ (tau + (gamma / P0 - tau) * exp(-gamma * t));

% -------------------------------------------------------------------------
% a) Euler con los dos pasos
% -------------------------------------------------------------------------
[t_1, P_1] = euler(f, 0, P0, h1, xf);
[t_2, P_2] = euler(f, 0, P0, h2, xf);

printf("\n--- a) Método de Euler con h = %g ---\n", h1);
printf("%10s %14s %14s %14s\n", "t", "P(t)", "exacta", "error");
for i = 1:length(t_1)
    printf("%10.4f %14.6f %14.6f %14.6e\n", t_1(i), P_1(i), exacta(t_1(i)), ...
           P_1(i) - exacta(t_1(i)));
end

printf("\n--- a) Método de Euler con h = %g ---\n", h2);
printf("%10s %14s %14s %14s\n", "t", "P(t)", "exacta", "error");
for i = 1:length(t_2)
    printf("%10.4f %14.6f %14.6f %14.6e\n", t_2(i), P_2(i), exacta(t_2(i)), ...
           P_2(i) - exacta(t_2(i)));
end

% -------------------------------------------------------------------------
% b) Comparación con la solución exacta
% -------------------------------------------------------------------------
printf("\n--- b) Comparación: error máximo en el intervalo ---\n");
printf("h = %-6g  error máximo = %.6e\n", h1, max(abs(P_1 - exacta(t_1))));
printf("h = %-6g  error máximo = %.6e\n", h2, max(abs(P_2 - exacta(t_2))));
printf("\nAl reducir el paso a la mitad, el error de Euler también se reduce\n");
printf("a la mitad: el método es de primer orden.\n");

% -------------------------------------------------------------------------
% Gráfico: solución numérica contra la exacta, y error
% -------------------------------------------------------------------------
t_fino = linspace(0, xf, 200);

figure;

subplot(1, 2, 1);
plot(t_fino, exacta(t_fino), "k-", "linewidth", 1.5);
hold on;
plot(t_1, P_1, "o-", "markersize", 5);
plot(t_2, P_2, "s-", "markersize", 5);
hold off;
grid on;
xlabel("t (tiempo)");
ylabel("P(t) (población)");
title("Solución numérica vs exacta");
legend("Exacta", sprintf("Euler h = %g", h1), sprintf("Euler h = %g", h2), ...
       "location", "southeast");

subplot(1, 2, 2);
plot(t_1, abs(P_1 - exacta(t_1)), "o-", "markersize", 5);
hold on;
plot(t_2, abs(P_2 - exacta(t_2)), "s-", "markersize", 5);
hold off;
grid on;
xlabel("t (tiempo)");
ylabel("|error|");
title("Error absoluto");
legend(sprintf("h = %g", h1), sprintf("h = %g", h2), "location", "northwest");
