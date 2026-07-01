"""Fusion AP invoice — read + DOWNLOAD ATTACHMENTS, with end-to-end timing.

Same semi-attended session + proven Payables nav as fusion_invoice_lookup.py, plus:
  * reveal the invoice header "Attachments" and download every file, and
  * time each milestone (auth/login, nav+open, read, download) and the total.

Downloads land in  ./attach_<invoice>/  (cwd). Attachment files are fetched over the
session cookies (ctx.request) when the link has an http href, else via a click +
Playwright download event.

  ~/otbi-atd/venv/bin/python -u fusion_invoice_fetch.py "CM-RES-000685"
  ~/otbi-atd/venv/bin/python -u fusion_invoice_fetch.py "CM-RES-000685" --probe   # no download, just dump attachment DOM
"""
import os
import re
import sys
import time
from pathlib import Path

from playwright.sync_api import sync_playwright

_HERE = Path(__file__).resolve().parent
for _cand in (_HERE.parent.parent / "runner", _HERE, Path.cwd()):
    if (_cand / "config.py").exists() and str(_cand) not in sys.path:
        sys.path.insert(0, str(_cand))

import config  # noqa: E402
import auth  # noqa: E402
from actions import ap_invoice  # noqa: E402

NAV_INVOICES = "pt1:_UISnvr:0:nv_itemNode_payables_payables_invoices"
GRP_PAYABLES = "groupNode_payables"
HEADER_LABELS = ["Invoice Date", "Invoice Type", "Supplier or Party", "Invoice Amount",
                 "Unpaid Amount", "Business Unit", "Payment Terms", "Payment Currency", "Holds"]
