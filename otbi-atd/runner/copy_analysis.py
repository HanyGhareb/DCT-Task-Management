"""otbi-atd : copy an existing OTBI analysis (optionally + a relative-time filter) to a
new name — used to spawn the F / UH / U10M incremental variants from an existing full
analysis WITHOUT rebuilding columns. Reuses the authenticated Playwright session (auth.py).

SAFE BY CONSTRUCTION: opens the SOURCE in the editor read-only and only ever uses
*Save As* (#uberBar_saveas) to write a NEW catalog object — it never Saves over the source.

Open-existing uses ?Answers&Path (the real editor, headless-friendly) — NOT ?Go&Action=Edit
(that serves the read-only viewer to a headless browser). The analysis opens on the Results
tab; we click Criteria, optionally add the filter, then Save As into the SOURCE's folder.

Modes:
  --probe "<src>"                              open + Criteria, dump controls, exit
  --copy "<src>" --to "<NAME>"                 plain Save-As copy (same folder)
        [--hour N | --minute N] [--on-column "<heading>"]   + relative-time filter
                                               (default column heading: "Last Updated Date")
  --edit "<src>" --remove-columns "A,B,C"      edit IN PLACE: delete the named columns
                                               from Criteria, then Save As the SAME name
                                               (Confirm Overwrite). Existing filters kept.

Verify: pass --verify to download the new analysis as CSV after saving (row sanity).
Env: same as the runner (OTBI_USER/PWD, ATD_STATE_DIR, OTBI_ANALYTICS_BASE, OTBI_ENV_NAME).
"""
import argparse
import os
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
LAZY = float(os.environ.get("OTBI_LAZY_WAIT", "5"))


def _step(m): print(f"[copy] {m}", flush=True)


def _shot(page, tag):
    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        p = os.path.join(STATE_DIR, f"copy_{tag}_{datetime.now():%H%M%S}.png")
        page.screenshot(path=p, full_page=True); _step(f"shot -> {p}")
    except Exception as e:  # noqa: BLE001
        _step(f"shot failed: {e}")


# --------------------------------------------------------------------------- #
def open_existing(page, base, analysis_path):
    """Open a SAVED analysis in the real Answers editor (headless-friendly)."""
    qp = urllib.parse.quote(analysis_path, safe="")
    url = base.rstrip("/") + f"/saw.dll?Answers&Path={qp}"
    _step(f"open: {url}")
    page.goto(url, wait_until="domcontentloaded", timeout=STEP_TIMEOUT * 2)
    for _ in range(40):
        if page.evaluate("""() => document.querySelectorAll('#selectedDiv,[id^="criteriaDataBrowser$"]').length"""):
            break
        time.sleep(2)
    time.sleep(LAZY + 2)


def click_tab(page, name):
    for sel in [f'a:text-is("{name}")', f'div:text-is("{name}")', f'span:text-is("{name}")',
                f'td:text-is("{name}")']:
        loc = page.locator(sel)
        for i in range(min(loc.count(), 8)):
            try:
                el = loc.nth(i)
                if el.is_visible():
                    el.click(); time.sleep(4)
                    _step(f"tab {name!r} via {sel}")
                    return True
            except Exception:
                continue
    _step(f"tab {name!r} not found"); return False


def _wait_columns(page, secs=40):
    for _ in range(int(secs / 2)):
        if page.evaluate("() => document.querySelectorAll('div.columnHeader').length"):
            return True
        time.sleep(2)
    return False


def _gear_for(page, heading):
    """The column-menu gear id of the Selected-Columns header whose text starts with
    `heading` (gear ids are per-load, so resolve live by column name)."""
    return page.evaluate(r"""(h) => {
      for (const e of document.querySelectorAll('div.columnHeader')) {
        if ((e.innerText||'').trim().startsWith(h)) {
          const g = e.querySelector('img[id$="_columnMenuImg"]');
          if (g) return g.id;
        }
      }
      return '';
    }""", heading)


def _click_ok_topmost(page):
    """Click the LAST visible OK (the topmost stacked dialog's OK)."""
    oks = page.locator('a:text-is("OK"), button:text-is("OK"), span:text-is("OK")')
    target = None
    for i in range(oks.count()):
        if oks.nth(i).is_visible():
            target = oks.nth(i)
    if not target:
        raise RuntimeError("no visible OK button")
    target.evaluate("el => el.click()")     # JS click — stacked OpaqueLayer can cover OK


