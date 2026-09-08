"""Offline Budget Status review: real local UI with intercepted API fixtures.

No production calls or deployment. Requires GL dev-proxy on 8224. Generates
screenshots and genuine PDF/PPTX samples, checks downloads and failure recovery.
"""
import json
import os
from pathlib import Path
import sys
import importlib.util
from playwright.sync_api import sync_playwright

HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fd_report_test',HERE/'fd_report_test.py')
fixtures=importlib.util.module_from_spec(spec);spec.loader.exec_module(fixtures)
import render_fd,render_pdf,render_pptx
OUT=Path(os.environ.get('FD_REVIEW_OUT','/tmp/fd-review'));OUT.mkdir(parents=True,exist_ok=True)
BASE=os.environ.get('GL_BASE','http://localhost:8224')
results=[]
def check(name,ok):
    results.append((name,bool(ok)));print(('PASS ' if ok else 'FAIL ')+name,flush=True)
    evidence=OUT/f'case_{len(results):02}.png'
    if globals().get('page') is not None:
        page.screenshot(path=str(evidence))
    elif (OUT/'Budget_Status_sample.pdf').exists():
        import fitz
        doc=fitz.open(OUT/'Budget_Status_sample.pdf')
        doc[0].get_pixmap().save(evidence);doc.close()

ctx=fixtures.fixture()
for layout in ('tiles','rows','map'):
    ctx['params']['presentation']=layout
    (OUT/f'budget-status-{layout}.html').write_text(render_pdf.render_html(ctx,'gl_budget_status.html.j2'))
ctx['params']['presentation']='tiles'
pdf=render_pdf.build_pdf(ctx,'gl_budget_status.html.j2');(OUT/'Budget_Status_sample.pdf').write_bytes(pdf)
ppt=render_pptx.build_deck(ctx['sections'],ctx);(OUT/'Budget_Status_sample.pptx').write_bytes(ppt)
from pptx import Presentation
from io import BytesIO
check('PDF generated',pdf.startswith(b'%PDF'))
check('PowerPoint includes all report pages',len(Presentation(BytesIO(ppt)).slides)==len(render_fd.prepare(ctx)['fd']['pages']))
raw=ctx['sections'][0]['data']
rows=[dict(sector=r['sector'],sectorName=r['sector_name'],costCenter=r['department'],costCenterName=r['department_name'],entity='DCT',chapter=r['chapter'],budget=r['budget'],actual=r['actual'],encumbrance=r['encumbrance'],fundsAvailable=r['funds_available'],combinations=1) for r in raw]
data=dict(period='09-2026',year=2026,rows=rows,periods=['08-2026','09-2026'],
    entities=[dict(code=k,name=k) for k in ['DCT','MUSEUMS','ALC','MASTERPIECES']],
    chapters=[dict(code=f'CH{i}',name=f'Chapter {i}',alt='') for i in range(1,6)],
    sectors=[dict(code=f'S{i}',name=f'Sector {i}') for i in range(3)],
    costCenters=[dict(code=f'D{i:02}',name=f'Department {i:02} — Planning and Executive Services',sector=f'S{i%3}') for i in range(30)],
    series=[dict(s=r['sector'],c=r['costCenter'],e=r['entity'],ch=r['chapter'],m={'08':[r['budget'],r['actual']*.8,r['encumbrance'],r['fundsAvailable']+r['actual']*.2,1],'09':[r['budget'],r['actual'],r['encumbrance'],r['fundsAvailable'],1]}) for r in rows],
    thresholds=dict(near=90,over=100),scope=dict(budgetGroupByChapter='CH1:1|CH2:1|CH3:1|CH4:3|CH5:5'),excluded={})
