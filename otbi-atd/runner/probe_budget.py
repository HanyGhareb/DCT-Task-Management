#!/usr/bin/env python3
"""probe_budget.py -- investigate PROJECTS_BUDGET_PERIODS OTBI failure/slowness.

Attaches to the SAVED session (auth_state_FUSION_ADGOV.json) ONLY -- it NEVER
initiates a login. If the session is dead it prints SESSION_DEAD and exits 2.

Modes:
  dump               open the Answers editor, click Advanced, dump logical SQL + XML
  run  <P2>          timed Go-URL downloads filtered on the given presentation
                     column (P2), scaling 1 -> 5 -> 20 -> 50 projects; stops at the
                     first 500. Also captures the OTBI error body when it fails.
  sql  "<logical>"   timed Go-URL &SQL= run of raw logical SQL (fallback path).
"""
import json
import re
import sys
import time
import urllib.parse

from playwright.sync_api import sync_playwright

BASE = "https://iaaibv.fa.ocs.oraclecloud29.com/analytics"
SRC = "/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_BUDGET_PERIODS"
STATE = "/root/otbi-atd-state/auth_state_FUSION_ADGOV.json"
OUT = "/root/otbi-atd-state/probe_budget"
TIMEOUT_MS = 660_000

IDS = ["300000489744733", "300000489744085", "300000449304981", "300000357612918",
       "300000489744330", "300000357494687", "300000356334796", "300000356334779",
       "300000357538933", "300000357495356", "300000356334496", "300000356334728",
       "300000356334949", "300000357495033", "300000357529747", "300000449304821",
       "300000449304892", "300000489774318", "300000515048997", "300000356334983",
       "300000489744998", "300000805438992", "300000823212013", "300000342936440",
       "300000357494083", "300000357494999", "300000357495237", "300000357539974",
       "300000489774186", "300000489774392", "300000515381456", "300000805438981",
       "300000823212037", "300000342565592", "300000342565609", "300000342565626",
       "300000357494134", "300000357495390", "300000357529560", "300000357538165",
       "300000357553874", "300000357569577", "300000357572640", "300000489744274",
       "300000489744639", "300000513275897", "300000823212026", "300001409291415",
       "300000357495993", "300000357539355"]


def log(m):
    print(f"[{time.strftime('%H:%M:%S')}] {m}", flush=True)


ENV = {
    "env_name": "FUSION_ADGOV",
    "analytics_base_url": BASE,
    "credential_ref": "FUSION_ADGOV",
    "fusion_apps_url": "https://iaaibv.fa.ocs.oraclecloud29.com",
}


def attach(p):
    """Authenticate exactly the way the worker does (auth.authenticate: saved
    profile first, credential login + Telegram-relayed MFA only if needed).
    Stop atd-worker on this VM first so the profile is free."""
    import auth
    browser, ctx = auth.authenticate(p, ENV, headless=True)
    pg = ctx.new_page()
    log("session OK (via auth.authenticate)")
    return browser, ctx, pg


def go_url(params=None, sql=None, fmt="csv"):
    if sql is not None:
        return (f"{BASE}/saw.dll?Go&SQL={urllib.parse.quote(sql, safe='')}"
                f"&Action=Download&Format={fmt}")
    qp = urllib.parse.quote(SRC, safe="")
    u = f"{BASE}/saw.dll?Go&path={qp}&Action=Download&Format={fmt}"
    if params:
        u += "&" + params
    return u


