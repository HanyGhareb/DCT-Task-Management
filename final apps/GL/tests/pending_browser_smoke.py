#!/usr/bin/env python3
"""GL app — "Encumbrances - Pending Approval" tab browser smoke (EN + AR/RTL).

Run via the webapp-testing helper (GL dev-proxy on its own port — never fight
over 8080):

  python scripts/with_server.py \
    --server "python3 '/root/DCT-Task-Management/final apps/GL/Jet/dev-proxy.py' 8098" --port 8098 \
    -- python3 "/root/DCT-Task-Management/final apps/GL/tests/pending_browser_smoke.py"

Conventions (see CLAUDE.md):
  * credentials come from the Admin quick-login source at runtime;
  * routes are driven BY ID via the VM (ko.dataFor(document.body).go('pending')),
    never by visible (translated) text;
  * the language toggle is restored to EN before exit.
"""
import json
import re
import sys
import urllib.request

BASE = "http://localhost:8098"
AUTH_SRC = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"

ok = fail = 0
def check(name, cond, extra=""):
    global ok, fail
    if cond:
        ok += 1; print("  PASS  %s %s" % (name, extra))
    else:
        fail += 1; print("  FAIL  %s %s" % (name, extra))

def login():
    user, pw = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                          open(AUTH_SRC).read())[0]
    req = urllib.request.Request(BASE + "/ords/admin/dct/auth/login",
                                 data=json.dumps({"username": user, "password": pw}).encode(),
                                 method="POST", headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read())

