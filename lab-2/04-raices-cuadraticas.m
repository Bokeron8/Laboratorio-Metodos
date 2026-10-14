% 04-raices-cuadraticas.m - Ejercicio 4 de la Guía 2: raíces de una cuadrática.
%
% Problema: las raíces de ax^2 + bx + c = 0 son
%   x1 = (-b + sqrt(b^2 - 4ac)) / (2a)
%   x2 = (-b - sqrt(b^2 - 4ac)) / (2a)
% Considerando x^2 + 62.10x + 1 = 0, y sabiendo que los valores de referencia
% son x1 = -0.01610723 y x2 = -62.08390:
%
% Estructura de la consigna:
%   a) Calcular x1 y x2 con redondeo a cuatro dígitos, normalizando los valores
%      con que se trabaja. Calcular los errores absolutos y relativos.
%   b) Racionalizar el numerador de la fórmula para obtener una forma
%      alternativa más precisa de x1, y obtener también una forma alternativa
%      de x2. Comparar los errores de las nuevas aproximaciones.
%
% Modelo matemático: Delta = b^2 - 4ac = 62.10^2 - 4 = 3852.41, y
% sqrt(Delta) = 62.0677855... El detalle que hace interesante el ejercicio es que
% las dos raíces son de magnitud muy distinta: una es casi cero y la otra es
% casi -62.10.
%
% En la fórmula directa, el numerador de x1 es -b + sqrt(Delta) = -62.1 + 62.0678
% = -0.0322: es una resta de dos números casi iguales, o sea una resta
% catastrófica. Se restan cuatro dígitos para obtener un número de un solo
% dígito, y quedan pocos dígitos correctos. En cambio el numerador de x2 es
% -b - sqrt(Delta) = -124.17: es una suma de magnitudes, sin cancelación.
%
% Racionalizando el numerador:
%   x1 = (-b + sqrt(Delta)) / (2a)
% Se multiplica numerador y denominador por el conjugado (-b - sqrt(Delta)):
%   x1 = [(-b + sqrt(Delta))(-b - sqrt(Delta))] / [2a(-b - sqrt(Delta))]
%      = [b^2 - Delta] / [2a(-b - sqrt(Delta))]
%      = [4ac] / [2a(-b - sqrt(Delta))]
%      = 2c / (-b - sqrt(Delta))
% y, simétricamente para la otra raíz:
%   x2 = 2c / (-b + sqrt(Delta))
%
% O sea: la resta catastrófica que estaba en el NUMERADOR de x1 se muda al
% DENOMINADOR de x2. La cancelación no se elimina, se cambia de lado. Por eso la
% forma racionalizada es la buena para x1 y la mala para x2, exactamente al
% revés que la forma directa. Ninguna de las dos formas sirve para las dos
% raíces.
%
% Corrección respecto de la versión anterior: el código escribía
% "redondear(paso6/2*a)". En Octave / y * tienen la MISMA prioridad y se
% evalúan de izquierda a derecha, así que eso es (paso6/2)*a y no
% paso6/(2*a). Con a = 1 el error no se nota, pero con a = 3 daría 15 en lugar
% de 1.667. Se escribe siempre paso6/(2*a), con el paréntesis explícito.
%
% El redondeo vive en redondear.m y depende de normalizar.m.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
a = 1;
b = 62.10;
c = 1;

% Valores de referencia dados por la consigna.
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
% Se calcula el discriminante con aritmética de cuatro dígitos para mostrar de
% entrada cuánto se pierde desde el principio.
delta = redondear(b^2 - 4 * a * c);
sqrt_delta = redondear(sqrt(delta));

fprintf('\n--- Discriminante con redondeo a %d dígitos ---\n', digitos);
fprintf('b^2 = %.10g   ->  redondeado = %-10.10g\n', b^2, redondear(b^2));
fprintf('4ac = %.10g   ->  redondeado = %-10.10g\n', 4 * a * c, redondear(4 * a * c));
fprintf('Delta exacto = %.10g  ->  redondeado = %-10.10g\n', b^2 - 4 * a * c, delta);
fprintf('sqrt(Delta) exacto = %.10g  ->  redondeado = %-10.10g\n', ...
        sqrt(b^2 - 4 * a * c), sqrt_delta);
fprintf('Valor exacto de la referencia -b = %.10g\n', -b);

% ----------------------------------------------------------------------
% a) Fórmula directa
% ----------------------------------------------------------------------
fprintf('\n--- a) Fórmula directa, con redondeo a %d dígitos ---\n', digitos);

% x1 = (-b + sqrt(Delta)) / (2a)
paso1 = redondear(-b);
paso2 = redondear(-b + sqrt_delta);
x1_directa = redondear(paso2 / (2 * a));

