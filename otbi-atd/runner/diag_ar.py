"""Diagnostic for the AR_INVOICE_REBILL navigation (Receivables -> Billing).

Screenshots tell you WHAT to click; they never tell you the SELECTOR. ADF ids
are generated, the DOM keeps hidden duplicates of visible controls, and grids
are split into frozen/scrollable halves -- which is why the PPM action needed a
19-round tune. This script closes that gap: it reuses the saved SSO session,
walks to a named AR screen, and dumps every VISIBLE label->input id, clickable,
titled icon and table id-scheme it finds. Write the handler selectors from its
output, not from a guess.

Run one screen at a time on a worker VM with a live session:

    python diag_ar.py nav
    python diag_ar.py billing
    python diag_ar.py search    INV00583863
    python diag_ar.py review    INV00583863
    python diag_ar.py creditform INV00583863
    python diag_ar.py duplicate INV00583863
    python diag_ar.py linedff   45110096148     # a COMPLETED invoice

Every screen also writes diag_ar_<screen>.png. READ-ONLY: it navigates and
opens forms but never clicks Save / Complete / OK, so nothing is committed.
"""
import json
import os
import sys
import time

from playwright.sync_api import sync_playwright

import auth
import config
from actions import ar_invoice_rebill as ar
from actions.ap_invoice import _apps_base
from actions.ppm_task_addl import (
    _dismiss_overlays,
    _jsclick,
    _label_input_id,
    _fill_label_real,
)

