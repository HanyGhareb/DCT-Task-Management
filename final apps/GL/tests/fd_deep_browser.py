"""Deep local fault-injection tests over the real GL UI; never writes to production.
All ORDS calls are intercepted. FD_DEEP_SOURCE selects local (default) or live assets.
"""
import copy,json,os,sys
from pathlib import Path
# Bound the entire test, including evaluate()/browser shutdown calls that can
# hang beyond Playwright's action timeout. The child owns a private process
# group so cleanup never targets another test or a saved Fusion browser.
if __name__ == '__main__' and '--bounded-child' not in sys.argv:
 import signal,subprocess,time
 timeout=int(os.environ.get('FD_DEEP_TIMEOUT_SECONDS','300'))
 if timeout <= 0: raise SystemExit('FD_DEEP_TIMEOUT_SECONDS must be positive')
 child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),'--bounded-child'],start_new_session=True)
 def interrupted(signum,frame):
  raise SystemExit(128+signum)
 signal.signal(signal.SIGTERM,interrupted)
 try:
  try: code=child.wait(timeout=timeout)
  except subprocess.TimeoutExpired:
   print(f'FAIL: test exceeded {timeout}s; terminating test browser group',file=sys.stderr,flush=True)
   code=124
 finally:
  try: os.killpg(child.pid,signal.SIGTERM)
  except ProcessLookupError: pass
  deadline=time.monotonic()+5
  while time.monotonic()<deadline:
   child.poll()
   try: os.killpg(child.pid,0)
   except ProcessLookupError: break
   time.sleep(0.1)
  try: os.killpg(child.pid,signal.SIGKILL)
  except ProcessLookupError: pass
  child.wait()
 raise SystemExit(code)
from playwright.sync_api import sync_playwright
ROOT=Path(__file__).resolve().parents[3]
OUT=Path(os.environ.get('FD_DEEP_OUT','/tmp/fd-deep/edge-before'));OUT.mkdir(parents=True,exist_ok=True)
DATA=json.loads((ROOT/'final apps/GL/UAT/UAT_GL_round4-06-09-2026/evidence_06-Sep-2026-01/baseline-reports/dashboard_cube.json').read_text())
PERIOD=DATA['period'];VM='ko.dataFor(document.body)';results=[]
def check(name,ok,detail=None):
 results.append(dict(name=name,passed=bool(ok),detail=detail));print(('PASS ' if ok else 'FAIL ')+name,flush=True)