def add_relative_filter(page, heading, unit, n):
    """Add a filter:  <heading>  >=  TIMESTAMPADD(SQL_TSI_<unit>, -n, CURRENT_TIMESTAMP).
    ANDed with any existing filters (e.g. the Business-Unit filter is preserved)."""
    expr = f"TIMESTAMPADD(SQL_TSI_{unit}, {-abs(int(n))}, CURRENT_TIMESTAMP)"
    _step(f"filter: {heading} >= {expr}")
    gear = _gear_for(page, heading)
    if not gear:
        raise RuntimeError(f"column not found in Selected Columns: {heading!r}")
    page.locator(f'#{gear}').first.click(timeout=10000); time.sleep(1.2)
    page.locator('#menuOptionItem_Filter').first.click(timeout=10000); time.sleep(2.5)
    page.locator('select[name="operator"]').first.select_option(
        label="is greater than or equal to"); time.sleep(0.8)
    page.locator('text="Add More Options"').first.click(); time.sleep(1.2)
    page.locator('#menuOptionItem_SQLExpression').first.click(); time.sleep(1.2)
    box = page.locator('#addSQLexpr')
    box.first.wait_for(state="visible", timeout=10000)
    box.first.fill(expr); time.sleep(0.5)
    _click_ok_topmost(page); time.sleep(2.0)
    _step("filter applied")


def remove_column(page, heading):
    """Delete the Selected-Columns column whose header starts with `heading` via its
    gear menu. Gear ids re-render after each removal, so resolve live every time."""
    gear = _gear_for(page, heading)
    if not gear:
        raise RuntimeError(f"column not found in Selected Columns: {heading!r}")
    page.locator(f'#{gear}').first.click(timeout=10000); time.sleep(1.2)
    for sel in ('#menuOptionItem_Delete', 'td:text-is("Delete")', 'a:text-is("Delete")',
                'span:text-is("Delete")'):
        loc = page.locator(sel)
        for i in range(min(loc.count(), 6)):
            try:
                el = loc.nth(i)
                if el.is_visible():
                    el.click(); time.sleep(2.0)
                    _step(f"column removed: {heading}")
                    return
            except Exception:
                continue
    items = page.evaluate("""() => [...document.querySelectorAll('[id^=menuOptionItem]')]
        .filter(e => e.offsetParent).map(e => e.id + ':' + (e.innerText||'').trim())""")
    raise RuntimeError(f"Delete option not found for {heading!r}; visible menu: {items}")


def _headings(page):
    """Current Selected-Columns headings (first line of each columnHeader), in order.
    Sorted columns render a sort-order badge prefix ('2<TAB><NBSP>Entity Code') — strip it."""
    return page.evaluate(r"""() => [...document.querySelectorAll('div.columnHeader')]
        .map(e => (e.innerText||'').trim().split('\n')[0]
             .replace(/^\d+[\t ]* [\t ]*/, '').trim())""")


def _gear_exact(page, heading):
    """Gear id of the column whose displayed heading EXACTLY equals `heading`
    (sort-order badge prefix stripped before comparing)."""
    return page.evaluate(r"""(h) => {
      for (const e of document.querySelectorAll('div.columnHeader')) {
        const t = (e.innerText||'').trim().split('\n')[0]
                    .replace(/^\d+[\t ]* [\t ]*/, '').trim();
        if (t === h) { const g = e.querySelector('img[id$="_columnMenuImg"]'); if (g) return g.id; }
      }
      return '';
    }""", heading)


def _open_formula_dialog(page, heading):
    gear = _gear_exact(page, heading)
    if not gear:
        raise RuntimeError(f"column not found (exact): {heading!r}")
    page.locator(f'#{gear}').first.click(timeout=10000); time.sleep(1.2)
    for sel in ('#menuOptionItem_EditFormula', 'td:has-text("Edit formula")',
                'a:has-text("Edit formula")', 'span:has-text("Edit formula")'):
        loc = page.locator(sel)
        for i in range(min(loc.count(), 6)):
            try:
                el = loc.nth(i)
                if el.is_visible():
                    el.click(); time.sleep(3.0)
                    return
            except Exception:
                continue
    items = page.evaluate("""() => [...document.querySelectorAll('[id^=menuOptionItem]')]
        .filter(e => e.offsetParent).map(e => e.id + ':' + (e.innerText||'').trim())""")
    raise RuntimeError(f"Edit-formula option not found for {heading!r}; visible menu: {items}")


