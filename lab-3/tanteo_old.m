% tanteo.m
function intervalos_encontrados = tanteo(f, a, b, inc)
  x = a;
  f_act = f(x);

  fprintf('\n--- Tabla de Valores del Método de Tanteo ---\n');
  fprintf('%-10s %-15s\n', 'h', 'f(h)');
  fprintf('%-10.4f %-15.4f\n', x, f_act);

  intervalos_encontrados = [];

  while (x + inc) <= b
      x_sig = x + inc;
      f_sig = f(x_sig);
      fprintf('%-10.4f %-15.4f\n', x_sig, f_sig);

      if (f_act * f_sig) <= 0
          fprintf('>>> Se detectó cambio de signo en el intervalo: [%.4f, %.4f]\n', x, x_sig);
          intervalos_encontrados = [intervalos_encontrados; x, x_sig];
      end

      x = x_sig;
      f_act = f_sig;
  end
  
  if isempty(intervalos_encontrados)
    disp('No se encontraron cambios de signo en el rango analizado.');
  else
    fprintf('\nRaíz separada con éxito para el paso siguiente.\n');
    fprintf('[%g, %g]\n', intervalos_encontrados');
  end
endfunction
