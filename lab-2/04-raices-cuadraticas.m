% 04-raices-cuadraticas.m - Ejercicio 4 de la Guía 2: raíces de una cuadrática.
%
% Para x^2 + 62.10x + 1 = 0, con referencias x1 = -0.01610723 y
% x2 = -62.08390, se calculan las raíces con la fórmula directa
%   x1 = (-b + sqrt(Delta)) / (2a),  x2 = (-b - sqrt(Delta)) / (2a)
% redondeando a cuatro dígitos, y luego con el numerador racionalizado
%   x1 = 2c / (-b - sqrt(Delta)),  x2 = 2c / (-b + sqrt(Delta)).
%
% Delta = b^2 - 4ac = 3852.41 y sqrt(Delta) = 62.0677855... El numerador de x1
% es -b + sqrt(Delta) = -0.0322: una resta de números casi iguales que destruye
% cifras significativas. Racionalizar traslada esa cancelación al denominador de
% x2, así que cada forma es buena para una raíz y mala para la otra.
%
% La división por 2a lleva paréntesis explícito: en Octave / y * tienen la misma
% prioridad y se evalúan de izquierda a derecha.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
a = 1;
b = 62.10;
c = 1;

% Valores de referencia dados por el problema.
referencia_x1 = -0.01610723;
referencia_x2 = -62.08390;

% Cantidad de dígitos con que se trabaja en la parte a).
digitos = 4;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 4 - RAÍCES DE UNA ECUACIÓN CUADRÁTICA\n');
fprintf('========================================================\n');
fprintf('Ecuación:  x^2 + %.2f x + 1 = 0\n', b);
fprintf('Referencias:  x1 = %.8f   x2 = %.8f\n', referencia_x1, referencia_x2);

% ----------------------------------------------------------------------
% Valores de partida
% ----------------------------------------------------------------------
% Se calcula el discriminante con aritmética de cuatro dígitos para ver cuánto
% se pierde desde el principio.
delta = redondear(b^2 - 4 * a * c, digitos);
sqrt_delta = redondear(sqrt(delta), digitos);

fprintf('\n--- Discriminante con redondeo a %d dígitos ---\n', digitos);
fprintf('b^2 = %.10g   ->  redondeado = %-10.10g\n', b^2, redondear(b^2, digitos));
fprintf('4ac = %.10g   ->  redondeado = %-10.10g\n', 4 * a * c, redondear(4 * a * c, digitos));
fprintf('Delta exacto = %.10g  ->  redondeado = %-10.10g\n', b^2 - 4 * a * c, delta);
fprintf('sqrt(Delta) exacto = %.10g  ->  redondeado = %-10.10g\n', ...
        sqrt(b^2 - 4 * a * c), sqrt_delta);
fprintf('Valor exacto de la referencia -b = %.10g\n', -b);

% ----------------------------------------------------------------------
% a) Fórmula directa
% ----------------------------------------------------------------------
fprintf('\n--- a) Fórmula directa, con redondeo a %d dígitos ---\n', digitos);

% x1 = (-b + sqrt(Delta)) / (2a)
paso1 = redondear(-b, digitos);
paso2 = redondear(-b + sqrt_delta, digitos);
x1_directa = redondear(paso2 / (2 * a), digitos);

% x2 = (-b - sqrt(Delta)) / (2a)
paso3 = redondear(-b - sqrt_delta, digitos);
x2_directa = redondear(paso3 / (2 * a), digitos);

fprintf('\nx1 = (-b + sqrt(Delta)) / (2a)\n');
fprintf('  -b                       = %-12.10g\n', paso1);
fprintf('  -b + sqrt(Delta)         = %-12.10g   <-- resta de dos numeros casi iguales\n', paso2);
fprintf('  x1 = ese valor / (2a)    = %-12.10g\n', x1_directa);

fprintf('\nx2 = (-b - sqrt(Delta)) / (2a)\n');
fprintf('  -b - sqrt(Delta)         = %-12.10g\n', paso3);
fprintf('  x2 = ese valor / (2a)    = %-12.10g\n', x2_directa);

fprintf('\nErrores de la fórmula directa:\n');
fprintf('%-6s %-14s %-14s %-14s %s\n', 'raíz', 'Calculada', 'Referencia', 'Error absoluto', 'Error relativo');
fprintf('%-6s %-14.8f %-14.8f %-14.4e %.4e\n', 'x1', x1_directa, referencia_x1, ...
        error_absoluto(referencia_x1, x1_directa), error_relativo(referencia_x1, x1_directa));
fprintf('%-6s %-14.8f %-14.8f %-14.4e %.4e\n', 'x2', x2_directa, referencia_x2, ...
        error_absoluto(referencia_x2, x2_directa), error_relativo(referencia_x2, x2_directa));

