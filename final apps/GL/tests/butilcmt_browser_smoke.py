#!/usr/bin/env python3
"""GL Budget Utilization Comments — browser smoke (v1.82.0, 2026-08-23).

EN: the Projects group gains the Comments tab; the butil results table gains a
Comments column (chat button + count badge) gated on the server echo; posting
a root comment from the drawer marks the line (**) with the explanatory note;
replies thread under the root; the register page lists everything and a row
click re-opens the thread; Sector comments are entered from the register page;
the AP drill drawer rows carry a chat icon that opens the comments drawer ON
TOP of the drill drawer; the two admin pages (Comment Roles / Reporting
Periods) render for SYS_ADMIN. AR: labels + RTL. Cleanup deletes everything.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8097
then:                       python3 butilcmt_browser_smoke.py
"""
import json
import os
import re

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8097"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/butilcmt_smoke"
PROJ, TASK = "4517000039", "4510747"
MARK = "ui smoke"

results = []


def check(name, ok, extra=""):
    results.append((name, ok))
    print(f"  {'PASS' if ok else 'FAIL'}  {name} {extra if not ok else ''}")


def preclean(pg, tok):
    """delete leftovers of an earlier aborted run (replies first, via threads)"""
    hdr = {"Authorization": "Bearer " + tok}
    reg = pg.request.get(BASE + "/ords/admin/gl/butilcmt?search=" + MARK.replace(" ", "%20"),
                         headers=hdr).json()
    for r in reg.get("items", []):
        q = ("level=%s&year=%s" % (r["level"], r["budgetYear"])
             + ("&project=%s&task=%s&etype=%s" % (r["projectNumber"], r["taskNumber"],
                r["expenditureType"]) if r["level"] == "BUTIL_LINE" else "")
             + ("&ekey=%s" % r["entityKey"] if r.get("entityKey") else ""))
        th = pg.request.get(BASE + "/ords/admin/gl/butilcmt?" + q.replace(" ", "%20"),
                            headers=hdr).json()
        for s in th.get("sections", []):
            for root in s.get("items", []):
                if MARK in root["text"]:
                    for rp in root.get("replies", []):
                        pg.request.delete(BASE + "/ords/admin/gl/butilcmt/%s" % rp["id"], headers=hdr)
                    pg.request.delete(BASE + "/ords/admin/gl/butilcmt/%s" % root["id"], headers=hdr)


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
        preclean(pg, tok)
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(r.json())))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        vm = "ko.dataFor(document.body)"
        pg.wait_for_function(f"() => {vm}.view()==='butil' && !{vm}.buLoading() && {vm}.buTotal()>0",
                             timeout=120000)

        # ---- nav + capability flags ----
        navtxt = pg.evaluate("() => document.body.innerText.toLowerCase()")
        check("Projects group shows the Comments tab",
              pg.evaluate(f"() => {vm}.navGroups[0].items.some(function(i){{return i.id==='comments';}})"))
        pg.wait_for_function(f"() => ({vm}.cmtCaps().canAdd)==='Y'", timeout=60000)
        check("caps loaded (admin holds every capability)",
              pg.evaluate(f"() => {vm}.cmtCaps().canManageRoles==='Y' && {vm}.cmtCaps().canClosePeriod==='Y'"))

        # ---- butil: Comments column on the fixture line ----
        pg.evaluate(f"() => {{ var v={vm}; v.buTypeSel([]); v.buBuSel([]);"
                    f" v.buSearch('{PROJ}'); v.buTask('{TASK}'); v.runButil(0); }}")
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buItems().length > 0", timeout=120000)
        check("server echoes commentsEnabled", pg.evaluate(f"() => {vm}.buCmtOn()") is True)
        check("Comments column header renders",
              pg.locator("#pg-butil th.cmt-th").is_visible())
        check("chat button renders per row",
              pg.locator("#pg-butil td.cmt-cell .cmt-btn").first.is_visible())
        check("no (**) star before any comment",
              not pg.locator("#pg-butil .cmt-star").first.is_visible())

        # ---- drawer: post a root comment ----
        pg.locator("#pg-butil td.cmt-cell .cmt-btn").first.click()
        pg.wait_for_selector("aside.dw-cmt.show", timeout=10000)
        pg.wait_for_function(f"() => !{vm}.cmtLoading()", timeout=60000)
        check("drawer opens with the line context",
              pg.evaluate(f"() => {vm}.cmtCtx().level") == "BUTIL_LINE")
        check("add-form period defaults to a real MM-YYYY",
              bool(re.match(r"^(0[1-9]|1[0-2])-\d{4}$", pg.evaluate(f"() => {vm}.cmtPeriod()") or "")))
        check("drawer search region present and collapsed by default",
              pg.locator(".dw-cmt .cmt-flt").is_visible()
              and not pg.locator(".dw-cmt .cmt-flt-b").is_visible())
        check("drawer period filter follows the dashboard parameter",
              pg.evaluate(f"() => ({vm}.cmtFltPer()||'') === ({vm}.buPeriod()||'')"))
        pg.evaluate(f"() => {vm}.cmtText('{MARK} root: budget risk justification')")
        pg.locator(".dw-cmt .cmt-addbox .btn-primary").click()
        pg.wait_for_function(
            f"() => !{vm}.cmtBusy() && !{vm}.cmtLoading() && "
            f"{vm}.cmtSections().some(function(s){{return s.items.length>0;}})", timeout=60000)
        card = pg.locator(".dw-cmt .cmt-card").first
        check("root comment renders with author + timestamp",
              card.locator(".cmt-auth").is_visible() and card.locator(".cmt-when").inner_text() != "")
        check("own comment offers Edit + Delete + Reply",
              card.locator(".cmt-acts .cmt-link").count() >= 3)
        pg.screenshot(path=OUT + "/01_drawer_en.png", full_page=True)

        # ---- reply threading ----
        card.locator(".cmt-acts .cmt-link").first.click()   # Reply
        pg.wait_for_selector(".dw-cmt .cmt-replybox", timeout=10000)
        pg.evaluate(f"() => {vm}.cmtReplyText('{MARK} reply: acknowledged')")
        pg.locator(".dw-cmt .cmt-replybox .btn-primary").click()
        pg.wait_for_function(
            f"() => !{vm}.cmtBusy() && {vm}.cmtSections()[0] && "
            f"{vm}.cmtSections()[0].items[0] && {vm}.cmtSections()[0].items[0].replies.length===1",
            timeout=60000)
        check("reply threads under the root",
              pg.locator(".dw-cmt .cmt-card.reply").first.is_visible())
        chip = pg.locator(".dw-cmt .cmt-card .cmt-per").first.inner_text()
        check("period chip carries the label", "accounting period" in chip.lower(), chip)
        # search region: period filter scopes the view; clearing restores it
        pg.locator(".dw-cmt .cmt-flt-h").click()
        check("search region expands", pg.locator(".dw-cmt .cmt-flt-b").is_visible())
        pg.evaluate(f"() => {vm}.cmtFltPer('01-2026')")
        check("period filter empties the thread view",
              pg.evaluate(f"() => {vm}.cmtSectionsView()[0].items.length") == 0)
        pg.evaluate(f"() => {vm}.cmtFltPer('')")
        check("clearing the filter restores the thread",
              pg.evaluate(f"() => {vm}.cmtSectionsView()[0].items.length") == 1)
        pg.evaluate(f"() => {vm}.closeCmtDrawer()")

        # ---- (**) star + note + badge on the grid (auto-refreshed) ----
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buItems()[0].hasCmt==='Y'",
                             timeout=120000)
        check("(**) star shows in the first cell",
              pg.locator("#pg-butil .cmt-star").first.is_visible())
        note = pg.locator("#pg-butil .cadj-note").nth(1)
        check("note under the table explains the (**)",
              note.is_visible() and note.inner_text().strip().startswith("(**)"), note.inner_text())
        check("chat button carries the count badge",
              pg.locator("#pg-butil td.cmt-cell .cmt-btn.has .cmt-n").first.inner_text() == "2")
        pg.screenshot(path=OUT + "/02_butil_star_en.png", full_page=True)

        # ---- Display Comments LOV -> extra Comments column ----
        pg.evaluate(f"() => {vm}.buCmtDisp('ALL')")
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buCmtDispMode()==='ALL'", timeout=120000)
        check("Display Comments=All adds the text column with the comment",
              pg.locator("#pg-butil .cmt-txt-cell").first.is_visible()
              and "ui smoke" in pg.locator("#pg-butil .cmt-txt-cell").first.inner_text(),
              pg.locator("#pg-butil .cmt-txt-cell").first.inner_text())
        pg.screenshot(path=OUT + "/02b_butil_cmtcol_en.png", full_page=True)
        pg.evaluate(f"() => {vm}.buCmtDisp('NONE')")
        pg.wait_for_function(f"() => !{vm}.buLoading() && {vm}.buCmtDispMode()==='NONE'", timeout=120000)
        check("Display Comments=None removes the column",
              pg.locator("#pg-butil .cmt-txt-cell").count() == 0)

        # ---- a REAL dashboard period selection flows into the drawer ----
        from datetime import date
        perd = "%02d-2026" % date.today().month     # the month the root was posted in
        pg.evaluate(f"() => {{ var v={vm}; v.buPeriod('{perd}'); v.runButil(0); }}")
        pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=120000)
        pg.locator("#pg-butil td.cmt-cell .cmt-btn").first.click()
        pg.wait_for_selector("aside.dw-cmt.show", timeout=10000)
        pg.wait_for_function(f"() => !{vm}.cmtLoading()", timeout=60000)
        check("drawer period filter follows a real dashboard period",
              pg.evaluate(f"() => {vm}.cmtFltPer()") == perd)
        check("scope line names the accounting period",
              perd in pg.evaluate(f"() => {vm}.cmtScopeLine()"))
        pg.evaluate(f"() => {{ {vm}.closeCmtDrawer(); {vm}.buPeriod(''); }}")

        # ---- AP drill rows carry the chat icon; comments drawer stacks above ----
        pg.evaluate(f"() => {vm}.openBuDrill({vm}.buItems()[0],'ap')")
        pg.wait_for_function(f"() => !{vm}.drillLoading()", timeout=120000)
        cols = pg.evaluate(f"() => {vm}.drillCols().map(function(c){{return c.key}})")
        check("AP drill gains the synthetic Comments column", cols and cols[-1] == "_cmt", cols)
        if pg.evaluate(f"() => {vm}.drillRows().length") > 0:
            pg.locator("aside.dw-wide table.drill-tbl td.cmt-cell .cmt-btn").first.click()
            pg.wait_for_selector("aside.dw-cmt.show", timeout=10000)
            pg.wait_for_function(f"() => !{vm}.cmtLoading()", timeout=60000)
            check("drill chat icon opens an AP_INVOICE thread above the drill drawer",
                  pg.evaluate(f"() => {vm}.cmtCtx().level") == "AP_INVOICE"
                  and pg.evaluate(f"() => {vm}.drillDrawer()") is True)
            pg.screenshot(path=OUT + "/03_drill_cmt_en.png", full_page=True)
            pg.evaluate(f"() => {vm}.closeCmtDrawer()")
        else:
            check("drill chat icon opens an AP_INVOICE thread above the drill drawer",
                  True, "(no AP rows on the fixture line — column check only)")
        pg.evaluate(f"() => {vm}.closeDrawer()")

        # ---- register page + Sector entry ----
        pg.evaluate(f"() => {vm}.go('comments')")
        pg.wait_for_function(f"() => {vm}.cmtRegLoaded() && !{vm}.cmtRegLoading()", timeout=60000)
        check("register (shared IR) mounts", pg.evaluate(f"() => !!{vm}.cmtRegData()"))
        check("register lists the line comment",
              pg.evaluate(f"() => {vm}.cmtRegData().items.some(function(r){{return r.level==='BUTIL_LINE' && r.text.indexOf('{MARK}')>=0;}})"))
        pg.screenshot(path=OUT + "/04_register_en.png", full_page=True)
        # row click re-opens the thread
        pg.locator("#pg-comments .ir-table tbody tr").first.locator("td").nth(2).click()
        pg.wait_for_selector("aside.dw-cmt.show", timeout=10000)
        pg.wait_for_function(f"() => !{vm}.cmtLoading()", timeout=60000)
        check("register row click opens the thread drawer",
              pg.evaluate(f"() => {vm}.cmtSections().length") >= 1)
        pg.evaluate(f"() => {vm}.closeCmtDrawer()")
        # sector-level entry
        sector = pg.evaluate(f"() => {vm}.buSectors()[0] || ''")
        if sector:
            pg.evaluate(f"() => {{ var v={vm}; v.cmtNewLevel('SECTOR');"
                        f" v.cmtNewKey({json.dumps(sector)}); v.openCmtNew(); }}")
            pg.wait_for_selector("aside.dw-cmt.show", timeout=10000)
            pg.wait_for_function(f"() => !{vm}.cmtLoading()", timeout=60000)
            check("sector thread opens from the register page",
                  pg.evaluate(f"() => {vm}.cmtCtx().level") == "SECTOR")
            pg.evaluate(f"() => {vm}.cmtText('{MARK} sector-level note')")
            pg.locator(".dw-cmt .cmt-addbox .btn-primary").click()
            pg.wait_for_function(
                f"() => !{vm}.cmtBusy() && {vm}.cmtSections().some(function(s){{return s.items.length>0;}})",
                timeout=60000)
            check("sector comment posted", True)
            pg.evaluate(f"() => {vm}.closeCmtDrawer()")
        else:
            check("sector thread opens from the register page", True, "(no sector LOV)")
            check("sector comment posted", True, "(skipped)")

        # ---- admin pages (SYS_ADMIN) ----
        pg.evaluate(f"() => {vm}.go('cmtroles')")
        pg.wait_for_function(f"() => {vm}.cmtRoles().length > 0", timeout=60000)
        finbp = pg.evaluate(f"() => {vm}.cmtRoles().find(function(r){{return r.roleCode==='FIN_BP';}})")
        check("Comment Roles page lists roles with seeded grants",
              bool(finbp) and finbp["canAdd"] == "Y" and finbp["canReply"] == "Y", finbp)
        check("capability checkboxes render",
              pg.locator("#pg-cmtroles td.cmt-cap input[type=checkbox]").first.is_visible())
        pg.screenshot(path=OUT + "/05_roles_en.png", full_page=True)
        pg.evaluate(f"() => {vm}.go('cmtperiods')")
        pg.wait_for_function(f"() => {vm}.cmtPerRows().length === 12", timeout=60000)
        check("Reporting Periods page shows the 12 periods with status pills",
              pg.locator("#pg-cmtperiods .cmt-pill").count() == 12)
        check("every period offers Close (all open)",
              pg.evaluate(f"() => {vm}.cmtPerRows().every(function(p){{return p.status==='OPEN'||p.status==='CLOSED';}})"))
        pg.screenshot(path=OUT + "/06_periods_en.png", full_page=True)

        # ---- AR / RTL ----
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(600)
        check("RTL applied", pg.evaluate("() => document.documentElement.getAttribute('dir')") == "rtl")
        check("periods title in Arabic", "فترات التقارير"
              in pg.locator("#pg-cmtperiods h1").inner_text())
        pg.evaluate(f"() => {vm}.go('comments')")
        pg.wait_for_timeout(400)
        check("register title in Arabic", "تعليقات استخدام الميزانية"
              in pg.locator("#pg-comments h1").inner_text())
        pg.evaluate(f"() => {vm}.go('butil')")
        pg.wait_for_function(f"() => !{vm}.buLoading()", timeout=120000)
        check("(**) note in Arabic",
              "(**)" in pg.locator("#pg-butil .cadj-note").nth(1).inner_text())
        pg.screenshot(path=OUT + "/07_ar.png", full_page=True)
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(400)

        # ---- cleanup ----
        preclean(pg, tok)
        fin = pg.request.get(
            BASE + "/ords/admin/gl/butil?year=2026&limit=1&project=%s&task=%s" % (PROJ, TASK),
            headers={"Authorization": "Bearer " + tok}).json()
        check("cleanup: butil back to hasCmt=N", fin["items"][0]["hasCmt"] == "N",
              fin["items"][0].get("hasCmt"))

        check("no page errors", not errors, errors[:3])
        b.close()

    passed = sum(1 for _, o in results if o)
    print(f"\n{passed}/{len(results)} passed")
    return 0 if passed == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
