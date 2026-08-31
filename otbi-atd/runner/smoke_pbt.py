"""Smoke driver for the PBT extract action (runner/actions/pa_budget_trx.py).

Runs the handler OUTSIDE the queue so a new scope can be exercised and
reconciled by hand before the scheduled sync is switched on.

SESSION SAFETY: builds a fresh browser context from the SAVED storage_state
rather than opening the worker's persistent Chromium profile - so it can run
while atd-worker is live, and it can never initiate a login (which would fire
an unattended Authenticator push). If the session has expired the handler
raises SessionExpired and this exits non-zero; recover it the normal way.

  python3 smoke_pbt.py --type Additional --from 2026-08-07 --to 2026-08-07
  python3 smoke_pbt.py --mode SYNC_DEEP                 # everything, all types
  python3 smoke_pbt.py --mode SYNC_SHALLOW --no-approvals
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

from playwright.sync_api import sync_playwright

from actions import pa_budget_trx as pbt

STATE_DIR = Path(os.environ.get("ATD_STATE_DIR", ".")).resolve()
ENV_NAME = os.environ.get("ATD_ENV_NAME", "FUSION_ADGOV")


def main(argv):
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", default="RANGE",
                    choices=["RANGE", "SYNC_SHALLOW", "SYNC_DEEP"])
    ap.add_argument("--type", action="append", dest="types",
                    help="repeatable; default = all three")
    ap.add_argument("--from", dest="date_from")
    ap.add_argument("--to", dest="date_to")
    ap.add_argument("--bu", action="append", dest="bus")
    ap.add_argument("--status", action="append", dest="statuses")
    ap.add_argument("--no-approvals", action="store_true")
    ap.add_argument("--purge", action="store_true",
                    help="delete rows that vanished upstream (full scope only)")
    ap.add_argument("--headed", action="store_true")
    a = ap.parse_args(argv[1:])

    payload = {
        "mode": a.mode,
        "transactionTypes": a.types or pbt.DEFAULT_TYPES,
        "businessUnits": a.bus or pbt.DEFAULT_BUS,
        "includeApprovals": not a.no_approvals,
        "purgeMissing": a.purge,
    }
    if a.date_from:
        payload["dateFrom"] = a.date_from
    if a.date_to:
        payload["dateTo"] = a.date_to
    if a.statuses:
        payload["statuses"] = a.statuses

    state = STATE_DIR / f"auth_state_{ENV_NAME}.json"
    if not state.exists():
        raise SystemExit(f"no saved session at {state} - start the worker once first")

    print("[smoke] payload:", json.dumps(payload, ensure_ascii=False))
    print(f"[smoke] session: {state}")
    t0 = time.time()

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not a.headed)
        ctx = browser.new_context(storage_state=str(state), ignore_https_errors=True)
        try:
            run_id, summary = pbt.extract(ctx, {"env_name": ENV_NAME}, payload,
                                          {"idem_key": "SMOKE"})
            print(f"\n[smoke] OK run_id={run_id} in {time.time() - t0:.0f}s\n"
                  f"[smoke] {summary}")
        except pbt.SessionExpired as e:
            print(f"\n[smoke] SESSION EXPIRED: {e}")
            return 2
        finally:
            ctx.close()
            browser.close()
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
