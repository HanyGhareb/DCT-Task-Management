"""otbi-atd action : update a task's Additional Information on a project's
financial plan in Oracle Fusion PPM (Manage Financial Project Plan).

Purpose (first use): set the "Organization Reference" DFF segment (a cost
centre) on one plan task. The other popup segments (Entity Specific /
Appropriation / Program / BG Override / Revenue Account Override) are also
fillable when present in the payload.

Driven through the Fusion UI using the shared, already-authenticated browser
context — the same SSO/MFA session the OTBI extract jobs use. There is NO REST
alternative: fscmRestApi returns 401 even with a full UI cookie session under
the federated ADGOV SSO (see docs/fusion-actions/README.md), so the UI robot is
the only channel. Navigation replicates the manual flow exactly:

  FuseWelcome -> Navigator -> expand "Projects"
    -> "Project Financial Management" work area (My Projects)
    -> search by Project Number -> open the project (Project Overview)
    -> Tasks drawer -> "Manage Financial Project Plan"
    -> Display = List -> QBE-filter the tasks table by Task Number
    -> row's "Additional Information" icon -> popup
    -> fill Organization Reference (LOV autosuggest) -> OK -> Save.

Proven ADF gotchas baked in (from the fusion-actions read PoC, 2026-06-30):
  * ADF intercepts normal clicks -> fire el.click() in-DOM (_jsclick);
  * Navigator sub-items are lazy -> expand the group first;
  * label-adjacent input fill via _fill_label (panelFormLayout markup).

Idempotency (mandatory for writes): this is an UPDATE, naturally idempotent —
re-applying the same value changes nothing. Before filling we read the current
Organization Reference in the popup; if it already carries the target cost
centre we close the popup and return "already set" without saving.

Safety: nothing is saved unless ATD_ACTION_LIVE=1. Otherwise we navigate,
filter, open the popup, fill it and click OK (all in-memory on the ADF page),
then raise actions.DryRun BEFORE the page-level Save — so a dry run exercises
every selector without committing anything.

NOTE — pod-specific selectors: the Navigator group/item ids and the plan-table
locators are a first cut and MUST be confirmed in a HEADED/screenshot run
(smoke_ppm_task.py) before the first live save. The framework around them
(queue, idempotency, dry-run, result callback) is release-independent.
"""
import os
import time

from . import DryRun
from .ap_invoice import _apps_base  # same Fusion apps-base resolution rules

POPUP_TITLE = "Additional Information"

# payload key -> the popup field's visible label (screenshot-confirmed)
ADDL_FIELDS = {
    "entitySpecific":         "Entity Specific",
    "appropriation":          "Appropriation",
    "program":                "Program",
    "bgOverride":             "BG Override",
    "orgReference":           "Organization Reference",
    "revenueAccountOverride": "Revenue Account Override",
}


def _live():
    return os.environ.get("ATD_ACTION_LIVE", "0") == "1"


def _shot(page, name):
    """Debug screenshot (headless selector tuning): set ATD_ACTION_SHOT_DIR."""
    d = os.environ.get("ATD_ACTION_SHOT_DIR")
    if not d:
        return
    try:
        page.screenshot(path=os.path.join(d, name), full_page=True)
    except Exception:  # noqa: BLE001
        pass


def validate_payload(data):
    """Raise on a malformed payload; return (project, task, org_ref)."""
    project = (str(data.get("projectNumber") or "")).strip()
    task = (str(data.get("taskNumber") or "")).strip()
    org_ref = (str(data.get("orgReference") or "")).strip()
    if not project or not task or not org_ref:
        raise RuntimeError("PPM_TASK_ADDL_INFO payload needs projectNumber, "
                           "taskNumber and orgReference")
    return project, task, org_ref


