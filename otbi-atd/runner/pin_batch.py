"""otbi-atd : batch-pin Custom Headings on every extract analysis so CSV headers can
never drift when a Fusion patch renames a subject-area column's default heading.

Reads a plans JSON (built from PROD.ATD_OTBI_JOBS column maps by gen_pin_plans.py):
  [ {"job": "...", "path": "/users/.../ANALYSIS", "expected": ["Heading", ...],
     "renames": {"current heading": "required heading", ...}}, ... ]

For each analysis: open in Answers, Criteria, pin EVERY column's Custom Heading to its
required text (renaming drifted ones back), Save over the same name, verify the final
heading set against `expected`. One authenticated browser session for the whole batch.

  python pin_batch.py --plans /root/otbi-atd-state/pin_plans.json [--only "PO Headers Full"]
"""
import argparse
import json
import os
import sys
import time

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

import auth
import copy_analysis as ca


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--plans", required=True)
    ap.add_argument("--only", help="comma-separated job-name filter")
    ap.add_argument("--headed", action="store_true")
    a = ap.parse_args()

    plans = json.load(open(a.plans, encoding="utf-8"))
    if a.only:
        keep = {s.strip() for s in a.only.split(",")}
        plans = [p for p in plans if p["job"] in keep]
    print(f"[pin-batch] {len(plans)} analyses to process", flush=True)

    env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
           "analytics_base_url": ca.DEFAULT_BASE,
           "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}

    results = []
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not a.headed)
        page = ctx.new_page()
        page.set_default_timeout(ca.STEP_TIMEOUT)
        for i, plan in enumerate(plans, 1):
            job, path = plan["job"], plan["path"]
            print(f"\n[pin-batch] ({i}/{len(plans)}) {job}  ->  {path}", flush=True)
            try:
                before, after = ca.do_pin(page, ca.DEFAULT_BASE, path,
                                          plan["expected"], plan.get("renames", {}))
                missing = [h for h in plan["expected"] if h not in after]
                extra = [h for h in after if h not in plan["expected"]]
                status = "PASS" if not missing and not extra else "WARN"
                results.append((job, status, missing, extra))
                print(f"[pin-batch] {status} {job} missing={missing} extra={extra}", flush=True)
            except Exception as e:  # noqa: BLE001
                ca._shot(page, f"pinfail_{i}")
                results.append((job, "FAIL", str(e)[:200], None))
                print(f"[pin-batch] FAIL {job}: {e}", flush=True)
                # recover the session for the next analysis
                try:
                    page.close(); page = ctx.new_page()
                    page.set_default_timeout(ca.STEP_TIMEOUT)
                except Exception:
                    pass
            time.sleep(2)
        browser.close()

    print("\n[pin-batch] ======== SUMMARY ========", flush=True)
    for r in results:
        print(f"[pin-batch] {r[1]:5s} {r[0]}  {r[2] if r[1] != 'PASS' else ''}", flush=True)
    fails = [r for r in results if r[1] == "FAIL"]
    print(f"[pin-batch] done: {len(results) - len(fails)} ok, {len(fails)} failed", flush=True)


if __name__ == "__main__":
    main()
