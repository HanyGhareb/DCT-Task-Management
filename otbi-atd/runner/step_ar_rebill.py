"""Supervised, stage-by-stage execution of an AR_INVOICE_REBILL against a REAL
invoice, with a human confirming each stage before the next one runs.

WHY THIS EXISTS (and why it is not just `--stop-after` in a loop)
Stages 5-8 share ONE live browser form: `Actions > Duplicate` opens a Create
Transaction form that exists only in the browser's memory until `Complete and
Review` commits it. Exiting between those stages would throw the form away, so
a "run one stage per invocation" approach cannot work. This script keeps the
SAME page object alive and simply pauses between stages.

HOW THE PAUSE WORKS
After each stage it writes <ctl>/NN_<STAGE>.json (status, note, captured ref,
screenshot path), prints a STAGE-DONE line, and then waits for the file
<ctl>/go_<next-stage-number> to appear before continuing. Create that file to
approve the next stage; create <ctl>/abort to stop cleanly.

SAFETY
  * ATD_AR_REBILL_ALLOW must contain the invoice -- the handler refuses
    otherwise. Set it; do not remove the guard for a supervised run.
  * ATD_ACTION_LIVE=1 is required for any committing click. Without it every
    stage still runs and stops at its commit (a full dry walk-through).
  * The action row is enqueued first, so the AR register and the
    ATD_ACTION_STEP timeline reflect progress exactly as a fleet run would.
  * Screenshots are written per stage when ATD_ACTION_SHOT_DIR is set.

USAGE
    python step_ar_rebill.py payload.json [--ctl /root/otbi-atd/runner/.ar_step]

payload.json is one request in the API shape:
  {"invoiceNumber": "...",
   "cm": {"transactionNumber","transactionDate","accountingDate",
          "creditReason","comments","finish"},
   "duplicate": {"transactionSource","transactionDate","accountingDate"},
   "lines": [{"lineNumber","memoLine","taxClassification",
              "projectNumber","taskNumber"}]}

NOTE ON PAUSE LENGTH: the Fusion/ADF session can idle out. Keep confirmations
within a few minutes; if a stage fails after a long pause, re-run from the
checkpoint rather than assuming a selector broke.
"""
import json
import os
import sys
import time

from playwright.sync_api import sync_playwright

import auth
import config
from actions import DryRun
from actions import ar_invoice_rebill as ar
from actions.ap_invoice import _apps_base

