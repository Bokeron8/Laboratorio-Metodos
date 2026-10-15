% 04-ecuacion-segundo-grado.m - Ejercicio 4 de la Guía 1: ecuación de segundo grado.
%
% Problema: "Si al quíntuple de un número se le suma el triple de su cuadrado, se
% obtiene el triple del mismo más 1". Es decir,
%   5x + 3x^2 = 3x + 1
% y hay que armar la ecuación de segundo grado correspondiente y encontrar los
% valores numéricos que cumplen esa condición.
%
% Modelo matemático: llevando todo a un lado,
%   3x^2 + 2x - 1 = 0,      con a = 3, b = 2, c = -1
% Se aplica la fórmula general
%   x1 = (-b + sqrt(b^2 - 4ac)) / (2a)
%   x2 = (-b - sqrt(b^2 - 4ac)) / (2a)
% El discriminante es Delta = b^2 - 4ac = 4 + 12 = 16, que es positivo, así que
% hay dos raíces reales distintas: x1 = 1/3 y x2 = -1.
%
% Verificación: no alcanza con comprobar la ecuación reducida, porque un error
% de signo podría dar por buena una raíz que no la satisface. La condición se
% contrasta sobre la ecuación ORIGINAL, calculando los dos miembros por
% separado: 3x + 1  contra  5x + 3x^2. Los dos miembros tienen que coincidir.
%
% Correcciones respecto de la versión original:
%   - inline y ezplot son legado. Octave 6.4 avisa "inline is obsolete" y en
%     Octave 9 fueron eliminados. Se reemplazan por un function handle @(x) y
%     por fplot.
%   - Se elimina la variable string "y", que quedaba definida y sin usar.
%
% Estructura del problema:
%   a) Armar la ecuación de segundo grado a partir del enunciado.
%   b) Calcular las dos raíces.
%   c) Verificarlas sobre la ecuación original y graficar.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Coeficientes de 3x^2 + 2x - 1 = 0.
a = 3;
b = 2;
c = -1;

% Miembros de la ecuación original, para la verificación.
% Lado izquierdo: "el triple del mismo más 1" es 3x + 1.
% Lado derecho: "el quíntuple más el triple del cuadrado" es 5x + 3x^2.
miembro_izquierdo = @(x) 3 * x + 1;
miembro_derecho = @(x) 5 * x + 3 * x.^2;

% Residuo de la ecuación original, que es lo que se grafica.
residuo = @(x) miembro_izquierdo(x) - miembro_derecho(x);

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 4 - ECUACIÓN DE SEGUNDO GRADO\n');
fprintf('========================================================\n');

% ----------------------------------------------------------------------
% a) Ecuación de segundo grado
% ----------------------------------------------------------------------
fprintf('\n--- a) Ecuación de segundo grado ---\n');
fprintf('Enunciado:  5x + 3x^2 = 3x + 1\n');
fprintf('Reordenando:  3x^2 + 2x - 1 = 0\n');
fprintf('Coeficientes:  a = %g,  b = %g,  c = %g\n', a, b, c);

% ----------------------------------------------------------------------
% b) Cálculo de las raíces
% ----------------------------------------------------------------------
delta = b^2 - 4 * a * c;
fprintf('\n--- b) Cálculo de las raíces ---\n');
fprintf('Discriminante:  Delta = b^2 - 4ac = %g\n', delta);
fprintf('sqrt(Delta) = %g\n', sqrt(delta));

x1 = (-b + sqrt(delta)) / (2 * a);
x2 = (-b - sqrt(delta)) / (2 * a);

fprintf('x1 = (-b + sqrt(Delta)) / (2a) = %s\n', sprintf('%.15f', x1));
fprintf('x2 = (-b - sqrt(Delta)) / (2a) = %s\n', sprintf('%.15f', x2));

% ----------------------------------------------------------------------
% c) Verificación sobre la ecuación original
% ----------------------------------------------------------------------
fprintf('\n--- c) Verificación sobre la ecuación original ---\n');
fprintf('Se evalúan por separado los dos miembros de 5x + 3x^2 = 3x + 1.\n\n');
fprintf('%-6s %-22s %-22s %s\n', 'raíz', '3x + 1', '5x + 3x^2', 'diferencia');
fprintf('%-6s %-22.15f %-22.15f %.3e\n', 'x1', miembro_izquierdo(x1), miembro_derecho(x1), ...
        miembro_izquierdo(x1) - miembro_derecho(x1));
fprintf('%-6s %-22.15f %-22.15f %.3e\n', 'x2', miembro_izquierdo(x2), miembro_derecho(x2), ...
        miembro_izquierdo(x2) - miembro_derecho(x2));

% Las soluciones analíticas, para contrastar.
fprintf('\nSoluciones analíticas:  x1 = 1/3 y x2 = -1\n');
fprintf('Error de x1 contra 1/3: %.3e\n', abs(x1 - 1/3));
fprintf('Error de x2 contra -1 : %.3e\n', abs(x2 + 1));

% ----------------------------------------------------------------------
% c) Gráfico
% ----------------------------------------------------------------------
% Se grafica el residuo 3x + 1 - (5x + 3x^2), que se anula en las raíces.
% fplot evalúa vectores, así que los operadores element-wise son obligatorios.
figure('Name', 'Ejercicio 1 - Ecuación de segundo grado');
fplot(residuo, [-3, 3], 'b-', 'LineWidth', 2);
grid on;
hold on;

% Eje horizontal en y = 0: sus cruces con la curva son las raíces.
plot([-3, 3], [0, 0], 'r--', 'LineWidth', 1.5);
plot(x1, 0, 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(x2, 0, 'ms', 'MarkerSize', 8, 'LineWidth', 2);

title('Residuo de 3x + 1 = 5x + 3x^2');
xlabel('x');
ylabel('3x + 1 - (5x + 3x^2)');
legend({'residuo', 'y = 0', 'x1 = 1/3', 'x2 = -1'}, 'Location', 'southeast');

hold off;

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('Las raíces obtenidas satisfacen la ecuación con error de orden de máquina.\n');
fprintf('La existencia de soluciones reales depende exclusivamente del signo del discriminante.\n');