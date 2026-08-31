"""GL Budget Utilization — negative-fund drill drawer + Generate-and-Send
arrow smoke (v1.85.0, 2026-08-24).

Verifies:
  1. The over-budget warning band (.bu-alert--negfund) is clickable and
     opens the shared drill drawer listing exactly the negFund()/negFundTotal()
     lines (server /butil?negfund=Y, GL/db/28).
  2. Drawer row count + total reconcile to the band's own aggregate.
  3. AR pass (drawer title + CTA translated).
  4. "Generate and Send" button carries the dropdown arrow (▾), matching
     "Generate Report ▾".

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/negfund_drill_smoke"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra}")


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
        tok = r.json()["sessionId"]
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(r.json())))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        vm = "ko.dataFor(document.body)"
        pg.wait_for_function(f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
                             timeout=120000)

        # ---- 0. Generate and Send arrow ----
        gs_txt = pg.locator(".gen-btn", has_text="Generate and Send").inner_text()
        check("Generate and Send carries the dropdown arrow", "▾" in gs_txt, gs_txt)
        gen_txt = pg.locator(".gen-btn", has_text="Generate Report").first.inner_text()
        check("Generate Report still carries the arrow (unchanged)", "▾" in gen_txt, gen_txt)

        # ---- 1. band is clickable + opens the drawer ----
        # the default scope's Project Type defaults to "DCT OPEX Project Type",
        # which currently has zero negative lines; the known negative lines
        # (DCT Trust Project Type) only surface with the type filter cleared.
        pg.evaluate(f"() => {{ {vm}.buTypeSel.removeAll(); {vm}.runButil(0); }}")
        pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=60000)
        neg_n = pg.evaluate(f"() => {vm}.buNegFund()")
        neg_t = pg.evaluate(f"() => {vm}.buNegFundTotal()")
        check("server ships negFund > 0 under default scope", neg_n > 0, f"n={neg_n} total={neg_t}")
        band = pg.locator(".bu-alert--negfund")
        check("warning band visible", band.is_visible())
        cursor = band.evaluate("el => getComputedStyle(el).cursor")
        check("band cursor is pointer (clickable)", cursor == "pointer", cursor)
        cta = band.locator(".bu-alert-cta")
        check("CTA 'View lines' visible", cta.is_visible() and cta.inner_text().strip() == "View lines",
              cta.inner_text() if cta.count() else None)

        band.click()
        pg.wait_for_function(f"() => {vm}.drillDrawer()===true && !{vm}.drillLoading()", timeout=60000)
        title = pg.evaluate(f"() => {vm}.drillTitle()")
        check("drawer title = negFund drill title", title == "Budget lines over budget (negative Fund Available)", title)
        drows = pg.evaluate(f"() => {vm}.drillRows().length")
        dcount = pg.evaluate(f"() => {vm}.drillCount()")
        dtot = pg.evaluate(f"() => {vm}.drillTotalV()")
        check("drawer row count == band count", dcount == neg_n, f"drawer={dcount} band={neg_n}")
        check("drawer loaded rows == count (under 5000 cap)", drows == dcount, f"rows={drows} count={dcount}")
        check("drawer total == band total", abs((dtot or 0) - (neg_t or 0)) < 0.01, f"drawer={dtot} band={neg_t}")
        cols = pg.evaluate(f"() => {vm}.drillCols().map(c=>c.key)")
        check("drawer has Fund Available column", "fundAvailable" in cols, cols)
        all_neg = pg.evaluate(
            f"() => {vm}.drillRows().every(r => (r.fundAvailable||0) < -0.005)")
        check("every drawer row is genuinely negative", all_neg is True, all_neg)
        pg.screenshot(path=OUT + "/01_drawer_en.png", full_page=False)

        pg.evaluate(f"() => {vm}.closeDrawer()")
        pg.wait_for_timeout(300)

        # ---- 2. AR pass ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(800)
        cta_ar = pg.locator(".bu-alert--negfund .bu-alert-cta").inner_text()
        check("AR CTA translated", cta_ar.strip() == "عرض البنود", cta_ar)
        pg.locator(".bu-alert--negfund").click()
        pg.wait_for_function(f"() => {vm}.drillDrawer()===true && !{vm}.drillLoading()", timeout=60000)
        title_ar = pg.evaluate(f"() => {vm}.drillTitle()")
        check("AR drawer title translated", "بنود الموازنة" in title_ar, title_ar)
        pg.screenshot(path=OUT + "/02_drawer_ar.png", full_page=False)
        pg.evaluate(f"() => {vm}.closeDrawer()")
        pg.evaluate(f"() => {vm}.toggleLang()")

        check("no page errors", not errors, errors[:2])
        b.close()

    n_ok = sum(1 for _, ok in results if ok)
    print(f"\n{n_ok}/{len(results)} PASS")
    return 0 if n_ok == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
