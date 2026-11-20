% 02-integral-tabla-corriente.m
% =========================================================================
% SCRIPT: Ejercicio 2 - Integración de una tabla de corriente
% =========================================================================

clear; clc;

printf("=== EJERCICIO 2: Integración de una tabla de corriente ===\n\n");

t_def = [0, 0.1, 0.2, 0.3, 0.4, 0.5];
i_def = [0.0, 0.15, 0.3, 0.55, 0.73, 0.81];

printf("Ingrese los datos de la tabla (Enter para usar los del enunciado).\n");
t = leer_vector("t = ", t_def);
i = leer_vector("i = ", i_def);

if length(t) ~= length(i)
    error("Los vectores t e i deben tener la misma longitud.");
end

n = length(t) - 1;
printf("\nCantidad de intervalos: %d\n", n);

% -------------------------------------------------------------------------
% Regla de los Trapecios
% -------------------------------------------------------------------------
I_trap = trapecios(t, i);
printf("\n--- Regla de los Trapecios (todos los intervalos) ---\n");
printf("Integral aproximada = %.8f\n", I_trap);

% -------------------------------------------------------------------------
% Fórmulas de Simpson por separado
% -------------------------------------------------------------------------
printf("\n--- Fórmulas de Simpson ---\n");
if mod(n, 2) == 0
    I_s13 = simpson_13(t, i);
    printf("Simpson 1/3 (aplicable, n par): %.8f\n", I_s13);
else
    printf("Simpson 1/3: no aplicable directamente (requiere n par).\n");
end
if mod(n, 3) == 0
    I_s38 = simpson_38(t, i);
    printf("Simpson 3/8 (aplicable, n multiplo de 3): %.8f\n", I_s38);
else
    printf("Simpson 3/8: no aplicable directamente (requiere n multiplo de 3).\n");
end

% -------------------------------------------------------------------------
% Combinaciones posibles
% -------------------------------------------------------------------------
printf("\n--- Combinaciones de fórmulas ---\n");

[I_auto, tramos] = integrar(t, i, "auto");
printf("Combinacion automatica de formulas:\n");
for k = 1:length(tramos)
    printf("  %s en [%.3f, %.3f]: %.8f\n", ...
        tramos(k).metodo, tramos(k).xa, tramos(k).xb, tramos(k).valor);
end
printf("  Total = %.8f\n", I_auto);

if mod(n, 2) ~= 0 && n >= 4
    I_alt = simpson_13(t(1:end-1), i(1:end-1)) + ...
        trapecios(t(end-1:end), i(end-1:end));
    printf("\nCombinacion Simpson 1/3 + Trapecios:\n");
    printf("  Simpson 1/3 en [%.3f, %.3f]: %.8f\n", ...
        t(1), t(end-1), simpson_13(t(1:end-1), i(1:end-1)));
    printf("  Trapecios en [%.3f, %.3f]: %.8f\n", ...
        t(end-1), t(end), trapecios(t(end-1:end), i(end-1:end)));
    printf("  Total = %.8f\n", I_alt);
end

printf("\n");
