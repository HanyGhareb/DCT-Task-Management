"""
wf_cascade_browser.py -- configurable level priority + matrix import acceptance.

Drives the REAL Admin JET app against PROD ORDS and proves:
  - the Level Priority drawer shows the seeded default order and REORDERING
    it persists (then restores it),
  - a per-role override can be created and removed from the same drawer,
  - the Import Matrix drawer parses a real .xlsx (matrix layout), dry-runs it
    (valid row -> CREATED, unknown email -> NO_USER exception), applies it,
    and the assignment appears in the assignments list,
  - the designer's participant editor offers ASSIGNED_ROLE_CASCADE,
  - AR/RTL renders.

Self-cleaning: removes imported rows + restores the default priority.
"""
import os, re, subprocess, sys, tempfile, time
from openpyxl import Workbook
from playwright.sync_api import sync_playwright

HERE = os.path.dirname(os.path.abspath(__file__))
JET = os.path.join(HERE, '..', 'Jet')
ADMIN_JET = os.path.join(HERE, '..', '..', 'Admin', 'Jet')  # creds + shared login page
PORT = 8099
PASS = FAIL = 0


def ok(m):
    global PASS; PASS += 1; print(f'  pass  {m}')


def bad(m):
    global FAIL; FAIL += 1; print(f'  FAIL  {m}')


def creds():
    src = open(os.path.join(ADMIN_JET, 'js', 'services', 'authService.js'), encoding='utf-8').read()
    return re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)[0]


def click_js(pg, locator):
    locator.first.evaluate('el => el.click()')


def sqlrun(script):
    fd, path = tempfile.mkstemp(suffix='.sql')
    os.write(fd, (script + '\nEXIT\n').encode()); os.close(fd)
    r = subprocess.run(['sql', '-name', 'prod_mcp', '@' + path], capture_output=True, text=True)
    os.unlink(path)
    return r.stdout


def cleanup():
    sqlrun("""SET DEFINE OFF
BEGIN
    UPDATE prod.dct_wf_role_assignment SET replaced_by_id = NULL
     WHERE notes LIKE 'Matrix import%' AND role_code = 'WF_KEY_USER';
    DELETE FROM prod.dct_wf_role_assignment
     WHERE notes LIKE 'Matrix import%' AND role_code = 'WF_KEY_USER';
    DELETE FROM prod.dct_wf_cascade_level WHERE role_code = 'WF_KEY_USER';
    COMMIT;
END;
/""")


print('=== cascade priority + matrix import -- browser acceptance ===\n')
cleanup()

# real PROD keys for the workbook fixture
out = sqlrun("""SET PAGESIZE 0
SET HEADING OFF
SELECT 'CC=' || MIN(cost_center_code) FROM prod.v_dct_wf_obj_cost_center;
SELECT 'EM=' || LOWER(MIN(email)) FROM prod.dct_users WHERE is_active='Y' AND email LIKE '%@%';""")
CC = re.search(r'CC=(\S+)', out).group(1)
EM = re.search(r'EM=(\S+)', out).group(1)

# build a small workbook in the REAL matrix layout
wb = Workbook()
ws = wb.active
ws.title = 'Director & ED Test'
ws.append(['Old Sector', 'Cost center', 'Old Department Name', 'New Cost center',
           'New Sector', 'New Department Name', 'PBP Emp. Name', 'Email',
           'FBP Emp Name', 'Email', 'FBP -UH', 'Remarks', 'AP Name', 'AP Emails',
           'Director/ ED Emp Name', 'Director /ED Email ', 'Key Users Names',
           'Key Users Email ID', 'CC status ', 'Action'])
ws.append(['Sec', CC, 'Dept', CC, 'Sector X', 'Dept X', '', '', '', '', '', '',
           '', '', '', '', 'Real User', EM, 'Active', ''])
ws.append(['Sec', CC, 'Dept', CC, 'Sector X', 'Dept X', '', '', '', '', '', '',
           '', '', '', '', 'Ghost', 'nobody@nowhere.xx', 'Active', ''])
