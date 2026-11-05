% ejercicio4_comparativo.m
% Comparación de métodos sobre el problema de componentes electrónicos

clc;
clear;

disp("=================================================");
disp("   EJERCICIO 4: COMPARACIÓN DE MÉTODOS LINEALES  ");
disp("=================================================");

% 1. Definición del modelo matemático
% x1: Transistores, x2: Resistores, x3: Chips
A = [4.3, 3.0, 2.0;
     1.0, 3.0, 1.0;
     2.0, 1.0, 3.0];

b = [960;
     510;
     610];

disp("Matriz de consumo de materiales A:");
disp(A);
disp("Vector de disponibilidad semanal b:");
disp(b);

% --- A. ELIMINACIÓN DE GAUSS ---
[x_gauss, t_gauss] = resolver_gauss(A, b);

% --- B. GAUSS-JORDAN ---
[x_gj, t_gj] = resolver_gauss_jordan(A, b);

% --- C. DESCOMPOSICIÓN LU ---
[x_lu, L, U, t_lu] = resolver_lu(A, b);

% --- D. GAUSS-SEIDEL ---
x0 = [0; 0; 0];
tol = 1e-5;
max_iter = 200;
[x_gs, iter_gs, t_gs] = resolver_gauss_seidel(A, b, x0, tol, max_iter);

% --- TABLA RESUMEN DE RESULTADOS ---
fprintf("\n======================== RESULTADOS ========================\n");
fprintf("%-18s %-10s %-10s %-10s %-12s\n", "Método", "x1 (Trans)", "x2 (Res)", "x3 (Chips)", "Tiempo (s)");
fprintf("------------------------------------------------------------\n");
fprintf("%-18s %-10.2f %-10.2f %-10.2f %-12e\n", "Gauss", x_gauss(1), x_gauss(2), x_gauss(3), t_gauss);
fprintf("%-18s %-10.2f %-10.2f %-10.2f %-12e\n", "Gauss-Jordan", x_gj(1), x_gj(2), x_gj(3), t_gj);
fprintf("%-18s %-10.2f %-10.2f %-10.2f %-12e\n", "Descomposición LU", x_lu(1), x_lu(2), x_lu(3), t_lu);
fprintf("%-18s %-10.2f %-10.2f %-10.2f %-12e (Iter: %d)\n", "Gauss-Seidel", x_gs(1), x_gs(2), x_gs(3), t_gs, iter_gs);
fprintf("============================================================\n");

% Interpretación final
fprintf("\nProducción óptima calculada:\n");
fprintf("  • Transistores: %.0f unidades\n", x_gauss(1));
fprintf("  • Resistores:   %.0f unidades\n", x_gauss(2));
fprintf("  • Chips:        %.0f unidades\n", x_gauss(3));
