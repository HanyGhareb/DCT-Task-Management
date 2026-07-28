#!/usr/bin/env python3
"""Bulk-load budget overrides from an adjustment sheet (cols: Project Number,
Project Name, Task, Expenditure Type, Budget, Override Budget = ADJUSTMENT).
Rule: override = earliest existing 2026 record budget + adjustment, so the
line effective annual = Budget + Adjustment. Stamps BUDGET_REALLOCATION +
provenance comment. First used 2026-07-28 (252/254 applied, reconciled to 4c).
Edit the file path/creds/year before reuse."""
import openpyxl, json, urllib.request, base64
from concurrent.futures import ThreadPoolExecutor
from collections import defaultdict

BASE = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl"
H = {"Authorization": "Basic " + base64.b64encode(b"ADMIN:iFinance@2026").decode(),
     "Content-Type": "application/json"}
COMMENT = "Bulk load 2026-07-28: Override Budget.xlsx (adjustment vs Fusion budget)"

wb = openpyxl.load_workbook('/root/DCT-Task-Management/docs/excel-integration/Override Budget.xlsx', data_only=True)
rows = []
for r in wb['Sheet2'].iter_rows(min_row=2, values_only=True):
    if r[0] is None: continue
    rows.append((str(r[0]).strip(), str(r[2]).strip(), str(r[3]).strip(), float(r[4] or 0), float(r[5] or 0)))

recs = defaultdict(list)
for m in range(1, 13):
    per = '%02d-2026' % m
    req = urllib.request.Request(BASE + "/budget/?budget_year=2026&accounting_period=%s&limit=10000" % per, headers=H)
    for i in json.loads(urllib.request.urlopen(req, timeout=120).read())['items']:
        recs[(i['project_number'], i['task_number'], i['expenditure_type'])].append(i)

def pnum(p):  # MM-YYYY sort key
    return (int(p[3:]), int(p[:2]))

tasks, skipped = [], []
for p, t, e, b, adj in rows:
    lst = recs.get((p, t, e))
    if not lst:
        skipped.append((p, t, e, 'no 2026 budget record'))
        continue
    lst = sorted(lst, key=lambda i: pnum(i['accounting_period']))
    tgt = lst[0]
    newv = round((tgt['budget'] or 0) + adj, 2)
    tasks.append((tgt['id'], p, t, e, tgt['accounting_period'], newv, adj, len(lst)))

def put(task):
    rid, p, t, e, per, newv, adj, n = task
    body = json.dumps({"budget_user": newv, "reason_category": "BUDGET_REALLOCATION", "comments": COMMENT}).encode()
    req = urllib.request.Request(BASE + "/budget/" + rid, data=body, method="PUT", headers=H)
    try:
        d = json.loads(urllib.request.urlopen(req, timeout=60).read())
        return (p, t, e, per, newv, adj, n, 'OK' if abs((d['budget_user'] or 0) - newv) < 0.01 else 'MISMATCH')
    except Exception as ex:
        return (p, t, e, per, newv, adj, n, 'ERR ' + str(ex)[:80])

with ThreadPoolExecutor(max_workers=8) as ex:
    results = list(ex.map(put, tasks))

ok = [r for r in results if r[7] == 'OK']
bad = [r for r in results if r[7] != 'OK']
print("applied OK: %d | failed: %d | skipped (no record): %d" % (len(ok), len(bad), len(skipped)))
print("sum override stored: %.2f | sum adjustment applied: %.2f" % (sum(r[4] for r in ok), sum(r[5] for r in ok)))
from collections import Counter
print("period distribution of applied:", sorted(Counter(r[3] for r in ok).items()))
print("multi-period lines touched:", sum(1 for r in ok if r[6] > 1))
for s in skipped: print("  SKIP:", s)
for b2 in bad[:10]: print("  FAIL:", b2)
neg = [r for r in ok if r[4] < -0.005]
zero = [r for r in ok if abs(r[4]) <= 0.005]
print("stored value < 0:", len(neg), [ (r[0],r[1],r[4]) for r in neg ], "| stored == 0:", len(zero))