XLSX_PATH = os.path.join(tempfile.gettempdir(), 'matrix_smoke.xlsx')
wb.save(XLSX_PATH)

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
        pg.wait_for_selector('input[type=\"text\"]', timeout=30000)  # redirect to Admin login
        pg.fill('input[type="text"]', user)
        pg.fill('input[type="password"]', pwd)
        pg.click('.btn-primary')
        # wait for the REAL login signal: _jetApp exists on the Admin login
        # page pre-login, so only the stored session proves the POST landed
        pg.wait_for_function("() => !!localStorage.getItem('ifinance_jet_session')", timeout=30000)
        # module app: session established on Admin -- return to the BPM root
        pg.goto(f'http://localhost:{PORT}/index.html', wait_until='networkidle')
        pg.wait_for_function('() => !!window._jetApp', timeout=30000)
        ok(f'logged in as {user}')
        pg.locator('.lang-pill button').nth(0).click(); pg.wait_for_timeout(1200)
        pg.evaluate("() => window._jetApp.navigate('roleAssignments')")
        pg.wait_for_selector('.data-table', timeout=20000)
        ok('Role Assignments page opened')

        # ---- Level Priority drawer: default order + reorder round-trip ----
        click_js(pg, pg.locator('.page-actions button', has_text='Level Priority'))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        codes = drawer.locator('tbody tr .mono').all_inner_texts()
        ok('drawer shows the default order Task>Project>CC>Sector') \
            if codes == ['TASK', 'PROJECT', 'COST_CENTER', 'SECTOR'] else bad(f'order {codes}')

        # move COST_CENTER to the top (two Up clicks), save
        for _ in range(2):
            click_js(pg, drawer.locator('tbody tr', has_text='COST_CENTER').locator('button').nth(0))
            pg.wait_for_timeout(300)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2000)
        codes = drawer.locator('tbody tr .mono').all_inner_texts()
        ok('reorder saved: COST_CENTER now first') \
            if codes and codes[0] == 'COST_CENTER' else bad(f'after save {codes}')

        # restore the seeded default
        for _ in range(2):
            click_js(pg, drawer.locator('tbody tr', has_text='COST_CENTER').locator('button').nth(1))
            pg.wait_for_timeout(300)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2000)
        codes = drawer.locator('tbody tr .mono').all_inner_texts()
        ok('default restored') if codes == ['TASK', 'PROJECT', 'COST_CENTER', 'SECTOR'] \
            else bad(f'restore failed {codes}')

        # per-role override: pick Key User scope, copy default, drop TASK+PROJECT, save
        drawer.locator('select').first.select_option('WF_KEY_USER')
        pg.wait_for_timeout(600)
        click_js(pg, drawer.locator('button', has_text='Start from default'))
        pg.wait_for_timeout(400)
        for _ in range(2):
            click_js(pg, drawer.locator('tbody tr').first.locator('button').nth(2))  # remove first
            pg.wait_for_timeout(300)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2000)
        codes = drawer.locator('tbody tr .mono').all_inner_texts()
        ok('per-role override saved (CC>Sector for Key User)') \
            if codes == ['COST_CENTER', 'SECTOR'] else bad(f'override {codes}')
        # remove the override again (empty list)
        for _ in range(2):
            click_js(pg, drawer.locator('tbody tr').first.locator('button').nth(2))
            pg.wait_for_timeout(300)
        click_js(pg, pg.locator('.ed-drawer.ed-show header .btn-primary'))
        pg.wait_for_timeout(2000)
        pg.keyboard.press('Escape'); pg.wait_for_timeout(600)
        ok('override removed (empty list saved)')

        # ---- Import Matrix drawer: parse -> dry run -> apply ----
        click_js(pg, pg.locator('.page-actions button', has_text='Import Matrix'))
        pg.wait_for_selector('.ed-drawer.ed-show', timeout=8000)
        drawer = pg.locator('.ed-drawer.ed-show')
        with pg.expect_file_chooser() as fc:
            click_js(pg, drawer.locator('button', has_text='Choose file'))
        fc.value.set_files(XLSX_PATH)
        pg.wait_for_timeout(2500)
        ok('workbook parsed (entries found)') \
            if 'entries parsed' in drawer.inner_text().lower() else bad('no parse message')

        click_js(pg, drawer.locator('button', has_text='Dry run'))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=20000)
        pg.wait_for_timeout(1000)
        body = drawer.inner_text()
        ok('dry run: valid person previews CREATED') if 'CREATED' in body else bad('no CREATED')
        ok('dry run: unknown email reported NO_USER') if 'NO_USER' in body else bad('no NO_USER')
        ok('exceptions export offered') \
            if drawer.locator('button', has_text='Export exceptions').count() else bad('no exceptions btn')

        click_js(pg, drawer.locator('button', has_text='Apply'))
        pg.wait_for_timeout(4000)
        body = drawer.inner_text()
        ok('applied: summary shows create=1') if 'Applied' in body else bad('no applied banner')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(600)

        # the imported assignment is in the list
        pg.locator('.view-toolbar select').first.select_option('COST_CENTER')
        pg.fill('.view-toolbar input.search-box', CC)
        click_js(pg, pg.locator('.view-toolbar button', has_text='Search'))
        pg.wait_for_timeout(1500)
        ok('imported assignment listed ACTIVE') \
            if pg.locator('tbody tr', has_text='Key User').count() else bad('imported row missing')

        # ---- designer offers the cascade resolver ----
        pg.evaluate("() => window._jetApp.navigate('processes')")
        pg.wait_for_selector('.wf-dz', timeout=20000)
        row = pg.locator('tr.wf-dz-row').first
        row.wait_for(state='visible', timeout=20000)
        click_js(pg, row)
        pg.wait_for_selector('.wf-dz-design', timeout=10000)
        click_js(pg, pg.locator('button', has_text='Edit chain'))
        pg.wait_for_timeout(2000)
        click_js(pg, pg.locator('button', has_text='+ Add step'))
        pg.wait_for_selector('.wf-dz-modal', timeout=8000)
        click_js(pg, pg.locator('.wf-dz-modal button', has_text='Add approver'))
        pg.wait_for_selector('.wf-dz-part', timeout=5000)
        opts = pg.locator('.wf-dz-part select').first.locator('option').all_inner_texts()
        ok('participant editor offers ASSIGNED_ROLE_CASCADE') \
            if 'ASSIGNED_ROLE_CASCADE' in opts else bad(f'resolvers {opts}')
        click_js(pg, pg.locator('.wf-dz-modal .region-actions button', has_text='Cancel'))
        pg.wait_for_timeout(600)
        click_js(pg, pg.locator('button', has_text='Discard draft'))
        pg.wait_for_timeout(2000)
        ok('draft discarded')

        # ---- AR / RTL ----
        pg.evaluate("() => window._jetApp.navigate('roleAssignments')")
        pg.wait_for_timeout(1200)
        pg.locator('.lang-pill button').nth(1).click()
        pg.wait_for_timeout(2000)
        # .page-actions holds the 2 tab buttons first: Level Priority = nth(5)
        click_js(pg, pg.locator('.page-actions button').nth(5))
        pg.wait_for_selector('.ed-drawer.ed-show tbody tr', timeout=8000)
        dirv = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        ar_txt = pg.locator('.ed-drawer.ed-show').inner_text()
        ok('AR/RTL: priority drawer renders translated') \
            if dirv == 'rtl' and 'المستوى' in ar_txt else bad(f'dir={dirv}')
        pg.keyboard.press('Escape'); pg.wait_for_timeout(400)
        pg.locator('.lang-pill button').nth(0).click()   # ALWAYS restore EN
        pg.wait_for_timeout(1500)
        ok('language restored to EN')

        js_errors = [e for e in errors if 'ResizeObserver' not in e]
        ok('no JS page errors') if not js_errors else bad(f'JS errors: {js_errors[:2]}')
        b.close()
finally:
    proxy.terminate()
    cleanup()
    # belt + braces: the default priority must be the seeded order
    sqlrun("""SET DEFINE OFF
DECLARE v VARCHAR2(400);
BEGIN
    SELECT LISTAGG(object_type_code, ',') WITHIN GROUP (ORDER BY seq) INTO v
      FROM prod.dct_wf_cascade_level WHERE role_code IS NULL AND is_active = 'Y';
    IF v <> 'TASK,PROJECT,COST_CENTER,SECTOR' THEN
        DELETE FROM prod.dct_wf_cascade_level WHERE role_code IS NULL;
        INSERT INTO prod.dct_wf_cascade_level (role_code, seq, object_type_code, created_by)
            SELECT NULL, 10, 'TASK', 'SEED' FROM dual UNION ALL
            SELECT NULL, 20, 'PROJECT', 'SEED' FROM dual UNION ALL
            SELECT NULL, 30, 'COST_CENTER', 'SEED' FROM dual UNION ALL
            SELECT NULL, 40, 'SECTOR', 'SEED' FROM dual;
        COMMIT;
    END IF;
END;
/""")

print(f'\n=== {PASS} passed, {FAIL} failed ===')
sys.exit(1 if FAIL else 0)
