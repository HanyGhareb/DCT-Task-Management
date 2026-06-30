"""Fusion AP invoice lookup (read-only) — proof-of-concept / reusable tool.

Logs into Oracle Fusion with the SAME semi-attended SSO/MFA session the OTBI-ATD
extract jobs use (otbi-atd/runner/auth.py), navigates the Payables UI, searches an
invoice by number, opens it, and returns the header summary + line description(s).

WHY THE UI (and not REST): the federated ADGOV SSO session is NOT accepted by
`fscmRestApi` — it returns HTTP 401 even with a full Fusion UI cookie session
(no Fusion-local password / OAuth client under SSO). So both reads and the planned
AP write-back go through the UI robot. See README.md in this folder.

Proven navigation (ADF intercepts normal clicks -> we fire el.click() in-DOM):
  FuseWelcome -> Navigator -> expand "Payables" -> "Invoices" (workarea)
  -> "Tasks" drawer -> "Manage Invoices" -> fill "Invoice Number" -> "Search"
  -> open the invoice link -> read the line "Description" (full textContent).

Run on a worker VM (atd-vm180/181/182) where the runner + saved session live:
  cp this file to ~/otbi-atd/runner/ (or run it in place — it finds the runner)
  cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh
  ~/otbi-atd/venv/bin/python -u fusion_invoice_lookup.py "INV/HQ/26032465"
  ~/otbi-atd/venv/bin/python -u fusion_invoice_lookup.py "INV/HQ/26032465" --json
  ~/otbi-atd/venv/bin/python -u fusion_invoice_lookup.py "INV/HQ/26032465" --headed

If the saved session has expired it prints/Telegrams ONE MFA number (tagged with the
VM); approve it in Microsoft Authenticator and the run continues.
"""
import json
import os
import sys
import time
from pathlib import Path

# --- make the runner modules (config/auth/actions) importable from anywhere ---
_HERE = Path(__file__).resolve().parent
for _cand in (_HERE.parent.parent / "runner", _HERE, Path.cwd()):
    if (_cand / "config.py").exists() and str(_cand) not in sys.path:
        sys.path.insert(0, str(_cand))

from playwright.sync_api import sync_playwright  # noqa: E402

import config  # noqa: E402
import auth  # noqa: E402
from actions import ap_invoice  # noqa: E402  (only for _apps_base helper)

NAV_INVOICES = "pt1:_UISnvr:0:nv_itemNode_payables_payables_invoices"
GRP_PAYABLES = "groupNode_payables"

# Header fields we try to read off the "Invoice Details" summary (best-effort).
# (No "Description" here — invoice header has none; the description is on the line.)
HEADER_LABELS = ["Invoice Date", "Invoice Type", "Supplier or Party", "Supplier Site",
                 "Invoice Amount", "Unpaid Amount", "Business Unit", "Payment Terms",
                 "Payment Currency", "Holds"]

