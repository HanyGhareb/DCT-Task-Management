"""Generate AR_INVOICE_REBILL payload JSONs from the flat rebill CSV.

CSV columns: Invoice Number, Memo Line, Project Number, Task, VAT Rate Code,
CM Number, New Invoice Number (the last two are RESULT columns, ignored here).
Rows are grouped by Invoice Number; the MEMO LINE is the matching key (user
rule 2026-07-26) so no line numbers are emitted.
"""
import csv
import json
import sys

DATE = "2026-02-28"
REASON = "Tax rate error"
FINISH = "COMPLETE_AND_CLOSE"
SOURCE = "DCT Manual"


def main(csv_path, out_dir, only=None):
    groups = {}
    order = []
    with open(csv_path, newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            inv = (row.get("Invoice Number") or "").strip().replace("\xa0", "")
            if not inv:
                continue
            if inv not in groups:
                groups[inv] = []
                order.append(inv)
            groups[inv].append({
                "memoLine": (row.get("Memo Line") or "").strip(),
                "taxClassification": (row.get("VAT Rate Code") or "").strip(),
                "projectNumber": (row.get("Project Number") or "").strip(),
                "taskNumber": (row.get("Task") or "").strip(),
            })
    wanted = [i.strip() for i in only.split(",")] if only else order
    for inv in wanted:
        if inv not in groups:
            raise SystemExit("invoice %s not in the CSV" % inv)
        payload = {
            "invoiceNumber": inv,
            "cm": {"transactionNumber": inv + "CM",
                   "transactionDate": DATE, "accountingDate": DATE,
                   "creditReason": REASON,
                   "comments": "Credit Inv# %s to correct TAX code" % inv,
                   "finish": FINISH},
            "duplicate": {"transactionSource": SOURCE,
                          "transactionDate": DATE, "accountingDate": DATE},
            "lines": groups[inv],
        }
        path = "%s/payload_%s.json" % (out_dir, inv)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(payload, f, indent=2)
        print("%s  (%d lines)" % (path, len(groups[inv])))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
