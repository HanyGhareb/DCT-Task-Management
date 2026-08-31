#!/usr/bin/env python3
"""GL Budget Utilization — Fund Movement columns browser smoke (v1.94.0;
restored v1.96.2 — the columns were briefly removed on 2026-08-31, then the
user clarified they stay on the page AND join the register's Budget
Utilization Lines sheet; APPROVED transactions only since the same day).

EN: the Budget Line / Department / Sector tabs each carry Fund Movement Count
and Fund Movement Amount columns (header hints), a green/red additions-vs-
deductions popover on cell hover, and a cell click that opens the shared drill
drawer with the register Fund Movement sheet's 28 columns, a 2-way sort
switch, and a total that ties to the cell. Dept-tab CSV export carries the two
columns. AR: labels + popover in Arabic. Read-only — creates nothing.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
then:                       python3 fm_browser_smoke.py
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/fm_smoke"

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
        pg = b.new_page(viewport={"width": 1760, "height": 1000}, accept_downloads=True)
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
        pg.wait_for_function(
            f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
            timeout=120000)
        # the FM line map loads right after /butil — wait for it
        pg.wait_for_function(f"() => Object.keys({vm}.buFmLineMap()).length > 0", timeout=60000)

        # ── 1. line tab: headers + hints ───────────────────────────────────
        ths = pg.locator("#pg-butil table.actuals-tbl").first.locator("th")
        head = [t.strip().lower() for t in ths.all_inner_texts()]
        check("FM Count header on line tab", "fund movement count" in head, head)
        check("FM Amount header on line tab", "fund movement amount" in head)
        cnt_th = ths.nth(head.index("fund movement count"))
        check("Count header hint mentions the split",
              "additions and deductions" in (cnt_th.get_attribute("title") or ""),
              cnt_th.get_attribute("title"))
        amt_th = ths.nth(head.index("fund movement amount"))
        check("Amount header hint carries the formula",
              "additions − deductions" in (amt_th.get_attribute("title") or ""),
              amt_th.get_attribute("title"))

        # ── 2. find a visible row with fund movement (widen scope if needed) ──
        has_fm = pg.evaluate(
            f"() => {vm}.buItems().some(r => !!{vm}.fmOfRow(r))")
        if not has_fm:
            proj = pg.evaluate(f"Object.keys({vm}.buFmLineMap())[0].split('|')[0]")
            pg.evaluate(f"() => {{ {vm}.buTypeSel([]); {vm}.buSearch('{proj}'); {vm}.runButil(0); }}")
            pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buItems().length>0", timeout=60000)
            has_fm = pg.evaluate(f"() => {vm}.buItems().some(r => !!{vm}.fmOfRow(r))")
        check("a visible row carries fund movement", has_fm)
        row_ix = pg.evaluate(f"() => {vm}.buItems().findIndex(r => !!{vm}.fmOfRow(r))")
        fm = pg.evaluate(f"() => {vm}.fmOfRow({vm}.buItems()[{row_ix}])")
        check("row stats coherent", fm["cnt"] == fm["posCnt"] + fm["negCnt"]
              and abs(fm["amt"] - (fm["posAmt"] + fm["negAmt"])) < 0.01, fm)

        tr = pg.locator("#pg-butil table.actuals-tbl").first.locator("tbody tr").nth(row_ix)
        tds = tr.locator("td")
        n_td = tds.count()
        # FM cells sit right after Fund Available; comments cells may follow
        cmt_extra = pg.evaluate(f"() => ({vm}.buCmtOn() ? 1 : 0) + ({vm}.buCmtDispMode() !== 'NONE' ? 1 : 0)")
        fm_cnt_td, fm_amt_td = tds.nth(n_td - 2 - cmt_extra), tds.nth(n_td - 1 - cmt_extra)
        check("count cell shows the count",
              fm_cnt_td.inner_text().strip().replace(",", "") == str(fm["cnt"]),
              (fm_cnt_td.inner_text(), fm["cnt"]))
        cls = fm_amt_td.get_attribute("class") or ""
        check("amount cell tinted by sign",
              ("fm-pos" in cls) == (fm["amt"] > 0) and ("fm-neg" in cls) == (fm["amt"] < 0), cls)

        # ── 3. hover popover: green/red split ──────────────────────────────
        fm_amt_td.hover()
        pg.wait_for_selector(".fm-tip", state="visible", timeout=10000)
        tip = pg.locator(".fm-tip").inner_text().lower()
        check("popover shows additions/deductions/net",
              "additions" in tip and "deductions" in tip and "net" in tip, tip)
        check("popover carries both counts",
              str(fm["posCnt"]) in tip and str(fm["negCnt"]) in tip, tip)
        pg.mouse.move(5, 5)
        pg.wait_for_selector(".fm-tip", state="hidden", timeout=10000)
        check("popover hides on leave", True)
        pg.screenshot(path=OUT + "/01_line_cols.png")

        # ── 4. cell click -> drill drawer ties to the cell ─────────────────
        fm_cnt_td.evaluate("el => el.click()")
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=60000)
        check("drawer title = Fund Movement",
              "fund movement" in pg.evaluate(f"{vm}.drillTitle()").lower())
        check("drawer has the 28 sheet columns",
              pg.evaluate(f"{vm}.drillCols().length") == 28,
              pg.evaluate(f"{vm}.drillCols().length"))
        check("drawer count ties to cell", pg.evaluate(f"{vm}.drillCount()") == fm["cnt"])
        check("drawer total ties to cell",
              abs(pg.evaluate(f"{vm}.drillTotalV()") - fm["amt"]) < 0.01)
        check("sort switch visible", pg.locator(".fm-sortbar").is_visible())
        check("sort switch has 2 options", pg.locator(".fm-sortbar .btn").count() == 2)
        first_default = pg.evaluate(f"() => ({vm}.drillRows()[0]||{{}}).trxNum")
        pg.locator(".fm-sortbar .btn").nth(1).click()
        pg.wait_for_function(f"() => !{vm}.drillLoading()", timeout=60000)
        check("date sort keeps count", pg.evaluate(f"{vm}.drillCount()") == fm["cnt"])
        check("date sort re-orders (dates ascending)", pg.evaluate(
            f"() => {vm}.drillRows().every((r,i,a) => i===0 || a[i-1].trxDate <= r.trxDate)"))
        # amount column tinted in the drawer too
        check("drawer amount cells tinted",
              pg.locator(".dw-drawer .drill-tbl td.fm-pos, .dw-drawer .drill-tbl td.fm-neg").count() > 0)
        # v1.95.0: styled 10-segment popover on the Code Combination column
        combo_td = pg.locator(".dw-drawer .drill-tbl tbody tr td:nth-child(5)")
        c_ix = next((i for i in range(combo_td.count())
                     if combo_td.nth(i).inner_text().strip()), None)
        check("a drill row carries a combination", c_ix is not None)
        combo_td.nth(c_ix).hover()
        pg.wait_for_selector(".combo-tip", state="visible", timeout=10000)
        check("combination popover opens in the drawer", True)
        check("popover lists the 10 segments", pg.evaluate(f"{vm}.tipRows().length") == 10,
              pg.evaluate(f"{vm}.tipRows().length"))
        check("popover resolves descriptions", pg.evaluate(
            f"() => {vm}.tipRows().filter(r => r.desc).length > 0"))
        pg.mouse.move(5, 5)
        # v1.95.0: status pills with icons on the 5 status columns
        pills = pg.locator(".dw-drawer .drill-tbl .st")
        check("status pills render in the drawer", pills.count() > 0, pills.count())
        check("positive statuses tone ok (green ✓)", pg.evaluate(
            "() => { const p=[...document.querySelectorAll('.dw-drawer .drill-tbl .st')]"
            ".filter(e => /baselined|success|pass|approved/i.test(e.textContent));"
            "return p.length>0 && p.every(e => e.classList.contains('st--ok')); }"))
        check("no err tone on positive words", pg.evaluate(
            "() => [...document.querySelectorAll('.dw-drawer .drill-tbl .st--err')]"
            ".every(e => /fail|error|reject/i.test(e.textContent))"))
        pg.screenshot(path=OUT + "/02_drill.png")
        pg.evaluate(f"{vm}.closeDrawer()")

        # ── 5. Department tab: group columns + drill ───────────────────────
        pg.evaluate(f"{vm}.setBuLevel('dept')")
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buAggItems().length>0 "
            f"&& Object.keys({vm}.buFmAggMap()).length>0", timeout=90000)
        aths = [t.strip().lower() for t in
                pg.locator("#pg-butil .bu-agg-tbl th").all_inner_texts()]
        check("FM headers on Department tab",
              "fund movement count" in aths and "fund movement amount" in aths, aths)
        g_ix = pg.evaluate(f"() => {vm}.buAggItems().findIndex(r => !!{vm}.fmOfGrp(r))")
        check("a group row carries fund movement", g_ix >= 0)
        gfm = pg.evaluate(f"() => {vm}.fmOfGrp({vm}.buAggItems()[{g_ix}])")
        gtr = pg.locator("#pg-butil .bu-agg-tbl tbody tr").nth(g_ix)
        gtds = gtr.locator("td")
        g_cmt = pg.evaluate(f"() => {vm}.buCmtOn() ? 1 : 0")
        g_cnt_td = gtds.nth(gtds.count() - 2 - g_cmt)
        check("group count cell shows the count",
              g_cnt_td.inner_text().strip().replace(",", "") == str(gfm["cnt"]),
              (g_cnt_td.inner_text(), gfm["cnt"]))
        g_cnt_td.evaluate("el => el.click()")
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=60000)
        check("group drill count ties", pg.evaluate(f"{vm}.drillCount()") == gfm["cnt"],
              (pg.evaluate(f"{vm}.drillCount()"), gfm["cnt"]))
        check("group drill total ties",
              abs(pg.evaluate(f"{vm}.drillTotalV()") - gfm["amt"]) < 0.01)
        pg.screenshot(path=OUT + "/03_dept_drill.png")
        pg.evaluate(f"{vm}.closeDrawer()")
        # unattributed-transfers note matches the computed remainder
        extra = pg.evaluate(f"() => {vm}.buFmAggExtra()")
        note_vis = pg.evaluate(
            "() => [...document.querySelectorAll('#pg-butil .cadj-note')]"
            ".some(n => n.offsetParent && /transfer lines/.test(n.textContent))")
        check("remainder note tracks buFmAggExtra", bool(extra) == note_vis, (extra, note_vis))

        # dept CSV export carries the two columns
        with pg.expect_download() as dl:
            pg.evaluate(f"{vm}.buExportCsv()")
        head_csv = open(dl.value.path(), encoding="utf-8-sig").readline()
        check("dept CSV carries FM columns",
              "Fund Movement Count" in head_csv and "Fund Movement Amount" in head_csv, head_csv)

        # ── 6. Sector tab ──────────────────────────────────────────────────
        pg.evaluate(f"{vm}.setBuLevel('sector')")
        pg.wait_for_function(
            f"() => !{vm}.buAggLoading() && {vm}.buAggItems().length>0", timeout=90000)
        # the FM agg map re-fetches per level (dept keys are CCs, sector keys are
        # sector names) — wait until a sector row actually resolves
        pg.wait_for_function(
            f"() => {vm}.buAggItems().some(r => !!{vm}.fmOfGrp(r))", timeout=60000)
        s_ix = pg.evaluate(f"() => {vm}.buAggItems().findIndex(r => !!{vm}.fmOfGrp(r))")
        check("a sector row carries fund movement", s_ix >= 0)
        sfm = pg.evaluate(f"() => {vm}.fmOfGrp({vm}.buAggItems()[{s_ix}])")
        str_ = pg.locator("#pg-butil .bu-agg-tbl tbody tr").nth(s_ix)
        stds = str_.locator("td")
        s_amt_td = stds.nth(stds.count() - 1 - g_cmt)
        s_amt_td.evaluate("el => el.click()")
        pg.wait_for_function(f"() => {vm}.drillDrawer() && !{vm}.drillLoading()", timeout=60000)
        check("sector drill ties", pg.evaluate(f"{vm}.drillCount()") == sfm["cnt"],
              (pg.evaluate(f"{vm}.drillCount()"), sfm["cnt"]))
        pg.evaluate(f"{vm}.closeDrawer()")

        # ── 7. Arabic / RTL ────────────────────────────────────────────────
        pg.evaluate("document.querySelector('button[data-bind*=\"toggleLang\"]').click()")
        pg.wait_for_function("document.documentElement.dir === 'rtl'", timeout=30000)
        pg.evaluate(f"{vm}.setBuLevel('line')")
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buItems().length>0", timeout=60000)
        ths_ar = " ".join(pg.locator("#pg-butil table.actuals-tbl").first
                          .locator("th").all_inner_texts())
        check("AR FM headers", "عدد حركات التمويل" in ths_ar and "مبلغ حركات التمويل" in ths_ar)
        row_ix2 = pg.evaluate(f"() => {vm}.buItems().findIndex(r => !!{vm}.fmOfRow(r))")
        check("AR rows still map", row_ix2 >= 0)
        tr2 = pg.locator("#pg-butil table.actuals-tbl").first.locator("tbody tr").nth(row_ix2)
        tds2 = tr2.locator("td")
        cmt_extra2 = pg.evaluate(f"() => ({vm}.buCmtOn() ? 1 : 0) + ({vm}.buCmtDispMode() !== 'NONE' ? 1 : 0)")
        tds2.nth(tds2.count() - 1 - cmt_extra2).hover()
        pg.wait_for_selector(".fm-tip", state="visible", timeout=10000)
        tip_ar = pg.locator(".fm-tip").inner_text()
        check("AR popover", "إضافات" in tip_ar and "خصومات" in tip_ar and "الصافي" in tip_ar, tip_ar)
        pg.screenshot(path=OUT + "/04_ar.png")
        # restore EN for the shared account (GL persists lang in localStorage only)
        pg.evaluate("document.querySelector('button[data-bind*=\"toggleLang\"]').click()")

        check("no page errors", not errors, errors[:3])
        b.close()

    passed = sum(1 for _, o in results if o)
    print(f"\n{passed}/{len(results)} passed")
    raise SystemExit(0 if passed == len(results) else 1)


if __name__ == "__main__":
    main()
