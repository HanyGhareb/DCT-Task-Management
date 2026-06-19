"""otbi-atd : create an OTBI analysis in the Answers UI from a declarative spec.

GENERIC + reusable across subject areas. Reuses the authenticated Playwright
session from auth.py (federated SSO/MFA), the same one extract.py downloads with,
so a created analysis is immediately loadable by the runner.

The OTBI "Answers" editor is a heavy, lazy-loading JS app (and the pod is often
slow), so every build step is verbose, folder-scoped, slow-tolerant, and
screenshot-on-failure. Attribute names repeat across folders (e.g. "Business Unit"
in two BU folders), so a column is always located *within its folder's children
container*, never page-wide.

A spec has FOUR inputs (JSON via --spec, or inline flags):
  1. the data    -> subject_area + columns[] ({folder, column, heading})
  2. the params  -> params[] ({folder, column, operator, prompted, default?})  (optional)
  3. the location-> save_folder   (catalog path; /users/<me>/.. maps to "My Folders")
  4. the name    -> name          (saved as <save_folder>/<name>)
Optional load hints: key (key column header), load_mode (TRUNCATE_INSERT|MERGE).

Usage:
  python create_analysis.py --spec ../specs/po_headers.json [--headed] [--pause]
         [--no-headings] [--no-params] [--load]

--load chains add_analysis.py + runner.py after the analysis is saved.

Env (same as the runner): OTBI_USER/OTBI_PWD or <REF>_USER/<REF>_PWD, ATD_STATE_DIR.
Optional: OTBI_ANALYTICS_BASE, OTBI_ENV_NAME (default FUSION_ADGOV),
OTBI_CREATE_TIMEOUT (per-action ms, def 30000), OTBI_LAZY_WAIT (folder load s, def 5).
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
LAZY = float(os.environ.get("OTBI_LAZY_WAIT", "5"))     # pod is slow: lazy-load grace


def _node(folder):
    return f'[id="criteriaDataBrowser${folder}"]'


def _disc(folder):
    return f'[id="criteriaDataBrowser${folder}_disclosure"]'


def _children(folder):
    return f'[id="criteriaDataBrowser${folder}_children"]'


def _shot(page, tag):
    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        path = os.path.join(STATE_DIR, f"create_{tag}_{datetime.now():%H%M%S}.png")
        page.screenshot(path=path, full_page=True)
        print(f"[shot] {path}")
    except Exception as e:  # noqa: BLE001
        print(f"[shot] failed: {e}")


def _dump(page, tag):
    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        path = os.path.join(STATE_DIR, f"create_{tag}_{datetime.now():%H%M%S}.html")
        with open(path, "w", encoding="utf-8") as f:
            f.write(page.content())
        print(f"[dump] {path}")
    except Exception as e:  # noqa: BLE001
        print(f"[dump] failed: {e}")


def _step(msg):
    print(f"[create] {msg}", flush=True)


def _js_click(loc):
    """Fire the element's click handler via JS — bypasses modal OpaqueLayer backdrops
    that intercept real pointer events (stacked OTBI dialogs)."""
    loc.evaluate("el => el.click()")


def _first(scope, selectors, timeout=4000):
    for s in selectors:
        try:
            loc = scope.locator(s) if isinstance(s, str) else getattr(scope, s[0])(s[1])
            if loc.count() > 0:
                loc.first.wait_for(state="visible", timeout=timeout)
                return loc.first
        except Exception:
            continue
    return None


# --------------------------------------------------------------------------- #
def open_editor(page, base, subject_area):
    sa = urllib.parse.quote(f'"{subject_area}"', safe="")
    url = base.rstrip("/") + f"/saw.dll?Answers&SubjectArea={sa}"
    _step(f"open editor: {url}")
    page.goto(url, wait_until="domcontentloaded", timeout=STEP_TIMEOUT * 2)
    time.sleep(LAZY + 4)
    if not _first(page, ['#selectedDiv', 'text=Subject Areas'], timeout=STEP_TIMEOUT):
        _shot(page, "open"); _dump(page, "open")
        raise RuntimeError("Answers editor did not open (no criteria pane)")


def expand_folder(page, folder):
    disc = page.locator(_disc(folder))
    if disc.count() == 0:
        _shot(page, "folder")
        raise RuntimeError(f"folder not in subject-area pane: {folder!r}")
    leaves = page.locator(_children(folder)).locator("span.treeNodeText")
    if leaves.count() > 0:
        return                                    # already expanded
    try:
        disc.first.scroll_into_view_if_needed(timeout=5000)
    except Exception:
        pass
    disc.first.click(timeout=STEP_TIMEOUT)
    # lazy children can be slow + large on this pod (e.g. Supplier Profile has 100+
    # attributes) — wait generously for the first leaf
    try:
        leaves.first.wait_for(state="attached", timeout=90000)
    except Exception:
        if leaves.count() > 0:
            return
        _shot(page, "folder_empty")
        raise RuntimeError(f"folder did not load children: {folder!r}")


def _col_count(page):
    return page.locator('div.columnHeader').count()   # added columns are .columnHeader boxes


def _add_leaf(page, leaf, column):
    """Double-click a tree leaf and confirm the column count grew."""
    try:
        leaf.scroll_into_view_if_needed(timeout=4000)
    except Exception:
        pass
    before = _col_count(page)
    leaf.dblclick(timeout=STEP_TIMEOUT)
    for _ in range(int((LAZY + 6) / 0.6)):
        time.sleep(0.6)
        if _col_count(page) > before:
            return True
    print(f"[create] (warn) could not confirm {column!r} added (column count unchanged)")
    return False


def add_column(page, folder, column):
    children = page.locator(_children(folder))
    leaf = children.locator(f'span.treeNodeText:text-is("{column}")')
    # Long folders (e.g. Supplier Profile, 100+ attrs) VIRTUALISE the tree — only a
    # window of leaves is in the DOM at a time, so a mid-list column may be absent.
    # Walk the scrollable ancestor down a page at a time to render every node, retry.
    for _ in range(24):
        if leaf.count() > 0:
            break
        try:
            page.evaluate("""(cid) => {
              const el = document.getElementById(cid) || document.getElementById('criteriaDataBrowser');
              let n = el;
              while (n) {
                if (n.scrollHeight > n.clientHeight + 5) {
                  n.scrollTop = n.scrollTop + Math.max(120, n.clientHeight - 30);
                  return;
                }
                n = n.parentElement;
              }
            }""", f"criteriaDataBrowser${folder}_children")
        except Exception:
            pass
        time.sleep(1.1)
    if leaf.count() > 0:
        _add_leaf(page, leaf.first, column)
        return
    # fallback: the subject-area search box (handles flaky/partial tree rendering).
    # It is hidden until the magnifier toggle is clicked.
    toggle = page.locator('#SAPaneHeaderToolbar_searchSA_image')
    sb = page.locator('#criteriaDataBrowserSASearchBoxInput')
    if toggle.count():
        print(f"[create] (add) {column!r} not rendered in {folder!r} tree; using search box")
        if not (sb.count() and sb.first.is_visible()):
            toggle.first.click(); time.sleep(1.5)
        sb.first.fill(column); sb.first.press("Enter"); time.sleep(LAZY + 4)
        sres = page.locator(f'span.treeNodeText:text-is("{column}")')
        try:
            sres.first.wait_for(state="attached", timeout=30000)
        except Exception:
            pass
        added = _add_leaf(page, sres.first, column) if sres.count() > 0 else False
        cancel = page.locator('#criteriaDataBrowserSASearchBoxCancel')
        if cancel.count() and cancel.first.is_visible():
            cancel.first.click()                       # restore the full tree
        else:
            sb.first.fill(""); sb.first.press("Enter")
        time.sleep(LAZY + 2)
        if added:
            return
    _shot(page, "column")
    raise RuntimeError(f"column not found in {folder!r}: {column!r}")


def _visible(loc):
    for i in range(loc.count()):
        if loc.nth(i).is_visible():
            return loc.nth(i)
    return None


def set_heading(page, raw, heading):
    """Set a custom heading on the column currently displaying `raw` (cog menu ->
    Column Properties -> Column Format -> Custom Headings). Call right after adding
    the column so duplicate source names (e.g. 'Business Unit') resolve to one match.
    Best-effort: logs + continues on failure."""
    try:
        # match by EXACT trimmed text so 'Supplier' != 'Supplier Number' and
        # 'Business Unit' resolves to the one still un-renamed (call right after add)
        all_cols = page.locator('div.columnHeader')
        col = None
        for i in range(all_cols.count()):
            try:
                if all_cols.nth(i).inner_text().strip() == raw:
                    col = all_cols.nth(i)        # last exact match = most recent add
            except Exception:
                continue
        if col is None:
            print(f"[create] (heading) column {raw!r} not found; skipping"); return
        cog = col.locator('img[id$="_columnMenuImg"]').first
        cog.scroll_into_view_if_needed(timeout=5000)
        cog.click(timeout=10000); time.sleep(1.0)
        page.locator('#menuOptionItem_ColumnProperties').first.click(timeout=8000)
        time.sleep(1.8)
        tab = _visible(page.get_by_text("Column Format", exact=True))
        if tab:
            tab.click(); time.sleep(1.0)
        chk = _visible(page.locator('input[name="customHdg"]'))
        if chk and not chk.is_checked():
            chk.click(); time.sleep(0.4)
        box = _visible(page.locator('input[name="columnHdg"]'))
        if box:
            box.fill(heading)
        ok = _first(page, ['a:text-is("OK")', 'button:text-is("OK")', 'span:text-is("OK")'])
        if ok:
            _js_click(ok); time.sleep(1.2)
    except Exception as e:  # noqa: BLE001
        _shot(page, "heading")
        print(f"[create] (heading) {raw!r} -> {heading!r} failed: {e}; continuing")


def add_filter(page, folder, column, operator, prompted, default=None):
    children = page.locator(_children(folder))
    leaf = children.locator(f'span.treeNodeText:text-is("{column}")')
    if leaf.count() == 0:
        print(f"[create] (filter) column not found {folder!r}:{column!r}; skipping"); return
    try:
        leaf.first.click(button="right"); time.sleep(0.8)
        flt = _first(page, ['text=Create Filter', 'a:has-text("Create Filter")', 'text=Filter'])
        if not flt:
            print(f"[create] (filter) Filter menu not found {column!r}; skipping"); return
        flt.click(); time.sleep(1.2)
        if prompted or operator == "is prompted":
            pchk = _first(page, ['text=is prompted', 'label:has-text("is prompted")'])
            if pchk:
                try: pchk.check()
                except Exception: pchk.click()
        elif operator:
            opsel = _first(page, ['select', '[role="combobox"]'])
            if opsel:
                try: opsel.select_option(label=operator)
                except Exception: pass
        if default is not None:
            val = _first(page, ['input[type="text"]', 'textarea'])
            if val: val.fill(str(default))
        ok = _first(page, ['a:text-is("OK")', 'button:text-is("OK")', 'span:text-is("OK")'])
        if ok:
            ok.click(); time.sleep(0.8)
    except Exception as e:  # noqa: BLE001
        _shot(page, "filter")
        print(f"[create] (filter) failed {column!r}: {e}; continuing")


def _ui_path(save_folder):
    """Map a catalog path to the Save-dialog tree labels."""
    segs = [s for s in save_folder.strip("/").split("/") if s]
    if segs and segs[0].lower() == "users":
        return ["My Folders"] + segs[2:]          # /users/<me>/A/B -> My Folders/A/B
    if segs and segs[0].lower() in ("shared folders", "shared"):
        return ["Shared Folders"] + segs[1:]
    return segs


def save_as(page, save_folder, name):
    _step(f"save as: {save_folder}/{name}")
    save = _first(page, ['#uberBar_save', '[title="Save Analysis"]'], timeout=STEP_TIMEOUT)
    if not save:
        _shot(page, "savebtn"); raise RuntimeError("Save control not found")
    save.click()
    # the Save As dialog is slow on this pod; wait for the filename field to appear
    name_box = None
    for _ in range(int((LAZY + 12) / 0.8)):
        time.sleep(0.8)
        nb = page.locator('#idFilename')
        if nb.count() and nb.first.is_visible():
            name_box = nb.first
            break
    if not name_box:
        _shot(page, "savedlg"); _dump(page, "savedlg")
        raise RuntimeError("Save As dialog (#idFilename) did not appear")
    # navigate folders: parts[0] is the root (My Folders / Shared Folders), rest are subfolders
    parts = _ui_path(save_folder)
    root, subs = (parts[0] if parts else "My Folders"), parts[1:]
    if root != "My Folders":
        rn = _first(page, [f'.treeNodeText:text-is("{root}")'], timeout=6000)
        if rn:
            rn.click(); time.sleep(LAZY)
    for seg in subs:                      # double-click each subfolder in the "Save In" list
        item = page.locator(f'span.CatalogObjectListListViewItem[title="{seg}"]')
        if item.count() == 0:
            _shot(page, "savefolder"); _dump(page, "savefolder")
            raise RuntimeError(f"save folder not found in 'Save In' list: {seg!r}")
        item.first.dblclick(); time.sleep(LAZY + 1)
    name_box = page.locator('#idFilename').first
    name_box.fill(name)
    # exact match — 'text=OK' does substring matching and hits "Lo*ok*up" behind the modal
    ok = _first(page, ['a:text-is("OK")', 'button:text-is("OK")', 'span:text-is("OK")'], timeout=8000)
    if not ok:
        _shot(page, "saveok"); _dump(page, "saveok")
        raise RuntimeError("Save dialog OK not found")
    _js_click(ok); time.sleep(2.5)        # JS click — a stacked OpaqueLayer can cover OK
    # if the name already exists, OTBI shows a 'Confirm Overwrite' dialog (OK / Cancel)
    conf = _first(page, ['span:text-is("Confirm Overwrite")', 'text=Confirm Overwrite'],
                  timeout=4000)
    if conf:
        _step("overwriting existing analysis")
        # the Save As dialog is still in the DOM behind this one, so its OK is first;
        # the Confirm Overwrite OK is the LAST visible OK (topmost dialog)
        oks = page.locator('a:text-is("OK")')
        target = None
        for i in range(oks.count()):
            if oks.nth(i).is_visible():
                target = oks.nth(i)
        if target:
            _js_click(target)
    time.sleep(LAZY + 3)


def build(page, spec, do_headings=True, do_params=True):
    open_editor(page, DEFAULT_BASE, spec["subject_area"])
    last = None
    for c in spec["columns"]:
        if c["folder"] != last:
            _step(f"expand folder: {c['folder']}")
            expand_folder(page, c["folder"])
            last = c["folder"]
        _step(f"add column: {c['folder']} -> {c['column']}")
        add_column(page, c["folder"], c["column"])
        # rename immediately so duplicate source names resolve uniquely
        if do_headings and c.get("heading") and c["heading"] != c["column"]:
            _step(f"heading: {c['column']} -> {c['heading']}")
            set_heading(page, c["column"], c["heading"])
    if do_params:
        for p in spec.get("params", []) or []:
            _step(f"filter: {p['column']} {p.get('operator','')}")
            add_filter(page, p["folder"], p["column"], p.get("operator", "is prompted"),
                       bool(p.get("prompted")) or p.get("operator") == "is prompted",
                       p.get("default"))
    save_as(page, spec["save_folder"], spec["name"])


def build_analysis(spec, headless=True, do_headings=True, do_params=True):
    """Auth + build + Save As + verify; returns the saved analysis catalog path.
    Single reusable entry point — the CLI and the runner --build queue both call this."""
    for k in ("subject_area", "name", "save_folder", "columns"):
        if not spec.get(k):
            raise ValueError(f"spec missing required key: {k}")
    env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
           "analytics_base_url": DEFAULT_BASE,
           "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}
    analysis_path = spec["save_folder"].rstrip("/") + "/" + spec["name"]
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=headless)
        page = ctx.new_page()
        page.set_default_timeout(STEP_TIMEOUT)
        try:
            build(page, spec, do_headings=do_headings, do_params=do_params)
            _step("verifying the saved analysis downloads as CSV...")
            csv_text = extract.download_csv(ctx, env, analysis_path)
            lines = csv_text.splitlines()
            _step(f"OK — saved + downloadable ({len(lines)} CSV lines)")
            _step("CSV header: " + (lines[0] if lines else "(empty)"))
        except Exception:
            _shot(page, "error")
            raise
        finally:
            browser.close()
    return analysis_path


# --------------------------------------------------------------------------- #
def chain_load(spec, analysis_path):
    from prepare import derive_table, derive_job
    table, job = derive_table(analysis_path), derive_job(analysis_path)
    args = [sys.executable, "add_analysis.py", analysis_path, "--table", table, "--job", job,
            "--load-mode", spec.get("load_mode", "TRUNCATE_INSERT")]
    if spec.get("key"):
        args += ["--key", spec["key"]]
    args += ["--apply"]
    print(f"[load] {' '.join(args)}")
    subprocess.run(args, check=True, cwd=os.path.dirname(__file__))
    print(f"[load] python runner.py {job}")
    subprocess.run([sys.executable, "runner.py", job], check=True, cwd=os.path.dirname(__file__))


def load_spec(a):
    spec = {}
    if a.spec:
        with open(a.spec, encoding="utf-8") as f:
            spec = json.load(f)
    if a.subject_area: spec["subject_area"] = a.subject_area
    if a.name: spec["name"] = a.name
    if a.save_folder: spec["save_folder"] = a.save_folder
    if a.columns: spec["columns"] = json.loads(a.columns)
    if a.params: spec["params"] = json.loads(a.params)
    for k in ("subject_area", "name", "save_folder", "columns"):
        if not spec.get(k):
            sys.exit(f"spec missing required key: {k}")
    return spec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec")
    ap.add_argument("--subject-area")
    ap.add_argument("--name")
    ap.add_argument("--save-folder")
    ap.add_argument("--columns")
    ap.add_argument("--params")
    ap.add_argument("--headed", action="store_true")
    ap.add_argument("--pause", action="store_true")
    ap.add_argument("--no-headings", action="store_true")
    ap.add_argument("--no-params", action="store_true")
    ap.add_argument("--load", action="store_true")
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
                build(page, spec, do_headings=not a.no_headings, do_params=not a.no_params)
                _step("verifying the saved analysis downloads as CSV...")
                csv_text = extract.download_csv(ctx, env, analysis_path)
                lines = csv_text.splitlines()
                _step(f"OK — saved + downloadable ({len(lines)} CSV lines)")
                _step("CSV header: " + (lines[0] if lines else "(empty)"))
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


if __name__ == "__main__":
    main()