% x2 = (-b - sqrt(Delta)) / (2a)
paso3 = redondear(-b - sqrt_delta);
x2_directa = redondear(paso3 / (2 * a));

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
r1_numerador = redondear(2 * c);
r1_denominador = redondear(-b - sqrt_delta);
x1_racionalizada = redondear(r1_numerador / r1_denominador);

% x2 = 2c / (-b + sqrt(Delta))
r2_numerador = redondear(2 * c);
r2_denominador = redondear(-b + sqrt_delta);
x2_racionalizada = redondear(r2_numerador / r2_denominador);

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

% Se calculan los cuatro errores una vez y se reutilizan en la tabla y en las
% conclusiones, para que los números citados no puedan desincronizarse.
err_x1_directa = error_absoluto(referencia_x1, x1_directa);
err_x1_racionalizada = error_absoluto(referencia_x1, x1_racionalizada);
err_x2_directa = error_absoluto(referencia_x2, x2_directa);
err_x2_racionalizada = error_absoluto(referencia_x2, x2_racionalizada);

% La ganadora es la de menor error absoluto. El texto se arma acá porque
% Octave no permite llamar a una funcion definida mas abajo en un script.
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
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('Este es el punto central del ejercicio: NO hay una fórmula mejor que la\n');
fprintf('otra. Cada una es precisa para una raíz y mala para la otra.\n');

fprintf('\nLa raíz CHICA, x1 = %.8f, se gana con la forma RACIONALIZADA.\n', referencia_x1);
fprintf('En la fórmula directa su numerador es -b + sqrt(Delta) = -%.2f + %.8f,\n', ...
        b, sqrt(b^2 - 4 * a * c));
fprintf('o sea %.8f: una resta de dos números casi iguales cuyo resultado es un\n', ...
        -b + sqrt(b^2 - 4 * a * c));
fprintf('número diminuto. Ahí se pierde casi toda la precisión: con cuatro dígitos\n');
fprintf('el numerador queda en %.10g y la raíz sale en %.10g.\n', paso2, x1_directa);
fprintf('Al racionalizar, ese mismo numerador se convierte en el DENOMINADOR de x2,\n');
fprintf('y x1 pasa a ser 2c / (-b - sqrt(Delta)) = %.2f / %.8f, un cociente entre\n', ...
        2 * c, -b - sqrt(b^2 - 4 * a * c));
fprintf('números de magnitud parecida, sin cancelación alguna. El error cae de\n');
fprintf('%.4e a %.4e.\n', err_x1_directa, err_x1_racionalizada);

fprintf('\nLa raíz GRANDE, x2 = %.5f, se PIERDE con la forma racionalizada.\n', referencia_x2);
fprintf('Su numerador en la fórmula directa es -b - sqrt(Delta) = %.8f, una suma de\n', ...
        -b - sqrt(b^2 - 4 * a * c));
fprintf('magnitudes donde no hay nada que cancelar, y por eso x2 sale bastante\n');
fprintf('bien: %.10g. Pero al racionalizar, el denominador pasa a ser\n', x2_directa);
fprintf('-b + sqrt(Delta) = %.8f, que es justamente la resta catastrófica. Con la\n', ...
        -b + sqrt(b^2 - 4 * a * c));
fprintf('aritmética de cuatro dígitos ese denominador queda en %.10g, que es un\n', r2_denominador);
fprintf('orden de magnitud entero, y dividir 2 por eso da %.10g en vez de %.5f.\n', ...
        x2_racionalizada, referencia_x2);

fprintf('\nLa razón de fondo: la resta catastrófica no se elimina, se muda de lado.\n');
fprintf('En la fórmula directa vive en el numerador de x1; en la racionalizada vive\n');
fprintf('en el denominador de x2. Racionalizar no agrega información, solo reparte\n');
fprintf('la misma resta en otro lugar.\n');
fprintf('\nLa moraleja práctica: cuando una cuadrática tiene dos raíces de magnitud\n');
fprintf('muy distinta, hay que elegir la forma que evita la resta catastrófica para\n');
fprintf('cada una por separado, o calcular una raíz con la forma segura y obtener\n');
fprintf('la otra con el producto de las raíces, x1 * x2 = c/a, que para este caso\n');
fprintf('daría %.8f y no sufre ninguna resta.\n', c / a * referencia_x2);
fprintf('\nLa consigna pide comparar los errores "a partir de las nuevas\n');
fprintf('aproximaciones", y la comparación muestra que la mejora de una raíz se\n');
fprintf('paga exactamente con el empeoramiento de la otra. Ese intercambio es la\n');
fprintf('respuesta, no un defecto del método.\n');
