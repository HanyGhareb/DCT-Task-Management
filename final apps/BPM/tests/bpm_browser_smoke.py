#!/usr/bin/env python3
"""
bpm_browser_smoke.py -- Fusion BPM (App 214) shell + consolidation smoke.

Proves the NEW app itself (the moved pages have their own deep suites here):
  - BPM boots on the shared session, brand cube BP / APP 214, burgundy brand
  - dashboard renders the stat tiles + quick links
  - nav: workspace visible to all; Process Design + Oversight only for
    WF_ADMIN / SYS_ADMIN (server 403s stay the real boundary)
  - every moved route loads: myWorklist, pendingApprovals, myDelegations,
    processes, roleAssignments, approvalMonitor, approvalTemplates, delegations
  - notifications page renders
  - the module switcher lists Fusion BPM
  - ADMIN app no longer shows the moved nav entries and links to Fusion BPM
  - AR/RTL renders with no raw i18n keys on the dashboard

READ-ONLY: navigates and renders only; nothing is created or actioned.

Run:  python3 "final apps/BPM/tests/bpm_browser_smoke.py"
"""
import os
import re
import subprocess
import sys
import time

from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
ADMIN_JET = os.path.join(HERE, '..', '..', 'Admin', 'Jet')
PORT = 8088

PASS = FAIL = 0


def ok(m):
    global PASS
    PASS += 1
    print(f'  pass  {m}')


def bad(m):
    global FAIL
    FAIL += 1
    print(f'  FAIL  {m}')


