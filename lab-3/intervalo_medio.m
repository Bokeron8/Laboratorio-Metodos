% intervalo_medio.m
function [raiz, iter, a, b] = intervalo_medio(f, a, b)
  err_limite = 0.001;
  err_actual = calcular_error(a, b);
  iter = 0;
  while (err_actual > err_limite)
    x = (a + b) / 2;
  
    f_inf = f(a);
    f_act = f(x);
    raiz = x;

    if(f_inf * f_act < 0)
      b = x;
    elseif (f_inf * f_act > 0)
      a = x;
    else 
      return;
    endif

    err_actual = calcular_error(a, b);
    iter++;
  endwhile
endfunction

function err = calcular_error(a, b)
  err = abs(b - a) / abs(b);
endfunction