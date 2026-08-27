#!/usr/bin/env python3
"""GL (App 210) — Generate-and-Send + Email Logs + Report Recipients browser smoke (EN + AR/RTL).

Covers: the butil page-head Generate and Send dropdown (3 levels), the send
drawer (shared <tree-select> pick -> Add -> selected list -> recipient
confirmation with the TEST-MODE banner and Confirm & Send enablement — the
actual send is NOT clicked here; the API smoke covers the batch), the Email
Logs page (search + register + drill drawer), and the Report Recipients page
(register + edit drawer + import drawer), plus an AR/RTL pass.

Setup/teardown via ORDS: creates a recipient list for a real sector with
@example.invalid addresses, deletes it after. Nothing can be emailed:
EMAIL_TEST_MODE=Y with no EMAIL_TEST_TO (user rule 2026-08-24).

Auth: GL_TOK = a live session token.
Run:  python dev-proxy.py 8213 (from GL/Jet) then python gs_browser_smoke.py
"""
import json
import os
import ssl
import sys
import urllib.request

from playwright.sync_api import sync_playwright

BASE = os.environ.get('GL_BASE', 'http://localhost:8213')
API = os.environ.get('GL_API', 'https://129.151.159.189')
EV = os.environ.get('GL_EVIDENCE', '/tmp/gl_gs_evidence/')
os.makedirs(EV, exist_ok=True)

TOK = os.environ.get('GL_TOK')
if not TOK:
    sys.exit('Set GL_TOK (live session token)')
sess = {
    'sessionId': TOK,
    'userId': int(os.environ.get('GL_UID', '1')),
    'username': os.environ.get('GL_USERNAME', 'ADMIN'),
    'displayName': os.environ.get('GL_DN', 'System Administrator'),
    'rolesCsv': os.environ.get('GL_ROLES', 'SYS_ADMIN'),
}
sess['roles'] = sess['rolesCsv'].split(',')

CTX_SSL = ssl.create_default_context()
CTX_SSL.check_hostname = False
CTX_SSL.verify_mode = ssl.CERT_NONE


def ords(method, path, body=None):
    hdr = {'Authorization': 'Bearer ' + TOK}
    data = None
    if body is not None:
        hdr['Content-Type'] = 'application/json'
        data = json.dumps(body).encode()
    r = urllib.request.Request(API + '/ords/admin/gl' + path, data=data,
                               method=method, headers=hdr)
    try:
        resp = urllib.request.urlopen(r, timeout=120, context=CTX_SSL)
        return resp.status, json.loads(resp.read() or b'{}')
    except urllib.error.HTTPError as e:
        return e.code, {}


results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('PASS' if cond else 'FAIL'), name, extra)


# ── setup: a recipient list on a real sector that has NO list row AT ALL
# (hasRecipients=false also covers disabled rows, which still hold the
#  unique (group,scope) slot — exclude any existing row explicitly) ────────
st, tree = ords('GET', '/butil/dist/meta/tree?level=SECTOR&year=2026')
st, existing = ords('GET', '/butil/dist')
taken = set(r['scopeValue'] for r in existing.get('items', []) if r['scopeType'] == 'SECTOR')
free = [s for s in tree.get('sectors', [])
        if not s.get('hasRecipients') and s['sector'] not in taken]
if not free:
    sys.exit('no sector without a recipient list — adjust the smoke')
SECTOR = free[0]['sector']
st, d = ords('POST', '/butil/dist', {
    'scopeType': 'SECTOR', 'scopeValue': SECTOR, 'scopeLabel': SECTOR,
    'sectorName': SECTOR,
    'recipients': [
        {'disposition': 'TO', 'email': 'ui.to@example.invalid', 'name': 'UI To'},
        {'disposition': 'CC', 'email': 'ui.cc@example.invalid'},
        {'disposition': 'BCC', 'email': 'ui.bcc@example.invalid'}]})
DIST_ID = d.get('distId')
print('setup: sector=%s distId=%s' % (SECTOR, DIST_ID))

