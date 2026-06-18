"""throwaway: open the Answers editor, dump DOM + screenshot to learn real selectors."""
import os, time, urllib.parse
from playwright.sync_api import sync_playwright
import auth

BASE = os.environ.get("OTBI_ANALYTICS_BASE",
                      "https://iaaibv.fa.ocs.oraclecloud29.com/analytics")
env = {"env_name": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV"),
       "analytics_base_url": BASE,
       "credential_ref": os.environ.get("OTBI_ENV_NAME", "FUSION_ADGOV")}
SA = '"Procurement - Purchasing Real Time"'

with sync_playwright() as p:
    browser, ctx = auth.authenticate(p, env, headless=True)
    page = ctx.new_page()
    url = BASE.rstrip("/") + "/saw.dll?Answers&SubjectArea=" + urllib.parse.quote(SA, safe="")
    print("URL:", url)
    page.goto(url, wait_until="domcontentloaded", timeout=90000)
    time.sleep(10)
    print("title:", page.title())
    print("cururl:", page.url)
    os.makedirs("c:/tmp", exist_ok=True)
    with open("c:/tmp/editor.html", "w", encoding="utf-8") as f:
        f.write(page.content())
    page.screenshot(path="c:/tmp/editor.png", full_page=True)
    print("frames:")
    for i, fr in enumerate(page.frames):
        print(f"  [{i}] name={fr.name!r} url={fr.url[:90]!r}")
        try:
            with open(f"c:/tmp/editor_frame{i}.html", "w", encoding="utf-8") as f:
                f.write(fr.content())
        except Exception as e:
            print("    frame content err:", e)
    # quick text probe: does the subject-area tree mention our folders?
    for needle in ["Subject Areas", "Selected Columns", "Purchase Order Header",
                   "Supplier", "Create Analysis", "Criteria"]:
        try:
            print(f"  has '{needle}':", page.get_by_text(needle).count())
        except Exception as e:
            print(f"  has '{needle}': err {e}")
    browser.close()
print("done")
