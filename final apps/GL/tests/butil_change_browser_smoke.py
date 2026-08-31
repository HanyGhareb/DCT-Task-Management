"""GL Budget Utilization — Budget CHANGE (+/-) smoke (v1.66.0, 2026-08-17).

The Excel override became a SIGNED change that is ADDED to the budget
(db/v2/106 v2 + db/v2/37 pb_src + GL/db/07 + 15). This covers the page side:
the Budget Change KPI tile, the include-change checkbox moving BOTH the annual
and the YTD budget, the line-grain drawer (annual/YTD Fusion + change +
adjusted), in-place editing, the signed presentation, CSV, and AR/RTL.

The fixture change is booked at 08-2026 on a line whose ONLY Fusion budget row
is 01-2026 (the un-phased-budget case, which is the norm here) so the smoke
also proves the orphan-period path end to end.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
"""
import base64
import json
import re
import sys
import urllib.request

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra}")


def xl(method, path, user, pwd, body=None):
    """Fixture helper: drive the Excel API directly (Basic auth)."""
    h = {"Authorization": "Basic " + base64.b64encode(f"{user}:{pwd}".encode()).decode()}
    data = None
    if body is not None:
        data = json.dumps(body).encode()
        h["Content-Type"] = "application/json"
    r = urllib.request.Request(ORDS + "/xl" + path, data=data, headers=h, method=method)
    return json.loads(urllib.request.urlopen(r, timeout=300).read())


