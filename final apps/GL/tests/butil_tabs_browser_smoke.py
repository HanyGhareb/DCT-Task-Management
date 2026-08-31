#!/usr/bin/env python3
"""GL Budget Utilization — Results-region level tabs (v1.89.0, layout B).

EN: the Results region shows the segmented switcher (Budget Line / Department /
Sector, icons) + the live summary strip; Budget Line = the untouched paged
table; Department/Sector = the aggregated register from GET /butil/agg with
plan-with-no-budget-line folded in (extra note + planExtra cell titles), vs
Plan / Coverage verdict pills, group comment buttons, and CSV export of the
active tab. Aggregated figures must reconcile EXACTLY to the line totals.
AR: labels + RTL. Read-only — creates nothing.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
then:                       python3 butil_tabs_browser_smoke.py
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/butil_tabs_smoke"

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
        tok = r.json()["sessionId"]
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(r.json())))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        vm = "ko.dataFor(document.body)"
        pg.wait_for_function(
            f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
            timeout=120000)

        # 1. toolbar renders: three pills, Budget Line active, strip populated
        pills = pg.locator("#pg-butil .bu-lvl-tab")
        check("three level pills render", pills.count() == 3, pills.count())
        check("Budget Line active by default",
              "on" in (pills.nth(0).get_attribute("class") or ""))
        check("pills carry icons", pg.locator("#pg-butil .bu-lvl-tab svg").count() == 3)
        check("line table visible", pg.locator("#pg-butil table.actuals-tbl").first.is_visible())
        check("pager visible on line level", pg.locator("#pg-butil .bu-pager").is_visible())
        strip_n = pg.evaluate(f"{vm}.buLvlSum().n")
        total = pg.evaluate(f"{vm}.fmt({vm}.buTotal())")
        check("strip count = line total", strip_n == total, (strip_n, total))
        check("strip label = Lines", pg.evaluate(f"{vm}.buLvlSum().nl") == "Lines")
        # v1.91.0: six icon KPI chips incl. Encumbrance = Commitment + Obligation
        check("six strip chips with icons",
              pg.locator("#pg-butil .bu-lvl-kv .kv-ico svg").count() == 6,
              pg.locator("#pg-butil .bu-lvl-kv .kv-ico svg").count())
        enc_ok = pg.evaluate(
            f"""Math.abs({vm}.buLvlSum().enc - (({vm}.buTotals().commitmentPr||0)+({vm}.buTotals().obligationPo||0))) < 0.01""")
        check("Encumbrance chip = Commitment + Obligation", enc_ok)

        # 1b. formula-first column hints (2026-08-29 feedback round)
        fund_tip = pg.evaluate(f"{vm}.t('chFund')")
        check("Fund hint carries the formula",
              "YTD Budget" in fund_tip and "Commitment PR + Obligation PO" in fund_tip, fund_tip)
        vs_tip = pg.evaluate(f"{vm}.piVsHdrTip()")
        check("vs Plan hint carries the formula", "\u00f7" in vs_tip and "100" in vs_tip, vs_tip)
        cov_tip = pg.evaluate(f"{vm}.piCovHdrTip()")
        check("Coverage hint carries the formula", "\u00f7" in cov_tip, cov_tip)
        titled = pg.evaluate(
            """() => Array.from(document.querySelectorAll('#pg-butil table.actuals-tbl thead th'))
                   .filter(function(th){return th.offsetParent!==null && !(th.getAttribute('title')||'').trim()}).length""")
        check("every visible line-table header has a hint", titled == 0, titled)

        # 1c. seed a COST_CENTER comment via the API so the Department tab's
        # Comments column shows the recorded text for the selected period
        cc0 = "4519202"
        seed = pg.request.post(BASE + "/ords/admin/gl/butilcmt",
            data=json.dumps({"level": "COST_CENTER", "entityKey": cc0, "budgetYear": 2026,
                             "period": "08-2026", "text": "TAB SMOKE dept comment"}),
            headers={"Content-Type": "application/json", "Authorization": "Bearer " + tok})
        seed_id = (seed.json() or {}).get("commentId") or (seed.json() or {}).get("id")
        pg.evaluate(f"{vm}.buPeriod('08-2026'); {vm}.runButil(0);")
        pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=120000)

        # 2. Department tab
        pills.nth(1).click()
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buAggItems().length>0", timeout=120000)
        check("dept pill active", "on" in (pills.nth(1).get_attribute("class") or ""))
        agg = pg.locator("#pg-butil .bu-agg-tbl")
        check("agg table visible", agg.is_visible())
        heads = [h.strip().lower() for h in agg.locator("thead th").all_inner_texts()]
        check("dept has Cost Center + Department cols",
              "cost center" in heads and "department" in heads, heads)
        check("pager hidden on dept level", not pg.locator("#pg-butil .bu-pager").is_visible())
        n_rows = agg.locator("tbody tr").count()
        n_groups = pg.evaluate(f"{vm}.buAggTotals().groups")
        check("dept rows = groups", n_rows == n_groups, (n_rows, n_groups))
        check("strip label = Departments",
              pg.evaluate(f"{vm}.buLvlSum().nl") == "Departments")

        # 3. reconciliation to the line totals (VM figures, exact)
        rec = pg.evaluate(f"""() => {{
          var a = {vm}.buAggTotals(), t = {vm}.buTotals();
          return ['budget','budgetAnnual','actualAp','actualGrn','commitmentPr',
                  'obligationPo','fundAvailable']
            .map(function(k){{ return Math.abs((a[k]||0)-(t[k]||0)); }});
        }}""")
        check("dept totals reconcile to line totals", all(d < 0.01 for d in rec), rec)
        check("dept line count reconciles",
              pg.evaluate(f"{vm}.buAggTotals().lines === {vm}.buTotal()"))

        # 4. plan outside budget lines folded in (note + planExtra)
        extra = pg.evaluate(f"{vm}.buAggExtra()")
        check("planExtra > 0 (unmatched plan folded in)", extra > 0, extra)
        check("extra note visible",
              pg.locator("#pg-butil .cadj-note", has_text="no matching budget line").is_visible())
        check("verdict pills render", agg.locator("tbody .vp").count() > 0)
        check("coverage pills render", agg.locator("tbody .pi-pill").count() > 0)

        # 4b. the Comments column records the department's comment at the period
        row_txt = pg.evaluate(
            f"""({vm}.buAggItems().filter(function(r){{return r.costCentre==='{"4519202"}'}})[0]||{{}}).commentsText||''""")
        check("dept Comments cell carries the recorded text",
              "TAB SMOKE dept comment" in row_txt and "[08-2026]" in row_txt, row_txt)
        check("comment text rendered in the grid",
              agg.locator("tbody .cmt-txt-clamp", has_text="TAB SMOKE dept comment").count() == 1)

        # 5. group comment button opens the COST_CENTER-level drawer
        if pg.evaluate(f"{vm}.buCmtOn()"):
            agg.locator("tbody .cmt-btn").first.click()
            pg.wait_for_function(f"() => {vm}.cmtDrawer()", timeout=30000)
            lvl = pg.evaluate(f"{vm}.cmtCtx().level")
            check("comment drawer opens at COST_CENTER", lvl == "COST_CENTER", lvl)
            pg.evaluate(f"{vm}.closeCmtDrawer()")
        else:
            check("comment drawer opens at COST_CENTER", True, "(comments off)")

        # 5b. figure drills (v1.92.0): a group money cell opens the shared
        # drill drawer scoped to the group — the drawer total ties to the cell.
        # (closing the comment drawer refetches the agg — wait it out first)
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buAggItems().length>0", timeout=120000)
        check("agg money cells drillable", agg.locator("tbody td.money-cell").count() > 0)
        # money-cell order per row: budgetAnnual, budget, planA, planY,
        # [revA, revY when revised exists], ap, grn, pr, po
        ap_idx = pg.evaluate(f"{vm}.buAggRevOn() ? 6 : 4")
        drill_idx = pg.evaluate(f"""() => {{
          var it = {vm}.buAggItems();
          for (var i = 0; i < it.length; i++)
            if (it[i].costCentre && Math.abs(it[i].actualAp||0) > 1) return i;
          return -1;
        }}""")
        check("drillable dept row found", drill_idx >= 0, drill_idx)
        row = agg.locator("tbody tr").nth(drill_idx)
        row.locator("td.money-cell").nth(ap_idx).click()
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=120000)
        got = pg.evaluate(f"{vm}.drillTotalV()")
        want = pg.evaluate(f"{vm}.buAggItems()[{drill_idx}].actualAp")
        check("dept AP drill total ties to the cell", abs(got - want) < 0.01, (got, want))
        cc_lbl = pg.evaluate(f"{vm}.buAggItems()[{drill_idx}].costCentre")
        check("drill subtitle names the group", cc_lbl in pg.evaluate(f"{vm}.drillSub()"),
              pg.evaluate(f"{vm}.drillSub()"))
        pg.screenshot(path=OUT + "/en_dept_drill.png", full_page=False)
        pg.evaluate(f"{vm}.closeDrawer()")
        # plan drill on a plan-outside-budget CC — the db/30 extra=Y leg
        po_idx = pg.evaluate(f"""() => {{
          var it = {vm}.buAggItems();
          for (var i = 0; i < it.length; i++)
            if (it[i].costCentre === '4510230') return i;
          return -1;
        }}""")
        check("planExtra CC 4510230 row found", po_idx >= 0, po_idx)
        agg.locator("tbody tr").nth(po_idx).locator("td.money-cell").nth(3).click()
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=120000)
        got = pg.evaluate(f"{vm}.drillTotalV()")
        want = pg.evaluate(f"{vm}.buAggItems()[{po_idx}].planApprovedYtd")
        check("plan drill ties on a no-budget-line CC (extra=Y)",
              abs(got - want) < 0.01, (got, want))
        pg.evaluate(f"{vm}.closeDrawer()")

        # 5c. missing-classification guard (v1.93.0): cost centre is MANDATORY —
        # a keyless group must fire the warning band (negfund pattern) whose
        # click lists the missing lines. Live data is fully classified, so
        # simulate a keyless group and assert the wiring.
        check("warning band hidden while all lines classified",
              not pg.locator("#pg-butil .bu-alert").first.is_visible())
        pg.evaluate(f"""{vm}.buAggItems.push({{sector:null, costCentre:null, department:null,
          lines:3, budget:500000, budgetAnnual:1200000, actualAp:0, actualGrn:0, procash:0,
          commitmentPr:0, obligationPo:0, fundAvailable:500000,
          planApprovedAnnual:0, planApprovedYtd:0, planRevisedAnnual:0, planRevisedYtd:0,
          planEffYtd:0, planEffAnnual:0, planExtra:0, planOnly:'N',
          planExecState:'NOPLAN', planCovState:'NONE', costAdj:0, hasAdj:'N',
          overrideBudget:0, overrideBudgetAnnual:0, overrideLines:0, cmtCount:0, hasCmt:'N'}})""")
        band = pg.locator("#pg-butil .bu-alert").first
        check("warning band fires on a keyless group", band.is_visible())
        check("band message uses the group's numbers",
              "3" in band.inner_text() and "1,200,000" in band.inner_text(), band.inner_text())
        check("keyless row tinted as violation",
              agg.locator("tbody tr.tr-noclass").count() == 1)
        pg.screenshot(path=OUT + "/en_noclass_band.png", full_page=False)
        agg.locator("tbody tr.tr-noclass td.money-cell").first.click()
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=120000)
        check("keyless cell opens the missing-lines list",
              pg.evaluate(f"{vm}.drillTitle()") == "Budget lines with missing Cost Centre",
              pg.evaluate(f"{vm}.drillTitle()"))
        pg.evaluate(f"{vm}.closeDrawer()")
        band.click()
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=120000)
        check("band click opens the missing-lines list",
              pg.evaluate(f"{vm}.drillTitle()") == "Budget lines with missing Cost Centre")
        pg.evaluate(f"{vm}.closeDrawer()")
        pg.evaluate(f"{vm}.buAggItems.pop()")
        check("band hides once the group is classified", not band.is_visible())

        # 6. CSV export of the active tab
        with pg.expect_download() as dl:
            pg.evaluate(f"{vm}.buExportCsv()")
        name = dl.value.suggested_filename
        check("dept CSV export", "departments" in name, name)

        # 7. Sector tab
        pills.nth(2).click()
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buLevel()==='sector'", timeout=120000)
        pg.wait_for_function(f"() => {vm}.buAggItems().length>0", timeout=120000)
        heads2 = [h.strip().lower() for h in agg.locator("thead th").all_inner_texts()]
        check("sector table drops CC column", "cost center" not in heads2, heads2)
        check("strip label = Sectors", pg.evaluate(f"{vm}.buLvlSum().nl") == "Sectors")
        check("sector fund reconciles", pg.evaluate(
            f"Math.abs({vm}.buAggTotals().fundAvailable - {vm}.buTotals().fundAvailable) < 0.01"))
        # sector row figure drill ties the same way
        s_idx = pg.evaluate(f"""() => {{
          var it = {vm}.buAggItems();
          for (var i = 0; i < it.length; i++)
            if (it[i].sector && Math.abs(it[i].actualAp||0) > 1) return i;
          return -1;
        }}""")
        check("drillable sector row found", s_idx >= 0, s_idx)
        agg.locator("tbody tr").nth(s_idx).locator("td.money-cell").nth(ap_idx).click()
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=120000)
        got = pg.evaluate(f"{vm}.drillTotalV()")
        want = pg.evaluate(f"{vm}.buAggItems()[{s_idx}].actualAp")
        check("sector AP drill total ties to the cell", abs(got - want) < 0.01, (got, want))
        pg.evaluate(f"{vm}.closeDrawer()")
        pg.screenshot(path=OUT + "/en_sector.png", full_page=False)

        # 8. criteria change while on an agg tab refetches the aggregation
        sector = pg.evaluate(f"{vm}.buAggItems()[0].sector")
        pg.evaluate(f"{vm}.buSector('{sector}'); {vm}.runButil(0);")
        pg.wait_for_function(
            f"() => !{vm}.buLoading() && !{vm}.buAggLoading()", timeout=120000)
        ok_scope = pg.evaluate(
            f"{vm}.buAggItems().every(function(r){{return r.sector==='{sector}'}})")
        check("search re-scopes the sector tab", ok_scope)
        pg.evaluate(f"{vm}.buSector(''); {vm}.runButil(0);")
        pg.wait_for_function(f"() => !{vm}.buLoading() && !{vm}.buAggLoading()", timeout=120000)

        # 9. back to Budget Line: table + pager restored
        pills.nth(0).click()
        check("line table restored", pg.locator("#pg-butil table.actuals-tbl").first.is_visible())
        check("pager restored", pg.locator("#pg-butil .bu-pager").is_visible())

        # 10. Arabic + RTL
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_function("document.documentElement.dir==='rtl'", timeout=30000)
        ar = pg.locator("#pg-butil .bu-lvl-tab").nth(1).inner_text().strip()
        check("AR dept pill label", "الإدارة" in ar, ar)
        pills.nth(1).click()
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buLevel()==='dept'", timeout=120000)
        check("AR agg table renders", pg.locator("#pg-butil .bu-agg-tbl tbody tr").count() > 0)
        check("AR strip label", pg.evaluate(f"{vm}.buLvlSum().nl") == "الإدارات")
        pg.screenshot(path=OUT + "/ar_dept.png", full_page=False)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_function("document.documentElement.dir==='ltr'", timeout=30000)

        if seed_id:
            pg.request.delete(BASE + "/ords/admin/gl/butilcmt/" + str(seed_id),
                              headers={"Authorization": "Bearer " + tok})
        check("no page errors", not errors, errors[:3])
        b.close()

    passed = sum(1 for _, ok in results if ok)
    print(f"\n{passed}/{len(results)} checks passed")
    if passed < len(results):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