def _dump_formula_dialog(page):
    """Discovery: list every visible input/checkbox in the open dialog with row context."""
    return page.evaluate(r"""() => {
      const vis = e => e.offsetParent !== null;
      const row = e => { const tr = e.closest('tr');
                         return tr ? (tr.innerText||'').trim().split('\n')[0].slice(0,60) : ''; };
      return [...document.querySelectorAll('input,textarea')].filter(vis).map(e => ({
        tag: e.tagName, id: e.id, name: e.name || '', type: e.type || '',
        value: (e.value||'').slice(0,60), checked: !!e.checked, row: row(e), dis: e.disabled
      }));
    }""")


def pin_heading(page, current, required):
    """Open Edit Column Formula for the column now headed `current`; tick Custom
    Headings; set Column Heading = `required`; OK. Idempotent."""
    _open_formula_dialog(page, current)
    cb = page.locator('input[name="customHdg"]:visible').first
    cb.wait_for(state="visible", timeout=10000)
    if not cb.is_checked():
        cb.evaluate("el => el.click()"); time.sleep(0.6)
    box = page.locator('input[name="columnHdg"]:visible').first
    for _ in range(10):                       # enables once customHdg is ticked
        if box.is_enabled():
            break
        time.sleep(0.5)
    box.fill(required); time.sleep(0.4)
    _click_ok_topmost(page); time.sleep(2.0)
    _step(f"pinned: {current!r} -> {required!r}")


def do_pin(page, base, src, expected, renames):
    """Pin EVERY column's Custom Heading. `expected` = required headings; `renames` maps
    a currently-displayed heading -> its required heading. Saves over the SAME name.
    Returns (before, after) heading lists."""
    open_existing(page, base, src)
    click_tab(page, "Criteria")
    if not _wait_columns(page):
        _shot(page, "nocols"); raise RuntimeError("Criteria columns did not render")
    before = _headings(page)
    _step(f"current headings ({len(before)}): {before}")
    exp = set(expected)
    for cur in before:
        req = renames.get(cur) or (cur if cur in exp else None)
        if req is None:
            _step(f"SKIP unexpected column (not in colmap, no rename): {cur!r}")
            continue
        pin_heading(page, cur, req)
    after = _headings(page)
    _step(f"headings after edits ({len(after)}): {after}")
    save_as(page, src.rsplit("/", 1)[1])
    return before, after


def save_as(page, name):
    """Save As into the dialog's DEFAULT folder (= the source analysis's folder), under
    `name`. We never navigate away, so the copy lands beside the source."""
    _step(f"save as: {name}")
    btn = page.locator('#uberBar_saveas')
    btn.first.wait_for(state="visible", timeout=STEP_TIMEOUT)
    btn.first.click()
    name_box = None
    for _ in range(int((LAZY + 14) / 0.8)):
        time.sleep(0.8)
        nb = page.locator('#idFilename')
        if nb.count() and nb.first.is_visible():
            name_box = nb.first; break
    if not name_box:
        _shot(page, "savedlg"); raise RuntimeError("Save As dialog (#idFilename) did not appear")
    cur = page.evaluate(r"""() => {
      const e = document.querySelector('#idSaveCurrentFolder,[id*="CurrentFolder" i]');
      return e ? (e.innerText||e.value||'').trim() : '';
    }""")
    _step(f"save-in folder (dialog default): {cur!r}")
    name_box.fill(name); time.sleep(0.4)
    _click_ok_topmost(page); time.sleep(2.5)
    # Confirm Overwrite only if the name already exists (shouldn't for new names)
    conf = page.locator('text="Confirm Overwrite"')
    if conf.count() and conf.first.is_visible():
        _step("name exists -> confirming overwrite")
        _click_ok_topmost(page); time.sleep(2)
    time.sleep(LAZY + 2)
    _step("saved")


