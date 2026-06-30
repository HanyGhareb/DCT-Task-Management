"""Unit tests for the render layer (no DB / no browser needed).

Run from reporting/runner/:  python -m pytest tests -q
"""
import os
import sys
import datetime as dt

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import render_pdf      # noqa: E402
import render_xlsx     # noqa: E402

COLUMNS = ["period_name", "sector_name", "budget_ytd", "gl_actual_ytd", "period_date"]
ROWS = [
    ("05-2026", "Infrastructure", 1234567.5, 1000000.0, dt.date(2026, 5, 1)),
    ("05-2026", "Culture & Arts", 250000.0, 312500.25, dt.date(2026, 5, 1)),
]
CTX = {
    "report_code": "GL_BUDGET_ACTUAL", "report_name": "Budget vs Actual (YTD)",
    "period": "05-2026", "generated_at": "2026-06-30 10:23 PM", "row_count": len(ROWS),
    "headers": [c.replace("_", " ").title() for c in COLUMNS],
    "columns": COLUMNS, "rows": ROWS, "meta": "Generated 2026-06-30 | 2 rows", "brand": "#1F6F8B",
}


def test_html_has_title_and_formatted_numbers():
    html = render_pdf.render_html(CTX)
    assert "Budget vs Actual (YTD)" in html
    assert "1,234,567.50" in html          # float formatted with thousands + 2dp
    assert "Sector Name" in html            # titleized header
    assert html.count("<tr>") >= 3          # header + 2 data rows


def test_html_empty_state():
    html = render_pdf.render_html(dict(CTX, rows=[], row_count=0))
    assert "No data" in html


def test_xlsx_is_a_zip_workbook():
    data = render_xlsx.build_xlsx(COLUMNS, ROWS, title="Budget vs Actual", meta="2 rows")
    assert data[:2] == b"PK"                # xlsx is a zip container
    assert len(data) > 2000


def test_fmt_filter():
    assert render_pdf._fmt(1234567) == "1,234,567"
    assert render_pdf._fmt(None) == ""
    assert render_pdf._fmt(3.5) == "3.50"
