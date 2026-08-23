#!/usr/bin/env python3
"""GL Projects Costing Adjustments — browser smoke (v1.78.0, 2026-08-22).

EN: the Projects group gains the Costing Adjustments tab; the butil Search
region has "Include Cost Adjustment" CHECKED by default; the page register
(shared IR) renders; a draft is created through the drawer (AP distribution
search -> Select -> corrected line + signed amounts), approved (confirm
dialog), and the butil results then star (*) the adjusted line and show the
explanatory note under the table; unticking the parameter re-runs, removes
the star + note and restores the published figures. AR: labels + RTL.
Cleanup deletes everything it created.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8096
then:                       python3 costadj_browser_smoke.py
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8096"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/costadj_smoke"
PROJ, TASK = "4517000039", "4510747"
AMT = 1500.0
COL_ORDER = ["status", "projectNumber", "taskNumber", "expenditureType", "amount",
             "budgetOverride", "invoiceNumber", "supplier", "ref", "reason",
             "budgetYear", "period", "className", "createdBy", "createdAt",
             "actionedBy", "actionedAt"]

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
        pg.on("dialog", lambda d: d.accept())
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

        # the fixture line's expenditure type, straight from the API
        et = pg.request.get(
            BASE + "/ords/admin/gl/butil?year=2026&limit=1&project=%s&task=%s" % (PROJ, TASK),
            headers={"Authorization": "Bearer " + tok}).json()["items"][0]["expenditureType"]

        # ---- nav + default checkbox ----
        navtxt = pg.evaluate("() => document.querySelector('nav, .topnav, body').innerText.toLowerCase()")
        check("Projects group shows the Costing Adjustments tab", "costing adjustments" in navtxt)
        check("Include Cost Adjustment defaults to ON", pg.evaluate(f"() => {vm}.buCadj()") is True)
        chk = pg.locator("#pg-butil [data-bind*='toggleBuCadj']")
        check("checkbox label reads included", "included" in chk.inner_text().lower(),
              chk.inner_text())

        # ---- costadj page ----
        pg.evaluate(f"() => {vm}.go('costadj')")
        pg.wait_for_function(f"() => {vm}.caLoaded() && !{vm}.caLoading()", timeout=60000)
        check("page title", pg.locator("#pg-costadj h1").inner_text().strip()
              == "Projects Costing Adjustments")
        check("register (shared IR) mounts", pg.evaluate(f"() => !!{vm}.caData()"))
        cols = pg.evaluate(f"() => {vm}.caData().columns.map(function(c){{return c.key}})")
        check("column order matches the approved layout (Status first)", cols == COL_ORDER, cols)
        base_total = pg.evaluate(f"() => {vm}.caCount()")
        pg.screenshot(path=OUT + "/01_register_en.png", full_page=True)

        # ---- create a draft through the drawer ----
        pg.locator("#pg-costadj .filter-actions .btn:not(.btn-primary)").click()
        pg.wait_for_selector("aside.dw-ca.show", timeout=10000)
        # accounting period is MANDATORY: defaulted, 12 real options, no Full-year
        check("period defaults to a real MM-YYYY",
              bool(re.match(r"^(0[1-9]|1[0-2])-\d{4}$", pg.evaluate(f"() => {vm}.caFPeriod()") or "")),
              pg.evaluate(f"() => {vm}.caFPeriod()"))
        check("period list = 12 months, no Full-year option",
              pg.evaluate(f"() => {vm}.caPeriodOpts().length") == 12)
        # dependent pick lists: tasks follow the project, etypes follow the task
        pg.evaluate(f"() => {{ var v={vm}; v.caFProj('{PROJ}'); v.caProjChanged(); }}")
        pg.wait_for_function(f"() => {vm}.caTasks().length > 0", timeout=60000)
        check("task list scoped to the picked project",
              pg.evaluate(f"() => {vm}.caTasks().indexOf('{TASK}') >= 0"),
              pg.evaluate(f"() => {vm}.caTasks()"))
        pg.evaluate(f"() => {{ var v={vm}; v.caFTask('{TASK}'); v.caTaskChanged(); }}")
        pg.wait_for_function(f"() => {vm}.caEtypes().length > 0", timeout=60000)
        check("expenditure types scoped to project + task",
              pg.evaluate(f"() => {vm}.caEtypes()") == [et], pg.evaluate(f"() => {vm}.caEtypes()"))
        pg.locator(".dw-ca .ca-dist-bar .inp").fill("DCT")
        pg.locator(".dw-ca .ca-dist-bar .btn").click()
        pg.wait_for_function(f"() => {vm}.caDistRows().length > 0", timeout=60000)
        check("distribution search returns rows", True)
        pg.locator(".dw-ca .ca-dist-tbl tbody tr").first.locator("button").click()
        check("selected distribution card shows", pg.locator(".dw-ca .ca-dist-sel").is_visible())
        pg.evaluate(f"() => {{ var v={vm}; v.caFProj('{PROJ}'); v.caFTask('{TASK}');"
                    f" v.caFEtype({json.dumps(et)}); v.caFAmount({AMT}); v.caFOvr(600);"
                    f" v.caFClass('REALLOCATION'); v.caFReason('browser smoke');"
                    f" v.caFComments('temp'); }}")
        pg.screenshot(path=OUT + "/02_drawer_en.png", full_page=True)
        pg.locator(".dw-ca .dw-acts .btn-primary").click()
        pg.wait_for_function(f"() => !{vm}.caDrawer() && !{vm}.caLoading()", timeout=60000)
        check("draft saved and register refreshed",
              pg.evaluate(f"() => {vm}.caCount()") == base_total + 1)
        ref = pg.evaluate(f"() => {vm}.caData().items[0].ref")
        # status pill, comma-free year and the Fusion invoice deep-link
        check("DRAFT status renders as a pill",
              pg.locator(".ir-table tr.ca-st-draft td[data-key=status] span").first.is_visible())
        ytxt = pg.locator(".ir-table tbody tr").first.locator("td[data-key=budgetYear]").inner_text()
        check("budget year renders without a comma", ytxt.strip() == "2026", ytxt)
        href = pg.locator(".ir-table tbody tr").first.locator("td[data-key=invoiceNumber] a.ir-link").get_attribute("href")
        check("invoice number deep-links to Fusion", bool(href) and "AP_VIEWINVOICE" in href, href)
        check("new row is first with a PCA ref and DRAFT status",
              bool(re.match(r"^PCA-\d{{5}}$".format(), ref))
              and pg.evaluate(f"() => {vm}.caData().items[0].status") == "DRAFT", ref)

        # ---- approve (confirm dialog auto-accepted) ----
        pg.evaluate(f"() => {{ var v={vm};"
                    f" v.openCaEdit(v.caData().items.find(function(r){{return r.ref==='{ref}';}})); }}")
        pg.wait_for_selector("aside.dw-ca.show", timeout=10000)
        check("draft drawer offers Approve / Reject / Delete",
              pg.locator(".dw-ca .ca-app").is_visible() and pg.locator(".dw-ca .ca-rej").is_visible())
        pg.locator(".dw-ca .ca-app").click()
        pg.wait_for_function(f"() => !{vm}.caDrawer() && !{vm}.caLoading()", timeout=60000)
        check("row is APPROVED after the confirm",
              pg.evaluate(f"() => {vm}.caData().items.find(function(r){{return r.ref==='{ref}';}}).status")
              == "APPROVED")
        check("APPROVED pill renders green",
              pg.locator(".ir-table tr.ca-st-approved td[data-key=status] span").first.is_visible())

        # ---- butil: star + note, and the un-tick reverting ----
        pg.evaluate(f"() => {{ var v={vm}; v.go('butil'); v.buTypeSel([]); v.buBuSel([]);"
                    f" v.buSearch('{PROJ}'); v.buTask('{TASK}'); v.runButil(0); }}")
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buItems().length > 0", timeout=120000)
        row = pg.evaluate(f"() => {vm}.buItems()[0]")
        check("adjusted line is flagged hasAdj=Y", row["hasAdj"] == "Y", row.get("hasAdj"))
        fund_on = row["fundAvailable"]
        check("(*) star shows in the first cell", pg.locator("#pg-butil .adj-star").first.is_visible())
        note = pg.locator("#pg-butil .cadj-note")
        check("note under the table explains the (*)", note.is_visible()
              and note.inner_text().strip().startswith("(*)"), note.inner_text())
        pg.screenshot(path=OUT + "/03_butil_star_en.png", full_page=True)

        pg.locator("#pg-butil [data-bind*='toggleBuCadj']").click()
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buCadjOn()===false", timeout=120000)
        row_off = pg.evaluate(f"() => {vm}.buItems()[0]")
        check("unticked: figures revert by (override - amount)",
              abs((fund_on - row_off["fundAvailable"]) - (600 - AMT)) < 0.005,
              (fund_on, row_off))
        check("unticked: star hidden", not pg.locator("#pg-butil .adj-star").first.is_visible())
        check("unticked: note hidden", not note.is_visible())
        pg.locator("#pg-butil [data-bind*='toggleBuCadj']").click()
        pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=120000)
        check("re-ticked: star returns", pg.locator("#pg-butil .adj-star").first.is_visible())

        # ---- AR / RTL ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(600)
        check("RTL applied", pg.evaluate("() => document.documentElement.getAttribute('dir')") == "rtl")
        chk_ar = pg.locator("#pg-butil [data-bind*='toggleBuCadj']").inner_text()
        check("checkbox label in Arabic", "تسوية التكاليف" in chk_ar, chk_ar)
        check("note in Arabic", "(*)" in note.inner_text() and "تسويات" in note.inner_text(),
              note.inner_text())
        pg.evaluate(f"() => {vm}.go('costadj')")
        pg.wait_for_timeout(400)
        check("page title in Arabic", "تسويات تكاليف المشاريع"
              in pg.locator("#pg-costadj h1").inner_text())
        pg.screenshot(path=OUT + "/04_ar.png", full_page=True)
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(400)

        # ---- cleanup (delete the approved row via the API) ----
        rid = pg.evaluate(f"() => {vm}.caData().items.find(function(r){{return r.ref==='{ref}';}}).id")
        dr = pg.request.delete(BASE + "/ords/admin/gl/costadj/%s" % rid,
                               headers={"Authorization": "Bearer " + tok})
        check("cleanup delete", dr.status == 200, dr.status)

        check("no page errors", not errors, errors[:3])
        b.close()

    passed = sum(1 for _, o in results if o)
    print(f"\n{passed}/{len(results)} passed")
    return 0 if passed == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
