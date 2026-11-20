% 05-pruebas.m
% =========================================================================
% SCRIPT: Pruebas de los algoritmos con funciones de valor conocido
% =========================================================================

clear; clc;

printf("=== PRUEBAS CON FUNCIONES DE VALOR CONOCIDO ===\n");

% -------------------------------------------------------------------------
% Derivación: f(x) = x^3, f'(1) = 3, f''(1) = 6
% -------------------------------------------------------------------------
printf("\n--- Derivacion: f(x) = x^3 ---\n");
x = 1:0.1:1.3;
y = x.^3;

[d1_asc, ~] = newton_gregory_derivada(x, y, 1, 1, "ascendente");
[d1_desc, ~] = newton_gregory_derivada(x, y, 1, 1, "descendente");
[d2_asc, ~] = newton_gregory_derivada(x, y, 1, 2, "ascendente");

printf("f'(1) exacta = 3\n");
printf("Ascendente   = %.10f  (error = %.3e)\n", d1_asc, abs(d1_asc - 3));
printf("Descendente  = %.10f  (error = %.3e)\n", d1_desc, abs(d1_desc - 3));
printf("f''(1) exacta = 6\n");
printf("Ascendente   = %.10f  (error = %.3e)\n", d2_asc, abs(d2_asc - 6));

% -------------------------------------------------------------------------
% Derivación: f(x) = exp(x), f'(0) = 1
% -------------------------------------------------------------------------
printf("\n--- Derivacion: f(x) = exp(x) ---\n");
x = 0:0.1:0.5;
y = exp(x);

[d1_asc, ~] = newton_gregory_derivada(x, y, 0, 1, "ascendente");
[d1_desc, ~] = newton_gregory_derivada(x, y, 0, 1, "descendente");

printf("f'(0) exacta = 1\n");
printf("Ascendente   = %.10f  (error = %.3e)\n", d1_asc, abs(d1_asc - 1));
printf("Descendente  = %.10f  (error = %.3e)\n", d1_desc, abs(d1_desc - 1));

% -------------------------------------------------------------------------
% Integración: f(x) = x^2 en [0, 1], integral exacta = 1/3
% -------------------------------------------------------------------------
printf("\n--- Integracion: f(x) = x^2 en [0, 1] (exacta = 0.33333333) ---\n");
x = 0:0.1:1;
y = x.^2;

exacta = 1/3;
I_trap = trapecios(x, y);
I_s13 = simpson_13(x, y);

printf("Trapecios    = %.10f  (error = %.3e)\n", I_trap, abs(I_trap - exacta));
printf("Simpson 1/3  = %.10f  (error = %.3e)\n", I_s13, abs(I_s13 - exacta));

% Simpson 3/8 necesita un número de intervalos múltiplo de 3.
x = 0:0.1:0.9;
y = x.^2;
exacta = 0.9^3 / 3;
I_s38 = simpson_38(x, y);
printf("Simpson 3/8 en [0, 0.9] = %.10f  (error = %.3e)\n", ...
    I_s38, abs(I_s38 - exacta));

% -------------------------------------------------------------------------
% Integración: f(x) = sin(x) en [0, pi], integral exacta = 2
% -------------------------------------------------------------------------
printf("\n--- Integracion: f(x) = sin(x) en [0, pi] (exacta = 2) ---\n");
x = linspace(0, pi, 13);   % 12 intervalos
y = sin(x);

exacta = 2;
I_trap = trapecios(x, y);
I_s13 = simpson_13(x, y);
I_s38 = simpson_38(x, y);

printf("Trapecios    = %.10f  (error = %.3e)\n", I_trap, abs(I_trap - exacta));
printf("Simpson 1/3  = %.10f  (error = %.3e)\n", I_s13, abs(I_s13 - exacta));
printf("Simpson 3/8  = %.10f  (error = %.3e)\n", I_s38, abs(I_s38 - exacta));

% -------------------------------------------------------------------------
% Combinación automática: f(x) = x^2 en [0, 1] con 11 intervalos
% -------------------------------------------------------------------------
printf("\n--- Combinacion automatica: f(x) = x^2 en [0, 1], 11 intervalos ---\n");
x = linspace(0, 1, 12);
y = x.^2;
[I_auto, tramos] = integrar(x, y, "auto");

for k = 1:length(tramos)
    printf("  %s en [%.4f, %.4f]: %.10f\n", ...
        tramos(k).metodo, tramos(k).xa, tramos(k).xb, tramos(k).valor);
end
printf("Combinada = %.10f  (error = %.3e)\n", I_auto, abs(I_auto - 1/3));

printf("\n");
