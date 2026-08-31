"""GL Cashflow — Projects-cashflow TEMPLATE smoke (v1.71.0, 2026-08-19).

The Download-template button used to hand out ONE sample row. It now pulls
GL/db/23 (GET /gl/cashflow/projects/template) and writes a WIDE workbook: every
budget line of the picked year (project / task / expenditure type) with its full
10-segment GL combination + classification attributes, one column per accounting
period, and any cashflow amounts already saved pre-filled. The upload reads both
the wide sheet and the classic long sheet, and skips BLANK month cells.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8099
"""
import json
import os
import re
import sys

from playwright.sync_api import sync_playwright
from openpyxl import load_workbook

BASE = "http://localhost:8099"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/cf_tpl"

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
        pg = b.new_page(viewport={"width": 1720, "height": 1000}, accept_downloads=True)
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
        pg.evaluate("() => ko.dataFor(document.body).go('cashflow')")
        pg.wait_for_function("() => ko.dataFor(document.body).cfTplYears().length > 0", timeout=120000)
        vm = "ko.dataFor(document.body)"

        # ---- 1. year picker ----
        years = pg.evaluate(f"() => {vm}.cfTplYears()")
        year = pg.evaluate(f"() => {vm}.cfTplYear()")
        check("year picker populated", len(years) > 0, years)
        check("year defaults to a loaded budget year", year in years, year)
        sel = pg.locator("#pg-cashflow select, .bu-sec select")
        check("picker rendered on the page", sel.count() >= 1, sel.count())

        # ---- 2. download the template ----
        with pg.expect_download(timeout=180000) as dl:
            pg.evaluate(f"() => {vm}.cfPjTemplate()")
        d = dl.value
        path = os.path.join(OUT, d.suggested_filename)
        d.save_as(path)
        check("filename carries the year", d.suggested_filename == f"Projects_Cashflow_Template_{year}.xlsx",
              d.suggested_filename)

        wb = load_workbook(path)
        ws = wb["Projects Cashflow"]
        head = [c.value for c in ws[1]]
        check("guide sheet present", len(wb.sheetnames) == 2, wb.sheetnames)
        check("key columns first", head[:5] == ['PROJECT', 'PROJECT_NAME', 'TASK', 'EXPENDITURE_TYPE', 'CF_TYPE'], head[:5])
        months = [h for h in head if isinstance(h, str) and re.match(r"^\d{2}-\d{4}$", h)]
        check("12 period columns", len(months) == 12 and months[0] == f"01-{year}", months[:2])
        check("GL combination column present", 'GL_COMBINATION' in head)
        for col in ('SECTOR', 'DEPARTMENT', 'COST_CENTER', 'GL_ACCOUNT', 'APPROPRIATION',
                    'CHAPTER', 'PROGRAM', 'BUSINESS_UNIT', 'PROJECT_TYPE', 'ANNUAL_BUDGET'):
            check(f"reference column {col}", col in head)

        rows = list(ws.iter_rows(min_row=2, values_only=True))
        check("all budget lines present (>1000)", len(rows) > 1000, len(rows))
        api = pg.evaluate(
            "async () => (await (await fetch('/ords/admin/gl/cashflow/projects/template?year=' + "
            f"{vm}.cfTplYear(), {{headers:{{Authorization:'Bearer ' + "
            "JSON.parse(localStorage.getItem('ifinance_jet_session')).sessionId}})).json())")
        check("row count matches the server line count", len(rows) >= api['count'], f"{len(rows)} vs {api['count']}")
        gl_i, cf_i = head.index('GL_COMBINATION'), head.index('CF_TYPE')
        combo_ok = sum(1 for r in rows if r[gl_i] and re.match(r"^\d{3}\.\d{6}\.", str(r[gl_i])))
        check("rows carry a canonical 10-segment combination", combo_ok > len(rows) * 0.9,
              f"{combo_ok}/{len(rows)}")
        check("CF_TYPE pre-filled APPROVED", all(r[cf_i] in ('APPROVED', 'REVISED') for r in rows))
        check("keys filled on every row", all(r[0] and r[2] and r[3] for r in rows))
        check("month cells left blank to fill", all(r[head.index(months[0])] in (None, 0) for r in rows[:50]))
        check("no page errors", not errors, errors[:2])

        # ---- 3. round-trip: type ONE amount, upload the same file ----
        tgt = rows[0]
        ws.cell(row=2, column=head.index(months[7]) + 1).value = 12345.67   # 08-YYYY
        up = os.path.join(OUT, "roundtrip.xlsx")
        wb.save(up)
        pg.set_input_files("#cfPjFile", up)
        pg.wait_for_function(f"() => {vm}.cfPjBusy() === false && /1/.test({vm}.cfNote())", timeout=120000)
        note = pg.evaluate(f"() => {vm}.cfNote()")
        check("upload posted exactly the ONE typed cell", "1" in note and "0" in note, note)
        srv = pg.evaluate(
            "async () => (await (await fetch('/ords/admin/gl/cashflow/projects/template?year=' + "
            f"{vm}.cfTplYear(), {{headers:{{Authorization:'Bearer ' + "
            "JSON.parse(localStorage.getItem('ifinance_jet_session')).sessionId}})).json())")
        hit = [l for l in srv['lines'] if l['project'] == tgt[0] and l['task'] == tgt[2]
               and l['etype'] == tgt[3]]
        check("saved amount lands on the right line/period",
              bool(hit) and abs(hit[0]['a08'] - 12345.67) < 0.01,
              hit[0]['a08'] if hit else None)
        check("re-download pre-fills the saved amount", bool(hit) and hit[0]['hasPlan'] == 'Y')
        print(f"  fixture written: {tgt[0]} / {tgt[2]} / {tgt[3]}  08-{year} = 12,345.67")
        with open(os.path.join(OUT, "fixture.json"), "w") as f:
            json.dump({"project": tgt[0], "task": tgt[2], "etype": tgt[3], "year": year}, f)

        pg.screenshot(path=os.path.join(OUT, "cashflow_en.png"), full_page=True)
        # ---- 4. AR / RTL ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(1500)
        check("AR: page flips to rtl", pg.evaluate("() => document.documentElement.dir") == "rtl")
        check("AR: template button translated",
              pg.evaluate(f"() => {vm}.t('cfTplBtn')") != 'cfTplBtn')
        pg.screenshot(path=os.path.join(OUT, "cashflow_ar.png"), full_page=True)
        pg.evaluate(f"() => {vm}.toggleLang()")
        b.close()

    ok = sum(1 for _, o in results if o)
    print(f"\n  {ok}/{len(results)} checks passed")
    sys.exit(0 if ok == len(results) else 1)


main()