# Grid column headers / menu items to exclude when sniffing the line description.
_NOT_DESC = ["Show All", "Multiperiod Accounting", "Start Date", "End Date",
             "Accrual Account", "Ship-to Location", "Consumption Advice", "Number",
             "Line", "Receipt", "Purchase Order", "Schedule", "UOM Name", "Price",
             "Quantity", "Amount", "Description", "Distribution Combination",
             "Tax Classification", "Supplier or Party", "Supplier Site"]


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    if not e:
        raise SystemExit("No enabled BROWSER env in ATD_OTBI_ENV.")
    return {"env_name": e["env_name"], "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


def _jsclick(page, sel, label, quiet=False):
    try:
        loc = page.locator(sel)
        if loc.count() == 0:
            if not quiet:
                print(f"[nav] {label}: not in DOM")
            return False
        loc.first.evaluate("el => el.click()")
        if not quiet:
            print(f"[nav] {label}: ok")
        return True
    except Exception as e:  # noqa: BLE001
        if not quiet:
            print(f"[nav] {label}: ERR {e}")
        return False


def _fill_label(page, label_text, value):
    js = """(args)=>{const[label,val]=args;
      for(const l of document.querySelectorAll('label,span,div')){
        if((l.innerText||'').trim()===label){let p=l.closest('tr,div');let d=0;
          while(p&&d<5){const inp=p.querySelector('input:not([type=hidden]),textarea');
            if(inp){inp.focus();inp.value=val;inp.dispatchEvent(new Event('input',{bubbles:true}));
              inp.dispatchEvent(new Event('change',{bubbles:true}));return true;}
            p=p.parentElement;d++;}}}return false;}"""
    try:
        return bool(page.evaluate(js, [label_text, value]))
    except Exception:  # noqa: BLE001
        return False


def _extract(page, labels, not_desc):
    """Read header label->value (best-effort) + line description(s).

    Header: for each label, scan forward in document order to the next different leaf
    text — ADF panelFormLayout renders the value cell right after the label.
    Line description: the longest multi-word DATA-cell (<td>) text that isn't a column
    header / menu word — the AP line Description is the longest free text on the row."""
    js = r"""(args) => {
      const [labels, notDesc] = args;
      const res = {header:{}, lines:[]};
      const norm = s => (s||'').replace(/\s+/g,' ').trim();
      const all = [...document.querySelectorAll('*')];
      const leafText = e => (e.children.length===0 ? norm(e.textContent) : '');
      // labels we must not mistake for a value (the extracted ones + common neighbours)
      const skip = new Set([...labels, 'Address','Notes','Attachments',
        'Payment Business Unit','Description','Items','Lines','Shipping and Handling']);
      // header: forward document-order scan from each label to its value
      for (const label of labels) {
        let li = -1;
        for (let i=0;i<all.length;i++){ if (norm(all[i].innerText)===label && all[i].children.length<=2){ li=i; break; } }
        if (li < 0) continue;
        for (let j=li+1; j<all.length && j<li+60; j++) {
          const t = leafText(all[j]);
          if (t && !skip.has(t)) { res.header[label]=t.slice(0,200); break; }
        }
      }
      // line description: longest multi-word LEAF text, minus column-header/menu words.
      // (Leaf-only: ADF nests whole sub-tables inside <td>, so td.textContent is a blob.)
      const bad = new Set(notDesc);
      const cand = [];
      document.querySelectorAll('span,div,td,a,label').forEach(e=>{
        if (e.children.length!==0) return;
        const t = norm(e.textContent);
        if (t.length>=15 && t.length<=300 && /[A-Za-z]{3}/.test(t) && /\s/.test(t)
            && !bad.has(t) && !/^[\d.,/%() -]+$/.test(t)
            && !/^\d{2}\/\d{2}\/\d{4}/.test(t) && !/\bAED\b/.test(t)) cand.push(t);
      });
      res.lines = [...new Set(cand)].sort((a,b)=>b.length-a.length).slice(0,5);
      return res;
    }"""
    try:
        return page.evaluate(js, [labels, not_desc])
    except Exception as e:  # noqa: BLE001
        print(f"[extract] ERR {e}")
        return {"header": {}, "lines": []}


def lookup(invoice_number, headed=False, shot_path=None):
    env = _env_from_db()
    base = ap_invoice._apps_base(env)
    out = {"invoiceNumber": invoice_number, "env": env["env_name"], "appsBase": base,
           "found": False, "header": {}, "lineDescriptions": []}
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=not headed)
        try:
            page = ctx.new_page()
            page.set_default_timeout(45000)
            page.set_viewport_size({"width": 1700, "height": 1000})
            page.goto(base + "/fscmUI/faces/FuseWelcome", wait_until="domcontentloaded")
            time.sleep(9)
            try:
                page.locator('a[title="Navigator"]').first.click()
            except Exception:  # noqa: BLE001
                pass
            time.sleep(4)
            _jsclick(page, f'a[id="{GRP_PAYABLES}"]', "expand Payables")
            time.sleep(2)
            _jsclick(page, f'a[id="{NAV_INVOICES}"]', "Payables>Invoices")
            time.sleep(15)
            _jsclick(page, '[title="Tasks"]', "Tasks drawer")
            time.sleep(3)
            _jsclick(page, 'a:has-text("Manage Invoices")', "Manage Invoices")
            time.sleep(10)
            if not _fill_label(page, "Invoice Number", invoice_number):
                loc = page.locator('input[aria-label*="Invoice Number"]')
                if loc.count():
                    loc.first.fill(invoice_number)
            _jsclick(page, '//button[normalize-space(.)="Search"]', "Search") \
                or _jsclick(page, 'button[id$="search"]', "Search(id)")
            time.sleep(8)
            opened = _jsclick(page, f'a:has-text("{invoice_number}")', "open invoice")
            out["found"] = bool(opened)
            time.sleep(12 if opened else 2)
            if shot_path:
                try:
                    page.screenshot(path=shot_path, full_page=True)
                    print(f"[shot] {shot_path}")
                except Exception:  # noqa: BLE001
                    pass
            if opened:
                res = _extract(page, HEADER_LABELS, _NOT_DESC)
                out["header"] = res.get("header", {})
                out["lineDescriptions"] = res.get("lines", [])
        finally:
            browser.close()
    return out


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("-")]
    if not args:
        raise SystemExit('usage: fusion_invoice_lookup.py "<invoice number>" [--headed] [--json]')
    num = args[0]
    headed = "--headed" in argv
    as_json = "--json" in argv
    shot = os.environ.get("FUSION_LOOKUP_SHOT")  # optional screenshot path
    res = lookup(num, headed=headed, shot_path=shot)

    if as_json:
        print(json.dumps(res, indent=2, ensure_ascii=False))
        return
    print("\n================ FUSION INVOICE LOOKUP ================")
    print(f"Invoice Number : {res['invoiceNumber']}")
    print(f"Found          : {res['found']}")
    for k, v in res["header"].items():
        print(f"{k:<15}: {v}")
    if res["lineDescriptions"]:
        print("Line Description(s):")
        for d in res["lineDescriptions"]:
            print(f"    • {d}")
    else:
        print("Line Description(s): <none captured>")
    print("======================================================")


if __name__ == "__main__":
    main(sys.argv)
