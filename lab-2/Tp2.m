
#EJERCICIO 1
#{
p = pi;
p_calc = 22/7;
errAbs = abs(p - p_calc);
errRelativo = errAbs / p;

printf("El error absoluto es: %f\n", errAbs);
printf("El error relativo es: %f\n", errRelativo);
#}
clc; clear;

#EJERCICIO 2
format long g


function [exponente, resultado]= normalizar(numero)
  exponente = 0;
  resultado = 0;
  if numero == 0 return;
  endif
  
  resultado = numero;
  while abs(resultado) >= 1
    exponente = exponente + 1;
    resultado = resultado / 10;
  endwhile
  
  while abs(resultado) < 0.1
    exponente = exponente - 1;
    resultado = resultado * 10;
  endwhile
endfunction

function resultado = redondear(numero)
  [exponente, r] = normalizar(numero);
  redondeado = round(r * 10^3) / 10^3;
  resultado =  redondeado * 10^exponente; 
endfunction

function resultado = truncar(numero)
  [exponente, r] = normalizar(numero);
  truncado = fix(r * 10^3) / 10^3;
  resultado = truncado * 10^exponente; 
endfunction

function errorAbs = errorAbsoluto(v_exacto, v_calculado)
  errorAbs = abs(v_exacto - v_calculado);
endfunction

function errorRelativo = errorRelativo(v_exacto, v_calculado)
  errorRelativo = errorAbsoluto(v_exacto, v_calculado) / v_exacto;
endfunction

#{
a = 133.921;
a_calc = redondear(133) + redondear(0.921);
a_redondeado = redondear(a_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f | Error Relativo: %f\n", a, a_redondeado, errorAbsoluto(a, a_redondeado), errorRelativo(a, a_redondeado));

b = 132.499;
b_calc = 133 - 0.501;
b_redondeado = redondear(b_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f | Error Relativo: %f\n", b, b_redondeado, errorAbsoluto(b, b_redondeado), errorRelativo(b, b_redondeado));

c = 1.673;
c_calc = redondear(121 - 119) - redondear(0.327);
c_redondeado = redondear(c_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f | Error Relativo: %f\n", c, c_redondeado, errorAbsoluto(c, c_redondeado), errorRelativo(c, c_redondeado));

d = 1.673;
d_calc = redondear(121 - 0.327) - redondear(119);
d_redondeado = redondear(d_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f | Error Relativo: %f\n", d, d_redondeado, errorAbsoluto(d, d_redondeado), errorRelativo(d, d_redondeado));

e = 0.28571;
e_calc = redondear(2/9)*redondear(9/7);
e_redondeado = redondear(e_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f | Error Relativo: %f\n", e, e_redondeado, errorAbsoluto(e, e_redondeado), errorRelativo(e, e_redondeado));
#}

#EJERCICIO 3
#{
a = 133.921;
a_calc = truncar(133) + truncar(0.921);
a_truncado = truncar(a_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f\n", a, a_truncado, errorAbsoluto(a, a_truncado));

b = 132.499;
b_calc = 133 - 0.501;
b_truncado = truncar(b_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f\n", b, b_truncado, errorAbsoluto(b, b_truncado));

c = 1.673;
c_calc = truncar(121 - 119) - truncar(0.327);
c_truncado = truncar(c_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f\n", c, c_truncado, errorAbsoluto(c, c_truncado));

d = 1.673;
d_calc = truncar(121 - 0.327) - truncar(119);
d_truncado = truncar(d_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f\n", d, d_truncado, errorAbsoluto(d, d_truncado));

e = 0.28571;
e_calc = truncar(2/9)*truncar(9/7);
e_truncado = truncar(e_calc);
printf("Valor exacto: %f | Valor calculado: %f | ErrorAbs: %f\n", e, e_truncado, errorAbsoluto(e, e_truncado));
#}

#EJERCICIO 4
#{
#x 2 + 62.10x + 1 = 0
a = 1;
b = 62.10;
c = 1;

function [x1, x2] = calcularRaices(a,b,c)
  paso1 = redondear(b^2);
  paso2 = redondear(4*a);
  paso3 = redondear(paso2*c);
  paso4 = redondear(paso1-paso3);
  paso5 = redondear(sqrt(paso4));
  paso6 = redondear(-b+paso5);
  x1 = redondear(paso6/2*a);
  paso6 = redondear(-b-paso5);
  x2 = redondear(paso6/2*a);
endfunction


[x1, x2] = calcularRaices(a,b,c)
#}

#x3 - 6 x2 + 3x – 0.149
#x(x(x-6)+1) - 0.149

x = 4.71;
x*(x*(x-6)+3) - 0.149
x^3-6*x^2 + 3*x - 0.149

paso1= redondear(x^3);
paso2 = redondear(x^2);
paso3 = redondear(3*x);
paso4 = redondear(6*paso2);
paso5 = redondear(paso1-paso4);
paso6 = redondear(paso5+paso3);
paso7 = redondear(paso6-0.149)

paso1 = redondear(x-6);
paso2 = redondear(x*paso1);
paso3 = redondear(paso2 + 3);
paso4 = redondear(x*(paso3));
paso5 = redondear(paso4 - 0.149)








