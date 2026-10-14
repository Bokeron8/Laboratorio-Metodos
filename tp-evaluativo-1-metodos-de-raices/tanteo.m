function intervalos = tanteo(f)
  % TANTEO - Separa raices barriendo [a, b] con paso delta_x y detectando cambios de signo.
  % Entrada:
  %   f - funcion a la que se le buscan raices, ej: @(x) x.^2 - 2
  % Salida:
  %   intervalos - matriz de Nx2 con los [a, b] donde f cambia de signo (vacia si no hay)
  % Nota: pide a, b y delta_x por teclado; el que llama usa los intervalos para elegir x0.
  % Ingreso de datos por teclado con validacion: a y b numeros con b > a.
  disp('--- METODO DE TANTEO ---');
  while (true)
    a = str2double(input('Ingrese el extremo inferior del intervalo (a): ', 's')); % ej: 2.0
    b = str2double(input('Ingrese el extremo superior del intervalo (b): ', 's')); % ej: 2.5 o 3.0
    if (isscalar(a) && isfinite(a) && isscalar(b) && isfinite(b) && b > a)
      break;
    endif
    disp('Rango invalido: a y b deben ser numeros con b mayor que a');
  endwhile

  % El paso debe ser un numero positivo menor que el ancho del intervalo.
  while (true)
    delta_x = str2double(input('Ingrese el valor del incremento delta_x (ej. 0.5 o 0.1): ', 's'));
    if (isscalar(delta_x) && isfinite(delta_x) && delta_x > 0 && delta_x <= (b - a))
      break;
    endif
    disp('Paso invalido: debe ser un numero positivo no mayor que (b - a)');
  endwhile

  % Punto de partida: se arranca en el extremo inferior.
  x_min = a;
  x_max = b;

  x_act = x_min;
  f_act = f(x_act);

  % Tabla de valores: muestra como evoluciona f en el barrido.
  fprintf('\n--- Tabla de Valores del Método de Tanteo ---\n');
  fprintf('%-10s %-15s\n', 'x', 'f(x)');
  fprintf('%-10.4f %-15.4f\n', x_act, f_act);

  % Acumulador de intervalos con cambio de signo: cada fila es un [x_act, x_sig].
  intervalos_encontrados = [];

  % Barrido: se avanza de a delta_x hasta cubrir [a, b].
  while (x_act + delta_x) <= x_max
    x_sig = x_act + delta_x; % siguiente punto del barrido
    f_sig = f(x_sig);
    fprintf('%-10.4f %-15.4f\n', x_sig, f_sig);

    % Si f cambia de signo (o toca cero) hay una raiz entre x_act y x_sig.
    if (f_act * f_sig) <= 0
      fprintf('>>> Se detectó cambio de signo en el intervalo: [%.4f, %.4f]\n', x_act, x_sig);
      intervalos_encontrados = [intervalos_encontrados; x_act, x_sig];
    endif

    x_act = x_sig; % se avanza al siguiente punto
    f_act = f_sig;
  endwhile

  % Informe final: lista los intervalos hallados o avisa si no hubo ninguno.
  if isempty(intervalos_encontrados)
    disp('No se encontraron cambios de signo en el rango analizado.');
  else
    fprintf('\nRaíz separada con éxito para el paso siguiente en el intervalo:\n');
    fprintf('[%g, %g]\n', intervalos_encontrados');
  endif

  % Se devuelven los intervalos para que el que llama elija x0 dentro de uno.
  intervalos = intervalos_encontrados;
endfunction