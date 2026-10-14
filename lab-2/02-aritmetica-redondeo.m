% 02-aritmetica-redondeo.m - Ejercicio 2 de la Guía 2: aritmética de redondeo.
%
% Problema: usando aritmética con redondeo a tres dígitos, realizar los cinco
% cálculos que siguen. Considerando como valor exacto el resultado con cinco
% dígitos decimales, obtener el error absoluto y el error relativo. Trabajar
% con los valores NORMALIZADOS.
%
% Estructura de la consigna:
%   a) 133 + 0.921
%   b) 133 - 0.499
%   c) (121 - 119) - 0.327
%   d) (121 - 0.327) - 119
%   e) (2/9) * (9/7)
%
% Modelo matemático: en cada caso se redondea a tres dígitos significativos
% CADA operando, se efectúa la operación, y el resultado se redondea otra vez a
% tres dígitos. El redondeo no es distributivo con la resta: redondear los
% operandos por separado y redondear el resultado no da lo mismo que redondear
% solo el resultado. Por eso los casos c) y d) tienen exactamente los mismos
% números escritos y dan resultados muy distintos, y esa es la observación
% central del ejercicio.
%
% El redondeo vive en redondear.m y depende de normalizar.m, porque la consigna
% pide trabajar con los valores normalizados. El error se mide con
% error_absoluto.m y error_relativo.m.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Cantidad de dígitos a los que se redondea.
digitos = 3;

% Valor exacto de referencia: el resultado con cinco dígitos decimales.
exactos = [133.921, 132.501, 1.673, 1.673, 0.28571];

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 2 - ARITMÉTICA CON REDONDEO A TRES DÍGITOS\n');
fprintf('========================================================\n');
fprintf('Los valores se normalizan antes de redondear, como pide la consigna.\n');

% ----------------------------------------------------------------------
% a) 133 + 0.921
% ----------------------------------------------------------------------
fprintf('\n--- a) 133 + 0.921 ---\n');
a_operandos = redondear(133) + redondear(0.921);
a = redondear(a_operandos);
fprintf('redondeo(133)    = %.10g\n', redondear(133));
fprintf('redondeo(0.921)  = %.10g\n', redondear(0.921));
fprintf('suma de operandos= %.10g\n', a_operandos);
fprintf('resultado        = %.10g\n', a);

% ----------------------------------------------------------------------
% b) 133 - 0.499
% ----------------------------------------------------------------------
% Nota: la versión anterior de este script usaba 0.501 como operando y
% 132.499 como valor exacto, que es internamente consistente pero NO es lo que
% pide el enunciado, que dice 133 - 0.499. Acá se sigue el enunciado.
fprintf('\n--- b) 133 - 0.499 ---\n');
b_operandos = redondear(133) - redondear(0.499);
b = redondear(b_operandos);
fprintf('redondeo(133)    = %.10g\n', redondear(133));
fprintf('redondeo(0.499)  = %.10g\n', redondear(0.499));
fprintf('resta de operandos = %.10g\n', b_operandos);
fprintf('resultado        = %.10g\n', b);

% ----------------------------------------------------------------------
% c) (121 - 119) - 0.327
% ----------------------------------------------------------------------
fprintf('\n--- c) (121 - 119) - 0.327 ---\n');
c_resta_interna = redondear(121 - 119);
c_operandos = c_resta_interna - redondear(0.327);
c = redondear(c_operandos);
fprintf('redondeo(121 - 119) = %.10g\n', c_resta_interna);
fprintf('redondeo(0.327)      = %.10g\n', redondear(0.327));
fprintf('resta de operandos   = %.10g\n', c_operandos);
fprintf('resultado            = %.10g\n', c);

% ----------------------------------------------------------------------
% d) (121 - 0.327) - 119
% ----------------------------------------------------------------------
fprintf('\n--- d) (121 - 0.327) - 119 ---\n');
d_resta_interna = redondear(121 - 0.327);
d_operandos = d_resta_interna - redondear(119);
d = redondear(d_operandos);
fprintf('redondeo(121 - 0.327) = %.10g\n', d_resta_interna);
fprintf('redondeo(119)         = %.10g\n', redondear(119));
fprintf('resta de operandos    = %.10g\n', d_operandos);
fprintf('resultado             = %.10g\n', d);

