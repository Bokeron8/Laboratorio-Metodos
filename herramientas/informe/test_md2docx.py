#!/usr/bin/env python3
"""Tests de estructura del conversor markdown -> .docx.

Verifican el formato que exige la pauta del TP evaluativo: A4, márgenes
3 cm / 2,5 cm, Arial 11 en el texto, Arial 14 en los títulos, interlineado 1,5
y espaciado anterior de 3 ptos. También la carátula y los campos automáticos.

Uso:
  herramientas/informe/.venv/bin/python -m unittest herramientas/informe/test_md2docx.py
"""
import pathlib
import tempfile
import unittest

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.shared import Cm, Pt

HERE = pathlib.Path(__file__).resolve().parent
import sys

sys.path.insert(0, str(HERE))
import md2docx  # noqa: E402

CFG = {
    "caratula": {
        "logo": "logo-unne.jpg",
        "universidad": "UNIVERSIDAD NACIONAL DEL NORDESTE",
        "facultad": "FACULTAD DE CIENCIAS EXACTAS Y NATURALES Y DE AGRIMENSURA",
        "asignatura": "Métodos Computacionales",
        "titulo": "1° Trabajo de Evaluación",
        "temas": ["Tema 1: Modelos matemáticos", "Tema 3: Raíces de Ecuaciones"],
        "integrantes": ["Bazzola Gabriel — L.U. 60.151", "Zambrano Franco — L.U. 60.153"],
        "comision": "Jueves de 15 a 17",
        "anio": "2026",
    }
}

MD = """# Introducción

Texto de prueba con **negrita** y `código`.

## Métodos asignados

- primer ítem
- segundo ítem

1. paso uno
2. paso dos

| Método | Iteraciones |
| :--- | ---: |
| Punto fijo | 7 |
| Newton | 3 |

```octave
x = 1;
```

![Raíz de F(x)](logo-unne.jpg)
"""


