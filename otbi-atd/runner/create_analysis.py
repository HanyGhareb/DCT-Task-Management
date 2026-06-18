"""otbi-atd : create an OTBI analysis in the Answers UI from a declarative spec.

GENERIC + reusable across subject areas. Reuses the authenticated Playwright
session from auth.py (federated SSO/MFA), the same one extract.py downloads with,
so a created analysis is immediately loadable by the runner.

The OTBI "Answers" editor is a heavy dynamic JS app, so every build step is
verbose, multi-selector (``_first``), and screenshot-on-failure. First bring-up
against a pod is expected to need 1-3 iterations: run with --headed (watch it) or
--pause (drop into the Playwright inspector to record real selectors), fix the
selector lists, repeat.

A spec has FOUR inputs (JSON via --spec, or inline flags):
  1. the data    -> subject_area + columns[] ({folder, column, heading})
  2. the params  -> params[] ({folder, column, operator, prompted, default?})  (optional)
  3. the location-> save_folder   (catalog folder; created if missing)
  4. the name    -> name          (saved as <save_folder>/<name>)
Optional load hints: key (key column header), load_mode (TRUNCATE_INSERT|MERGE).

Usage:
  python create_analysis.py --spec ../specs/po_headers.json [--headed] [--pause] [--load]
  python create_analysis.py --subject-area "..." --name "..." \
         --save-folder "/users/.../PO" --columns '[{...}]' [--params '[{...}]']

--load chains add_analysis.py + runner.py after the analysis is saved.

Env (same as the runner): OTBI_USER/OTBI_PWD or <REF>_USER/<REF>_PWD, ATD_STATE_DIR.
Optional: OTBI_ANALYTICS_BASE (default the known pod), OTBI_ENV_NAME (default
FUSION_ADGOV), ATD_SQLCL (for --load), OTBI_CREATE_TIMEOUT (per-action ms, def 30000).
"""
import argparse
import json
import os
import subprocess
import sys
import time
import urllib.parse
from datetime import datetime

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

import auth
import extract

DEFAULT_BASE = os.environ.get("OTBI_ANALYTICS_BASE",
                              "https://iaaibv.fa.ocs.oraclecloud29.com/analytics")
STATE_DIR = os.environ.get("ATD_STATE_DIR", ".")
STEP_TIMEOUT = int(os.environ.get("OTBI_CREATE_TIMEOUT", "30000"))


# --------------------------------------------------------------------------- #
# small UI helpers (mirrors auth._first style: try selectors, return first hit)
# --------------------------------------------------------------------------- #
def _first(scope, selectors, timeout=4000):
    """First visible locator from a list of selector strings (or (kind,value))."""
    for s in selectors:
        try:
            if isinstance(s, tuple):
                kind, val = s
                loc = getattr(scope, kind)(val)
            else:
                loc = scope.locator(s)
            if loc.count() > 0:
                for i in range(loc.count()):
                    cand = loc.nth(i)
                    try:
                        cand.wait_for(state="visible", timeout=timeout)
                        return cand
                    except Exception:
                        continue
        except Exception:
            pass
    return None


def _shot(page, tag):
    """Screenshot to ATD_STATE_DIR for live debugging; never raises."""
    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        ts = datetime.now().strftime("%H%M%S")
        path = os.path.join(STATE_DIR, f"create_{tag}_{ts}.png")
        page.screenshot(path=path, full_page=True)
        print(f"[shot] {path}")
    except Exception as e:  # noqa: BLE001
        print(f"[shot] failed: {e}")


def _step(msg):
    print(f"[create] {msg}", flush=True)


