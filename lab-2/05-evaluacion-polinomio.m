% 05-evaluacion-polinomio.m - Ejercicio 5 de la Guía 2: evaluación de un polinomio.
%
% Problema: evaluar
%   f(x) = x^3 - 6x^2 + 3x - 0.149
% en x = 4.71, usando aritmética de tres dígitos, consignando los valores en
% una tabla SIN NORMALIZARLOS, y calcular el error absoluto y el relativo.
% Luego reescribir la fórmula en forma anidada, recalcular los errores,
% analizar cómo crecen o disminuyen y emitir conclusión.
%
% Estructura de la consigna:
%   5.a) La tabla de tres filas (exacto / truncado / redondeado) con las
%        columnas x, x^2, x^3, 6x^2, 3x, f(x), error absoluto, error relativo.
%   5.b) La misma evaluación con la forma anidada x(x(x - 6) + 3) - 0.149.
%
% Modelo matemático: "tres dígitos" son tres dígitos SIGNIFICATIVOS. El
% resultado exacto de referencia es
%   f(4.71) = 104.487111 - 133.1046 + 14.13 - 0.149 = -14.636489
%
% Por qué truncar_n y redondear_n, y no truncar y redondear
% -------------------------------------------------------
% El enunciado dice explícitamente "sin normalizarlos". El punto 5.a usa por
% lo tanto truncar_n.m y redondear_n.m, que operan sobre la mantisa y no
% normalizan, y NO truncar.m y redondear.m, que sí normalizan. Son operaciones
% distintas y confundirlas fue el error que existía en la versión anterior de
% este ejercicio.
%
% Ojo también con el signo: f(4.71) es NEGATIVO. El error relativo se calcula
% con el valor absoluto del denominador, así que sale positivo; la versión
% anterior dividía por el valor con signo y obtenía un error relativo negativo,
% lo que no tiene sentido.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
x = 4.71;
digitos = 3;

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 5 - EVALUACIÓN DE UN POLINOMIO CON TRES DÍGITOS\n');
fprintf('========================================================\n');
fprintf('f(x) = x^3 - 6x^2 + 3x - 0.149,   x = %.2f\n', x);
fprintf('La consigna pide trabajar SIN normalizar los valores.\n');

% ----------------------------------------------------------------------
% 5.a) Forma directa
% ----------------------------------------------------------------------
fprintf('\n--- 5.a) Forma directa:  x^3 - 6x^2 + 3x - 0.149 ---\n');

% --- Fila exacta: sin ninguna aritmética de tres dígitos ---
ex_x2 = x^2;
ex_x3 = x^3;
ex_6x2 = 6 * x^2;
ex_3x = 3 * x;
ex_f = x^3 - 6 * x^2 + 3 * x - 0.149;

fprintf('\nFila exacta:\n');
fprintf('  x     = %.10g\n', x);
fprintf('  x^2   = %.10g\n', ex_x2);
fprintf('  x^3   = %.10g\n', ex_x3);
fprintf('  6x^2  = %.10g\n', ex_6x2);
fprintf('  3x    = %.10g\n', ex_3x);
fprintf('  f(x)  = %.10g\n', ex_f);

% --- Fila truncada ---
% Se trunca a tres dígitos significativos CADA resultado intermedio, que es lo
% que significa hacer la cuenta con aritmética de tres dígitos.
tr_x = truncar_n(x, digitos);
tr_x2 = truncar_n(tr_x * tr_x, digitos);
tr_x3 = truncar_n(tr_x2 * tr_x, digitos);
tr_6x2 = truncar_n(truncar_n(6, digitos) * tr_x2, digitos);
tr_3x = truncar_n(truncar_n(3, digitos) * tr_x, digitos);
tr_f = truncar_n(truncar_n(truncar_n(tr_x3 - tr_6x2, digitos) + tr_3x, digitos) ...
                 - truncar_n(0.149, digitos), digitos);

% --- Fila redondeada ---
rd_x = redondear_n(x, digitos);
rd_x2 = redondear_n(rd_x * rd_x, digitos);
rd_x3 = redondear_n(rd_x2 * rd_x, digitos);
rd_6x2 = redondear_n(redondear_n(6, digitos) * rd_x2, digitos);
rd_3x = redondear_n(redondear_n(3, digitos) * rd_x, digitos);
rd_f = redondear_n(redondear_n(redondear_n(rd_x3 - rd_6x2, digitos) + rd_3x, digitos) ...
                 - redondear_n(0.149, digitos), digitos);

