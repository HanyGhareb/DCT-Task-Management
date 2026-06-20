"""otbi-atd : HEADED smoke test for the AP-invoice action (run on the runner host).

Drives ap_invoice.create() in a VISIBLE browser, bypassing the queue, so you can
watch login -> navigate -> fill -> (save) and tune the Create-Invoice selectors.

It also runs a fscmRestApi REACHABILITY PROBE first and reports the verdict — this
is the test for "where does the InvoiceId come from": if REST is reachable we read
the InvoiceId back by invoice number; if not, we fall back to the invoice number we
set (our idem_key) and idempotency must be UI-based.

Usage (from otbi-atd/runner, with env.ps1 dot-sourced for DB + Fusion creds):
  python smoke_ap_invoice.py payload.json            # dry run: fill form, DO NOT save
  $env:ATD_ACTION_LIVE=1; python smoke_ap_invoice.py payload.json   # actually create
  python smoke_ap_invoice.py payload.json --probe-only   # only test REST reachability

Needs oracledb env (ATD_DB_USER/PASSWORD/DSN + TNS_ADMIN[/ATD_WALLET_PASSWORD]) to
read the env row, and a valid/created Fusion SSO session (MFA approved if expired).
"""
import json
import os
import sys
import time

from playwright.sync_api import sync_playwright

import config
import auth
from actions import ap_invoice, DryRun


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    if not e:
        raise SystemExit("No enabled BROWSER env in ATD_OTBI_ENV.")
    return {"env_name": e["env_name"],
            "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


def _probe(ctx, env, invoice_number):
    base = ap_invoice._apps_base(env)
    print(f"\n[probe] Fusion apps base : {base}")
    print(f"[probe] fscmRestApi GET invoices?q=InvoiceNumber={invoice_number} ...")
    try:
        found = ap_invoice.find_existing_invoice(ctx, env, invoice_number)
        print(f"[probe] REST REACHABLE (JSON ok). existing InvoiceId = {found!r}")
        print("[probe] => InvoiceId will come from this REST read-back; idempotency = REST probe.")
        return True
    except Exception as e:  # noqa: BLE001
        print(f"[probe] REST NOT usable: {e}")
        print("[probe] => fall back to the invoice number (idem_key) as the reference; "
              "idempotency must be UI-search-based.")
        return False


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("-")]
    probe_only = "--probe-only" in argv
    if not args:
        raise SystemExit("usage: python smoke_ap_invoice.py <payload.json> [--probe-only]")
    with open(args[0], "r", encoding="utf-8") as fh:
        payload = json.load(fh)
    num = payload.get("invoiceNumber")
    if not num:
        raise SystemExit("payload.json missing 'invoiceNumber'")

    env = _env_from_db()
    live = os.environ.get("ATD_ACTION_LIVE", "0") == "1"
    print(f"[smoke] env={env['env_name']}  live={live}  invoice={num}")

    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=False)  # visible; MFA if expired
        try:
            _probe(ctx, env, num)
            if probe_only:
                return
            print("\n[smoke] creating invoice via the UI "
                  + ("(LIVE — will SAVE)" if live else "(DRY RUN — fills form, will NOT save)"))
            try:
                fusion_id, ref = ap_invoice.create(ctx, env, payload, {"idem_key": num})
                print(f"[smoke] RESULT: {ref} -> id={fusion_id}")
            except DryRun as d:
                print(f"[smoke] DRY RUN OK: {d}")
            print("[smoke] leaving the browser open 30s for inspection ...")
            time.sleep(30)
        finally:
            browser.close()


if __name__ == "__main__":
    main(sys.argv)