# --------------------------------------------------------------------------- #
# build steps  (selectors are best-effort; confirm/harden on the headed run)
# --------------------------------------------------------------------------- #
def open_editor(page, base, subject_area):
    """Open the Answers 'Create Analysis' editor on a subject area (Criteria tab)."""
    sa = urllib.parse.quote(f'"{subject_area}"', safe="")
    url = base.rstrip("/") + f"/saw.dll?Answers&SubjectArea={sa}"
    _step(f"open editor: {url}")
    page.goto(url, wait_until="domcontentloaded", timeout=STEP_TIMEOUT * 2)
    time.sleep(6)
    # the subject-area pane / Criteria tab should now be present
    pane = _first(page, [
        'text=Subject Areas',
        '.SubjectArea',
        '#analysiseditortab_criteria',
        'text=Selected Columns',
    ], timeout=STEP_TIMEOUT)
    if not pane:
        _shot(page, "open")
        raise RuntimeError("Answers editor did not open (no subject-area pane). "
                           "Check the SubjectArea URL form against the live pod.")


def expand_folder(page, folder):
    """Expand a folder node in the subject-area tree (idempotent)."""
    node = _first(page, [
        ('get_by_text', folder),
        f'a:has-text("{folder}")',
        f'span:has-text("{folder}")',
        f'div[title="{folder}"]',
    ], timeout=STEP_TIMEOUT)
    if not node:
        _shot(page, "folder")
        raise RuntimeError(f"folder not found in subject-area pane: {folder!r}")
    # a double-click toggles expand in the classic tree; do it once if collapsed
    try:
        node.dblclick()
        time.sleep(1.2)
    except Exception:
        node.click()
        time.sleep(1.2)


def add_column(page, folder, column):
    """Add one column to Selected Columns (folder must be expanded first)."""
    leaf = _first(page, [
        ('get_by_text', column),
        f'a:has-text("{column}")',
        f'span:has-text("{column}")',
        f'div[title="{column}"]',
    ], timeout=STEP_TIMEOUT)
    if not leaf:
        _shot(page, "column")
        raise RuntimeError(f"column not found: {folder!r} -> {column!r}")
    leaf.dblclick()                       # double-click adds it to the criteria
    time.sleep(1.0)


def set_heading(page, column, heading):
    """Set a custom heading on an already-added column (best-effort)."""
    # open the column's action menu in the Selected Columns area
    menu = _first(page, [
        f'[title="{column}"] >> xpath=ancestor-or-self::*[1]',
        f'a:has-text("{column}")',
    ], timeout=8000)
    if not menu:
        print(f"[create] (heading) column chip not found for {column!r}; skipping")
        return
    try:
        menu.click(button="right")
        time.sleep(0.6)
        props = _first(page, ['text=Column Properties', 'a:has-text("Column Properties")'])
        if not props:
            print(f"[create] (heading) Column Properties menu not found for {column!r}; skipping")
            return
        props.click()
        time.sleep(1.2)
        # Column Format tab -> Custom Headings checkbox -> heading textbox
        fmt = _first(page, ['text=Column Format', 'a:has-text("Column Format")'])
        if fmt:
            fmt.click(); time.sleep(0.6)
        chk = _first(page, ['text=Custom Headings', 'input[type="checkbox"]'])
        if chk:
            try:
                chk.check()
            except Exception:
                chk.click()
            time.sleep(0.4)
        box = _first(page, ['textarea', 'input[type="text"]'])
        if box:
            box.fill(heading)
        ok = _first(page, ['text=OK', 'button:has-text("OK")'])
        if ok:
            ok.click(); time.sleep(0.8)
    except Exception as e:  # noqa: BLE001
        _shot(page, "heading")
        print(f"[create] (heading) failed for {column!r}: {e}; continuing")


