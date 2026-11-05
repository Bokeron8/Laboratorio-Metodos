% 04-componentes-electronicos.m - Ejercicio 4 de la Guía 4: Comparación de Métodos
clc;
clear;

fprintf('========================================================\n');
fprintf('  EJERCICIO 4 - COMPONENTES ELECTRÓNICOS (COMPARATIVA)\n');
fprintf('========================================================\n');

% x1: Transistores, x2: Resistores, x3: Chips de computadora
A = [4.3, 3.0, 2.0;
     1.0, 3.0, 1.0;
     2.0, 1.0, 3.0];

b = [960; 510; 610];

fprintf('Matriz A (Cobre, Zinc, Vidrio):\n');
disp(A);
fprintf('Vector b (Disponibilidad semanal):\n');
disp(b');

% 1. Eliminación de Gauss
[x_g, t_g] = resolver_gauss(A, b);

% 2. Gauss-Jordan
[x_gj, t_gj] = resolver_gauss_jordan_func(A, b);

% 3. Descomposición LU
[x_lu, ~, ~, ~, t_lu] = resolver_lu_func(A, b);

% 4. Gauss-Seidel
[x_gs, iter_gs, t_gs] = resolver_gauss_seidel_func(A, b, [0; 0; 0], 1e-5, 200);

fprintf('\n================== RESUMEN COMPARATIVO ==================\n');
fprintf('%-18s %-10s %-10s %-10s %-12s\n', 'Método', 'x1 (Trans)', 'x2 (Res)', 'x3 (Chips)', 'Tiempo (s)');
fprintf('------------------------------------------------------------\n');
fprintf('%-18s %-10.2f %-10.2f %-10.2f %-12e\n', 'Eliminación Gauss', x_g(1), x_g(2), x_g(3), t_g);
fprintf('%-18s %-10.2f %-10.2f %-10.2f %-12e\n', 'Gauss-Jordan', x_gj(1), x_gj(2), x_gj(3), t_gj);
fprintf('%-18s %-10.2f %-10.2f %-10.2f %-12e\n', 'Descomposición LU', x_lu(1), x_lu(2), x_lu(3), t_lu);
fprintf('%-18s %-10.2f %-10.2f %-10.2f %-12e (%d it)\n', 'Gauss-Seidel', x_gs(1), x_gs(2), x_gs(3), t_gs, iter_gs);
fprintf('============================================================\n');
