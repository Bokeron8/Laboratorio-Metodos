% 01-derivacion-newton-gregory.m
% =========================================================================
% SCRIPT: Ejercicio 1 - Derivación con fórmulas de Newton-Gregory
% =========================================================================

clear; clc;

printf("=== EJERCICIO 1: Derivación numérica con Newton-Gregory ===\n\n");

x_def = [12, 13, 14, 15, 16, 17];
y_def = [0.96262, 0.94718, 0.93108, 0.92221, 0.91181, 0.90151];

printf("Ingrese los datos de la tabla (Enter para usar los del enunciado).\n");
x = leer_vector("x = ", x_def);
y = leer_vector("y = ", y_def);

if length(x) ~= length(y)
    error("Los vectores x e y deben tener la misma longitud.");
end

% -------------------------------------------------------------------------
% a. Tabla de diferencias
% -------------------------------------------------------------------------
T = tabla_diferencias(x, y);
printf("\n--- Apartado a: Tabla de diferencias finitas ---\n");
mostrar_tabla_diferencias(T);
printf("\nLas diferencias descendentes se leen sobre la diagonal inferior derecha.\n");

% -------------------------------------------------------------------------
% b. f'(x) con la fórmula ascendente
% -------------------------------------------------------------------------
x1 = leer_escalar("\nPunto para calcular f'(x) [12]: ", 12);
[f1_asc, ~] = newton_gregory_derivada(x, y, x1, 1, "ascendente");

printf("\n--- Apartado b: f'(%.4f) con Gregory-Newton Ascendente ---\n", x1);
printf("f'(%.4f) = %.8f\n", x1, f1_asc);

printf("\nSensibilidad de f'(%.4f) a la cantidad de términos (puntos):\n", x1);
for k = 2:length(x)
    dk = newton_gregory_derivada(x(1:k), y(1:k), x1, 1, "ascendente");
    printf("  %d puntos: %.8f\n", k, dk);
end

% -------------------------------------------------------------------------
% c. f'(x) con ambas fórmulas
% -------------------------------------------------------------------------
x2 = leer_escalar("\nPunto para comparar ambas fórmulas [12.4]: ", 12.4);
[f2_asc, ~] = newton_gregory_derivada(x, y, x2, 1, "ascendente");
[f2_desc, ~] = newton_gregory_derivada(x, y, x2, 1, "descendente");

printf("\n--- Apartado c: f'(%.4f) con ambas fórmulas ---\n", x2);
printf("Ascendente  : f'(%.4f) = %.8f\n", x2, f2_asc);
printf("Descendente : f'(%.4f) = %.8f\n", x2, f2_desc);
printf("Diferencia  : |asc - desc| = %.8e\n", abs(f2_asc - f2_desc));
printf("Comparacion : |f'(%.4f) - f'(%.4f)| = %.8e\n", ...
    x1, x2, abs(f1_asc - f2_asc));

% -------------------------------------------------------------------------
% d. f''(x) con la fórmula descendente
% -------------------------------------------------------------------------
x3 = leer_escalar("\nPunto para calcular f''(x) [17]: ", 17);
[f3_desc, ~] = newton_gregory_derivada(x, y, x3, 2, "descendente");

printf("\n--- Apartado d: f''(%.4f) con Gregory-Newton Descendente ---\n", x3);
printf("f''(%.4f) = %.8f\n", x3, f3_desc);

printf("\nDiferencias descendentes en el último nodo (x = %.4f):\n", x(end));
anterior = y(end);
printf("  nabla^0 y = %.8f\n", anterior);
for k = 1:length(x)-1
    actual = T(length(x) - k, k + 2);
    printf("  nabla^%d y = %.8f\n", k, actual);
end

printf("\nSensibilidad de f''(%.4f) a la cantidad de términos (puntos):\n", x3);
for k = 3:length(x)
    dk = newton_gregory_derivada(x(end-k+1:end), y(end-k+1:end), x3, 2, "descendente");
    printf("  %d puntos: %.8f\n", k, dk);
end

printf("\n");