def _jsclick(scope, selectors, label, required=True):
    """Fire el.click() in-DOM on the first VISIBLE match of the first matching
    selector (ADF intercepts normal Playwright clicks — proven in the
    fusion-actions read PoC). Visible-first matters: ADF keeps hidden
    duplicates in the DOM (topbar Personalize spans, pre-rendered dialog
    buttons) that match text selectors earlier in document order. Falls back
    to the first match when no match reports visible."""
    if isinstance(selectors, str):
        selectors = [selectors]
    for s in selectors:
        try:
            loc = scope.locator(s)
            n = loc.count()
            if n == 0:
                continue
            target = loc.first
            for i in range(min(n, 12)):
                try:
                    if loc.nth(i).is_visible():
                        target = loc.nth(i)
                        break
                except Exception:  # noqa: BLE001
                    pass
            target.evaluate("el => el.click()")
            return True
        except Exception:  # noqa: BLE001
            pass
    if required:
        raise RuntimeError(f"{label}: no matching element (selectors {selectors})")
    return False


def _fill_label(page, label_text, value):
    """Fill the input adjacent to a visible label (ADF panelFormLayout).
    Tolerates the '**'/'*' required-marker prefix ADF prepends to labels."""
    js = """(args)=>{const[label,val]=args;
      const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();
      for(const l of document.querySelectorAll('label,span,div')){
        if(norm(l.innerText)===label){let p=l.closest('tr,div');let d=0;
          while(p&&d<5){const inp=p.querySelector('input:not([type=hidden]),textarea');
            if(inp){inp.focus();inp.value=val;inp.dispatchEvent(new Event('input',{bubbles:true}));
              inp.dispatchEvent(new Event('change',{bubbles:true}));return true;}
            p=p.parentElement;d++;}}}return false;}"""
    try:
        return bool(page.evaluate(js, [label_text, value]))
    except Exception:  # noqa: BLE001
        return False


def _label_input_id(page, label_text):
    """The DOM id of the visible input adjacent to a visible label, or None."""
    js = """(label)=>{const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();
      const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
      for(const l of document.querySelectorAll('label,span,div')){
        if(norm(l.innerText)===label && vis(l)){let p=l.closest('tr,div');let d=0;
          while(p&&d<5){const inp=p.querySelector('input:not([type=hidden]),textarea');
            if(inp && vis(inp)) return inp.id||null;
            p=p.parentElement;d++;}}}return null;}"""
    try:
        return page.evaluate(js, label_text)
    except Exception:  # noqa: BLE001
        return None


def _fill_label_real(page, label_text, value):
    """Fill the input adjacent to a visible label with REAL keyboard input +
    Tab blur. Round-10 proved the JS value-set (_fill_label) does NOT register
    in ADF's client component state on af:query fields — the search ran with
    an empty Project Number. ADF syncs the component on real typing/blur."""
    iid = _label_input_id(page, label_text)
    if not iid:
        return False
    # ADF ids contain ':' — attribute selector avoids CSS escaping issues
    loc = page.locator(f'[id="{iid}"]')
    try:
        loc.click(timeout=5000)
        loc.fill("")
        try:
            loc.press_sequentially(value, delay=30)
        except AttributeError:  # older Playwright
            loc.type(value, delay=30)
        page.keyboard.press("Tab")
        return True
    except Exception:  # noqa: BLE001
        return False


def _clear_label_field(page, label_text):
    """Clear a pre-filled query field (LOV combobox) with real keystrokes.
    The 'My Active Projects' saved search pre-fills Team Member + Project
    Status, which over-constrain the Project Number query (round-11: the
    number was typed correctly but the combined criteria returned 0 rows)."""
    iid = _label_input_id(page, label_text)
    if not iid:
        return False
    loc = page.locator(f'[id="{iid}"]')
    try:
        if not (loc.input_value() or "").strip():
            return True
        loc.click(timeout=5000)
        page.keyboard.press("Control+a")
        page.keyboard.press("Delete")
        page.keyboard.press("Tab")
        time.sleep(1)
        return True
    except Exception:  # noqa: BLE001
        return False


def _label_on_page(page, label_text):
    """True when a (required-marker-tolerant) label is present in the DOM."""
    js = """(label)=>{const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();
      return [...document.querySelectorAll('label,span,div')]
        .some(l=>norm(l.innerText)===label);}"""
    try:
        return bool(page.evaluate(js, label_text))
    except Exception:  # noqa: BLE001
        return False


