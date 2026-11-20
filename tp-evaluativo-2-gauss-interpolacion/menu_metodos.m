% menu_metodos.m
% Programa principal que integra:
%   1. Método de Gauss-Jordan con Pivoteo Parcial   -> gauss_jordan.m
%   2. Interpolación Inversa Lineal                 -> interpolacion_inversa_lineal.m
%
% Los métodos viven en sus propios archivos: este menú sólo pide los datos y
% delega. Cada método valida sus entradas. Los errores se capturan con
% try/catch para volver al menú sin cerrar el programa.

clc;
clear;

% =========================================================================
% OPCIÓN 1: MÉTODO DE GAUSS-JORDAN CON PIVOTEO PARCIAL
% =========================================================================
function ejecutar_gauss_jordan()
    A_ejemplo = [80 15 35 60; 28 72 57 25; 20 20 12 20; 50 10 20 60];
    b_ejemplo = [230; 180; 80; 160];

    fprintf("\n--- INGRESO DE DATOS: GAUSS-JORDAN ---\n");
    fprintf("Ejemplo A: %s\n", strrep(mat2str(A_ejemplo), ";", "; "));
    fprintf("Ejemplo b: %s\n", strrep(mat2str(b_ejemplo), ";", "; "));

    A = input("Ingrese la matriz de coeficientes A (Enter = ejemplo): ");
    if isempty(A)
        A = A_ejemplo;
    end

    b = input("Ingrese el vector de términos independientes b (Enter = ejemplo): ");
    if isempty(b)
        b = b_ejemplo;
    end

    % Asegurar que b sea vector columna
    if isrow(b)
        b = b';
    endif

    tic;
    try
        % gauss_jordan imprime el paso a paso y la solución final.
        gauss_jordan(A, b);
    catch err
        fprintf("[Error] %s\n", err.message);
        return;
    end
    tiempo = toc;

    fprintf("Tiempo de ejecución: %.6f segundos\n", tiempo);
endfunction


% =========================================================================
% OPCIÓN 2: INTERPOLACIÓN INVERSA LINEAL
% =========================================================================
function ejecutar_interpolacion_inversa()
    x_ejemplo = [15 25 35 45 55 65];
    y_ejemplo = [0.965926 0.906308 0.819152 0.707107 0.573576 0.422618];
    y_objetivo_ejemplo = 0.90728517;

    fprintf("\n--- INGRESO DE DATOS: INTERPOLACIÓN INVERSA LINEAL ---\n");
    fprintf("Ejemplo X: %s\n", mat2str(x_ejemplo));
    fprintf("Ejemplo Y: %s\n", mat2str(y_ejemplo));

    x_tabla = input("Ingrese el vector X (Enter = ejemplo): ");
    if isempty(x_tabla)
        x_tabla = x_ejemplo;
    end

    y_tabla = input("Ingrese el vector Y (Enter = ejemplo): ");
    if isempty(y_tabla)
        y_tabla = y_ejemplo;
    end

    % La validación vive en interpolacion_inversa_lineal.m.
    y_objetivo = input(sprintf("Ingrese el valor objetivo de y (Enter = %.8f): ", ...
                               y_objetivo_ejemplo));
    if isempty(y_objetivo)
        y_objetivo = y_objetivo_ejemplo;
    end

    tic;
    try
        % El método imprime el paso a paso y el resultado.
        interpolacion_inversa_lineal(x_tabla, y_tabla, y_objetivo);
    catch err
        fprintf("[Error] %s\n", err.message);
        return;
    end
    tiempo = toc;

    fprintf("Tiempo de ejecución: %.6f segundos\n", tiempo);
endfunction


% --- MENÚ PRINCIPAL ---
opcion = 0;
while opcion ~= 3
    fprintf("\n==============================================\n");
    fprintf("       MENÚ DE MÉTODOS NUMÉRICOS\n");
    fprintf("==============================================\n");
    fprintf("  1. Método de Gauss-Jordan (Sistemas Lineales)\n");
    fprintf("  2. Interpolación Inversa Lineal\n");
    fprintf("  3. Salir\n");
    fprintf("==============================================\n");

    opcion = input("Seleccione una opción (1-3): ");

    switch opcion
        case 1
            ejecutar_gauss_jordan();
        case 2
            ejecutar_interpolacion_inversa();
        case 3
            fprintf("\nSaliendo del programa...\n");
        otherwise
            fprintf("\n[!] Opción no válida. Por favor ingrese 1, 2 o 3.\n");
    endswitch
endwhile