POLL_SECS = 3
PAUSE_TIMEOUT_SECS = int(os.environ.get("AR_STEP_PAUSE_TIMEOUT", "3600"))


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    return {"env_name": e["env_name"], "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


OWNER = "supervised"


def _enqueue(conn, payload, who="step.supervised"):
    """Create the queue row so the AR register + timeline show this run, then
    IMMEDIATELY take ownership of it.

    The worker fleet drains ATD_ACTION_REQUEST in its idle loop and claims any
    READY row regardless of action type (runner._drain_actions_idle). A row left
    READY would therefore be raced: a VM could pick this invoice up and drive it
    UNSUPERVISED while the operator is still confirming stage 2. Claiming it
    here makes it invisible to claim_next_action, which only selects READY.
    """
    cur = conn.cursor()
    aid = cur.callfunc("prod.atd_action_pkg.enqueue_action", int, [
        "AR_INVOICE_REBILL", "AR", "AR_REBILL", None,
        payload["invoiceNumber"],
        "AR-REBILL:" + payload["invoiceNumber"].upper(),
        json.dumps(payload), None, who])
    cur.execute("""UPDATE prod.atd_action_request
                      SET run_status = 'CLAIMED', claimed_by = :o,
                          claimed_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
                          worker_host = :o, started_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
                          updated_at = SYSTIMESTAMP
                    WHERE action_id = :a AND run_status <> 'DONE'""",
                {"o": OWNER, "a": aid})
    conn.commit()
    cur.close()
    return aid


def _renew_lease(conn, action_id):
    """Re-stamp claimed_at so reap_stale_actions cannot hand this row back to
    READY (default lease 30 min) during a long operator pause -- which would
    let a worker claim it mid-flight."""
    try:
        cur = conn.cursor()
        cur.execute("""UPDATE prod.atd_action_request
                          SET claimed_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
                              updated_at = SYSTIMESTAMP
                        WHERE action_id = :a AND claimed_by = :o""",
                    {"a": action_id, "o": OWNER})
        conn.commit()
        cur.close()
    except Exception as e:  # noqa: BLE001
        print("  (lease renewal failed: %s)" % str(e)[:80], flush=True)


def _wait_for_go(ctl, stage_no, stage_code, conn=None, action_id=None):
    """Block until the operator approves the next stage, renewing the queue
    lease while we wait so no worker can claim this row mid-run."""
    go = os.path.join(ctl, "go_%d" % stage_no)
    abort = os.path.join(ctl, "abort")
    waited = 0
    print("WAITING for approval of stage %d (%s) -- create %s"
          % (stage_no, stage_code, go), flush=True)
    while waited < PAUSE_TIMEOUT_SECS:
        if os.path.exists(abort):
            raise SystemExit("ABORTED by operator (%s)" % abort)
        if os.path.exists(go):
            print("APPROVED stage %d (%s)" % (stage_no, stage_code), flush=True)
            return
        time.sleep(POLL_SECS)
        waited += POLL_SECS
        if conn is not None and action_id and waited % 300 == 0:
            _renew_lease(conn, action_id)   # every 5 min, well inside the lease
    raise SystemExit("TIMED OUT waiting for approval of stage %d after %ds"
                     % (stage_no, PAUSE_TIMEOUT_SECS))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print(__doc__)
        raise SystemExit("usage: step_ar_rebill.py payload.json")
    ctl = "/root/otbi-atd/runner/.ar_step"
    if "--ctl" in sys.argv:
        ctl = sys.argv[sys.argv.index("--ctl") + 1]
    os.makedirs(ctl, exist_ok=True)

    payload = ar.validate_payload(json.load(open(args[0])))
    ar._check_allowlist(payload["invoiceNumber"])       # hard refusal if off-list

    live = os.environ.get("ATD_ACTION_LIVE") == "1"
    print("=" * 70, flush=True)
    print("SUPERVISED REBILL  invoice=%s  LIVE=%s  lines=%d"
          % (payload["invoiceNumber"], live, len(payload["lines"])), flush=True)
    print("  credit memo : %s  finish=%s  dates %s / %s"
          % (payload["cm"]["transactionNumber"], payload["cm"]["finish"],
             payload["cm"]["transactionDate"], payload["cm"]["accountingDate"]),
          flush=True)
    print("  duplicate   : source=%s  dates %s / %s"
          % (payload["duplicate"]["transactionSource"],
             payload["duplicate"]["transactionDate"],
             payload["duplicate"]["accountingDate"]), flush=True)
    for l in payload["lines"]:
        print("  line %-3s %-38s tax=%-18s proj=%s task=%s"
              % (l["lineNumber"], l["memoLine"][:38],
                 l["taxClassification"] or "(unchanged)",
                 l["projectNumber"], l["taskNumber"]), flush=True)
    print("  control dir : %s" % ctl, flush=True)
    print("=" * 70, flush=True)

    conn = config.connect()
    try:
        action_id = _enqueue(conn, payload)
        print("ACTION_ID=%d" % action_id, flush=True)
        saga = ar._Saga(conn, action_id, "supervised", 1)
        start = saga.resume_from()
        if start > 1:
            print("RESUMING at stage %d (earlier stages already checkpointed)"
                  % start, flush=True)

        env = _env_from_db()
        base = _apps_base(env)
        with sync_playwright() as p:
            browser, ctx = auth.authenticate(p, env, headless=True)
            try:
                page = ctx.new_page()
                page.set_default_timeout(45000)
                page.set_viewport_size({"width": 1700, "height": 1200})
                run = ar._Run(page, base, payload, saga)
                if start > 1:
                    run.cm_txn_number = saga.ref("CM_CREATE")
                    run.cm_doc_number = saga.ref("CM_CAPTURE")
                    run.new_txn_number = saga.ref("DUPLICATE")
                    run.new_doc_number = saga.ref("DUP_CAPTURE")

                for no, code, fn in ar.STAGES:
                    if no < start:
                        continue
                    if no > 1 or start > 1:
                        _wait_for_go(ctl, no, code, conn, action_id)

                    print("-" * 70, flush=True)
                    print("RUNNING stage %d %s" % (no, code), flush=True)
                    saga.begin(no, code)
                    shot = None
                    try:
                        status, ref, note = fn(run)
                    except DryRun as e:
                        saga.end(code, "RUNNING", None, "dry run stopped here")
                        print("STAGE-DRYRUN %d %s :: %s" % (no, code, e), flush=True)
                        _write(ctl, no, code, "DRYRUN", str(e), None, page)
                        print("Set ATD_ACTION_LIVE=1 to perform the committing "
                              "click, then re-run: it resumes from the "
                              "checkpoint.", flush=True)
                        return
                    except Exception as e:  # noqa: BLE001
                        saga.fail(code, e)
                        print("STAGE-FAILED %d %s :: %s" % (no, code, e), flush=True)
                        _write(ctl, no, code, "FAILED", str(e), None, page)
                        raise
                    saga.end(code, status, ref, note)
                    shot = _write(ctl, no, code, status, note, ref, page)
                    print("STAGE-DONE %d %s status=%s ref=%s :: %s"
                          % (no, code, status, ref or "-", note), flush=True)
                    if shot:
                        print("  screenshot: %s" % shot, flush=True)

                doc = run.new_doc_number or saga.ref("DUP_CAPTURE")
                cm = run.cm_doc_number or saga.ref("CM_CAPTURE")
                conn.cursor().callproc("prod.atd_action_pkg.mark_action_done",
                                       [action_id, doc,
                                        "rebilled %s (credit memo %s)"
                                        % (payload["invoiceNumber"], cm or "n/a")])
                print("=" * 70, flush=True)
                print("COMPLETE  new invoice document no = %s | credit memo "
                      "document no = %s" % (doc, cm), flush=True)
            finally:
                browser.close()
    finally:
        try:
            conn.close()
        except Exception:  # noqa: BLE001
            pass


def _write(ctl, no, code, status, note, ref, page):
    shot = os.path.join(ctl, "%02d_%s.png" % (no, code))
    try:
        page.screenshot(path=shot, full_page=True)
    except Exception:  # noqa: BLE001
        shot = None
    with open(os.path.join(ctl, "%02d_%s.json" % (no, code)), "w") as f:
        json.dump({"stage": no, "code": code, "status": status,
                   "note": note, "ref": ref, "screenshot": shot,
                   "url": (page.url or "")[:200]}, f, indent=1)
    return shot


if __name__ == "__main__":
    main()
