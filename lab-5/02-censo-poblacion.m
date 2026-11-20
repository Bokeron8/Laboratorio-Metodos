% 02-censo-poblacion.m
% =========================================================================
% SCRIPT: Ejercicio 2 - Censo de población en EE.UU. (Lagrange)
% =========================================================================

clear; clc;

printf("=== EJERCICIO 2: Censo de población en Estados Unidos ===\n\n");

anos = [1940, 1950, 1960, 1970, 1980, 1990];
poblacion = [132165, 151326, 179323, 203302, 226542, 249633]; % en miles

disp("Tabla de Censo (Año vs Población en miles):");
disp([anos; poblacion]');

% a. Aproximar la población en el año 1965 usando Lagrange
ano_objetivo = 1965;
[pob_1965, L] = lagrange(anos, poblacion, ano_objetivo);

printf("\n--- Apartado a: Interpolación de Lagrange ---\n");
printf("Población estimada en el año %d: %.3f miles (approx. %.0f habitantes)\n", ...
    ano_objetivo, pob_1965, pob_1965 * 1000);

% b. Análisis de exactitud comparando con el valor real aproximado (189 703 000)
pob_real = 189703; % en miles
error_abs = abs(pob_1965 - pob_real);
error_rel = (error_abs / pob_real) * 100;

printf("\n--- Apartado b: Análisis de Exactitud ---\n");
printf("Valor real informado: %.3f miles (189,703,000 hab.)\n", pob_real);
printf("Error absoluto      : %.3f miles\n", error_abs);
printf("Error relativo      : %.4f %%\n", error_rel);
printf("Conclusión: La interpolación polinómica de Lagrange con datos censales decenales\n");
printf("ofrece una aproximación razonablemente precisa, aunque al estar en el punto medio\n");
printf("del intervalo (1960-1970) los polinomios de alto grado pueden presentar oscilaciones\n");
printf("(fenómeno de Runge) o limitaciones respecto a crecimientos poblacionales no lineales.\n");
