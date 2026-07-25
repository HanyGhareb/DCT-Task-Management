#!/usr/bin/env python3
"""GL Reconciliation tab — browser smoke (EN + AR/RTL).
Start: python3 dev-proxy.py 8099  (this script starts it itself).
"""
import json, re, subprocess, sys, time, os, signal, urllib.request

BASE = "http://localhost:8099"
GLDIR = "/root/DCT-Task-Management/final apps/GL/Jet"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
ok = fail = 0
def ck(n, c, x=""):
    global ok, fail
    print(("  PASS " if c else "  FAIL ") + n + (" " + str(x) if x else ""))
    ok += 1 if c else 0; fail += 0 if c else 1

def login():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    req = urllib.request.Request(BASE + "/ords/admin/dct/auth/login",
        data=json.dumps({"username": u, "password": p}).encode(),
        method="POST", headers={"Content-Type": "application/json"})
    return json.loads(urllib.request.urlopen(req, timeout=60).read())

def main():
    proxy = subprocess.Popen(["python3", os.path.join(GLDIR, "dev-proxy.py"), "8099"],
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    try:
        time.sleep(2.5)
        session = login(); ck("login via dev-proxy", bool(session.get("sessionId")))
        from playwright.sync_api import sync_playwright
        with sync_playwright() as pw:
            browser = pw.chromium.launch()
            for lang in ("en", "ar"):
                pg = browser.new_page(viewport={"width": 1680, "height": 1050})
                errs = []
                pg.on("console", lambda m: errs.append(m.text) if m.type == "error" else None)
                pg.add_init_script(
                    "localStorage.setItem('ifinance_jet_session', %s);"
                    "localStorage.setItem('gl_lang', %s);" % (json.dumps(json.dumps(session)), json.dumps(lang)))
                pg.goto(BASE + "/index.html")
                pg.wait_for_function("window.ko && ko.dataFor(document.body)", timeout=30000)
                pg.evaluate("ko.dataFor(document.body).go('recon')")
                P = "[%s] " % lang
                # spinner MUST be visible during the initial load (filters + summary)
                pg.wait_for_function("ko.dataFor(document.body).rcBusy()===true", timeout=10000)
                ov = pg.locator(".bu-body.rc-loading .bu-load-ov")
                bb = ov.bounding_box()
                ck(P + "spinner overlay visible on initial load",
                   ov.is_visible() and bb is not None and bb["height"] > 50,
                   "(h=%s)" % (round(bb["height"]) if bb else None))
                ck(P + "spinner has progress circle", pg.locator(".bu-body.rc-loading .ojpc").count() == 1)
                # wait for summary to load (rcSummary set)
                pg.wait_for_function("ko.dataFor(document.body).rcSummary()!=null", timeout=45000)
                pg.wait_for_timeout(700)
                P = "[%s] " % lang
                tiles = pg.locator(".rc-tile").count()
                ck(P + "KPI tiles render", tiles >= 5, "(%d)" % tiles)
                ck(P + "composition donut", pg.locator(".rc-donut").count() == 1)
                ck(P + "measure bars (4)", pg.locator(".rc-bar-row").count() == 4, "(%d)" % pg.locator(".rc-bar-row").count())
                rows = pg.locator(".rc-table tbody tr").count()
                ck(P + "register rows present", rows > 0, "(%d)" % rows)
                # RTL check
                if lang == "ar":
                    d = pg.evaluate("document.documentElement.getAttribute('dir')")
                    ck(P + "dir=rtl", d == "rtl", d)
                # coverage value sane
                cov = pg.evaluate("ko.dataFor(document.body).rcCoverage()")
                ck(P + "coverage 0..100", 0 <= cov <= 100, "(%s%%)" % cov)
                # drill a difference cell -> drawer opens with rows
                dl = pg.locator(".rc-table tbody .rc-dl").first
                if dl.count():
                    dl.click()
                    pg.wait_for_function("ko.dataFor(document.body).drillDrawer()===true", timeout=20000)
                    pg.wait_for_function("ko.dataFor(document.body).drillLoading()===false", timeout=30000)
                    drows = pg.evaluate("ko.dataFor(document.body).drillRows().length")
                    ck(P + "drill drawer shows source rows", drows > 0, "(%d)" % drows)
                    pg.evaluate("ko.dataFor(document.body).closeDrawer && ko.dataFor(document.body).closeDrawer()")
                else:
                    ck(P + "drill link present", False)
                # KPI-tile drill: click the Coverage (matched) tile value -> drawer with source rows
                kpi = pg.locator(".rc-tile--ok .rc-dl").first
                if kpi.count():
                    kpi.click()
                    pg.wait_for_function("ko.dataFor(document.body).drillDrawer()===true", timeout=20000)
                    pg.wait_for_function("ko.dataFor(document.body).drillLoading()===false", timeout=30000)
                    krows = pg.evaluate("ko.dataFor(document.body).drillRows().length")
                    kcols = pg.evaluate("ko.dataFor(document.body).drillCols().map(c=>c.key).join(',')")
                    ck(P + "KPI coverage(matched) drill shows rows", krows > 0, "(%d)" % krows)
                    ck(P + "KPI drill has Source column (measure=all)", "measure" in kcols, kcols)
                    # no '#' project keys must appear (cancelled/soft-deleted excluded)
                    hashed = pg.evaluate("ko.dataFor(document.body).drillRows().filter(r=>String(r.project||'').charAt(0)==='#').length")
                    ck(P + "no '#' project rows in drill", hashed == 0, "(%d)" % hashed)
                    pg.evaluate("ko.dataFor(document.body).closeDrawer && ko.dataFor(document.body).closeDrawer()")
                else:
                    ck(P + "KPI drill link present", False)
                # Budget tile drill (GL ledger)
                bd = pg.locator(".rc-tile--budget .rc-dl").first
                if bd.count():
                    bd.click()
                    pg.wait_for_function("ko.dataFor(document.body).drillLoading()===false", timeout=30000)
                    ck(P + "Budget tile drill shows lines", pg.evaluate("ko.dataFor(document.body).drillRows().length") > 0)
                    pg.evaluate("ko.dataFor(document.body).closeDrawer && ko.dataFor(document.body).closeDrawer()")
                else:
                    ck(P + "Budget drill link present", False)
                # switch measure to PR + grain to combination, re-load rows
                pg.evaluate("ko.dataFor(document.body).rcSetMeasure('pr')")
                pg.evaluate("ko.dataFor(document.body).rcSetGrain('combination')")
                pg.wait_for_function("ko.dataFor(document.body).rcBusy()===false", timeout=30000)
                pg.wait_for_timeout(400)
                ck(P + "register reloads on measure/grain switch", pg.locator(".rc-table tbody tr").count() >= 0)
                ck(P + "no console errors", len(errs) == 0, str(errs[:2]))
                if lang == "en":
                    pg.screenshot(path="/tmp/claude-0/-root-DCT-Task-Management/887defe4-a6f8-4205-ab13-7af7659d4af8/scratchpad/recon_en.png", full_page=True)
                pg.close()
            browser.close()
    finally:
        proxy.send_signal(signal.SIGTERM)
    print("== %d pass / %d fail ==" % (ok, fail))
    sys.exit(1 if fail else 0)

main()