class TestFormato(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.salida = pathlib.Path(cls.tmp.name) / "informe.docx"
        md2docx.construir(MD, CFG, cls.salida, base_dir=HERE)
        cls.doc = Document(str(cls.salida))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_hoja_a4(self):
        s = self.doc.sections[0]
        self.assertAlmostEqual(s.page_width.cm, 21.0, places=1)
        self.assertAlmostEqual(s.page_height.cm, 29.7, places=1)

    def test_margenes(self):
        s = self.doc.sections[0]
        self.assertAlmostEqual(s.top_margin.cm, 3.0, places=2)
        self.assertAlmostEqual(s.bottom_margin.cm, 2.5, places=2)
        self.assertAlmostEqual(s.left_margin.cm, 2.5, places=2)
        self.assertAlmostEqual(s.right_margin.cm, 2.5, places=2)

    def test_texto_arial_11_justificado_interlineado(self):
        st = self.doc.styles["Normal"]
        self.assertEqual(st.font.name, "Arial")
        self.assertEqual(st.font.size, Pt(11))
        pf = st.paragraph_format
        self.assertEqual(pf.alignment, WD_ALIGN_PARAGRAPH.JUSTIFY)
        self.assertAlmostEqual(float(pf.line_spacing), 1.5, places=2)
        self.assertEqual(pf.space_before, Pt(3))

    def test_titulos_arial_14(self):
        for nombre in ("Heading 1", "Heading 2", "Heading 3"):
            st = self.doc.styles[nombre]
            self.assertEqual(st.font.name, "Arial", nombre)
            self.assertEqual(st.font.size, Pt(14), nombre)

    def test_caratula(self):
        texto = "\n".join(p.text for p in self.doc.paragraphs[:14])
        for esperado in (
            "UNIVERSIDAD NACIONAL DEL NORDESTE",
            "FACULTAD DE CIENCIAS EXACTAS Y NATURALES Y DE AGRIMENSURA",
            "Métodos Computacionales",
            "Bazzola Gabriel — L.U. 60.151",
            "Zambrano Franco — L.U. 60.153",
            "Jueves de 15 a 17",
            "2026",
        ):
            self.assertIn(esperado, texto)

    def test_logo_en_caratula(self):
        self.assertGreaterEqual(len(self.doc.inline_shapes), 2)

    def test_indice_automatico(self):
        xml = self.doc.element.body.xml
        self.assertIn("TOC", xml)
        self.assertIn('w:fldCharType="begin"', xml)

    def test_indice_de_figuras(self):
        xml = self.doc.element.body.xml
        self.assertIn('\\c "Figura"', xml)

    def test_instruccion_de_campo_dentro_de_un_run(self):
        from docx.oxml.ns import qn

        partes = [("body", self.doc.element.body)]
        pie = self.doc.sections[0].footer
        if pie is not None:
            partes.append(("footer", pie._element))
        for nombre, parte in partes:
            for instr in parte.iter(qn("w:instrText")):
                self.assertEqual(
                    instr.getparent().tag,
                    qn("w:r"),
                    f"{nombre}: w:instrText debe ir dentro de w:r, no suelto en w:p",
                )

    def test_indice_lleno_con_paginas(self):
        indice = {
            "titulos": [(1, "Introducción", 4), (2, "Métodos asignados", 5)],
            "figuras": [(1, "Figura 1: Raíz de F(x)", 7)],
        }
        salida = pathlib.Path(self.tmp.name) / "con-indice.docx"
        md2docx.construir(MD, CFG, salida, base_dir=HERE, indice=indice)
        xml = Document(str(salida)).element.body.xml
        self.assertIn("Introducción", xml)
        self.assertIn("Métodos asignados", xml)
        self.assertIn("Figura 1: Raíz de F(x)", xml)
        self.assertNotIn("Actualizá el índice con F9", xml)
        # Sigue siendo un campo real, actualizable si el lector quiere.
        self.assertIn('TOC \\o "1-3"', xml)
        self.assertIn('TOC \\h \\z \\c "Figura"', xml)

    def test_instruccion_entre_begin_y_separate(self):
        """Si la instrucción queda antes del begin, Word la muestra como texto."""
        from docx.oxml.ns import qn

        indice = {"titulos": [(1, "Introducción", 4)], "figuras": []}
        salida = pathlib.Path(self.tmp.name) / "orden.docx"
        md2docx.construir(MD, CFG, salida, base_dir=HERE, indice=indice)
        doc = Document(str(salida))
        for p in doc.paragraphs:
            if "TOC" not in p._p.xml:
                continue
            hijos = list(p._p)
            tipos = []
            for h in hijos:
                if h.tag == qn("w:r"):
                    fld = h.find(qn("w:fldChar"))
                    if fld is not None:
                        tipos.append(fld.get(qn("w:fldCharType")))
                    if h.find(qn("w:instrText")) is not None:
                        tipos.append("instr")
            self.assertEqual(tipos, ["begin", "instr", "separate"],
                             "orden del campo: begin, instrucción, separate")
            return
        self.fail("no se encontró el párrafo del índice")
    def test_tabla(self):
        self.assertEqual(len(self.doc.tables), 1)
        t = self.doc.tables[0]
        self.assertEqual(len(t.rows), 3)
        self.assertEqual([c.text for c in t.rows[0].cells], ["Método", "Iteraciones"])

    def test_pipe_escapado_no_parte_la_celda(self):
        md = (
            "| Método | Condición |\n"
            "| :--- | :--- |\n"
            "| Punto fijo | *\\|g'(x0)\\| < 1* |\n"
        )
        salida = pathlib.Path(self.tmp.name) / "pipe.docx"
        md2docx.construir(md, CFG, salida, base_dir=HERE)
        t = Document(str(salida)).tables[0]
        self.assertEqual(len(t.columns), 2)
        self.assertEqual(t.cell(1, 1).text, "|g'(x0)| < 1")

    def test_anchos_de_columna_por_contenido(self):
        datos = [
            ["Método", "Orden de convergencia", "Requiere derivada"],
            ["Punto fijo", "Lineal", "No"],
            ["Newton-Raphson", "Cuadrática", "Sí, aproximada"],
        ]
        anchos = md2docx._anchos_de_columna(datos)
        self.assertEqual(len(anchos), 3)
        self.assertAlmostEqual(sum(anchos), 16.0, places=2)
        # "convergencia" (12, negrita) no puede quedar más angosta que su palabra.
        self.assertGreaterEqual(anchos[1], 2.51 + 2 * 0.19)
        # "Newton-Raphson" entra en una línea: 2,99 cm de texto + márgenes.
        self.assertGreaterEqual(anchos[0], 2.99 + 2 * 0.19)

    def test_anchos_siempre_suman_el_ancho_util(self):
        datos = [
            ["Método", "Tolerancia", "Iteraciones", "Raíz", "Tiempo prom. (ms)", "Tiempo/iter. (ms)"],
            ["Punto fijo", "0.05", "4", "213.319634", "0.287", "0.072"],
            ["Punto fijo", "0.002", "6", "213.324457", "0.357", "0.059"],
            ["Punto fijo", "0.0001", "7", "213.324539", "0.392", "0.056"],
            ["Newton-Raphson", "0.05", "2", "213.324552", "0.289", "0.145"],
            ["Newton-Raphson", "0.002", "3", "213.324553", "0.338", "0.113"],
            ["Newton-Raphson", "0.0001", "3", "213.324553", "0.340", "0.113"],
            ["Aitken", "0.05", "2", "213.324553", "0.226", "0.113"],
            ["Aitken", "0.002", "3", "213.324553", "0.270", "0.090"],
            ["Aitken", "0.0001", "3", "213.324553", "0.268", "0.089"],
        ]
        anchos = md2docx._anchos_de_columna(datos)
        self.assertAlmostEqual(sum(anchos), 16.0, places=2)
        # "Tiempo" (negrita, 11 pt) mide 1,38 cm; con los márgenes de celda la
        # columna necesita 1,76 cm o LibreOffice parte la palabra ("Tiemp/o").
        self.assertGreaterEqual(anchos[4], 1.38 + 2 * 0.19)

    def test_codigo_monoespaciado(self):
        parrafos = [p for p in self.doc.paragraphs if p.text.strip() == "x = 1;"]
        self.assertEqual(len(parrafos), 1)
        self.assertEqual(parrafos[0].runs[0].font.name, "Courier New")

    def test_figura_con_epigrafe(self):
        pies = [p for p in self.doc.paragraphs if p.style.name == "Caption"]
        self.assertEqual(len(pies), 1)
        xml = pies[0]._p.xml
        self.assertIn("Figura", xml)
        self.assertIn("Raíz de F(x)", xml)
        # El número lo aporta un campo SEQ: es lo que alimenta el índice de figuras.
        self.assertIn("SEQ Figura", xml)

    def test_listas(self):
        textos = [p.text for p in self.doc.paragraphs]
        self.assertIn("primer ítem", textos)
        self.assertIn("paso dos", textos)


class TestInyeccion(unittest.TestCase):
    def test_code_y_img_se_resuelven(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        base = pathlib.Path(tmp.name)
        (base / "parte.m").write_text("a = 2;\n", encoding="utf-8")
        (base / "logo-unne.jpg").write_bytes((HERE / "logo-unne.jpg").read_bytes())
        md = "{{CODE:parte.m}}\n\n{{IMG:logo-unne.jpg|Figura de prueba}}\n"

        salida = base / "out.docx"
        md2docx.construir(md, CFG, salida, base_dir=base)
        doc = Document(str(salida))
        textos = [p.text for p in doc.paragraphs]
        self.assertIn("a = 2;", textos)
        self.assertTrue(any("Figura de prueba" in t for t in textos))

    def test_incluir_archivo(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        base = pathlib.Path(tmp.name)
        (base / "tabla.md").write_text("| a |\n| :--- |\n| 1 |\n", encoding="utf-8")

        salida = base / "out.docx"
        md2docx.construir("{{INCLUIR:tabla.md}}\n", CFG, salida, base_dir=base)
        doc = Document(str(salida))
        self.assertEqual(len(doc.tables), 1)

    def test_archivo_faltante_no_explota(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        salida = pathlib.Path(tmp.name) / "out.docx"
        md2docx.construir("{{CODE:no-existe.m}}\n", CFG, salida, base_dir=HERE)
        doc = Document(str(salida))
        self.assertTrue(any("no-existe.m" in p.text for p in doc.paragraphs))


if __name__ == "__main__":
    unittest.main()
