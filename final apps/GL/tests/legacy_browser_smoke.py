#!/usr/bin/env python3
"""GL app — "Legacy (EBS)" tab browser smoke (EN + AR/RTL).

Run via the webapp-testing helper (GL dev-proxy on its own port):

  python scripts/with_server.py \
    --server "python3 '/root/DCT-Task-Management/final apps/GL/Jet/dev-proxy.py' 8097" --port 8097 \
    -- python3 "/root/DCT-Task-Management/final apps/GL/tests/legacy_browser_smoke.py"

Covers: nav tab, COA-mapping interactive report (3,191 seeded rows), search,
admin add/edit drawer open+close, balances region (empty state or coverage
table), template button presence, AR/RTL toggle (restored to EN before exit).
"""
import json
import re
import urllib.request

BASE = "http://localhost:8097"
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
        pg = browser.new_page(viewport={"width": 1600, "height": 1000})
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(session)))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)

        check("Legacy nav tab present", pg.locator("nav.pnav a").count() == 8,
              str(pg.locator("nav.pnav a").count()))

        # ── EN: open the Legacy tab by id and wait for the mapping fetch ──
        pg.evaluate("ko.dataFor(document.body).go('legacy')")
        pg.wait_for_function("ko.dataFor(document.body).xmLoaded()", timeout=60000)
        vm_count = pg.evaluate("ko.dataFor(document.body).xmCount()")
        check("mapping loaded (3,191 rows)", vm_count == 3191, str(vm_count))
        check("interactive report rendered",
              pg.locator("div[data-bind*='xmGridClick'] table").count() >= 1)
        check("page title", "Legacy System (EBS)" in pg.inner_text("#pg-legacy h1"))

        # search narrows the set
        pg.evaluate("var v=ko.dataFor(document.body); v.xmSearch('424521'); v.runEbsMap();")
        pg.wait_for_function("ko.dataFor(document.body).xmCount() < 100", timeout=60000)
        check("search narrows", pg.evaluate("ko.dataFor(document.body).xmCount()") >= 1)
        pg.evaluate("var v=ko.dataFor(document.body); v.xmSearch(''); v.runEbsMap();")
        pg.wait_for_function("ko.dataFor(document.body).xmCount() === 3191", timeout=60000)

        # ── admin drawer: open new-mapping drawer, then close ──
        check("admin can manage", pg.evaluate("ko.dataFor(document.body).canManageEbs") is True)
        pg.evaluate("ko.dataFor(document.body).openXmNew()")
        pg.wait_for_selector("aside[data-bind*='xmDrawer'].show", timeout=10000)
        check("new-mapping drawer opens",
              pg.locator("aside[data-bind*='xmDrawer'].show").count() == 1)
        pg.evaluate("ko.dataFor(document.body).closeXmDrawer()")
        check("drawer closes", pg.evaluate("ko.dataFor(document.body).xmDrawer()") is False)

        # row click → edit drawer (delegated resolve through the shared IR)
        pg.locator("div[data-bind*='xmGridClick'] tbody td").first.click()
        pg.wait_for_timeout(400)
        opened = pg.evaluate("ko.dataFor(document.body).xmDrawer()")
        check("row click opens edit drawer", opened is True)
        if opened:
            check("edit drawer holds an id", pg.evaluate("!!ko.dataFor(document.body).xmId()"))
            pg.evaluate("ko.dataFor(document.body).closeXmDrawer()")

        # ── balances region: summary loaded (coverage table or empty state) ──
        pg.wait_for_function("ko.dataFor(document.body).ebLoaded()", timeout=60000)
        years = pg.evaluate("ko.dataFor(document.body).ebYears().length")
        if years:
            check("coverage table shown", pg.locator("#pg-legacy table.data-table").count() >= 2)
        else:
            check("empty state shown", "upload the EBS balance file" in
                  pg.inner_text("#pg-legacy"))
        check("template button present",
              pg.locator("#pg-legacy button[data-bind*='ebTemplate']").count() == 1)
        check("upload button present (admin)",
              pg.locator("#pg-legacy button[data-bind*='uploadEbs']").is_visible())

        # ── AR/RTL round-trip (GL portal keeps its own gl_lang; restore EN) ──
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(600)
        check("RTL applied", pg.evaluate("document.documentElement.dir") == "rtl")
        ar_title = pg.inner_text("#pg-legacy h1")
        check("AR title", "EBS" in ar_title and "النظام السابق" in ar_title, ar_title)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(400)
        check("EN restored", pg.evaluate("document.documentElement.dir") == "ltr")

        browser.close()

    print("\n%d PASS / %d FAIL" % (ok, fail))
    return 1 if fail else 0

if __name__ == "__main__":
    import sys
    sys.exit(main())
