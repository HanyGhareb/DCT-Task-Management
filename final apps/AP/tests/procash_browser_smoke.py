"""Procash Transactions - browser smoke (App 212 / AP), EN + AR/RTL.

Drives the real pages against a dev-proxy: register -> new transaction ->
detail lines -> submit gate -> submit -> process -> link invoice -> unlink ->
cancel, then the Arabic/RTL pass.

Auth: module apps redirect to Admin when no session exists, so the suite seeds
localStorage directly. Provide one of
  IFINANCE_SESSION_JSON='{"sessionId":"...","userId":1,...}'   (mint in the DB)
  IFINANCE_UAT_USER / IFINANCE_UAT_PASS                        (normal login)

Everything it writes is tagged BRW-PCH-<timestamp> and ends CANCELLED; a PROD
run should follow up with
  DELETE FROM prod.dct_ap_procash WHERE bank_reference LIKE 'BRW-PCH-%';

Gotchas honoured here:
  * route by id (_jetApp.navigate('procash')) - nav labels are translated
  * the shared shell PERSISTS the language choice to the user's server side
    prefs, so the AR pass always restores EN before leaving
  * networkidle never settles reliably on these pages - wait on window._jetApp

Run: python3 procash_browser_smoke.py [port]
"""
import json
import os
import sys
import time
import urllib.request

from playwright.sync_api import sync_playwright

PORT = sys.argv[1] if len(sys.argv) > 1 else '8134'
BASE = 'http://localhost:' + PORT
ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TAG = 'BRW-PCH-' + time.strftime('%Y%m%d%H%M%S')

results = []


def check(name, cond, extra=''):
    results.append((name, bool(cond)))
    print(('  PASS  ' if cond else '  FAIL  ') + name + (('   -> ' + str(extra)) if extra and not cond else ''))
    return bool(cond)


def session():
    raw = os.environ.get('IFINANCE_SESSION_JSON')
    if raw:
        s = json.loads(raw)
    else:
        user, pwd = os.environ.get('IFINANCE_UAT_USER'), os.environ.get('IFINANCE_UAT_PASS')
        if not user or not pwd:
            sys.exit('Set IFINANCE_SESSION_JSON, or IFINANCE_UAT_USER / IFINANCE_UAT_PASS')
        req = urllib.request.Request(
            ADB + '/dct/auth/login',
            data=json.dumps({'username': user, 'password': pwd}).encode(),
            headers={'Content-Type': 'application/json'})
        s = json.loads(urllib.request.urlopen(req, timeout=60).read())
    s['roles'] = (s.get('rolesCsv') or '').split(',')
    s['initials'] = ''.join(p[0] for p in (s.get('displayName') or 'X').split()[:2]).upper()
    return s


def goto(page, route):
    page.evaluate("r => window._jetApp.navigate(r)", route)
    page.wait_for_timeout(1200)