def _dismiss_overlays(page):
    """Close a still-open Navigator/menu overlay (it covers the work-area form —
    seen on the first vm181 dry run: My Projects loaded BEHIND the open menu)."""
    for _ in range(2):
        try:
            page.keyboard.press("Escape")
        except Exception:  # noqa: BLE001
            pass
        time.sleep(1)


def _open_tasks_drawer(page):
    """Open the right-edge Tasks panel drawer (clipboard icon) if closed."""
    if page.locator('a:has-text("Manage Financial Project Plan"), a:has-text("My Projects")').count() == 0:
        _jsclick(page, '[title="Tasks"]', "Tasks drawer", required=False)
        time.sleep(3)


def _goto_my_projects(page, base):
    """FuseWelcome -> Navigator -> Projects group -> PFM work area -> My Projects."""
    page.goto(base + "/fscmUI/faces/FuseWelcome", wait_until="domcontentloaded")
    time.sleep(9)
    try:
        page.locator('a[title="Navigator"]').first.click()
    except Exception:  # noqa: BLE001
        pass
    time.sleep(4)
    # sub-items are lazy: expand the Projects group first (id mirrors groupNode_payables)
    _jsclick(page, ['a[id="groupNode_projects"]', 'a[id*="groupNode"][id*="project" i]'],
             "expand Projects group", required=False)
    time.sleep(2)
    _jsclick(page, ['a[id*="itemNode_projects"][id*="financial" i]',
                    'a:has-text("Project Financial Management")'],
             "Projects>Project Financial Management")
    time.sleep(15)
    # the Navigator overlay can stay open over the loaded work area — close it
    _dismiss_overlays(page)
    # the work area may not land on My Projects — reach it via the Tasks drawer
    if not _label_on_page(page, "Project Number"):
        _open_tasks_drawer(page)
        if _jsclick(page, 'a:has-text("My Projects")', "My Projects", required=False):
            time.sleep(6)
            _dismiss_overlays(page)


def _search_input_ready(page):
    """True when a 'Project Number' label has an actual INPUT nearby — the bare
    label text is a FALSE signal (the results grid's column header is also
    'Project Number'; vm181 diag run proved the collapsed panel renders NO
    inputs at all: main frame had labelPN=2 but inputs=2 page-wide)."""
    js = """()=>{const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();
      for(const l of document.querySelectorAll('label,span,div')){
        if(norm(l.innerText)==='Project Number'){let p=l.closest('tr,div');let d=0;
          while(p&&d<4){if(p.querySelector('input:not([type=hidden])'))return true;
            p=p.parentElement;d++;}}}return false;}"""
    try:
        return bool(page.evaluate(js))
    except Exception:  # noqa: BLE001
        return False


def _expand_search_panel(page):
    """My Projects lands with the '▶ Search' region COLLAPSED and its form
    fields NOT in the DOM (lazy panel). The af:query disclosure is an anchor
    with title="Expand Search" and id ending '::_afrDscl' (round-9 diag HTML
    dump) — a REAL Playwright pointer click on that VISIBLE anchor expands the
    panel (verified: visible inputs 1 -> 12). Text-based clicks NEVER work: the
    header <h1>Search</h1> ignores clicks, and the topbar holds a HIDDEN
    'Search' span (Personalize Global Search, display:none) that matches
    exact-text first in document order."""
    for _ in range(3):
        if _search_input_ready(page):
            return
        for sel in ('a[title="Expand Search"]',
                    'a[id$="_afrDscl"][title*="Expand" i]',
                    '[title*="Expand Search" i]',
                    '[title*="Expand" i]'):
            loc = page.locator(sel)
            clicked = False
            for i in range(min(loc.count(), 10)):
                el = loc.nth(i)
                try:
                    if el.is_visible():
                        el.click(timeout=3000)
                        clicked = True
                        break
                except Exception:  # noqa: BLE001
                    pass
            if clicked:
                time.sleep(4)
                if _search_input_ready(page):
                    return
        time.sleep(3)


