"""BI live storage API/UI check, signing in through the built-in Admin UI."""
import json,os
from pathlib import Path
from playwright.sync_api import sync_playwright
ROOT=Path(__file__).resolve().parents[3];OUT=Path(os.environ.get('BI_STORAGE_LIVE_EVIDENCE','/tmp/rpt-storage-impl/live'));OUT.mkdir(parents=True,exist_ok=True)
ORDS='https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
results=[]
def check(name,ok):
 results.append([name,bool(ok)]);print(('PASS ' if ok else 'FAIL ')+name,flush=True)
with sync_playwright() as pw:
 browser=pw.chromium.launch(headless=True);ctx=browser.new_context(ignore_https_errors=True,viewport=dict(width=1535,height=1100));page=ctx.new_page()
 page.goto('https://129.151.159.189/dct/index.html')
 page.locator('.quick-btn').filter(has_text='System Admin').click(timeout=60000)
 page.wait_for_function('!!localStorage.getItem("ifinance_jet_session")',timeout=60000)
 if os.environ.get('BI_STORAGE_LIVE_SOURCE','local')=='local':
  def assets(r):
   asset=r.request.url.split('/BI/Jet/',1)[1].split('?',1)[0];path=ROOT/'final apps/BI/Jet'/asset
   if path.is_file():return r.fulfill(path=str(path))
   r.continue_()
  page.route('**/BI/Jet/**',assets)
 page.goto('https://129.151.159.189/BI/Jet/index.html#workers')
 page.wait_for_selector('.rpt-storage-kpis',timeout=60000)
 check('Storage panel loads real data',page.locator('.rpt-storage [role=alert]').count()==0)
 data=page.evaluate('''async base=>{let s=JSON.parse(localStorage.getItem('ifinance_jet_session'));let r=await fetch(base+'/rpt/storage',{headers:{Authorization:'Bearer '+s.sessionId}});return {status:r.status,body:await r.json()}}''',ORDS)
 check('Authenticated storage API returns 200',data['status']==200)
 d=data['body'];(OUT/'storage.json').write_text(json.dumps(d,indent=2))
 check('Retention remains 90 days',d['retentionDays']==90)
 check('Storage totals are plausible',d['fileCount']>0 and d['fileBytes']>0 and d['allocatedBytes']>=d['fileBytes'])
 check('Cleanup audit is present',len(d['cleanup'])>0 and d['cleanup'][0]['status']=='SUCCESS')
 check('At most 10 largest reports and 20 audits',len(d['reports'])<=10 and len(d['cleanup'])<=20)
 check('File bytes reconcile with all listed reports when fewer than 10',len(d['reports'])==10 or sum(r['fileBytes'] for r in d['reports'])==d['fileBytes'])
 anon=ctx.request.get(ORDS+'/rpt/storage');check('Anonymous storage API blocked',anon.status==401)
 for lang in ['en','ar']:
  page.evaluate('(lang)=>new Promise(resolve=>require(["shared/i18n"],i=>{i.setLang(lang);resolve();}))',lang);page.wait_for_timeout(400)
  page.locator('.rpt-storage').screenshot(path=str(OUT/(lang+'.png')))
  page.locator('.rpt-storage .data-table-wrap').last.screenshot(path=str(OUT/(lang+'-audit.png')))
 check('Existing scheduler controls still list maintenance',page.locator('table').filter(has_text='DCT_RPT_MAINT_JOB').count()>0)
 other=browser.new_context(ignore_https_errors=True);viewer=other.new_page()
 viewer.goto('https://129.151.159.189/dct/index.html')
 viewer.locator('.quick-btn').filter(has_text='Finance Director').click(timeout=60000)
 viewer.wait_for_function('!!localStorage.getItem("ifinance_jet_session")',timeout=60000)
 denied=viewer.evaluate('''async base=>{let s=JSON.parse(localStorage.getItem('ifinance_jet_session'));let r=await fetch(base+'/rpt/storage',{headers:{Authorization:'Bearer '+s.sessionId}});return r.status}''',ORDS)
 check('Non-admin storage API blocked',denied==403)
 other.close();browser.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2))
raise SystemExit(0 if all(ok for _,ok in results) else 1)
