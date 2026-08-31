"""GL Budget Utilization — "Refresh data" dropdown + Data Conveyor POPUP smoke
(v1.77.0, 2026-08-22).

Part 1 (simulated): force the VM state and assert the popup renders — CENTRED
fixed overlay while pdataBusy, 15 segments with the done-count lit, count/job
captions, the x hides it (run keeps going, header button stays busy),
AR/RTL mirror (SVG flipped, chips readable).
Part 1b: the three refresh buttons are folded into ONE "Refresh data" dropdown
(.gen pattern) — source / actuals / rebuild (admin-only) + last-refreshed line.
Part 2 (LIVE): trigger the real refresh, watch the popup show genuine fleet
progress, wait for the run to finish (~2-3 min), popup hides.

Run with the GL dev-proxy:  python3 'final apps/GL/Jet/dev-proxy.py' 8096
"""
import json
import os
import re
import time

from playwright.sync_api import sync_playwright

BASE = "http://localhost:8096"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
OUT = "/tmp/cvb_smoke"

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
        pg.add_init_script(
            "localStorage.setItem('ifinance_jet_session', %s);"
            "localStorage.setItem('gl_lang', 'en');" % json.dumps(json.dumps(r.json())))
        pg.goto(BASE + "/index.html")
        pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)", timeout=120000)
        vm = "ko.dataFor(document.body)"
        pg.wait_for_function(f"() => {vm}.view()==='butil' && !{vm}.buLoading()", timeout=120000)

        # ---- part 1: simulated state ----
        band = pg.locator(".cvb")
        check("band hidden when idle", not band.is_visible())
        pg.evaluate(f"() => {{ var v={vm}; v.pdataDone(7); "
                    f"v.pdataJob('PR Lines All · GRN Gap'); v.pdataBusy(true); }}")
        pg.wait_for_selector(".cvb", state="visible", timeout=5000)
        check("band visible while pdataBusy", band.is_visible())
        segs_on = pg.evaluate("() => document.querySelectorAll('.cvb-segs i.on').length")
        segs_all = pg.evaluate("() => document.querySelectorAll('.cvb-segs i').length")
        check("15 segments, 7 lit", segs_all == 15 and segs_on == 7, f"{segs_on}/{segs_all}")
        txt = band.inner_text()
        check("count caption", "7 of 15 extracts finished" in txt, txt[:80])
        check("running-job caption", "PR Lines All" in txt and "GRN Gap" in txt)
        check("Fusion + i-Finance chips", "Fusion" in txt and "i-Finance" in txt)
        moving = pg.evaluate(
            "() => getComputedStyle(document.querySelector('.cvb-parcel')).animationName")
        check("parcel animation running", moving == "cvb-ride", moving)
        # popup is a CENTRED fixed overlay
        pos = pg.evaluate(
            "() => {var c=document.querySelector('.cvb-card').getBoundingClientRect();"
            "return {dx: Math.abs(c.left+c.width/2 - innerWidth/2),"
            "        dy: Math.abs(c.top+c.height/2 - innerHeight/2),"
            "        fixed: getComputedStyle(document.querySelector('.cvb')).position};}")
        check("popup fixed + centred", pos["fixed"] == "fixed" and pos["dx"] < 60 and pos["dy"] < 120,
              str(pos))
        pg.screenshot(path=OUT + "/01_band_en.png")
        # x hides the popup; the run (pdataBusy) keeps going + button stays busy
        pg.locator(".cvb-x").click()
        check("x hides popup, run keeps going",
              not band.is_visible() and pg.evaluate(f"() => {vm}.pdataBusy()"))
        btn_label = pg.locator("#pg-butil .page-actions .gen-btn").last.inner_text()
        check("header button shows busy label", "Refreshing" in btn_label, btn_label)
        pg.evaluate(f"() => {vm}.cvbHidden(false)")
        check("popup back when un-hidden", band.is_visible())

        # AR / RTL: SVG mirrored, chips stay readable HTML
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(600)
        flip = pg.evaluate(
            "() => getComputedStyle(document.querySelector('.cvb-svg')).transform")
        check("AR mirrors the belt (scaleX -1)", "-1" in flip, flip)
        txt_ar = pg.locator(".cvb").inner_text()
        check("AR captions Arabic", "استخراج" in txt_ar, txt_ar[:60])
        pg.screenshot(path=OUT + "/02_band_ar.png")
        pg.evaluate(f"() => {vm}.toggleLang()")
        pg.wait_for_timeout(400)
        pg.evaluate(f"() => {{ var v={vm}; v.pdataBusy(false); v.pdataDone(0); v.pdataJob(''); }}")
        check("band hides again", not band.is_visible())

        # ---- part 1b: "Refresh data" dropdown replaces the 3 buttons ----
        acts = pg.locator("#pg-butil .page-actions > button")
        labels = [acts.nth(i).inner_text().strip() for i in range(acts.count())]
        check("no standalone refresh buttons left",
              not any("Rebuild" in l or "Refresh actuals" in l or "source data" in l for l in labels),
              labels)
        rd_btn = pg.locator("#pg-butil .page-actions .gen").nth(1).locator(".gen-btn")
        check("Refresh data button present", rd_btn.inner_text().strip() == "Refresh data",
              rd_btn.inner_text())
        rd_btn.click()
        items = pg.locator("#pg-butil .page-actions .gen").nth(1).locator(".gen-item")
        check("dropdown lists 3 actions (admin)", items.count() == 3, items.count())
        menu_txt = pg.locator("#pg-butil .page-actions .gen").nth(1).locator(".gen-menu").inner_text()
        check("menu has source/actuals/rebuild",
              "Refresh source data" in menu_txt and "Refresh actuals" in menu_txt
              and "Rebuild views" in menu_txt, menu_txt[:80])
        pg.wait_for_timeout(2500)   # rd-last fetch
        last = pg.evaluate(f"() => {vm}.rdLast()")
        check("last-refreshed time fetched", bool(last), last)
        pg.screenshot(path=OUT + "/04_dropdown.png")
        pg.evaluate(f"() => {vm}.closeRd()")
        # non-admin sees only 2 items
        pg.evaluate(f"() => {{ {vm}.isSysAdmin = false; }}")
        rd_btn.click()
        n2 = pg.locator("#pg-butil .page-actions .gen").nth(1).locator(".gen-item").count()
        check("non-admin: Rebuild views hidden (2 items)", n2 == 2, n2)
        pg.evaluate(f"() => {{ {vm}.closeRd(); {vm}.isSysAdmin = true; }}")

        # ---- part 2: LIVE run via the real button ----
        pg.evaluate(f"() => {vm}.refreshProjectsData()")
        pg.wait_for_function(f"() => {vm}.pdataBusy()", timeout=30000)
        check("live: band appears on real run", band.is_visible())
        saw_progress, saw_job = 0, False
        t0 = time.time()
        while time.time() - t0 < 600:
            if not pg.evaluate(f"() => {vm}.pdataBusy()"):
                break
            done = pg.evaluate(f"() => {vm}.pdataDone()")
            job = pg.evaluate(f"() => {vm}.pdataJob()")
            saw_progress = max(saw_progress, done)
            saw_job = saw_job or bool(job)
            if done and done < 15 and not os.path.exists(OUT + "/03_live_mid.png"):
                pg.screenshot(path=OUT + "/03_live_mid.png")
            pg.wait_for_timeout(4000)
        secs = int(time.time() - t0)
        check("live: run finished within 10 min", not pg.evaluate(f"() => {vm}.pdataBusy()"), f"{secs}s")
        check("live: real progress observed", saw_progress > 0, f"peak done={saw_progress}")
        check("live: running-job name observed", saw_job)
        check("live: band hidden after completion", not band.is_visible())
        check("no page errors", not errors, errors[:2])
        b.close()

    n_ok = sum(1 for _, ok in results if ok)
    print(f"\n{n_ok}/{len(results)} PASS")
    return 0 if n_ok == len(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
