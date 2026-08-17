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


SCOPE = 'type=Additional&year=2026&'   # the page's mandatory scope


def main():
    tok = login()
    ck('login', bool(tok))

    # ---- criteria LOVs ---------------------------------------------------
    f = api(tok, '/budgettrx/filters?' + SCOPE.rstrip('&'))
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

    lov = api(tok, '/budgettrx/lov?' + SCOPE.rstrip('&'))
    for key in ('projects', 'tasks', 'etypes', 'costCenters'):
        ck('lov.%s present' % key, key in lov and len(lov[key]) > 0, len(lov.get(key, [])))
    ck('lov projects carry number + name', all('p' in x for x in lov['projects'][:5]),
       lov['projects'][0])
    allty = api(tok, '/budgettrx/lov?year=2026')
    typed = api(tok, '/budgettrx/lov?type=Estimated-Cost&year=2026')
    # subset, not "smaller": Estimated-Cost happens to touch every project in
    # 2026, so its list legitimately equals the all-types list
    pset = lambda d: {x['p'] for x in d['projects']}
    ck('lov scopes by budget type',
       pset(lov) < pset(allty) or pset(typed) < pset(allty),
       'Additional %d, EstCost %d, all types %d; lists differ: %s'
       % (len(lov['projects']), len(typed['projects']), len(allty['projects']),
          pset(lov) != pset(typed)))
    ck('each typed list is a subset of all types',
       pset(lov) <= pset(allty) and pset(typed) <= pset(allty))
    unscoped = api(tok, '/budgettrx/filters')
    ck('criteria LOVs narrow to the scope',
       len(f['sectors']) <= len(unscoped['sectors'])
       and len(f['appropriations']) < len(unscoped['appropriations']),
       'sectors %d/%d, appropriations %d/%d'
       % (len(f['sectors']), len(unscoped['sectors']),
          len(f['appropriations']), len(unscoped['appropriations'])))

    # ---- mandatory scope -------------------------------------------------
    # Budget Type + Transaction Year scope the whole page (perf decision
    # 2026-08-17), so the server refuses a call without them -- a curl cannot
    # ask for the whole table either
    ck('missing type+year -> 400', status(tok, '/budgettrx?size=1') == 400)
    ck('missing year -> 400', status(tok, '/budgettrx?type=Additional&size=1') == 400)
    ck('missing type -> 400', status(tok, '/budgettrx?year=2026&size=1') == 400)

    # ---- baseline --------------------------------------------------------
    base = api(tok, '/budgettrx?' + SCOPE + 'size=1')
    total = base['total']
    ck('in-scope grid returns its headers', total > 1000, total)

    # THE guard: line-level criteria go through an EXISTS, which would drop the
    # headers that have no lines yet. Unfiltered, they must still be counted.
    lineless = api(tok, '/budgettrx?' + SCOPE + 'size=5000')
    zero = [i for i in lineless['items'] if i['lines'] == 0]
    ck('line-less headers survive the unfiltered grid', len(zero) > 0, '%d headers' % len(zero))

    # ---- each line-level criterion narrows, and stays consistent ---------
    sec = f['sectors'][0]['code']
    r = api(tok, '/budgettrx?' + SCOPE + 'sector=' + sec + '&size=1')
    ck('sector filter narrows', 0 < r['total'] < total, '%s -> %d' % (sec, r['total']))

    ch = f['chapters'][0]['code']
    r = api(tok, '/budgettrx?' + SCOPE + 'chapter=' + ch + '&size=1')
    ck('chapter filter narrows', 0 < r['total'] < total, '%s -> %d' % (ch, r['total']))

    pg = f['programs'][0]['code']
    r = api(tok, '/budgettrx?' + SCOPE + 'program=' + pg + '&size=1')
    ck('program filter narrows', 0 < r['total'] < total, '%s -> %d' % (pg, r['total']))

    ap = f['appropriations'][0]['code']
    r = api(tok, '/budgettrx?' + SCOPE + 'appropriation=' + ap + '&size=1')
    ck('appropriation filter narrows', 0 < r['total'] < total, '%s -> %d' % (ap, r['total']))

    proj = lov['projects'][0]['p']
    r = api(tok, '/budgettrx?' + SCOPE + 'project=' + proj + '&size=1')
    ck('project filter narrows', 0 < r['total'] < total, '%s -> %d' % (proj, r['total']))

    task = urllib.parse.quote(lov['tasks'][0]['t'])
    r = api(tok, '/budgettrx?' + SCOPE + 'task=' + task + '&size=1')
    ck('task filter narrows', 0 < r['total'] < total, '%s -> %d' % (task, r['total']))

    et = urllib.parse.quote(lov['etypes'][0])
    r = api(tok, '/budgettrx?' + SCOPE + 'etype=' + et + '&size=1')
    ck('expenditure-type filter narrows', 0 < r['total'] < total, '%s -> %d' % (et, r['total']))

    cc = urllib.parse.quote(lov['costCenters'][0])
    r = api(tok, '/budgettrx?' + SCOPE + 'costcenter=' + cc + '&size=1')
    ck('cost-centre filter narrows', 0 < r['total'] < total, '%s -> %d' % (cc, r['total']))

    per = f['periods'][0]
    r = api(tok, '/budgettrx?' + SCOPE + 'period=' + per + '&size=1')
    ck('accounting-period filter narrows', 0 < r['total'] < total, '%s -> %d' % (per, r['total']))

    # combined criteria are ANDed on the SAME line
    r2 = api(tok, '/budgettrx?' + SCOPE + 'sector=%s&project=%s&size=1' % (sec, proj))
    r1 = api(tok, '/budgettrx?' + SCOPE + 'project=%s&size=1' % proj)
    ck('criteria combine (AND on one line)', r2['total'] <= r1['total'],
       '%d <= %d' % (r2['total'], r1['total']))

    # ---- search now reaches the lines ------------------------------------
    r = api(tok, '/budgettrx?' + SCOPE + 'search=' + urllib.parse.quote(lov['etypes'][0][:12]) + '&size=1')
    ck('free-text search matches line attributes', r['total'] > 0, r['total'])

    # ---- errors ----------------------------------------------------------
    ck('bad period -> 400', status(tok, '/budgettrx?' + SCOPE + 'period=2026-06') == 400)
    ck('bad date -> 400', status(tok, '/budgettrx?' + SCOPE + 'from=notadate') == 400)
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
