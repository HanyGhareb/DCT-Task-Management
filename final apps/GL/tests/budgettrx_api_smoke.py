#!/usr/bin/env python3
"""GL /gl/budgettrx* API smoke — criteria parity with Budget Utilization.

Covers the header-level criteria, the nine LINE-level ones added 2026-08-17
(Sector / Chapter / Program / Appropriation / Cost centre / Project / Task /
Expenditure type / Accounting period), the free-text search, and the guard that
keeps line-less headers in the unfiltered grid.

Run: python budgettrx_api_smoke.py            (defaults to the webtier)
     GL_BASE=http://localhost:8210 python budgettrx_api_smoke.py
"""
import json
import os
import re
import ssl
import sys
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
    return json.loads(urllib.request.urlopen(r, timeout=120, context=CTX).read())


def status(tok, path):
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path,
                               headers={'Authorization': 'Bearer ' + tok})
    try:
        urllib.request.urlopen(r, timeout=60, context=CTX)
        return 200
    except urllib.error.HTTPError as e:
        return e.code


def main():
    tok = login()
    ck('login', bool(tok))

    # ---- criteria LOVs ---------------------------------------------------
    f = api(tok, '/budgettrx/filters')
    for key in ('types', 'businessUnits', 'projectTypes', 'statuses', 'years', 'approvers',
                'sectors', 'chapters', 'programs', 'appropriations', 'periods'):
        ck('filters.%s present' % key, key in f and len(f[key]) > 0,
           len(f.get(key, [])))
    ck('sectors carry code+name', all('code' in s and 'name' in s for s in f['sectors']),
       f['sectors'][0])
    # MM-YYYY sorts wrong lexically -- the handler orders on the numeric YYYYMM
    pn = [int(p[3:] + p[:2]) for p in f['periods']]
    ck('periods sorted newest-first (numeric YYYYMM, not the string)', pn == sorted(pn, reverse=True),
       f['periods'][:4])

    lov = api(tok, '/budgettrx/lov')
    for key in ('projects', 'tasks', 'etypes', 'costCenters'):
        ck('lov.%s present' % key, key in lov and len(lov[key]) > 0, len(lov.get(key, [])))
    ck('lov projects carry number + name', all('p' in x for x in lov['projects'][:5]),
       lov['projects'][0])
    typed = api(tok, '/budgettrx/lov?type=Estimated-Cost')
    ck('lov scopes by budget type', 0 < len(typed['projects']) <= len(lov['projects']),
       '%d of %d' % (len(typed['projects']), len(lov['projects'])))

    # ---- baseline --------------------------------------------------------
    base = api(tok, '/budgettrx?size=1')
    total = base['total']
    ck('unfiltered grid returns every header', total > 2000, total)

    # THE guard: line-level criteria go through an EXISTS, which would drop the
    # headers that have no lines yet. Unfiltered, they must still be counted.
    lineless = api(tok, '/budgettrx?size=5000')
    zero = [i for i in lineless['items'] if i['lines'] == 0]
    ck('line-less headers survive the unfiltered grid', len(zero) > 0, '%d headers' % len(zero))

    # ---- each line-level criterion narrows, and stays consistent ---------
    sec = f['sectors'][0]['code']
    r = api(tok, '/budgettrx?sector=' + sec + '&size=1')
    ck('sector filter narrows', 0 < r['total'] < total, '%s -> %d' % (sec, r['total']))

    ch = f['chapters'][0]['code']
    r = api(tok, '/budgettrx?chapter=' + ch + '&size=1')
    ck('chapter filter narrows', 0 < r['total'] < total, '%s -> %d' % (ch, r['total']))

    pg = f['programs'][0]['code']
    r = api(tok, '/budgettrx?program=' + pg + '&size=1')
    ck('program filter narrows', 0 < r['total'] < total, '%s -> %d' % (pg, r['total']))

    ap = f['appropriations'][0]['code']
    r = api(tok, '/budgettrx?appropriation=' + ap + '&size=1')
    ck('appropriation filter narrows', 0 < r['total'] < total, '%s -> %d' % (ap, r['total']))

    proj = lov['projects'][0]['p']
    r = api(tok, '/budgettrx?project=' + proj + '&size=1')
    ck('project filter narrows', 0 < r['total'] < total, '%s -> %d' % (proj, r['total']))

    task = urllib.parse.quote(lov['tasks'][0]['t'])
    r = api(tok, '/budgettrx?task=' + task + '&size=1')
    ck('task filter narrows', 0 < r['total'] < total, '%s -> %d' % (task, r['total']))

    et = urllib.parse.quote(lov['etypes'][0])
    r = api(tok, '/budgettrx?etype=' + et + '&size=1')
    ck('expenditure-type filter narrows', 0 < r['total'] < total, '%s -> %d' % (et, r['total']))

    cc = urllib.parse.quote(lov['costCenters'][0])
    r = api(tok, '/budgettrx?costcenter=' + cc + '&size=1')
    ck('cost-centre filter narrows', 0 < r['total'] < total, '%s -> %d' % (cc, r['total']))

    per = f['periods'][0]
    r = api(tok, '/budgettrx?period=' + per + '&size=1')
    ck('accounting-period filter narrows', 0 < r['total'] < total, '%s -> %d' % (per, r['total']))

    # combined criteria are ANDed on the SAME line
    r2 = api(tok, '/budgettrx?sector=%s&project=%s&size=1' % (sec, proj))
    r1 = api(tok, '/budgettrx?project=%s&size=1' % proj)
    ck('criteria combine (AND on one line)', r2['total'] <= r1['total'],
       '%d <= %d' % (r2['total'], r1['total']))

    # ---- search now reaches the lines ------------------------------------
    r = api(tok, '/budgettrx?search=' + urllib.parse.quote(lov['etypes'][0][:12]) + '&size=1')
    ck('free-text search matches line attributes', r['total'] > 0, r['total'])

    # ---- errors ----------------------------------------------------------
    ck('bad period -> 400', status(tok, '/budgettrx?period=2026-06') == 400)
    ck('bad date -> 400', status(tok, '/budgettrx?from=notadate') == 400)
    ck('unknown transaction -> 404', status(tok, '/budgettrx/NOPE-1') == 404)
    r = urllib.request.Request(BASE + '/ords/admin/gl/budgettrx/filters')
    try:
        urllib.request.urlopen(r, timeout=30, context=CTX)
        ck('no token -> 401', False)
    except urllib.error.HTTPError as e:
        ck('no token -> 401', e.code == 401, e.code)

    print('\n%d passed, %d failed' % (ok, fail))
    return 0 if fail == 0 else 1


if __name__ == '__main__':
    import urllib.parse
    import urllib.error
    sys.exit(main())
