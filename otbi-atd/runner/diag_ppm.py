"""One-off diagnostic for the PPM navigation: reuse the saved session, walk the
same path as ppm_task_addl._goto_my_projects, then report EVERY frame and where
the 'Search' disclosure / 'Advanced' button / 'Project Number' label live."""
import time

from playwright.sync_api import sync_playwright

import config
import auth
from actions import ppm_task_addl as ppm
from actions.ap_invoice import _apps_base


def _env_from_db():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    return {"env_name": e["env_name"], "analytics_base_url": e["analytics_base_url"],
            "fusion_apps_url": e.get("fusion_apps_url"),
            "credential_ref": e.get("credential_ref") or e["env_name"]}


JS_SCAN = """()=>{
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const out={anchorsSearch:[], buttons:[], labelPN:0, inputs:0};
  document.querySelectorAll('a').forEach(a=>{
    const t=norm(a.innerText);
    if(t==='Search') out.anchorsSearch.push({id:a.id||'', cls:(a.className||'').slice(0,60)});
  });
  document.querySelectorAll('button').forEach(b=>{
    const t=norm(b.innerText); if(t) out.buttons.push(t);
  });
  document.querySelectorAll('label,span,div').forEach(l=>{
    if(norm(l.innerText).replace(/^\\*+\\s*/,'')==='Project Number') out.labelPN++;
  });
  out.inputs=document.querySelectorAll('input:not([type=hidden])').length;
  return out;}"""

env = _env_from_db()
base = _apps_base(env)
with sync_playwright() as p:
    browser, ctx = auth.authenticate(p, env, headless=True)
    try:
        page = ctx.new_page()
        page.set_default_timeout(45000)
        page.set_viewport_size({"width": 1700, "height": 1000})
        ppm._goto_my_projects(page, base)
        print("\n=== FRAMES ===")
        for f in page.frames:
            print(" frame:", (f.name or "<main>")[:40], "|", f.url[:110])
        print("\n=== PER-FRAME SCAN ===")
        for f in page.frames:
            try:
                r = f.evaluate(JS_SCAN)
                print((f.name or "<main>")[:30], "->", r)
            except Exception as e:  # noqa: BLE001
                print((f.name or "<main>")[:30], "-> ERR", str(e)[:80])
        print("\n=== SEARCH HEADER HTML (2 ancestor levels) ===")
        js_html = """()=>{const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
          for(const s of document.querySelectorAll('span,div,a,h1,h2')){
            const t=norm(s.innerText);
            if((t==='Search'||t==='Advanced Search') && s.children.length===0){
              let p=s.parentElement&&s.parentElement.parentElement
                    ?s.parentElement.parentElement:s.parentElement;
              return (p?p.outerHTML:s.outerHTML).slice(0,4000);}}
          return 'NOT FOUND';}"""
        print(page.evaluate(js_html))
        page.screenshot(path="diag_ppm.png", full_page=True)
    finally:
        browser.close()
print("done")
