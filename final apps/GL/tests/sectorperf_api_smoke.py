#!/usr/bin/env python3
"""GL /gl/sectorperf* API smoke — the Sector Financial Performance report.

The load-bearing assertions are the RECONCILIATION ones: budget / actual /
encumbrance / funds available returned by this report must equal what
/gl/butil returns for the same scope, full-year AND period-cut, unfiltered
AND sector-filtered. If those drift, the report contradicts the Budget
Utilization page it sits next to.

Run: python sectorperf_api_smoke.py            (defaults to the webtier)
     GL_BASE=http://localhost:8210 python sectorperf_api_smoke.py
"""
import json
import os
import re
import ssl
import urllib.error
import urllib.parse
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
YEAR = os.environ.get('GL_YEAR', '2026')
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


def near(a, b, tol=0.5):
    return abs((a or 0) - (b or 0)) <= tol


def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    r = urllib.request.Request(BASE + '/ords/admin/dct/auth/login',
                               data=json.dumps({'username': u, 'password': p}).encode(),
                               method='POST', headers={'Content-Type': 'application/json'})
    return json.loads(urllib.request.urlopen(r, timeout=60, context=CTX).read())['sessionId']


def api(tok, path, method='GET'):
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, method=method,
                               headers={'Authorization': 'Bearer ' + tok})
    return json.loads(urllib.request.urlopen(r, timeout=180, context=CTX).read())


def status(tok, path, method='GET', tok_ok=True):
    hdr = {'Authorization': 'Bearer ' + tok} if tok_ok else {}
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, method=method, headers=hdr)
    try:
        urllib.request.urlopen(r, timeout=120, context=CTX)
        return 200
    except urllib.error.HTTPError as e:
        return e.code


def butil(tok, extra=''):
    """Totals from the Budget Utilization page for the same scope."""
    d = api(tok, '/butil?year=%s&limit=1%s' % (YEAR, extra))
    return d.get('totals', {})


