"""Email delivery: resolve a report's recipients, render the body with dynamic
variables, attach the generated files, send via SMTP, and record per-recipient
delivery status in DCT_RPT_DELIVERY.

SMTP non-secret settings come from DCT_RPT_CONFIG (UI-editable); the password is
the secret RPT_SMTP_PASSWORD env var. While EMAIL_ENABLED != 'Y' the runner skips
delivery entirely (generate-only), so this is only called when sending is on.
"""
import os
import smtplib
from email.message import EmailMessage
from jinja2 import Environment, select_autoescape

import config

_jinja = Environment(autoescape=select_autoescape(["html", "xml"]))

_DEFAULT_BODY = (
    "<p>Dear {{ recipient_name }},</p>"
    "<p>Please find attached the <strong>{{ report_name }}</strong> report"
    "{% if period %} for <strong>{{ period }}</strong>{% endif %}"
    " ({{ row_count }} rows).</p>"
    "<p>Generated {{ generated_at }} by i-Finance Reporting.</p>"
)


def resolve_recipients(conn, report_code, requested_by):
    """[(email, channel)] from the report's recipient rules (EMAIL channel only here)."""
    cur = conn.cursor()
    cur.execute(
        "select recipient, channel from table(prod.dct_rpt_pkg.resolve_recipients(:c, :b))",
        c=report_code, b=requested_by)
    seen, out = set(), []
    for recipient, channel in cur.fetchall():
        if recipient and (channel or "EMAIL") == "EMAIL" and recipient not in seen:
            seen.add(recipient)
            out.append((recipient, channel or "EMAIL"))
    return out


def _record(conn, run_id, recipient, channel, status, error=None):
    conn.cursor().callproc("prod.dct_rpt_pkg.record_delivery",
                           [run_id, recipient, channel, status, error])


def send_report(conn, conf, run_id, ctx, subject_tpl, body_tpl, attachments):
    """Render + send to every resolved recipient. attachments = [(name, mime, bytes)].
    Returns (sent, failed) counts. Records each outcome in DCT_RPT_DELIVERY."""
    recipients = resolve_recipients(conn, ctx["report_code"], ctx.get("requested_by"))
    if not recipients:
        return 0, 0

    host = config.cfg(conf, "SMTP_HOST")
    port = int(config.cfg(conf, "SMTP_PORT", "587"))
    tls = (config.cfg(conf, "SMTP_TLS", "STARTTLS") or "STARTTLS").upper()
    user = config.cfg(conf, "SMTP_USER")
    pwd = os.environ.get("RPT_SMTP_PASSWORD")
    mail_from = config.cfg(conf, "SMTP_FROM", user or "no-reply@dct.gov.ae")
    from_name = config.cfg(conf, "SMTP_FROM_NAME", "i-Finance Reporting")

    subj_t = _jinja.from_string(subject_tpl or "{{ report_name }}")
    body_t = _jinja.from_string(body_tpl or _DEFAULT_BODY)

    sent = failed = 0
    for email, channel in recipients:
        try:
            rctx = dict(ctx, recipient_name=email.split("@")[0], recipient_email=email)
            msg = EmailMessage()
            msg["From"] = f"{from_name} <{mail_from}>"
            msg["To"] = email
            msg["Subject"] = subj_t.render(**rctx)
            html = body_t.render(**rctx)
            msg.set_content("This report requires an HTML-capable mail client.")
            msg.add_alternative(html, subtype="html")
            for name, mime, data in attachments:
                maintype, _, subtype = (mime or "application/octet-stream").partition("/")
                msg.add_attachment(data, maintype=maintype, subtype=subtype or "octet-stream",
                                   filename=name)
            _send_smtp(host, port, tls, user, pwd, msg)
            _record(conn, run_id, email, channel, "SENT")
            sent += 1
        except Exception as e:  # noqa: BLE001 - one bad recipient must not fail the rest
            _record(conn, run_id, email, channel, "FAILED", str(e)[:1900])
            failed += 1
    return sent, failed


def _send_smtp(host, port, tls, user, pwd, msg):
    if not host:
        raise RuntimeError("SMTP_HOST not configured")
    if tls == "SSL":
        srv = smtplib.SMTP_SSL(host, port, timeout=40)
    else:
        srv = smtplib.SMTP(host, port, timeout=40)
    try:
        if tls == "STARTTLS":
            srv.starttls()
        if user and pwd:
            srv.login(user, pwd)
        srv.send_message(msg)
    finally:
        srv.quit()
