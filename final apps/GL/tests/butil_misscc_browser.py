#!/usr/bin/env python3
"""GL Budget Utilization -- missing-Cost-Centre red alert band + drill drawer (v1.43.0)."""
import json, re, urllib.request
BASE="http://localhost:8098"; AUTH="/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
ok=fail=0
def ck(n,c,x=""):
    global ok,fail; print(("  PASS " if c else "  FAIL ")+n+" "+str(x)); ok,fail=(ok+1,fail) if c else (ok,fail+1)
def login():
    u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",open(AUTH).read())[0]
    r=urllib.request.Request(BASE+"/ords/admin/dct/auth/login",data=json.dumps({"username":u,"password":p}).encode(),method="POST",headers={"Content-Type":"application/json"})
    return json.loads(urllib.request.urlopen(r,timeout=60).read())
def main():
    from playwright.sync_api import sync_playwright
    s=login(); ck("login",bool(s.get("sessionId")))
    with sync_playwright() as p:
        b=p.chromium.launch(headless=True); pg=b.new_page(viewport={"width":1700,"height":1000})
        pg.add_init_script("localStorage.setItem('ifinance_jet_session',%s);localStorage.setItem('gl_lang','en');"%json.dumps(json.dumps(s)))
        pg.goto(BASE+"/index.html"); pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)",timeout=120000)
        pg.evaluate("ko.dataFor(document.body).go('butil')")
        pg.wait_for_function("ko.dataFor(document.body).buFiltersLoaded && ko.dataFor(document.body).buFiltersLoaded()",timeout=120000)
        pg.wait_for_function("!ko.dataFor(document.body).buLoading()",timeout=120000); pg.wait_for_timeout(400)
        vm="ko.dataFor(document.body)."
        # default filters (BU=DCT, type=OPEX) may or may not have missing lines; force the full 2026 set
        pg.evaluate(vm+"buBuSel.removeAll()"); pg.evaluate(vm+"buType('')")
        pg.evaluate(vm+"runButil(0)")
        pg.wait_for_function("!"+vm+"buLoading()",timeout=120000); pg.wait_for_timeout(300)
        miss=pg.evaluate(vm+"buMissCc()")
        ck("missingCc loaded from /butil",miss>0,"(%d lines)"%miss)
        band=pg.locator(".bu-alert")
        ck("red band visible",band.is_visible())
        txt=band.inner_text()
        ck("band mentions count",str(miss) in txt.replace(",",""),txt[:80])
        ck("band styled red",pg.evaluate("getComputedStyle(document.querySelector('.bu-alert')).borderInlineStartColor")=="rgb(192, 57, 43)")
        # click -> drawer with the lines
        band.click()
        pg.wait_for_function(vm+"drillDrawer()",timeout=30000)
        pg.wait_for_function("!"+vm+"drillLoading()",timeout=120000); pg.wait_for_timeout(300)
        rows=pg.evaluate(vm+"drillRows().length")
        ck("drawer rows == missingCc",rows==miss,"(%d rows)"%rows)
        cnt=pg.evaluate(vm+"drillCount()")
        ck("drawer count == missingCc",cnt==miss)
        nullcc=pg.evaluate("ko.dataFor(document.body).drillRows().every(function(r){return !r.costCentre && r.budgetAnnual})")
        ck("every drawer row CC-less w/ annual budget",nullcc)
        tot=pg.evaluate(vm+"drillTotalV()")
        sm=pg.evaluate("ko.dataFor(document.body).drillRows().reduce(function(a,r){return a+(r.budgetAnnual||0)},0)")
        ck("drawer total reconciles",abs(tot-sm)<0.01,"(%s)"%round(tot,2))
        ck("drawer title",pg.evaluate(vm+"drillTitle()")=="Budget lines with missing Cost Centre")
        pg.screenshot(path="misscc_en.png",full_page=False)
        pg.evaluate(vm+"closeDrawer()")
        # narrow filter with no missing lines -> band hidden
        pg.evaluate(vm+"buProject('4511001117')"); pg.evaluate(vm+"buProjCommit()"); pg.evaluate(vm+"runButil(0)")
        pg.wait_for_function("!"+vm+"buLoading()",timeout=120000); pg.wait_for_timeout(300)
        ck("band hidden when 0 missing",not pg.locator(".bu-alert").is_visible(),"(missingCc=%s)"%pg.evaluate(vm+"buMissCc()"))
        # AR/RTL render
        pg.evaluate(vm+"buProjSel.removeAll()"); pg.evaluate(vm+"runButil(0)")
        pg.wait_for_function("!"+vm+"buLoading()",timeout=120000)
        pg.evaluate(vm+"toggleLang()") if pg.evaluate("typeof ko.dataFor(document.body).toggleLang==='function'") else pg.evaluate(vm+"setLang('ar')")
        pg.wait_for_timeout(600)
        ck("RTL dir set",pg.evaluate("document.documentElement.dir")=="rtl")
        ar=pg.locator(".bu-alert").inner_text()
        ck("band arabic text",("مركز تكلفة" in ar),ar[:60])
        pg.screenshot(path="misscc_ar.png")
        # restore EN (shell persists language to server prefs)
        pg.evaluate(vm+"toggleLang()") if pg.evaluate("typeof ko.dataFor(document.body).toggleLang==='function'") else pg.evaluate(vm+"setLang('en')")
        pg.wait_for_timeout(400)
        ck("EN restored",pg.evaluate("document.documentElement.dir")!="rtl")
        b.close()
    print("---"); print(f"{ok} passed, {fail} failed")
    return fail
if __name__=="__main__":
    raise SystemExit(main())