def main():
    user, pwd = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                           open(AUTH).read())[0]

    # ---- fixture: one -250,000 change at 08-2026 on a big DCT OPEX line ----
    lst = xl("GET", "/budget/?budget_year=2026&accounting_period=08-2026", user, pwd)
    line = sorted(lst["items"], key=lambda r: -(r["budget_annual"] or 0))[0]
    xl("PUT", "/budget/" + line["id"], user, pwd,
       {"budget_change": -250000, "reason_category": "BUDGET_REALLOCATION",
        "comments": "browser smoke"})
    print(f"  fixture: {line['project_number']} / {line['task_number']} "
          f"annual {line['budget_annual']:,.0f}, change -250,000 at 08-2026")

    try:
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
            pg.evaluate("() => ko.dataFor(document.body).go('butil')")
            pg.wait_for_function(
                "() => { const v = ko.dataFor(document.body); "
                "return v.buFiltersLoaded() && v.buLoading() === false && v.buItems().length > 0; }",
                timeout=180000)
            vm = "ko.dataFor(document.body)"

            # ---- 1. KPI tile: signed change + changed-line count ----
            chg = pg.evaluate(f"() => {vm}.buTot('overrideBudget')")
            lines_n = pg.evaluate(f"() => {vm}.buTot('overrideLines')")
            check("KPI tile carries the net change", round(chg, 2) == -250000, f"({chg})")
            check("KPI tile counts changed lines", lines_n == 1, f"({lines_n})")
            tile = pg.locator(".bk-ovr .bk-v")
            tile_k = pg.locator(".bk-ovr .bk-k").inner_text()
            check("tile label is Budget Change (+/-)",
                  "budget change" in tile_k.lower(), tile_k)
            check("tile value renders negative red",
                  "ov-neg" in (tile.get_attribute("class") or ""),
                  tile.inner_text())

            # ---- 2. include-change checkbox moves BOTH annual and YTD ----
            ann0 = pg.evaluate(f"() => {vm}.buTot('budgetAnnual')")
            ytd0 = pg.evaluate(f"() => {vm}.buTot('budget')")
            off_txt = pg.locator(".ovr-chk").first.inner_text()
            check("checkbox reads 'Select to include Budget Override'",
                  "include budget override" in off_txt.lower(), off_txt.strip()[:60])
            pg.evaluate(f"() => {vm}.toggleBuOvr()")
            pg.wait_for_function(
                f"() => {vm}.buLoading() === false && {vm}.buConsiderOvr() === true", timeout=180000)
            ann1 = pg.evaluate(f"() => {vm}.buTot('budgetAnnual')")
            ytd1 = pg.evaluate(f"() => {vm}.buTot('budget')")
            check("annual budget moves by the change", round(ann1 - ann0, 2) == -250000,
                  f"({ann0:,.0f} -> {ann1:,.0f})")
            check("YTD budget moves by the change", round(ytd1 - ytd0, 2) == -250000,
                  f"({ytd0:,.0f} -> {ytd1:,.0f})")
            check("tile shows the applied hint",
                  pg.locator(".bk-ovr .ov-applied").is_visible())

            # ---- 3. YTD cutoff before the change period excludes it ----
            pg.evaluate(f"() => {{ {vm}.buPeriod('07-2026'); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
            chg07 = pg.evaluate(f"() => {vm}.buTot('overrideBudget')")
            check("YTD 07-2026 excludes an 08-2026 change", round(chg07, 2) == 0, f"({chg07})")
            pg.evaluate(f"() => {{ {vm}.buPeriod('08-2026'); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
            chg08 = pg.evaluate(f"() => {vm}.buTot('overrideBudget')")
            check("YTD 08-2026 includes it", round(chg08, 2) == -250000, f"({chg08})")
            pg.evaluate(f"() => {{ {vm}.buPeriod(''); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)

            # ---- 4. drawer: line grain with fusion + adjusted columns ----
            pg.locator(".bk-ovr").click()
            pg.wait_for_function(f"() => {vm}.ovDrawer() && {vm}.ovLoading() === false", timeout=180000)
            rows = pg.evaluate(f"() => {vm}.ovRows().length")
            check("drawer lists the change", rows == 1, f"(rows={rows})")
            heads = [h.strip() for h in pg.locator(".ov-tbl thead th").all_inner_texts()]
            for want in ["Annual Budget (Fusion)", "YTD Budget (Fusion)", "Budget Change (+/-)",
                         "Adjusted Annual", "Adjusted YTD"]:
                check(f"drawer column '{want}'", any(want.lower() == h.lower() for h in heads),
                      "" if any(want.lower() == h.lower() for h in heads) else str(heads))
            row0 = pg.evaluate(f"() => {vm}.ovRows()[0]")
            check("drawer row carries fusion annual + ytd",
                  row0["fusionAnnual"] == line["budget_annual"] and row0["fusionYtd"] is not None,
                  f"({row0['fusionAnnual']:,.0f})")
            check("drawer row adjusted = fusion + change",
                  round(row0["adjustedAnnual"], 2) == round(row0["fusionAnnual"] - 250000, 2))
            check("drawer row period is the change period", row0["accountingPeriod"] == "08-2026")
            inp = pg.locator(".ov-tbl tbody tr:first-child .ov-inp")
            check("change input shows the signed amount", inp.input_value() == "-250000",
                  inp.input_value())
            check("negative input styled red", "ov-neg" in (inp.get_attribute("class") or ""))
            foot = pg.locator(".ov-tbl tfoot").inner_text()
            check("footer shows Net change", "Net change" in foot, foot.replace("\n", " ")[:70])
            pg.screenshot(path="/root/DCT-Task-Management/final apps/GL/tests/butil_change_en.png")

            # ---- 5. in-place edit (positive change) ----
            inp.fill("125000")
            inp.dispatch_event("change")
            pg.locator(".ov-tbl tbody tr:first-child .btn-primary").evaluate("el => el.click()")
            pg.wait_for_function(f"() => {vm}.ovRows()[0].saving() === false", timeout=120000)
            saved = pg.evaluate(f"() => {vm}.ovRows()[0].override()")
            check("in-place edit saved", str(saved) == "125000", f"({saved})")
            pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
            chg2 = pg.evaluate(f"() => {vm}.buTot('overrideBudget')")
            check("KPI re-runs after the save", round(chg2, 2) == 125000, f"({chg2})")

            # ---- 6. CSV export: capture the generated blob and assert its content
            # (the page builds a detached <a download>, which never raises a
            # Playwright download event, so intercept createObjectURL instead) ----
            csv = pg.evaluate("""async () => {
                const vm = ko.dataFor(document.body);
                const realURL = URL.createObjectURL, realClick = HTMLAnchorElement.prototype.click;
                let blob = null, name = '';
                URL.createObjectURL = b => { blob = b; return 'blob:stub'; };
                HTMLAnchorElement.prototype.click = function () { name = this.download; };
                try { vm.ovExportCsv(); } finally {
                    URL.createObjectURL = realURL; HTMLAnchorElement.prototype.click = realClick;
                }
                return { name: name, text: blob ? await blob.text() : '' };
            }""")
            check("CSV file name", csv["name"].startswith("gl_budget_change_"), csv["name"])
            head = csv["text"].split("\n")[0]
            check("CSV header has the new columns",
                  all(h in head for h in ["Annual Budget (Fusion)", "YTD Budget (Fusion)",
                                          "Budget Change (+/-)", "Adjusted Annual", "Adjusted YTD"]),
                  head[:120])
            check("CSV carries the data row and a total footer",
                  "125000" in csv["text"] and csv["text"].strip().split("\n")[-1].startswith('"Total'),
                  csv["text"].strip().split("\n")[-1][:80])

            # ---- 7. AR / RTL ----
            pg.evaluate(f"() => {vm}.toggleLang()")
            pg.wait_for_timeout(700)
            dirn = pg.evaluate("() => document.documentElement.getAttribute('dir')")
            check("AR flips to RTL", dirn == "rtl", str(dirn))
            ar_k = pg.locator(".bk-ovr .bk-k").inner_text()
            check("tile label translated", "تغيير الموازنة" in ar_k, ar_k)
            ar_heads = " ".join(pg.locator(".ov-tbl thead th").all_inner_texts())
            check("drawer columns translated", "بعد التعديل" in ar_heads and "فيوجن" in ar_heads)
            pg.screenshot(path="/root/DCT-Task-Management/final apps/GL/tests/butil_change_ar.png")
            pg.evaluate(f"() => {vm}.toggleLang()")     # restore EN (the shell persists it)
            pg.wait_for_timeout(500)

            check("no page errors", not errors, str(errors[:2]))
            b.close()
    finally:
        # ---- fixture cleanup ----
        xl("PUT", "/budget/" + line["id"], user, pwd, {"budget_change": 0})
        print("  fixture cleared")

    ok = sum(1 for _, o in results if o)
    print(f"\n== {ok}/{len(results)} passed ==")
    sys.exit(0 if ok == len(results) else 1)


if __name__ == "__main__":
    main()