def timed_fetch(ctx, tag, url):
    log(f"{tag}: GET ...{url[-160:]}")
    t0 = time.time()
    try:
        r = ctx.request.get(url, timeout=TIMEOUT_MS)
    except Exception as e:  # noqa: BLE001
        log(f"{tag}: EXCEPTION after {time.time()-t0:.1f}s : {str(e)[:200]}")
        return {"tag": tag, "ok": False, "secs": time.time() - t0}
    secs = time.time() - t0
    body = r.body()
    ctype = r.headers.get("content-type", "").lower()
    is_html = "html" in ctype or body[:15].lstrip().lower().startswith(b"<!doctype")
    if r.status == 200 and not is_html:
        text = body.decode("utf-8-sig", "replace")
        rows = max(0, len([l for l in text.splitlines() if l.strip()]) - 1)
        with open(f"{OUT}_{tag}.csv", "w", encoding="utf-8") as f:
            f.write(text)
        log(f"{tag}: OK  {secs:.1f}s  rows={rows}")
        return {"tag": tag, "ok": True, "secs": secs, "rows": rows}
    with open(f"{OUT}_{tag}.html", "wb") as f:
        f.write(body)
    txt = re.sub(r"<[^>]+>", " ", body.decode("utf-8", "replace"))
    txt = re.sub(r"&#\d+;|&\w+;", " ", txt)
    txt = re.sub(r"\s+", " ", txt)
    hits = re.findall(
        r"(nQSError[^\.]{0,220}|ORA-\d+[^\.]{0,180}|Odbc driver returned an error[^\.]{0,120}"
        r"|[Tt]ime ?out[^\.]{0,120}|exceeded[^\.]{0,160})", txt)
    log(f"{tag}: FAIL status={r.status} {secs:.1f}s")
    for h in hits[:8]:
        log(f"{tag}:   err> {h.strip()}")
    if not hits:
        log(f"{tag}:   body> {txt[:800]}")
    return {"tag": tag, "ok": False, "secs": secs, "status": r.status}


def do_dump(pg):
    qp = urllib.parse.quote(SRC, safe="")
    url = f"{BASE}/saw.dll?Answers&Path={qp}"
    log(f"open editor: {url[-120:]}")
    pg.goto(url, wait_until="domcontentloaded", timeout=240000)
    time.sleep(15)
    clicked = False
    for sel in ['a:text-is("Advanced")', 'div:text-is("Advanced")',
                'span:text-is("Advanced")', 'td:text-is("Advanced")']:
        loc = pg.locator(sel)
        for i in range(min(loc.count(), 8)):
            try:
                el = loc.nth(i)
                if el.is_visible():
                    el.click()
                    clicked = True
                    break
            except Exception:  # noqa: BLE001
                continue
        if clicked:
            break
    log(f"advanced tab clicked={clicked}")
    time.sleep(15)
    pg.screenshot(path=f"{OUT}_advanced.png", full_page=True)
    tas = pg.evaluate(
        "() => Array.from(document.querySelectorAll('textarea'))"
        ".map(t => (t.value||'').slice(0, 30000)).filter(v => v.length > 40)")
    with open(f"{OUT}_advanced.txt", "w", encoding="utf-8") as f:
        for i, v in enumerate(tas):
            f.write(f"===== textarea {i} =====\n{v}\n\n")
    log(f"dumped {len(tas)} textareas -> {OUT}_advanced.txt")
    for i, v in enumerate(tas):
        head = v[:400].replace("\n", " ")
        log(f"  ta{i}: {head}")


def do_run(ctx, p2):
    results = []
    p2q = urllib.parse.quote(p2, safe="")

    def params_for(ids):
        if len(ids) == 1:
            return f"P0=1&P1=eq&P2={p2q}&P3={ids[0]}"
        vals = "+".join(ids)
        return f"P0=1&P1=in&P2={p2q}&P3={vals}"

    for n in (1, 5, 20, 50):
        tag = f"proj{n}"
        res = timed_fetch(ctx, tag, go_url(params=params_for(IDS[:n])))
        results.append(res)
        if not res.get("ok"):
            log(f"stopping scale-up at {n} project(s) — request failed")
            break
        time.sleep(3)
    log("RESULTS " + json.dumps(results))


