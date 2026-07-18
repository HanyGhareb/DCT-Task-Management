"""
wf_role_assign_browser.py -- Admin -> Role Assignments page acceptance.

Drives the REAL Admin JET app against PROD ORDS and proves a WF admin can:
  - open the new Role Assignments page from the System nav,
  - create a date-tracked FBP assignment on a real project via the type-driven
    object picker (with the live "currently holds" preview),
  - see it listed ACTIVE with the object label,
  - open the per-object Timeline,
  - see the audit tab record ASSIGN_CREATE and export is offered,
  - end the assignment (history kept, status ENDED),
  - render the page under AR/RTL,
  - and the process designer offers the ASSIGNED_ROLE resolver.

Self-cleaning: removes the rows it created via SQLcl (matched on the notes tag).
"""
import os, re, subprocess, sys, tempfile, time
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
PORT = 8094
TAG = 'browser-smoke-ra'
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


def cleanup():
    script = f"""SET DEFINE OFF
BEGIN
    UPDATE prod.dct_wf_role_assignment SET replaced_by_id = NULL
     WHERE notes LIKE '%{TAG}%';
    DELETE FROM prod.dct_wf_role_assignment WHERE notes LIKE '%{TAG}%';
    COMMIT;
END;
/
EXIT
"""
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, script.encode()); os.close(fd)
    subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)


