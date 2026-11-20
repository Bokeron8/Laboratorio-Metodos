% 04-densidad-sodio.m
% =========================================================================
% SCRIPT: Ejercicio 4 - Densidad del sodio a diferentes temperaturas
% =========================================================================

clear; clc;

printf("=== EJERCICIO 4: Densidad del sodio en función de la temperatura ===\n\n");

temperatura = [102, 245, 327, 423, 565];
densidad = [0.564642, 0.644218, 0.717356, 0.783327, 0.853329];

disp("Tabla de datos (Temperatura vs Densidad):");
disp([temperatura; densidad]');

T_eval = 275;

% a. Aplicar fórmula de Lagrange para T = 275
[densidad_lagrange, ~] = lagrange(temperatura, densidad, T_eval);
printf("\n--- Apartado a: Interpolación de Lagrange para T = %d ---\n", T_eval);
printf("Densidad estimada (Lagrange) = %.6f\n", densidad_lagrange);

% b. Aplicar Interpolación Parabólica Progresiva para T = 275 y estimar error
[densidad_parabolica, puntos_usados] = interpolacion_parabolica_progresiva(temperatura, densidad, T_eval);
printf("\n--- Apartado b: Interpolación Parabólica Progresiva para T = %d ---\n", T_eval);
printf("Puntos utilizados (Temperatura y Densidad):\n");
disp(puntos_usados);
printf("Densidad estimada (Parabólica Progresiva) = %.6f\n", densidad_parabolica);

% Estimación de error (diferencia absoluta entre ambos métodos locales/globales)
error_estimado = abs(densidad_lagrange - densidad_parabolica);
printf("Error estimado (diferencia Lagrange vs Parabólica) = %.8f\n", error_estimado);

% c. Conclusiones
printf("\n--- Apartado c: Conclusiones ---\n");
printf("1. La interpolación de Lagrange utiliza todos los puntos disponibles, generando un polinomio\n");
printf("   de grado 4, lo cual puede incorporar oscilaciones espurias si hay errores experimentales.\n");
printf("2. La interpolación parabólica progresiva utiliza un subconjunto local de 3 puntos (grado 2),\n");
printf("   enfocándose en la región inmediata a T = 275 (entre 245 y 327).\n");
printf("3. Ambas técnicas proporcionan resultados muy cercanos, validando la consistencia de los datos\n");
printf("   experimentales de densidad del sodio en ese rango térmico.\n");
