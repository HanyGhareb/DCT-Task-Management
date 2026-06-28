"""otbi-atd : "Generate Schedule OTBI Data" — bulk-generate the F/UH/U10M incremental
variants for every base analysis under a catalog folder (optionally recursing subfolders).

A *base* analysis = one whose name does NOT already end in _F / _UH / _U10M. For each base
<NAME> we create, in the same folder (skipping any that already exist):
    <NAME>_F     full copy (no filter)
    <NAME>_UH    <date col> >= TIMESTAMPADD(SQL_TSI_HOUR,   -1,  CURRENT_TIMESTAMP)
    <NAME>_U10M  <date col> >= TIMESTAMPADD(SQL_TSI_MINUTE, -10, CURRENT_TIMESTAMP)
The date column is auto-detected from the base analysis's CSV header (prefers
"Last Updated Date"). Reuses copy_analysis.do_copy (the proven editor automation) and the
authenticated session (auth.py).

Driven by the worker via `runner.py --schedgen`, which drains QUEUED prod.atd_schedgen_request
rows (folder_path + include_subfolders) and writes a per-analysis result summary back.
"""
import json
import os
import sys
import time
import urllib.parse

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

import auth
import extract
import copy_analysis as ca

BASE = os.environ.get("OTBI_ANALYTICS_BASE", "https://iaaibv.fa.ocs.oraclecloud29.com/analytics")
VARIANT_SUFFIXES = ("_F", "_UH", "_U10M")
_LIST_JS = ("() => Array.from(document.querySelectorAll('[title]')).map(e=>e.getAttribute('title'))"
            ".filter(t=>t && t.indexOf('Click to see more actions of ')===0)"
            ".map(t=>t.replace('Click to see more actions of ',''))")


