#Lab3

#Ejercicio2

clc;

    fprintf('\n==========================================\n');
    fprintf('\tMETEDO NEWTON-RAPHSON\n');
    fprintf('============================================\n');
% Definición de la función de utilidad
% -0.0013*(x.^3) + 0.3*(x.^2) + 8*x - 372

F = str2func(["@(x) " input("Ingrese una función en términos de x (ej: x.^2 + 3.*x): ", "s")]);
#a)

% Graficación con fplot
disp('--- Ingrese rango de X para graficar ---');
x_min = input("Ingrese el límite inferior de x (ej: 0): ");
x_max = input("Ingrese el límite superior de x (ej: 6): ");

figure('Name', 'Grafico de N-R');
fplot(F, [x_min, x_max], 'b-', 'LineWidth', 2);
grid on;
hold on;
% Eje horizontal en y = 0 para ver el cruce por cero
plot([x_min, x_max], [0, 0], 'r--', 'LineWidth', 1.5);

title(["Gráfico de f(x)"]);
xlabel('x');
ylabel('f(x)');
legend({"f(x)", "y = 0"}, "Location", "northeast");
hold off;

#b)

% Funciones
h = 1e-4; % Un paso intermedio óptimo para aproximar derivadas segundas

% Primera derivada aproximada (Diferencia central)
dF = @(x) (F(x + h) - F(x - h)) / (2 * h);
% Segunda derivada aproximada (Diferencia finita de segundo orden)
d2F = @(x) (F(x + h) - 2 * F(x) + F(x - h)) / (h^2);

%dF = @(x) - 0.0039*(x.^2)+ 0.6*x + 8
%d2F= @(x) - 0.0078*x + 0.6

Tanteo_old(F);

tol = input('Ingrese la cota de error permitida (ej: 0.001): ');

% ============================================================
% BUCLE DINÁMICO DE EVALUACIÓN DE INTERVALOS
% ============================================================
continuar = 's';
caso = 0;

while lower(continuar) == 's'
    caso = caso + 1;
    fprintf('\n--- CONFIGURACIÓN DEL CASO %d ---\n', caso);
    a = input('Ingrese el límite inferior del intervalo (a): ');
    b = input('Ingrese el límite superior del intervalo (b): ');

    fprintf('\n============================================================\n');
    fprintf('ANALISIS PARA EL INTERVALO [%.1f, %.1f]\n', a, b);
    fprintf('============================================================\n');

    % 1. Comprobación de Fourier
    fa = F(a); fb = F(b);
    dfa = dF(a); dfb = dF(b);
    d2fa = d2F(a); d2fb = d2F(b);

    fprintf('1. Cambio de signo: F(a)=%.4f, F(b)=%.4f -> Producto = %.4e\n', fa, fb, fa*fb);
    fprintf('2. Signo de F''(x): F''(a)=%.4f, F''(b)=%.4f\n', dfa, dfb);
    fprintf('3. Signo de F''''(x): F''''(a)=%.4f, F''''(b)=%.4f\n', d2fa, d2fb);

    % Elección de x0 según Fourier: F(x0) * F''(x0) > 0
    if (fa * d2fa) > 0
        x0 = a;
    else
        x0 = b;
    end
    fprintf('-> Condición de Fourier F(x0)*F''''(x0) > 0 satisfecha para x0 = %.2f\n\n', x0);

    % 2. Método de Newton-Raphson
    fprintf('%-6s %-12s %-12s %-12s %-12s\n', 'Iter', 'x_k', 'F(x_k)', 'F''(x_k)', 'Error:|x_sig - x_act|');

    x_act = x0;
    iter = 0;
    error_k = 1;

    tic;
    while error_k > tol
        iter = iter + 1;
        fx = F(x_act);
        dfx = dF(x_act);

        x_sig = x_act - (fx / dfx);
        error_k = abs(x_sig - x_act);

        fprintf('%-6d %-12.6f %-12.6e %-12.6f %-12.8f\n', ...
                iter, x_act, fx, dfx, error_k);

        x_act = x_sig;
    end
    tiempo = toc;
    fprintf('\n>>> Raíz encontrada: x ≈ %.4f (se requieren %d impresoras)\n', x_act, ceil(x_act));
    fprintf('>>> Cantidad de iteraciones: %d\n', iter);
    fprintf('>>> Tiempo: %.6f segundos\n', tiempo);

    % Pregunta de control para continuar o cerrar el programa
    continuar = input('\n¿Desea evaluar otro intervalo hallado por tanteo? (s/n): ', 's');
end