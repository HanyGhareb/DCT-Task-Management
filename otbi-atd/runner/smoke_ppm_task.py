"""otbi-atd : smoke test for the PPM_TASK_ADDL_INFO action (runner host / worker VM).

Drives ppm_task_addl.update() directly, bypassing the queue, so you can watch
(or screenshot) login -> My Projects -> project -> Manage Financial Project Plan
-> Display=List -> task filter -> Additional Information popup -> Organization
Reference fill, and tune the ADF selectors.

HEADLESS by default (the worker VMs have no display) with step screenshots
written to ./ppm_smoke_shots/; pass --headed on a desktop to watch the browser.

There is no REST idempotency probe for this action (fscmRestApi is 401 under
the ADGOV SSO — see docs/fusion-actions/README.md): it is an UPDATE (naturally
idempotent) and the guard is UI-based — the handler reads the popup's current
Organization Reference and skips the save when it already carries the target.

Usage (from the runner dir, with the runner env sourced for DB + Fusion creds):
  python smoke_ppm_task.py payload_ppm_task.json            # dry run: fill popup + OK, DO NOT Save
  ATD_ACTION_LIVE=1 python smoke_ppm_task.py payload_ppm_task.json   # actually update
  python smoke_ppm_task.py payload_ppm_task.json --headed   # visible browser (desktop)

Needs oracledb env (ATD_DB_USER/PASSWORD/DSN + TNS_ADMIN[/ATD_WALLET_PASSWORD])
to read the env row, and a valid/created Fusion SSO session (MFA if expired).
"""
import json
import os
import sys
import time

from playwright.sync_api import sync_playwright

import config
import auth
from actions import ppm_task_addl, DryRun


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


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("-")]
    headed = "--headed" in argv
    if not args:
        raise SystemExit("usage: python smoke_ppm_task.py <payload.json> [--headed]")
    with open(args[0], "r", encoding="utf-8") as fh:
        payload = json.load(fh)
    project, task, org_ref = ppm_task_addl.validate_payload(payload)

    # step screenshots for headless selector tuning
    shots = os.environ.setdefault("ATD_ACTION_SHOT_DIR",
                                  os.path.join(os.getcwd(), "ppm_smoke_shots"))
    os.makedirs(shots, exist_ok=True)

    env = _env_from_db()
    live = os.environ.get("ATD_ACTION_LIVE", "0") == "1"
    print(f"[smoke] env={env['env_name']}  live={live}  headed={headed}")
    print(f"[smoke] project={project}  task={task!r}  orgReference={org_ref}")
    print(f"[smoke] screenshots -> {shots}")

    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not headed)  # MFA if expired
        try:
            print("\n[smoke] updating the financial-plan task via the UI "
                  + ("(LIVE — will SAVE)" if live else "(DRY RUN — fills popup, will NOT Save)"))
            try:
                fusion_id, ref = ppm_task_addl.update(
                    ctx, env, payload,
                    {"idem_key": f"PPM-ORGREF:{project}:{task}:{org_ref}"})
                print(f"[smoke] RESULT: {ref} -> {fusion_id}")
            except DryRun as d:
                print(f"[smoke] DRY RUN OK: {d}")
            if headed:
                print("[smoke] leaving the browser open 30s for inspection ...")
                time.sleep(30)
        finally:
            browser.close()


if __name__ == "__main__":
    main(sys.argv)
