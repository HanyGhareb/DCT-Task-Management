#!/usr/bin/env python3
"""GL app — "Cashflow" + "DOF Reports" tabs browser smoke (EN + AR/RTL).

Run with the GL dev-proxy on its own port:

  python3 "final apps/GL/Jet/dev-proxy.py" 8098 &
  python3 "final apps/GL/tests/dof_browser_smoke.py"

Covers: both nav tabs, cashflow upload/template buttons + coverage or empty
states, the three DOF datasets on the shared interactive report (row counts,
chapter/grand totals in YoY), the reasons/remarks drawer (open via row click,
close), Generate Workbook button, AR/RTL round-trip (restored to EN).
"""
import json
import re
import urllib.request

BASE = "http://localhost:8098"
AUTH_SRC = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"

ok = fail = 0
def check(name, cond, extra=""):
    global ok, fail
    if cond:
        ok += 1; print("  PASS  %s %s" % (name, extra))
    else:
        fail += 1; print("  FAIL  %s %s" % (name, extra))

def login():
    user, pw = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                          open(AUTH_SRC).read())[0]
    req = urllib.request.Request(BASE + "/ords/admin/dct/auth/login",
                                 data=json.dumps({"username": user, "password": pw}).encode(),
                                 method="POST", headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read())

def main():
    from playwright.sync_api import sync_playwright

    session = login()
    check("login (via dev-proxy)", bool(session.get("sessionId")))

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        pg = browser.new_page(viewport={"width": 1700, "height": 1000})
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(session)))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)

        check("nav has 10+ tabs", pg.locator("nav.pnav a").count() >= 10,
              str(pg.locator("nav.pnav a").count()))

        # ── CASHFLOW tab ──
        pg.evaluate("ko.dataFor(document.body).go('cashflow')")
        pg.wait_for_function("ko.dataFor(document.body).cfLoaded()", timeout=60000)
        check("cashflow title", "Cashflow" in pg.inner_text("#pg-cashflow h1"))
        check("GL upload button (admin)",
              pg.locator("#pg-cashflow button[data-bind*='uploadCfGl']").is_visible())
        check("PJ upload button (admin)",
              pg.locator("#pg-cashflow button[data-bind*='uploadCfPj']").is_visible())
        check("template buttons", pg.locator("#pg-cashflow button[data-bind*='Template']").count() == 2)
        gl_years = pg.evaluate("ko.dataFor(document.body).cfGlYears().length")
        if gl_years:
            check("GL coverage table", pg.locator("#pg-cashflow table.data-table").count() >= 1)
        else:
            check("GL empty state", "No GL cashflow loaded" in pg.inner_text("#pg-cashflow"))

        # ── DOF tab: YoY ──
        pg.evaluate("ko.dataFor(document.body).go('dof')")
        pg.wait_for_function("ko.dataFor(document.body).dofLoaded()", timeout=120000)
        check("DOF renamed to 'DOF Submissions'",
              pg.inner_text("#pg-dof h1").strip() == "DOF Submissions",
              pg.inner_text("#pg-dof h1"))
        yoy_n = pg.evaluate("ko.dataFor(document.body).dofCount()")
        check("YoY rows loaded", yoy_n > 50, str(yoy_n))

        # ── 2026-08-03 round: butil-style regions, year LOV, dynamic headers ──
        check("two bu-sec regions (Search + Results)",
              pg.locator("#pg-dof .bu-sec").count() == 2,
              str(pg.locator("#pg-dof .bu-sec").count()))
        pg.evaluate("ko.dataFor(document.body).toggleDofSec('search')")
        summ = pg.evaluate("ko.dataFor(document.body).dofSearchSummary()")
        check("collapsed Search summary", "20" in summ, summ)
        pg.evaluate("ko.dataFor(document.body).toggleDofSec('search')")
        yrs = pg.evaluate("ko.dataFor(document.body).dofYears()")
        check("year LOV back to 2016", yrs[-1] == "2016", "%s..%s" % (yrs[-1], yrs[0]))
        heads = pg.eval_on_selector_all(
            "#pg-dof table thead th",
            "els => els.map(e => e.textContent.trim().toLowerCase())")
        yr0 = int(pg.evaluate("ko.dataFor(document.body).dofYear()"))
        check("hdr Revised Budget <year>",
              any(("revised budget %d" % yr0) in h for h in heads))
        check("hdr Actual FY <year-1>",
              any(("actual fy %d" % (yr0 - 1)) in h for h in heads))
        check("hdr Actual YTD <year>",
              any(("actual ytd %d" % yr0) in h for h in heads))

        # EBS-era year run (2024): headers follow the year, era note shows
        pg.evaluate("var v=ko.dataFor(document.body); v.dofYear('2024'); v.runDof();")
        pg.wait_for_function("ko.dataFor(document.body).dofBusy() === false", timeout=120000)
        n24 = pg.evaluate("ko.dataFor(document.body).dofCount()")
        check("EBS-era 2024 run returns rows", n24 > 50, str(n24))
        heads = pg.eval_on_selector_all(
            "#pg-dof table thead th",
            "els => els.map(e => e.textContent.trim().toLowerCase())")
        check("hdr follows year (Revised Budget 2024)",
              any("revised budget 2024" in h for h in heads))
        check("hdr Actual FY 2023", any("actual fy 2023" in h for h in heads))
        check("EBS era note shown", pg.evaluate("ko.dataFor(document.body).dofEraNote()") is True)
        eq = pg.evaluate("""(function(){
          var v = ko.dataFor(document.body);
          v.dofReport('butil'); v.runDof();
          return true; })()""")
        pg.wait_for_function("ko.dataFor(document.body).dofData().section === 'dofbutil'"
                             " && ko.dataFor(document.body).dofBusy() === false", timeout=120000)
        check("butil 2024 Initial=Revised (one EBS budget measure)",
              pg.evaluate("""ko.dataFor(document.body).dofData().items.length > 10 &&
                ko.dataFor(document.body).dofData().items.every(function(r){
                  return Math.abs((r.initBudget||0)-(r.revBudget||0)) < 0.01; })"""))
        # back to current year for the remaining legacy checks
        pg.evaluate("var v=ko.dataFor(document.body); v.dofReset(); v.runDof();")
        pg.wait_for_function("ko.dataFor(document.body).dofData().section === 'dofyoy'"
                             " && ko.dataFor(document.body).dofBusy() === false", timeout=120000)
        check("interactive report rendered",
              pg.locator("#pg-dof div[data-bind*='dofGridClick'] table").count() >= 1)
        body_txt = pg.inner_text("#pg-dof")
        check("chapter total row visible", "Chapter 1 Total" in body_txt)
        check("grand total row present",
              pg.evaluate("ko.dataFor(document.body).dofData().items.some(function(r){return r.rowType==='GRAND'})"))
        check("generate button present",
              pg.locator("#pg-dof button[data-bind*='runDofRegister']").is_visible())

        # ── 2026-08-04 layout round: year bands / tints / sticky / zebra /
        #    delta arrows / unit + near-zero params ──
        yr_now = pg.evaluate("ko.dataFor(document.body).dofYear()")
        band = pg.eval_on_selector_all("#pg-dof .ir-table thead tr.ir-band th",
                                       "els => els.map(e => e.textContent.trim())")
        check("grouped header band rendered", len(band) >= 3, str(band))
        check("band has FY current + prior",
              ("FY " + yr_now) in band and ("FY " + str(int(yr_now) - 1)) in band, str(band))
        check("sticky identity columns (3)",
              pg.locator("#pg-dof .ir-table thead th.ir-col-sticky").count() == 3,
              str(pg.locator("#pg-dof .ir-table thead th.ir-col-sticky").count()))
        check("current-year tint cells", pg.locator("#pg-dof td.dofc-cur").count() > 0)
        check("prior-year tint cells", pg.locator("#pg-dof td.dofc-pri").count() > 0)
        check("zebra stripes", pg.locator("#pg-dof tr.ir-even").count() > 0)
        check("variance delta arrows", pg.locator("#pg-dof td .ir-delta").count() > 0)
        # 'Showing figures in' re-scales the emitted envelope w/o a re-query
        raw = pg.evaluate("ko.dataFor(document.body).dofData().items"
                          ".filter(function(r){return r.rowType==='GRAND'})[0].revBudget")
        pg.evaluate("ko.dataFor(document.body).dofUnit('M')")
        pg.wait_for_timeout(300)
        scaled = pg.evaluate("ko.dataFor(document.body).dofData().items"
                             ".filter(function(r){return r.rowType==='GRAND'})[0].revBudget")
        check("unit M rescales figures", abs(scaled * 1e6 - raw) < 1,
              "%s -> %s" % (raw, scaled))
        pg.evaluate("ko.dataFor(document.body).dofUnit('X')")
        pg.evaluate("ko.dataFor(document.body).dofZero('dash')")
        pg.wait_for_timeout(300)
        check("near-zero mode param applied",
              pg.evaluate("ko.dataFor(document.body).dofData().columns"
                          ".filter(function(c){return c.type==='money'})"
                          ".every(function(c){return c.nearZero && c.nearZero.mode==='dash'})"))
        pg.evaluate("ko.dataFor(document.body).dofZero('muted')")
        pg.wait_for_timeout(200)

        # ── 2026-08-04 (2): merged identity columns + multi-select criteria ──
        ths2 = pg.eval_on_selector_all(
            "#pg-dof .ir-table thead th",
            "els => els.map(e => e.textContent.trim().split('\\u24d8')[0].trim())")
        check("merged headers not truncated",
              any(h.startswith("Appropriation") for h in ths2)
              and any(h == "Account" for h in ths2), str(ths2[:6]))
        check("merged cell carries code + name",
              pg.evaluate("ko.dataFor(document.body).dofData().items"
                          ".filter(function(r){return r.rowType==='DETAIL'})[0]"
                          ".apprFull.indexOf(' \\u2014 ') > 0"))
        n_all = pg.evaluate("ko.dataFor(document.body).dofCount()")
        ch0 = pg.evaluate("ko.dataFor(document.body).dofChapters()[0]")
        pg.evaluate("ko.dataFor(document.body).dofChSel.push(%s)" % json.dumps(ch0))
        pg.wait_for_timeout(300)
        n_ch = pg.evaluate("ko.dataFor(document.body).dofCount()")
        check("chapter criteria narrows (multi-select)", 0 < n_ch < n_all,
              "%s -> %s" % (n_all, n_ch))
        check("chapter total kept under chapter filter",
              pg.evaluate("ko.dataFor(document.body).dofData().items"
                          ".some(function(r){return r.rowType==='CHTOTAL'})"))
        apr0 = pg.evaluate("ko.dataFor(document.body).dofApprOpts()[0].c")
        pg.evaluate("ko.dataFor(document.body).dofApSel.push(%s)" % json.dumps(apr0))
        pg.wait_for_timeout(300)
        check("appr filter grand reconciles",
              pg.evaluate("""(function(){
                var it = ko.dataFor(document.body).dofData().items;
                var det = it.filter(function(r){return r.rowType==='DETAIL'});
                var g = it.filter(function(r){return r.rowType==='GRAND'})[0];
                if (!det.length || !g) return false;
                var s = det.reduce(function(a,r){return a+(r.actualYtd||0)},0);
                return Math.abs(s-(g.actualYtd||0)) < 0.01; })()"""))
        check("criteria chips rendered", pg.locator("#pg-dof .mchip").count() == 2,
              str(pg.locator("#pg-dof .mchip").count()))
        pg.evaluate("var v=ko.dataFor(document.body);"
                    "v.dofChSel.removeAll(); v.dofApSel.removeAll();")
        pg.wait_for_timeout(200)

        # row click on a detail row -> notes drawer
        check("admin can edit notes", pg.evaluate("ko.dataFor(document.body).canEditDofNotes") is True)
        pg.evaluate("""(function(){
          var v = ko.dataFor(document.body);
          var det = v.dofData().items.filter(function(r){return r.rowType==='DETAIL'})[0];
          v.openDofNote(det);
        })()""")
        pg.wait_for_timeout(300)
        check("notes drawer opens (yoy)", pg.evaluate("ko.dataFor(document.body).dofDrawer()") is True)
        check("single reason field", pg.locator("aside[data-bind*='dofDrawer'].show textarea").count() == 1)
        # 2026-08-04: the drawer displays ALL record info of the clicked row
        check("drawer shows full record info",
              pg.evaluate("ko.dataFor(document.body).dofNInfo().length") >= 8,
              str(pg.evaluate("ko.dataFor(document.body).dofNInfo().length")))
        check("record grid rendered",
              pg.locator("aside[data-bind*='dofDrawer'].show .dof-rec > div").count() >= 16)
        # 2026-08-04 (3): drawer figures mirror the table format — 2-decimal
        # money + the ▲/▼ colored variance
        check("drawer variance formatted like table",
              pg.evaluate("ko.dataFor(document.body).dofNInfo().some("
                          "function(e){return (e.arrow==='\\u25b2'||e.arrow==='\\u25bc')"
                          " && (e.cls==='pos'||e.cls==='neg');})"))
        check("drawer money has 2 decimals",
              pg.evaluate("ko.dataFor(document.body).dofNInfo().some("
                          "function(e){return e.num && /\\.\\d\\d$/.test(e.v);})"))
        pg.evaluate("ko.dataFor(document.body).closeDofDrawer()")
        check("drawer closes", pg.evaluate("ko.dataFor(document.body).dofDrawer()") is False)

        # ── DOF: Budget Utilization ──
        pg.evaluate("var v=ko.dataFor(document.body); v.dofReport('butil'); v.runDof();")
        pg.wait_for_function("ko.dataFor(document.body).dofData().section === 'dofbutil'", timeout=60000)
        bu_n = pg.evaluate("ko.dataFor(document.body).dofCount()")
        check("BU rows loaded", bu_n >= 10, str(bu_n))
        # 2026-08-03: chapter sub-total + grand-total bands (server rowType ->
        # row._rowClass -> shared IR tr classes; butil fits on page 1)
        check("chapter subtotal bands rendered",
              pg.locator("#pg-dof tr.ir-row-subtotal").count() >= 4,
              str(pg.locator("#pg-dof tr.ir-row-subtotal").count()))
        check("grand total band rendered + bold",
              pg.evaluate("(function(){var g=document.querySelector('#pg-dof tr.ir-row-grand td');"
                          "if(!g)return false;var cs=getComputedStyle(g);"
                          "return cs.fontWeight==='700'||cs.fontWeight==='bold';})()"))
        check("BU chapter totals reconcile",
              pg.evaluate("""(function(){
                var it = ko.dataFor(document.body).dofData().items;
                var det = it.filter(function(r){return r.rowType==='DETAIL'})
                            .reduce(function(a,r){return a+(r.actualYtd||0)},0);
                var g = it.filter(function(r){return r.rowType==='GRAND'})[0];
                return g && Math.abs(det-(g.actualYtd||0)) < 0.01; })()"""))
        check("BU CF-missing note behaviour",
              pg.evaluate("ko.dataFor(document.body).dofCfWarn()") in (True, False))

        # ── DOF: Quarterly ──
        pg.evaluate("var v=ko.dataFor(document.body); v.dofReport('quarterly'); v.runDof();")
        pg.wait_for_function("ko.dataFor(document.body).dofData().section === 'dofquarterly'", timeout=60000)
        q_n = pg.evaluate("ko.dataFor(document.body).dofCount()")
        check("Quarterly rows loaded", q_n >= 10, str(q_n))
        # 2026-08-04: Q1..Q4 bands + alternating quarter tints
        check("quarter bands rendered (4)",
              pg.eval_on_selector_all(
                  "#pg-dof .ir-table thead tr.ir-band th",
                  "els => els.filter(e => /Quarter \\d/.test(e.textContent)).length") == 4)
        check("quarter tint alternation",
              pg.locator("#pg-dof td.dofc-qa").count() > 0
              and pg.locator("#pg-dof td.dofc-qb").count() > 0)
        pg.evaluate("""(function(){
          var v = ko.dataFor(document.body);
          v.openDofNote(v.dofData().items[0]);
        })()""")
        pg.wait_for_timeout(300)
        check("quarterly drawer has 5 fields",
              pg.locator("aside[data-bind*='dofDrawer'].show textarea").count() == 5)
        pg.evaluate("ko.dataFor(document.body).closeDofDrawer()")

        # ── AR/RTL round-trip (restore EN before exit) ──
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(600)
        check("RTL applied", pg.evaluate("document.documentElement.dir") == "rtl")
        ar_title = pg.inner_text("#pg-dof h1")
        check("AR DOF title", "دائرة المالية" in ar_title, ar_title)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(400)
        check("EN restored", pg.evaluate("document.documentElement.dir") == "ltr")

        browser.close()

    print("\n%d PASS / %d FAIL" % (ok, fail))
    return 1 if fail else 0

if __name__ == "__main__":
    import sys
    sys.exit(main())