try:
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        ctx = b.new_context(viewport={'width': 1680, 'height': 1050}, ignore_https_errors=True)
        page = ctx.new_page()
        errors = []
        page.on('pageerror', lambda e: errors.append(str(e)))
        ctx.add_init_script(
            "localStorage.setItem('ifinance_jet_session', " + json.dumps(json.dumps(sess)) + ")")
        page.goto(BASE + '/index.html')
        page.wait_for_function(
            "() => window.ko && document.querySelector('.pnav--grp a')", timeout=60000)
        page.wait_for_timeout(2500)

        # ---- 1. Generate and Send menu on the butil page ------------------
        gsbtn = page.locator('#pg-butil .page-actions .gen-btn').nth(1)
        check('Generate and Send button present',
              'generate and send' in gsbtn.inner_text().strip().lower(), gsbtn.inner_text())
        gsbtn.click()
        page.wait_for_timeout(300)
        items = page.locator('#pg-butil .gen-menu .gen-item')
        # both dropdowns exist; the open one is the Generate-and-Send menu
        vis = [i for i in range(items.count()) if items.nth(i).is_visible()]
        check('level menu shows 3 levels', len(vis) == 3, str(len(vis)))
        page.screenshot(path=EV + '01_menu.png')

        # ---- 2. sector-level drawer: tree -> Add -> selected --------------
        items.nth(vis[0]).click()               # Sector Level
        page.wait_for_selector('.dw-gs.show', timeout=15000)
        page.wait_for_selector('.dw-gs .tv-row', timeout=20000)
        check('send drawer + tree rows', page.locator('.dw-gs .tv-row').count() > 3,
              page.locator('.dw-gs .tv-row').count())
        page.fill('.dw-gs .tv-filter', SECTOR[:14])
        page.wait_for_timeout(400)
        row = page.locator('.dw-gs .tv-row').first
        check('tree filter narrows', page.locator('.dw-gs .tv-row').count() >= 1)
        row.click()
        page.wait_for_timeout(200)
        check('tri-state check ON', 'on' in (row.locator('.tv-cb').get_attribute('class') or ''))
        page.locator('.dw-gs .gs-mid .btn').click()
        page.wait_for_timeout(200)
        check('Add moves node to the selected list',
              page.locator('.dw-gs .gs-chip').count() == 1)
        page.screenshot(path=EV + '02_tree_pick.png')

        # ---- 3. confirmation: To/Cc/Bcc + TEST banner + Send enabled ------
        page.locator('.dw-gs .dw-acts .btn-primary').click()   # Next
        page.wait_for_selector('.dw-gs .gs-confirm .gs-node', timeout=20000)
        check('confirmation shows the node', page.locator('.dw-gs .gs-node').count() == 1)
        body = page.locator('.dw-gs .gs-confirm').inner_text()
        check('To addresses listed', 'ui.to@example.invalid' in body, '')
        check('Cc addresses listed', 'ui.cc@example.invalid' in body, '')
        check('Bcc shown as count only',
              'ui.bcc@example.invalid' not in body and 'hidden' in body.lower())
        banner = page.locator('.dw-gs .gs-banner.test')
        check('TEST MODE banner shown', banner.count() >= 1 and banner.first.is_visible())
        send_btn = page.locator('.dw-gs .dw-acts .btn-primary')
        check('Confirm & Send enabled (not clicked)', send_btn.is_enabled())
        page.screenshot(path=EV + '03_confirm.png')
        page.locator('.dw-gs .dw-acts .btn', has_text='Close').click()
        page.wait_for_timeout(300)

        # ---- 4. Email Logs page ------------------------------------------
        page.locator('.pnav--sub a', has_text='Email Logs').click()
        page.wait_for_selector('#pg-emaillog', timeout=15000)
        page.wait_for_timeout(1500)
        check('email logs page + filters',
              page.locator('#pg-emaillog .el-filters label').count() >= 10,
              page.locator('#pg-emaillog .el-filters label').count())
        rows = page.locator('#pg-emaillog tbody tr')
        check('email history rows (from API smoke)', rows.count() >= 1, rows.count())
        page.screenshot(path=EV + '04_emaillog.png')
        rows.first.click()
        page.wait_for_selector('.dw-el.show', timeout=15000)
        page.wait_for_timeout(1200)
        check('drill drawer: recipients table',
              page.locator('.dw-el tbody tr').count() >= 1,
              page.locator('.dw-el tbody tr').count())
        drill_txt = page.locator('.dw-el .dw-b').inner_text()
        check('drill shows dispositions', 'TO' in drill_txt)
        page.screenshot(path=EV + '05_drill.png')
        page.locator('.dw-el .dw-acts .btn', has_text='Close').click()
        page.wait_for_timeout(300)

        # ---- 5. Report Recipients page -----------------------------------
        page.locator('.pnav--grp a', has_text='Settings').click()
        page.wait_for_timeout(800)
        page.locator('.pnav--sub a', has_text='Report Recipients').click()
        page.wait_for_selector('#pg-recipients', timeout=15000)
        page.wait_for_timeout(1500)
        check('recipients register rows',
              page.locator('#pg-recipients tbody tr').count() >= 1,
              page.locator('#pg-recipients tbody tr').count())
        page.locator('#pg-recipients tbody tr', has_text=SECTOR).first.click()
        page.wait_for_selector('.dw-rl.show', timeout=15000)
        page.wait_for_timeout(800)
        check('edit drawer: 3 recipient rows',
              page.locator('.dw-rl.show tbody tr').count() == 3,
              page.locator('.dw-rl.show tbody tr').count())
        page.screenshot(path=EV + '06_rl_edit.png')
        page.locator('.dw-rl.show .dw-acts .btn', has_text='Close').click()
        page.wait_for_timeout(300)
        page.locator('#pg-recipients .page-actions .btn', has_text='Import from Excel').click()
        page.wait_for_selector('.dw-rl.show', timeout=15000)
        check('import drawer opens', page.locator('.dw-rl.show').count() >= 1)
        page.screenshot(path=EV + '07_import.png')
        page.locator('.dw-rl.show .dw-acts .btn', has_text='Close').click()
        page.wait_for_timeout(300)

        # ---- 6. AR / RTL pass --------------------------------------------
        page.evaluate("ko.dataFor(document.body).toggleLang()")
        page.wait_for_timeout(1200)
        check('RTL applied', page.evaluate("document.documentElement.dir") == 'rtl')
        check('recipients title in Arabic',
              'مستلمو التقارير' in page.locator('#pg-recipients .greet').inner_text())
        page.locator('.pnav--grp a').nth(0).click()   # Projects group
        page.wait_for_timeout(800)
        gsbtn_ar = page.locator('#pg-butil .page-actions .gen-btn').nth(1)
        check('AR Generate and Send label', 'إنشاء وإرسال' in gsbtn_ar.inner_text())
        page.screenshot(path=EV + '08_ar.png')
        page.evaluate("ko.dataFor(document.body).toggleLang()")
        page.wait_for_timeout(600)

        check('no JS errors end-to-end', not errors, '; '.join(errors[:3]))
        b.close()
finally:
    if DIST_ID:
        st, _ = ords('DELETE', '/butil/dist/' + str(DIST_ID))
        print('teardown: delete dist %s -> %s' % (DIST_ID, st))

passed = sum(1 for _, okk in results if okk)
print('\n== RESULT: %d/%d passed ==' % (passed, len(results)))
sys.exit(0 if passed == len(results) else 1)