_NOT_DESC = ["Show All", "Multiperiod Accounting", "Start Date", "End Date", "Accrual Account",
             "Ship-to Location", "Consumption Advice", "Number", "Line", "Receipt",
             "Purchase Order", "Schedule", "UOM Name", "Price", "Quantity", "Amount",
             "Description", "Distribution Combination", "Supplier or Party"]


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    return {"env_name": e["env_name"], "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


def jsclick(page, sel, label, quiet=False):
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


def fill_label(page, label_text, value):
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


def extract(page):
    js = r"""(args) => {
      const [labels, notDesc] = args;
      const res = {header:{}, lines:[]};
      const norm = s => (s||'').replace(/\s+/g,' ').trim();
      const all = [...document.querySelectorAll('*')];
      const leafText = e => (e.children.length===0 ? norm(e.textContent) : '');
      const skip = new Set([...labels,'Address','Notes','Attachments','Payment Business Unit',
        'Description','Items','Lines','Shipping and Handling']);
      for (const label of labels) {
        let li=-1; for(let i=0;i<all.length;i++){if(norm(all[i].innerText)===label&&all[i].children.length<=2){li=i;break;}}
        if(li<0) continue;
        for(let j=li+1;j<all.length&&j<li+60;j++){const t=leafText(all[j]); if(t&&!skip.has(t)){res.header[label]=t.slice(0,200);break;}}
      }
      const bad=new Set(notDesc); const cand=[];
      document.querySelectorAll('span,div,td,a,label').forEach(e=>{ if(e.children.length!==0) return;
        const t=norm(e.textContent);
        if(t.length>=15&&t.length<=300&&/[A-Za-z]{3}/.test(t)&&/\s/.test(t)&&!bad.has(t)
           &&!/^[\d.,/%() -]+$/.test(t)&&!/^\d{2}\/\d{2}\/\d{4}/.test(t)&&!/\bAED\b/.test(t)) cand.push(t);});
      res.lines=[...new Set(cand)].sort((a,b)=>b.length-a.length).slice(0,5);
      return res;}"""
    try:
        return page.evaluate(js, [HEADER_LABELS, _NOT_DESC])
    except Exception as e:  # noqa: BLE001
        print(f"[extract] ERR {e}"); return {"header": {}, "lines": []}


def reveal_attachments(page):
    """Click the header Attachments link / 'N more...' so all file links render."""
    for sel in ['a:has-text("more...")', 'a:has-text("more")',
                'a[id*="AttachmentLov"]', 'a[title*="Attachment"]', '[title="Attachments"]']:
        if jsclick(page, sel, f"reveal attachments ({sel})", quiet=True):
            time.sleep(2)
    time.sleep(1)


def collect_attachments(page):
    """Return [{text, href, id}] for the real attachment-table file links only.

    The header attachments popup renders each file as an anchor whose id matches
    `...popAttachmentTable:<row>:...FileLiveFile` (gl* = already-materialised content
    URL, cl* = collapsed/placeholder that only yields its real URL when clicked). We
    target exactly those, excluding the amount cells, the 'N more' and dialog-close
    controls that a generic 'looks like a file' scan picked up."""
    js = r"""() => {
      const out=[];
      document.querySelectorAll('a[id*="popAttachmentTable"]').forEach(a=>{
        const id=a.id||'';
        if (!/FileLiveFile/i.test(id)) return;          // only the file links
        const t=(a.innerText||a.textContent||'').trim();
        const href=a.href||a.getAttribute('href')||'';
        out.push({text:t.slice(0,160), href, id});
      });
      const seen=new Set();
      return out.filter(o=>{const k=o.id; if(seen.has(k))return false; seen.add(k); return true;}).slice(0,60);
    }"""
    try:
        return page.evaluate(js)
    except Exception as e:  # noqa: BLE001
        print(f"[attach] collect ERR {e}"); return []


def _safe_name(name, i):
    n = re.sub(r'[\\/:*?"<>|]+', "_", (name or f"attachment_{i}").strip())
    return n or f"attachment_{i}"


def _is_real_content(href):
    return "/content/conn/FusionAppsContentRepository" in (href or "")


def _row_content_href(page, row_idx):
    """After materialising a collapsed row, return the /content/ download href in it."""
    try:
        return page.evaluate(
            """(rid)=>{const els=document.querySelectorAll('a[id*="popAttachmentTable:'+rid+':"]');
               for(const a of els){const h=a.href||''; if(h.includes('/content/conn/FusionAppsContentRepository')) return h;}
               return '';}""", str(row_idx))
    except Exception:  # noqa: BLE001
        return ""


def _save_via_request(ctx, href, label, outdir, idx):
    resp = ctx.request.get(href, timeout=180000)
    ct = (resp.headers or {}).get("content-type", "")
    if resp.status == 200 and "text/html" not in ct:
        name = _safe_name(label, idx)
        dest = os.path.join(outdir, name)
        with open(dest, "wb") as fh:
            fh.write(resp.body())
        return name, os.path.getsize(dest)
    print(f"[attach] {label!r}: content GET HTTP {resp.status} ct={ct!r}")
    return None


def download_attachments(page, ctx, atts, outdir):
    """gl* rows carry a direct /content/ URL -> GET over cookies (fast/proven).
    cl* (collapsed command-link) rows stream the file via an ADF server postback that
    only fires on a REAL trusted click (a JS el.click() does not invoke ADF's handler)
    -> real .click() inside expect_download. If a cl click navigates to the wrapper
    page instead, go back and re-open the popup so the remaining rows still work."""
    os.makedirs(outdir, exist_ok=True)
    saved = []
    inv_url = page.url
    for i, a in enumerate(atts):
        label = a.get("text") or f"attachment_{i}"
        href = a.get("href") or ""
        try:
            if _is_real_content(href):
                res = _save_via_request(ctx, href, label, outdir, i)
                if res:
                    saved.append((res[0], res[1], "get"))
                    print(f"[attach] saved {res[0]} ({res[1]} B) [get]")
                continue
            # collapsed command-link: trusted click -> ADF streamed download
            try:
                with page.expect_download(timeout=30000) as di:
                    page.locator(f'a[id="{a["id"]}"]').first.click(force=True, timeout=12000)
                d = di.value
                name = _safe_name(d.suggested_filename or label, i)
                dest = os.path.join(outdir, name)
                d.save_as(dest)
                saved.append((name, os.path.getsize(dest), "click"))
                print(f"[attach] saved {name} ({os.path.getsize(dest)} B) [click]")
            except Exception as ce:  # noqa: BLE001
                print(f"[attach] UNRESOLVED {label!r}: {str(ce)[:80]}")
                # recover if the click navigated to the wrapper page
                if "FndOverview" in page.url and page.url != inv_url:
                    try:
                        page.go_back(wait_until="domcontentloaded"); time.sleep(4)
                        reveal_attachments(page)
                    except Exception:  # noqa: BLE001
                        pass
        except Exception as e:  # noqa: BLE001
            print(f"[attach] FAILED {label!r}: {e}")
    return saved


def main():
    argv = sys.argv
    args = [a for a in argv[1:] if not a.startswith("-")]
    if not args:
        raise SystemExit('usage: fusion_invoice_fetch.py "<invoice number>" [--probe]')
    num = args[0]
    probe = "--probe" in argv
    outdir = os.path.abspath(f"attach_{_safe_name(num, 0)}")

    T = {}
    T["t0"] = time.perf_counter()
    env = _env_from_db()
    base = ap_invoice._apps_base(env)
    T["db"] = time.perf_counter()
    print(f"[fetch] invoice={num!r} base={base}")

    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=True)
        T["auth"] = time.perf_counter()
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
            jsclick(page, f'a[id="{GRP_PAYABLES}"]', "expand Payables")
            time.sleep(2)
            jsclick(page, f'a[id="{NAV_INVOICES}"]', "Payables>Invoices")
            time.sleep(15)
            jsclick(page, '[title="Tasks"]', "Tasks drawer")
            time.sleep(3)
            jsclick(page, 'a:has-text("Manage Invoices")', "Manage Invoices")
            time.sleep(10)
            if not fill_label(page, "Invoice Number", num):
                loc = page.locator('input[aria-label*="Invoice Number"]')
                if loc.count():
                    loc.first.fill(num)
            jsclick(page, '//button[normalize-space(.)="Search"]', "Search") or \
                jsclick(page, 'button[id$="search"]', "Search(id)")
            time.sleep(8)
            opened = jsclick(page, f'a:has-text("{num}")', "open invoice")
            time.sleep(12)
            T["open"] = time.perf_counter()

            res = extract(page) if opened else {"header": {}, "lines": []}
            T["read"] = time.perf_counter()
            try:
                page.screenshot(path=f"fetch_{_safe_name(num,0)}.png", full_page=True)
            except Exception:  # noqa: BLE001
                pass

            reveal_attachments(page)
            atts = collect_attachments(page)
            print(f"[attach] candidate file links: {len(atts)}")
            for a in atts:
                print(f"    • text={a['text']!r} href={(a['href'] or '')[:90]!r} id={a['id']!r}")
            saved = [] if probe else download_attachments(page, ctx, atts, outdir)
            T["attach"] = time.perf_counter()

            # ---- report ----
            auth_s = T["auth"] - T["db"]
            mfa = auth_s > 30  # a fresh login (MFA) takes far longer than session reuse
            print("\n================ RESULT ================")
            print(f"Invoice Number : {num}")
            print(f"Found          : {opened}")
            for k, v in res["header"].items():
                print(f"{k:<15}: {v}")
            if res["lines"]:
                print(f"Description    : {res['lines'][0]}")
            print(f"Attachments    : {len(saved)} downloaded -> {outdir}")
            for n, sz, how in saved:
                print(f"    • {n}  ({sz} B, {how})")
            print("\n---------------- TIMING (seconds) ----------------")
            print(f"  DB/env            : {T['db']-T['t0']:7.1f}")
            print(f"  Session login     : {auth_s:7.1f}   {'(included an MFA approval — human time)' if mfa else '(session reused, no MFA)'}")
            print(f"  Nav+search+open   : {T['open']-T['auth']:7.1f}")
            print(f"  Read header/desc  : {T['read']-T['open']:7.1f}")
            print(f"  Attachments       : {T['attach']-T['read']:7.1f}")
            print(f"  -------------------------------")
            print(f"  TOTAL end-to-end  : {T['attach']-T['t0']:7.1f}")
            print(f"  Automated (excl. login) : {(T['attach']-T['t0'])-auth_s:7.1f}")
            print("==================================================")
        finally:
            browser.close()


if __name__ == "__main__":
    main()
