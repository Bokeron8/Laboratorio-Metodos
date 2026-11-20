% 06-milne-edo-lineal.m
% =========================================================================
% SCRIPT: Ejercicio 6 - Euler modificado para el arranque y Milne después
%   y' = 3x + 3y,  y(0) = 1,  intervalo (0; 0,3)
%   Solución exacta: y = 4/3 * e^(3x) - x - 1/3
% =========================================================================

clear; clc;

printf("=== EJERCICIO 6: Euler modificado y Milne ===\n\n");
printf("Ecuación diferencial: y' = 3x + 3y,  y(0) = 1\n");
printf("Intervalo: (0; 0,3)\n");
printf("Solución exacta: y = 4/3 * e^(3x) - x - 1/3\n\n");
printf("Presione Enter para usar los valores del enunciado.\n");

f = @(x, y) 3 * x + 3 * y;
exacta = @(x) (4 / 3) * exp(3 * x) - x - 1 / 3;

xf = leer_escalar("Extremo final del intervalo [0.3]: ", 0.3);
h1 = leer_escalar("Primer paso h [0.1]: ", 0.1);
h2 = leer_escalar("Segundo paso h [0.05]: ", 0.05);
E  = leer_escalar("Tolerancia del corrector E [0.001]: ", 0.001);

% -------------------------------------------------------------------------
% a) Método modificado de Euler para hallar los valores iniciales
% -------------------------------------------------------------------------
[x_1, y_1] = euler_modificado(f, 0, 1, h1, xf, E);
[x_2, y_2] = euler_modificado(f, 0, 1, h2, xf, E);

printf("\n--- a) Euler modificado con h = %g ---\n", h1);
printf("%10s %16s %16s %14s\n", "x", "y", "exacta", "error");
for i = 1:length(x_1)
    printf("%10.4f %16.8f %16.8f %14.6e\n", x_1(i), y_1(i), exacta(x_1(i)), ...
           y_1(i) - exacta(x_1(i)));
end

printf("\n--- a) Euler modificado con h = %g ---\n", h2);
printf("%10s %16s %16s %14s\n", "x", "y", "exacta", "error");
for i = 1:length(x_2)
    printf("%10.4f %16.8f %16.8f %14.6e\n", x_2(i), y_2(i), exacta(x_2(i)), ...
           y_2(i) - exacta(x_2(i)));
end

printf("\nNota: con h = %g los cuatro primeros valores llegan hasta x = %g y\n", ...
       h1, x_1(4));
printf("Milne sólo podría calcular fuera del intervalo pedido. Por eso el\n");
printf("arranque de Milne se toma del cálculo con h = %g.\n", h2);

% -------------------------------------------------------------------------
% b) Milne con los cuatro primeros valores de h = 0,05
% -------------------------------------------------------------------------
[x_m, y_m, it_m] = milne(f, x_2(1:4), y_2(1:4), h2, xf, E);

printf("\n--- b) Milne con h = %g ---\n", h2);
printf("%10s %16s %16s %14s %10s\n", "x", "y", "exacta", "error", "correc.");
for i = 1:length(x_m)
    if i <= 4
        printf("%10.4f %16.8f %16.8f %14.6e %10s\n", x_m(i), y_m(i), ...
               exacta(x_m(i)), y_m(i) - exacta(x_m(i)), "RK");
    else
        printf("%10.4f %16.8f %16.8f %14.6e %10d\n", x_m(i), y_m(i), ...
               exacta(x_m(i)), y_m(i) - exacta(x_m(i)), it_m(i - 4));
    end
end

% -------------------------------------------------------------------------
% c) Errores en los puntos pedidos
% -------------------------------------------------------------------------
printf("\n--- c) Errores en los puntos pedidos ---\n");
printf("%10s %16s %16s %14s\n", "x", "Milne", "exacta", "error");
for objetivo = [0.20, 0.25]
    idx = find(abs(x_m - objetivo) < 1e-9, 1);
    printf("%10.4f %16.8f %16.8f %14.6e\n", objetivo, y_m(idx), ...
           exacta(objetivo), y_m(idx) - exacta(objetivo));
end

% -------------------------------------------------------------------------
% Gráfico
% -------------------------------------------------------------------------
x_fino = linspace(0, xf, 200);

figure;

subplot(1, 2, 1);
plot(x_fino, exacta(x_fino), "k-", "linewidth", 1.5);
hold on;
plot(x_m, y_m, "o-", "markersize", 6);
hold off;
grid on;
xlabel("x");
ylabel("y");
title("Solución numérica vs exacta");
legend("Exacta", "Euler modificado + Milne", "location", "northwest");

subplot(1, 2, 2);
plot(x_m, abs(y_m - exacta(x_m)), "o-", "markersize", 6);
grid on;
xlabel("x");
ylabel("|error|");
title("Error absoluto de la solución numérica");