def add_filter(page, folder, column, operator, prompted, default=None):
    """Create a (optionally prompted) filter on a column (best-effort)."""
    leaf = _first(page, [('get_by_text', column), f'a:has-text("{column}")'], timeout=8000)
    if not leaf:
        print(f"[create] (filter) column not found for filter: {column!r}; skipping")
        return
    try:
        leaf.click(button="right"); time.sleep(0.6)
        flt = _first(page, ['text=Create Filter', 'text=Filter', 'a:has-text("Filter")'])
        if not flt:
            print(f"[create] (filter) Filter menu not found for {column!r}; skipping")
            return
        flt.click(); time.sleep(1.0)
        opsel = _first(page, ['select', '[role="combobox"]'])
        if opsel:
            try:
                opsel.select_option(label=operator)
            except Exception:
                pass
        if default is not None:
            val = _first(page, ['input[type="text"]', 'textarea'])
            if val:
                val.fill(str(default))
        if prompted:
            pchk = _first(page, ['text=is prompted', 'label:has-text("is prompted")',
                                 'input[type="checkbox"]'])
            if pchk:
                try:
                    pchk.check()
                except Exception:
                    pchk.click()
        ok = _first(page, ['text=OK', 'button:has-text("OK")'])
        if ok:
            ok.click(); time.sleep(0.8)
    except Exception as e:  # noqa: BLE001
        _shot(page, "filter")
        print(f"[create] (filter) failed for {column!r}: {e}; continuing")


def save_as(page, save_folder, name):
    """Save the analysis to <save_folder>/<name> (creates folder if needed)."""
    _step(f"save as: {save_folder}/{name}")
    save = _first(page, [
        '[title="Save Analysis As"]', '[title="Save As"]', '[title="Save"]',
        'a[title*="Save"]', 'button:has-text("Save")',
    ], timeout=STEP_TIMEOUT)
    if not save:
        _shot(page, "savebtn")
        raise RuntimeError("Save toolbar control not found")
    save.click(); time.sleep(2.0)
    # In the Save dialog: pick folder, set name, OK.
    # The classic dialog often exposes a folder path/name; try a direct path field first.
    name_box = _first(page, ['input[name="name"]', 'input[type="text"]'], timeout=STEP_TIMEOUT)
    # navigate the folder tree by clicking each segment under the catalog root
    segs = [s for s in save_folder.strip("/").split("/") if s]
    for seg in segs:
        node = _first(page, [('get_by_text', seg), f'a:has-text("{seg}")',
                             f'div[title="{seg}"]'], timeout=6000)
        if node:
            try:
                node.click(); time.sleep(0.6)
            except Exception:
                pass
        else:
            # create the missing folder via "New Folder"
            nf = _first(page, ['[title="New Folder"]', 'button:has-text("New Folder")'])
            if nf:
                nf.click(); time.sleep(0.6)
                nfb = _first(page, ['input[type="text"]'])
                if nfb:
                    nfb.fill(seg)
                ok = _first(page, ['text=OK', 'button:has-text("OK")'])
                if ok:
                    ok.click(); time.sleep(0.8)
    name_box = name_box or _first(page, ['input[name="name"]', 'input[type="text"]'])
    if name_box:
        name_box.fill(name)
    ok = _first(page, ['[title="OK"]', 'text=OK', 'button:has-text("OK")'])
    if not ok:
        _shot(page, "savedlg")
        raise RuntimeError("Save dialog OK not found")
    ok.click(); time.sleep(3.0)


def build(page, spec):
    open_editor(page, DEFAULT_BASE, spec["subject_area"])
    # group columns by folder so each folder is expanded once
    last_folder = None
    for c in spec["columns"]:
        if c["folder"] != last_folder:
            _step(f"expand folder: {c['folder']}")
            expand_folder(page, c["folder"])
            last_folder = c["folder"]
        _step(f"add column: {c['folder']} -> {c['column']}")
        add_column(page, c["folder"], c["column"])
    for c in spec["columns"]:
        if c.get("heading") and c["heading"] != c["column"]:
            _step(f"heading: {c['column']} -> {c['heading']}")
            set_heading(page, c["column"], c["heading"])
    for p in spec.get("params", []) or []:
        _step(f"filter: {p['column']} {p.get('operator','')}"
              f"{' (prompted)' if p.get('prompted') else ''}")
        add_filter(page, p["folder"], p["column"], p.get("operator", "is equal to"),
                   bool(p.get("prompted")), p.get("default"))
    save_as(page, spec["save_folder"], spec["name"])


