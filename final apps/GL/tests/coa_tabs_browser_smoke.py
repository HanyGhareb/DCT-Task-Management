"""GL Chart of Accounts (Settings) sub-tabs smoke (v1.73.0, 2026-08-21).

The four collapsible regions of the Chart of Accounts page became four
sub-tabs, in the user-specified order:
  1 Classification values | 2 Manage CoA Mapping | 3 Combinations explorer
  | 4 Classification overview
Default tab = Classification values. The explorer keeps Export CSV + the
maximize toggle (Esc restores). EN + AR/RTL.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8098
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8098"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/coa_tabs"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra}")


def visible(pg, idx):
    """Is the idx-th .bu-sec inside #pg-overview visible?"""
    return pg.evaluate(
        "(i) => {var s=document.querySelectorAll('#pg-overview .bu-sec');"
        "return s[i] ? s[i].offsetParent !== null || getComputedStyle(s[i]).position==='fixed' : null;}", idx)


def main():
    os.makedirs(OUT, exist_ok=True)
    user, pwd = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                           open(AUTH).read())[0]
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page(viewport={"width": 1720, "height": 1000})
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
        pg.evaluate(f"() => {vm}.go('overview')")
        pg.wait_for_function(f"() => {vm}.view()==='overview'", timeout=30000)

        # ---- 1. tab strip: 4 tabs in the specified order ----
        tabs = pg.locator("#pg-overview .coa-tabs a")
        check("tab strip renders 4 tabs", tabs.count() == 4, tabs.count())
        labels = [tabs.nth(i).inner_text().strip().lower() for i in range(tabs.count())]
        check("order 1 = Classification values", "classification values" in labels[0], labels[0])
        check("order 2 = Manage CoA Mapping", "manage coa mapping" in labels[1], labels[1])
        check("order 3 = Combinations explorer", "combinations explorer" in labels[2], labels[2])
        check("order 4 = Classification overview", "classification overview" in labels[3], labels[3])

        # ---- 2. default tab = classification values ----
        check("default tab is Classification values", pg.evaluate(f"() => {vm}.coaTab()") == "cls")
        check("values region visible", visible(pg, 0) is True)
        check("mapping region hidden", visible(pg, 1) is False)
        check("explorer region hidden", visible(pg, 2) is False)
        check("overview region hidden", visible(pg, 3) is False)
        pg.wait_for_function(f"() => {vm}.values().length > 0", timeout=60000)
        check("classification values loaded", pg.evaluate(f"() => {vm}.values().length") > 0)
        pg.screenshot(path=f"{OUT}/coa_tab1_values.png", full_page=True)

        # ---- 3. mapping tab ----
        tabs.nth(1).click()
        check("mapping tab shows mapping only",
              visible(pg, 1) is True and visible(pg, 0) is False and visible(pg, 2) is False)
        check("segment picker present", pg.locator("#pg-overview .bu-sec").nth(1).locator("select").count() >= 2)

        # ---- 4. explorer tab ----
        tabs.nth(2).click()
        check("explorer tab shows explorer only",
              visible(pg, 2) is True and visible(pg, 1) is False)
        pg.wait_for_function(f"() => {vm}.combos().length > 0", timeout=60000)
        check("combinations loaded", pg.evaluate(f"() => {vm}.combos().length") > 0)
        exp = pg.locator("#pg-overview .bu-sec").nth(2)
        check("Export CSV button on explorer header", exp.locator(".bu-sec-h .btn").count() == 1)
        check("maximize button on explorer header", exp.locator(".bu-maxbtn").count() == 1)
        exp.locator(".bu-maxbtn").click()
        check("maximize applies .maxed", pg.evaluate(f"() => {vm}.coaMax()") is True)
        pg.keyboard.press("Escape")
        check("Esc restores from maximize", pg.evaluate(f"() => {vm}.coaMax()") is False)
        pg.screenshot(path=f"{OUT}/coa_tab3_explorer.png", full_page=True)

        # ---- 5. overview tab (now last) ----
        tabs.nth(3).click()
        check("overview tab shows overview only",
              visible(pg, 3) is True and visible(pg, 2) is False)
        check("KPI cards render", pg.locator("#pg-overview .hero .card.stat").count() >= 4,
              pg.locator("#pg-overview .hero .card.stat").count())
        check("combination count populated", pg.evaluate(f"() => {vm}.combinationCount()") > 0)
        pg.screenshot(path=f"{OUT}/coa_tab4_overview.png", full_page=True)

        # ---- 6. Arabic / RTL ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_function("() => document.documentElement.getAttribute('dir')==='rtl'", timeout=15000)
        ar = [tabs.nth(i).inner_text().strip() for i in range(4)]
        check("AR tab labels", ar[0] == "قيم التصنيف" and any("؀" <= c <= "ۿ" for c in "".join(ar)), ar)
        tabs.nth(0).click()
        check("AR: tab switch still works", visible(pg, 0) is True and visible(pg, 3) is False)
        pg.screenshot(path=f"{OUT}/coa_tabs_ar.png", full_page=True)
        pg.evaluate(f"() => {vm}.toggleLang()")

        check("no page errors", not errors, errors[:3])
        b.close()

    n_ok = sum(1 for _, ok in results if ok)
    print(f"\n== {n_ok}/{len(results)} PASS ==")
    return 0 if n_ok == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
