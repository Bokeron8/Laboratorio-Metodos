#!/usr/bin/env python3
"""Tests de la ubicación de títulos y figuras en el PDF paginado.

No invocan LibreOffice: trabajan sobre páginas ya extraídas.

Uso:
  herramientas/informe/.venv/bin/python -m unittest herramientas/informe/test_paginar.py
"""
import pathlib
import sys
import unittest

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import paginar  # noqa: E402


class TestUbicar(unittest.TestCase):
    def test_ubica_cada_entrada_en_su_pagina(self):
        paginas = [
            "Carátula",
            "Índice\n1. Introducción .... 4\n2. Desarrollo .... 5",
            "Índice de figuras\nFigura 1: Raíz .... 6",
            "1. Introducción\nTexto de la introducción.",
            "2. Desarrollo\n2.1 Métodos asignados\nTexto.",
            "Figura 1: Raíz de F(x)\nPágina 6 de 6",
        ]
        entradas = [(1, "1. Introducción"), (1, "2. Desarrollo"),
                    (2, "2.1 Métodos asignados")]
        ubicadas = paginar.ubicar(entradas, paginas, desde=3)
        self.assertEqual(ubicadas, [
            (1, "1. Introducción", 4),
            (1, "2. Desarrollo", 5),
            (2, "2.1 Métodos asignados", 5),
        ])

    def test_no_se_confunde_con_el_indice(self):
        paginas = [
            "Índice\n1. Introducción .... 3",
            "Índice de figuras\nFigura 1: Raíz .... 4",
            "1. Introducción\nTexto",
        ]
        ubicadas = paginar.ubicar([(1, "1. Introducción")], paginas,
                                  desde=paginar.pagina_de_contenido(paginas))
        self.assertEqual(ubicadas, [(1, "1. Introducción", 3)])

    def test_titulo_cortado_en_dos_lineas(self):
        paginas = ["", "", "2.1 Métodos asignados. Análisis y\ncomparación\nTexto"]
        ubicadas = paginar.ubicar(
            [(2, "2.1 Métodos asignados. Análisis y comparación")], paginas, desde=2)
        self.assertEqual(ubicadas[0][2], 3)

    def test_entrada_inexistente_no_rompe(self):
        ubicadas = paginar.ubicar([(1, "No está")], ["", "Texto"], desde=0)
        self.assertEqual(ubicadas, [(1, "No está", None)])


class TestPaginaDeContenido(unittest.TestCase):
    def test_salta_caratula_e_indices(self):
        paginas = ["Carátula", "Índice\n...", "Índice de figuras\n...", "Contenido"]
        self.assertEqual(paginar.pagina_de_contenido(paginas), 3)

    def test_sin_indice_de_figuras_empieza_en_cero(self):
        self.assertEqual(paginar.pagina_de_contenido(["Carátula", "Contenido"]), 0)


if __name__ == "__main__":
    unittest.main()