# --------------------------------------------------------------------------- #
# load hand-off (reuses the existing tools; no new load code)
# --------------------------------------------------------------------------- #
def chain_load(spec, analysis_path):
    from prepare import derive_table, derive_job
    table = derive_table(analysis_path)
    job = derive_job(analysis_path)
    args = [sys.executable, "add_analysis.py", analysis_path,
            "--table", table, "--job", job,
            "--load-mode", spec.get("load_mode", "TRUNCATE_INSERT")]
    if spec.get("key"):
        args += ["--key", spec["key"]]
    args += ["--apply"]
    print(f"[load] {' '.join(args)}")
    subprocess.run(args, check=True, cwd=os.path.dirname(__file__))
    print(f"[load] python runner.py {job}")
    subprocess.run([sys.executable, "runner.py", job], check=True,
                   cwd=os.path.dirname(__file__))


# --------------------------------------------------------------------------- #
def load_spec(a):
    if a.spec:
        with open(a.spec, encoding="utf-8") as f:
            spec = json.load(f)
    else:
        spec = {}
    # inline flags override / fill the spec
    if a.subject_area:
        spec["subject_area"] = a.subject_area
    if a.name:
        spec["name"] = a.name
    if a.save_folder:
        spec["save_folder"] = a.save_folder
    if a.columns:
        spec["columns"] = json.loads(a.columns)
    if a.params:
        spec["params"] = json.loads(a.params)
    for k in ("subject_area", "name", "save_folder", "columns"):
        if not spec.get(k):
            sys.exit(f"spec missing required key: {k}")
    return spec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec", help="path to a spec JSON file")
    ap.add_argument("--subject-area")
    ap.add_argument("--name")
    ap.add_argument("--save-folder")
    ap.add_argument("--columns", help="inline JSON array of {folder,column,heading}")
    ap.add_argument("--params", help="inline JSON array of {folder,column,operator,prompted}")
    ap.add_argument("--headed", action="store_true", help="show the browser (bring-up)")
    ap.add_argument("--pause", action="store_true",
                    help="open the editor then drop into the Playwright inspector")
    ap.add_argument("--load", action="store_true",
                    help="after saving, run add_analysis.py + runner.py")
    a = ap.parse_args()
    spec = load_spec(a)

    env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
           "analytics_base_url": DEFAULT_BASE,
           "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}
    analysis_path = spec["save_folder"].rstrip("/") + "/" + spec["name"]

    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not (a.headed or a.pause))
        page = ctx.new_page()
        page.set_default_timeout(STEP_TIMEOUT)
        try:
            if a.pause:
                open_editor(page, DEFAULT_BASE, spec["subject_area"])
                print("[create] paused — use the inspector to record selectors")
                page.pause()
            else:
                build(page, spec)
                _step("verifying the saved analysis downloads as CSV...")
                csv_text = extract.download_csv(ctx, env, analysis_path)
                rows = csv_text.count("\n")
                _step(f"OK — analysis saved and downloadable ({rows} CSV lines incl. header)")
        except Exception:
            _shot(page, "error")
            raise
        finally:
            browser.close()

    print(f"\nanalysis: {analysis_path}")
    if a.load and not a.pause:
        chain_load(spec, analysis_path)
    elif not a.pause:
        from prepare import derive_table, derive_job
        print("\nregister + load it with:")
        print(f'  python add_analysis.py "{analysis_path}" --table {derive_table(analysis_path)} '
              f'--job {derive_job(analysis_path)} '
              f'--load-mode {spec.get("load_mode","TRUNCATE_INSERT")}'
              + (f' --key "{spec["key"]}"' if spec.get("key") else "") + " --apply")
        print("or re-run create_analysis.py with --load.")


if __name__ == "__main__":
    main()