def _open_project(page, project_number):
    """Search My Projects by project number and open the project overview."""
    _expand_search_panel(page)
    # widen the query: the saved search pre-fills these two (see helper doc)
    _clear_label_field(page, "Team Member")
    _clear_label_field(page, "Project Status")
    if not _fill_label_real(page, "Project Number", project_number):
        loc = page.locator('input[aria-label*="Project Number"], input[id*="ProjectNumber"]')
        if loc.count() == 0:
            raise RuntimeError("Project Number search field not found on My Projects")
        loc.first.click()
        loc.first.fill(project_number)
        page.keyboard.press("Tab")
    _shot(page, "ppm_01b_search_filled.png")
    # real pointer click on the visible Search button (query submit)
    btn = page.locator('button:has-text("Search")')
    clicked = False
    for i in range(min(btn.count(), 10)):
        if btn.nth(i).is_visible() and btn.nth(i).inner_text().strip() == "Search":
            btn.nth(i).click(timeout=5000)
            clicked = True
            break
    if not clicked:
        _jsclick(page, ['//button[normalize-space(.)="Search"]', 'button[id$="search"]'],
                 "Search")
    time.sleep(8)
    if not _jsclick(page, f'a:has-text("{project_number}")',
                    "open project", required=False):
        raise RuntimeError(f"project {project_number!r} not found in My Projects results")
    time.sleep(12)


def _open_financial_plan(page):
    """From Project Overview, open Manage Financial Project Plan; Display=List."""
    _open_tasks_drawer(page)
    _jsclick(page, 'a:has-text("Manage Financial Project Plan")',
             "Manage Financial Project Plan")
    time.sleep(12)
    # Display: Hierarchy | List -> List (QBE filtering needs the flat list)
    js = """() => {
      for (const r of document.querySelectorAll('input[type=radio]')) {
        const id = r.id || '';
        const lbl = (id && document.querySelector(`label[for="${CSS.escape(id)}"]`)) || r.closest('label');
        if (lbl && (lbl.innerText||'').trim() === 'List') { r.click(); return true; }
      }
      return false; }"""
    try:
        if not page.evaluate(js):
            _jsclick(page, ['label:has-text("List")'], "Display=List", required=False)
    except Exception:  # noqa: BLE001
        pass
    time.sleep(5)


def _addl_icon_id(page, task_number):
    """The DOM id of the task row's Additional Information icon anchor.
    Ground truth (diag3 on the live plan): the Task Number cell renders as
    span id '…:tt1:<row>:tNum::content' and the SAME row's icon anchor is
    '…:tt1:<row>:dffIL1' — identical prefix, so locate the span by exact text
    and swap the suffix. No tr/row heuristics (the ADF page is nested tables
    and rows split across frozen/scrollable grids — every row-walk guess
    failed rounds 12-13)."""
    js = """(task)=>{const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
      const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
      for(const s of document.querySelectorAll(
          'span[id$=":tNum::content"], input[id$=":tNum::content"]')){
        const txt = s.tagName==='INPUT' ? s.value : s.innerText;
        if(norm(txt)===task && vis(s))
          return s.id.slice(0,-'tNum::content'.length)+'dffIL1';}
      return null;}"""
    try:
        return page.evaluate(js, task_number)
    except Exception:  # noqa: BLE001
        return None


def _find_popup(page):
    """Locator for the OPEN Additional Information dialog, or None. ADF
    panelWindow popups carry NO role="dialog" (round-14: the popup was open
    on-screen and the role-based detector missed it) — so anchor on the
    visible title text and walk up to the smallest div that holds the DFF
    inputs + the Organization Reference label."""
    js = """(title)=>{const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
      const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
      for(const el of document.querySelectorAll('div,span,td,h1,h2')){
        if(el.children.length===0 && norm(el.innerText)===title && vis(el)){
          let p=el.parentElement;
          while(p){
            if(p.tagName==='DIV'
               && p.querySelectorAll('input:not([type=hidden])').length>=3
               && p.innerText.indexOf('Organization Reference')>=0){
              if(!p.id) p.id='atdAddlPopup';
              return p.id;}
            p=p.parentElement;}}}
      return null;}"""
    try:
        pid = page.evaluate(js, POPUP_TITLE)
    except Exception:  # noqa: BLE001
        pid = None
    return page.locator(f'[id="{pid}"]') if pid else None


