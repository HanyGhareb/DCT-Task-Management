"""Render a report PDF from a Word (.docx) template: docxtpl -> LibreOffice.

Templates are authored in Microsoft Word with Jinja2 tags (same variables as the
HTML templates, plus `data` = rows as dicts) and stored in DCT_RPT_TEMPLATE via
the BI app -- no worker redeploy to change a layout. Conversion to PDF uses
headless LibreOffice (soffice); each call gets its own -env:UserInstallation
profile so concurrent conversions on one VM never fight over the profile lock.
"""
import os
import pathlib
import shutil
import subprocess
import tempfile

import jinja2

from render_pdf import _fmt, _isnum


def fetch_template(conn, name):
    """Template file bytes from DCT_RPT_TEMPLATE, or None when not stored/disabled."""
    cur = conn.cursor()
    cur.execute("select content from prod.dct_rpt_template "
                "where template_name = :n and enabled = 'Y'", n=name)
    row = cur.fetchone()
    if not row:
        return None
    data = row[0]
    return data.read() if hasattr(data, "read") else data


def _jenv():
    env = jinja2.Environment()
    env.filters["fmt"] = _fmt
    env.tests["num"] = _isnum
    return env


def _soffice():
    return (os.environ.get("RPT_SOFFICE")
            or shutil.which("soffice")
            or shutil.which("libreoffice"))


def docx_bytes_from_template(template_bytes, ctx):
    """Render the .docx template bytes with the run context (docxtpl)."""
    from docxtpl import DocxTemplate
    with tempfile.TemporaryDirectory(prefix="rptdocx_") as td:
        src = os.path.join(td, "template.docx")
        with open(src, "wb") as f:
            f.write(template_bytes)
        tpl = DocxTemplate(src)
        tpl.render(ctx, _jenv())
        out = os.path.join(td, "rendered.docx")
        tpl.save(out)
        with open(out, "rb") as f:
            return f.read()


def docx_to_pdf(docx_bytes, timeout=180):
    """Convert rendered .docx bytes to PDF bytes via headless LibreOffice."""
    soffice = _soffice()
    if not soffice:
        raise RuntimeError(
            "LibreOffice (soffice) not found -- install libreoffice-writer on this "
            "worker or set RPT_SOFFICE to the binary path")
    with tempfile.TemporaryDirectory(prefix="rptlo_") as td:
        src = os.path.join(td, "report.docx")
        with open(src, "wb") as f:
            f.write(docx_bytes)
        profile = pathlib.Path(td, "lo_profile").as_uri()
        proc = subprocess.run(
            [soffice, f"-env:UserInstallation={profile}", "--headless",
             "--norestore", "--convert-to", "pdf", "--outdir", td, src],
            capture_output=True, timeout=timeout)
        pdf = os.path.join(td, "report.pdf")
        if proc.returncode != 0 or not os.path.exists(pdf):
            raise RuntimeError(
                "LibreOffice PDF conversion failed: "
                + (proc.stderr or proc.stdout or b"").decode(errors="replace")[:500])
        with open(pdf, "rb") as f:
            return f.read()


def build_pdf(conn, template_name, ctx, timeout=480):
    """LibreOffice table layout is slow on huge tables — timeout comes from the
    DOCX_PDF_TIMEOUT_SEC config. Word templates suit executive-size row counts;
    large tabular exports belong to .j2 (Chromium) templates."""
    blob = fetch_template(conn, template_name)
    if blob is None:
        raise RuntimeError(
            f"Word template '{template_name}' not found in DCT_RPT_TEMPLATE "
            "(upload it on the BI Templates page)")
    return docx_to_pdf(docx_bytes_from_template(blob, ctx), timeout=timeout)
