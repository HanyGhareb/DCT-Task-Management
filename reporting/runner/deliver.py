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


def _send_smtp(host, port, tls, user, pwd, msg, to_addrs=None):
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
        # to_addrs (when given) is the full SMTP envelope -- this is how Bcc
        # recipients receive the message without ever appearing in a header
        srv.send_message(msg, to_addrs=to_addrs)
    finally:
        srv.quit()


# ---------------------------------------------------------------------------
# Distribution path (runs carrying DCT_RPT_RUN.dist_id -- GL "Generate and
# Send"): ONE message per run with real To/Cc headers + envelope-only Bcc,
# recipients from DCT_RPT_DIST_RECIP instead of the per-report recipient rules.
#
# TEST MODE (EMAIL_TEST_MODE, ships 'Y'): the message goes ONLY to
# EMAIL_TEST_TO -- never the defined To/Cc/Bcc -- with a "[TEST]" subject
# prefix; the run is stamped is_test='Y' and every intended real address is
# recorded SKIPPED so the log shows who WOULD have received it. While test
# mode is ON with no test address configured, delivery is skipped entirely.
# ---------------------------------------------------------------------------

_DIST_DEFAULT_SUBJECT = (
    "DCT i-Finance | {{ report_name }} | {{ scope_label }}"
    "{% if period %} | YTD {{ period }}"
    "{% elif params.year %} | FY {{ params.year }}{% endif %}")

_DIST_DEFAULT_BODY = (
    "<p>Dear Colleagues,</p>"
    "<p>Please find attached the <strong>{{ report_name }}</strong>"
    "{% if scope_label %} for <strong>{{ scope_label }}</strong>{% endif %}"
    "{% if period %} (YTD {{ period }})"
    "{% elif params.year %} (FY {{ params.year }}){% endif %}.</p>"
    "<p>Generated {{ generated_at }} by i-Finance Reporting.</p>")


def _dist_info(conn, dist_id):
    cur = conn.cursor()
    cur.execute(
        "select scope_type, scope_value, scope_label, sector_name, subject_tpl "
        "from prod.dct_rpt_dist where dist_id = :d", d=dist_id)
    row = cur.fetchone()
    if not row:
        return None
    return {"scope_type": row[0], "scope_value": row[1],
            "scope_label": row[2] or row[1], "sector_name": row[3],
            "subject_tpl": row[4]}


def _dist_recipients(conn, dist_id):
    """{'TO': [...], 'CC': [...], 'BCC': [...]} -- enabled rows, de-duped with
    TO > CC > BCC priority when the same address appears twice."""
    cur = conn.cursor()
    cur.execute(
        "select disposition, email from prod.dct_rpt_dist_recip "
        "where dist_id = :d and enabled = 'Y' "
        "order by decode(disposition, 'TO', 1, 'CC', 2, 3), recip_id", d=dist_id)
    groups, seen = {"TO": [], "CC": [], "BCC": []}, set()
    for disp, email in cur.fetchall():
        email = (email or "").strip()
        key = email.lower()
        if not email or key in seen or disp not in groups:
            continue
        seen.add(key)
        groups[disp].append(email)
    return groups


def _record_dist(conn, run_id, recipient, status, disposition, error=None):
    conn.cursor().execute(
        "insert into prod.dct_rpt_delivery "
        "(run_id, recipient, channel, status, sent_at, error_msg, disposition) "
        "values (:r, :e, 'EMAIL', :s, "
        "case when :s2 = 'SENT' then systimestamp end, :err, :d)",
        r=run_id, e=recipient, s=status, s2=status,
        err=(error or None), d=disposition)


def _stamp_run(conn, run_id, subject, is_test):
    conn.cursor().execute(
        "update prod.dct_rpt_run set email_subject = :s, is_test = :t "
        "where run_id = :r", s=(subject or "")[:400], t=is_test, r=run_id)


def record_dist_skipped(conn, run_id, dist_id, reason):
    """Log every defined recipient as SKIPPED (e.g. EMAIL_ENABLED=N) so the
    email log stays honest about what was NOT sent."""
    groups = _dist_recipients(conn, dist_id)
    for disp in ("TO", "CC", "BCC"):
        for email in groups[disp]:
            _record_dist(conn, run_id, email, "SKIPPED", disp, reason)
    conn.commit()


