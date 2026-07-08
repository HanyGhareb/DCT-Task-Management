"""Unit tests for the Word-template PDF path (render_docx + starter template).

No DB, no network. LibreOffice conversion tests skip when soffice is absent.
Run: pytest reporting/runner/tests/test_render_docx.py -v
"""
import io
import os
import sys
import zipfile

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

import render_docx            # noqa: E402
import upload_template        # noqa: E402


SAMPLE_CTX = {
    "report_code": "UT_SAMPLE",
    "report_name": "Unit Test Sample",
    "period": "06-2026",
    "params": {"year": 2026, "sector": "Tourism"},
    "generated_at": "2026-07-07 05:00 PM",
    "row_count": 2,
    "requested_by": "PYTEST",
    "headers": ["Sector Name", "Budget Ytd", "Actual Ap"],
    "columns": ["SECTOR_NAME", "BUDGET_YTD", "ACTUAL_AP"],
    "rows": [("Tourism", 1000000.5, 250000), ("Culture", 2000000, 0)],
    "data": [
        {"sector_name": "Tourism", "budget_ytd": 1000000.5, "actual_ap": 250000},
        {"sector_name": "Culture", "budget_ytd": 2000000, "actual_ap": 0},
    ],
    "sections": None,
    "meta": "Generated 2026-07-07 05:00 PM | 2 rows",
    "brand": "#1F6F8B",
    "landscape": False,
}


def _doc_xml(docx_bytes):
    with zipfile.ZipFile(io.BytesIO(docx_bytes)) as z:
        return z.read("word/document.xml").decode("utf-8")


def test_starter_docx_is_valid_zip():
    data = upload_template.make_starter_docx()
    xml = _doc_xml(data)
    assert "{{ report_name }}" in xml or "report_name" in xml


def test_starter_renders_with_sample_ctx():
    rendered = render_docx.docx_bytes_from_template(
        upload_template.make_starter_docx(), SAMPLE_CTX)
    xml = _doc_xml(rendered)
    assert "Unit Test Sample" in xml
    assert "Tourism" in xml and "Culture" in xml
    assert "1,000,000.50" in xml            # fmt filter applied
    assert "{%" not in xml and "{{" not in xml   # no unexpanded tags
    # dynamic table expanded: 3 header cells + 2 data rows x 3 cells
    assert xml.count("Sector Name") == 1
    assert "Budget Ytd" in xml and "Actual Ap" in xml


def test_missing_db_template_raises():
    class FakeCur:
        def execute(self, *_a, **_k):
            pass

        def fetchone(self):
            return None

    class FakeConn:
        def cursor(self):
            return FakeCur()

    with pytest.raises(RuntimeError, match="not found"):
        render_docx.build_pdf(FakeConn(), "nope.docx", SAMPLE_CTX)


@pytest.mark.skipif(render_docx._soffice() is None,
                    reason="LibreOffice (soffice) not installed")
def test_docx_to_pdf_conversion():
    rendered = render_docx.docx_bytes_from_template(
        upload_template.make_starter_docx(), SAMPLE_CTX)
    pdf = render_docx.docx_to_pdf(rendered)
    assert pdf[:5] == b"%PDF-"
    assert len(pdf) > 1000
