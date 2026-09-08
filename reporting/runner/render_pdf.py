"""Render a report to PDF: Jinja2 HTML template -> Chromium (page.pdf()).

Primary engine is Playwright/Chromium (reuses the ATD dependency and avoids the
WeasyPrint GTK-on-Windows install). Set PDF_RENDERER=WEASYPRINT in DCT_RPT_CONFIG
to use WeasyPrint instead (lighter, but needs the native GTK libs).
"""
import os
import re as _re
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


def render_html(ctx, template_name="report.html.j2", source=None):
    """Render the report HTML with the run context. `source` (DB-stored template
    text, DCT_RPT_TEMPLATE) wins over the bundled file of the same name."""
    if (ctx.get("report_code") or "").upper() == "GL_BUDGET_STATUS":
        from render_fd import prepare
        ctx = prepare(ctx)
    if source is not None:
        return _env.from_string(source).render(**ctx)
    return _env.get_template(template_name).render(**ctx)


def html_to_pdf(html, renderer="PLAYWRIGHT", landscape=False):
    if (renderer or "PLAYWRIGHT").upper() == "WEASYPRINT":
        return _weasyprint(html)
    return _playwright(html, landscape=landscape)


_PDF_CHROME_RE = {
    "header": _re.compile(
        r'<template\s+id="pdf-header"(?:\s+data-margin="([^"]*)")?\s*>(.*?)</template>', _re.S),
    "footer": _re.compile(
        r'<template\s+id="pdf-footer"(?:\s+data-margin="([^"]*)")?\s*>(.*?)</template>', _re.S),
}


def _extract_pdf_chrome(html):
    """Opt-in per-page header/footer (SECTOR_PERF_BOOK first consumer): a report
    template embeds <template id="pdf-header" data-margin="24mm">...</template>
    and/or <template id="pdf-footer" data-margin="16mm">...</template>; both are
    cut out of the flowing document and passed to Chromium's displayHeaderFooter,
    which repeats them on EVERY printed page inside the page margins — flowing
    content can never overlap them. data-margin overrides that side's page
    margin to make the room. Templates without the blocks are untouched, and an
    unprocessed <template> element renders nothing on the WeasyPrint path."""
    out = {"header": None, "footer": None, "margin_top": None, "margin_bottom": None}
    for kind, rx in _PDF_CHROME_RE.items():
        m = rx.search(html)
        if m:
            html = html[:m.start()] + html[m.end():]
            out[kind] = m.group(2)
            out["margin_top" if kind == "header" else "margin_bottom"] = m.group(1)
    return html, out


def _playwright(html, landscape=False):
    from playwright.sync_api import sync_playwright
    html, chrome = _extract_pdf_chrome(html)
    kwargs = dict(
        format="A4",
        landscape=landscape,
        print_background=True,
        margin={"top": chrome["margin_top"] or "14mm",
                "bottom": chrome["margin_bottom"] or "16mm",
                "left": "12mm", "right": "12mm"},
    )
    if chrome["header"] is not None or chrome["footer"] is not None:
        kwargs["display_header_footer"] = True
        kwargs["header_template"] = chrome["header"] or "<span></span>"
        kwargs["footer_template"] = chrome["footer"] or "<span></span>"
    with sync_playwright() as p:
        browser = p.chromium.launch(args=["--no-sandbox"])
        try:
            page = browser.new_page()
            page.set_content(html, wait_until="networkidle")
            return page.pdf(**kwargs)
        finally:
            browser.close()


def _weasyprint(html):
    from weasyprint import HTML
    return HTML(string=html, base_url=_TPL_DIR).write_pdf()


def build_pdf(ctx, template_name="report.html.j2", renderer="PLAYWRIGHT", source=None):
    return html_to_pdf(render_html(ctx, template_name, source=source), renderer,
                       landscape=bool(ctx.get("landscape")))