def do_copy(page, base, src, to_name, hour=None, minute=None, on_column="Last Updated Date"):
    open_existing(page, base, src)
    click_tab(page, "Criteria")
    if not _wait_columns(page):
        _shot(page, "nocols"); raise RuntimeError("Criteria columns did not render")
    if hour:
        add_relative_filter(page, on_column, "HOUR", hour)
    elif minute:
        add_relative_filter(page, on_column, "MINUTE", minute)
    save_as(page, to_name)


def do_edit(page, base, src, remove_cols):
    """In-place edit: remove columns, then Save As under the SAME name (overwrite)."""
    open_existing(page, base, src)
    click_tab(page, "Criteria")
    if not _wait_columns(page):
        _shot(page, "nocols"); raise RuntimeError("Criteria columns did not render")
    for heading in remove_cols:
        remove_column(page, heading)
    save_as(page, src.rsplit("/", 1)[1])


# --------------------------------------------------------------------------- #
def _probe(page, base, src):
    page.set_viewport_size({"width": 1920, "height": 1080})
    open_existing(page, base, src)
    click_tab(page, "Criteria")
    _wait_columns(page)
    cols = page.evaluate("""() => [...document.querySelectorAll('div.columnHeader')]
        .map(e => (e.innerText||'').trim()).slice(0,40)""")
    _step(f"columns ({len(cols)}): {cols}")
    _shot(page, "probe")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--probe")
    ap.add_argument("--probe-formula", help="open Edit Column Formula for --column and dump dialog fields")
    ap.add_argument("--column", help="column heading for --probe-formula")
    ap.add_argument("--copy")
    ap.add_argument("--edit")
    ap.add_argument("--remove-columns")
    ap.add_argument("--to")
    ap.add_argument("--hour", type=int)
    ap.add_argument("--minute", type=int)
    ap.add_argument("--on-column", default="Last Updated Date")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--headed", action="store_true")
    a = ap.parse_args()

    env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
           "analytics_base_url": DEFAULT_BASE,
           "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}

    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not a.headed)
        page = ctx.new_page(); page.set_default_timeout(STEP_TIMEOUT)
        try:
            if a.probe:
                _probe(page, DEFAULT_BASE, a.probe)
            elif a.probe_formula and a.column:
                open_existing(page, DEFAULT_BASE, a.probe_formula)
                click_tab(page, "Criteria")
                if not _wait_columns(page):
                    _shot(page, "nocols"); raise RuntimeError("Criteria columns did not render")
                _step(f"headings: {_headings(page)}")
                _open_formula_dialog(page, a.column)
                import json as _json
                _step("dialog fields:\n" + _json.dumps(_dump_formula_dialog(page), indent=1))
                _shot(page, "formula_dlg")
            elif a.edit and a.remove_columns:
                cols = [c.strip() for c in a.remove_columns.split(",") if c.strip()]
                do_edit(page, DEFAULT_BASE, a.edit, cols)
                _step(f"DONE (edited in place) -> {a.edit}")
                if a.verify:
                    _step("verifying CSV download of the edited analysis...")
                    csv = extract.download_csv(ctx, env, a.edit)
                    lines = csv.splitlines()
                    _step(f"VERIFY OK — {len(lines)} CSV lines; header: {lines[0] if lines else '(empty)'}")
            elif a.copy and a.to:
                folder = a.copy.rsplit("/", 1)[0]
                new_path = folder + "/" + a.to
                do_copy(page, DEFAULT_BASE, a.copy, a.to,
                        hour=a.hour, minute=a.minute, on_column=a.on_column)
                _step(f"DONE -> {new_path}")
                if a.verify:
                    _step("verifying CSV download of the new analysis...")
                    csv = extract.download_csv(ctx, env, new_path)
                    lines = csv.splitlines()
                    _step(f"VERIFY OK — {len(lines)} CSV lines; header: {lines[0] if lines else '(empty)'}")
            else:
                sys.exit("use --probe <path>  OR  --copy <path> --to <NAME> [--hour N|--minute N]"
                         "  OR  --edit <path> --remove-columns 'A,B,C'")
        except Exception:
            _shot(page, "error"); raise
        finally:
            browser.close()


if __name__ == "__main__":
    main()
