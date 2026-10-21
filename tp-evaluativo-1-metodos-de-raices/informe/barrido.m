% BARRIDO - Compara los tres metodos sobre el problema de la Guia 3.
%
% Corre cada metodo con tres tolerancias, repite N veces para promediar el
% tiempo de ejecucion y emite el resultado como tabla markdown.
%
% Las funciones de metodo imprimen su tabla de iteraciones en cada llamada.
% Para que ese ruido no ensucie la tabla final, todo el stdout se descarta
% (redirigido a /dev/null por generar.py) y el resultado se escribe por stderr.
%
% Uso: octave-cli --no-window-system barrido.m > /dev/null

base = fileparts(fileparts(mfilename('fullpath')));  % carpeta del TP
addpath(base);

F = @(x) 5*x - 200*log(400./(500-x)) - 1000;
G = @(x) 200 + 40*log(400./(500-x));

x0 = 200;
N = 20000;
tolerancias = [0.05 0.002 0.0001];
nombres = {'Punto fijo', 'Newton-Raphson', 'Aitken'};

fprintf(stderr, '| Método | Tolerancia | Iteraciones | Raíz | Tiempo prom. (ms) | Tiempo/iter. (ms) |\n');
fprintf(stderr, '| :--- | ---: | ---: | ---: | ---: | ---: |\n');

for m = 1:3
  for k = 1:numel(tolerancias)
    tol = tolerancias(k);

    % Calentamiento: la primera llamada paga la compilacion del interprete.
    switch m
      case 1, [~, ~, ~] = iteracion(G, F, x0, tol);
      case 2, [~, ~, ~] = newton_raphson(F, x0, tol);
      case 3, [~, ~, ~] = aceleracion(G, F, x0, tol);
    endswitch

    t = tic;
    for repeticion = 1:N
      switch m
        case 1, [raiz, iter, conv] = iteracion(G, F, x0, tol);
        case 2, [raiz, iter, conv] = newton_raphson(F, x0, tol);
        case 3, [raiz, iter, conv] = aceleracion(G, F, x0, tol);
      endswitch
    endfor
    ms = toc(t) / N * 1000;

    if (!conv)
      error('barrido: %s no convergio con tolerancia %g', nombres{m}, tol);
    endif

    fprintf(stderr, '| %s | %g | %d | %.6f | %.3f | %.3f |\n', ...
            nombres{m}, tol, iter, raiz, ms, ms / iter);
  endfor
endfor