with sync_playwright() as p:
 b=p.chromium.launch(headless=True);context=b.new_context(viewport={'width':1535,'height':1050},ignore_https_errors=True)
 def open_page(saved=None):
  page=context.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
  def route(r):
   url=r.request.url
   if '/ords/' in url:
    value=DATA if '/fd/status' in url else {'defaultPeriod':PERIOD} if '/actuals/filters' in url else {}
    return r.fulfill(json=value)
   if os.environ.get('FD_DEEP_SOURCE','local')=='local':
    for suffix,typ in [('js/app.js','application/javascript'),('css/app.css','text/css'),('index.html','text/html')]:
     if '/GL/Jet/'+suffix in url:return r.fulfill(path=str(ROOT/'final apps/GL/Jet'/suffix),content_type=typ)
   return r.continue_()
  page.route('**/*',route)
  page.add_init_script('localStorage.clear();localStorage.setItem("ifinance_jet_session",JSON.stringify({sessionId:"fixture",userId:1,username:"TEST",roles:["SYS_ADMIN"],rolesCsv:"SYS_ADMIN"}));localStorage.setItem("gl_lang","en");'+('localStorage.setItem("gl_fd_ui",'+json.dumps(saved)+');' if saved is not None else ''))
  page.goto('https://129.151.159.189/GL/Jet/index.html')
  try:
   page.wait_for_function('window.ko && ko.dataFor(document.body)',timeout=20000)
   page.evaluate(VM+".go('fd')");page.wait_for_function(VM+'.fdLoaded()',timeout=20000)
  except Exception:pass
  return page,errors
 page,errors=open_page('null');check('Saved JSON null does not break dashboard boot',page.evaluate('!!(window.ko && ko.dataFor(document.body))'),errors);page.close()
 page,errors=open_page('{broken');check('Malformed saved JSON recovers',page.evaluate(VM+'.fdLoaded()'),errors);page.close()
 page,errors=open_page();check('Baseline fixture opens',not errors,errors)
 # Exact browser-accessible labels and keyboard operation, rather than mere visual labels.
 for i,name in [(0,'Budget Year'),(1,'Accounting Period'),(2,'Figures in')]:
  el=page.locator('#pg-fd select.inp').nth(i)
  check(name+' has an accessible label',el.evaluate("e=>!!(e.getAttribute('aria-label')||e.getAttribute('aria-labelledby')||(e.labels&&e.labels.length))"))
 header=page.locator('#pg-fd .bu-sec-h').first
 check('Search collapse can be reached by keyboard',header.evaluate("e=>e.tabIndex>=0 || e.tagName==='BUTTON'"))
 header.focus();header.press('Enter')
 check('Enter collapses Search',not page.evaluate(VM+'.fdSecSearchOpen()'))
 header.press('Space');check('Space expands Search',page.evaluate(VM+'.fdSecSearchOpen()'))
 # Screen-reader selection state on Entity controls.
 check('Entity buttons expose selected state',page.locator('#pg-fd .fd-seg button').first.get_attribute('aria-pressed')=='true')
 check('Hover instructions hidden while summaries disabled',not page.locator('#pg-fd [data-bind*="fdTrCardHint"]').first.is_visible())
 # Stale errors must not disable a cached valid period forever.
 page.evaluate(VM+".fdError('Injected failed request')")
 alternative=next(x for x in DATA['periods'] if x!=PERIOD)
 page.evaluate('(p)=>'+VM+'.fdPeriod(p)',alternative)
 check('Returning to cached valid period clears load error',page.evaluate(VM+".fdError()===''"))
 # Export sorting and all layouts; both language directions at phone widths.
 for lang in ('en','ar'):
  page.evaluate('(l)=>'+VM+'.lang(l)',lang)
  for layout in ('tiles','rows','map'):
   page.evaluate('(l)=>'+VM+'.fdLayout(l)',layout)
   for width in (1535,768,390):
    page.set_viewport_size({'width':width,'height':1050});page.wait_for_timeout(100)
    overflow=page.locator('#pg-fd').evaluate('(el)=>({width:el.clientWidth,scroll:el.scrollWidth})')
    check(f'{lang} {layout} dashboard fits {width}px',overflow['scroll']<=overflow['width']+1,overflow)
 page.close()
 # Freeze browser fetch promises to resolve responses out of order deterministically.
 page,errors=open_page()
 page.evaluate("""()=>{window.realFetch=window.fetch;window.fdPending=[];window.fetch=(url,opts)=>String(url).includes('/fd/status')?new Promise((resolve,reject)=>fdPending.push({url,resolve,reject})):realFetch(url,opts)}""")
 page.evaluate('()=>{'+VM+'.runFd();'+VM+'.runFd();}')
 page.wait_for_function('fdPending.length===2')
 newer=copy.deepcopy(DATA);newer['testMarker']='newer'
 older=copy.deepcopy(DATA);older['testMarker']='older'
 page.evaluate('(d)=>fdPending[1].resolve(new Response(JSON.stringify(d),{status:200}))',newer)
 page.wait_for_function(VM+'.fdData().testMarker==="newer"')
 page.evaluate('(d)=>fdPending[0].resolve(new Response(JSON.stringify(d),{status:200}))',older);page.wait_for_timeout(100)
 check('Late earlier response cannot replace newer search result',page.evaluate(VM+'.fdData().testMarker')=='newer')
 page.evaluate('()=>{'+VM+'.runFd();'+VM+'.runFd();}');page.wait_for_function('fdPending.length===4')
 page.evaluate('(d)=>fdPending[3].resolve(new Response(JSON.stringify(d),{status:200}))',newer)
 page.wait_for_function('!'+VM+'.fdBusy()')
 page.evaluate('fdPending[2].reject(new Error("stale network failure"))');page.wait_for_timeout(100)
 check('Stale failed request cannot disable a newer successful result',page.evaluate(VM+".fdError()===''"))
 # Switching back to a cached period invalidates a pending fetch too.
 page.evaluate('()=>{'+VM+'.runFd();}')
 page.wait_for_function('fdPending.length===5')
 page.evaluate('(p)=>'+VM+'.fdPeriod(p)',alternative)
 page.evaluate('(d)=>fdPending[4].resolve(new Response(JSON.stringify(d),{status:200}))',older);page.wait_for_timeout(100)
 check('Cached period switch ignores a pending stale response',page.evaluate(VM+'.fdData().testMarker')=='newer' and not page.evaluate(VM+'.fdBusy()'))
 page.close()
 # Zero-budget-only activity: must not disappear from the selected presentation.
 page,errors=open_page();zero=copy.deepcopy(DATA)
 for r in zero['rows']:r['budget']=0;r['fundsAvailable']=-r['actual']-r['encumbrance']
 page.evaluate('(d)=>'+VM+'.fdData(d)',zero);page.evaluate(VM+".fdLayout('map')");page.wait_for_timeout(150)
 check('Unbudgeted active sectors exist in the data',page.evaluate(VM+'.fdSectors().length')>0)
 check('Zero-budget activity uses approved Ledger fallback',page.locator('#pg-fd .fd-lg-row').count()>0 and page.locator('#pg-fd [data-bind*=fdNoBudgetNotice]').first.is_visible())
 for kind in ['data-sector','data-cc']:
  target=page.locator('#pg-fd .fd-lg-row['+kind+']').first
  page.evaluate(VM+'.fdShowSummary(false)');target.hover()
  check('Zero-budget '+kind+' summary hidden unchecked',not page.evaluate(VM+'.fdTrShow()'))
  page.evaluate(VM+'.fdShowSummary(true)');page.mouse.move(0,0);target.hover()
  check('Zero-budget '+kind+' summary shown checked',page.evaluate(VM+'.fdTrShow()'))
 page.evaluate(VM+'.fdShowSummary(false)')
 page.screenshot(path=str(OUT/'zero-budget-map.png'),full_page=True);page.close()
 page,errors=open_page('{"search":false}')
 custom=copy.deepcopy(DATA);custom['entities'].append(dict(code='TEST_ENTITY',name='Example Entity',nameAr='جهة تجريبية'))
 page.evaluate('(d)=>'+VM+'.fdData(d)',custom);page.evaluate(VM+".fdEntity('TEST_ENTITY')")
 check('Collapsed Search uses configured entity name', 'Example Entity' in page.evaluate(VM+'.fdSearchSummary()'))
 page.close()
 b.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2));print(f"{sum(r['passed'] for r in results)}/{len(results)} passed")
raise SystemExit(0 if all(r['passed'] for r in results) else 1)
