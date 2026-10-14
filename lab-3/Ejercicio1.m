#Lab3

#Ejercicio1

clc;

R = 3;
V = 30;

% Definición de la función f(h)
f = @(h) pi * (h.^2) .* ((3*R - h)/3) - V;

#{
a)
% Graficación con fplot
figure('Name', 'Evaluación Gráfica del Tanque Esférico');
fplot(f, [0, 6], 'b-', 'LineWidth', 2);
grid on;
hold on;

% Eje horizontal en y = 0 para ver el cruce por cero
plot([0, 6], [0, 0], 'r--', 'LineWidth', 1.5);

title('Evaluación gráfica: f(h) = V(h) - 30');
xlabel('Profundidad h (m)');
ylabel('f(h)');
#}

#{
b)
#}

% Rango de búsqueda física
h_min = 0;
h_max = 6;

% Ingreso de datos por teclado
delta_h = input('Ingrese el valor del incremento delta_h (ej. 0.5 o 0.1): ');

% Algoritmo de Tanteo
h_act = h_min;
f_act = f(h_act);

fprintf('\n--- Tabla de Valores del Método de Tanteo ---\n');
fprintf('%-10s %-15s\n', 'h', 'f(h)');
fprintf('%-10.4f %-15.4f\n', h_act, f_act);

intervalos_encontrados = [];

while (h_act + delta_h) <= h_max
    h_sig = h_act + delta_h;
    f_sig = f(h_sig);
    fprintf('%-10.4f %-15.4f\n', h_sig, f_sig);

    if (f_act * f_sig) <= 0
        fprintf('>>> Se detectó cambio de signo en el intervalo: [%.4f, %.4f]\n', h_act, h_sig);
        intervalos_encontrados = [intervalos_encontrados; h_act, h_sig];
    end

    h_act = h_sig;
    f_act = f_sig;
end

if isempty(intervalos_encontrados)
    disp('No se encontraron cambios de signo en el rango analizado.');
else
    fprintf('\nRaíz separada con éxito para el paso siguiente.\n');
    fprintf('[%g, %g]\n', intervalos_encontrados');
end


#c)

% Ingreso de datos
disp('--- Parámetros Iniciales ---');
a = input('Ingrese el extremo inferior del intervalo (a): '); % ej: 2.0
b = input('Ingrese el extremo superior del intervalo (b): '); % ej: 2.5 o 3.0
tol = input('Ingrese la cota de error permitida (ej: 0.001): ');

% Verificación del Teorema de Bolzano
if f(a) * f(b) > 0
    error('f(a) y f(b) deben tener signos opuestos.');
end

%Metodo de Intervalo Medio------

tic;
a_im = a; b_im = b;
iter_im = 0;
c_im = a_im;
error_im = abs(b_im - a_im);

fprintf('\n=== MÉTODO DE INTERVALO MEDIO ===\n');
fprintf('%-6s %-10s %-10s %-10s %-12s %-10s\n', 'Iter', 'a', 'b', 'c', 'f(c)', 'Error (b-a)');

while error_im > tol
    iter_im = iter_im + 1;
    c_im = (a_im + b_im) / 2;
    fc = f(c_im);
    error_im = (b_im - a_im) / 2;

    fprintf('%-6d %-10.5f %-10.5f %-10.5f %-12.5e %-10.5f\n', ...
            iter_im, a_im, b_im, c_im, fc, error_im);

    if fc == 0
        break;
    elseif f(a_im) * fc < 0
        b_im = c_im;
    else
        a_im = c_im;
    end
end
tiempo_im = toc;

%Metodo Interpolacion Lineal
tic;
a_il = a; b_il = b;
iter_il = 0;
c_il_ant = a_il;
error_il = 1;

fprintf('\n=== MÉTODO DE INTERPOLACIÓN LINEAL ===\n');
fprintf('%-6s %-10s %-10s %-10s %-12s %-10s\n', 'Iter', 'a', 'b', 'c', 'f(c)', '|c_act - c_ant|');

while error_il > tol
    iter_il = iter_il + 1;
    fa = f(a_il);
    fb = f(b_il);

    % Fórmula de falsa posición
    c_il = b_il - (fb * (b_il - a_il)) / (fb - fa);
    fc = f(c_il);

    if iter_il > 1
        error_il = abs(c_il - c_il_ant);
    else
        error_il = abs(b_il - a_il);
    end

    fprintf('%-6d %-10.5f %-10.5f %-10.5f %-12.5e %-10.5f\n', ...
            iter_il, a_il, b_il, c_il, fc, error_il);

    c_il_ant = c_il;

    if fc == 0
        break;
    elseif fa * fc < 0
        b_il = c_il;
    else
        a_il = c_il;
    end
end
tiempo_il = toc;

% Resultados Finales
fprintf('\n================== RESUMEN ==================\n');
fprintf('Intervalo Medio      -> Raíz: %.5f m | Iteraciones: %d | Tiempo: %.6f s\n', ...
        c_im, iter_im, tiempo_im);
fprintf('Interpolación Lineal -> Raíz: %.5f m | Iteraciones: %d | Tiempo: %.6f s\n', ...
        c_il, iter_il, tiempo_il);