def main():
    tok = login()
    ck('login', bool(tok))

    # ---- filters ---------------------------------------------------------
    f = api(tok, '/sectorperf/filters?year=' + YEAR)
    for key in ('years', 'periods', 'sectors', 'departments', 'kinds',
                'projectTypes', 'businessUnits', 'planTypes'):
        ck('filters carries ' + key, isinstance(f.get(key), list) and len(f[key]) > 0,
           len(f.get(key) or []))
    ck('filters periods are MM-YYYY of the year',
       all(re.match(r'^(0[1-9]|1[0-2])-%s$' % YEAR, p) for p in f['periods']), f['periods'][:2])
    ck('filters departments carry code + label',
       all('costCentre' in d and 'department' in d for d in f['departments']))
    ck('default kind scope is Opex|Capex (the pack footnote)',
       f.get('defaultKinds') == 'Opex|Capex', f.get('defaultKinds'))

    # ---- overview --------------------------------------------------------
    o = api(tok, '/sectorperf?year=' + YEAR)
    ck('overview returns the kind matrix', len(o.get('matrix') or []) > 0)
    ck('overview returns a KPI band', isinstance(o.get('kpi'), dict))
    ck('overview returns both gauges',
       [g['kind'] for g in o.get('gauges') or []] == ['Opex', 'Capex'])
    ck('overview returns revenue', isinstance(o.get('revenue'), dict))
    ck('overview returns revenue-to-opex', isinstance(o.get('revenueToOpex'), dict))
    ck('overview returns data-quality counters', isinstance(o.get('quality'), dict))

    kpi = o['kpi']
    mat = {m['kind']: m for m in o['matrix']}
    ck('matrix sums to the KPI band (budget)',
       near(sum(m['fyBudget'] for m in o['matrix']), kpi['budget']))
    ck('matrix sums to the KPI band (actual)',
       near(sum(m['ytdActual'] for m in o['matrix']), kpi['actual']))
    ck('KPI actual-vs-plan amount is actual minus plan',
       near(kpi['actualVsPlanAmount'], kpi['actual'] - kpi['plan']))
    ck('only Opex and Capex are in scope by default',
       set(mat) <= {'Opex', 'Capex'}, list(mat))

    # ---- RECONCILIATION to /gl/butil -------------------------------------
    allkinds = '&kind=' + urllib.parse.quote('|'.join(f['kinds']))
    o_all = api(tok, '/sectorperf?year=%s%s' % (YEAR, allkinds))
    b = butil(tok)
    k = o_all['kpi']
    ck('RECON full-year budget ties to /gl/butil', near(k['budget'], b.get('budgetAnnual')),
       '%s vs %s' % (k['budget'], b.get('budgetAnnual')))
    ck('RECON full-year actual ties to /gl/butil',
       near(k['actual'], (b.get('actualAp') or 0) + (b.get('actualGrn') or 0)))
    ck('RECON full-year encumbrance ties to /gl/butil',
       near(k['encumbrance'], (b.get('commitmentPr') or 0) + (b.get('obligationPo') or 0)))
    ck('RECON full-year funds available ties to /gl/butil',
       near(k['fundsAvailable'], b.get('fundAvailable')))

    per = '08-' + YEAR
    o_p = api(tok, '/sectorperf?year=%s&period=%s%s' % (YEAR, per, allkinds))
    b_p = butil(tok, '&period=' + per)
    kp = o_p['kpi']
    ck('RECON period-cut actual ties to /gl/butil',
       near(kp['actual'], (b_p.get('actualAp') or 0) + (b_p.get('actualGrn') or 0)),
       '%s vs %s' % (kp['actual'], (b_p.get('actualAp') or 0) + (b_p.get('actualGrn') or 0)))
    ck('RECON period-cut funds available ties to /gl/butil',
       near(kp['fundsAvailable'], b_p.get('fundAvailable')))
    ck('period cut lowers or equals the full-year actual', kp['actual'] <= k['actual'] + 0.5)

    sec = f['sectors'][0]
    q = '&sector=' + urllib.parse.quote(sec)
    o_s = api(tok, '/sectorperf?year=%s%s%s' % (YEAR, allkinds, q))
    b_s = butil(tok, q)
    ck('RECON sector-filtered budget ties to /gl/butil',
       near(o_s['kpi']['budget'], b_s.get('budgetAnnual')), sec)
    ck('RECON sector-filtered actual ties to /gl/butil',
       near(o_s['kpi']['actual'], (b_s.get('actualAp') or 0) + (b_s.get('actualGrn') or 0)), sec)

    # ---- sector table ----------------------------------------------------
    s = api(tok, '/sectorperf/sectors?year=%s%s' % (YEAR, allkinds))
    ck('sector table returns rows', len(s.get('items') or []) > 0, len(s.get('items') or []))
    ck('sector table total ties to the KPI band',
       near(s['total']['budget'], k['budget']) and near(s['total']['actual'], k['actual']))
    ck('sector rows sum to the sector total',
       near(sum(i['budget'] for i in s['items']), s['total']['budget']))
    ck('sector actual-vs-plan amount is actual minus plan',
       all(near(i['actualVsPlanAmount'], i['actual'] - i['plan']) for i in s['items']))

    p = api(tok, '/sectorperf/sectors?year=%s%s&level=project' % (YEAR, allkinds))
    ck('project level expands the sector table',
       len(p['items']) >= len(s['items']) and 'projectNumber' in p['items'][0])
    ck('project level totals match the sector level',
       near(p['total']['budget'], s['total']['budget']))

    # ---- departments -----------------------------------------------------
    d = api(tok, '/sectorperf/departments?year=%s%s' % (YEAR, allkinds))
    ck('department series returns rows', len(d.get('items') or []) > 0, len(d.get('items') or []))
    ck('departments sum to the same budget',
       near(sum(i['budget'] for i in d['items']), k['budget']))
    ck('departments are sorted by budget descending',
       all(d['items'][i]['budget'] >= d['items'][i + 1]['budget'] for i in range(len(d['items']) - 1)))

    # ---- trend -----------------------------------------------------------
    t = api(tok, '/sectorperf/trend?year=%s%s' % (YEAR, allkinds))
    ck('trend returns 12 months', len(t.get('items') or []) == 12, len(t.get('items') or []))
    ck('trend cumulative actual is monotonic',
       all(t['items'][i]['actualCumulative'] <= t['items'][i + 1]['actualCumulative'] + 0.001
           for i in range(11)))
    ck('trend December cumulative actual equals the full-year actual',
       near(t['items'][11]['actualCumulative'], k['actual'], 1.0),
       '%s vs %s' % (t['items'][11]['actualCumulative'], k['actual']))
    # Assert at months where the cut-off genuinely bites. A late month can pass
    # trivially whenever the extract has no postings after it, which is exactly
    # the case today (data stops in August) -- so December alone proves nothing.
    for m in (4, 6, 8):
        cut = api(tok, '/sectorperf?year=%s%s&period=%02d-%s' % (YEAR, allkinds, m, YEAR))
        ck('trend cumulative at month %d equals the period-cut actual' % m,
           near(t['items'][m - 1]['actualCumulative'], cut['kpi']['actual'], 1.0),
           '%s vs %s' % (t['items'][m - 1]['actualCumulative'], cut['kpi']['actual']))
        ck('month %d cut is strictly below the full year' % m,
           cut['kpi']['actual'] < k['actual'] if m < 8 else cut['kpi']['actual'] <= k['actual'])
    ck('trend states its budget basis', t.get('budgetBasis') == 'annual-flat')

    # ---- revenue ---------------------------------------------------------
    rv = api(tok, '/sectorperf/revenue?year=' + YEAR)
    ck('revenue returns categories', len(rv.get('categories') or []) > 0)
    ck('revenue returns both streams',
       {x['stream'] for x in rv.get('streams') or []} == {'SOVEREIGN', 'COMMERCIAL'})
    ck('revenue categories sum to the stream totals',
       near(sum(c['actual'] for c in rv['categories']),
            rv['total']['actual'] +
            sum(c['actual'] for c in rv['categories'] if c['stream'] == 'OTHER')))
    ck('revenue total actual matches the overview',
       near(rv['total']['actual'] +
            sum(c['actual'] for c in rv['categories'] if c['stream'] == 'OTHER'),
            o['revenue']['ytdActual'], 1.0))
    ck('revenue MTD trend returned', isinstance(rv.get('trend'), list))
    rv_full = api(tok, '/sectorperf?year=%s' % YEAR)['revenue']
    rv_cut = api(tok, '/sectorperf?year=%s&period=04-%s' % (YEAR, YEAR))['revenue']
    ck('revenue plan honours the period cut-off',
       rv_cut['ytdPlan'] < rv_full['ytdPlan'],
       '%s vs %s' % (rv_cut['ytdPlan'], rv_full['ytdPlan']))
    ck('revenue actual honours the period cut-off',
       rv_cut['ytdActual'] < rv_full['ytdActual'])
    ck('revenue FY plan is unaffected by the period cut-off',
       near(rv_cut['fyPlan'], rv_full['fyPlan']))

    # ---- sample-data controls -------------------------------------------
    sm = api(tok, '/sectorperf/sample?year=' + YEAR)
    # 'batches' is omitted when NULL (APEX_JSON drops NULL keys -- platform
    # convention, clients bind $data.field), so it is asserted only when active
    for key in ('active', 'expenditureRows', 'revenueRows', 'canPurge'):
        ck('sample status carries ' + key, key in sm)
    ck('sample status carries batches when active',
       sm.get('active') != 'Y' or 'batches' in sm)
    ck('sample rows are all batch-stamped when active',
       sm.get('active') != 'Y' or sm.get('batches', '').startswith('SAMPLE:'),
       sm.get('batches'))

    # ---- errors ----------------------------------------------------------
    ck('overview without year is 400', status(tok, '/sectorperf') == 400)
    ck('bad period is 400', status(tok, '/sectorperf?year=%s&period=13-%s' % (YEAR, YEAR)) == 400)
    ck('period outside the year is 400',
       status(tok, '/sectorperf?year=%s&period=01-1999' % YEAR) == 400)
    ck('bad plantype is 400', status(tok, '/sectorperf?year=%s&plantype=NOPE' % YEAR) == 400)
    ck('bad level is 400', status(tok, '/sectorperf/sectors?year=%s&level=nope' % YEAR) == 400)
    ck('no token is 401', status(tok, '/sectorperf?year=' + YEAR, tok_ok=False) == 401)

    print('\n%d passed / %d total' % (ok, ok + fail))
    return 0 if fail == 0 else 1


if __name__ == '__main__':
    raise SystemExit(main())
