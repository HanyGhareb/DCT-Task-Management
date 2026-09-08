#!/usr/bin/env python3
"""GL /gl/butil/sectorbook API smoke — the Sector Performance Report bridge.

SECTOR_PERF_BOOK (reporting/db/42) is the Budget Utilization Briefing Book
pack re-covered for distribution: DCT logo top-right + a copyright line on
EVERY page (render_pdf.py pdf-header/pdf-footer hook), simplified cover,
prepared-by "Financial Planning and Reporting". This smoke enqueues a run
through the GL bridge (GL/db/50), waits for a worker to render it, downloads
the PDF and checks the guardrails (auth, validation, run scoping).

Run: python sector_book_api_smoke.py            (defaults to the webtier)
     GL_BASE=http://localhost:8210 python sector_book_api_smoke.py
     GL_PERIOD=09-2026 python sector_book_api_smoke.py
"""
import json
import os
import re
import ssl
import time
import urllib.error
import urllib.request

BASE = os.environ.get('GL_BASE', 'https://129.151.159.189')
AUTH = '/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js'
YEAR = int(os.environ.get('GL_YEAR', '2026'))
PERIOD = os.environ.get('GL_PERIOD', time.strftime('%m-') + str(YEAR))
OUT = os.environ.get('GL_PDF_OUT', '/tmp/sector_performance_report_smoke.pdf')
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


def api(tok, path, method='GET', body=None):
    hdr = {'Authorization': 'Bearer ' + tok}
    data = None
    if body is not None:
        hdr['Content-Type'] = 'application/json'
        data = json.dumps(body).encode()
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, method=method,
                               data=data, headers=hdr)
    return json.loads(urllib.request.urlopen(r, timeout=180, context=CTX).read())


def status_of(tok, path, method='GET', body=None, with_tok=True):
    hdr = {'Authorization': 'Bearer ' + tok} if with_tok else {}
    data = None
    if body is not None:
        hdr['Content-Type'] = 'application/json'
        data = json.dumps(body).encode()
    r = urllib.request.Request(BASE + '/ords/admin/gl' + path, method=method,
                               data=data, headers=hdr)
    try:
        urllib.request.urlopen(r, timeout=60, context=CTX)
        return 200
    except urllib.error.HTTPError as e:
        return e.code


def main():
    tok = login()
    ck('login', bool(tok))

    # one real sector for the mandatory single-sector scope (user rule 2026-09-06)
    sector = os.environ.get('GL_SECTOR') or (api(tok, '/butil/filters').get('sectors') or [None])[0]
    ck('filters ship a sector LOV', bool(sector), sector)

    # guardrails
    ck('POST without session = 401',
       status_of('', '/butil/sectorbook', 'POST', {'year': YEAR}, with_tok=False) == 401)
    ck('POST without year = 400',
       status_of(tok, '/butil/sectorbook', 'POST', {}) == 400)
    ck('POST without sector = 400 (one-sector rule)',
       status_of(tok, '/butil/sectorbook', 'POST', {'year': YEAR}) == 400)
    ck('POST pipe-list sector = 400 (one-sector rule)',
       status_of(tok, '/butil/sectorbook', 'POST',
                 {'year': YEAR, 'sector': 'A|B'}) == 400)
    ck('POST bad period = 400',
       status_of(tok, '/butil/sectorbook', 'POST',
                 {'year': YEAR, 'sector': sector, 'period': '13-' + str(YEAR)}) == 400)
    ck('GET unknown run = 404', status_of(tok, '/butil/sectorbook/999999999') == 404)

    # enqueue with the default page scope (one sector + YTD period + DCT OPEX type)
    d = api(tok, '/butil/sectorbook', 'POST',
            {'year': YEAR, 'period': PERIOD, 'sector': sector,
             'projecttype': 'DCT OPEX Project Type'})
    run_id = d.get('runId')
    ck('enqueue -> runId', bool(run_id), 'run #%s (%s, period %s)' % (run_id, sector, PERIOD))

    # a BUDGET_UTIL_BOOK status route must NOT see this run (report-code scoping)
    ck('run invisible to /butil/book/:id', status_of(tok, '/butil/book/%s' % run_id) == 404)

    st = {}
    for _ in range(75):                     # ~7.5 min ceiling
        time.sleep(6)
        try:
            st = api(tok, '/butil/sectorbook/%s' % run_id)
        except Exception:
            continue
        if st.get('status') in ('SUCCESS', 'FAILED'):
            break
    ck('run finished SUCCESS', st.get('status') == 'SUCCESS', st.get('error') or st.get('status'))
    ck('run hasPdf', bool(st.get('hasPdf')))

    r = urllib.request.Request(BASE + '/ords/admin/gl/butil/sectorbook/%s/pdf' % run_id,
                               headers={'Authorization': 'Bearer ' + tok})
    pdf = urllib.request.urlopen(r, timeout=300, context=CTX).read()
    ck('PDF downloads', pdf[:5] == b'%PDF-', '%d bytes' % len(pdf))
    ck('PDF is a real book', len(pdf) > 20000)
    with open(OUT, 'wb') as f:
        f.write(pdf)
    print('  PDF saved to ' + OUT)

    print('\n%d passed, %d failed' % (ok, fail))
    raise SystemExit(1 if fail else 0)


if __name__ == '__main__':
    main()
