#!/usr/bin/env python3
"""GL /gl/butil/lines/costadj API smoke — cost-adjustment drill reconciliation.

The /gl/butil figures are server-adjusted by approved Projects Costing
Adjustments (costadj=Y default); the drill drawer appends the adjustment rows
from this route so its total reconciles to the on-screen figure. Sample:
project 4511000981 / PCA-00018 (+2,368,623 on Actual, period 04-2026).

Run: python costadj_drill_api_smoke.py      (defaults to the webtier)
"""
import json
import os
import re
import ssl
import sys
import urllib.parse
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

PROJECT = '4511000981'
YEAR = 2026

ok = fail = 0


def ck(name, cond, extra=''):
    global ok, fail
    print(('  PASS ' if cond else '  FAIL ') + name + ('  ' + str(extra) if extra else ''))
    if cond:
        ok += 1
    else:
        fail += 1


def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


def get(tok, path, params=None):
    q = ('?' + urllib.parse.urlencode({k: v for k, v in (params or {}).items()
                                       if v not in (None, '')})) if params else ''
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path + q,
                               headers={'Authorization': 'Bearer ' + tok})
    try:
        return 200, json.loads(urllib.request.urlopen(r, timeout=180, context=CTX).read())
    except urllib.error.HTTPError as e:
        return e.code, {}


def main():
    tok = login()
    print('== sample row (project %s) ==' % PROJECT)
    st, bu = get(tok, '/butil', {'year': YEAR, 'project': PROJECT, 'limit': 50})
    rows = [r for r in bu.get('items', []) if r.get('hasAdj') == 'Y']
    ck('butil row with hasAdj=Y found', st == 200 and len(rows) >= 1, len(rows))
    if not rows:
        sys.exit(1)
    row = rows[0]
    ck('response echoes includeCostAdj=Y', bu.get('includeCostAdj') == 'Y')
    ck('row carries costAdj component', abs(row.get('costAdj', 0)) > 0, row.get('costAdj'))
    keys = {'year': YEAR, 'project': row['projectNumber'], 'task': row['taskNumber'],
            'etype': row['expenditureType']}

    print('== AP drill reconciliation (full year) ==')
    st, base = get(tok, '/butil/lines', dict(keys, metric='ap'))
    st2, adj = get(tok, '/butil/lines/costadj', dict(keys, metric='ap'))
    ck('both routes 200', st == 200 and st2 == 200, (st, st2))
    ck('adjustment rows returned', len(adj.get('rows', [])) >= 1, len(adj.get('rows', [])))
    r0 = (adj.get('rows') or [{}])[0]
    ck('row flagged fromAdj=Y with the PCA ref',
       r0.get('fromAdj') == 'Y' and str(r0.get('adjRef', '')).startswith('PCA-'),
       r0.get('adjRef'))
    ck('row shows the REFERENCED invoice distribution (not the PCA trx)',
       not str(r0.get('invoice', '')).startswith('PCA-') and bool(r0.get('line'))
       and bool(r0.get('invoiceId')) and r0.get('invAmount') is not None,
       '%s line %s inv-amt %s' % (r0.get('invoice'), r0.get('line'), r0.get('invAmount')))
    ck('row carries the invoice REAL statuses + description',
       r0.get('validation') not in (None, '', 'Cost Adjustment')
       and r0.get('payment') not in (None, '', 'Reallocation')
       and bool(r0.get('description')) and 'PCA-' not in str(r0.get('description')),
       '%s / %s' % (r0.get('validation'), r0.get('payment')))
    merged = (base.get('total') or 0) + (adj.get('total') or 0)
    ck('base + adjustments == on-screen Actual AP',
       abs(merged - (row.get('actualAp') or 0)) < 0.01,
       '%.2f + %.2f = %.2f vs %.2f' % (base.get('total') or 0, adj.get('total') or 0,
                                       merged, row.get('actualAp') or 0))

    print('== YTD period rule (adjustment period 04-2026) ==')
    st, a_mar = get(tok, '/butil/lines/costadj', dict(keys, metric='ap', period='03-2026'))
    ck('03-2026 YTD excludes the adjustment', (a_mar.get('total') or 0) == 0
       and len(a_mar.get('rows', [])) == 0, a_mar.get('total'))
    st, a_apr = get(tok, '/butil/lines/costadj', dict(keys, metric='ap', period='04-2026'))
    ck('04-2026 YTD includes the adjustment', abs(a_apr.get('total') or 0) > 0, a_apr.get('total'))
    # and the butil figure follows the same rule
    st, bu_mar = get(tok, '/butil', {'year': YEAR, 'project': PROJECT, 'period': '03-2026', 'limit': 50})
    m_rows = [r for r in bu_mar.get('items', [])
              if r['taskNumber'] == row['taskNumber'] and r['expenditureType'] == row['expenditureType']]
    st, mar_base = get(tok, '/butil/lines', dict(keys, metric='ap', period='03-2026'))
    if m_rows:
        ck('03-2026 butil Actual == raw AP lines (no adj)',
           abs((m_rows[0].get('actualAp') or 0) - (mar_base.get('total') or 0)) < 0.01,
           '%.2f vs %.2f' % (m_rows[0].get('actualAp') or 0, mar_base.get('total') or 0))
    else:
        ck('03-2026 butil row present', False)

    print('== aggregate (KPI-card) mode ==')
    st, agg = get(tok, '/butil/lines/costadj',
                  {'year': YEAR, 'metric': 'ap', 'fproject': PROJECT})
    ck('aggregate mode finds the adjustment', st == 200 and
       any(r.get('fromAdj') == 'Y' for r in agg.get('rows', [])),
       len(agg.get('rows', [])))
    ck('aggregate rows carry project/task identity',
       all(r.get('project') and r.get('task') for r in agg.get('rows', [])))

    print('== budget metrics + error paths ==')
    st, bud = get(tok, '/butil/lines/costadj', dict(keys, metric='budget'))
    ck('budget metric 200 (override rows only)', st == 200, st)
    ck('sample has no budget override -> 0 rows', len(bud.get('rows', [])) == 0,
       len(bud.get('rows', [])))
    st, _ = get(tok, '/butil/lines/costadj', dict(keys, metric='grn'))
    ck('400 unsupported metric', st == 400, st)
    st, _ = get(tok, '/butil/lines/costadj', {'metric': 'ap'})
    ck('400 year required', st == 400, st)
    st, _ = get('bad-token', '/butil/lines/costadj', dict(keys, metric='ap'))
    ck('401 bad token', st == 401, st)

    print('\n== RESULT: %d passed, %d failed ==' % (ok, fail))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