SHOT_PREFIX = "diag_ar_"


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    return {"env_name": e["env_name"], "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


# --------------------------------------------------------------------------
# DOM scanners. Every one filters to VISIBLE elements (ADF law 1) -- an id
# harvested from a hidden duplicate is worse than no id at all.
# --------------------------------------------------------------------------
_VIS = ("const vis=e=>e&&e.offsetParent!==null&&"
        "e.getBoundingClientRect().width>0&&e.getBoundingClientRect().height>0;")
_NORM = "const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();"

JS_LABELED_INPUTS = """()=>{%s%s
  const out=[];
  document.querySelectorAll('input:not([type=hidden]),textarea,select').forEach(inp=>{
    if(!vis(inp))return;
    let label='';
    // ADF renders the label as a sibling/ancestor cell, not a <label for=>
    let p=inp.closest('tr,td,div'); let d=0;
    while(p&&d<5&&!label){
      for(const l of p.querySelectorAll('label,span')){
        const t=norm(l.innerText);
        if(t&&t.length<60&&!l.contains(inp)){label=t;break;}
      }
      p=p.parentElement;d++;
    }
    out.push({label:label,id:inp.id||'',tag:inp.tagName.toLowerCase(),
              type:inp.type||'',value:(inp.value||'').slice(0,40)});
  });
  return out;}""" % (_VIS, _NORM)

JS_CLICKABLES = """()=>{%s%s
  const out=[];
  document.querySelectorAll('a,button,[role=button]').forEach(el=>{
    if(!vis(el))return;
    const t=norm(el.innerText)||norm(el.getAttribute('title'))||'';
    if(!t||t.length>60)return;
    out.push({text:t,id:el.id||'',title:el.getAttribute('title')||'',
              tag:el.tagName.toLowerCase()});
  });
  return out;}""" % (_VIS, _NORM)

JS_TITLED = """()=>{%s%s
  const out=[];
  document.querySelectorAll('[title],[alt]').forEach(el=>{
    if(!vis(el))return;
    const t=el.getAttribute('title')||el.getAttribute('alt')||'';
    if(!t||t.length>60)return;
    out.push({title:norm(t),id:el.id||'',tag:el.tagName.toLowerCase()});
  });
  return out;}""" % (_VIS, _NORM)

# ADF law 5: never walk <tr> ancestors -- harvest the deterministic id scheme
# from the grid instead (…:tt1:<row>:<field>::content and friends).
JS_TABLES = """()=>{%s%s
  const out=[];
  document.querySelectorAll('table').forEach(tb=>{
    if(!vis(tb))return;
    const heads=[...tb.querySelectorAll('th')].map(h=>norm(h.innerText))
                 .filter(t=>t).slice(0,25);
    if(!heads.length)return;
    const cellIds=[];
    const rows=[...tb.querySelectorAll('tr')].slice(0,4);
    rows.forEach(r=>{
      [...r.querySelectorAll('td')].slice(0,25).forEach(td=>{
        const el=td.querySelector('[id]');
        if(el&&el.id)cellIds.push({text:norm(td.innerText).slice(0,30),id:el.id});
      });
    });
    out.push({tableId:tb.id||'',headers:heads,sampleCellIds:cellIds.slice(0,30)});
  });
  return out;}""" % (_VIS, _NORM)


JS_SELECT_OPTIONS = """()=>{%s%s
  const out=[];
  document.querySelectorAll('select').forEach(sel=>{
    if(!vis(sel))return;
    let lab='';
    if(sel.id){const l=document.querySelector('label[for="'+CSS.escape(sel.id)+'"]');
               if(l)lab=norm(l.innerText);}
    out.push({label:lab,id:sel.id||'',value:sel.value,
              options:Array.from(sel.options).map(o=>o.text).slice(0,40)});
  });
  return out;}""" % (_VIS, _NORM)


def dump(page, screen, extra=None):
    """Report everything a handler author needs for this screen."""
    print("\n" + "=" * 74)
    print("SCREEN:", screen, "|", page.url[:110])
    print("=" * 74)

    print("\n--- FRAMES ---")
    for f in page.frames:
        print("  ", (f.name or "<main>")[:38], "|", f.url[:100])

    for title, js in (("LABELLED INPUTS (label -> id)", JS_LABELED_INPUTS),
                      ("CLICKABLES (text | id | title)", JS_CLICKABLES),
                      ("TITLED / ICONS", JS_TITLED),
                      ("SELECT DROPDOWNS (label | id | options)",
                       JS_SELECT_OPTIONS),
                      ("TABLES (headers + id scheme)", JS_TABLES)):
        print("\n--- %s ---" % title)
        try:
            rows = page.evaluate(js)
        except Exception as e:  # noqa: BLE001
            print("   ERR", str(e)[:90])
            continue
        if not rows:
            print("   (none visible)")
            continue
        seen = set()
        for r in rows:
            key = json.dumps(r, sort_keys=True)
            if key in seen:
                continue
            seen.add(key)
            print("  ", json.dumps(r, ensure_ascii=False))

    if extra:
        print("\n--- SCREEN NOTES ---")
        for line in extra:
            print("  ", line)

    path = SHOT_PREFIX + screen + ".png"
    try:
        page.screenshot(path=path, full_page=True)
        print("\n   screenshot ->", path)
    except Exception as e:  # noqa: BLE001
        print("   screenshot failed:", str(e)[:80])


# --------------------------------------------------------------------------
# Navigation, mirroring the manual walkthrough
# --------------------------------------------------------------------------
def goto_welcome(page, base):
    page.goto(base + "/fscmUI/faces/FuseWelcome", wait_until="domcontentloaded")
    time.sleep(9)


def open_navigator(page):
    try:
        page.locator('a[title="Navigator"]').first.click()
    except Exception:  # noqa: BLE001
        pass
    time.sleep(4)


def goto_billing(page, base):
    """Delegate to the HANDLER's navigation.

    The diag must drive the same code the robot drives, or the two drift and
    the diag "passes" against selectors the handler does not use. That already
    bit once: the diag kept a JS click on the Actions menu and an a: match on
    its entries after both were fixed in the handler, so the creditform screen
    silently dumped the Review Transaction page instead.
    """
    ar._goto_billing(page, base)
    return "handler"


def _goto_billing_unused(page, base):
    """Kept for reference: the original standalone navigation."""
    goto_welcome(page, base)
    open_navigator(page)
    # sub-items are lazy -- expand the group before clicking the item
    _jsclick(page, ['a[id="groupNode_receivables"]',
                    'a[id*="groupNode"][id*="receivable" i]'],
             "expand Receivables group", required=False)
    time.sleep(2)
    landed = _jsclick(page, ['a[id*="itemNode_receivables"][id*="billing" i]',
                             'a:has-text("Billing")'],
                      "Receivables>Billing", required=False)
    if landed:
        time.sleep(15)
        _dismiss_overlays(page)
        return "navigator"

    # fallback: springboard tab + app tile
    goto_welcome(page, base)
    _jsclick(page, ['a:has-text("Receivables")', '[title="Receivables"]'],
             "Receivables tab", required=False)
    time.sleep(4)
    _jsclick(page, ['a:has-text("Billing")', '[title="Billing"]'],
             "Billing tile", required=False)
    time.sleep(15)
    _dismiss_overlays(page)
    return "springboard"


def open_search_panel(page):
    """Delegate to the handler."""
    return ar._open_search_panel(page)


def _open_search_panel_unused(page):
    """Kept for reference."""
    for sel in ('[title="Search: Transactions"]',
                '[id$="TransactionsQuickSearch::icon"]',
                '[id*="TransactionsQuickSearch"]',
                'a[title="Expand Search"]', 'a[id$="_afrDscl"]'):
        loc = page.locator(sel)
        for i in range(min(loc.count(), 10)):
            el = loc.nth(i)
            try:
                if el.is_visible():
                    el.click(timeout=4000)
                    time.sleep(3)
                    if _label_input_id(page, "Transaction Number"):
                        return True
            except Exception:  # noqa: BLE001
                pass
    return bool(_label_input_id(page, "Transaction Number"))


def search_invoice(page, invoice):
    """Delegate to the handler's search."""
    ar._search_transaction(page, invoice)
    return True


def open_invoice(page, invoice):
    """Click the transaction-number link in the results grid."""
    if not search_invoice(page, invoice):
        return False
    # exact: a substring match on the invoice number also hits <invoice>CM
    ok = _jsclick(page, ar._txn_link(invoice), "open invoice", required=False)
    time.sleep(10)
    return ok


def open_actions_menu(page):
    # the handler uses a REAL pointer click here -- a JS click leaves the ADF
    # popup closed and its entries never enter the DOM
    ar._open_actions_menu(page)


# --------------------------------------------------------------------------
def main():
    screen = (sys.argv[1] if len(sys.argv) > 1 else "billing").lower()
    invoice = sys.argv[2] if len(sys.argv) > 2 else None

    env = _env_from_db()
    base = _apps_base(env)
    with sync_playwright() as p:
        # Standing rule: ride the worker's existing session, never log in
        # (a fresh login fires an MFA push and re-issues the cookies the
        # fleet is using). See step_ar_rebill.attach_existing_session.
        from step_ar_rebill import attach_existing_session
        browser, ctx = attach_existing_session(p, env, headless=True)
        try:
            page = ctx.new_page()
            page.set_default_timeout(45000)
            page.set_viewport_size({"width": 1700, "height": 1000})

            if screen == "nav":
                goto_welcome(page, base)
                open_navigator(page)
                dump(page, "nav", ["Looking for: groupNode_receivables and its "
                                   "itemNode_* children (Billing)."])

            elif screen == "billing":
                how = goto_billing(page, base)
                opened = open_search_panel(page)
                dump(page, "billing",
                     ["reached Billing via: %s" % how,
                      "search panel opened: %s" % opened,
                      "Transaction Number input id: %s"
                      % _label_input_id(page, "Transaction Number")])

            elif screen == "search":
                _need(invoice)
                goto_billing(page, base)
                search_invoice(page, invoice)
                dump(page, "search",
                     ["Results grid: capture the transaction-number link id "
                      "scheme AND the 'Original Transaction Number' column -- "
                      "that column is the credit-memo idempotency probe.",
                      "If no rows: the not-found path must fail the request "
                      "with 'Invoice %s not found'." % invoice])

            elif screen == "review":
                _need(invoice)
                goto_billing(page, base)
                open_invoice(page, invoice)
                open_actions_menu(page)
                dump(page, "review",
                     ["Actions menu must expose 'Credit Transaction' and "
                      "'Duplicate' -- capture both item ids.",
                      "Also capture the Invoice Lines grid id scheme (Line, "
                      "Memo Line, Tax Classification, Details icon)."])

            elif screen == "creditform":
                _need(invoice)
                goto_billing(page, base)
                open_invoice(page, invoice)
                open_actions_menu(page)
                _jsclick(page, ar.SEL["act_credit"],
                         "Credit Transaction", required=False)
                time.sleep(12)
                dump(page, "creditform",
                     ["Need ids for: Transaction Number, Transaction Date, "
                      "Accounting Date, Credit Reason, Comments.",
                      "Need ids for the buttons: 'Credit Entire Balance', "
                      "'Save', 'Complete and Close'.",
                      "NOTHING is clicked here -- the form is left uncommitted."])

            elif screen == "duplicate":
                _need(invoice)
                goto_billing(page, base)
                open_invoice(page, invoice)
                open_actions_menu(page)
                _jsclick(page, ar.SEL["act_duplicate"], "Duplicate",
                         required=False)
                time.sleep(12)
                dump(page, "duplicate",
                     ["Need ids for: Transaction Source, Transaction Date, "
                      "Accounting Date.",
                      "Need the LINE GRID id scheme: per-row Memo Line cell and "
                      "the Tax Classification dropdown (ADF law 5 -- id scheme, "
                      "never tr-walks).",
                      "Need the 'Complete and Review' button id.",
                      "NOTHING is clicked here -- nothing is committed."])

            elif screen == "linedff":
                _need(invoice)
                goto_billing(page, base)
                open_invoice(page, invoice)
                dump(page, "linedff_grid",
                     ["Capture the per-line 'Details' icon id scheme."])
                _jsclick(page, ar.SEL["line_details"],
                         "line Details icon", required=False)
                time.sleep(8)
                dump(page, "linedff",
                     ["Review Invoice Line: need ids for Project and Task "
                      "under 'Additional Information'.",
                      "Capture the LINE NAVIGATOR at top-right (the '1' select "
                      "with prev/next arrows) -- walking it avoids a full ADF "
                      "page cycle per line.",
                      "Capture 'Save and Close'. Confirm whether a "
                      "transaction-level Save is needed afterwards.",
                      "NOTHING is saved here."])

            elif screen == "reviewnav":
                # Evidence run for the nav-elimination optimisation (phase 2 of
                # the ATD_AR_FAST plan, 2026-07-27): stages 2/4/5 start on a
                # Review Transaction page and currently pay a full FuseWelcome
                # renav (~32s) to get back to the Billing search. Candidates
                # for a cheaper way back, to be PROVEN here before any handler
                # code: a "Done" button returning to Manage Transactions,
                # and/or the right-rail Tasks magnifier still being present on
                # the record page. READ-ONLY: nothing is clicked beyond opening
                # the invoice (and optionally Done in a second pass).
                _need(invoice)
                goto_billing(page, base)
                open_invoice(page, invoice)
                dump(page, "reviewnav",
                     ["Looking for, on the RECORD page: an exact-text 'Done' "
                      "button/anchor (capture its id); anything matching "
                      "[title*='Search'] or *TransactionsQuickSearch* (the "
                      "work-area magnifier); breadcrumb anchors back to "
                      "Manage Transactions.",
                      "If 'Done' exists: re-run with DIAG_AR_CLICK_DONE=1 to "
                      "click it and prove the search panel is reachable "
                      "afterwards. That second pass is still read-only."])
                if os.environ.get("DIAG_AR_CLICK_DONE") == "1":
                    ar._click_by_text(page, "Done", "Done button")
                    time.sleep(6)
                    opened = open_search_panel(page)
                    dump(page, "reviewnav_after_done",
                         ["search panel opened after Done: %s" % opened,
                          "Transaction Number input id: %s"
                          % _label_input_id(page, "Transaction Number")])

            else:
                print("unknown screen: %s" % screen)
                print(__doc__)
                return
        finally:
            browser.close()
    print("\ndone")


def _need(invoice):
    if not invoice:
        raise SystemExit("this screen needs an invoice number argument")


if __name__ == "__main__":
    main()
