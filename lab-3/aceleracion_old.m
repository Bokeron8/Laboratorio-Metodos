% aceleracion.m

% F = str2func(["@(x) " input("Ingrese una función en términos de x (ej: x.^2 + 3.*x): ", "s")]);
f = @(x) 5*x - 200 * log (400 ./ (500 - x)) - 1000;
f2 = @(x) 200 + 40 * log (400 / (500 - x));

h = 1e-4; % Un paso intermedio óptimo para aproximar derivadas segundas

% Primera derivada aproximada (Diferencia central)
dF2 = @(x) (f2(x + h) - f2(x - h)) / (2 * h);
x0 = 0;
if (dF2(x0) >= 1)
  disp("El metodo no converge");
  exit();
endif


x_act = x0;
x_anterior = x_act;
x_sig = f2(x_act);
error_k = 0.0001;
iter = 0;

while ((abs(x_sig - x_anterior)) > error_k)
  x_sig = f2(x_act)
  x_anterior = x_act
  x_act = x_sig
  iter++;
endwhile

printf("%.4f", x_act);
printf("\n Cantidad de iteraciones: %.4f", iter);


figure('Name', 'Grafico de N-R');
fplot(f, [0, 300], 'b-', 'LineWidth', 2);
grid on;
hold on;
% Eje horizontal en y = 0 para ver el cruce por cero
plot([0, 300], [0, 0], 'r--', 'LineWidth', 1.5);

title(["Gráfico de f(x)"]);
xlabel('x');
ylabel('f(x)');
legend({"f(x)", "y = 0"}, "Location", "northeast");
hold off;
pause;