requests=[];mode={'fail':False,'download_fail':False,'status_fail':False}
with sync_playwright() as pw:
    browser=pw.chromium.launch(headless=True,args=['--no-sandbox'])
    page=browser.new_page(viewport=dict(width=1535,height=1000),ignore_https_errors=True)
    errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
    def route(r):
        url=r.request.url
        if '/ords/' not in url:return r.continue_()
        value={}
        if '/fd/report' in url:
            if r.request.method=='POST':
                requests.append(r.request.post_data_json)
                if mode['fail']:return r.fulfill(status=403,json={'error':'Report permission required'})
                value={'runId':321}
            elif url.endswith('/file'):
                if mode['download_fail']:return r.fulfill(status=500,json={'error':'Download failed'})
                return r.fulfill(body=ppt if requests[-1]['format']=='PPTX' else pdf,content_type='application/octet-stream')
            else:value=dict(status='FAILED',error='Test renderer failure') if mode['status_fail'] else dict(status='SUCCESS',hasFile=True)
        elif '/fd/status' in url:value=data
        elif '/fd/lines' in url:value={'rows':[],'total':0}
        elif '/actuals/filters' in url:value={'defaultPeriod':'09-2026'}
        elif '/boot' in url:value={'dimensions':[]}
        return r.fulfill(json=value)
    page.route('**/*',route)
    page.add_init_script("localStorage.setItem('ifinance_jet_session',JSON.stringify({sessionId:'offline-fixture',userId:1,username:'REVIEW',displayName:'Local Review',roles:['SYS_ADMIN'],rolesCsv:'SYS_ADMIN'}));localStorage.setItem('gl_lang','en');")
    page.goto(BASE+'/index.html')
    page.wait_for_function('window.ko && ko.dataFor(document.body)',timeout=60000)
    page.evaluate("ko.dataFor(document.body).go('fd')")
    page.wait_for_function('ko.dataFor(document.body).fdLoaded()',timeout=30000)
    page.wait_for_timeout(500)
    check('UI loads without JS errors',not errors)
    summary=page.locator('#pg-fd .fd-summary input')
    ring=page.locator('#pg-fd .fd-ring--bud').first
    check('Show Summary starts unchecked',not summary.is_checked())
    ring.hover();page.wait_for_timeout(150)
    check('Unchecked suppresses ring summary',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    summary.check();ring.hover();page.wait_for_timeout(150)
    check('Checked enables ring summary',page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    page.evaluate('ko.dataFor(document.body).fdShowSummary(false)')
    check('Unchecking immediately closes an open summary',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    ring.focus();check('Unchecked suppresses keyboard focus summary',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    ring.click();check('Ring drill remains available',page.evaluate('ko.dataFor(document.body).drillDrawer()'))
    page.evaluate('ko.dataFor(document.body).closeDrawer()')
    page.locator('#pg-fd .fd-card').first.hover();page.wait_for_timeout(100)
    check('Unchecked also suppresses card summaries',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    page.mouse.move(0,0)
    grid=page.locator('#pg-fd .filter-grid').bounding_box();pres=page.locator('#pg-fd .fd-pres-field').bounding_box()
    check('Compact presentation at far right',pres['width']<=301 and abs(pres['x']+pres['width']-grid['x']-grid['width'])<2)
    check('Presentation descriptions not clipped',page.locator('#pg-fd .fd-pres-txt small').evaluate_all('(els)=>els.every(e=>e.scrollWidth<=e.clientWidth+1 && e.scrollHeight<=e.clientHeight+1)'))
    page.evaluate('window.scrollTo(0,0)');page.wait_for_timeout(150)
    page.locator('#pg-fd .bu-sec').first.screenshot(path=str(OUT/'00_search_layout.png'))
    page.screenshot(path=str(OUT/'01_search_desktop.png'),full_page=True)
    for fmt in ('PDF','PPTX'):
        page.locator('#pg-fd .gen-btn').click()
        with page.expect_download(timeout=20000) as dl:
            page.locator('#pg-fd .gen-item').nth(0 if fmt=='PDF' else 1).click()
        download=dl.value
        check(fmt+' downloads with frozen period filename',download.suggested_filename=='Budget_Status_09-2026'+('.pdf' if fmt=='PDF' else '.pptx'))
        download.save_as(str(OUT/download.suggested_filename))
        page.wait_for_function('!ko.dataFor(document.body).fdPrintBusy()')
    page.evaluate("(()=>{let v=ko.dataFor(document.body);v.fdSel(['S1']);v.fdCcSel(['D01']);v.fdLayout('rows');v.fdDeptQ('Planning');v.buUnit('M');v.fdSecSort('name');v.fdDeptSort('free')})()")
    with page.expect_download(timeout=20000):page.evaluate("ko.dataFor(document.body).runFdReport('PDF')")
    check('Export sends current filters and presentation',all(requests[-1].get(k)==v for k,v in dict(period='09-2026',entity='ALL',sectors='S1',departments='D01',presentation='rows',unit='M',lang='en',sector_sort='name',department_sort='free',department_search='Planning').items()))
    for failure in ('fail','status_fail','download_fail'):
        mode[failure]=True
        page.evaluate("ko.dataFor(document.body).runFdReport('PDF')")
        page.wait_for_function('!ko.dataFor(document.body).fdPrintBusy()',timeout=20000)
        check('Print recovers after '+failure,page.locator('#pg-fd .gen-btn').is_enabled())
        mode[failure]=False
    page.evaluate("ko.dataFor(document.body).fdShowSummary(true);ko.dataFor(document.body).fdReset()")
    check('Reset restores unchecked default',not summary.is_checked())
    for width in (1024,768,390):
        page.set_viewport_size(dict(width=width,height=1000));page.wait_for_timeout(250)
        check(f'Search controls fit at {width}px',page.locator('#pg-fd .filter-grid').evaluate('(e)=>e.scrollWidth<=e.clientWidth+1'))
    page.screenshot(path=str(OUT/'02_mobile.png'),full_page=True)
    page.set_viewport_size(dict(width=1535,height=1000))
    page.evaluate("ko.dataFor(document.body).toggleLang()")
    page.wait_for_timeout(300)
    check('Arabic checkbox label',page.locator('#pg-fd .fd-summary').inner_text()=='إظهار الملخص')
    page.screenshot(path=str(OUT/'03_arabic.png'),full_page=True)
    check('No JS errors through interaction',not errors)
    page.evaluate("ko.dataFor(document.body).fdError('Test data-load failure')")
    check('Print disabled after data-load failure',not page.locator('#pg-fd .gen-btn').is_enabled())
    page.evaluate("ko.dataFor(document.body).fdError('')")
    for layout in ('tiles','rows','map'):
        page.goto((OUT/f'budget-status-{layout}.html').as_uri())
        check(layout+' report pages fit',page.locator('.report-page').evaluate_all('(els)=>els.every(e=>e.scrollHeight<=e.clientHeight+1 && e.scrollWidth<=e.clientWidth+1)'))
        page.locator('.report-page').first.screenshot(path=str(OUT/f'04_report_{layout}.png'))
    browser.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2))
print(f'{sum(ok for _,ok in results)}/{len(results)} passed')
sys.exit(0 if all(ok for _,ok in results) else 1)
