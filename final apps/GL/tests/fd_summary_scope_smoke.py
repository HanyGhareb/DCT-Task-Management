"""Verify Show Summary across rings, sector and department graphs, all layouts.
FD_SUMMARY_STAGED=1 intercepts only app.js with the staged deployment file.
API reads always use the real service. No balances or report definitions change.
"""
import json,os,re
from pathlib import Path
from playwright.sync_api import sync_playwright
from fd_report_live_smoke import ROOT,req
OUT=Path(os.environ.get('FD_SUMMARY_EVIDENCE','/tmp/fd-summary/evidence'));OUT.mkdir(parents=True,exist_ok=True)
u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",(ROOT/'final apps/Admin/Jet/js/services/authService.js').read_text())[0]
st,sess=req('POST','/dct/auth/login',body=dict(username=u,password=p));assert st==200
results=[]
def check(name,ok):
    results.append([name,bool(ok)]);print(('PASS ' if ok else 'FAIL ')+name,flush=True)
with sync_playwright() as pw:
    b=pw.chromium.launch(headless=True)
    page=b.new_page(viewport={'width':1535,'height':1050},ignore_https_errors=True)
    errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
    if os.environ.get('FD_SUMMARY_STAGED')=='1':
        page.route('**/GL/Jet/js/app.js*',lambda route:route.fulfill(path=os.environ.get('FD_SUMMARY_APP','/tmp/fd-summary/stage/GL/Jet/js/app.js'),content_type='application/javascript'))
    page.add_init_script('localStorage.setItem("ifinance_jet_session",'+json.dumps(json.dumps(sess))+');localStorage.setItem("gl_lang","en");')
    page.goto('https://129.151.159.189/GL/Jet/index.html')
    page.wait_for_function('window.ko && ko.dataFor(document.body)',timeout=60000)
    page.evaluate("ko.dataFor(document.body).go('fd')")
    page.wait_for_function('ko.dataFor(document.body).fdLoaded()',timeout=120000)
    vm='ko.dataFor(document.body)'
    check('Summary unchecked on load',not page.locator('#pg-fd .fd-summary input').is_checked())
    for layout in ('tiles','rows','map'):
        page.evaluate(f"{vm}.fdLayout('{layout}')");page.wait_for_timeout(300)
        sector={'tiles':'.fd-cards:not(.fd-cards--dept) .fd-card','rows':'.fd-lg-row[data-sector]','map':'.fd-tm[data-sector]'}[layout]
        dept={'tiles':'.fd-cards--dept .fd-card','rows':'.fd-lg-row[data-cc]','map':'.fd-tm[data-cc]'}[layout]
        for name,selector in [('Budget ring','.fd-ring--bud'),('Actual ring','.fd-ring--act'),('Encumbrance ring','.fd-ring--enc'),('Fund graph','.fd-fund'),('Sector',sector),('Department',dept)]:
            target=page.locator('#pg-fd '+selector).first
            page.evaluate(vm+'.fdShowSummary(false)');page.mouse.move(0,0);target.hover()
            check(layout+' '+name+' hidden when unchecked',not page.evaluate(vm+'.fdTrShow()'))
            page.locator('#pg-fd .fd-summary input').check();page.mouse.move(0,0);target.hover()
            check(layout+' '+name+' shown when checked',page.evaluate(vm+'.fdTrShow()'))
            page.evaluate(vm+'.fdShowSummary(false)')
            check(layout+' '+name+' closes immediately on uncheck',not page.evaluate(vm+'.fdTrShow()'))
        page.locator('#pg-fd '+sector).first.click()
        check(layout+' sector selection still works',len(page.evaluate(vm+'.fdSel()'))==1)
        page.locator('#pg-fd '+dept).first.click()
        check(layout+' department selection still works',len(page.evaluate(vm+'.fdCcSel()'))==1)
        page.evaluate(vm+'.fdClearDepts();'+vm+'.fdClearSectors()')
    page.evaluate(vm+".fdLayout('tiles');"+vm+'.toggleLang()');page.wait_for_timeout(200)
    for label,selector in [('Arabic sector','.fd-cards:not(.fd-cards--dept) .fd-card'),('Arabic department','.fd-cards--dept .fd-card')]:
        node=page.locator('#pg-fd '+selector).first
        page.evaluate(vm+'.fdShowSummary(false)');page.mouse.move(0,0);node.hover()
        check(label+' hidden unchecked',not page.evaluate(vm+'.fdTrShow()'))
        page.locator('#pg-fd .fd-summary input').check();page.mouse.move(0,0);node.hover()
        check(label+' shown checked',page.evaluate(vm+'.fdTrShow()'))
        node.screenshot(path=str(OUT/(label.replace(' ','_')+'.png')))
    page.evaluate(vm+'.fdShowSummary(false)');page.evaluate('window.scrollTo(0,0)')
    page.screenshot(path=str(OUT/'summary-default-off.png'))
    check('No JavaScript errors',not errors)
    if os.environ.get('FD_SUMMARY_STAGED')!='1':check('Expected deployed version',page.evaluate('window.APP_VERSION')==os.environ.get('GL_EXPECT_VERSION','1.115.1'))
    b.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2))
print(f'{sum(ok for _,ok in results)}/{len(results)} passed')
raise SystemExit(0 if all(ok for _,ok in results) else 1)
