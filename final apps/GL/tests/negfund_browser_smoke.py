"""GL Budget Utilization — negative-fund flagging + Type-column removal smoke
(v1.74.0, 2026-08-22).

Verifies:
  1. The butil results table no longer has the leading "Type" column
     (first header = Sector, 19 columns).
  2. The over-budget warning band (.bu-alert--negfund) shows above the
     Overview region when the filtered set has negative Fund Available
     lines, with count + amount in the message (EN + AR).
  3. A negative Fund Available cell renders red (td.neg) with the
     warning flag icon (.nf-flag) visible.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/negfund_smoke"

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
        # app lands on butil; wait for the first run to finish
        pg.wait_for_function(f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
                             timeout=120000)

        # ---- 1. Type column removed ----
        heads = pg.evaluate(
            "() => [...document.querySelectorAll('#pg-butil .actuals-tbl thead th')]"
            ".map(th => th.textContent.trim().toLowerCase())")
        check("results table has 19 columns", len(heads) == 19, len(heads))
        check("no 'type' header", "type" not in [h for h in heads if h == "type"], heads[0])
        check("first header is Sector", heads[0] == "sector", heads[0])

        # ---- 2. over-budget warning band (default scope has negFund > 0) ----
        neg_n = pg.evaluate(f"() => {vm}.buNegFund()")
        neg_t = pg.evaluate(f"() => {vm}.buNegFundTotal()")
        check("server ships negFund > 0 under default scope", neg_n > 0, f"n={neg_n} total={neg_t}")
        band = pg.locator(".bu-alert--negfund")
        check("warning band visible", band.is_visible())
        btxt = band.inner_text()
        check("band shows count + over-budget wording",
              str(neg_n) in btxt and "Over budget" in btxt, btxt[:90])
        # band sits ABOVE the Overview region
        above = pg.evaluate(
            "() => {var a=document.querySelector('.bu-alert--negfund');"
            "var o=[...document.querySelectorAll('#pg-butil .bu-sec')]"
            ".find(s=>s.textContent.includes('OVERVIEW')||s.textContent.includes('Overview'));"
            "return a && o ? a.getBoundingClientRect().top < o.getBoundingClientRect().top : null;}")
        check("band sits above the Overview region", above is True, above)
        pg.screenshot(path=OUT + "/01_banner_en.png", full_page=False)

        # ---- 3. red cell + flag icon on a negative line ----
        rowj = pg.request.get(
            BASE + "/ords/admin/gl/butil?year=2026&projecttype=DCT%20OPEX%20Project%20Type"
                   "&bu=Department%20of%20Culture%20and%20Tourism&limit=5000",
            headers={"Authorization": "Bearer " + tok}).json()
        neg_rows = [i for i in rowj.get("items", []) if (i.get("fundAvailable") or 0) < 0]
        check("API returns negative lines to target", len(neg_rows) > 0, len(neg_rows))
        if neg_rows:
            proj = neg_rows[0]["projectNumber"]
            pg.evaluate(f"() => {{ {vm}.buSearch({json.dumps(proj)}); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=60000)
            cell = pg.locator("#pg-butil .actuals-tbl tbody td.neg").first
            check("negative fund cell carries .neg", cell.count() > 0)
            color = cell.evaluate("el => getComputedStyle(el).color")
            weight = cell.evaluate("el => getComputedStyle(el).fontWeight")
            bgcol = cell.evaluate("el => getComputedStyle(el).backgroundColor")
            check("cell text is red", color != "rgb(0, 0, 0)" and "rgb" in color, color)
            check("cell is bold", weight in ("700", "bold"), weight)
            check("cell has soft red tint", bgcol not in ("rgba(0, 0, 0, 0)", "transparent"), bgcol)
            flag = pg.locator("#pg-butil .actuals-tbl tbody td.neg .nf-flag").first
            check("warning flag icon visible", flag.is_visible())
            pg.screenshot(path=OUT + "/02_neg_cell.png", full_page=False)
            pg.evaluate(f"() => {{ {vm}.buSearch(''); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=60000)

        # ---- 4. AR pass (GL keeps language in localStorage only) ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(800)
        btxt_ar = pg.locator(".bu-alert--negfund").inner_text()
        check("AR band text is Arabic", "الموازنة" in btxt_ar, btxt_ar[:60])
        heads_ar = pg.evaluate(
            "() => [...document.querySelectorAll('#pg-butil .actuals-tbl thead th')].length")
        check("AR table still 19 columns", heads_ar == 19, heads_ar)
        pg.screenshot(path=OUT + "/03_banner_ar.png", full_page=False)
        pg.evaluate(f"() => {vm}.toggleLang()")

        check("no page errors", not errors, errors[:2])
        b.close()

    n_ok = sum(1 for _, ok in results if ok)
    print(f"\n{n_ok}/{len(results)} PASS")
    return 0 if n_ok == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
