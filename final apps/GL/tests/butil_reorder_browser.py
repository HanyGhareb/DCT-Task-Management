#!/usr/bin/env python3
import json, re, sys, urllib.request
BASE="http://localhost:8098"; AUTH="/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
ok=fail=0
def ck(n,c,x=""):
    global ok,fail; print(("  PASS " if c else "  FAIL ")+n+" "+str(x)); ok+=1 if c else 0; fail+=0 if c else 1
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
        pg.wait_for_timeout(500)
        bu=pg.locator("div[data-bind=\"visible:view()==='butil'\"]").first
        labels=[l.strip() for l in bu.locator(".filter-grid .field .lbl").all_inner_texts()]
        ck("first field is Business Unit","business unit" in labels[0].lower(),"(1st=%s)"%labels[0])
        ll=[l.lower() for l in labels]
        ck("Appropriation field present",any(l.startswith("appropriation") for l in ll),str(labels))
        ck("DCT Program field present",any(l=="program" for l in ll))
        # order: Appropriation & Program come after Expenditure Type, before Search
        idx={l:i for i,l in enumerate(ll)}
        ck("Approp/Program after Etype before Search", idx.get("appropriation",99)>idx.get("expenditure type",0) and idx.get("program",99)<idx.get("search",99))
        # 7-column grid (2 rows)
        cols=pg.evaluate("getComputedStyle(document.querySelector(\"div[data-bind=\\\"visible:view()==='butil'\\\"] .filter-grid\")).gridTemplateColumns")
        ck("grid has 7 columns",len(cols.split())==7,"(%d cols)"%len(cols.split()))
        # dropdowns populated
        na=pg.evaluate("ko.dataFor(document.body).buAppropList().length"); npg=pg.evaluate("ko.dataFor(document.body).buProgramList().length")
        ck("Appropriation LOV populated",na>0,"(%d)"%na); ck("Program LOV populated",npg>0,"(%d)"%npg)
        # BU default = DCT
        busel=pg.evaluate("ko.dataFor(document.body).buBuSel()")
        ck("BU defaults to DCT",busel==["Department of Culture and Tourism"],str(busel))
        # end-to-end: pick an appropriation, Search, results narrow
        pg.wait_for_function("ko.dataFor(document.body).buTotal()>0",timeout=60000)
        pg.evaluate("var v=ko.dataFor(document.body); v.buBuSel.removeAll(); v.buType(''); v.runButil(0);")
        pg.wait_for_function("!ko.dataFor(document.body).buLoading()",timeout=60000); pg.wait_for_timeout(300)
        base=pg.evaluate("ko.dataFor(document.body).buTotal()")
        ap=pg.evaluate("ko.dataFor(document.body).buAppropList()[0]")
        pg.evaluate("var v=ko.dataFor(document.body); v.buApprop('%s'); v.runButil(0);"%ap.replace("'","\\'"))
        pg.wait_for_function("!ko.dataFor(document.body).buLoading()",timeout=60000); pg.wait_for_timeout(300)
        ft=pg.evaluate("ko.dataFor(document.body).buTotal()")
        ck("appropriation pick narrows results",0<ft<base,"(%d of %d)"%(ft,base))
        pg.screenshot(path="/root/DCT-Task-Management/final apps/GL/tests/butil_reorder.png",full_page=False)
    print("== %d pass / %d fail =="%(ok,fail)); sys.exit(1 if fail else 0)
main()
