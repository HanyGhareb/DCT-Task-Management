"""Actual deployed Print-menu downloads and summary defaults; no API interception."""
import json,os,re
from pathlib import Path
from playwright.sync_api import sync_playwright
from fd_report_live_smoke import ROOT,req
OUT=Path(os.environ.get('FD_LIVE_EVIDENCE','/tmp/fd-live-ui'));OUT.mkdir(parents=True,exist_ok=True)
u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",(ROOT/'final apps/Admin/Jet/js/services/authService.js').read_text())[0]
status,sess=req('POST','/dct/auth/login',body={'username':u,'password':p});assert status==200
results=[]
def check(name,ok):
    results.append((name,bool(ok)));print(('PASS ' if ok else 'FAIL ')+name,flush=True)
with sync_playwright() as pw:
    b=pw.chromium.launch(headless=True)
    page=b.new_page(viewport={'width':1535,'height':1050},ignore_https_errors=True)
    errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
    page.add_init_script('localStorage.setItem("ifinance_jet_session",'+json.dumps(json.dumps(sess))+');localStorage.setItem("gl_lang","en");')
    page.goto('https://129.151.159.189/GL/Jet/index.html')
    page.wait_for_function('window.ko && ko.dataFor(document.body)',timeout=60000)
    page.evaluate("ko.dataFor(document.body).go('fd')")
    page.wait_for_function('ko.dataFor(document.body).fdLoaded()',timeout=120000)
    expected=os.environ.get('FD_EXPECT_VERSION','1.113.0')
    check('Live APP_VERSION '+expected,page.evaluate('window.APP_VERSION')==expected)
    checkbox=page.locator('#pg-fd .fd-summary input')
    ring=page.locator('#pg-fd .fd-ring--bud').first
    check('Summary defaults unchecked',not checkbox.is_checked())
    ring.hover();check('Unchecked suppresses summary',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    checkbox.check();ring.hover();check('Checked enables summary',page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    page.evaluate('ko.dataFor(document.body).fdShowSummary(false)')
    check('Unchecking closes summary immediately',not page.evaluate('ko.dataFor(document.body).fdTrShow()'))
    print_btn=page.locator('#pg-fd .gen-btn')
    print_btn.click();check('Print menu offers PDF and PowerPoint',page.locator('#pg-fd .gen-item').count()==2)
    page.locator('#pg-fd .gen-item').first.focus();page.keyboard.press('Escape')
    check('Escape closes Print menu',not page.evaluate('ko.dataFor(document.body).fdPrintOpen()'))
    for i,ext in enumerate(('pdf','pptx')):
        print_btn.click()
        with page.expect_download(timeout=180000) as download:
            page.locator('#pg-fd .gen-item').nth(i).click()
        d=download.value;d.save_as(str(OUT/d.suggested_filename))
        check('Print menu downloads live '+ext,d.suggested_filename.endswith('.'+ext))
        page.wait_for_function('!ko.dataFor(document.body).fdPrintBusy()')
    page.evaluate('window.scrollTo(0,0)');page.wait_for_timeout(200)
    page.locator('#pg-fd .bu-sec').first.screenshot(path=str(OUT/'search-live.png'))
    page.screenshot(path=str(OUT/'dashboard-live.png'),full_page=True)
    for width in (1024,768,390):
        page.set_viewport_size({'width':width,'height':1050})
        check('Search fits '+str(width)+'px',page.locator('#pg-fd .filter-grid').evaluate('(e)=>e.scrollWidth<=e.clientWidth+1'))
    page.set_viewport_size({'width':1535,'height':1050})
    page.evaluate('ko.dataFor(document.body).toggleLang()');page.wait_for_timeout(300)
    check('Arabic Summary label',page.locator('#pg-fd .fd-summary').inner_text()=='إظهار الملخص')
    page.locator('#pg-fd .bu-sec').first.screenshot(path=str(OUT/'search-live-ar.png'))
    check('No JavaScript errors',not errors)
    b.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2))
print(f'{sum(ok for _,ok in results)}/{len(results)} passed')
raise SystemExit(0 if all(ok for _,ok in results) else 1)
