"""Render a report to PDF: Jinja2 HTML template -> Chromium (page.pdf()).

Primary engine is Playwright/Chromium (reuses the ATD dependency and avoids the
WeasyPrint GTK-on-Windows install). Set PDF_RENDERER=WEASYPRINT in DCT_RPT_CONFIG
to use WeasyPrint instead (lighter, but needs the native GTK libs).
"""
import os
import datetime as _dt
from jinja2 import Environment, FileSystemLoader, select_autoescape

_TPL_DIR = os.path.join(os.path.dirname(__file__), "templates")
_env = Environment(
    loader=FileSystemLoader(_TPL_DIR),
    autoescape=select_autoescape(["html", "xml", "j2"]),
)


def _fmt(v):
    """Display-format a cell: thousands-separated numbers, ISO-ish dates, '' for None."""
    if v is None:
        return ""
    if isinstance(v, bool):
        return "Yes" if v else "No"
    if isinstance(v, int):
        return f"{v:,}"
    if isinstance(v, float):
        return f"{v:,.2f}"
    if isinstance(v, _dt.datetime):
        return v.strftime("%Y-%m-%d %H:%M")
    if isinstance(v, _dt.date):
        return v.strftime("%Y-%m-%d")
    return v


def _isnum(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)


_env.filters["fmt"] = _fmt
_env.tests["num"] = _isnum


def render_html(ctx, template_name="report.html.j2"):
    """Render the report HTML from a template in templates/ with the run context."""
    return _env.get_template(template_name).render(**ctx)


def html_to_pdf(html, renderer="PLAYWRIGHT"):
    if (renderer or "PLAYWRIGHT").upper() == "WEASYPRINT":
        return _weasyprint(html)
    return _playwright(html)


def _playwright(html):
    from playwright.sync_api import sync_playwright
    with sync_playwright() as p:
        browser = p.chromium.launch(args=["--no-sandbox"])
        try:
            page = browser.new_page()
            page.set_content(html, wait_until="networkidle")
            return page.pdf(
                format="A4",
                print_background=True,
                margin={"top": "14mm", "bottom": "16mm", "left": "12mm", "right": "12mm"},
            )
        finally:
            browser.close()


def _weasyprint(html):
    from weasyprint import HTML
    return HTML(string=html, base_url=_TPL_DIR).write_pdf()


def build_pdf(ctx, template_name="report.html.j2", renderer="PLAYWRIGHT"):
    return html_to_pdf(render_html(ctx, template_name), renderer)