def _env():
    return {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
            "analytics_base_url": BASE,
            "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}


def _step(m): print(f"[schedgen] {m}", flush=True)


def list_folder(page, folder):
    """Catalog-page listing of a folder's immediate children (names only)."""
    url = BASE.rstrip("/") + "/saw.dll?catalog&path=" + urllib.parse.quote(folder, safe="")
    page.goto(url, wait_until="domcontentloaded", timeout=70000)
    time.sleep(ca.LAZY + 8)
    return sorted(set(page.evaluate(_LIST_JS)))


def detect_date_col(ctx, env, analysis_path):
    """Read the analysis CSV header and pick a last-updated date column. Returns the
    column heading, or None. Also returns True/False whether the path is a downloadable
    analysis (False => it's a sub-folder)."""
    try:
        lines = extract.download_csv(ctx, env, analysis_path).splitlines()
    except extract.ReportError:
        return None, False        # not an analysis (sub-folder / missing)
    cols = (lines[0] if lines else "").split(",")
    pref = [c for c in cols if c.strip() == "Last Updated Date"]
    if pref:
        return pref[0], True
    for needle in ("Last Updated Date", "Last Update Date", "Updated Date", "Update Date"):
        hit = [c for c in cols if needle in c]
        if hit:
            return hit[0], True
    return None, True             # an analysis, but no date column found


def _is_base(name):
    return not any(name.endswith(s) for s in VARIANT_SUFFIXES)


def process_folder(page, ctx, env, folder, recurse, results, depth=0):
    if depth > 8:
        return
    try:
        items = list_folder(page, folder)
    except Exception as e:  # noqa: BLE001
        results["folders_failed"].append({"folder": folder, "error": f"list: {type(e).__name__}"})
        return
    existing = set(items)
    _step(f"folder {folder} -> {items}")
    subfolders = []
    for name in items:
        if not _is_base(name):
            continue                          # already a variant
        path = folder + "/" + name
        date_col, is_analysis = detect_date_col(ctx, env, path)
        if not is_analysis:
            subfolders.append(name)
            continue
        rec = {"folder": folder, "base": name, "dateCol": date_col, "created": [], "skipped": [], "failed": []}
        # _F (always), then _UH/_U10M when a date column exists
        plan = [("_F", None, None)]
        if date_col:
            plan += [("_UH", 1, None), ("_U10M", None, 10)]
        else:
            rec["failed"].append("no date column -> only _F")
        for suffix, hour, minute in plan:
            target = name + suffix
            if target in existing:
                rec["skipped"].append(target)
                continue
            try:
                if os.environ.get("SCHEDGEN_DRY") == "1":
                    rec["created"].append("(dry)" + target)        # plan only — no catalog write
                else:
                    ca.do_copy(page, BASE, path, target, hour=hour, minute=minute,
                               on_column=date_col or "Last Updated Date")
                    rec["created"].append(target)
                existing.add(target)
            except Exception as e:  # noqa: BLE001
                rec["failed"].append(f"{target}: {type(e).__name__}")
                ca._shot(page, "schedgen_err")
        results["analyses"].append(rec)
        _step(f"  {name}: created={rec['created']} skipped={rec['skipped']} failed={rec['failed']}")
    if recurse:
        for sf in subfolders:
            process_folder(page, ctx, env, folder + "/" + sf, recurse, results, depth + 1)


def generate(folder, recurse, pw=None):
    """Entry point: auth + walk the folder + generate variants. Returns a results dict."""
    env = _env()
    results = {"folder": folder, "recurse": bool(recurse), "analyses": [], "folders_failed": []}
    mgr = pw if pw is not None else sync_playwright().start()
    browser = None
    try:
        browser, ctx = auth.authenticate(mgr, env, headless=True)
        page = ctx.new_page()
        page.set_viewport_size({"width": 1920, "height": 1080})
        page.set_default_timeout(ca.STEP_TIMEOUT)
        process_folder(page, ctx, env, folder.rstrip("/"), recurse, results)
    finally:
        if browser:
            browser.close()
        if pw is None:
            mgr.stop()
    n_created = sum(len(a["created"]) for a in results["analyses"])
    n_fail = sum(len(a["failed"]) for a in results["analyses"])
    results["summary"] = {"bases": len(results["analyses"]), "created": n_created, "failed": n_fail}
    return results


# --------------------------------------------------------------------------- #
# Worker queue drain — claim QUEUED prod.atd_schedgen_request rows and run them.
# --------------------------------------------------------------------------- #
def drain_requests(conn, pw=None):
    """Process every QUEUED schedule-gen request (one at a time). conn = oracledb conn."""
    processed = 0
    while True:
        cur = conn.cursor()
        row = cur.callfunc("prod.atd_schedgen_pkg.claim_next", int, [])
        if not row or row == 0:
            break
        req_id = row
        cur.execute("SELECT folder_path, include_subfolders FROM prod.atd_schedgen_request "
                    "WHERE req_id=:id", id=req_id)
        folder, sub = cur.fetchone()
        _step(f"claimed req {req_id}: {folder} (subfolders={sub})")
        try:
            res = generate(folder, str(sub or "N").upper() == "Y", pw=pw)
            msg = (f"{res['summary']['bases']} base(s), {res['summary']['created']} created, "
                   f"{res['summary']['failed']} failed")
            cur.execute(
                "UPDATE prod.atd_schedgen_request SET status='DONE', message=:m, "
                "result_json=:r, finished=systimestamp WHERE req_id=:id",
                m=msg[:3900], r=json.dumps(res)[:32000], id=req_id)
            conn.commit()
            _step(f"req {req_id} DONE: {msg}")
        except Exception as e:  # noqa: BLE001
            conn.rollback()
            cur.execute(
                "UPDATE prod.atd_schedgen_request SET status='FAILED', message=:m, "
                "finished=systimestamp WHERE req_id=:id", m=str(e)[:3900], id=req_id)
            conn.commit()
            _step(f"req {req_id} FAILED: {e}")
        processed += 1
    return processed


if __name__ == "__main__":
    # CLI: python schedgen.py "<folder path>" [--recurse]   (direct run, no queue)
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("folder")
    ap.add_argument("--recurse", action="store_true")
    a = ap.parse_args()
    out = generate(a.folder, a.recurse)
    print(json.dumps(out, indent=2, ensure_ascii=False))