def _open_addl_popup(page, task_number):
    """Open the task row's Additional Information popup via a REAL pointer
    click on the icon anchor located BY ID (see _addl_icon_id)."""
    dlg = _find_popup(page)
    if dlg is not None:  # already open (e.g. read-back after Save)
        return dlg
    icon_id = _addl_icon_id(page, task_number)
    if not icon_id:
        raise RuntimeError(f"task {task_number!r} not found on the financial plan "
                           "(check the Task Number and that Display=List)")
    icon = page.locator(f'[id="{icon_id}"]')
    if icon.count() == 0:
        raise RuntimeError(f"Additional Information icon {icon_id!r} not in DOM "
                           "(column may be hidden — check View > Columns)")
    for _ in range(3):
        try:
            icon.first.click(timeout=5000)
        except Exception:  # noqa: BLE001
            _jsclick(page, f'[id="{icon_id}"]', "Additional Information icon",
                     required=False)
        time.sleep(5)
        dlg = _find_popup(page)
        if dlg is not None:
            return dlg
    raise RuntimeError("Additional Information popup did not open")


def _popup_field(dlg, label):
    """The input for a labelled popup field (ADF DFF segment)."""
    for s in (f'input[aria-label*="{label}"]',
              f'tr:has(label:has-text("{label}")) input:not([type="hidden"])',
              f'td:has-text("{label}") + td input'):
        loc = dlg.locator(s)
        if loc.count() > 0:
            return loc.first
    try:
        f = dlg.get_by_label(label, exact=False)
        if f.count() > 0:
            return f.first
    except Exception:  # noqa: BLE001
        pass
    return None


def _fill_lov(page, field, value):
    """Fill an LOV-backed segment and pick the autosuggest entry carrying value.
    Must TYPE for real: fill() sets the value without keystrokes, so the ADF
    autosuggest never fires and the component state stays empty (round-10)."""
    field.click()
    field.fill("")
    try:
        field.press_sequentially(str(value), delay=40)
    except AttributeError:  # older Playwright
        field.type(str(value), delay=40)
    time.sleep(3)
    # the suggest list renders in a floating popup (e.g. "DCT Finance | 4510195")
    # — REAL click on the VISIBLE entry (round-15: the JS click left the list
    # open, so the pick had not registered with the ADF component)
    picked = False
    for sel in (f'li:has-text("{value}")', f'td:has-text("{value}")',
                f'div[role="option"]:has-text("{value}")'):
        loc = page.locator(sel)
        for i in range(min(loc.count(), 8)):
            el = loc.nth(i)
            try:
                if el.is_visible():
                    el.click(timeout=3000)
                    picked = True
                    break
            except Exception:  # noqa: BLE001
                pass
        if picked:
            break
    if not picked:
        field.press("Tab")  # let ADF auto-match the unique value
    time.sleep(2)


def _fill_popup(page, dlg, data, org_ref):
    """Fill Organization Reference (+ any other provided segments). Returns
    (current, resolved): the pre-existing Organization Reference value (for
    the idempotency verdict) and the DISPLAY text the LOV resolved the code to
    (Fusion shows the description, e.g. 'DCT ALC Executive Director's Office
    Division' for 4510195 — the read-back after Save must compare against
    THAT, not the code)."""
    org_field = _popup_field(dlg, ADDL_FIELDS["orgReference"])
    if org_field is None:
        raise RuntimeError("Organization Reference field not found in the popup")
    current = ""
    try:
        current = (org_field.input_value() or "").strip()
    except Exception:  # noqa: BLE001
        pass
    if org_ref in current:
        return current, current  # already set — caller skips the save
    for key, label in ADDL_FIELDS.items():
        if key == "orgReference":
            continue
        val = data.get(key)
        if val in (None, ""):
            continue
        fld = _popup_field(dlg, label)
        if fld is None:
            raise RuntimeError(f"popup field {label!r} not found")
        _fill_lov(page, fld, val)
    _fill_lov(page, org_field, org_ref)
    resolved = ""
    try:
        resolved = (org_field.input_value() or "").strip()
    except Exception:  # noqa: BLE001
        pass
    return current, resolved