fprintf('\nFila truncada a tres dígitos:\n');
fprintf('  x     = %.10g\n', tr_x);
fprintf('  x^2   = %.10g\n', tr_x2);
fprintf('  x^3   = %.10g\n', tr_x3);
fprintf('  6x^2  = %.10g\n', tr_6x2);
fprintf('  3x    = %.10g\n', tr_3x);
fprintf('  f(x)  = %.10g\n', tr_f);

fprintf('\nFila redondeada a tres dígitos:\n');
fprintf('  x     = %.10g\n', rd_x);
fprintf('  x^2   = %.10g\n', rd_x2);
fprintf('  x^3   = %.10g\n', rd_x3);
fprintf('  6x^2  = %.10g\n', rd_6x2);
fprintf('  3x    = %.10g\n', rd_3x);
fprintf('  f(x)  = %.10g\n', rd_f);

% ----------------------------------------------------------------------
% Tabla que pide la consigna
% ----------------------------------------------------------------------
fprintf('\nTabla de 5.a:\n\n');
fprintf('%-22s %-9s %-9s %-9s %-8s %-7s %-10s %-12s %s\n', ...
        'Método / Caso', 'x', 'x^2', 'x^3', '6x^2', '3x', 'f(x)', 'Error abs.', 'Error rel.');

% Una fila por caso, con las nueve columnas de la tabla de la consigna.
% La primera columna va aparte porque es texto.
etiquetas_filas = {'Exacto', 'Tres dígitos (truncados)', 'Tres dígitos (redondeados)'};
tabla = [ x,    ex_x2, ex_x3, ex_6x2, ex_3x, ex_f, 0, 0;
          tr_x, tr_x2, tr_x3, tr_6x2, tr_3x, tr_f, ...
                 error_absoluto(ex_f, tr_f), error_relativo(ex_f, tr_f);
          rd_x, rd_x2, rd_x3, rd_6x2, rd_3x, rd_f, ...
                 error_absoluto(ex_f, rd_f), error_relativo(ex_f, rd_f)];

for k = 1:rows(tabla)
  fprintf('%-22s %-9.6g %-9.6g %-9.6g %-8.6g %-7.6g %-10.6g %-12.4e %.4e\n', ...
          etiquetas_filas{k}, tabla(k, 1), tabla(k, 2), tabla(k, 3), tabla(k, 4), ...
          tabla(k, 5), tabla(k, 6), tabla(k, 7), tabla(k, 8));
endfor

% ----------------------------------------------------------------------
% 5.b) Forma anidada
% ----------------------------------------------------------------------
fprintf('\n--- 5.b) Forma anidada:  x(x(x - 6) + 3) - 0.149 ---\n');
fprintf('La forma directa usa cuatro multiplicaciones y tres sumas. La forma\n');
fprintf('anidada usa solo dos multiplicaciones: los factores se reutilizan.\n');

% --- Anidada exacta ---
an_t1 = x - 6;
an_t2 = x * an_t1;
an_t3 = an_t2 + 3;
an_t4 = x * an_t3;
an_f = an_t4 - 0.149;

% --- Anidada truncada ---
ant_t1 = truncar_n(x - 6, digitos);
ant_t2 = truncar_n(x * ant_t1, digitos);
ant_t3 = truncar_n(ant_t2 + truncar_n(3, digitos), digitos);
ant_t4 = truncar_n(x * ant_t3, digitos);
ant_f = truncar_n(ant_t4 - truncar_n(0.149, digitos), digitos);

% --- Anidada redondeada ---
anr_t1 = redondear_n(x - 6, digitos);
anr_t2 = redondear_n(x * anr_t1, digitos);
anr_t3 = redondear_n(anr_t2 + redondear_n(3, digitos), digitos);
anr_t4 = redondear_n(x * anr_t3, digitos);
anr_f = redondear_n(anr_t4 - redondear_n(0.149, digitos), digitos);

fprintf('\nDetail de los pasos de la forma anidada:\n');
fprintf('  x - 6     exacto %-12.10g  trunc %-10.10g  redond %-10.10g\n', ...
        an_t1, ant_t1, anr_t1);
fprintf('  x(x - 6)  exacto %-12.10g  trunc %-10.10g  redond %-10.10g\n', ...
        an_t2, ant_t2, anr_t2);
fprintf('  + 3       exacto %-12.10g  trunc %-10.10g  redond %-10.10g\n', ...
        an_t3, ant_t3, anr_t3);
fprintf('  x(...)    exacto %-12.10g  trunc %-10.10g  redond %-10.10g\n', ...
        an_t4, ant_t4, anr_t4);
fprintf('  f(x)      exacto %-12.10g  trunc %-10.10g  redond %-10.10g\n', ...
        an_f, ant_f, anr_f);

fprintf('\nTabla de 5.b:\n\n');
fprintf('%-22s %-12s %-12s %s\n', 'Método / Caso', 'Error abs.', 'Error rel.', 'vs. forma directa');