SA = '"Project Control - Budgets Real Time"'
PROJ = "300000489744733"
LADDER = [
    ("L1_minimal",
     f'SELECT 0 s_0, "Project"."Project Key" s_1, '
     f'"- Budget Cost Measures"."Current Budget Cost" s_2 FROM {SA} '
     f'WHERE "Project"."Project Key" = {PROJ}'),
    ("L2_dims",
     f'SELECT 0 s_0, "Project"."Project Key" s_1, "Task"."Task Key" s_2, '
     f'"Fiscal Calendar"."Fiscal Period" s_3, "Resource"."Resource Type Name" s_4, '
     f'"Projects Calendar"."Fiscal Year" s_5, '
     f'"- Budget Cost Measures"."Current Budget Cost" s_6 FROM {SA} '
     f'WHERE "Project"."Project Key" = {PROJ}'),
    ("L3_filters",
     f'SELECT 0 s_0, "Project"."Project Key" s_1, "Task"."Task Key" s_2, '
     f'"Fiscal Calendar"."Fiscal Period" s_3, "Resource"."Resource Type Name" s_4, '
     f'"Projects Calendar"."Fiscal Year" s_5, '
     f'"- Budget Cost Measures"."Current Budget Cost" s_6 FROM {SA} '
     f'WHERE ("Project"."Project Key" = {PROJ}) '
     f'AND (DESCRIPTOR_IDOF("- Business Unit"."Business Unit Name") '
     f'IN (300000002427529, 300000324906601)) '
     f'AND ("Projects Calendar"."Fiscal Year" = 2026)'),
    ("L4_version_cols",
     f'SELECT 0 s_0, "Project"."Project Key" s_1, "Task"."Task Key" s_2, '
     f'"Fiscal Calendar"."Fiscal Period" s_3, "Resource"."Resource Type Name" s_4, '
     f'"Projects Calendar"."Fiscal Year" s_5, '
     f'"- Budget Version Record Information"."Budget Version Last Update Date" s_6, '
     f'"- Budget Version Record Information"."Budget Version Last Updated By" s_7, '
     f'"- Budget Cost Measures"."Current Budget Cost" s_8 FROM {SA} '
     f'WHERE ("Project"."Project Key" = {PROJ}) '
     f'AND (DESCRIPTOR_IDOF("- Business Unit"."Business Unit Name") '
     f'IN (300000002427529, 300000324906601)) '
     f'AND ("Projects Calendar"."Fiscal Year" = 2026)'),
    ("L5_full_nofilter",
     f'SELECT 0 s_0, "Project"."Project Key" s_1, "Task"."Task Key" s_2, '
     f'"Fiscal Calendar"."Fiscal Period" s_3, "Resource"."Resource Type Name" s_4, '
     f'"Projects Calendar"."Fiscal Year" s_5, '
     f'"- Budget Version Record Information"."Budget Version Last Update Date" s_6, '
     f'"- Budget Version Record Information"."Budget Version Last Updated By" s_7, '
     f'"- Budget Cost Measures"."Current Budget Cost" s_8 FROM {SA} '
     f'WHERE (DESCRIPTOR_IDOF("- Business Unit"."Business Unit Name") '
     f'IN (300000002427529, 300000324906601)) '
     f'AND ("Projects Calendar"."Fiscal Year" = 2026) '
     f'FETCH FIRST 500001 ROWS ONLY'),
]


FULLCOLS = (f'SELECT 0 s_0, "Project"."Project Key" s_1, "Task"."Task Key" s_2, '
            f'"Fiscal Calendar"."Fiscal Period" s_3, "Resource"."Resource Type Name" s_4, '
            f'"Projects Calendar"."Fiscal Year" s_5, '
            f'"- Budget Version Record Information"."Budget Version Last Update Date" s_6, '
            f'"- Budget Version Record Information"."Budget Version Last Updated By" s_7, '
            f'"- Budget Cost Measures"."Current Budget Cost" s_8 FROM {SA} ')
