"""Round-14 diagnostic: on the Manage Financial Project Plan List view, dump
ground truth about (a) every element whose title/alt mentions 'Additional',
(b) every visible 'Annual Reports' text node and its ancestor-row structure —
so the icon click can be wired to the right row across the frozen/scrollable
table split. Reuses the saved session; unattended."""
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


JS_ICONS = """()=>{
  const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  const out=[];
  document.querySelectorAll('[title],[alt]').forEach(e=>{
    const t=(e.getAttribute('title')||e.getAttribute('alt')||'');
    if(/additional/i.test(t)){
      const tr=e.closest('tr');
      out.push({tag:e.tagName, id:(e.id||'').slice(-45), title:t.slice(0,40),
                vis:vis(e), y:Math.round(e.getBoundingClientRect().top),
                rowTxt:tr?tr.innerText.replace(/\\s+/g,' ').slice(0,50):''});}});
  return out;}"""

JS_TASKROWS = """(task)=>{
  const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const out=[];
  const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);
  let n;
  while((n=walker.nextNode())){
    if(norm(n.textContent)===task && n.parentElement && vis(n.parentElement)){
      const el=n.parentElement;
      const tr=el.closest('tr');
      const tbl=el.closest('table');
      let rowIdx=-1;
      if(tr&&tr.parentElement)
        rowIdx=[...tr.parentElement.children].indexOf(tr);
      out.push({tag:el.tagName, id:(el.id||'').slice(-50),
                y:Math.round(el.getBoundingClientRect().top),
                rowIdx, tblId:tbl?(tbl.id||'').slice(-40):'',
                trChildTds:tr?tr.children.length:0,
                trTitles:tr?tr.querySelectorAll('[title]').length:0});}}
  return out;}"""


def main():
    env = _env_from_db()
    base = _apps_base(env)
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=True)
        try:
            page = ctx.new_page()
            page.set_default_timeout(45000)
            page.set_viewport_size({"width": 1700, "height": 1000})
            ppm._goto_my_projects(page, base)
            ppm._open_project(page, "4511000682")
            ppm._open_financial_plan(page)
            page.screenshot(path="diag3_plan.png", full_page=True)

            print("=== elements titled/alt *Additional* ===")
            for r in page.evaluate(JS_ICONS):
                print(r)
            print("=== visible 'Annual Reports' text nodes ===")
            for r in page.evaluate(JS_TASKROWS, "Annual Reports"):
                print(r)
        finally:
            browser.close()
    print("done")


if __name__ == "__main__":
    main()
