"""Round-9 diagnostic: find HOW to expand the collapsed 'Search' disclosure on
My Projects. Reuses the saved session (no MFA). Dumps the header region HTML,
then tries a sequence of candidate expansion actions, verifying + screenshotting
after each. Stops at the first one that materialises search inputs."""
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


JS_STATE = """()=>{
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  let pn=0, kw=0;
  document.querySelectorAll('label').forEach(l=>{
    const t=norm(l.innerText);
    if(t.replace(/^\\*+\\s*/,'')==='Project Number') pn++;
    if(t==='Keywords') kw++;});
  let inputs=0;
  document.querySelectorAll('input:not([type=hidden])').forEach(i=>{if(vis(i))inputs++;});
  return {visInputs:inputs, labelPN:pn, labelKW:kw};}"""

JS_HEADER_HTML = """()=>{
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const vis=e=>e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  for(const s of document.querySelectorAll('span,div,a,h1,h2')){
    const t=norm(s.innerText);
    if((t==='Search'||t==='Advanced Search') && s.children.length===0 && vis(s)){
      let p=s; for(let d=0; d<3 && p.parentElement; d++) p=p.parentElement;
      return {tag:s.tagName, id:s.id||'', cls:(s.className||'').toString().slice(0,80),
              html:p.outerHTML.slice(0,6000)};}}
  return null;}"""


def state(fr):
    try:
        return fr.evaluate(JS_STATE)
    except Exception as e:  # noqa: BLE001
        return {"err": str(e)[:60]}


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

            # which frame holds the visible Search header?
            target = None
            for fr in page.frames:
                try:
                    info = fr.evaluate(JS_HEADER_HTML)
                except Exception:  # noqa: BLE001
                    continue
                if info:
                    target = fr
                    print(f"[diag2] header frame={fr.name or '<main>'} "
                          f"tag={info['tag']} id={info['id']!r} cls={info['cls']!r}")
                    print("[diag2] --- header region HTML (3 levels up) ---")
                    print(info["html"])
                    print("[diag2] --- end HTML ---")
                    break
            if target is None:
                print("[diag2] NO visible Search header found in any frame")
                page.screenshot(path="diag2_00_none.png", full_page=True)
                return
            print("[diag2] initial state:", state(target))

            def check(step):
                time.sleep(4)
                st = state(target)
                page.screenshot(path=f"diag2_{step}.png", full_page=True)
                print(f"[diag2] after {step}: {st}")
                return (st.get("visInputs", 0) > 2) or st.get("labelPN", 0) > 0

            # A: real click on a disclosure anchor (ADF renders id ending ::disAcr)
            try:
                loc = target.locator('a[id$="::disAcr"], a[id*="disclosure" i]')
                n = loc.count()
                print(f"[diag2] A: disAcr anchors={n}")
                for i in range(min(n, 6)):
                    if loc.nth(i).is_visible():
                        loc.nth(i).click(timeout=3000)
                        break
                if check("A_disAcr"):
                    return
            except Exception as e:  # noqa: BLE001
                print("[diag2] A err:", str(e)[:100])

            # B: real click on expand icon (title/alt Expand/Disclose)
            try:
                loc = target.locator('[title*="Expand" i], img[alt*="Expand" i], '
                                     '[title*="Disclose" i]')
                n = loc.count()
                print(f"[diag2] B: expand-titled els={n}")
                for i in range(min(n, 6)):
                    if loc.nth(i).is_visible():
                        loc.nth(i).click(timeout=3000)
                        break
                if check("B_expandIcon"):
                    return
            except Exception as e:  # noqa: BLE001
                print("[diag2] B err:", str(e)[:100])

            # C: keyboard — focus the visible Search text, press Enter then Space
            try:
                loc = target.get_by_text("Search", exact=True)
                hit = None
                for i in range(min(loc.count(), 10)):
                    if loc.nth(i).is_visible():
                        hit = loc.nth(i)
                        break
                if hit:
                    hit.focus()
                    page.keyboard.press("Enter")
                    if check("C_enter"):
                        return
                    hit.focus()
                    page.keyboard.press("Space")
                    if check("C_space"):
                        return
            except Exception as e:  # noqa: BLE001
                print("[diag2] C err:", str(e)[:100])

            # D: pointer click LEFT of the Search text (on the triangle glyph)
            try:
                loc = target.get_by_text("Search", exact=True)
                for i in range(min(loc.count(), 10)):
                    el = loc.nth(i)
                    if el.is_visible():
                        box = el.bounding_box()
                        if box:
                            x = box["x"] - 14
                            y = box["y"] + box["height"] / 2
                            print(f"[diag2] D: clicking at ({x:.0f},{y:.0f}) "
                                  f"(text box x={box['x']:.0f})")
                            page.mouse.click(x, y)
                        break
                if check("D_triangle"):
                    return
            except Exception as e:  # noqa: BLE001
                print("[diag2] D err:", str(e)[:100])

            # E: dblclick the header text itself
            try:
                loc = target.get_by_text("Search", exact=True)
                for i in range(min(loc.count(), 10)):
                    el = loc.nth(i)
                    if el.is_visible():
                        el.click(timeout=3000)
                        time.sleep(1)
                        el.dblclick(timeout=3000)
                        break
                if check("E_dblclick"):
                    return
            except Exception as e:  # noqa: BLE001
                print("[diag2] E err:", str(e)[:100])

            print("[diag2] ALL ATTEMPTS FAILED — see screenshots + HTML dump")
        finally:
            browser.close()
    print("done")


if __name__ == "__main__":
    main()
