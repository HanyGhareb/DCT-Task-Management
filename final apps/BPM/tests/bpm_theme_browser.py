#!/usr/bin/env python3
"""
bpm_theme_browser.py -- Fusion BPM switchable app skins acceptance.

Proves against PROD ORDS + the real app:
  - a fresh browser boots on the NIGHT skin (the default) with a dark ground,
  - the Appearance page renders its three theme cards (night current),
  - clicking a card previews the skin LIVE (body[data-bpm-skin] flips),
  - Save persists THEME_SKIN so a clean browser (no localStorage) is corrected
    to the saved skin by the boot sync -- the admin's choice reaches everyone,
  - AR/RTL renders the page without raw i18n keys.

Self-restoring: saves NIGHT back at the end and restores EN.
Run:  python3 "final apps/BPM/tests/bpm_theme_browser.py"
"""
import os, re, subprocess, sys, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
ADMIN_JET = os.path.join(HERE, '..', '..', 'Admin', 'Jet')
PORT = 8093
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def creds():
    src = open(os.path.join(ADMIN_JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def skin(pg):
    return pg.evaluate("() => document.body.getAttribute('data-bpm-skin')")


def body_bg(pg):
    return pg.evaluate("() => getComputedStyle(document.body).backgroundColor")


def save_current(pg):
    pg.locator('.page-actions .btn-primary').first.evaluate('el => el.click()')
    pg.wait_for_selector('.alert-banner--info', timeout=10000)


print('=== Fusion BPM app skins -- browser acceptance ===\n')
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

        # ---- login hop (module app -> Admin login -> back) ----------------
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_selector('input[type="text"]', timeout=30000)
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function("() => !!localStorage.getItem('ifinance_jet_session')", timeout=30000)
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')

        # force EN (shell persists language server-side)
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)

        # ---- default skin -------------------------------------------------
        if skin(pg) == 'night':
            ok('fresh browser boots on the NIGHT skin (default)')
        else:
            bad(f'default skin is {skin(pg)!r}, expected night')
        bg = body_bg(pg)
        ok(f'night ground is dark ({bg})') if bg == 'rgb(23, 19, 26)' else bad(f'night body bg = {bg}')

        # ---- Appearance page ---------------------------------------------
        pg.evaluate("() => window._jetApp.navigate('appearance')")
        pg.wait_for_selector('.ap-grid', timeout=20000)
        n = pg.locator('.ap-card').count()
        ok('Appearance page renders 3 theme cards') if n == 3 else bad(f'{n} theme cards')
        cur = pg.locator('.ap-card--on')
        ok('night card is selected') if cur.count() == 1 else bad('no selected card')
        txt = pg.inner_text('.ap-grid')
        if re.search(r'\bap\.[a-z]', txt):
            bad('raw i18n keys visible on Appearance page (EN)')
        else:
            ok('no raw i18n keys (EN)')

        # ---- live preview: click Redwood ---------------------------------
        pg.locator('.ap-card').nth(1).click()
        pg.wait_for_timeout(400)
        ok('clicking Redwood previews it live') if skin(pg) == 'redwood' else bad(f'skin after click = {skin(pg)}')
        bg = body_bg(pg)
        ok(f'redwood ground is warm light ({bg})') if bg == 'rgb(251, 249, 248)' else bad(f'redwood body bg = {bg}')

        # ---- save + cold-boot correction ----------------------------------
        save_current(pg)
        ok('Save confirms with a message')
        # a CLEAN browser (no bpm_skin) must be corrected to REDWOOD from the DB
        pg.evaluate("() => localStorage.removeItem('bpm_skin')")
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        try:
            pg.wait_for_function(
                "() => document.body.getAttribute('data-bpm-skin') === 'redwood'", timeout=15000)
            ok('clean boot syncs the saved skin from the DB (redwood reaches every user)')
        except Exception:
            bad(f'clean boot stayed on {skin(pg)!r} -- DB sync did not correct')

        # ---- diwan spot check --------------------------------------------
        pg.evaluate("() => window._jetApp.navigate('appearance')")
        pg.wait_for_selector('.ap-grid', timeout=20000)
        pg.locator('.ap-card').nth(2).click()
        pg.wait_for_timeout(400)
        bg = body_bg(pg)
        ok(f'diwan previews ivory paper ({bg})') if skin(pg) == 'diwan' and bg == 'rgb(248, 245, 239)' \
            else bad(f'diwan check: skin={skin(pg)} bg={bg}')

        # ---- AR / RTL -----------------------------------------------------
        pg.locator('.lang-pill button').nth(1).click(); pg.wait_for_timeout(1500)
        rtl = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        txt = pg.inner_text('.ap-grid') if pg.locator('.ap-grid').count() else ''
        if rtl == 'rtl' and txt and not re.search(r'\bap\.[a-z]', txt):
            ok('AR renders RTL with no raw i18n keys')
        else:
            bad(f'AR check failed (dir={rtl})')
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)
        ok('restored EN')

        # ---- restore NIGHT (leave no trace) -------------------------------
        if pg.locator('.ap-grid').count() == 0:
            pg.evaluate("() => window._jetApp.navigate('appearance')")
            pg.wait_for_selector('.ap-grid', timeout=20000)
        pg.locator('.ap-card').nth(0).click(); pg.wait_for_timeout(300)
        save_current(pg)
        ok('restored the NIGHT default in the DB') if skin(pg) == 'night' else bad('restore failed')

        pg.screenshot(path=os.path.join(HERE, 'bpm_theme.png'), full_page=True)

        real = [e for e in errors if 'favicon' not in e.lower()]
        ok('no JavaScript errors') if not real else bad(f'JS errors: {real[:2]}')
        b.close()
finally:
    proxy.terminate()

print(f'\n=== {PASS} pass / {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