def main():
    from playwright.sync_api import sync_playwright

    session = login()
    check("login (via dev-proxy)", bool(session.get("sessionId")))

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        pg = browser.new_page(viewport={"width": 1600, "height": 1000})
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(session)))
        pg.goto(BASE + "/index.html")
        # networkidle never settles (CDN scripts + proxied ORDS keep-alives) —
        # wait for the KO app itself to be bound instead
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)

        # ── EN: navigate by id and let /gl/pending load ──
        check("nav tab present", pg.locator("nav.pnav a").count() == 9,
              "(%d tabs)" % pg.locator("nav.pnav a").count())
        pg.evaluate("ko.dataFor(document.body).go('pending')")
        pg.wait_for_function("ko.dataFor(document.body).pnLoaded()", timeout=120000)
        pend = pg.locator("div[data-bind=\"visible:view()==='pending'\"]").first
        check("page title", "Pending Approval" in pend.locator("h1.greet").inner_text())
        chip = pend.locator(".page-actions .chip").nth(1).inner_text()
        check("count chip", "pending lines" in chip, "(%s)" % chip)
        check("snapshot as-of chip", "Snapshot" in pend.locator(".page-actions .chip").nth(0).inner_text())
        check("briefing book button", pend.locator(".page-actions button.btn-primary").is_enabled())

        # KPI band: 4 composite tiles with non-empty values
        tiles = pend.locator(".bu-kpis .bk")
        check("4 KPI tiles", tiles.count() == 4)
        vals = [tiles.nth(i).locator(".bk-v").inner_text().strip() for i in range(tiles.count())]
        check("tile values non-empty", all(v and v != "—" for v in vals), str(vals))

        # aging + approver mini tables
        check("aging table 4 buckets", pend.locator(".pn-grid2 .pn-mini").nth(0).locator("tbody tr").count() == 4)
        apv_rows = pend.locator(".pn-grid2 .pn-mini").nth(1).locator("tbody tr").count()
        check("approver follow-up rows", 0 < apv_rows <= 8, "(%d)" % apv_rows)
        check("unmatched note", pend.locator(".pn-um").is_visible())

        # shared IR grid rendered with the pending columns
        pg.wait_for_selector("div[data-bind=\"visible:view()==='pending'\"] table.ir-table tbody tr")
        grid_rows = pend.locator("table.ir-table tbody tr").count()
        check("IR grid rows", grid_rows > 0, "(%d on page 1)" % grid_rows)
        # Chrome's innerText applies the header's text-transform — compare lower-case
        heads = [h.lower() for h in pend.locator("table.ir-table thead th").all_inner_texts()]
        check("IR pending columns", any("days pending" in h for h in heads)
              and any("pending with" in h for h in heads), "(%d heads)" % len(heads))

        # summary strip reconciles with the VM totals
        vm_amt = pg.evaluate("ko.dataFor(document.body).pnTotAmtTxt()")
        check("summary amount", vm_amt in pend.locator(".en-sum").inner_text(), "(%s)" % vm_amt)

        # KPI cross-check against the VM's server aggregates
        kpis = pg.evaluate("ko.dataFor(document.body).pnKpis()")
        check("kpis docs = PR + PO", kpis["docs"] == kpis["docsPr"] + kpis["docsPo"], str(kpis["docs"]))
        check("kpis reserved + unreserved = total",
              abs(kpis["reservedAmt"] + kpis["unreservedAmt"] - kpis["amtTotal"]) < 1)

        # v1.28.0 — redesigned KPI band + aging heat badges
        check("pn-kpis semantic accents", pend.locator(".pn-kpis .pnk-docs").count() == 1
              and pend.locator(".pn-kpis .pnk-age").count() == 1)
        check("aging hot state", pend.locator(".pnk-age.hot").count() == (1 if kpis["over30Docs"] > 0 else 0))
        check("aging heat badges", pend.locator(".pn-badge").count() == 4)
        pg.screenshot(path="/root/DCT-Task-Management/final apps/GL/tests/pending_en.png", full_page=False)

        # v1.28.0 — Source filter scopes to PR only, then back
        all_count = pg.evaluate("ko.dataFor(document.body).pnCount()")
        pg.evaluate("var v=ko.dataFor(document.body); v.pnSource('PR'); v.runPending();")
        pg.wait_for_function("!ko.dataFor(document.body).pnLoading()", timeout=120000)
        pr_kpis = pg.evaluate("ko.dataFor(document.body).pnKpis()")
        check("source=PR scopes KPIs", pr_kpis["docsPo"] == 0 and pr_kpis["docsPr"] > 0,
              "(PR docs %s)" % pr_kpis["docsPr"])
        pg.evaluate("var v=ko.dataFor(document.body); v.pnSource(''); v.runPending();")
        pg.wait_for_function("!ko.dataFor(document.body).pnLoading()", timeout=120000)
        check("source reset restores", pg.evaluate("ko.dataFor(document.body).pnCount()") == all_count)

        # v1.28.0 — "Showing figures in" drives the tile values (buUnit)
        pg.evaluate("ko.dataFor(document.body).buUnit('M')")
        amt_txt = pend.locator(".pnk-amt .bk-v").inner_text()
        check("figures-in M unit", amt_txt.strip().endswith("M"), "(%s)" % amt_txt.strip())
        pg.evaluate("ko.dataFor(document.body).buUnit('auto')")

        # v1.28.0 — Document # cells deep-link to Oracle Fusion (new tab)
        doc0 = pg.evaluate("ko.dataFor(document.body).pnData().items[0].docNumber")
        cell = pend.locator("table.ir-table tbody td", has_text=doc0).first
        cell.hover()
        check("doc# link affordance", "pn-doclink" in (cell.get_attribute("class") or ""), "(%s)" % doc0)
        pg.evaluate("window._lastOpen=null; window.open=function(u){window._lastOpen=u;}")
        cell.click()
        opened = pg.evaluate("window._lastOpen")
        check("doc# click opens Fusion deep link", bool(opened) and "deeplink" in opened,
              "(%s...)" % (opened or "")[:70])

        # ── AR / RTL ──
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(800)
        check("RTL direction", pg.evaluate("document.documentElement.getAttribute('dir')") == "rtl")
        ar_title = pend.locator("h1.greet").inner_text()
        check("Arabic title", "الاعتماد" in ar_title, "(%s)" % ar_title)
        check("Arabic KPI label", "المستندات" in pend.locator(".bu-kpis .bk-k").first.inner_text())
        pg.screenshot(path="/root/DCT-Task-Management/final apps/GL/tests/pending_ar.png", full_page=False)
        # restore EN (the language choice persists — never leave a test in AR)
        pg.evaluate("ko.dataFor(document.body).toggleLang()")
        pg.wait_for_timeout(400)
        check("restored EN", pg.evaluate("document.documentElement.getAttribute('dir')") != "rtl")

        # other tabs unaffected (butil still loads)
        pg.evaluate("ko.dataFor(document.body).go('butil')")
        pg.wait_for_function("!ko.dataFor(document.body).buBusy()", timeout=120000)
        check("butil tab still works", pg.locator("div[data-bind=\"visible:view()==='butil'\"] .bu-kpis .bk").count() == 4)

        browser.close()

    print("\n== %d pass / %d fail ==" % (ok, fail))
    sys.exit(1 if fail else 0)

if __name__ == "__main__":
    main()
