#!/usr/bin/env python3
"""GL app — butil "Refresh source data" button smoke (v1.62.0, GL/db/19).

Run via the webapp-testing helper (own port — never fight over 8080):

  python scripts/with_server.py \
    --server "python3 '/root/DCT-Task-Management/final apps/GL/Jet/dev-proxy.py' 8097" --port 8097 \
    -- python3 "/root/DCT-Task-Management/final apps/GL/tests/butil_pdata_smoke.py"

Clicks the REAL button: enqueues the PROJECTS_DATA set (Projects Full + Tasks
Full + Projects Budget Full - V2) and waits for the fleet to finish (~1-3 min).
"""
import json
import re
import sys
import time
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
        pg = browser.new_page(viewport={"width": 1700, "height": 1000})
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(session)))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)

        pg.evaluate("ko.dataFor(document.body).go('butil')")
        pg.wait_for_timeout(2500)

        btn = pg.locator("button", has_text="Refresh source data")
        check("button present on butil page", btn.count() == 1)

        vm_ok = pg.evaluate("typeof ko.dataFor(document.body).refreshProjectsData === 'function'"
                            " && typeof ko.dataFor(document.body).pdataBusy === 'function'")
        check("VM handler + observable bound", vm_ok)

        # click the real thing: enqueue the set, busy label shows, then completes
        btn.first.click()
        pg.wait_for_timeout(1500)
        check("busy state after click", pg.evaluate("ko.dataFor(document.body).pdataBusy()"))
        check("busy label shown",
              pg.locator("button", has_text="Refreshing data").count() >= 1)

        t0 = time.time()
        done = False
        while time.time() - t0 < 360:
            if not pg.evaluate("ko.dataFor(document.body).pdataBusy()"):
                done = True
                break
            pg.wait_for_timeout(5000)
        check("refresh completed within 6 min", done, "(%.0fs)" % (time.time() - t0))
        check("button back to idle", btn.count() == 1)

        # AR label renders (portal VM exposes toggleLang, not setLang; toggle
        # back so the persisted language choice stays EN)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(1200)
        ar = pg.locator("button", has_text="تحديث بيانات المصدر").count()
        check("AR label", ar == 1)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(800)

        browser.close()

    print("\n%d passed, %d failed" % (ok, fail))
    sys.exit(1 if fail else 0)

if __name__ == "__main__":
    main()
