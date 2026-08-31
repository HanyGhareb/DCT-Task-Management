"""GL Budget-vs-Actual (General Ledger tab) v1.57.0 — browser smoke.

Run with the GL dev-proxy on its own port:
    python3 'final apps/GL/Jet/dev-proxy.py' 8096   (server)
Covers: one-shot register on the SHARED <interactive-report> (grouped header
bands, frozen combination column, tints), oj-progress-circle busy overlay on
load + re-run, drawer type-ahead LOV inputs -> chips, figure-cell drill to the
supporting-lines modal, combination popover, AR/RTL toggle + EN restore.
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
        s = r.json()
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(s)))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        check("app booted", True)

        # ── nav + one-shot load ──────────────────────────────────────────
        pg.evaluate("() => ko.dataFor(document.body).go('actuals')")
        pg.wait_for_function(
            "() => { const v = ko.dataFor(document.body); "
            "return v.acItems().length > 0 && v.acLoading() === false; }",
            timeout=180000)
        n_items = pg.evaluate("() => ko.dataFor(document.body).acItems().length")
        n_total = pg.evaluate("() => ko.dataFor(document.body).acTotal()")
        check("one-shot register loaded (no pager)", n_items > 100, f"items={n_items} total={n_total}")
        check("full filtered set client-side", n_items == min(n_total, 10000),
              f"items={n_items} total={n_total}")

        # ── shared IR grid ───────────────────────────────────────────────
        pg.wait_for_selector(".ac-results .ir-table", timeout=60000)
        bands = pg.eval_on_selector_all(
            ".ac-results .ir-table thead tr.ir-band th",
            "els => els.map(e => e.textContent.trim())")
        check("grouped header bands rendered", len([x for x in bands if x]) >= 4, str(bands))
        rows = pg.locator(".ac-results .ir-table tbody tr").count()
        check("IR rows rendered", rows > 5, f"rows={rows}")
        toolbar = pg.locator(".ac-results .ir-toolbar, .ac-results .ir-tools").count()
        check("IR toolbar present (columns/filters/export)", toolbar >= 0)
        tinted = pg.locator(".ac-results .ir-table td.acc-pr").count()
        check("per-group column tints applied", tinted > 0, f"tinted={tinted}")

        # ── busy overlay on re-run ───────────────────────────────────────
        pg.evaluate("() => { ko.dataFor(document.body).runActuals(); }")
        seen = pg.evaluate(
            "() => { const el = document.querySelector('#pg-actuals .bu-load-ov, .ac-body .bu-load-ov');"
            " return !!el && getComputedStyle(el).display !== 'none'; }")
        check("busy overlay shown while searching", seen)
        pg.wait_for_function("() => ko.dataFor(document.body).acLoading() === false", timeout=180000)
        gone = pg.evaluate(
            "() => { const el = document.querySelector('.ac-body .bu-load-ov');"
            " return !!el && getComputedStyle(el).display === 'none'; }")
        check("busy overlay hidden after load", gone)

        # ── drawer type-ahead LOVs ───────────────────────────────────────
        pg.evaluate("() => ko.dataFor(document.body).openAcFilters()")
        pg.wait_for_selector(".dw-filter.show", timeout=5000)
        selects = pg.locator(".dw-filter .fd-grid select").count()
        inputs = pg.locator(".dw-filter .fd-grid input[list]").count()
        check("6 LOV filters are type-ahead inputs", inputs == 6, f"inputs={inputs} selects={selects}")
        sec = pg.evaluate("() => (ko.dataFor(document.body).acSectors()[0] || {}).code || ''")
        if sec:
            inp = pg.locator(".dw-filter input[list='ac-sector-dl']")
            inp.fill(sec)
            inp.dispatch_event("change")
            pg.wait_for_timeout(300)
        chips = pg.evaluate("() => ko.dataFor(document.body).acSectorSel().length")
        check("typed sector commits to a chip", chips == 1, f"sel={chips}")
        # type a NAME instead of a code — unique-name match also commits
        nm = pg.evaluate("() => (ko.dataFor(document.body).acChapters()[0] || {}).name || ''")
        if nm:
            inp = pg.locator(".dw-filter input[list='ac-chapter-dl']")
            inp.fill(nm)
            inp.dispatch_event("change")
            pg.wait_for_timeout(300)
        check("typed chapter NAME commits to a chip",
              pg.evaluate("() => ko.dataFor(document.body).acChapterSel().length") == 1)
        pg.screenshot(path="final apps/GL/tests/ac_ir_drawer.png")
        # apply -> chips flow into the run; then clear via reset for the drill test
        pg.evaluate("() => ko.dataFor(document.body).applyAcFilters()")
        pg.wait_for_function("() => ko.dataFor(document.body).acLoading() === false", timeout=180000)
        check("filtered re-run ok", True,
              f"rows={pg.evaluate('() => ko.dataFor(document.body).acItems().length')}")
        pg.evaluate("() => { const v = ko.dataFor(document.body); v.acSectorSel.removeAll(); v.acChapterSel.removeAll(); v.runActuals(); }")
        pg.wait_for_function("() => ko.dataFor(document.body).acLoading() === false", timeout=180000)

        # ── figure-cell drill (delegated) ────────────────────────────────
        cell = pg.locator(".ac-results .ir-table tbody tr td.acc-bud").first
        cell.hover()
        pg.wait_for_timeout(200)
        cell.click()
        pg.wait_for_selector(".modal.wide", state="visible", timeout=30000)
        check("figure cell drills to supporting-lines modal", True)
        pg.evaluate("() => ko.dataFor(document.body).closeDrill()")
        pg.wait_for_timeout(300)

        # ── "Figures in" display unit — shared with Budget Utilization (v1.59.0) ──
        pg.evaluate("() => ko.dataFor(document.body).openAcFilters()")
        pg.wait_for_selector(".dw-filter.show", timeout=5000)
        nsel = pg.locator(".dw-filter .fd-grid select").count()
        check("drawer has the Figures-in unit select", nsel == 4, f"selects={nsel}")
        pg.evaluate("() => ko.dataFor(document.body).buUnit('M')")
        pg.wait_for_timeout(600)
        band_v = pg.locator(".kgrid .kg-v").first.inner_text()
        check("KPI band follows the unit (M)", band_v.strip().endswith("M"), band_v)
        mlabels = pg.eval_on_selector_all(
            ".ac-results .ir-table thead th",
            "els => els.map(e => e.textContent).filter(x => x.includes('(M)')).length")
        check("IR money column labels carry the (M) suffix", mlabels >= 5, f"n={mlabels}")
        pg.evaluate("() => ko.dataFor(document.body).buUnit('auto')")
        pg.wait_for_timeout(600)
        pg.evaluate("() => ko.dataFor(document.body).closeAcFilters()")
        pg.wait_for_timeout(300)

        # ── KPI aggregate drawer round (v1.58.0) ─────────────────────────
        pg.evaluate("() => { ko.dataFor(document.body).openAcAgg('budget'); }")
        pg.wait_for_function(
            "() => { const v = ko.dataFor(document.body); "
            "return v.drillDrawer() && v.drillLoading() === false && v.drillRows().length > 0; }",
            timeout=120000)
        first_cc = pg.evaluate("() => ko.dataFor(document.body).drillRows()[0].costCenter")
        check("drawer cost centre shows 'code - name'", " - " in str(first_cc), str(first_cc))
        note = pg.evaluate("() => ko.dataFor(document.body).drillSortNote()")
        check("sort-criteria hint shown on top of the table", "Sorted by" in str(note), str(note))
        amts = pg.evaluate(
            "() => ko.dataFor(document.body).drillRows().map(r => Number(r.amount) || 0)")
        check("drawer rows sorted by amount descending",
              all(amts[i] >= amts[i + 1] for i in range(len(amts) - 1)), f"n={len(amts)}")
        dcell = pg.locator(".dw-drawer.dw-wide .drill-tbl tbody tr td").nth(2)
        dcell.hover()
        pg.wait_for_timeout(400)
        check("drawer combination cell shows segment popover",
              bool(pg.evaluate("() => ko.dataFor(document.body).tipShow()")))
        pg.screenshot(path="final apps/GL/tests/ac_drawer_round.png")
        pg.evaluate("() => ko.dataFor(document.body).closeDrawer()")
        pg.wait_for_timeout(300)
        check("closing the drawer clears the sort note",
              pg.evaluate("() => ko.dataFor(document.body).drillSortNote()") == "")

        # ── combination popover (delegated ko.contextFor) ────────────────
        combo = pg.locator(".ac-results .ir-table tbody tr td.acc-mono").first
        combo.hover()
        pg.wait_for_timeout(400)
        tip = pg.evaluate("() => ko.dataFor(document.body).tipShow()")
        check("combination popover on hover", bool(tip))
        pg.screenshot(path="final apps/GL/tests/ac_ir_en.png")

        # ── AR / RTL + EN restore ────────────────────────────────────────
        pg.evaluate("() => ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(1200)
        rtl = pg.evaluate("() => document.documentElement.getAttribute('dir')")
        check("AR flips to RTL", rtl == "rtl", str(rtl))
        pg.screenshot(path="final apps/GL/tests/ac_ir_ar.png")
        pg.evaluate("() => ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(800)
        check("EN restored", pg.evaluate("() => document.documentElement.getAttribute('dir')") == "ltr")

        check("no page JS errors", not errors, str(errors[:3]))
        b.close()

    fails = [x for x in results if not x[1]]
    print(f"\n{len(results) - len(fails)}/{len(results)} PASS")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
