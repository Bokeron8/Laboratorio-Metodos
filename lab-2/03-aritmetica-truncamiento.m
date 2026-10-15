% 03-aritmetica-truncamiento.m - Ejercicio 3 de la Guía 2: aritmética de truncamiento.
%
% Problema: repetir el ejercicio anterior usando aritmética con TRUNCAMIENTO a
% tres dígitos, y comparar los resultados obtenidos en 2 y 3.
%
% Estructura del problema:
%   a) Repetir los cinco casos del ejercicio 2 con truncamiento a tres dígitos,
%      normalizando los valores.
%   b) Comparar los resultados con los del ejercicio 2.
%
% Modelo matemático: es idéntico al del ejercicio 2, con una sola diferencia:
% el truncamiento no mira el dígito que se descarta. Donde el redondeo sube al
% valor siguiente cuando el dígito descartado es 5 o más, el truncamiento
% siempre se queda con la parte baja. Por eso truncar(133.921) = 133 mientras
% que redondear(133.921) = 134.
%
% Por esa razon el error del truncamiento es SIEMPRE del mismo signo que el
% error del redondeo, y de magnitud parecida. No es que un metodo sea mejor que
% el otro: los dos se equivocan, cada uno hacia su lado.
%
% El truncamiento vive en truncar.m y depende de normalizar.m. El error se mide
% con error_absoluto.m y error_relativo.m.

clc;

% ----------------------------------------------------------------------
% Datos del problema
% ----------------------------------------------------------------------
% Valor exacto de referencia: el resultado con cinco dígitos decimales.
exactos = [133.921, 132.501, 1.673, 1.673, 0.28571];

% Resultados del ejercicio 2 (redondeo), recalculados acá con las mismas
% funciones para que la comparación sea justa y no dependa de copiar números.
% Se los vuelve a imprimir más abajo porque se requiere comparar.
redondeados = [redondear(redondear(133) + redondear(0.921)), ...
               redondear(redondear(133) - redondear(0.499)), ...
               redondear(redondear(121 - 119) - redondear(0.327)), ...
               redondear(redondear(121 - 0.327) - redondear(119)), ...
               redondear(redondear(2 / 9) * redondear(9 / 7))];

fprintf('\n========================================================\n');
fprintf('  EJERCICIO 3 - ARITMÉTICA CON TRUNCAMIENTO A TRES DÍGITOS\n');
fprintf('========================================================\n');
fprintf('Los valores se normalizan antes de truncar, como en el ejercicio 2.\n');

% ----------------------------------------------------------------------
% a) Los cinco casos con truncamiento
% ----------------------------------------------------------------------
fprintf('\n--- a) Detail de cada caso con truncamiento ---\n');

fprintf('\nCaso a) 133 + 0.921\n');
a_t = truncar(133) + truncar(0.921);
a = truncar(a_t);
fprintf('  truncar(133) = %-10.10g truncar(0.921) = %-10.10g suma = %.10g\n', ...
        truncar(133), truncar(0.921), a_t);
fprintf('  resultado    = %.10g\n', a);

fprintf('\nCaso b) 133 - 0.499\n');
b_t = truncar(133) - truncar(0.499);
b = truncar(b_t);
fprintf('  truncar(133) = %-10.10g truncar(0.499) = %-10.10g resta = %.10g\n', ...
        truncar(133), truncar(0.499), b_t);
fprintf('  resultado    = %.10g\n', b);

fprintf('\nCaso c) (121 - 119) - 0.327\n');
c_t = truncar(121 - 119) - truncar(0.327);
c = truncar(c_t);
fprintf('  truncar(121 - 119) = %-10.10g truncar(0.327) = %-10.10g resta = %.10g\n', ...
        truncar(121 - 119), truncar(0.327), c_t);
fprintf('  resultado           = %.10g\n', c);

fprintf('\nCaso d) (121 - 0.327) - 119\n');
d_t = truncar(121 - 0.327) - truncar(119);
d = truncar(d_t);
fprintf('  truncar(121 - 0.327) = %-10.10g truncar(119) = %-10.10g resta = %.10g\n', ...
        truncar(121 - 0.327), truncar(119), d_t);
fprintf('  resultado            = %.10g\n', d);

fprintf('\nCaso e) (2/9) * (9/7)\n');
e_t = truncar(2 / 9) * truncar(9 / 7);
e = truncar(e_t);
fprintf('  truncar(2/9) = %-10.10g truncar(9/7) = %-10.10g producto = %.10g\n', ...
        truncar(2 / 9), truncar(9 / 7), e_t);
fprintf('  resultado     = %.10g\n', e);

truncados = [a, b, c, d, e];

% ----------------------------------------------------------------------
% b) Comparación con el ejercicio 2
% ----------------------------------------------------------------------
% Se pide comparar los resultados de los ejercicios 2 y 3, así que
% los dos van en la misma tabla, con los dos errores.
err_abs_trunc = zeros(1, 5);
err_rel_trunc = zeros(1, 5);
err_abs_redon = zeros(1, 5);
err_rel_redon = zeros(1, 5);

fprintf('\n--- b) Comparación de los ejercicios 2 y 3 ---\n\n');
fprintf('%-6s %-12s %-12s %-12s %-13s %-13s %s\n', ...
        'caso', 'Exacto', 'Redondeo', 'Truncam.', 'Err. abs. red.', ...
        'Err. abs. trunc.', 'Cociente');

for k = 1:5
  err_abs_trunc(k) = error_absoluto(exactos(k), truncados(k));
  err_rel_trunc(k) = error_relativo(exactos(k), truncados(k));
  err_abs_redon(k) = error_absoluto(exactos(k), redondeados(k));
  err_rel_redon(k) = error_relativo(exactos(k), redondeados(k));

  fprintf('%-6s %-12.6g %-12.6g %-12.6g %-13.4e %-13.4e %.2f\n', ...
          char('a' + k - 1), exactos(k), redondeados(k), truncados(k), ...
          err_abs_redon(k), err_abs_trunc(k), ...
          err_abs_trunc(k) / max(err_abs_redon(k), eps));
endfor

% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
% Resumen
% ----------------------------------------------------------------------
fprintf('\n--- Resumen ---\n');
fprintf('Truncar y redondear son formas distintas de perder información (sesgos opuestos).\n');
fprintf('Sin embargo, el factor crítico sigue siendo el orden de operaciones para prevenir la cancelación.\n');
