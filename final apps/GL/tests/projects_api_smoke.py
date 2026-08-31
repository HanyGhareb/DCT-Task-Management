"""Executive Project Dashboard -- API smoke + reconciliation (GL App 210).

The reconciliation checks are the acceptance gate for this feature: the
portfolio KPI band MUST equal the Budget Utilization totals for the same
criteria, or the two pages tell an executive different things about the same
money.

Usage:
    python projects_api_smoke.py
    GL_BASE=http://localhost:8210 python projects_api_smoke.py
"""
import json
import os
import re
import ssl
import sys
import urllib.error
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE

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


def api(tok, path):
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path,
                               headers={'Authorization': 'Bearer ' + tok})
    return json.loads(urllib.request.urlopen(r, timeout=180, context=CTX).read())


def status(tok, path):
    """Return the HTTP status for a path, following the error body."""
    hdr = {'Authorization': 'Bearer ' + tok} if tok else {}
    try:
        urllib.request.urlopen(
            urllib.request.Request(BASE + '/ords/admin/gl' + path, headers=hdr),
            timeout=120, context=CTX)
        return 200
    except urllib.error.HTTPError as e:
        return e.code


def close(a, b, tol=0.005):
    return abs(float(a or 0) - float(b or 0)) <= tol


def main():
    tok = login()
    ck('login', bool(tok))

    print('\n-- gates --')
    ck('projects requires auth', status(None, '/projects?year=2026') in (401, 403))
    ck('projects/lov requires year 400', status(tok, '/projects/lov') == 400)

    print('\n-- filters --')
    f = api(tok, '/projects/filters')
    yr = f.get('defaultYear')
    ck('filters defaultYear', bool(yr), yr)
    ck('filters years[]', isinstance(f.get('years'), list) and len(f['years']) >= 1)
    ck('filters statuses[]', isinstance(f.get('statuses'), list) and len(f['statuses']) >= 1,
       f.get('statuses'))
    ck('filters bands[]', f.get('bands') == ['GREEN', 'AMBER', 'RED', 'GREY'])
    for k in ('projectTypes', 'sectors', 'chapters', 'businessUnits'):
        ck('filters ' + k, isinstance(f.get(k), list))

    print('\n-- lov --')
    lov = api(tok, '/projects/lov?year=%s' % yr)
    ck('lov projects[]', isinstance(lov.get('projects'), list) and len(lov['projects']) > 0,
       len(lov.get('projects') or []))
    ck('lov costCenters[]', isinstance(lov.get('costCenters'), list))
    ck('lov managers[]', isinstance(lov.get('managers'), list), len(lov.get('managers') or []))

    print('\n-- portfolio --')
    p = api(tok, '/projects?year=%s' % yr)
    t = p.get('totals') or {}
    ck('portfolio items[]', isinstance(p.get('items'), list) and len(p['items']) > 0,
       '%s of %s' % (len(p.get('items') or []), p.get('total')))
    ck('portfolio totals{}', bool(t))
    ck('portfolio bands{}', isinstance(p.get('bands'), dict), p.get('bands'))
    ck('portfolio flags{}', isinstance(p.get('flags'), dict), p.get('flags'))
    ck('portfolio dataGaps{}', isinstance(p.get('dataGaps'), dict))
    dg = p.get('dataGaps') or {}
    ck('dataGaps arReceipts DATA_GAP',
       (dg.get('arReceipts') or {}).get('status') == 'DATA_GAP')
    ck('dataGaps actualTaskDates flagged', 'actualTaskDates' in dg, dg.get('actualTaskDates'))

    print('\n-- RECONCILIATION vs /gl/butil (the acceptance gate) --')
    for label, qs in (('full year', ''),
                      ('period cut', '&period=06-%s' % yr),
                      ('sector filter', '')):
        if label == 'sector filter':
            secs = f.get('sectors') or []
            if not secs:
                continue
            qs = '&sector=' + urllib.request.quote(secs[0])
        b = api(tok, '/butil?year=%s%s&limit=1' % (yr, qs))
        pf = api(tok, '/projects?year=%s%s&limit=1' % (yr, qs))
        bt, pt = b.get('totals') or {}, pf.get('totals') or {}
        for key in ('budget', 'budgetAnnual', 'actualAp', 'actualGrn',
                    'commitmentPr', 'obligationPo', 'fundAvailable'):
            ck('%s: %s' % (label, key), close(bt.get(key), pt.get(key)),
               '%s vs %s' % (bt.get(key), pt.get(key)))

    print('\n-- project 360 --')
    num = p['items'][0]['projectNumber']
    d = api(tok, '/projects/%s?year=%s' % (num, yr))
    ck('360 project{}', bool(d.get('project')), num)
    ck('360 year{}', bool(d.get('year')))
    ck('360 health{}', bool(d.get('health')))
    ck('360 health disclaimer', bool((d.get('health') or {}).get('disclaimer')))
    ck('360 revenue DATA_GAP',
       ((d.get('revenue') or {}).get('receipts') or {}).get('status') == 'DATA_GAP')
    ck('360 unknown project 404', status(tok, '/projects/ZZZNOPE?year=%s' % yr) == 404)

    print('\n-- 360 tile equals its portfolio row --')
    row = next((r for r in p['items'] if r['projectNumber'] == num), None)
    y = d.get('year') or {}
    for key in ('budgetAnnual', 'actualAp', 'actualGrn', 'commitmentPr', 'obligationPo'):
        ck('360 %s == row' % key, close(row.get(key), y.get(key)),
           '%s vs %s' % (row.get(key), y.get(key)))

    print('\n-- 360 children --')
    for path, arr in (('tasks', 'items'), ('pipeline', None), ('invoices', 'items'),
                      ('revenue', None), ('trx', 'items'), ('cashflow', 'periods')):
        r = api(tok, '/projects/%s/%s?year=%s' % (num, path, yr))
        ck('360 %s responds' % path, isinstance(r, dict))
        if arr:
            ck('360 %s %s[]' % (path, arr), isinstance(r.get(arr), list))

    print('\n%d passed, %d failed' % (ok, fail))
    return 0 if fail == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
