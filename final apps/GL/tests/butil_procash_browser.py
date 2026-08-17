"""Budget Utilization - the Include Procash toggle on the GL page (App 210).

Drives the real page against a dev-proxy (python3 dev-proxy.py 8137 in GL/Jet):
the control renders, the figure reaches the page, ticking it reduces Fund
Available by exactly the procash and adds it to Actual, and the label flips.

Gotchas honoured: the year select BLANKS a value that is not in its loaded list,
so the suite waits for buYears() before setting it, and it clears the page's
default business unit and period which would filter the fixture line out.

Auth: IFINANCE_TOKEN=<session id>.
Run: IFINANCE_TOKEN=... python3 butil_procash_browser.py
"""
import json,os,sys,time,urllib.request,urllib.error
from playwright.sync_api import sync_playwright
B='https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TOK=os.environ['IFINANCE_TOKEN']; TAG='GLB-PCH-'+time.strftime('%Y%m%d%H%M%S')
PROJ,TASK,ET='4517000039','4510747','491811 - Heritage culture assts'
def call(p,m='GET',b=None):
    d=json.dumps(b).encode() if b is not None else None
    r=urllib.request.Request(B+p,data=d,method=m); r.add_header('Authorization','Bearer '+TOK)
    if d: r.add_header('Content-Type','application/json')
    try:
        x=urllib.request.urlopen(r,timeout=240); return x.status,json.loads(x.read() or b'null')
    except urllib.error.HTTPError as e: return e.code,None
res=[]
def check(n,c,d=''):
    res.append((n,bool(c))); print(('  PASS  ' if c else '  FAIL  ')+n+(('   -> '+str(d)) if d and not c else ''))
_,lovs=call('/ap/procash/meta/lovs')
c,made=call('/ap/procash','POST',{'bankReference':TAG,'businessUnit':lovs['businessUnits'][0],
  'payeeName':'GL page check','amount':2500,'currencyCode':'AED','paymentDate':'2026-08-18'})
check('the sample procash transaction is created', c==200 and made and made.get('procashId'), (c, made))
pid=made['procashId']
c,ln=call('/ap/procash/%s/lines'%pid,'POST',{'codingBasis':'PROJECT','projectNumber':PROJ,'taskNumber':TASK,
  'expenditureType':ET,'amount':2500})
check('the sample line is coded to the budget line', c==200, (c, ln))
c,api_chk=call('/gl/butil?year=2026&limit=50&project=%s&task=%s'%(PROJ,TASK))
check('the API already reports it before the page loads',
      (api_chk or {}).get('totals',{}).get('procash')==2500, (api_chk or {}).get('totals',{}).get('procash'))
sess={'sessionId':TOK,'userId':1,'username':'ADMIN','displayName':'System Administrator','rolesCsv':'SYS_ADMIN'}
sess['roles']=['SYS_ADMIN']
with sync_playwright() as p:
    b=p.chromium.launch(headless=True); ctx=b.new_context(viewport={'width':1700,'height':1050}); pg=ctx.new_page()
    errs=[]; pg.on('pageerror', lambda e: errs.append(str(e)))
    pg.goto('http://localhost:8137/index.html')
    pg.evaluate("s => localStorage.setItem('ifinance_jet_session', JSON.stringify(s))", sess)
    pg.goto('http://localhost:8137/index.html'); pg.wait_for_function("() => !!window.ko", timeout=40000)
    pg.wait_for_timeout(3000)
    pg.evaluate("() => ko.dataFor(document.body).go('butil')"); pg.wait_for_timeout(2500)
    # the year select blanks a value absent from its list, so wait for the list
    pg.wait_for_function("() => (ko.dataFor(document.body).buYears() || []).length > 0", timeout=40000)
    check('the Include Procash control is on the page', pg.locator("text=Select to include Procash").count()>=1)
    # run the report narrowed to the coded line
    pg.evaluate("""(a) => { const vm = ko.dataFor(document.body);
        const y = (vm.buYears() || []).map(String).indexOf('2026') >= 0 ? '2026' : String(vm.buYears()[0]);
        vm.buYear(y); vm.buProjSel([a.p]); vm.buTask(a.t); vm.buTypeSel([]);
        vm.buBuSel([]); vm.buPeriod('');        // the page defaults would filter the line out
        return vm.runButil(0); }""",
        {'p':PROJ,'t':TASK})
    pg.wait_for_timeout(9000)
    tot=pg.evaluate("() => ko.dataFor(document.body).buTotals()")
    pcash=(tot or {}).get('procash') or 0
    check('the page received the procash figure', pcash>=2500, pcash)
    fund_off=tot.get('fundAvailable')
    check('a Procash column is rendered', pg.locator("th:has-text('Procash')").count()>=1)
    pg.screenshot(path='/tmp/gl_procash_off.png', full_page=False)
    pg.evaluate("() => ko.dataFor(document.body).toggleBuProcash()"); pg.wait_for_timeout(9000)
    tot2=pg.evaluate("() => ko.dataFor(document.body).buTotals()")
    on=pg.evaluate("() => ko.dataFor(document.body).buProcashOn()")
    act=pg.evaluate("() => ko.dataFor(document.body).buActualTot()")
    check('the toggle is reflected back from the server', on is True, on)
    check('Fund Available drops by the procash', abs(tot2['fundAvailable']-(fund_off-pcash))<0.005,
          (fund_off, tot2['fundAvailable'], pcash))
    check('Actual now includes the procash',
          abs(act-((tot2['actualAp'] or 0)+(tot2['actualGrn'] or 0)+pcash))<0.005, (act, pcash))
    check('the label switches to "included"', pg.locator("text=Procash included").count()>=1)
    pg.screenshot(path='/tmp/gl_procash_on.png', full_page=False)
    check('no JavaScript errors', len(errs)==0, errs[:2])
    b.close()
call('/ap/procash/%s/cancel'%pid,'POST',{})
ok=sum(1 for _,k in res if k); print('\n=== %d passed, %d failed ==='%(ok,len(res)-ok))
sys.exit(0 if ok==len(res) else 1)