def _raise_on_adf_error(page):
    err = page.locator('div[role="alertdialog"], div[id*="msgDlg"]')
    if err.count() > 0 and err.first.is_visible():
        txt = ""
        try:
            txt = err.first.inner_text()[:500]
        except Exception:  # noqa: BLE001
            pass
        if "error" in txt.lower():
            raise RuntimeError(f"Fusion raised an error on Save: {txt}")


def update(ctx, env, data, action):
    """Update one plan task's Additional Information. Returns (fusion_id, ref).
    fusion_id = '<project>/<task>' (no new Fusion object is created)."""
    project, task, org_ref = validate_payload(data)
    base = _apps_base(env)
    page = ctx.new_page()
    page.set_default_timeout(45000)
    page.set_viewport_size({"width": 1700, "height": 1000})
    try:
        _goto_my_projects(page, base)
        _shot(page, "ppm_01_my_projects.png")
        _open_project(page, project)
        _shot(page, "ppm_02_project_overview.png")
        _open_financial_plan(page)
        _shot(page, "ppm_03_plan_list.png")
        dlg = _open_addl_popup(page, task)

        current, resolved = _fill_popup(page, dlg, data, org_ref)
        _shot(page, "ppm_04_popup_filled.png")
        if org_ref in current:
            # idempotency: the target cost centre is already on the task
            _jsclick(dlg, ['//button[normalize-space(.)="Cancel"]',
                           'a:has-text("Cancel")'], "popup Cancel", required=False)
            return f"{project}/{task}", f"already set ({current}) — idempotent skip"
        _jsclick(dlg, ['//button[normalize-space(.)="OK"]', 'a:has-text("OK")'],
                 "popup OK")
        time.sleep(3)

        # safety gate: everything above is in-memory on the ADF page
        if not _live():
            raise DryRun(f"PPM_TASK_ADDL_INFO {project}/{task}: popup filled with "
                         f"orgReference={org_ref} but ATD_ACTION_LIVE!=1 -> NOT saved "
                         "(set ATD_ACTION_LIVE=1 to update for real)")

        # page-level Save: NOT a <button> in this skin (round-17: the XPath
        # matched nothing while the button was plainly on screen) — real click
        # on the first VISIBLE element with exact text 'Save' ('Save and
        # Close' cannot match an exact-text locator)
        saved_click = False
        loc = page.get_by_text("Save", exact=True)
        for i in range(min(loc.count(), 10)):
            el = loc.nth(i)
            try:
                if el.is_visible():
                    el.click(timeout=5000)
                    saved_click = True
                    break
            except Exception:  # noqa: BLE001
                pass
        if not saved_click:
            _jsclick(page, ['//button[normalize-space(.)="Save"]',
                            '//a[normalize-space(.)="Save"]'], "Save")
        time.sleep(8)
        _raise_on_adf_error(page)

        # read-back: re-open the popup on the same row and confirm the value
        # stuck — Fusion shows the LOV DESCRIPTION after commit, so match the
        # code OR the resolved display text captured at fill time
        dlg = _open_addl_popup(page, task)
        fld = _popup_field(dlg, ADDL_FIELDS["orgReference"])
        saved = (fld.input_value() or "").strip() if fld is not None else ""
        norm = " ".join(saved.split())
        ok = (org_ref in saved) or (resolved and norm == " ".join(resolved.split()))
        if not ok:
            raise RuntimeError(f"PPM_TASK_ADDL_INFO {project}/{task}: Save did not stick "
                               f"(popup now shows {saved!r}, expected {resolved or org_ref!r})"
                               " — not marking DONE so it can retry")
        _jsclick(dlg, ['//button[normalize-space(.)="Cancel"]', 'a:has-text("Cancel")'],
                 "popup Cancel", required=False)
        _shot(page, "ppm_05_saved.png")
    except Exception:
        _shot(page, "ppm_99_failure.png")
        raise
    finally:
        page.close()
    return f"{project}/{task}", f"updated orgReference {current or '(empty)'} -> {org_ref}"