% ----------------------------------------------------------------------
% b) Fórmula con el numerador racionalizado
% ----------------------------------------------------------------------
fprintf('\n--- b) Numerador racionalizado ---\n');
fprintf('Multiplicando numerador y denominador por el conjugado:\n');
fprintf('  x1 = (-b + sqrt(Delta)) / (2a)  =  2c / (-b - sqrt(Delta))\n');
fprintf('  x2 = (-b - sqrt(Delta)) / (2a)  =  2c / (-b + sqrt(Delta))\n');

% x1 = 2c / (-b - sqrt(Delta))
r1_numerador = redondear(2 * c, digitos);
r1_denominador = redondear(-b - sqrt_delta, digitos);
x1_racionalizada = redondear(r1_numerador / r1_denominador, digitos);

% x2 = 2c / (-b + sqrt(Delta))
r2_numerador = redondear(2 * c, digitos);
r2_denominador = redondear(-b + sqrt_delta, digitos);
x2_racionalizada = redondear(r2_numerador / r2_denominador, digitos);

fprintf('\nx1 = 2c / (-b - sqrt(Delta))\n');
fprintf('  2c                    = %-12.10g\n', r1_numerador);
fprintf('  -b - sqrt(Delta)      = %-12.10g\n', r1_denominador);
fprintf('  x1                    = %-12.10g\n', x1_racionalizada);

fprintf('\nx2 = 2c / (-b + sqrt(Delta))\n');
fprintf('  2c                    = %-12.10g\n', r2_numerador);
fprintf('  -b + sqrt(Delta)      = %-12.10g\n', r2_denominador);
fprintf('  x2                    = %-12.10g\n', x2_racionalizada);

fprintf('\nErrores de la fórmula racionalizada:\n');
fprintf('%-6s %-14s %-14s %-14s %s\n', 'raíz', 'Calculada', 'Referencia', 'Error absoluto', 'Error relativo');
fprintf('%-6s %-14.8f %-14.8f %-14.4e %.4e\n', 'x1', x1_racionalizada, referencia_x1, ...
        error_absoluto(referencia_x1, x1_racionalizada), error_relativo(referencia_x1, x1_racionalizada));
fprintf('%-6s %-14.8f %-14.8f %-14.4e %.4e\n', 'x2', x2_racionalizada, referencia_x2, ...
        error_absoluto(referencia_x2, x2_racionalizada), error_relativo(referencia_x2, x2_racionalizada));

% ----------------------------------------------------------------------
% Comparación
% ----------------------------------------------------------------------
fprintf('\n--- Comparación de las dos formas ---\n\n');
fprintf('%-6s %-18s %-18s %s\n', 'raíz', 'Error abs. directa', 'Error abs. rac.', 'Ganadora');

% Se calculan los cuatro errores una vez y se reutilizan en la tabla.
err_x1_directa = error_absoluto(referencia_x1, x1_directa);
err_x1_racionalizada = error_absoluto(referencia_x1, x1_racionalizada);
err_x2_directa = error_absoluto(referencia_x2, x2_directa);
err_x2_racionalizada = error_absoluto(referencia_x2, x2_racionalizada);

% La ganadora es la de menor error absoluto. El texto se arma acá porque Octave
% no permite llamar a una función definida más abajo en un script.
if (err_x1_racionalizada < err_x1_directa)
  ganadora_x1 = 'racionalizada';
else
  ganadora_x1 = 'directa';
endif
if (err_x2_racionalizada < err_x2_directa)
  ganadora_x2 = 'racionalizada';
else
  ganadora_x2 = 'directa';
endif

fprintf('%-6s %-18.4e %-18.4e %s\n', 'x1', err_x1_directa, err_x1_racionalizada, ganadora_x1);
fprintf('%-6s %-18.4e %-18.4e %s\n', 'x2', err_x2_directa, err_x2_racionalizada, ganadora_x2);

fprintf('\nPara x1, la forma racionalizada mejora el error por un factor de %.4e\n', ...
        err_x1_directa / max(err_x1_racionalizada, eps));
fprintf('Para x2, la misma forma lo empeora por un factor de  %.4e\n', ...
        err_x2_racionalizada / max(err_x2_directa, eps));

% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('No existe una única fórmula óptima. La forma directa es precisa para la raíz grande,\n');
fprintf('mientras que la forma racionalizada (conjugada) evita la cancelación catastrófica para la raíz pequeña.\n');
fprintf('\nEl enunciado pide comparar los errores "a partir de las nuevas\n');
fprintf('aproximaciones", y la comparación muestra que la mejora de una raíz se\n');
fprintf('paga exactamente con el empeoramiento de la otra. Ese intercambio es la\n');
fprintf('respuesta, no un defecto del método.\n');
