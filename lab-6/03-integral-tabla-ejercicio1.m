% 03-integral-tabla-ejercicio1.m
% =========================================================================
% SCRIPT: Ejercicio 3 - Integral de la tabla del Ejercicio 1
% =========================================================================

clear; clc;

printf("=== EJERCICIO 3: Integral de la tabla del Ejercicio 1 ===\n\n");

x_def = [12, 13, 14, 15, 16, 17];
y_def = [0.96262, 0.94718, 0.93108, 0.92221, 0.91181, 0.90151];

printf("Ingrese los datos de la tabla (Enter para usar los del enunciado).\n");
x = leer_vector("x = ", x_def);
y = leer_vector("y = ", y_def);

if length(x) ~= length(y)
    error("Los vectores x e y deben tener la misma longitud.");
end

n = length(x) - 1;
printf("\nIntervalo de integracion: [%.4f, %.4f]\n", x(1), x(end));
printf("Cantidad de intervalos: %d\n", n);

% -------------------------------------------------------------------------
% Regla de los Trapecios
% -------------------------------------------------------------------------
I_trap = trapecios(x, y);
printf("\n--- Regla de los Trapecios (todos los intervalos) ---\n");
printf("Integral aproximada = %.8f\n", I_trap);

% -------------------------------------------------------------------------
% Formula de Simpson 1/3
% -------------------------------------------------------------------------
printf("\n--- Formula de Simpson 1/3 ---\n");
if mod(n, 2) == 0
    I_s13 = simpson_13(x, y);
    printf("Integral aproximada = %.8f\n", I_s13);
else
    printf("No aplicable sobre todo el intervalo: requiere un numero par de intervalos.\n");
    printf("Se combina con Trapecios en el intervalo restante.\n");
end

% -------------------------------------------------------------------------
% Combinaciones de Trapecios y Simpson 1/3
% -------------------------------------------------------------------------
if mod(n, 2) ~= 0 && n >= 4
    printf("\n--- Combinaciones de Trapecios y Simpson 1/3 ---\n");

    I_A_13 = simpson_13(x(1:end-1), y(1:end-1));
    I_A_trap = trapecios(x(end-1:end), y(end-1:end));
    I_A = I_A_13 + I_A_trap;
    printf("Opcion A: Simpson 1/3 en [%.4f, %.4f] + Trapecios en [%.4f, %.4f]\n", ...
        x(1), x(end-1), x(end-1), x(end));
    printf("  Simpson 1/3 = %.8f\n", I_A_13);
    printf("  Trapecios   = %.8f\n", I_A_trap);
    printf("  Total       = %.8f\n", I_A);

    I_B_trap = trapecios(x(1:2), y(1:2));
    I_B_13 = simpson_13(x(2:end), y(2:end));
    I_B = I_B_trap + I_B_13;
    printf("Opcion B: Trapecios en [%.4f, %.4f] + Simpson 1/3 en [%.4f, %.4f]\n", ...
        x(1), x(2), x(2), x(end));
    printf("  Trapecios   = %.8f\n", I_B_trap);
    printf("  Simpson 1/3 = %.8f\n", I_B_13);
    printf("  Total       = %.8f\n", I_B);

    printf("\nDiferencia entre Opcion A y Opcion B: %.8e\n", abs(I_A - I_B));
end

printf("\nLa combinacion de las dos formulas de Simpson se analiza en el Ejercicio 4.\n");

printf("\n");
