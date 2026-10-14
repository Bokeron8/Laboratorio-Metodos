#Lab3

#Ejercicio3

clc;


% Definición de la función de iteración g(x)
g = @(x) 200 + 40 * log(400 ./ (500 - x));

% Datos iniciales
x0 = 200;
tol = input('Ingrese la cota de error permitida (ej: 0.001): ');
max_iter = 100;

disp('========================================================');
disp('  MÉTODO DE ITERACIÓN (PUNTO FIJO) Y ACELERACIÓN DE AITKEN');
disp('========================================================');
disp('Opciones:');
disp('  1) Iteración Simple');
disp('  2) Iteración con Aceleración de Aitken');
opcion = input('Seleccione una opción (1 o 2): ');

if opcion == 1
    %% --- ITERACIÓN SIMPLE ---
    fprintf('\n--- MÉTODO DE ITERACIÓN SIMPLE ---\n');
    fprintf('%-6s %-14s %-14s %-12s\n', 'Iter', 'x_k', 'x_{k+1}', 'Error');

    x_act = x0;
    iter = 0;
    error_k = 1;

    while error_k > tol && iter < max_iter
        iter = iter + 1;
        x_sig = g(x_act);
        error_k = abs(x_sig - x_act);

        fprintf('%-6d %-14.6f %-14.6f %-12.6f\n',
                  iter, x_act, x_sig, error_k);
        x_act = x_sig;
    end
    raiz = x_act;

else
    %% --- ACELERACIÓN DE AITKEN (Método de Steffensen) ---
    fprintf('\n--- MÉTODO CON ACELERACIÓN DE AITKEN ---\n');
    fprintf('%-6s %-12s %-12s %-12s %-14s %-12s\n', ...
            'Paso', 'x_0', 'x_1', 'x_2', 'x_acelerado', 'Error');

    x_act = x0;
    iter = 0;
    error_k = 1;

    while error_k > tol && iter < max_iter
        iter = iter + 1;

        % Se generan dos pasos simples con g(x)
        x1 = g(x_act);
        x2 = g(x1);

        % Denominador de Aitken: Delta^2(x) = x2 - 2*x1 + x_act
        den = x2 - 2*x1 + x_act;
        if abs(den) < 1e-12
            break;
        end

        % Fórmula de extrapolación de Aitken
        x_acel = x_act - ((x1 - x_act)^2) / den;
        error_k = abs(x_acel - x_act);

        fprintf('%-6d %-12.6f %-12.6f %-12.6f %-14.6f %-12.6f\n', ...
                iter, x_act, x1, x2, x_acel, error_k);

        x_act = x_acel;
    end
    raiz = x_act;
end

fprintf('\n>>> Solución aproximada: x ≈ %.4f unidades\n', raiz);
fprintf('>>> Cantidad de unidades a producir y vender: %d unidades\n', ceil(raiz));
fprintf('>>> Cantidad de iteraciones: %d\n', iter);

%% --- GRAFICACIÓN DE LAS DOS CURVAS (y = x  e  y = g(x)) ---
figure('Name', 'Método de Iteración - Punto Fijo');
rango = [190, 230];

% Grafica la recta y = x
fplot(@(x) x, rango, 'r--', 'LineWidth', 1.5);
hold on; grid on;

% Grafica la curva y = g(x)
fplot(g, rango, 'b-', 'LineWidth', 2);

% Grafica el punto de equilibrio / punto fijo
plot(raiz, raiz, 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 8);

title('Punto Fijo: Intersección entre y = x  e  y = g(x)');
xlabel('x (unidades)');
ylabel('y');
legend('y = x', 'y = g(x)', sprintf('Punto Fijo (%.2f)', raiz), 'Location', 'NorthWest');
