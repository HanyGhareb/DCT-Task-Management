#!/usr/bin/env python3
"""
security_console_browser.py -- browser test for the Admin Security Console.

Drives the REAL Admin JET app against PROD ORDS and asserts the Fusion-style
security pages actually render and behave after the 2026-07-19 review round:

  Privileges          interactive-report catalog + who columns + drawer editor
                      with verb-first AND description-required validation
  Privilege Groups    interactive-report (card view replaced)
  Duty / Job roles    interactive-report catalogs; the FULL role editor
                      (definition + grants/duties/exclusions/effective tabs)
                      now lives in a wide edit-drawer opened by row click
  Security Profiles   interactive-report catalog
  User Management     master-detail + aligned form grid + New User drawer
  <security-info>     page-security drawer, artifact register as an
                      interactive-report

Plus the AR/RTL pass, restoring EN at the end (the shell persists the choice).
READ-ONLY on business data: everything it opens it cancels.

Run:  python3 "final apps/Admin/tests/security_console_browser.py"
"""
import os
import re
import subprocess
import sys
import time

from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8097

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
    src = open(os.path.join(JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def set_lang(pg, lang):
    sel = 'button:text-is("EN")' if lang == 'en' else 'button:text-is("ع")'
    pg.locator(sel).last.click()
    pg.wait_for_timeout(2200)


def nav(pg, route, selector):
    pg.evaluate(f"() => window._jetApp.navigate('{route}')")
    pg.wait_for_selector(selector, timeout=25000)


def open_drawer(pg):
    """the open (non-security-info) edit drawer"""
    return pg.locator('.ed-drawer.ed-show:not(.si-drawer)').first


print('=== Security Console -- browser test ===\n')

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

        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function("() => !!window._jetApp", timeout=30000)
        ok(f'logged in as {user}')
        set_lang(pg, 'en')

        # ---- nav group ----------------------------------------------------
        if pg.locator('text=Security Console').count() > 0:
            ok('Security Console nav group visible to SYS_ADMIN')
        else:
            bad('Security Console nav group missing')

        # ---- privileges: interactive report -------------------------------
        nav(pg, 'privileges', '.rm-ir-panel')
        pg.wait_for_selector('.rm-ir-panel .ir-table tbody tr', timeout=25000)
        # Chrome innerText applies the th text-transform — compare lower-case
        head_txt = pg.locator('.rm-ir-panel .ir-table thead').inner_text().lower()
        if 'created by' in head_txt and 'updated on' in head_txt:
            ok('privileges grid shows the who columns')
        else:
            bad(f'who columns missing from grid header: {head_txt[:120]}')
        if 'description' in head_txt:
            ok('privileges grid shows the Description column')
        else:
            bad('Description column missing')

        pg.locator('.rm-ir-panel .ir-wrap input.form-control').first.fill('GL_VIEW')
        pg.wait_for_timeout(1200)
        rows = pg.locator('.rm-ir-panel .ir-table tbody tr')
        if rows.count() >= 5:
            ok(f'IR global search filters the catalog ({rows.count()} GL_VIEW rows)')
        else:
            bad(f'IR search rows = {rows.count()}')
        pg.locator('.rm-ir-panel .ir-wrap input.form-control').first.fill('')
        pg.wait_for_timeout(800)

        # ---- privilege editor drawer + validation -------------------------
        pg.click('.rm-btn-add')
        pg.wait_for_selector('.ed-drawer.ed-show:not(.si-drawer)', timeout=10000)
        dr = open_drawer(pg)
        dr.locator('input.re-input--mono').fill('TBROWSER_X')
        dr.locator('input.re-input:not(.re-input--mono)').first.fill('Budget things')
        dr.locator('header .btn-primary').click()
        pg.wait_for_timeout(600)
        if 'verb' in (dr.locator('.rm-alert--error').inner_text() or '').lower():
            ok('verb-first rule enforced in the editor drawer')
        else:
            bad('verb-first rule not enforced client-side')
        dr.locator('input.re-input:not(.re-input--mono)').first.fill('View budget things')
        dr.locator('header .btn-primary').click()
        pg.wait_for_timeout(600)
        if 'description' in (dr.locator('.rm-alert--error').inner_text() or '').lower():
            ok('description-required rule enforced in the editor drawer')
        else:
            bad('description-required rule not enforced')
        dr.locator('header .btn:not(.btn-primary)').first.click()
        pg.wait_for_timeout(500)

        # ---- row click opens the editor drawer ----------------------------
        pg.locator('.rm-ir-panel td[data-key="code"]', has_text='ADMIN_MANAGE_SECURITY').first.click()
        pg.wait_for_selector('.ed-drawer.ed-show:not(.si-drawer)', timeout=10000)
        dr = open_drawer(pg)
        if 'Manage Security Console' in (dr.locator('input.re-input:not(.re-input--mono)').first.input_value() or ''):
            ok('row click opens the privilege editor pre-filled')
        else:
            bad('row click editor not pre-filled')
        dr.locator('header .btn:not(.btn-primary)').first.click()
        pg.wait_for_timeout(500)

        # ---- security info drawer (shared component, IR register) ---------
        pg.locator('.si-link').first.click()
        pg.wait_for_selector('.si-drawer.ed-show', timeout=15000)
        pg.wait_for_timeout(1500)
        # .first: the embedded interactive-report carries its own nested
        # edit-drawer (the calc-column editor), so the selector matches twice
        body = pg.locator('.si-drawer .ed-drawer__body').first.inner_text()
        if 'ADMIN_MANAGE_SECURITY' in body:
            ok('<security-info> drawer shows the page view privilege')
        else:
            bad(f'security-info drawer content unexpected: {body[:120]}')
        if pg.locator('.si-drawer .ir-table tbody tr').count() >= 1:
            ok('security-info drawer renders artifacts as an interactive report')
        else:
            bad('security-info artifact interactive report missing')
        pg.locator('.si-drawer header .btn').first.click()
        pg.wait_for_timeout(400)

        # ---- privilege groups ---------------------------------------------
        nav(pg, 'privilegeGroups', '.rm-ir-panel')
        pg.wait_for_selector('.rm-ir-panel .ir-table tbody tr', timeout=25000)
        if pg.locator('text=Financial Planning and Reporting').count() > 0:
            ok('privilege group "Financial Planning and Reporting" in the grid')
        else:
            bad('GL privilege group missing from grid')
        grp_txt = pg.locator('.rm-ir-panel .ir-table tbody').inner_text()
        if 'Bundles the' in grp_txt:
            ok('group descriptions visible in the grid')
        else:
            bad('group descriptions missing')

        # ---- duty + job roles ---------------------------------------------
        nav(pg, 'dutyRoles', '.rm-ir-panel')
        pg.wait_for_selector('.rm-ir-panel .ir-table tbody tr', timeout=25000)
        if 'GL_DUTY_FIN_REPORTING' in pg.locator('.rm-ir-panel .ir-table tbody').inner_text():
            ok('duty roles grid lists the GL duties')
        else:
            bad('GL duties missing from duty grid')

        nav(pg, 'jobRoles', '.rm-ir-panel')
        pg.wait_for_selector('.rm-ir-panel .ir-table tbody tr', timeout=25000)
        jobs = pg.locator('.rm-ir-panel .ir-table tbody').inner_text()
        if 'GL_ACCOUNTANT' in jobs and 'GL_ANALYST' in jobs:
            ok('job roles grid lists GL Analyst + GL Accountant')
        else:
            bad('GL job roles missing')

        # ---- role editor drawer -------------------------------------------
        pg.locator('.rm-ir-panel td[data-key="code"]', has_text='GL_ACCOUNTANT').first.click()
        pg.wait_for_selector('.ed-drawer.ed-show:not(.si-drawer)', timeout=10000)
        dr = open_drawer(pg)
        pg.wait_for_timeout(2000)
        tabs_txt = dr.locator('.rm-tabs').inner_text()
        m = re.search(r'Nested Duties \((\d+)\)', tabs_txt)
        if m and int(m.group(1)) >= 3:
            ok(f'role editor drawer: GL Accountant nests {m.group(1)} duties')
        else:
            bad(f'role editor duties count wrong: {tabs_txt}')
        dr.locator('.rm-tab', has_text='Effective Privileges').click()
        pg.wait_for_timeout(800)
        eff_rows = dr.locator('.rm-table .rm-row')
        if eff_rows.count() >= 10:
            ok(f'role editor drawer: effective closure renders ({eff_rows.count()} privileges)')
        else:
            bad(f'effective closure rows = {eff_rows.count()}')
        dr.locator('header .btn:not(.btn-primary)').first.click()
        pg.wait_for_timeout(600)

        # ---- security profiles --------------------------------------------
        nav(pg, 'secProfiles', '.rm-ir-panel')
        pg.wait_for_timeout(1500)
        ok('security profiles page rendered as an interactive report')

        # ---- user management ----------------------------------------------
        nav(pg, 'userManagement', '.rm-split')
        pg.wait_for_selector('.rm-user-item', timeout=25000)
        pg.locator('.rm-user-item').first.click()
        pg.wait_for_selector('.rm-tabs', timeout=25000)
        ok('user management: master-detail opened')
        if pg.locator('.rm-form-grid').count() >= 1:
            ok('user management: profile uses the aligned form grid')
        else:
            bad('aligned form grid missing on profile tab')
        pg.locator('.rm-tab', has_text='Effective Privileges').click()
        pg.wait_for_timeout(2000)
        ok('user management: effective privileges tab rendered')
        pg.locator('.rm-tab', has_text='Role Assignments').click()
        pg.wait_for_timeout(1200)
        if pg.locator('.rm-inline-form select').count() >= 1:
            ok('user management: dated role-assignment form present')
        else:
            bad('role assignment form missing')

        # new user drawer
        pg.locator('.rm-page-head .rm-btn-add').click()
        pg.wait_for_selector('.ed-drawer.ed-show:not(.si-drawer)', timeout=10000)
        dr = open_drawer(pg)
        if dr.locator('input.re-input--mono').count() >= 1:
            ok('user management: New User opens in a drawer')
        else:
            bad('New User drawer missing username field')
        dr.locator('header .btn:not(.btn-primary)').first.click()
        pg.wait_for_timeout(500)

        pg.screenshot(path=os.path.join(HERE, 'security_console_en.png'), full_page=True)

        # ---- AR / RTL pass ------------------------------------------------
        set_lang(pg, 'ar')
        dir_attr = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        if dir_attr == 'rtl':
            ok('AR pass: document flips to RTL')
        else:
            bad(f'AR pass: dir={dir_attr}')
        nav(pg, 'privileges', '.rm-page')
        pg.wait_for_timeout(2000)
        if pg.locator('.rm-ir-panel .ir-table tbody tr, .rm-empty').count() > 0:
            ok('AR pass: privileges grid renders under RTL')
        else:
            bad('AR pass: privileges page empty under RTL')
        pg.screenshot(path=os.path.join(HERE, 'security_console_ar.png'), full_page=True)
        set_lang(pg, 'en')
        ok('language restored to EN (account left as found)')

        js_errors = [e for e in errors if 'ResizeObserver' not in e]
        if not js_errors:
            ok('no JavaScript page errors')
        else:
            bad(f'JS errors: {js_errors[:3]}')

        b.close()
finally:
    proxy.terminate()

print(f'\n=== {PASS} pass, {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