def send_dist_report(conn, conf, run_id, ctx, subject_tpl, body_tpl,
                     attachments, dist_id):
    """One message for the run's distribution. Returns (sent, failed) counts
    of ADDRESSES (a delivered group message counts every address as sent)."""
    info = _dist_info(conn, dist_id)
    if not info:
        _record_dist(conn, run_id, None, "SKIPPED", None, "distribution row not found")
        return 0, 0
    groups = _dist_recipients(conn, dist_id)
    intended = [(d, e) for d in ("TO", "CC", "BCC") for e in groups[d]]

    test_mode = (config.cfg(conf, "EMAIL_TEST_MODE", "Y") or "Y").upper() == "Y"
    test_to = [a.strip() for a in
               (config.cfg(conf, "EMAIL_TEST_TO", "") or "").replace(";", ",").split(",")
               if a.strip()]

    rctx = dict(ctx,
                scope_type=info["scope_type"], scope_value=info["scope_value"],
                scope_label=info["scope_label"], sector_name=info["sector_name"],
                recipient_name="Colleagues", recipient_email="")
    subj_t = _jinja.from_string(info["subject_tpl"] or _DIST_DEFAULT_SUBJECT)
    body_t = _jinja.from_string(body_tpl or _DIST_DEFAULT_BODY)
    subject = subj_t.render(**rctx)
    html = body_t.render(**rctx)

    if test_mode:
        subject = "[TEST] " + subject
        note = ("<p style=\"color:#B42318;border:1px solid #B42318;padding:8px;\">"
                "<strong>TEST MODE</strong> — this message was redirected to the "
                "test mailbox. Intended recipients: To: "
                + (", ".join(groups["TO"]) or "—") + " | Cc: "
                + (", ".join(groups["CC"]) or "—") + " | Bcc: "
                + str(len(groups["BCC"])) + " hidden.</p>")
        html = note + html
    _stamp_run(conn, run_id, subject, "Y" if test_mode else "N")

    if test_mode and not test_to:
        for disp, email in intended:
            _record_dist(conn, run_id, email, "SKIPPED", disp,
                         "test mode ON with no EMAIL_TEST_TO configured")
        conn.commit()
        return 0, 0

    if test_mode:
        header_to, header_cc, envelope = test_to, [], list(test_to)
    else:
        header_to, header_cc = groups["TO"], groups["CC"]
        envelope = groups["TO"] + groups["CC"] + groups["BCC"]
    if not envelope:
        _record_dist(conn, run_id, None, "SKIPPED", None, "no enabled recipients")
        conn.commit()
        return 0, 0

    msg = EmailMessage()
    msg["From"] = (f"{config.cfg(conf, 'SMTP_FROM_NAME', 'i-Finance Reporting')} "
                   f"<{config.cfg(conf, 'SMTP_FROM', config.cfg(conf, 'SMTP_USER') or 'no-reply@dct.gov.ae')}>")
    if header_to:
        msg["To"] = ", ".join(header_to)
    if header_cc:
        msg["Cc"] = ", ".join(header_cc)
    msg["Subject"] = subject
    msg.set_content("This report requires an HTML-capable mail client.")
    msg.add_alternative(html, subtype="html")
    for name, mime, data in attachments:
        maintype, _, subtype = (mime or "application/octet-stream").partition("/")
        msg.add_attachment(data, maintype=maintype,
                           subtype=subtype or "octet-stream", filename=name)

    host = config.cfg(conf, "SMTP_HOST")
    port = int(config.cfg(conf, "SMTP_PORT", "587"))
    tls = (config.cfg(conf, "SMTP_TLS", "STARTTLS") or "STARTTLS").upper()
    user = config.cfg(conf, "SMTP_USER")
    pwd = os.environ.get("RPT_SMTP_PASSWORD")

    sent = failed = 0
    try:
        _send_smtp(host, port, tls, user, pwd, msg, to_addrs=envelope)
        if test_mode:
            for email in test_to:
                _record_dist(conn, run_id, email, "SENT", "TO")
                sent += 1
            for disp, email in intended:
                _record_dist(conn, run_id, email, "SKIPPED", disp,
                             "test mode -- redirected to " + ", ".join(test_to))
        else:
            for disp, email in intended:
                _record_dist(conn, run_id, email, "SENT", disp)
                sent += 1
    except Exception as e:  # noqa: BLE001 - record the outcome, never crash the run
        err = str(e)[:1900]
        targets = ([("TO", a) for a in test_to] if test_mode else intended)
        for disp, email in targets:
            _record_dist(conn, run_id, email, "FAILED", disp, err)
            failed += 1
        if test_mode:
            for disp, email in intended:
                _record_dist(conn, run_id, email, "SKIPPED", disp, "test mode")
    conn.commit()
    return sent, failed