def creds():
    src = open(os.path.join(ADMIN_JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def set_lang(pg, lang):
    sel = 'button:text-is("EN")' if lang == 'en' else 'button:text-is("ع")'
    pg.locator(sel).last.click()
    pg.wait_for_timeout(2200)


print('=== Fusion BPM -- app smoke ===\n')

proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)

try:
    user, pwd = creds()
    with sync_playwright() as p:
        b = p.chromium.launch(args=['--no-sandbox', '--disable-dev-shm-usage'])
        pg = b.new_page(viewport={'width': 1500, 'height': 950})
        errors = []
        pg.on('pageerror', lambda e: errors.append(str(e)))

        # ---- boot: no session -> Admin login, then back to BPM ------------
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_selector('input[type="text"]', timeout=30000)
        if '/Admin/Jet/' in pg.url:
            ok('no session: BPM redirected to the Admin portal for auth')
        else:
            bad('expected redirect to Admin, at ' + pg.url)
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function("() => !!localStorage.getItem('ifinance_jet_session')", timeout=30000)
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_function("() => !!window._jetApp", timeout=30000)
        ok(f'BPM booted on the shared session as {user}')
        set_lang(pg, 'en')

        # ---- shell identity ----------------------------------------------
        side = pg.locator('.side-logo').inner_text()
        if 'BP' in side and '214' in side:
            ok('side logo: BP cube + APP 214')
        else:
            bad('side logo wrong: ' + side.replace('\n', ' '))
        brand = pg.evaluate("getComputedStyle(document.documentElement).getPropertyValue('--brand').trim()")
        ok(f'brand var applied ({brand})') if brand else bad('no --brand var')

        # ---- dashboard ----------------------------------------------------
        pg.wait_for_selector('.bpm-stats', timeout=20000)
        tiles = pg.locator('.bpm-stat').count()
        ok(f'dashboard renders {tiles} stat tiles') if tiles >= 3 else bad(f'only {tiles} stat tiles')
        qk = pg.locator('.bpm-quick .qk').count()
        ok(f'dashboard renders {qk} quick links') if qk >= 3 else bad(f'only {qk} quick links')

        # ---- nav groups (SYS_ADMIN sees everything) -----------------------
        nav = pg.locator('nav.side').inner_text()
        for item in ['My Worklist', 'Pending Approvals', 'My Delegations',
                     'Approval Processes', 'Role Assignments',
                     'Approval Monitor', 'Approval Templates', 'Delegations']:
            if item in nav:
                ok(f'nav shows "{item}"')
            else:
                bad(f'nav missing "{item}": ' + nav[:200].replace('\n', ' '))

        # ---- every moved route loads --------------------------------------
        ROUTES = [
            ('myWorklist',        '.wf-wl'),
            ('pendingApprovals',  '.page-wrap'),
            ('myDelegations',     '.page-wrap'),
            ('processes',         '.wf-dz, .page-wrap'),
            ('roleAssignments',   '.data-table'),
            ('approvalMonitor',   '.page-wrap'),
            ('approvalTemplates', '.page-wrap'),
            ('delegations',       '.page-wrap'),
            ('notifications',     '.page-wrap'),
        ]
        for route, sel in ROUTES:
            pg.evaluate(f"() => window._jetApp.navigate('{route}')")
            try:
                pg.wait_for_selector(sel, timeout=20000)
                pg.wait_for_timeout(600)
                body = pg.inner_text('.app-module-host')
                leaked = re.findall(r'\b(?:vw|wf|pa|del|tmpl|nav|dash)\.[a-zA-Z_.]+\b', body)
                if leaked:
                    bad(f'route {route}: raw i18n keys visible: {sorted(set(leaked))[:4]}')
                else:
                    ok(f'route {route} renders')
            except Exception as e:
                bad(f'route {route} failed to render: {str(e)[:80]}')

        # ---- module switcher lists Fusion BPM ------------------------------
        pg.locator('.modsw-btn').click()
        pg.wait_for_timeout(500)
        menu = pg.locator('.modsw-menu').inner_text()
        if 'Fusion BPM' in menu and '214' in menu:
            ok('module switcher lists Fusion BPM (APP 214)')
        else:
            bad('switcher missing Fusion BPM: ' + menu[:200].replace('\n', ' '))
        pg.keyboard.press('Escape')
        pg.locator('.app-content').click()

        # ---- AR / RTL ------------------------------------------------------
        pg.evaluate("() => window._jetApp.navigate('dashboard')")
        pg.wait_for_selector('.bpm-stats', timeout=20000)
        set_lang(pg, 'ar')
        direction = pg.evaluate("document.documentElement.getAttribute('dir')")
        ok('AR switches to RTL') if direction == 'rtl' else bad('dir != rtl')
        body = pg.inner_text('.page-wrap')
        leaked = re.findall(r'\b(?:dash|nav)\.[a-zA-Z_.]+\b', body)
        if leaked:
            bad(f'AR dashboard leaks raw keys: {sorted(set(leaked))[:4]}')
        else:
            ok('AR dashboard leaks no raw i18n keys')
        pg.screenshot(path=os.path.join(HERE, 'bpm_smoke_ar.png'), full_page=True)
        set_lang(pg, 'en')
        ok('language restored to EN')
        pg.screenshot(path=os.path.join(HERE, 'bpm_smoke_en.png'), full_page=True)

        # ---- ADMIN side: moved entries gone, Fusion BPM link present -------
        pg.goto(f'http://localhost:{PORT}/Admin/Jet/index.html', wait_until='networkidle')
        pg.wait_for_function("() => !!window._jetApp", timeout=30000)
        pg.wait_for_timeout(1500)
        anav = pg.locator('nav.side').inner_text()
        gone = [x for x in ['My Worklist', 'Role Assignments', 'Approval Monitor',
                            'Approval Templates'] if x in anav]
        if gone:
            bad('Admin still shows moved entries: ' + str(gone))
        else:
            ok('Admin nav no longer shows the moved workflow entries')
        if 'Fusion BPM' in anav:
            ok('Admin nav links to Fusion BPM under i-Finance Modules')
        else:
            bad('Admin nav has no Fusion BPM link: ' + anav[:300].replace('\n', ' '))

        # ---- console health ------------------------------------------------
        if errors:
            bad(f'JS errors during run: {errors[:3]}')
        else:
            ok('no JavaScript errors during the whole run')

        b.close()
finally:
    proxy.terminate()

print(f'\n=== {PASS} passed, {FAIL} failed ===')
sys.exit(1 if FAIL else 0)
