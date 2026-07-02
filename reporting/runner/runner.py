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
import os
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
HOSTNAME = socket.gethostname() or "rpt"
WORKER_ID = f"{HOSTNAME}/py{os.getpid()}"
XLSX_MIME = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

# worker registry (DCT_RPT_WORKER) is only maintained by long-running --forever
# workers; one-shot drains stay invisible to the BI Workers page
_registered = False


def _now():
    return datetime.now(DUBAI)


def _read(v):
    return v.read() if hasattr(v, "read") else v


def _sha256(data):
    return hashlib.sha256(data).hexdigest()


def beat(conn, status, current_run=None, done=0, failed=0, stopped=False):
    """Upsert this worker's DCT_RPT_WORKER row (no-op unless --forever)."""
    if not _registered:
        return
    try:
        conn.cursor().execute(
            """
            merge into prod.dct_rpt_worker w
            using (select :wid as worker_id from dual) s on (w.worker_id = s.worker_id)
            when matched then update set
              w.status = :st,
              w.current_run_id = :run,
              w.runs_done = w.runs_done + :done,
              w.runs_failed = w.runs_failed + :failed,
              w.last_heartbeat = systimestamp,
              w.stopped_at = case when :stopped = 1 then systimestamp else w.stopped_at end
            when not matched then insert
              (worker_id, engine, hostname, pid, status, started_at, last_heartbeat)
            values (:wid, 'PYTHON', :host, :pid, :st, systimestamp, systimestamp)
            """,
            wid=WORKER_ID, st=status, run=current_run, done=done, failed=failed,
            stopped=(1 if stopped else 0), host=HOSTNAME, pid=os.getpid())
        conn.commit()
    except Exception as e:  # noqa: BLE001 - registry must never kill the worker
        print(f"[worker] heartbeat failed: {e}", file=sys.stderr)


def read_command(conn):
    """The BI Workers page's desired action for this worker (PAUSE/RESUME/STOP)."""
    if not _registered:
        return None
    try:
        cur = conn.cursor()
        cur.execute("select command from prod.dct_rpt_worker where worker_id = :wid",
                    wid=WORKER_ID)
        row = cur.fetchone()
        return row[0] if row else None
    except Exception:  # noqa: BLE001
        return None


def clear_command(conn):
    try:
        conn.cursor().execute(
            "update prod.dct_rpt_worker set command = null where worker_id = :wid",
            wid=WORKER_ID)
        conn.commit()
    except Exception:  # noqa: BLE001
        pass


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
    cur.execute("select name_en, email_subject_tpl, email_body_tpl, pdf_template "
                "from prod.dct_rpt_definition where report_code = :c", c=code)
    row = cur.fetchone()
    return row if row else (code, None, None, None)


def record_output(conn, run_id, fmt, name, mime, data):
    cur = conn.cursor()
    lob = conn.createlob(oracledb.DB_TYPE_BLOB)
    lob.write(data)
    v = cur.var(oracledb.NUMBER)
    cur.execute("begin :id := prod.dct_rpt_pkg.record_output(:r, :f, :n, :m, :b, :s); end;",
                id=v, r=run_id, f=fmt, n=name, m=mime, b=lob, s=_sha256(data))


def mark(conn, run_id, status, row_count=None, error=None):
    conn.cursor().callproc("prod.dct_rpt_pkg.mark_status", [run_id, status, row_count, error])


def _headers(columns):
    return [str(c).replace("_", " ").title() for c in columns]


_MONEY_COLS = {"actual_ap", "actual_grn", "commitment_pr", "obligation_po",
               "fund_available", "balance_due", "matched_aed"}


def _is_money_col(name):
    n = str(name).lower()
    return n in _MONEY_COLS or n.endswith("_aed") or "amount" in n or "budget" in n


def _totals(columns, rows):
    """Per-column sums for money columns only (None elsewhere) — keeps the
    totals row meaningful (no sums of line numbers / counts / years)."""
    totals = [None] * len(columns)
    money = [_is_money_col(c) for c in columns]
    for row in rows:
        for j, v in enumerate(row):
            if money[j] and isinstance(v, (int, float)) and not isinstance(v, bool):
                totals[j] = (totals[j] or 0) + v
    return totals


