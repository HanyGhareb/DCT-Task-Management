"""i-Finance Reporting runner (PYTHON engine).

Claims QUEUED PYTHON runs from the shared control plane (DCT_RPT_PKG.claim_next,
SKIP LOCKED), runs the report's data source, renders PDF/Excel, archives the
output BLOBs (DCT_RPT_OUTPUT), emails the recipients when EMAIL_ENABLED='Y', and
records the run + delivery outcome. Mirrors the otbi-atd worker pattern.

Usage:
  python runner.py                       # drain the queue, then exit
  python runner.py --once                # process at most one run
  python runner.py --forever             # long-running worker (sleeps when idle)
  python runner.py --run GL_BUDGET_ACTUAL [--period 05-2026]   # enqueue + drain (test)
  python runner.py --reclaim             # requeue stuck RUNNING runs and exit
"""
import argparse
import hashlib
import json
import socket
import sys
import time
from datetime import datetime, timezone, timedelta

import oracledb

import config
import datasource
import render_pdf
import render_xlsx
import deliver
import notify

DUBAI = timezone(timedelta(hours=4))           # Asia/Dubai (fixed +04:00, no DST)
WORKER_ID = (socket.gethostname() or "rpt") + "/py"
XLSX_MIME = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"


def _now():
    return datetime.now(DUBAI)


def _read(v):
    return v.read() if hasattr(v, "read") else v


def _sha256(data):
    return hashlib.sha256(data).hexdigest()


def claim(conn):
    cur = conn.cursor()
    v_run = cur.var(oracledb.NUMBER)
    v_code = cur.var(str, 60)
    v_eng = cur.var(str, 20)
    v_stype = cur.var(str, 20)
    v_sref = cur.var(oracledb.DB_TYPE_CLOB)
    v_par = cur.var(oracledb.DB_TYPE_CLOB)
    v_fmt = cur.var(str, 40)
    v_by = cur.var(str, 100)
    cur.callproc("prod.dct_rpt_pkg.claim_next",
                 [WORKER_ID, v_run, v_code, v_eng, v_stype, v_sref, v_par, v_fmt, v_by])
    run_id = v_run.getvalue()
    if run_id is None:
        return None
    return {
        "run_id": int(run_id),
        "report_code": v_code.getvalue(),
        "engine": v_eng.getvalue(),
        "source_type": v_stype.getvalue(),
        "source_ref": _read(v_sref.getvalue()),
        "params": _read(v_par.getvalue()),
        "formats": v_fmt.getvalue(),
        "requested_by": v_by.getvalue(),
    }


def _definition_extras(conn, code):
    cur = conn.cursor()
    cur.execute("select name_en, email_subject_tpl, email_body_tpl "
                "from prod.dct_rpt_definition where report_code = :c", c=code)
    row = cur.fetchone()
    return row if row else (code, None, None)


def record_output(conn, run_id, fmt, name, mime, data):
    cur = conn.cursor()
    lob = conn.createlob(oracledb.DB_TYPE_BLOB)
    lob.write(data)
    v = cur.var(oracledb.NUMBER)
    cur.execute("begin :id := prod.dct_rpt_pkg.record_output(:r, :f, :n, :m, :b, :s); end;",
                id=v, r=run_id, f=fmt, n=name, m=mime, b=lob, s=_sha256(data))


def mark(conn, run_id, status, row_count=None, error=None):
    conn.cursor().callproc("prod.dct_rpt_pkg.mark_status", [run_id, status, row_count, error])