FULLWHERE = (f'WHERE (DESCRIPTOR_IDOF("- Business Unit"."Business Unit Name") '
             f'IN (300000002427529, 300000324906601)) '
             f'AND ("Projects Calendar"."Fiscal Year" = 2026)')
SETCUR = "SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1';"
ORDERBY = (' ORDER BY 6 ASC NULLS LAST, 5 ASC NULLS LAST, '
           'SORTKEY("Fiscal Calendar"."Fiscal Period") ASC NULLS LAST, '
           '2 ASC NULLS LAST, 3 ASC NULLS LAST')
LADDER2 = [
    ("M1_full_plain", FULLCOLS + FULLWHERE),
    ("M2_full_currency", SETCUR + FULLCOLS + FULLWHERE),
    ("M3_full_orderby", FULLCOLS + FULLWHERE + ORDERBY),
    ("M4_1proj_currency",
     SETCUR + FULLCOLS + FULLWHERE + f' AND ("Project"."Project Key" = {PROJ})'),
]


def do_ladder(ctx, rungs=None, max_fails=1):
    results = []
    fails = 0
    for tag, sql in (rungs or LADDER):
        res = timed_fetch(ctx, tag, go_url(sql=sql))
        results.append(res)
        if not res.get("ok"):
            fails += 1
            if fails >= max_fails:
                log(f"ladder stopped at {tag} (fail budget reached)")
                break
        time.sleep(3)
    log("LADDER_RESULTS " + json.dumps(results))


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "dump"
    with sync_playwright() as p:
        browser, ctx, pg = attach(p)
        try:
            if mode == "dump":
                do_dump(pg)
            elif mode == "run":
                do_run(ctx, sys.argv[2])
            elif mode == "sql":
                timed_fetch(ctx, "rawsql", go_url(sql=sys.argv[2]))
            elif mode == "ladder":
                do_ladder(ctx)
            elif mode == "ladder2":
                do_ladder(ctx, LADDER2)
            elif mode == "each":
                rungs = []
                for i, pid in enumerate(IDS[1:5], start=2):
                    rungs.append((f"E_proj{i}", FULLCOLS + FULLWHERE +
                                  f' AND ("Project"."Project Key" = {pid})'))
                rungs.append(("E_in_same",
                              FULLCOLS + FULLWHERE +
                              f' AND ("Project"."Project Key" IN ({PROJ}, {PROJ}))'))
                rungs.append(("E_in_two",
                              FULLCOLS + FULLWHERE +
                              f' AND ("Project"."Project Key" IN ({PROJ}, {IDS[1]}))'))
                rungs.append(("E_or_two",
                              FULLCOLS + FULLWHERE +
                              f' AND (("Project"."Project Key" = {PROJ}) '
                              f'OR ("Project"."Project Key" = {IDS[1]}))'))
                do_ladder(ctx, rungs, max_fails=2)
            elif mode == "final":
                rungs = [
                    ("F1_between",
                     FULLCOLS + FULLWHERE +
                     ' AND ("Project"."Project Key" BETWEEN 300000489744000 '
                     'AND 300000489745000)'),
                    ("F2_period",
                     FULLCOLS + FULLWHERE +
                     ' AND ("Fiscal Calendar"."Fiscal Period" = \'01-2026\')'),
                ]
                do_ladder(ctx, rungs, max_fails=2)
            elif mode == "sqlscale":
                rungs = []
                for n in (5, 20, 50):
                    ids = ", ".join(IDS[:n])
                    rungs.append((f"S{n}", FULLCOLS + FULLWHERE +
                                  f' AND ("Project"."Project Key" IN ({ids}))'))
                rungs.append(("S_dimlist",
                              f'SELECT 0 s_0, "Project"."Project Key" s_1 '
                              f'FROM {SA} ' + FULLWHERE))
                do_ladder(ctx, rungs)
            elif mode == "base":
                timed_fetch(ctx, "baseline", go_url())
            else:
                print("unknown mode", mode)
        finally:
            browser.close()


if __name__ == "__main__":
    main()
