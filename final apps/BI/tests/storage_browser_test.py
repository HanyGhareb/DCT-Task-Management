"""Storage panel browser tests with isolated synthetic API responses."""
import copy,json,os
from pathlib import Path
from playwright.sync_api import sync_playwright
ROOT=Path(__file__).resolve().parents[3];OUT=Path(os.environ.get('BI_STORAGE_EVIDENCE','/tmp/rpt-storage-impl/browser'));OUT.mkdir(parents=True,exist_ok=True)
fixture=dict(asOf='2026-09-06 04:00 PM',retentionDays=90,fileCount=328,fileBytes=210176573,allocatedBytes=244000000,expiredCount=4,expiredBytes=1048576,added7DaysBytes=120000,added30DaysBytes=250000,reports=[dict(reportCode='GL_BUDGET_STATUS',name='Budget Status',nameAr='حالة الموازنة',fileCount=30,fileBytes=18000000,oldestAt='2026-09-01')],cleanup=[dict(cleanupId=1,startedAt='2026-09-06 03:00 PM',finishedAt='2026-09-06 03:00 PM',status='SUCCESS',retentionDays=90,filesDeleted=2,bytesDeleted=1048576,durationSeconds=1,error='')])
results=[]
def check(name,ok):
 results.append([name,bool(ok)]);print(('PASS ' if ok else 'FAIL ')+name,flush=True)
with sync_playwright() as pw:
 browser=pw.chromium.launch(headless=True);ctx=browser.new_context(ignore_https_errors=True,viewport=dict(width=1535,height=1100));page=ctx.new_page();errors=[];calls=[];mode='normal'
 page.on('pageerror',lambda e:errors.append(str(e)))
 def route(r):
  url=r.request.url
  if '/ords/' in url:
   if '/rpt/storage' in url:
    calls.append(url)
    if mode=='error':return r.fulfill(status=500,json={'error':'Injected service failure'})
    return r.fulfill(json=fixture)
   return r.fulfill(json=dict(workers=[],jobs=[],queue={}) if '/rpt/workers/' in url else {})
  if os.environ.get('BI_STORAGE_SOURCE','local')=='local' and '/BI/Jet/' in url:
   asset=url.split('/BI/Jet/',1)[1].split('?',1)[0]
   path=ROOT/'final apps/BI/Jet'/asset
   if path.is_file():return r.fulfill(path=str(path))
  r.continue_()
 page.route('**/*',route)
 page.add_init_script('localStorage.clear();localStorage.setItem("ifinance_jet_session",JSON.stringify({sessionId:"fixture",userId:1,username:"TEST",roles:["SYS_ADMIN"],rolesCsv:"SYS_ADMIN",displayName:"Storage Test"}));')
 page.goto('https://129.151.159.189/BI/Jet/index.html#workers');page.wait_for_selector('.rpt-storage .rpt-storage-kpis',timeout=60000)
 check('Storage figures render',page.locator('.rpt-storage').inner_text().find('200.44 MB')>=0)
 check('Retention displayed', '90' in page.locator('.rpt-storage-kpis').inner_text())
 check('Largest reports displayed','Budget Status' in page.locator('.rpt-storage').inner_text())
 check('Audit has exact removed size','1 MB' in page.locator('.rpt-storage').inner_text())
 initial=len(calls);page.wait_for_timeout(10500);check('Worker polling does not repeatedly scan storage',len(calls)==initial)
 page.locator('.rpt-storage button').click();page.wait_for_timeout(300);check('Manual refresh reloads storage',len(calls)==initial+1)
 for lang in ['en','ar']:
  page.evaluate('(lang)=>new Promise(resolve=>require(["shared/i18n"],i=>{i.setLang(lang);resolve();}))',lang);page.wait_for_timeout(300)
  check(lang+' no untranslated storage keys','storage.' not in page.locator('.rpt-storage').inner_text())
  for width in [1535,768,390]:
   page.set_viewport_size(dict(width=width,height=1100));page.wait_for_timeout(100)
   check(f'{lang} fits {width}px',page.evaluate('document.documentElement.scrollWidth <= window.innerWidth+1'))
  page.set_viewport_size(dict(width=1535,height=1100));page.locator('.rpt-storage').screenshot(path=str(OUT/(lang+'.png')))
 mode='error';page.locator('.rpt-storage button').click();page.wait_for_selector('.rpt-storage [role=alert]');check('Failure shown without losing previous data',page.locator('.rpt-storage-kpis').is_visible())
 mode='normal';fixture.update(fileCount=0,fileBytes=0,allocatedBytes=None,retentionDays=0,expiredCount=0,expiredBytes=0,reports=[],cleanup=[])
 page.locator('.rpt-storage button').click();page.wait_for_timeout(300)
 check('Empty reports and audit states',page.locator('.rpt-storage .empty-state').count()==2)
 check('Keep-forever state renders', 'الاحتفاظ بالكل' in page.locator('.rpt-storage').inner_text())
 check('Failed banner clears on retry',page.locator('.rpt-storage [role=alert]').count()==0)
 fixture['cleanup']=[dict(cleanupId=2,startedAt='2026-09-06',finishedAt='',status='FAILED',retentionDays=None,filesDeleted=0,bytesDeleted=0,durationSeconds=None,error='<script>window.injected=1</script>')]
 page.locator('.rpt-storage button').click();page.wait_for_timeout(300)
 check('Failed cleanup visible',page.locator('.rpt-storage .badge--danger').count()==1)
 check('Error text safely escaped',page.evaluate('window.injected===undefined') and '<script>' in page.locator('.rpt-storage-detail').inner_text())
 check('No JavaScript errors',not errors)
 if errors:print(errors)
 browser.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2))
raise SystemExit(0 if all(ok for _,ok in results) else 1)
