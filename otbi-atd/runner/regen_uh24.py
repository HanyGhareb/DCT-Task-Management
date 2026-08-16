"""otbi-atd : regenerate every _UH24 incremental analysis from its (heading-pinned)
FULL analysis — Save-As over the SAME catalog name, re-adding the 24h relative filter.
Guarantees Full and UH24 always carry identical (pinned) column headings.

  python regen_uh24.py [--only "PO Headers,..."]  [--verify]
"""
import argparse
import os
import sys
import time

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

import auth
import copy_analysis as ca
import extract

U = "/users/haghareb@dctabudhabi.ae/Data"

# family, full analysis path, UH24 name (same folder), 24h filter column heading
PLAN = [
    ("AP Invoices",      f"{U}/AP/prod/AP Invoices/AP_INVOICES_F",                         "AP_INVOICES_UH24",              "Last Updated Date"),
    ("AP Lines",         f"{U}/AP/prod/AP Invoice Lines/AP_INVOICE_LINES_F",               "AP_INVOICE_LINES_UH24",         "Last Updated Date"),
    ("AP Distributions", f"{U}/AP/prod/AP Invoice Distributions/AP_INVOICE_DISTRIBUTIONS_F", "AP_INVOICE_DISTRIBUTIONS_UH24", "Last Updated Date"),
    ("AP Installments",  f"{U}/AP/prod/AP Invoice Installments/AP_INVOICE_INSTALLMENTS",   "AP_INVOICE_INSTALLMENTS_UH24",  "Last Updated Date"),
    ("PO Headers",       f"{U}/PO/prod/PO Headers/PO_HEADERS_F",                           "PO_HEADERS_UH24",               "Updated Date"),
    ("PO Lines",         f"{U}/PO/prod/PO Lines/PO_LINES_F",                               "PO_LINES_UH24",                 "Updated on"),
    ("PO Schedules",     f"{U}/PO/prod/PO Schedules/PO Schedules",                         "PO_SCHEDULES_UH24",             "Schedule Last Updated Date"),
    ("PO Distributions", f"{U}/PO/prod/PO Distributions/PO Distributions",                 "PO_DISTRIBUTIONS_UH24",         "Last Updated Date"),
    ("PR Headers",       f"{U}/PR/prod/01_PR_HEADERS/01_PR_HEADERS_F",                     "01_PR_HEADERS_UH24",            "Last Updated Date"),
    ("PR Lines",         f"{U}/PR/prod/02_PR_LINES/01_PR_LINES_F",                         "01_PR_LINES_UH24",              "Last Updated Date"),
    ("PR Distributions", f"{U}/PR/prod/03_PR_DISTRIBUTIONS/01_PR_DISTRIBUTIONS_F",         "01_PR_DISTRIBUTIONS_UH24",      "Last Updated Date"),
    ("Suppliers",        f"{U}/Suppliers/prod/01-Suppliers",                               "SUPPLIERS_UH24",                "Last Updated"),
    ("Supplier Sites",   f"{U}/Suppliers/prod/02-Supplier_Sites",                          "SUPPLIER_SITES_UH24",           "Last Updated"),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", help="comma-separated family filter")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--headed", action="store_true")
    a = ap.parse_args()

    plan = PLAN
    if a.only:
        keep = {s.strip() for s in a.only.split(",")}
        plan = [p for p in plan if p[0] in keep]
    print(f"[regen] {len(plan)} UH24 copies to regenerate", flush=True)

    env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
           "analytics_base_url": ca.DEFAULT_BASE,
           "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}

    results = []
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not a.headed)
        page = ctx.new_page()
        page.set_default_timeout(ca.STEP_TIMEOUT)
        for i, (fam, src, to_name, on_col) in enumerate(plan, 1):
            print(f"\n[regen] ({i}/{len(plan)}) {fam}: {src} -> {to_name}", flush=True)
            try:
                ca.do_copy(page, ca.DEFAULT_BASE, src, to_name, hour=24, on_column=on_col)
                if a.verify:
                    new_path = src.rsplit("/", 1)[0] + "/" + to_name
                    csv = extract.download_csv(ctx, env, new_path)
                    lines = csv.splitlines()
                    print(f"[regen] verify: {len(lines)} CSV lines; header: {lines[0][:200] if lines else '(empty)'}",
                          flush=True)
                results.append((fam, "PASS"))
            except Exception as e:  # noqa: BLE001
                ca._shot(page, f"regenfail_{i}")
                results.append((fam, f"FAIL {str(e)[:150]}"))
                print(f"[regen] FAIL {fam}: {e}", flush=True)
                try:
                    page.close(); page = ctx.new_page()
                    page.set_default_timeout(ca.STEP_TIMEOUT)
                except Exception:
                    pass
            time.sleep(2)
        browser.close()

    print("\n[regen] ======== SUMMARY ========", flush=True)
    for fam, st in results:
        print(f"[regen] {st:5s} {fam}", flush=True)


if __name__ == "__main__":
    main()