def main():
    sess = session()
    with sync_playwright() as p:
        b = p.chromium.launch(headless=True)
        ctx = b.new_context(viewport={'width': 1600, 'height': 1000})
        page = ctx.new_page()
        errors = []      # JS errors only — the suite deliberately provokes 400s,
        console = []     # so network noise is kept separate from real breakage
        page.on('pageerror', lambda e: errors.append(str(e)))
        page.on('console', lambda m: console.append(m.text) if m.type == 'error' else None)

        page.goto(BASE + '/index.html')
        page.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
        page.goto(BASE + '/index.html')
        page.wait_for_function("() => !!window._jetApp", timeout=30000)
        page.wait_for_timeout(1500)

        print('-- register')
        goto(page, 'procash')
        page.wait_for_timeout(2500)
        check('the register page loads', 'Procash' in page.locator('.page-title').first.inner_text(),
              page.locator('.page-title').first.inner_text())
        check('the KPI band has 4 tiles', page.locator('.kpi').count() == 4, page.locator('.kpi').count())
        check('the filter row renders', page.locator('.ap-chips .form-control').count() >= 6,
              page.locator('.ap-chips .form-control').count())
        check('the register region renders',
              page.locator('.ap-region .section-heading').count() >= 1)
        check('a new transaction can be started', page.locator('button:has-text("New procash")').count() == 1)

        print('-- create')
        page.locator('button:has-text("New procash")').click()
        page.wait_for_timeout(2500)
        check('the entry page opens', 'New procash' in page.locator('.page-title').inner_text(),
              page.locator('.page-title').inner_text())
        check('the payment form renders', page.locator('.form-grid .form-control').count() >= 10,
              page.locator('.form-grid .form-control').count())

        def fill(label, value):
            grp = page.locator('.form-group', has=page.locator('.form-label', has_text=label)).first
            el = grp.locator('.form-control').first
            el.fill(str(value))
            el.dispatch_event('change')          # KO value: commits on change

        fill('Bank reference', TAG)
        fill('Paying bank account', 'FAB Current 9911')
        fill('Amount', '900')
        # payee is now a strict pick from the Fusion supplier list
        page.locator('.form-group', has=page.locator('.form-label', has_text='Find supplier')).first \
            .locator('.form-control').first.fill('a')
        page.wait_for_timeout(1500)
        payee = page.locator('.form-group', has=page.locator('.form-label', has_text='Payee')).first \
            .locator('select')
        check('the payee dropdown is fed from the supplier master',
              payee.locator('option').count() > 1, payee.locator('option').count())
        payee.select_option(index=1)
        payee.dispatch_event('change')
        page.locator('.form-group', has=page.locator('.form-label', has_text='Business unit')).first \
            .locator('select').select_option(index=1)
        page.wait_for_timeout(300)
        page.locator('.page-actions button:has-text("Save")').click()
        page.wait_for_timeout(3000)
        check('saving stamps a payment number',
              'PCH-' in page.locator('.page-title').inner_text(), page.locator('.page-title').inner_text())
        check('a new transaction shows the Draft pill',
              page.locator('.pc-pill').first.inner_text().strip().lower() == 'draft',
              page.locator('.pc-pill').first.inner_text())
        check('an empty transaction reports a blocking finding',
              page.locator('.pc-finding--block').count() >= 1)
        check('the tab strip appears once saved', page.locator('.ap-tabs .ap-tab').count() == 3)

        print('-- detail lines')
        page.locator('button:has-text("Add line")').click()
        page.wait_for_timeout(800)
        check('the line drawer opens', page.locator('.dw-drawer.show').count() == 1)
        check('the coding basis offers both options',
              page.locator('.dw-drawer.show input[type=radio]').count() == 2)

        # project / task / expenditure type come from the meta pick lists
        proj = page.evaluate("""async () => {
            const t = JSON.parse(localStorage.getItem('ifinance_jet_session')).sessionId;
            const base = '/ords/admin/ap/procash/meta/';
            const j = async u => (await fetch(base + u, { headers: { Authorization: 'Bearer ' + t } })).json();
            const ps = await j('projects');
            for (const p of ps.items.slice(0, 25)) {
                const ts = await j('tasks?project=' + encodeURIComponent(p.code));
                if (ts.items && ts.items.length) {
                    const es = await j('etypes');
                    return { project: p.code, task: ts.items[0].code, etype: es.items[0].code };
                }
            }
            return null;
        }""")
        check('a project/task/expenditure fixture was found', bool(proj), proj)

        def dpick(label, value):
            sel = page.locator('.dw-drawer.show .form-group',
                               has=page.locator('.form-label', has_text=label)).first.locator('select')
            sel.select_option(value)
            sel.dispatch_event('change')
            page.wait_for_timeout(700)

        def dfill(label, value):
            grp = page.locator('.dw-drawer.show .form-group', has=page.locator('.form-label', has_text=label)).first
            el = grp.locator('.form-control').first
            el.fill(str(value))
            el.dispatch_event('change')

        dpick('Project', proj['project'])
        dpick('Task', proj['task'])
        dpick('Expenditure type', proj['etype'])
        check('the coding fields are strict dropdowns',
              page.locator('.dw-drawer.show select').count() >= 3,
              page.locator('.dw-drawer.show select').count())
        dfill('Amount', '500')
        page.locator('.dw-drawer.show button:has-text("Save")').click()
        page.wait_for_timeout(2500)
        check('the line is stored', page.locator('.data-table tbody tr').count() == 1,
              page.locator('.data-table tbody tr').count())
        check('the balance line flags the gap', page.locator('.pc-neg').count() >= 1)

        print('-- submit gate')
        page.locator('.page-actions button:has-text("Submit")').click()
        page.wait_for_timeout(2000)
        check('an out of balance transaction stays Draft',
              page.locator('.pc-pill').first.inner_text().strip().lower() == 'draft',
              page.locator('.pc-pill').first.inner_text())

        fill('Amount', '500')
        page.locator('.page-actions button:has-text("Save")').click()
        page.wait_for_timeout(2500)
        check('the balance line turns positive once matched', page.locator('.pc-pos').count() >= 1)

        page.locator('.page-actions button:has-text("Submit")').click()
        page.wait_for_timeout(2500)
        check('a balanced transaction submits',
              page.locator('.pc-pill').first.inner_text().strip().lower() in ('submitted', 'in approval'),
              page.locator('.pc-pill').first.inner_text())

        print('-- process and invoice')
        if page.locator('button:has-text("Mark processed")').count():
            page.locator('button:has-text("Mark processed")').click()
            page.wait_for_timeout(2500)
            check('processing lands on Processed',
                  page.locator('.pc-pill').first.inner_text().strip().lower() == 'processed',
                  page.locator('.pc-pill').first.inner_text())

            page.locator('button:has-text("Link invoice")').click()
            page.wait_for_timeout(3000)
            check('the invoice picker opens', page.locator('.dw-drawer.show').count() == 1)
            rows = page.locator('.dw-drawer.show .data-table tbody tr')
            check('the picker lists Fusion invoices', rows.count() > 0, rows.count())
            picked = page.locator('.dw-drawer.show button:has-text("Link")')
            if picked.count():
                picked.first.click()
                page.wait_for_timeout(3000)
                check('linking lands on Invoiced',
                      page.locator('.pc-pill').first.inner_text().strip().lower() == 'invoiced',
                      page.locator('.pc-pill').first.inner_text())
                check('the invoice region appears',
                      page.locator('.kv-grid').count() >= 1)
                check('an invoiced transaction hides Save',
                      page.locator('.page-actions button:has-text("Save")').count() == 0)
                page.locator('button:has-text("Unlink invoice")').click()
                page.wait_for_timeout(500)
                page.on('dialog', lambda d: d.accept())
                page.wait_for_timeout(2500)
            else:
                page.locator('.dw-drawer.show button:has-text("Close")').click()

        print('-- tabs')
        page.locator('.ap-tab', has_text='Attachments').click()
        page.wait_for_timeout(700)
        check('the attachments tab renders', page.locator('.empty-state, .data-table').count() >= 1)
        page.locator('.ap-tab', has_text='History').click()
        page.wait_for_timeout(700)
        hist = page.locator('.data-table tbody tr').count()
        check('the history tab lists the transitions', hist >= 2, hist)

        print('-- back to the register')
        page.locator('button:has-text("Back")').click()
        page.wait_for_timeout(2500)
        check('Back returns to the register',
              'Procash Transactions' in page.locator('.page-title').first.inner_text())
        page.locator('.ap-chips input[type=search]').fill(TAG)
        page.wait_for_timeout(1800)
        found = page.locator('.data-table tbody tr').count()
        check('the register finds this run', found >= 1, found)
        check('the status pill renders in the register', page.locator('.data-table .pc-pill').count() >= 1)

        print('-- arabic / RTL')
        page.locator('.lang-pill button', has_text='\u0639').click()   # AR
        page.wait_for_timeout(2500)
        check('the document flips to RTL', page.evaluate("document.documentElement.getAttribute('dir')") == 'rtl',
              page.evaluate("document.documentElement.getAttribute('dir')"))
        goto(page, 'procash')
        page.wait_for_timeout(2500)
        title_ar = page.locator('.page-title').first.inner_text()
        check('the register title is Arabic', 'معاملات' in title_ar, title_ar)
        check('no raw i18n key leaks in Arabic', '.pc' not in title_ar and 'pc.' not in title_ar, title_ar)
        check('the KPI band survives RTL', page.locator('.kpi').count() == 4)

        # restore EN - the shell persists the choice to the user's server prefs
        page.locator('.lang-pill button', has_text='EN').click()
        page.wait_for_timeout(2000)
        check('English is restored', page.evaluate("document.documentElement.getAttribute('dir')") != 'rtl')

        print('-- cleanup')
        goto(page, 'procash')
        page.wait_for_timeout(2000)
        page.locator('.ap-chips input[type=search]').fill(TAG)
        page.wait_for_timeout(1800)
        if page.locator('.data-table tbody tr').count():
            page.locator('.data-table tbody tr').first.click()
            page.wait_for_timeout(2500)
            page.on('dialog', lambda d: d.accept())
            if page.locator('button:has-text("Cancel transaction")').count():
                page.locator('button:has-text("Cancel transaction")').click()
                page.wait_for_timeout(2500)
                check('the transaction can be cancelled',
                      page.locator('.pc-pill').first.inner_text().strip().lower() == 'cancelled',
                      page.locator('.pc-pill').first.inner_text())

        check('no JavaScript errors were raised', len(errors) == 0, errors[:3])
        b.close()

    passed = sum(1 for _, ok in results if ok)
    print('\n=== %d passed, %d failed ===' % (passed, len(results) - passed))
    print('rows tagged %s remain in PROD until cleaned' % TAG)
    return 0 if passed == len(results) else 1


if __name__ == '__main__':
    sys.exit(main())
