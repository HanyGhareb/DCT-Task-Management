"""Harvest the per-row Details icon ids on the EDIT Transaction line grid.

Stage 7's first line runs on the CREATE Transaction form, where the icon is
`…:AT1:_ATp:table1:<row>:commandImageLink110`. Saving that line commits the
transaction, so every LATER line runs on the EDIT Transaction page -- which
uses a different component id, and the run stops there (by design: it refuses
to fall back to a selector that matches every row).

Read-only. Attaches to the worker's existing session, never logs in.
"""
import os
import sys
import time

from playwright.sync_api import sync_playwright

sys.path.insert(0, "/root/otbi-atd/runner")
import config                                            # noqa: E402
from actions import ar_invoice_rebill as ar              # noqa: E402
from actions.ap_invoice import _apps_base                # noqa: E402
from step_ar_rebill import _env_from_db, attach_existing_session  # noqa: E402

TXN = sys.argv[1] if len(sys.argv) > 1 else "45100251002"

JS_DUMP = """(grid)=>{
  const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  const out={rows:{}, details:[], anyLink:[]};
  for(const e of document.querySelectorAll('[id]')){
    const id=e.id||'';
    if(!id.includes(grid)) continue;
    const rest=id.slice(id.indexOf(grid)+grid.length);
    const m=rest.match(/^(\\d+):(.+)$/);
    if(!m) continue;
    const [_,row,comp]=m;
    (out.rows[row]=out.rows[row]||[]);
    if(out.rows[row].indexOf(comp)<0) out.rows[row].push(comp);
    const t=(e.getAttribute('title')||'')+' '+(e.getAttribute('aria-label')||'');
    if(/details/i.test(t) || /commandImageLink|dffIL|Detail/i.test(comp)){
      out.details.push({row:row, comp:comp, tag:e.tagName, title:t.trim(),
                        visible:vis(e), id:id});
    }
  }
  // anything at all that looks like a details affordance, grid or not
  for(const e of document.querySelectorAll('[title],a,img')){
    const t=(e.getAttribute('title')||'');
    if(/^details$/i.test(t.trim()))
      out.anyLink.push({tag:e.tagName, id:e.id||'(no id)', visible:vis(e)});
  }
  return out;
}"""

env = _env_from_db()
base = _apps_base(env)
with sync_playwright() as p:
    browser, ctx = attach_existing_session(p, env, headless=True)
    try:
        page = ctx.new_page()
        page.set_default_timeout(45000)
        page.set_viewport_size({"width": 1700, "height": 1200})
        print("searching for %s ..." % TXN, flush=True)
        ar._search_transaction(page, TXN, base=base)
        time.sleep(6)
        # _search_transaction leaves us on the results grid for an Incomplete
        # row; open it explicitly. :text-is, never :has-text -- substring match
        # would also hit <TXN>CM (ADF law 10).
        if "Manage Transactions" in (page.title() or "") or \
                page.locator('a:text-is("%s")' % TXN).count() > 0:
            ar._click_by_text(page, TXN, "transaction number link")
            time.sleep(10)
        ar._jsclick(page, ar.SEL["dialog_ok"], "dismiss dialog", required=False)
        time.sleep(2)
        ar._jsclick(page, ['a[id$=":sdi3::disAcr"]', 'a:text-is("Invoice Lines")',
                           'div[role="tab"]:text-is("Invoice Lines")'],
                    "Invoice Lines tab", required=False)
        time.sleep(5)
        page.screenshot(path="/root/otbi-atd/runner/.ar_744/probe_edit_grid.png",
                        full_page=True)
        print("URL:", page.url[:110])
        print("title:", (page.title() or "")[:90])
        print("rows read by the handler:", ar._dup_line_rows(page))
        d = page.evaluate(JS_DUMP, ar.DUP_GRID)
        print("\n--- components present per grid row ---")
        for row in sorted(d["rows"], key=lambda r: int(r)):
            print(" row %s: %s" % (row, ", ".join(sorted(d["rows"][row]))[:400]))
        print("\n--- details-like elements under the grid ---")
        for x in d["details"]:
            print("  row=%s comp=%s tag=%s vis=%s title=%r"
                  % (x["row"], x["comp"], x["tag"], x["visible"], x["title"]))
        print("\n--- every title=\"Details\" on the page ---")
        for x in d["anyLink"]:
            print("  %s vis=%s id=%s" % (x["tag"], x["visible"], x["id"]))
    finally:
        browser.close()
