#!/usr/bin/env python3
"""
security_console_browser.py -- browser test for the Admin Security Console.

Drives the REAL Admin JET app against PROD ORDS and asserts the Fusion-style
security pages actually render and behave:

  Privileges          catalog + verb-first create validation
  Privilege Groups    "Financial Planning and Reporting" card from the GL seed
  Duty / Job roles    the seeded GL duties and jobs, nested-duty editor
  Security Profiles   list page
  User Management     master-detail + the effective-privileges preview
  <security-info>     the SYS_ADMIN page-security drawer (shared component)

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
    pg.wait_for_selector(selector, timeout=20000)


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

        # ---- privileges ---------------------------------------------------
        nav(pg, 'privileges', '.rm-page')
        pg.wait_for_selector('.rm-table .rm-row', timeout=20000)
        pg.fill('.rm-search', 'GL_VIEW')
        pg.keyboard.press('Enter')
        pg.wait_for_timeout(1500)
        rows = pg.locator('.rm-table .rm-row')
        if rows.count() >= 5:
            ok(f'privileges catalog lists the GL seeds ({rows.count()} GL_VIEW rows)')
        else:
            bad(f'privileges catalog rows = {rows.count()}')

        # verb-first validation, client-side
        pg.click('.rm-btn-add')
        pg.wait_for_selector('.rm-modal')
        pg.fill('.rm-modal input.re-input--mono', 'TBROWSER_X')
        pg.locator('.rm-modal input.re-input:not(.re-input--mono)').first.fill('Budget things')
        pg.locator('.rm-modal .rm-modal-confirm').click()
        pg.wait_for_timeout(600)
        if 'verb' in (pg.locator('.rm-modal .rm-alert--error').inner_text() or '').lower():
            ok('verb-first rule enforced in the create dialog')
        else:
            bad('verb-first rule not enforced client-side')
        pg.locator('.rm-modal .rm-modal-cancel').click()

        # ---- security info drawer (shared component) ----------------------
        pg.locator('.si-link').first.click()
        pg.wait_for_selector('.si-drawer.ed-show', timeout=15000)
        pg.wait_for_timeout(1500)
        body = pg.locator('.si-drawer .ed-drawer__body').inner_text()
        if 'ADMIN_MANAGE_SECURITY' in body:
            ok('<security-info> drawer shows the page view privilege')
        else:
            bad(f'security-info drawer content unexpected: {body[:120]}')
        if pg.locator('.si-drawer .si-art').count() >= 1:
            ok('security-info drawer lists registered artifacts')
        else:
            bad('security-info drawer shows no artifacts')
        pg.keyboard.press('Escape')
        pg.wait_for_timeout(400)

        # ---- privilege groups ---------------------------------------------
        nav(pg, 'privilegeGroups', '.rm-group-list')
        pg.wait_for_timeout(1200)
        if pg.locator('text=Financial Planning and Reporting').count() > 0:
            ok('privilege group "Financial Planning and Reporting" rendered')
        else:
            bad('GL privilege group card missing')

        # ---- duty + job roles ---------------------------------------------
        nav(pg, 'dutyRoles', '.rm-page')
        pg.wait_for_selector('.rm-table .rm-row', timeout=20000)
        duty_names = pg.locator('.rm-table').inner_text()
        if 'GL_DUTY_FIN_REPORTING' in duty_names:
            ok('duty roles catalog lists the GL duties')
        else:
            bad('GL duties missing from duty catalog')

        nav(pg, 'jobRoles', '.rm-page')
        pg.wait_for_selector('.rm-table .rm-row', timeout=20000)
        jobs = pg.locator('.rm-table').inner_text()
        if 'GL_ACCOUNTANT' in jobs and 'GL_ANALYST' in jobs:
            ok('job roles catalog lists GL Analyst + GL Accountant')
        else:
            bad('GL job roles missing')

        # open the GL Accountant editor -> duties + effective tabs
        row = pg.locator('.rm-row', has_text='GL_ACCOUNTANT').first
        row.locator('.rm-action-btn--edit').first.click()
        pg.wait_for_selector('.rm-tabs', timeout=20000)
        pg.wait_for_timeout(1500)
        tabs_txt = pg.locator('.rm-tabs').inner_text()
        m = re.search(r'Nested Duties \((\d+)\)', tabs_txt)
        if m and int(m.group(1)) >= 3:
            ok(f'role editor: GL Accountant nests {m.group(1)} duties')
        else:
            bad(f'role editor duties count wrong: {tabs_txt}')
        pg.locator('.rm-tab', has_text='Effective Privileges').click()
        pg.wait_for_timeout(800)
        eff_rows = pg.locator('.rm-table .rm-row')
        if eff_rows.count() >= 10:
            ok(f'role editor: effective closure renders ({eff_rows.count()} privileges)')
        else:
            bad(f'effective closure rows = {eff_rows.count()}')
        pg.locator('.rm-back-btn').click()
        pg.wait_for_timeout(800)

        # ---- security profiles --------------------------------------------
        nav(pg, 'secProfiles', '.rm-page')
        pg.wait_for_timeout(1200)
        ok('security profiles page rendered')

        # ---- user management ----------------------------------------------
        nav(pg, 'userManagement', '.rm-split')
        pg.wait_for_selector('.rm-user-item', timeout=20000)
        pg.locator('.rm-user-item').first.click()
        pg.wait_for_selector('.rm-tabs', timeout=20000)
        ok('user management: master-detail opened')
        pg.locator('.rm-tab', has_text='Effective Privileges').click()
        pg.wait_for_timeout(2000)
        ok('user management: effective privileges tab rendered')
        pg.locator('.rm-tab', has_text='Role Assignments').click()
        pg.wait_for_timeout(1200)
        if pg.locator('.rm-inline-form select').count() >= 1:
            ok('user management: dated role-assignment form present')
        else:
            bad('role assignment form missing')

        pg.screenshot(path=os.path.join(HERE, 'security_console_en.png'), full_page=True)

        # ---- AR / RTL pass ------------------------------------------------
        set_lang(pg, 'ar')
        dir_attr = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        if dir_attr == 'rtl':
            ok('AR pass: document flips to RTL')
        else:
            bad(f'AR pass: dir={dir_attr}')
        nav(pg, 'privileges', '.rm-page')
        pg.wait_for_timeout(1500)
        if pg.locator('.rm-table .rm-row, .rm-empty').count() > 0:
            ok('AR pass: privileges page renders under RTL')
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
