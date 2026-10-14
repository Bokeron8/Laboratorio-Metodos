#Ejercicio 1
#{
N = input("Ingresa cantidad de numeros: ");
total = 0;
for i=1:1:N
    numero = input("Ingrese el valor a sumar: ");
    total = total + numero;
 endfor
 
 printf("Suma total es:  %d\n", total);
 printf("Tiempo de ejecucion: %.2fms", cputime);
 #}
 
 #Ejercicio 2
 #{
 N = 5;
 total = 0;
 for i=1:1:N
   x = input("Ingrese el valor a sumar: ");
   if(x > 0 && mod(x, 2) == 0);
    total = total + x;
   end 
 endfor
 printf("Suma total es:  %d\n", total);
 printf("Tiempo de ejecucion: %.2fms", cputime);
 #}

#Ejercicio 3
#{  
n = input("Ingrese que termino de Fibonacci quiere conocer: ");
printf("%d termindo de fibonacci: %d\n", n, fibonacci(n));
#}

# Ejercicio 4
#3*x + 1 = (5 * x) + 3 * (x^2)

#{
y = "3 * x^2 + 2*x - 1";
a=3;
b=2;
c=-1; 
x1 = (-b+sqrt(b^2-4*a*c))/(2*a);
y1 = 3 * x1^2 + 2*x1 - 1;
x2 = (-b-sqrt(b^2-4*a*c))/(2*a);
y2 = 3 * x2^2 + 2*x2 - 1;

verificacion1_1 = 3*x1 + 1;
verificacion1_2 = 5*x1 + 3 * x1^2;

verificacion2_1 = 3*x2 + 1;
verificacion2_2 = 5*x2 + 3 * x2^2;

x = [x1, x2];
yraiz = [y1, y2];

f=inline(y);
plot(x1,yraiz, 'rx');
hold on;
grafica1=ezplot(f);
set(grafica1,'color','r');
grid on;
ylabel('y');
xlabel('x');
title('Grafico de funciones de f(x)');

printf("x1: %d\n", x1);
printf("x2: %d\n", x2);
printf("y1: %d\n", y1);
printf("y2: %d\n", y2);
#}
#EJERCICIO 5
#{
n = input('Ingrese cuantos terminos de la serie calcular: ');
total = 1;
for i=1:1:n;
  total = total + 1/factorial(i);
endfor;

printf("Resultado: %f\n", total);
#}

#EJERCICIO 6

#{
#n = input("Ingrese cantidad de terminos para calcular pi: ");
terminos = input("Ingrese cantidad de decimales: ");
valor_pi = fix(pi * 10 * terminos) / 100;
total = 0;
contador = 1;
for i=1:1:n
  if mod(i, 2) == 0
    total = total - fix(1 / contador * 10*terminos) / 100;
  else 
    total = total + 1 / fix(1 / contador * 10*terminos) / 100;
  endif
  contador = contador + 2;
endfor

#3 digito 613
#4 digito 1690
#5 digitos 10800
pi = 4 * total;
printf("PI = %f\n", pi)
printf("Tiempo de ejecucion: %.2fms", cputime)
#}