% ----------------------------------------------------------------------
% e) (2/9) * (9/7)
% ----------------------------------------------------------------------
fprintf('\n--- e) (2/9) * (9/7) ---\n');
e_operandos = redondear(2 / 9) * redondear(9 / 7);
e = redondear(e_operandos);
fprintf('redondeo(2/9) = %.10g\n', redondear(2 / 9));
fprintf('redondeo(9/7) = %.10g\n', redondear(9 / 7));
fprintf('producto      = %.10g\n', e_operandos);
fprintf('resultado     = %.10g\n', e);

% ----------------------------------------------------------------------
% Tabla de resultados
% ----------------------------------------------------------------------
calculados = [a, b, c, d, e];
errores_abs = zeros(1, 5);
errores_rel = zeros(1, 5);

fprintf('\n--- Tabla de resultados ---\n\n');
fprintf('%-6s %-14s %-14s %-14s %s\n', ...
        'caso', 'Exacto', 'Calculado', 'Error absoluto', 'Error relativo');
for k = 1:5
  errores_abs(k) = error_absoluto(exactos(k), calculados(k));
  errores_rel(k) = error_relativo(exactos(k), calculados(k));
  fprintf('%-6s %-14.8g %-14.8g %-14.6e %.6e\n', ...
          char('a' + k - 1), exactos(k), calculados(k), errores_abs(k), errores_rel(k));
endfor

% ----------------------------------------------------------------------
% Conclusiones
% ----------------------------------------------------------------------
fprintf('\n--- Conclusiones ---\n');
fprintf('El caso que mas dice es el contraste entre c) y d). Los dos escriben\n');
fprintf('121, 119 y 0.327, y los dos parten exactamente de 1.673, pero el error\n');
fprintf('es muy distinto:\n');
fprintf('  c) error absoluto = %.4e\n', errores_abs(3));
fprintf('  d) error absoluto = %.4e\n', errores_abs(4));
fprintf('El caso d) comete un error %.1f veces mayor, y la diferencia no esta en\n', ...
        errores_abs(4) / max(errores_abs(3), eps));
fprintf('la aritmetica sino en el ORDEN de las operaciones.\n');
fprintf('\n');
fprintf('En c) se resuelve primero 121 - 119 = %.10g, que en aritmetica de tres\n', c_resta_interna);
fprintf('digitos es EXACTO: no se pierde nada. Recien ahi se resta el 0.327, y el\n');
fprintf('resultado %.10g conserva los tres digitos que se esperaban.\n', c);
fprintf('\n');
fprintf('En d) se resuelve primero 121 - 0.327 = %.10g, y al redondearlo a tres\n', 121 - 0.327);
fprintf('digitos significativos da %.10g: el 0.673 desaparece entero. Ese digito se\n', d_resta_interna);
fprintf('pierde ANTES de la segunda resta y no hay manera de recuperarlo. Peor\n');
fprintf('aun: lo que queda es restar dos numeros casi iguales, %.10g y 119, para\n', d_resta_interna);
fprintf('obtener %.10g. Restar numeros casi iguales para llegar a un resultado\n', exactos(4));
fprintf('pequeno es lo que se llama cancelacion catastrofica: el resultado tiene\n');
fprintf('pocas cifras significativas utiles y cualquier error previo queda\n');
fprintf('amplificado. Por eso d) no solo falla, falla mas fuerte que c).\n');
fprintf('\n');
fprintf('En el caso e) el error viene de otra fuente: redondear(2/9) = %.10g y\n', redondear(2 / 9));
fprintf('redondear(9/7) = %.10g son dos errores que se multiplican entre si. Ahi no\n', redondear(9 / 7));
fprintf('hay cancelacion, solo acumulacion de errores parciales.\n');
