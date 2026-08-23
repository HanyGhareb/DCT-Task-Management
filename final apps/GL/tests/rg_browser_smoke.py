#!/usr/bin/env python3
"""GL Budget Utilization — "The Binder" report-generation popup (v1.80.0).

Runs a LIVE Excel Register generation scoped to one project/task and proves:
the centred popup appears with the book + its 7 real section chips, the
headline names the running format, the elapsed clock actually ticks, the ×
hides the popup while the run continues, the workbook download lands, and
the popup closes itself when the run finishes. AR strings checked via t().

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8096
then:                       python3 rg_browser_smoke.py
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8096"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/rg_smoke"
PROJ, TASK = "4517000039", "4510747"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra if not ok else ''}")


def main():
    os.makedirs(OUT, exist_ok=True)
    user, pwd = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                           open(AUTH).read())[0]
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page(viewport={"width": 1760, "height": 1000})
        errors = []
        pg.on("pageerror", lambda e: errors.append(str(e)))
        r = pg.request.post(BASE + "/ords/admin/dct/auth/login",
                            data=json.dumps({"username": user, "password": pwd}),
                            headers={"Content-Type": "application/json"})
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(r.json())))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        vm = "ko.dataFor(document.body)"
        pg.wait_for_function(f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
                             timeout=120000)

        # narrow scope so the register renders fast, then start a LIVE run
        pg.evaluate(f"() => {{ var v={vm}; v.buTypeSel([]); v.buBuSel([]);"
                    f" v.buSearch('{PROJ}'); v.buTask('{TASK}'); }}")
        pg.evaluate(f"() => {{ {vm}.runBuXlsx(); }}")

        # ---- popup up, correct content ----
        pg.wait_for_selector(".rg .rg-card", state="visible", timeout=15000)
        check("popup appears over the dimmed page", True)
        check("headline names the running format",
              pg.locator(".rg-tx b").inner_text().strip() == "Generating Excel Register (XLSX)",
              pg.locator(".rg-tx b").inner_text())
        check("the book carries the page title + year",
              "Budget Utilization" in pg.locator(".rg-book").inner_text()
              and "2026" in pg.locator(".rg-book").inner_text(),
              pg.locator(".rg-book").inner_text())
        chips = pg.locator(".rg-secs span").all_inner_texts()
        check("7 real section chips", len(chips) == 7 and chips[0] == "Cover"
              and "Open obligations" in chips, chips)
        check("status line shows the poll cadence",
              "every 5 seconds" in pg.locator(".rg-sub").inner_text(),
              pg.locator(".rg-sub").inner_text())
        pg.screenshot(path=OUT + "/01_popup_en.png")

        # ---- the clock is real ----
        pg.wait_for_function(f"() => {vm}.rgElapsed() !== '0:00'", timeout=10000)
        check("elapsed clock ticks", True)

        # ---- × hides, run continues ----
        pg.locator(".rg-x").click()
        check("× hides the popup", not pg.locator(".rg .rg-card").is_visible())
        check("the run keeps going", pg.evaluate(f"() => {vm}.buXlsxBusy()") is True)

        # ---- live completion: download lands, popup state closes ----
        with pg.expect_download(timeout=420000) as dl:
            pg.wait_for_function(f"() => !{vm}.buXlsxBusy()", timeout=420000)
        check("the workbook downloads",
              "Budget_Utilization_Register" in dl.value.suggested_filename,
              dl.value.suggested_filename)
        check("popup closes itself when the run finishes",
              pg.evaluate(f"() => {vm}.rgShow()") is False)

        # ---- a fresh run un-hides the popup (rgHidden resets) ----
        pg.evaluate(f"() => {{ {vm}.rgStart('rgGenBook', 6); }}")
        check("a new run re-shows the popup after a previous hide",
              pg.locator(".rg .rg-card").is_visible()
              and pg.locator(".rg-tx b").inner_text().strip() == "Generating Briefing Book (PDF)")
        pg.evaluate(f"() => {{ {vm}.rgShow(false); }}")

        # ---- Arabic strings ----
        ar = pg.evaluate(f"() => {{ var v={vm}; v.setLangProbe = null;"
                         f" var keep = v.lang(); v.lang('ar');"
                         f" var out = [v.t('rgGenBook'), v.t('rgSecAp'), v.t('rgHide')];"
                         f" v.lang(keep); return out; }}")
        check("Arabic translations present",
              "الكتاب" in ar[0] and "الدائنين" in ar[1] and "إخفاء" in ar[2], ar)

        check("no page errors", not errors, errors[:3])
        b.close()

    passed = sum(1 for _, o in results if o)
    print(f"\n{passed}/{len(results)} passed")
    return 0 if passed == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