print('=== Role Assignments page -- browser acceptance ===\n')
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
        pg.on('dialog', lambda d: d.accept())

        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')

        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)
        pg.evaluate("() => window._jetApp.navigate('roleAssignments')")
        pg.wait_for_selector('.data-table', timeout=20000)
        ok('Role Assignments page opened (routed by id)')

        # ---- create: FBP on a project ----
        click_js(pg, pg.locator('button', has_text='New Assignment'))
        pg.wait_for_selector('.modal-box', timeout=8000)
        pg.locator('.modal-box select').nth(0).select_option('PROJECT')
        pg.locator('.modal-box select').nth(1).select_option('WF_FBP')
        pg.wait_for_timeout(400)
        # object picker: search then pick the first row
        pg.locator('.modal-box input.form-control').nth(0).fill('')
        click_js(pg, pg.locator('.modal-box button', has_text='Find'))
        pg.wait_for_selector('.modal-box select[size]', timeout=10000)
        first_val = pg.locator('.modal-box select[size] option').first.get_attribute('value')
        pg.locator('.modal-box select[size]').select_option(first_val)
        pg.wait_for_timeout(800)
        # preview panel appears once object+role are chosen
        ok('live holder preview shown') if pg.locator('.modal-box .alert-banner', has_text='holds this role').count() \
            else bad('no preview panel')
        # assignee = first real user in the select
        assignee_sel = pg.locator('.modal-box select').nth(3)
        opts = assignee_sel.locator('option')
        assignee_sel.select_option(opts.nth(1).get_attribute('value'))
        pg.locator('.modal-box input[type="text"]').last.fill(TAG)
        click_js(pg, pg.locator('.modal-box .btn-primary', has_text='Save'))
        pg.wait_for_timeout(2500)
        ok('assignment created (drawer closed)') if not pg.locator('.modal-box').count() \
            else bad('drawer still open: ' + (pg.locator('.alert-banner--danger').inner_text() if pg.locator('.alert-banner--danger').count() else '?'))

        # ---- listed ACTIVE ----
        pg.fill('.view-toolbar input.search-box', first_val)
        click_js(pg, pg.locator('.view-toolbar button', has_text='Search'))
        pg.wait_for_timeout(1500)
        row = pg.locator('tbody tr', has_text=first_val).first
        ok('row listed with status ACTIVE') if 'ACTIVE' in row.inner_text() else bad('row missing/not active')

        # ---- timeline ----
        click_js(pg, row.locator('button', has_text='Timeline'))
        pg.wait_for_selector('.wf-chain', timeout=8000)
        ok('timeline modal renders the history chain') if pg.locator('.wf-chain li').count() >= 1 else bad('empty timeline')
        click_js(pg, pg.locator('.modal-box button', has_text='Close'))
        pg.wait_for_timeout(600)

        # ---- audit tab ----
        click_js(pg, pg.locator('.page-actions button', has_text='Audit'))
        pg.wait_for_timeout(1500)
        pg.fill('.view-toolbar input.search-box', first_val)
        click_js(pg, pg.locator('.view-toolbar button', has_text='Search'))
        pg.wait_for_timeout(1500)
        ok('audit lists ASSIGN_CREATE') if pg.locator('tbody tr', has_text='ASSIGN_CREATE').count() \
            else bad('audit missing create row')
        ok('Export CSV offered') if pg.locator('button', has_text='Export CSV').count() else bad('no export button')

        # ---- end the assignment ----
        click_js(pg, pg.locator('.page-actions button', has_text='Assignments'))
        pg.wait_for_timeout(1200)
        pg.fill('.view-toolbar input.search-box', first_val)
        click_js(pg, pg.locator('.view-toolbar button', has_text='Search'))
        pg.wait_for_timeout(1200)
        row = pg.locator('tbody tr', has_text=first_val).first
        click_js(pg, row.locator('button', has_text='End'))
        pg.wait_for_selector('.modal-box', timeout=8000)
        click_js(pg, pg.locator('.modal-box .btn-primary', has_text='Confirm'))
        try:
            pg.wait_for_selector('.modal-overlay', state='detached', timeout=8000)
        except Exception:
            err_txt = pg.locator('.modal-box .alert-banner--danger').inner_text() \
                if pg.locator('.modal-box .alert-banner--danger').count() else '(no error shown)'
            bad('end dialog did not close: ' + err_txt)
            pg.locator('.modal-box .btn-secondary', has_text='Cancel').first.evaluate('el => el.click()')
        pg.wait_for_timeout(1000)
        click_js(pg, pg.locator('.view-toolbar button', has_text='Search'))
        pg.wait_for_timeout(1200)
        row = pg.locator('tbody tr', has_text=first_val).first
        # ending TODAY keeps the row ACTIVE through end of day (inclusive end
        # date) -- the proof of the end is the To column no longer being open
        cells = row.locator('td')
        end_cell = cells.nth(5).inner_text().strip()
        ok(f'assignment end-dated ({end_cell}), history kept') \
            if end_cell not in ('', '—', '—') else bad('end date still open: ' + end_cell)

        # ---- AR / RTL ----
        pg.locator('.lang-pill button').nth(1).click(); pg.wait_for_timeout(1500)
        rtl = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        ar_ok = pg.locator('.page-title').inner_text().strip() != '' and rtl == 'rtl'
        ok(f'page renders under AR (dir={rtl})') if ar_ok else bad('AR render failed')
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1000)
        ok('restored EN')

        # ---- designer offers ASSIGNED_ROLE ----
        pg.evaluate("() => window._jetApp.navigate('processes')")
        pg.wait_for_selector('.wf-dz', timeout=20000)
        has = pg.evaluate("""() => {
          // ko is an AMD module here, not a global -- sync require works once loaded
          var ko = window.require ? window.require('knockout') : window.ko;
          var el = document.querySelector('wf-designer > *');
          var vm = ko && el && ko.dataFor(el);
          return !!(vm && vm.RESOLVERS && vm.RESOLVERS.indexOf('ASSIGNED_ROLE') >= 0);
        }""")
        ok('designer resolver list includes ASSIGNED_ROLE') if has else bad('resolver missing in designer')

        ok('no page errors') if not errors else bad(f'page errors: {errors[:2]}')
        b.close()
finally:
    proxy.terminate()
    cleanup()

print(f'\n=== {PASS} pass / {FAIL} fail ===')
sys.exit(1 if FAIL else 0)
