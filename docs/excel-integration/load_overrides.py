#!/usr/bin/env python3
"""Bulk-load budget CHANGES from an adjustment sheet (cols: Project Number,
Project Name, Task, Expenditure Type, Budget, Override Budget = ADJUSTMENT).

v2 (2026-08-17): the API stores a SIGNED CHANGE, which is exactly what the
sheet's last column already holds — so the adjustment is now posted VERBATIM
(`budget_change = adjustment`). No more "read the earliest period row, add the
adjustment to its budget, store the absolute result" conversion the v1 API
forced (that is what made the old rows unrecoverable when the model flipped).

The change is booked to PERIOD (default: the line's earliest 2026 period, which
is what the original 2026-07-28 load effectively did). Set PERIOD to e.g.
'08-2026' to book everything to one accounting period instead — with the
un-phased Fusion budget that is a first-class case now.

First used 2026-07-28 (252/254 applied). Edit the file path/creds/year/period
before reuse; a re-run is idempotent per line (PUT replaces the change).
"""
import json, urllib.request, urllib.parse, base64
import openpyxl
from concurrent.futures import ThreadPoolExecutor
from collections import Counter, defaultdict

BASE = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl"
H = {"Authorization": "Basic " + base64.b64encode(b"ADMIN:iFinance@2026").decode(),
     "Content-Type": "application/json"}
SHEET = '/root/DCT-Task-Management/docs/excel-integration/Override Budget.xlsx'
YEAR = 2026
PERIOD = None          # None = the line's earliest budget period; or e.g. '08-2026'
BU = None              # None = the API default (Department of Culture and Tourism)
PTYPE = None           # None = the API default (DCT OPEX Project Type)
COMMENT = "Bulk load 2026-08-17: Override Budget.xlsx (adjustment vs Fusion budget)"
DRY_RUN = True         # flip to False to actually write

wb = openpyxl.load_workbook(SHEET, data_only=True)
rows = []
for r in wb['Sheet2'].iter_rows(min_row=2, values_only=True):
    if r[0] is None:
        continue
    rows.append((str(r[0]).strip(), str(r[2]).strip(), str(r[3]).strip(),
                 float(r[4] or 0), float(r[5] or 0)))


def pnum(p):           # MM-YYYY sort key
    return (int(p[3:]), int(p[:2]))


_cache = {}


def fetch(period):
    """One download per period, cached: the row id encodes the period, so each
    period needs its own copy of the line set - but only ONCE."""
    if period not in _cache:
        q = f"{BASE}/budget/?budget_year={YEAR}&accounting_period={period}&limit=10000"
        if BU:
            q += "&business_unit=" + urllib.parse.quote(BU)
        if PTYPE:
            q += "&project_type=" + urllib.parse.quote(PTYPE)
        req = urllib.request.Request(q, headers=H)
        items = json.loads(urllib.request.urlopen(req, timeout=300).read())['items']
        _cache[period] = {(i['project_number'], i['task_number'],
                           i['expenditure_type']): i for i in items}
    return _cache[period]


# The line grain is identical in every period download; the per-period call is
# only needed to learn WHICH periods a line actually carries budget in (so the
# default booking period can stay "the line's earliest").
periods = [PERIOD] if PERIOD else ['%02d-%d' % (m, YEAR) for m in range(1, 13)]
by_line, seen_periods = {}, defaultdict(list)
for per in periods:
    for key, i in fetch(per).items():
        by_line.setdefault(key, i)
        if (i['budget_ytd'] or 0) != 0 or (i['budget_annual'] or 0) != 0:
            seen_periods[key].append(per)

tasks, skipped = [], []
for p, t, e, _budget, adj in rows:
    key = (p, t, e)
    line = by_line.get(key)
    if not line:
        skipped.append((p, t, e, f'no {YEAR} budget line'))
        continue
    if abs(adj) < 0.005:
        skipped.append((p, t, e, 'zero adjustment'))
        continue
    per = PERIOD or sorted(seen_periods.get(key) or periods, key=pnum)[0]
    # the row id encodes the period the change is booked to, so re-fetch the
    # line at THAT period rather than reusing whichever download it came from
    hit = fetch(per).get(key)
    if not hit:
        skipped.append((p, t, e, f'line absent at {per}'))
        continue
    tasks.append((hit['id'], p, t, e, per, round(adj, 2)))


def put(task):
    rid, p, t, e, per, adj = task
    if DRY_RUN:
        return (p, t, e, per, adj, 'DRY')
    body = json.dumps({"budget_change": adj, "reason_category": "BUDGET_REALLOCATION",
                       "comments": COMMENT}).encode()
    req = urllib.request.Request(BASE + "/budget/" + rid, data=body, method="PUT", headers=H)
    try:
        d = json.loads(urllib.request.urlopen(req, timeout=60).read())
        good = abs((d['budget_change'] or 0) - adj) < 0.01
        return (p, t, e, per, adj, 'OK' if good else 'MISMATCH')
    except Exception as ex:
        return (p, t, e, per, adj, 'ERR ' + str(ex)[:80])


with ThreadPoolExecutor(max_workers=8) as ex:
    results = list(ex.map(put, tasks))

ok = [r for r in results if r[5] in ('OK', 'DRY')]
bad = [r for r in results if r[5] not in ('OK', 'DRY')]
print("%s | applied: %d | failed: %d | skipped: %d"
      % ('DRY RUN' if DRY_RUN else 'WRITTEN', len(ok), len(bad), len(skipped)))
print("sum change applied: %.2f" % sum(r[4] for r in ok))
print("period distribution:", sorted(Counter(r[3] for r in ok).items(), key=lambda x: pnum(x[0])))
print("negative changes: %d | positive: %d"
      % (sum(1 for r in ok if r[4] < 0), sum(1 for r in ok if r[4] > 0)))
for s in skipped[:10]:
    print("  SKIP:", s)
for b2 in bad[:10]:
    print("  FAIL:", b2)
