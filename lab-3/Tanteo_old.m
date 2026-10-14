#Tanteo

function Tanteo(f)
  % Ingreso de datos por teclado
  disp('--- METODO DE TANTEO ---');
  a = input('Ingrese el extremo inferior del intervalo (a): '); % ej: 2.0
  b = input('Ingrese el extremo superior del intervalo (b): '); % ej: 2.5 o 3.0

  delta_x = input('Ingrese el valor del incremento delta_x (ej. 0.5 o 0.1): ');

  % Algoritmo de Tanteo
  x_min = a;
  x_max = b;

  x_act = x_min;
  f_act = f(x_act);

  fprintf('\n--- Tabla de Valores del Método de Tanteo ---\n');
  fprintf('%-10s %-15s\n', 'x', 'f(x)');
  fprintf('%-10.4f %-15.4f\n', x_act, f_act);

  intervalos_encontrados = [];

while (x_act + delta_x) <= x_max
    x_sig = x_act + delta_x;
    f_sig = f(x_sig);
    fprintf('%-10.4f %-15.4f\n', x_sig, f_sig);

    if (f_act * f_sig) <= 0
        fprintf('>>> Se detectó cambio de signo en el intervalo: [%.4f, %.4f]\n', x_act, x_sig);
        intervalos_encontrados = [intervalos_encontrados; x_act, x_sig];
    end

    x_act = x_sig;
    f_act = f_sig;
    end

if isempty(intervalos_encontrados)
    disp('No se encontraron cambios de signo en el rango analizado.');
  else
    fprintf('\nRaíz separada con éxito para el paso siguiente en el intervalo:\n');
    fprintf('[%g, %g]\n', intervalos_encontrados');

  endif
endfunction