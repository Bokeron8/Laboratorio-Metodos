function intervalos = tanteo(f, a, b)
  % TANTEO - Separa raíces barriendo [a, b] con paso delta_x y detectando cambios
  % de signo.
  % Entradas:
  %   f - función a la que se le buscan raíces, ej: @(x) x.^2 - 2
  %   a - extremo inferior del barrido
  %   b - extremo superior del barrido
  % Salida:
  %   intervalos - matriz de Nx2 con los [a, b] donde f cambia de signo (vacía si no hay)
  if (nargin != 3)
    error("tanteo: se requieren 3 argumentos (f, a, b)");
  endif
  if (!isa(f, "function_handle"))
    error("tanteo: f debe ser un function_handle, ej: @(x) x.^2 - 2");
  endif

  disp('--- METODO DE TANTEO ---');

  % El paso debe ser un número positivo menor que el ancho del intervalo.
  while (true)
    delta_x = str2double(input('Ingrese el valor del incremento delta_x (ej. 0.5 o 0.1): ', 's'));
    if (isscalar(delta_x) && isfinite(delta_x) && delta_x > 0 && delta_x <= (b - a))
      break;
    endif
    disp('Paso invalido: debe ser un numero positivo no mayor que (b - a)');
  endwhile

  % Punto de partida: extremo inferior del rango.
  x_act = a;
  f_act = f(x_act);

  % Tabla de valores del barrido: x contra f(x).
  fprintf('\n--- Tabla de Valores del Método de Tanteo ---\n');
  fprintf('%-10s %-15s\n', 'x', 'f(x)');
  fprintf('%-10.4f %-15.4f\n', x_act, f_act);

  % Cada fila acumulada es un [x_act, x_sig] con cambio de signo.
  intervalos_encontrados = [];

  % Barrido de [a, b] con paso delta_x.
  while (x_act + delta_x) <= b
    x_sig = x_act + delta_x; % siguiente punto del barrido
    f_sig = f(x_sig);
    fprintf('%-10.4f %-15.4f\n', x_sig, f_sig);

    % Si f cambia de signo (o toca cero) hay una raíz entre x_act y x_sig.
    if (f_act * f_sig) <= 0
      fprintf('>>> Se detectó cambio de signo en el intervalo: [%.4f, %.4f]\n', x_act, x_sig);
      intervalos_encontrados = [intervalos_encontrados; x_act, x_sig];
    endif

    x_act = x_sig; % se avanza al siguiente punto
    f_act = f_sig;
  endwhile

  % Resumen del barrido.
  if isempty(intervalos_encontrados)
    disp('No se encontraron cambios de signo en el rango analizado.');
  else
    fprintf('\nRaíz separada con éxito para el paso siguiente en el intervalo:\n');
    fprintf('[%g, %g]\n', intervalos_encontrados');
  endif

  intervalos = intervalos_encontrados;
endfunction
