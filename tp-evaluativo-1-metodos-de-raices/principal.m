% PRINCIPAL - Programa conductor: elige el metodo y carga los datos por teclado.
% Metodos disponibles: punto fijo (iteracion), Newton-Raphson y Aitken (aceleracion).

fprintf('\n==========================================\n');
fprintf('\tMETODOS NUMERICOS\n');
fprintf('============================================\n');
fprintf('1. Punto fijo (iteracion)\n');
fprintf('2. Newton-Raphson\n');
fprintf('3. Aitken (aceleracion de punto fijo)\n');

opcion = NaN;
while (true)
  opcion = str2double(input('Elija el metodo (1-3): ', 's'));
  if (isscalar(opcion) && any(opcion == [1, 2, 3]))
    break;
  endif
  disp('Opcion invalida, ingrese 1, 2 o 3');
endwhile

% Carga de la funcion segun el metodo elegido.
% Para Newton se pide F (busca F(x) = 0); para punto fijo/Aitken se pide g (itera x = g(x))
% mas la F original (para mostrar donde F(x) = 0).
% OJO: usar operadores elemento a elemento (.*, ./) para que el grafico evalue vectores.
disp('Nota: en las funciones usar ./ y .* (ej: 400./(500-x)), no / ni * solos.');
if (opcion == 2)
  % Se reintenta hasta que la expresion parsea como funcion de x.
  while (true)
    expr = input("Ingrese F(x) en terminos de x (ej: x.^2 - 2): ", "s");
    try
      F = str2func(["@(x) " expr]);
      break;
    catch
      disp("Funcion invalida, revise la sintaxis (ej: x.^2 - 2)");
    end_try_catch
  endwhile
  G = F; % Newton trabaja directo sobre F, no hay funcion de iteracion separada
else
  while (true)
    expr = input("Ingrese g(x) en terminos de x (ej: 200 + 40*log(400./(500-x))): ", "s");
    try
      G = str2func(["@(x) " expr]);
      break;
    catch
      disp("Funcion invalida, revise la sintaxis (ej: 200 + 40*log(400./(500-x)))");
    end_try_catch
  endwhile
  while (true)
    expr = input("Ingrese F(x) original en terminos de x (ej: 5*x - 200*log(400./(500-x)) - 1000): ", "s");
    try
      F = str2func(["@(x) " expr]);
      break;
    catch
      disp("Funcion invalida, revise la sintaxis");
    end_try_catch
  endwhile
endif

% Tanteo opcional: barre F buscando cambios de signo y sugiere un x0.
% Se aplica sobre F original (busca F(x) = 0), no sobre g.
hacer_tanteo = input('¿Hacer tanteo para ubicar la raiz? (s/n): ', 's');
x0_sugerido = [];
if (lower(hacer_tanteo) == 's')
  intervalos = tanteo(F);
  if (!isempty(intervalos))
    x0_sugerido = mean(intervalos(1, :)); % punto medio del primer intervalo hallado
  endif
endif

% Parametros comunes a todos los metodos, con validacion de tipos.
if (isempty(x0_sugerido))
  while (true)
    x0 = str2double(input('Ingrese el valor inicial x0 (ej: 0): ', 's'));
    if (isscalar(x0) && isfinite(x0))
      break;
    endif
    disp('x0 debe ser un numero');
  endwhile
else
  while (true)
    txt = input(sprintf('Ingrese x0 (Enter para usar el sugerido %.4f): ', x0_sugerido), 's');
    if (isempty(txt))
      x0 = x0_sugerido;
      break;
    endif
    x0 = str2double(txt);
    if (isscalar(x0) && isfinite(x0))
      break;
    endif
    disp('x0 debe ser un numero');
  endwhile
endif
while (true)
  tol = str2double(input('Ingrese la tolerancia (ej: 0.0001): ', 's'));
  if (isscalar(tol) && isfinite(tol) && tol > 0)
    break;
  endif
  disp('La tolerancia debe ser un numero positivo');
endwhile

% Llamada al metodo elegido: los 3 devuelven (raiz, iteraciones, flag de convergencia).
switch (opcion)
  case 1 % punto fijo: itera x = g(x)
    [x_raiz, iter, convergio] = iteracion(G, F, x0, tol);
    nombre = "Punto fijo";
  case 2 % Newton: itera con F y su derivada aproximada
    [x_raiz, iter, convergio] = newton_raphson(F, x0, tol);
    nombre = "Newton-Raphson";
  case 3 % Aitken: acelera la iteracion x = g(x)
    [x_raiz, iter, convergio] = aceleracion(G, F, x0, tol);
    nombre = "Aitken";
  otherwise
    disp("Opcion invalida");
    return;
endswitch

if (!convergio)
  printf("%s no converge para ese x0\n", nombre);
  return;
endif

% Muestra del resultado en consola.
printf("\n>>> %s: raiz aproximada: %.4f\n", nombre, x_raiz);
printf(">>> Cantidad de iteraciones: %d\n", iter);

% Grafico unico: la funcion original F(x) contra y = 0, con la raiz marcada.
% Vale para los 3 metodos porque los 3 devuelven la raiz de F(x) = 0.
% Rango del grafico con validacion: numeros con maximo mayor que minimo.
while (true)
  x_min = str2double(input('Ingrese el limite inferior de x para graficar (ej: 0): ', 's'));
  x_max = str2double(input('Ingrese el limite superior de x para graficar (ej: 300): ', 's'));
  if (isscalar(x_min) && isfinite(x_min) && isscalar(x_max) && isfinite(x_max) && x_max > x_min)
    break;
  endif
  disp('Rango invalido: deben ser numeros con el superior mayor que el inferior');
endwhile

hFig = figure('Name', ["Grafico de " nombre]);
fplot(F, [x_min, x_max], 'b-', 'LineWidth', 2);
grid on;
hold on;
% Eje horizontal en y = 0 para ver el cruce por cero
plot([x_min, x_max], [0, 0], 'r--', 'LineWidth', 1.5);
% Marca de la raiz sobre la funcion original y sobre el eje
plot(x_raiz, F(x_raiz), 'ko', 'MarkerSize', 8, 'LineWidth', 2);
plot(x_raiz, 0, 'kx', 'MarkerSize', 8, 'LineWidth', 2);
title(["Función original F(x) - " nombre]);
xlabel('x');
ylabel('F(x)');
legend({"F(x)", "y = 0", "F(raiz)", "raiz"}, "Location", "northeast");
hold off;
drawnow;
% Se queda frenado hasta que cerras la ventana del grafico (no hace falta tocar teclas).
waitfor(hFig);