def process(conn, conf, job):
    run_id = job["run_id"]
    code = job["report_code"]
    params = json.loads(job["params"]) if job.get("params") else {}
    name_en, subj_tpl, body_tpl = _definition_extras(conn, code)

    columns, rows = datasource.fetch(conn, job["source_type"], job["source_ref"], params)
    stamp = _now().strftime("%Y%m%d_%H%M")
    period = params.get("period")
    meta = f"Generated {_now().strftime('%Y-%m-%d %I:%M %p')} | {len(rows)} rows" + \
           (f" | period {period}" if period else "")
    ctx = {
        "report_code": code, "report_name": name_en or code,
        "period": period, "generated_at": _now().strftime("%Y-%m-%d %I:%M %p"),
        "row_count": len(rows), "requested_by": job.get("requested_by"),
        "headers": [str(c).replace("_", " ").title() for c in columns],
        "columns": columns, "rows": rows, "meta": meta, "brand": "#1F6F8B",
    }

    formats = [f.strip().upper() for f in (job.get("formats") or "PDF,XLSX").split(",") if f.strip()]
    renderer = config.cfg(conf, "PDF_RENDERER", "PLAYWRIGHT")
    attachments = []
    if "PDF" in formats:
        pdf = render_pdf.build_pdf(ctx, renderer=renderer)
        fn = f"{code}_{stamp}.pdf"
        record_output(conn, run_id, "PDF", fn, "application/pdf", pdf)
        attachments.append((fn, "application/pdf", pdf))
    if "XLSX" in formats:
        xlsx = render_xlsx.build_xlsx(columns, rows, title=name_en or code, meta=meta,
                                      sheet_name=code)
        fn = f"{code}_{stamp}.xlsx"
        record_output(conn, run_id, "XLSX", fn, XLSX_MIME, xlsx)
        attachments.append((fn, XLSX_MIME, xlsx))
    if "CSV" in formats:
        csv_bytes = _csv(columns, rows)
        fn = f"{code}_{stamp}.csv"
        record_output(conn, run_id, "CSV", fn, "text/csv", csv_bytes)
        attachments.append((fn, "text/csv", csv_bytes))

    sent = failed = 0
    if (config.cfg(conf, "EMAIL_ENABLED", "N") or "N").upper() == "Y" and attachments:
        sent, failed = deliver.send_report(conn, conf, run_id, ctx, subj_tpl, body_tpl, attachments)

    mark(conn, run_id, "SUCCESS", row_count=len(rows))
    print(f"[run {run_id}] {code} OK: {len(rows)} rows, formats={','.join(formats)}, "
          f"email sent={sent} failed={failed}")


def _csv(columns, rows):
    import io
    import csv as _c
    buf = io.StringIO()
    w = _c.writer(buf)
    w.writerow(columns)
    for r in rows:
        w.writerow(r)
    return ("﻿" + buf.getvalue()).encode("utf-8")   # BOM so Excel reads Arabic


def process_one(conn, conf):
    job = claim(conn)
    if not job:
        return False
    try:
        process(conn, conf, job)
    except Exception as e:  # noqa: BLE001
        msg = f"{type(e).__name__}: {e}"
        print(f"[run {job['run_id']}] {job['report_code']} FAILED: {msg}", file=sys.stderr)
        try:
            mark(conn, job["run_id"], "FAILED", error=msg[:3900])
        except Exception:  # noqa: BLE001
            pass
        notify.send(f"i-Finance report {job['report_code']} (run {job['run_id']}) FAILED: {msg}")
    return True


def enqueue(conn, code, params):
    cur = conn.cursor()
    v = cur.var(oracledb.NUMBER)
    cur.execute("begin :id := prod.dct_rpt_pkg.enqueue(:c, :p, 'ONDEMAND', :by); end;",
                id=v, c=code, p=(json.dumps(params) if params else None), by=WORKER_ID)
    conn.commit()
    return int(v.getvalue())


def main(argv=None):
    ap = argparse.ArgumentParser(description="i-Finance Reporting runner (PYTHON engine)")
    ap.add_argument("--once", action="store_true", help="process at most one run")
    ap.add_argument("--forever", action="store_true", help="long-running worker")
    ap.add_argument("--reclaim", action="store_true", help="requeue stuck runs and exit")
    ap.add_argument("--run", metavar="REPORT_CODE", help="enqueue this report then drain")
    ap.add_argument("--period", help="value for the :period bind (with --run)")
    args = ap.parse_args(argv)

    conn = config.connect()
    conf = config.load_config(conn)

    if args.reclaim:
        conn.cursor().callproc("prod.dct_rpt_pkg.reclaim_stuck")
        print("reclaimed stuck runs")
        return 0

    if args.run:
        rid = enqueue(conn, args.run, {"period": args.period} if args.period else {})
        print(f"enqueued run {rid} for {args.run}")

    if args.forever:
        idle = int(config.cfg(conf, "WORKER_IDLE_SEC", "20"))
        print(f"[worker {WORKER_ID}] forever (idle={idle}s)")
        while True:
            try:
                if not process_one(conn, conf):
                    time.sleep(idle)
                conf = config.load_config(conn)   # pick up UI config changes
            except Exception as e:  # noqa: BLE001
                print(f"[worker] loop error: {e}", file=sys.stderr)
                time.sleep(idle)

    if args.once:
        process_one(conn, conf)
        return 0

    n = 0
    while process_one(conn, conf):
        n += 1
    print(f"drained {n} run(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
