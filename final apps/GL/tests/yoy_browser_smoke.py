"""GL Balances YoY tab — browser smoke.

Run via the webapp-testing helper (GL dev-proxy on its own port):
    python3 'final apps/GL/Jet/dev-proxy.py' 8096  (server)
Covers: nav tab, default 3-year run, pivot table (year columns + totals),
measure toggle, client search filter, month change re-run, AR/RTL, EN restore.
"""
import json
import re
import sys
import time

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8096"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra}")


def main():
    user, pwd = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                           open(AUTH).read())[0]
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page(viewport={"width": 1600, "height": 1000})
        # login via ORDS through the proxy, then seed the session pre-boot
        r = pg.request.post(BASE + "/ords/admin/dct/auth/login",
                            data=json.dumps({"username": user, "password": pwd}),
                            headers={"Content-Type": "application/json"})
        s = r.json()
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(s)))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        check("app booted", True)

        # nav to the YoY tab
        pg.evaluate("() => ko.dataFor(document.body).go('yoy')")
        pg.wait_for_function(
            "() => ko.dataFor(document.body).yoLoaded() === true", timeout=120000)
        vm_years = pg.evaluate("() => ko.dataFor(document.body).yoYears()")
        check("default run loaded", True, str(vm_years))
        check("3 default years", len(vm_years) == 3, str(vm_years))
        n = pg.evaluate("() => ko.dataFor(document.body).yoView().length")
        check("accounts in pivot", n > 100, f"n={n}")

        # 2026-08-03 rework: SHARED interactive report — ascending year
        # columns, dynamic Change YY-YY headers, hints, trailing Chart col
        pg.wait_for_selector("#pg-yoy .ir-table", timeout=60000)
        ths = pg.eval_on_selector_all(
            "#pg-yoy .ir-table thead th",
            "els => els.map(e => e.textContent.trim().split('\\u24d8')[0].trim())")
        check("interactive report rendered", len(ths) >= 7, str(len(ths)))
        yrs_h = [h for h in ths if h[:4].isdigit()]
        check("year columns ascending", yrs_h == sorted(yrs_h) and len(yrs_h) == len(vm_years), str(yrs_h))
        ya, yb = sorted(vm_years)[-1], sorted(vm_years)[-2]
        sfx = f"{str(yb)[-2:]}-{str(ya)[-2:]}"
        check("dynamic Change header", any(f"Change {sfx}" in h for h in ths), sfx)
        check("dynamic Change %% header", any(f"Change % {sfx}" in h for h in ths))
        check("Chart column last", "Chart" in ths[-1], ths[-1])
        check("column hints present", pg.locator("#pg-yoy .ir-hint").count() >= 5)
        check("sparklines rendered", pg.locator("#pg-yoy .ir-spark .sp-mini").count() >= 20)
        pg.hover("#pg-yoy .ir-spark >> nth=0")
        vis = pg.eval_on_selector("#pg-yoy .ir-spark .ir-spark-pop",
                                  "e => getComputedStyle(e).display")
        check("hover trend chart popover", vis == "block", vis)

        # 2026-08-04 layout round: alternating year tints, gold Change block
        # with red/green ▲▼ arrows, zebra striping
        check("year column tints alternate",
              pg.locator("#pg-yoy td.yoc-a").count() > 0
              and pg.locator("#pg-yoy td.yoc-b").count() > 0)
        check("Change columns gold tinted", pg.locator("#pg-yoy td.yoc-chg").count() > 0)
        up = pg.locator("#pg-yoy .ir-delta--up").count()
        dn = pg.locator("#pg-yoy .ir-delta--dn").count()
        check("delta arrows on Change", up + dn > 0, "up=%d dn=%d" % (up, dn))
        check("zebra stripes", pg.locator("#pg-yoy tr.ir-even").count() > 0)

        # measure toggle rebuilds the envelope
        pg.evaluate("() => ko.dataFor(document.body).yoMeasure('budget')")
        time.sleep(0.5)
        n_ir = pg.evaluate("() => ko.dataFor(document.body).yoIr().items.length")
        check("measure toggle re-renders", n_ir > 100, f"items={n_ir}")
        pg.evaluate("() => ko.dataFor(document.body).yoMeasure('actual')")

        # client search narrows
        pg.evaluate("() => ko.dataFor(document.body).yoSearch('411121')")
        time.sleep(0.3)
        n2 = pg.evaluate("() => ko.dataFor(document.body).yoView().length")
        check("search narrows", 0 < n2 < n, f"{n} -> {n2}")
        row = pg.evaluate("() => ko.dataFor(document.body).yoView()[0]")
        check("searched account correct", row["account"] == "411121", row["account"])
        vals = pg.evaluate("() => { var vm = ko.dataFor(document.body); var r = vm.yoView()[0];"
                           " return vm.yoYears().map(function(y){ return vm.yoVal(r, y); }); }")
        check("row has per-year values", any(v for v in vals if v), str(vals))
        pg.evaluate("() => ko.dataFor(document.body).yoSearch('')")

        # YTD month run
        pg.evaluate("() => { var vm = ko.dataFor(document.body); vm.yoMonth(6); vm.runYoy(); }")
        pg.wait_for_function("() => !ko.dataFor(document.body).yoBusy()", timeout=120000)
        n3 = pg.evaluate("() => ko.dataFor(document.body).yoView().length")
        check("YTD-Jun re-run", n3 > 50, f"n={n3}")

        # AR / RTL
        pg.evaluate("() => ko.dataFor(document.body).toggleLang()")
        time.sleep(1.0)
        dir_attr = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        check("RTL applied", dir_attr == "rtl", dir_attr)
        title = pg.eval_on_selector("#pg-yoy h1", "e => e.textContent")
        check("AR title", "الأستاذ" in title or "سنوية" in title, title)
        pg.evaluate("() => ko.dataFor(document.body).toggleLang()")
        time.sleep(1.0)
        dir2 = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        check("EN restored", dir2 != "rtl", str(dir2))

        b.close()

    npass = sum(1 for _, ok in results if ok)
    print(f"\n{npass} PASS / {len(results) - npass} FAIL")
    sys.exit(0 if npass == len(results) else 1)


if __name__ == "__main__":
    main()
