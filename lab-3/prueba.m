f=input('Ingrese la funcion f(x):'); %Funcion principal
g=input('Ingrese la funcion g(x):');
f=inline(f)
g=inline(g)
hold on
grafica1=ezplot(f);
set(grafica1,'color','r')
grafica2=ezplot(g);
set(grafica2,'color', 'g','linewidth',2)
grid on
ylabel('y')
xlabel('x')
title('Grafico de funciones de f(x) y g(x)')