err_abs_trunc_directa = error_absoluto(ex_f, tr_f);
err_abs_redond_directa = error_absoluto(ex_f, rd_f);
err_abs_trunc_anidada = error_absoluto(ex_f, ant_f);
err_abs_redond_anidada = error_absoluto(ex_f, anr_f);

fprintf('%-22s %-12.4e %-12.4e %s\n', 'Exacto', 0, 0, '-');
fprintf('%-22s %-12.4e %-12.4e %-10s\n', 'Truncado, forma directa', ...
        err_abs_trunc_directa, error_relativo(ex_f, tr_f), '-');
fprintf('%-22s %-12.4e %-12.4e %s\n', 'Truncado, forma anidada', ...
        err_abs_trunc_anidada, error_relativo(ex_f, ant_f), ...
        sprintf('x%.4f', err_abs_trunc_directa / max(err_abs_trunc_anidada, eps)));
fprintf('%-22s %-12.4e %-12.4e %s\n', 'Redondeado, forma directa', ...
        err_abs_redond_directa, error_relativo(ex_f, rd_f), '-');
fprintf('%-22s %-12.4e %-12.4e %s\n', 'Redondeado, forma anidada', ...
        err_abs_redond_anidada, error_relativo(ex_f, anr_f), ...
        sprintf('x%.4f', err_abs_redond_directa / max(err_abs_redond_anidada, eps)));

% ----------------------------------------------------------------------
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('Valor exacto:  f(4.71) = %.10g\n', ex_f);
fprintf('Truncamiento, forma directa: error %.4e (%.2f %% del valor)\n', ...
        err_abs_trunc_directa, 100 * error_relativo(ex_f, tr_f));
fprintf('Truncamiento, forma anidada:  error %.4e (%.2f %% del valor)\n', ...
        err_abs_trunc_anidada, 100 * error_relativo(ex_f, ant_f));
fprintf('Redondeo,    forma directa: error %.4e (%.2f %% del valor)\n', ...
        err_abs_redond_directa, 100 * error_relativo(ex_f, rd_f));
fprintf('Redondeo,    forma anidada:  error %.4e (%.2f %% del valor)\n', ...
        err_abs_redond_anidada, 100 * error_relativo(ex_f, anr_f));

fprintf('\nEl error DOMINA en las dos formas, y se queda en el mismo orden de\n');
fprintf('magnitud: pasar a la forma anidada lo reduce por un factor de %.1f con\n', ...
        err_abs_trunc_directa / max(err_abs_trunc_anidada, eps));
fprintf('truncamiento y de %.1f con redondeo, pero en ningún caso llega a cero.\n', ...
        err_abs_redond_directa / max(err_abs_redond_anidada, eps));
fprintf('Eso es justamente lo que la consigna pide observar: el error no se\n');
fprintf('acumula hasta infinitud, se mantiene en un nivel bajo pero no despreciable.\n');

fprintf('\nLa razón se ve en los valores intermedios. En la forma directa se\n');
fprintf('calcula x^3 = %.6g y despues 6x^2 = %.6g, y la resta entre ambos da\n', ...
        ex_x3, ex_6x2);
fprintf('un numero pequeno (%.6g) a partir de dos numeros grandes: eso es una\n', ...
        ex_x3 - ex_6x2);
fprintf('resta catastrofica, y el error de truncar o redondear x^3 se amplifica\n');
fprintf('al dividir por la diferencia. La forma anidada evita esa resta entre\n');
fprintf('numeros grandes: suma primero x - 6 = %.6g, que ya es un numero chico, y\n', an_t1);
fprintf('de ahi en adelante todos los pasos son de magnitud parecida al resultado.\n');

fprintf('\nCrecimiento o disminucion del error: disminuye. Y la razon es\n');
fprintf('cuantitativa, no casual: la forma directa hace 4 multiplicaciones y 3\n');
fprintf('sumas, la anidada hace 2 multiplicaciones y 3 sumas. Cada operacion\n');
fprintf('individual genera un error del orden de medio digito, asi que reducir\n');
fprintf('las operaciones reduce el error total de forma aproximadamente\n');
fprintf('proporcional. Un error que crece con la cantidad de operaciones es\n');
fprintf('linealmente inestable; uno acotado, linealmente estable.\n');

fprintf('\nConclusion: para evaluar un polinomio conviene escribirlo en forma\n');
fprintf('anidada (Horner) y no calcular las potencias por separado. Es el mismo\n');
fprintf('polinomio y da el mismo valor exacto, pero en aritmetica finita da un\n');
fprintf('resultado mucho mejor y sin esfuerzo adicional: menos calculos.\n');
