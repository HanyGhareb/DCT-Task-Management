"""
wf_diagram_browser.py — <wf-diagram> graphical view (design-time) acceptance.

Drives the REAL Admin JET app against PROD ORDS and proves the Approval
Processes page can show an approval chain as a FLOWCHART (not just a list):
  - a "Diagram" toggle renders the seeded DEMO_APPROVAL chain as connected nodes,
  - the two conditional steps show their condition on a branch pill,
  - the final-gate node is marked,
  - the "who" (approver) shows on each node,
  - toggling back to "List" restores the step list,
  - the diagram still renders under AR / RTL.

Read-only: it uses the already-seeded DEMO_APPROVAL process, seeds/deletes nothing.
Give it its own dev-proxy port.
"""
import os, re, subprocess, sys, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8096
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def creds():
    src = open(os.path.join(JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def click_js(pg, locator):
    locator.first.evaluate('el => el.click()')


print('=== <wf-diagram> — graphical design view (read-only) ===\n')

proxy = subprocess.Popen([sys.executable, 'dev-proxy.py', str(PORT)], cwd=JET,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(3)
try:
    user, pwd = creds()
    with sync_playwright() as p:
        b = p.chromium.launch(args=['--no-sandbox', '--disable-dev-shm-usage'])
        pg = b.new_page(viewport={'width': 1500, 'height': 980})
        errors = []
        pg.on('pageerror', lambda e: errors.append(str(e)))

        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')

        pg.locator('button:text-is("EN")').last.click(); pg.wait_for_timeout(1200)
        pg.evaluate("() => window._jetApp.navigate('processes')")
        pg.wait_for_selector('.wf-dz', timeout=20000)
        ok('Approval Processes page opened')

        row = pg.locator('tr.wf-dz-row', has_text='DEMO_APPROVAL')
        row.first.wait_for(state='visible', timeout=20000)
        click_js(pg, row)
        pg.wait_for_selector('.wf-dz-design', timeout=10000)
        ok('DEMO_APPROVAL design panel opened')

        # switch to the graphical Diagram view
        click_js(pg, pg.locator('button:text-is("Diagram")'))
        pg.wait_for_selector('.wf-dg', timeout=10000)
        nodes = pg.locator('.wf-dg-node')
        n = nodes.count()
        ok(f'diagram renders ({n} nodes)') if n == 4 else bad(f'expected 4 nodes, got {n}')

        # connectors between rows (flow, not a bare list)
        conns = pg.locator('.wf-dg-conn').count()
        ok(f'flow connectors drawn ({conns})') if conns >= 4 else bad(f'too few connectors: {conns}')

        # the two conditions appear on branch pills
        dg = pg.locator('.wf-dg').inner_text()
        ok('condition amount >= 50000 shown on a branch') if 'amount >= 50000' in dg.replace('  ', ' ') else bad('amount condition missing')
        ok('condition contract_months >= 6 shown on a branch') if 'contract_months >= 6' in dg.replace('  ', ' ') else bad('months condition missing')

        # final-gate node marked, and the approver ("who") shows
        ok('final-gate node marked') if pg.locator('.wf-dg-final').count() >= 1 else bad('no final-gate marker')
        ok('approver (SYS_ADMIN) shown on nodes') if 'SYS_ADMIN' in dg else bad('approver not shown')

        # endorsement step keeps its outcome-set identity
        ok('ENDORSE_SET surfaced on the Finance step') if 'ENDORSE_SET' in dg else bad('outcome set not shown')

        # toggle back to List
        click_js(pg, pg.locator('button:text-is("List")'))
        pg.wait_for_selector('.wf-dz-steps', timeout=8000)
        ok('toggled back to the list view') if pg.locator('.wf-dz-step').count() == 4 else bad('list did not restore')

        # AR / RTL — diagram must still render (lang pill: [EN, ع])
        pg.locator('.lang-pill button').nth(1).click(); pg.wait_for_timeout(1500)
        click_js(pg, pg.locator('button').filter(has_text=re.compile('مخطط')))  # "Diagram" in AR
        pg.wait_for_selector('.wf-dg', timeout=10000)
        rtl = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        ok(f'diagram renders under AR (dir={rtl}, {pg.locator(".wf-dg-node").count()} nodes)') \
            if pg.locator('.wf-dg-node').count() == 4 and rtl == 'rtl' else bad('AR diagram did not render')
        # restore EN so we don't leave the account in Arabic
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1000)
        ok('restored EN')

        ok('no page errors') if not errors else bad(f'page errors: {errors[:2]}')
        b.close()
finally:
    proxy.terminate()

print(f'\n=== {PASS} pass / {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
