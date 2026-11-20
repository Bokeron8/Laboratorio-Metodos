% 04-combinacion-simpson.m
% =========================================================================
% SCRIPT: Ejercicio 4 - Combinación de las dos fórmulas de Simpson
% =========================================================================

clear; clc;

printf("=== EJERCICIO 4: Combinacion de Simpson 1/3 y Simpson 3/8 ===\n\n");

x_def = [12, 13, 14, 15, 16, 17];
y_def = [0.96262, 0.94718, 0.93108, 0.92221, 0.91181, 0.90151];

printf("Ingrese los datos de la tabla (Enter para usar los del enunciado).\n");
x = leer_vector("x = ", x_def);
y = leer_vector("y = ", y_def);

if length(x) ~= length(y)
    error("Los vectores x e y deben tener la misma longitud.");
end

n = length(x) - 1;
printf("\nIntervalo de integracion: [%.4f, %.4f] con %d intervalos\n", ...
    x(1), x(end), n);

if mod(n, 2) == 0 || n < 3
    error("Este ejercicio requiere un numero impar de intervalos (n >= 3).");
end

% -------------------------------------------------------------------------
% Resultados del Ejercicio 3 (Trapecios y Simpson 1/3)
% -------------------------------------------------------------------------
I_trap = trapecios(x, y);
I_A = simpson_13(x(1:end-1), y(1:end-1)) + trapecios(x(end-1:end), y(end-1:end));
I_B = trapecios(x(1:2), y(1:2)) + simpson_13(x(2:end), y(2:end));

printf("\n--- Resultados del Ejercicio 3 ---\n");
printf("Trapecios (todo el intervalo)               : %.8f\n", I_trap);
printf("Simpson 1/3 [%.0f,%.0f] + Trapecios [%.0f,%.0f] : %.8f\n", ...
    x(1), x(end-1), x(end-1), x(end), I_A);
printf("Trapecios [%.0f,%.0f] + Simpson 1/3 [%.0f,%.0f] : %.8f\n", ...
    x(1), x(2), x(2), x(end), I_B);

% -------------------------------------------------------------------------
% Ejercicio 4: combinacion de las dos formulas de Simpson
% -------------------------------------------------------------------------
printf("\n--- Ejercicio 4: combinaciones de las dos formulas de Simpson ---\n");

% Opcion A: Simpson 3/8 en los 3 primeros intervalos + Simpson 1/3 en los 2
% restantes.
I_A_38 = simpson_38(x(1:4), y(1:4));
I_A_13 = simpson_13(x(4:end), y(4:end));
I_opA = I_A_38 + I_A_13;

printf("\nOpcion A: Simpson 3/8 + Simpson 1/3\n");
printf("  Simpson 3/8 en [%.4f, %.4f]: %.8f\n", x(1), x(4), I_A_38);
printf("  Simpson 1/3 en [%.4f, %.4f]: %.8f\n", x(4), x(end), I_A_13);
printf("  Total = %.8f\n", I_opA);

% Opcion B: Simpson 1/3 en los primeros n-3 intervalos + Simpson 3/8 en los
% 3 ultimos.
I_B_13 = simpson_13(x(1:end-3), y(1:end-3));
I_B_38 = simpson_38(x(end-3:end), y(end-3:end));
I_opB = I_B_13 + I_B_38;

printf("\nOpcion B: Simpson 1/3 + Simpson 3/8\n");
printf("  Simpson 1/3 en [%.4f, %.4f]: %.8f\n", x(1), x(end-3), I_B_13);
printf("  Simpson 3/8 en [%.4f, %.4f]: %.8f\n", x(end-3), x(end), I_B_38);
printf("  Total = %.8f\n", I_opB);

% -------------------------------------------------------------------------
% Comparacion
% -------------------------------------------------------------------------
printf("\n--- Comparacion de resultados ---\n");
printf("%-46s %14s\n", "Metodo", "Integral");
printf("%-46s %14.8f\n", "Trapecios (Ej. 3)", I_trap);
printf("%-46s %14.8f\n", "Simpson 1/3 + Trapecios (Ej. 3)", I_A);
printf("%-46s %14.8f\n", "Trapecios + Simpson 1/3 (Ej. 3)", I_B);
printf("%-46s %14.8f\n", "Opcion A: 3/8 + 1/3 (Ej. 4)", I_opA);
printf("%-46s %14.8f\n", "Opcion B: 1/3 + 3/8 (Ej. 4)", I_opB);

printf("\nDiferencia entre Opcion A y Opcion B : %.8e\n", abs(I_opA - I_opB));
printf("Diferencia entre Opcion A y Simpson 1/3 + Trapecios: %.8e\n", abs(I_opA - I_A));
printf("Diferencia entre Opcion B y Simpson 1/3 + Trapecios: %.8e\n", abs(I_opB - I_A));

printf("\n");
