"""Build pin_plans.json for pin_batch.py from PROD.ATD_OTBI_JOBS column maps.

Scope: every enabled-catalog CSV analysis under the haghareb folder — the FULL /
standalone analyses only (the _UH24 incremental copies are regenerated from the fixed
Fulls afterwards, so they are excluded here). AR (saljaaidi) and BIP .xdo excluded.

Strays (columns the drift engine auto-added after a Fusion heading rename) are removed
from `expected` and mapped back to the original heading via `renames`.
"""
import json
import os

import oracledb

OUT = os.path.join(os.environ.get("ATD_STATE_DIR", "."), "pin_plans.json")

EXCLUDE_JOBS = {
    "AR INVOICE LINES - ALL", "AR Invoice Distribution Details - ALL",   # saljaaidi catalog
    "PR PO Pending Approval",                                            # BIP .xdo
    "Projects Budget Full",                                              # same analysis as V2
}

# per-job: strays to drop from expected + rename map current->required
STRAYS = {
    "PO Headers Full": {"drop": ["Supplier"], "ren": {"Supplier": "Supplier Name"}},
    "PR Lines All": {"drop": ["Supplier"], "ren": {"Supplier": "Supplier Name"}},
    "Suppliers Full": {"drop": ["DataFox Legal Name"],
                       "ren": {"DataFox Legal Name": "Legal Name"}},
    "AP Invoices Full": {
        "drop": ["Invoice Accounting Date", "Invoice Canceled Date",
                 "Intercompany Invoice Indicator", "Pay alone", "Supplier or Party Site"],
        "ren": {"Invoice Accounting Date": "GL Date",
                "Invoice Canceled Date": "Cancelled Date",
                "Intercompany Invoice Indicator": "Inter Company Flag",
                "Pay alone": "Pay Alone Flag",
                "Supplier or Party Site": "Party Site Name"}},
}


def main():
    conn = oracledb.connect(user=os.environ["ATD_DB_USER"],
                            password=os.environ["ATD_DB_PASSWORD"],
                            dsn=os.environ["ATD_DB_DSN"],
                            config_dir=os.environ.get("TNS_ADMIN"),
                            wallet_location=os.environ.get("TNS_ADMIN"),
                            wallet_password=os.environ.get("ATD_WALLET_PASSWORD"))
    cur = conn.cursor()
    cur.execute("""select job_name, source_ref, column_map_json
                     from prod.atd_otbi_jobs
                    where output_format = 'csv'
                      and source_ref not like '%_UH24'
                    order by job_name""")
    plans = []
    for jn, src, cm in cur:
        if jn in EXCLUDE_JOBS or cm is None:
            continue
        cmj = json.loads(cm.read() if hasattr(cm, "read") else cm)
        s = STRAYS.get(jn, {})
        expected = [h for h in cmj.keys() if h not in set(s.get("drop", []))]
        plans.append({"job": jn, "path": src, "expected": expected,
                      "renames": s.get("ren", {})})
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(plans, f, indent=1)
    print(f"wrote {OUT}: {len(plans)} plans")
    for p in plans:
        print(f"  {p['job']:38s} cols={len(p['expected'])} renames={len(p['renames'])}")


if __name__ == "__main__":
    main()