def process(conn, conf, job):
    run_id = job["run_id"]
    code = job["report_code"]
    params = json.loads(job["params"]) if job.get("params") else {}
    name_en, subj_tpl, body_tpl, pdf_tpl = _definition_extras(conn, code)
    source_type = (job.get("source_type") or "SQL").upper()
    stamp = _now().strftime("%Y%m%d_%H%M")
    period = params.get("period")

    sections = None
    if source_type == "MULTI":
        spec, sections = datasource.fetch_multi(conn, job["source_ref"], params)
        for s in sections:
            s["headers"] = _headers(s["columns"])
            s["totals"] = _totals(s["columns"], s["rows"]) if s["layout"] == "table" else None
        columns, rows = [], []
        row_count = sum(len(s["rows"]) for s in sections)
        crumbs = " | ".join(f"{k} {v}" for k, v in params.items() if v not in (None, ""))
        meta = f"Generated {_now().strftime('%Y-%m-%d %I:%M %p')} | {row_count} lines" + \
               (f" | {crumbs}" if crumbs else "")
        landscape = (spec.get("orientation") or "").lower() == "landscape"
    else:
        columns, rows = datasource.fetch(conn, source_type, job["source_ref"], params)
        row_count = len(rows)
        meta = f"Generated {_now().strftime('%Y-%m-%d %I:%M %p')} | {row_count} rows" + \
               (f" | period {period}" if period else "")
        landscape = False

    ctx = {
        "report_code": code, "report_name": name_en or code,
        "period": period, "params": params,
        "generated_at": _now().strftime("%Y-%m-%d %I:%M %p"),
        "row_count": row_count, "requested_by": job.get("requested_by"),
        "headers": _headers(columns),
        "columns": columns, "rows": rows, "sections": sections,
        "meta": meta, "brand": "#1F6F8B", "landscape": landscape,
    }

    formats = [f.strip().upper() for f in (job.get("formats") or "PDF,XLSX").split(",") if f.strip()]
    renderer = config.cfg(conf, "PDF_RENDERER", "PLAYWRIGHT")
    attachments = []
    if "PDF" in formats:
        pdf = render_pdf.build_pdf(ctx, template_name=(pdf_tpl or "report.html.j2"),
                                   renderer=renderer)
        fn = f"{code}_{stamp}.pdf"
        record_output(conn, run_id, "PDF", fn, "application/pdf", pdf)
        attachments.append((fn, "application/pdf", pdf))
    if "XLSX" in formats:
        if sections is not None:
            xlsx = render_xlsx.build_xlsx_multi(sections, title=name_en or code, meta=meta)
        else:
            xlsx = render_xlsx.build_xlsx(columns, rows, title=name_en or code, meta=meta,
                                          sheet_name=code)
        fn = f"{code}_{stamp}.xlsx"
        record_output(conn, run_id, "XLSX", fn, XLSX_MIME, xlsx)
        attachments.append((fn, XLSX_MIME, xlsx))
    if "CSV" in formats:
        csv_bytes = _csv_multi(sections) if sections is not None else _csv(columns, rows)
        fn = f"{code}_{stamp}.csv"
        record_output(conn, run_id, "CSV", fn, "text/csv", csv_bytes)
        attachments.append((fn, "text/csv", csv_bytes))

    sent = failed = 0
    if (config.cfg(conf, "EMAIL_ENABLED", "N") or "N").upper() == "Y" and attachments:
        sent, failed = deliver.send_report(conn, conf, run_id, ctx, subj_tpl, body_tpl, attachments)

    mark(conn, run_id, "SUCCESS", row_count=row_count)
    print(f"[run {run_id}] {code} OK: {row_count} rows, formats={','.join(formats)}, "
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


def _csv_multi(sections):
    import io
    import csv as _c
    buf = io.StringIO()
    w = _c.writer(buf)
    for i, s in enumerate(sections):
        if i:
            w.writerow([])
        w.writerow([s.get("title") or s.get("key") or "Section"])
        w.writerow(s["columns"])
        for r in s["rows"]:
            w.writerow(r)
    return ("﻿" + buf.getvalue()).encode("utf-8")   # BOM so Excel reads Arabic


def process_one(conn, conf):
    job = claim(conn)
    if not job:
        return False
    beat(conn, "RUNNING", current_run=job["run_id"])
    try:
        process(conn, conf, job)
        beat(conn, "IDLE", done=1)
    except Exception as e:  # noqa: BLE001
        msg = f"{type(e).__name__}: {e}"
        print(f"[run {job['run_id']}] {job['report_code']} FAILED: {msg}", file=sys.stderr)
        try:
            mark(conn, job["run_id"], "FAILED", error=msg[:3900])
        except Exception:  # noqa: BLE001
            pass
        beat(conn, "IDLE", failed=1)
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
    ap.add_argument("--params", metavar="JSON",
                    help='run parameters as JSON, e.g. \'{"year":2026,"sector":"..."}\' (with --run)')
    args = ap.parse_args(argv)

    conn = config.connect()
    conf = config.load_config(conn)

    if args.reclaim:
        conn.cursor().callproc("prod.dct_rpt_pkg.reclaim_stuck")
        print("reclaimed stuck runs")
        return 0

    if args.run:
        run_params = json.loads(args.params) if args.params else {}
        if args.period:
            run_params.setdefault("period", args.period)
        rid = enqueue(conn, args.run, run_params)
        print(f"enqueued run {rid} for {args.run}")

    if args.forever:
        global _registered
        _registered = True
        idle = int(config.cfg(conf, "WORKER_IDLE_SEC", "20"))
        print(f"[worker {WORKER_ID}] forever (idle={idle}s)")
        beat(conn, "IDLE")
        try:
            while True:
                try:
                    cmd = read_command(conn)
                    if cmd == "STOP":
                        print(f"[worker {WORKER_ID}] STOP command received — exiting")
                        clear_command(conn)
                        beat(conn, "STOPPED", stopped=True)
                        return 0
                    if cmd == "PAUSE":
                        beat(conn, "PAUSED")
                        time.sleep(idle)
                        continue
                    if cmd == "RESUME":
                        clear_command(conn)
                    if not process_one(conn, conf):
                        beat(conn, "IDLE")
                        time.sleep(idle)
                    conf = config.load_config(conn)   # pick up UI config changes
                except Exception as e:  # noqa: BLE001
                    print(f"[worker] loop error: {e}", file=sys.stderr)
                    time.sleep(idle)
        finally:
            beat(conn, "STOPPED", stopped=True)

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
