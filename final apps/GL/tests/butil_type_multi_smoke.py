"""GL Budget Utilization — Project Type MULTI-SELECT smoke (v1.60.0).

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8096
Covers: default DCT-OPEX chip, second pick becomes a chip, multi-type search
returns the union, MSS BU + MSS type shows data (the zero-figures complaint),
chip remove, Reset restores the single default chip.
"""
import json
import re
import sys

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
        sel = pg.evaluate(f"() => {vm}.buTypeSel()")
        check("default = one DCT OPEX chip", sel == ["DCT OPEX Project Type"], str(sel))
        base_total = pg.evaluate(f"() => {vm}.buTotal()")

        # pick MSS type from the select -> second chip
        has_mss = pg.evaluate(f"() => {vm}.buTypes().indexOf('MSS OPEX Project Type') >= 0")
        check("MSS OPEX type in the LOV", has_mss)
        pg.evaluate(f"() => {{ {vm}.buTypePick('MSS OPEX Project Type'); {vm}.buTypeAdd(); }}")
        sel = pg.evaluate(f"() => {vm}.buTypeSel()")
        check("second pick becomes a chip", len(sel) == 2, str(sel))
        chips = pg.locator("#pg-butil .mchips-bar .mchip, .mchips-bar .mchip").count()
        check("chips visible in the applied-filters tray", chips >= 2, f"chips={chips}")

        # clear the default DCT Business-Unit chip so the union is visible
        pg.evaluate(f"() => {{ {vm}.buBuSel([]); {vm}.runButil(0); }}")
        pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
        multi_total = pg.evaluate(f"() => {vm}.buTotal()")
        check("multi-type search = union of both types", multi_total > base_total,
              f"single={base_total} multi={multi_total}")

        # the MSS complaint: BU = Museum Shared Services now shows data
        pg.evaluate(f"() => {{ {vm}.buBuSel(['Museum Shared Services']); {vm}.runButil(0); }}")
        pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
        mss_total = pg.evaluate(f"() => {vm}.buTotal()")
        mss_budget = pg.evaluate(f"() => ({vm}.buTotals() || {{}}).budget || 0")
        check("MSS BU + MSS type shows data (was all zeros)", mss_total > 0 and mss_budget > 0,
              f"rows={mss_total} budget={round(mss_budget)}")
        pg.screenshot(path="final apps/GL/tests/butil_type_multi.png")

        # chip remove + Reset restores the single default
        pg.evaluate(f"() => {{ {vm}.buChipRemove({vm}.buTypeSel, 'MSS OPEX Project Type'); }}")
        check("chip x removes the pick",
              pg.evaluate(f"() => {vm}.buTypeSel().length") == 1)
        pg.evaluate(f"() => {{ {vm}.buBuSel([]); {vm}.buReset(); }}")
        pg.wait_for_function(f"() => {vm}.buLoading() === false", timeout=180000)
        check("Reset restores the single DCT OPEX default chip",
              pg.evaluate(f"() => {vm}.buTypeSel()") == ["DCT OPEX Project Type"])

        check("no page JS errors", not errors, str(errors[:3]))
        b.close()

    fails = [x for x in results if not x[1]]
    print(f"\n{len(results) - len(fails)}/{len(results)} PASS")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
