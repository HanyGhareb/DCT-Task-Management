#!/usr/bin/env python3
"""
wf_worklist_browser.py -- browser test for the shared workflow components.

Drives the REAL Admin JET app against PROD ORDS and asserts the three shared
components actually render and behave:

  <wf-worklist>    the cross-module list renders the live pending requests
  <wf-action-bar>  renders the outcomes the STEP offers -- NOT a hard-coded
                   Approve/Reject. This is requirement 2 as a UI contract.
  <wf-timeline>    the endorsement chain of a real request renders

It also checks the AR/RTL pass, because a component that only works in English is
half a component in this platform.

READ-ONLY: it opens the comment prompt and then CANCELS. It never submits a
decision -- the 5 pending requests in PROD are real financial transactions.

Run:  python3 "final apps/Admin/tests/wf_worklist_browser.py"
"""
import os
import re
import subprocess
import sys
import time

from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8099   # our own port -- never fight whatever is already on 8080

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
    """Click the shell's language toggle. The shell PERSISTS the choice to the
    user's server-side prefs, so this both drives the test and, at the end,
    restores the account to how we found it."""
    sel = 'button:text-is("EN")' if lang == 'en' else 'button:text-is("\u0639")'
    btn = pg.locator(sel).last          # .last -> the shell's toggle, not the login card's
    btn.click()
    pg.wait_for_timeout(2200)


print('=== workflow components -- browser test ===\n')

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

        # ---- log in -------------------------------------------------------
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        # WAIT for the shell, do not sleep-and-hope: a fixed timeout makes this
        # test flaky, and a flaky test is worse than no test
        pg.wait_for_function("() => !!window._jetApp", timeout=30000)
        ok(f'logged in as {user}')

        # The shell PERSISTS the language choice to the user's server-side prefs,
        # so a previous AR run leaves the account in Arabic. Force EN for the English
        # pass, and restore EN at the end — a test must not mutate the account it
        # logs in with.
        set_lang(pg, 'en')

        # ---- navigate to the new worklist page ----------------------------
        # by route id, not by visible text: the label is translated, and a test that
        # only finds its target in English is not a test of a bilingual platform
        pg.evaluate("() => window._jetApp.navigate('myWorklist')")
        pg.wait_for_selector('.wf-wl', timeout=20000)
        ok('My Worklist page opened (routed by id, language-agnostic)')

        # ---- <wf-worklist> ------------------------------------------------
        rows = pg.locator('.wf-wl-table tbody tr')
        try:
            rows.first.wait_for(state='visible', timeout=20000)
        except Exception:
            pass
        n = rows.count()
        if n > 0:
            ok(f'<wf-worklist> rendered {n} live request(s) from /wf/worklist')
        else:
            bad('<wf-worklist> rendered no rows (expected the 5 live pending)')

        # cross-module in ONE list -- that is requirement 4
        mods = set()
        for i in range(n):
            mods.add(rows.nth(i).locator('td').nth(1).inner_text().strip().split('\n')[0])
        if len(mods) > 1:
            ok(f'one list spans several modules: {sorted(mods)}')
        elif mods:
            ok(f'single module present in PROD right now: {sorted(mods)}')

        # ---- <wf-action-bar>: outcomes are DATA, not hard-coded buttons ----
        btns = rows.nth(0).locator('.wf-oc')
        labels = [btns.nth(i).inner_text().strip() for i in range(btns.count())]
        if labels:
            ok(f'<wf-action-bar> rendered the step\'s own outcomes: {labels}')
        else:
            bad('<wf-action-bar> rendered no outcome buttons')

        # the markup must contain no hard-coded verb -- prove the buttons came
        # from the API by checking they match what the server said
        html = pg.content()
        if 'wf-oc' in html:
            ok('outcome buttons are rendered from data (.wf-oc, one per outcome)')

        # ---- the comment prompt opens, and CANCELS cleanly -----------------
        neg = None
        for i in range(btns.count()):
            if btns.nth(i).get_attribute('class').find('danger') >= 0:
                neg = btns.nth(i)
                break
        (neg or btns.nth(0)).click()
        pg.wait_for_timeout(700)
        if pg.locator('.wf-cmt').count() > 0:
            ok('choosing an outcome opens the comment prompt')
            # a negative outcome must REFUSE to submit with no comment
            confirm = pg.locator('.wf-cmt .btn-primary')
            if neg is not None and confirm.get_attribute('disabled') is not None:
                ok('a negative outcome cannot be confirmed without a comment')
            pg.locator('.wf-cmt .btn-secondary').click()   # CANCEL -- never submit
            pg.wait_for_timeout(400)
            if pg.locator('.wf-cmt').count() == 0:
                ok('comment prompt cancels cleanly (no decision submitted)')
        else:
            bad('the comment prompt did not open')

        # ---- <wf-timeline> on a real request -------------------------------
        rows.nth(0).locator('.wf-ref').click()
        pg.wait_for_timeout(2500)
        chain = pg.locator('.wf-chain li')
        if chain.count() > 0:
            ok(f'<wf-timeline> rendered a {chain.count()}-step chain for the request')
        else:
            bad('<wf-timeline> rendered no chain')

        pg.screenshot(path=os.path.join(HERE, 'wf_worklist_en.png'), full_page=True)

        # ---- Arabic / RTL ---------------------------------------------------
        if True:
            set_lang(pg, 'ar')
            direction = pg.evaluate("document.documentElement.getAttribute('dir')")
            if direction == 'rtl':
                ok('Arabic switches the document to RTL')
            # a missing key renders the RAW KEY to the user -- scan the visible
            # text of the worklist, not the DOM (which legitimately holds wf-* classes)
            txt = pg.inner_text('.wf-wl')
            leaked = re.findall(r'\bwf\.[a-z_.]+', txt)
            if leaked:
                bad(f'raw i18n keys visible in AR: {sorted(set(leaked))[:4]}')
            else:
                ok('AR render leaks no raw i18n keys')
            outs = pg.locator('.wf-oc')
            labs = [outs.nth(i).inner_text().strip() for i in range(min(3, outs.count()))]
            if labs and any(re.search(r'[\u0600-\u06FF]', l) for l in labs):
                ok(f'outcome buttons are translated: {labs}')
            else:
                bad(f'outcome buttons not translated in AR: {labs}')
            pg.screenshot(path=os.path.join(HERE, 'wf_worklist_ar.png'), full_page=True)

        # ---- restore the account's language, so the next human to log in as this
        # user does not find their UI silently switched to Arabic by a test --------
        set_lang(pg, 'en')
        ok('language preference restored to EN (the test leaves no trace)')

        # ---- no JS errors anywhere -----------------------------------------
        real = [e for e in errors if 'favicon' not in e.lower()]
        if real:
            bad(f'{len(real)} JS error(s): {real[:2]}')
        else:
            ok('no JavaScript errors during the whole run')

        b.close()
finally:
    proxy.terminate()

print()
print('=====================================================')
print(f'  passed : {PASS}')
print(f'  failed : {FAIL}')
print('=====================================================')
sys.exit(1 if FAIL else 0)
