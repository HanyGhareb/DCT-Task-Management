#!/usr/bin/env python3
"""GL expenditure-plan balances API smoke (db/v2/126 + GL/db/21/22/30).

/gl/butil, /gl/projects and /gl/projects/:num ship the uploaded cashflow plan
as planApprovedAnnual/Ytd + planRevisedAnnual/Ytd (BUTIL_END-aware YTD; full
year => YTD = Annual), and /gl/butil/lines/plan serves the monthly rows behind
any plan figure. Sample: project 4511000981 (plan months 03..12-2026).

Run: python plan_butil_api_smoke.py      (defaults to the webtier)
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
        return 200, json.loads(urllib.request.urlopen(r, timeout=300, context=CTX).read())
    except urllib.error.HTTPError as e:
        return e.code, {}


def main():
    tok = login()

    print('== /gl/butil plan balances (project %s, full year) ==' % PROJECT)
    st, bu = get(tok, '/butil', {'year': YEAR, 'project': PROJECT, 'limit': 100})
    t = bu.get('totals', {})
    ck('butil 200 + totals carry plan keys', st == 200 and 'planApprovedAnnual' in t
       and 'planRevisedYtd' in t and 'planUnmatched' in t)
    ck('full year: plan YTD == plan Annual',
       abs((t.get('planApprovedYtd') or 0) - (t.get('planApprovedAnnual') or 0)) < 0.01,
       t.get('planApprovedAnnual'))
    rows = [r for r in bu.get('items', []) if r.get('hasPlan') == 'Y']
    ck('rows flagged hasPlan=Y', len(rows) >= 1, len(rows))
    row_sum = sum(r.get('planApprovedAnnual') or 0 for r in bu.get('items', []))
    ck('totals == sum of row plan figures',
       abs(row_sum - (t.get('planApprovedAnnual') or 0)) < 0.01,
       '%.2f vs %.2f' % (row_sum, t.get('planApprovedAnnual') or 0))
    annual = t.get('planApprovedAnnual') or 0

    print('== YTD period rule (plan months start 03-2026) ==')
    st, b_feb = get(tok, '/butil', {'year': YEAR, 'project': PROJECT, 'period': '02-2026', 'limit': 5})
    ck('02-2026 YTD plan = 0 (before first plan month)',
       st == 200 and (b_feb['totals'].get('planApprovedYtd') or 0) == 0,
       b_feb['totals'].get('planApprovedYtd'))
    ck('02-2026 annual plan unchanged',
       abs((b_feb['totals'].get('planApprovedAnnual') or 0) - annual) < 0.01)
    st, b_jun = get(tok, '/butil', {'year': YEAR, 'project': PROJECT, 'period': '06-2026', 'limit': 5})
    ytd_jun = b_jun['totals'].get('planApprovedYtd') or 0
    ck('06-2026 YTD plan between 0 and annual', 0 < ytd_jun < annual, ytd_jun)

    print('== /gl/butil/lines/plan drill reconciliation ==')
    for r in rows:
        keys = {'year': YEAR, 'project': r['projectNumber'], 'task': r['taskNumber'],
                'etype': r['expenditureType']}
        st, d = get(tok, '/butil/lines/plan', keys)
        ck('row drill == row Annual (%s)' % r['taskNumber'],
           st == 200 and abs((d.get('total') or 0) - (r.get('planApprovedAnnual') or 0)) < 0.01,
           '%.2f vs %.2f' % (d.get('total') or 0, r.get('planApprovedAnnual') or 0))
    st, agg = get(tok, '/butil/lines/plan', {'year': YEAR, 'fproject': PROJECT})
    ck('aggregate drill == totals Annual',
       st == 200 and abs((agg.get('total') or 0) - annual) < 0.01, agg.get('total'))
    st, aggy = get(tok, '/butil/lines/plan', {'year': YEAR, 'fproject': PROJECT, 'period': '06-2026'})
    ck('aggregate YTD drill == 06-2026 YTD plan',
       st == 200 and abs((aggy.get('total') or 0) - ytd_jun) < 0.01,
       '%.2f vs %.2f' % (aggy.get('total') or 0, ytd_jun))
    r0 = (agg.get('rows') or [{}])[0]
    ck('drill rows shaped (period/amount/loadedBy)',
       bool(r0.get('period')) and 'amount' in r0 and 'loadedBy' in r0, r0.get('period'))
    st, rev = get(tok, '/butil/lines/plan', {'year': YEAR, 'fproject': PROJECT, 'type': 'REVISED'})
    ck('REVISED drill empty today (no revised uploads)',
       st == 200 and (rev.get('total') or 0) == 0, rev.get('total'))

    print('== portfolio + 360 parity ==')
    st, pf = get(tok, '/projects', {'year': YEAR, 'project': PROJECT, 'limit': 10})
    pt = pf.get('totals', {})
    ck('portfolio totals plan == butil plan',
       st == 200 and abs((pt.get('planApprovedAnnual') or 0) - annual) < 0.01,
       pt.get('planApprovedAnnual'))
    prow = (pf.get('items') or [{}])[0]
    ck('portfolio row carries plan figures',
       abs((prow.get('planApprovedAnnual') or 0) - annual) < 0.01, prow.get('planApprovedAnnual'))
    st, p3 = get(tok, '/projects/' + PROJECT, {'year': YEAR, 'period': '06-2026'})
    y = p3.get('year', {})
    ck('360 YTD plan == butil 06-2026 YTD',
       st == 200 and abs((y.get('planApprovedYtd') or 0) - ytd_jun) < 0.01,
       y.get('planApprovedYtd'))
    ck('360 annual plan == butil annual',
       abs((y.get('planApprovedAnnual') or 0) - annual) < 0.01)

    print('== error paths ==')
    st, _ = get(tok, '/butil/lines/plan', {'year': YEAR, 'type': 'X'})
    ck('400 bad type', st == 400, st)
    st, _ = get(tok, '/butil/lines/plan', {'type': 'APPROVED'})
    ck('400 year required', st == 400, st)
    st, _ = get(tok, '/butil/lines/plan', {'year': YEAR, 'period': '13-2026'})
    ck('400 bad period', st == 400, st)
    st, _ = get('bad-token', '/butil/lines/plan', {'year': YEAR})
    ck('401 bad token', st == 401, st)

    print('\n== RESULT: %d passed, %d failed ==' % (ok, fail))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
