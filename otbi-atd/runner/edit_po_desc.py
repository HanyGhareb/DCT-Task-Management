"""One-shot maintenance: wrap the PO Headers 'Order Description' column formula
with REPLACE so free-text can no longer break the OTBI CSV export.

Root cause (2026-08-18, PO 451102007057): a description STARTING with a double
quote (and containing commas + line breaks) corrupts OTBI's CSV field quoting,
so the row splits on its embedded commas and ~24 rows load misaligned
(ORDERED_AMOUNT/RATE non-numeric + SUBMIT_DATE non-date drift warnings on
every Full run). Fix requested by the user: REPLACE comma -> dash; we also
strip the double-quote char because THAT is what breaks the quoting (682 other
rows with commas load fine while properly quoted).

New formula: REPLACE(REPLACE(<current>, ',', '-'), '"', '''')

Applied to BOTH catalog analyses feeding PROD.ATD_PO_HEADERS (Full
PO_HEADERS_F + incremental PO_HEADERS_UH24) so MERGE cycles cannot flip the
text back and forth. Idempotent: a formula already containing REPLACE( is
skipped. Run on a worker VM with that VM's atd-worker STOPPED (one Fusion
browser per host per account).
"""
import os
import sys
import time

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
import oracledb
from playwright.sync_api import sync_playwright

import auth
import config
import copy_analysis as ca

PATHS = [
    "/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Headers/PO_HEADERS_F",
    "/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Headers/PO_HEADERS_UH24",
]
HEADING = "Order Description"


_JS_FIND = r"""() => {
  const out = [];
  for (const t of document.querySelectorAll('textarea, .CodeMirror')) {
    if (t.classList && t.classList.contains('CodeMirror')) {
      if (t.CodeMirror) out.push({kind:'cm', id:t.id||'', val:t.CodeMirror.getValue()});
      continue;
    }
    out.push({kind:'ta', id:t.id||'', name:t.name||'', vis:t.offsetParent!==null,
              dis:t.disabled, val:(t.value||'').slice(0,300)});
  }
  return out;
}"""


def _find_formula(page):
    """Search EVERY frame for the formula editor. Returns (frame, kind, id, value)."""
    for fr in page.frames:
        try:
            for e in fr.evaluate(_JS_FIND):
                if '"' in (e.get("val") or "") and "." in (e.get("val") or ""):
                    return fr, e["kind"], e.get("id", ""), e["val"]
        except Exception:
            continue
    return None, None, None, None


def _set_formula(frame, kind, box_id, value):
    if kind == "cm":
        return frame.evaluate(r"""(v) => {
          for (const t of document.querySelectorAll('.CodeMirror'))
            if (t.CodeMirror) { t.CodeMirror.setValue(v); t.CodeMirror.save(); return true; }
          return false;
        }""", value)
    return frame.evaluate(r"""(a) => {
      const t = a.id ? document.getElementById(a.id)
                     : [...document.querySelectorAll('textarea')]
                         .find(x => (x.value||'').includes('"'));
      if (!t) return false;
      t.value = a.v;
      t.dispatchEvent(new Event('input', {bubbles:true}));
      t.dispatchEvent(new Event('change', {bubbles:true}));
      return true;
    }""", {"id": box_id, "v": value})


def edit_one(page, path):
    ca.open_existing(page, ca.DEFAULT_BASE, path)
    ca.click_tab(page, "Criteria")
    if not ca._wait_columns(page):
        ca._shot(page, "po_nocols")
        raise RuntimeError(f"criteria columns did not render: {path}")
    ca._open_formula_dialog(page, HEADING)
    frame, kind, box_id, cur = _find_formula(page)
    if cur is None:
        ca._shot(page, "po_nobox")
        frames = [(f.name, f.url[:80]) for f in page.frames]
        raise RuntimeError(f"formula editor not found; frames={frames}")
    print(f"[edit] editor kind={kind} id={box_id!r} frame={frame.url[:60]}")
    print(f"[edit] current formula: {cur}")
    if "REPLACE(" in cur.upper().replace(" ", ""):
        print("[edit] already wrapped - skipping")
        ca._click_ok_topmost(page)
        time.sleep(1.5)
        return False
    new = f"REPLACE(REPLACE({cur.strip()}, ',', '-'), '\"', '''')"
    if not _set_formula(frame, kind, box_id, new):
        raise RuntimeError("failed to set formula")
    time.sleep(0.5)
    _, _, _, check = _find_formula(page)
    print(f"[edit] new formula: {check}")
    assert check == new, "editor did not accept the new formula"
    ca._click_ok_topmost(page)
    time.sleep(2.5)
    ca.save_as(page, path.rsplit("/", 1)[1])
    return True


def main():
    conn = oracledb.connect(
        user=os.environ["ATD_DB_USER"], password=os.environ["ATD_DB_PASSWORD"],
        dsn=os.environ["ATD_DB_DSN"], config_dir=os.environ.get("TNS_ADMIN"),
        wallet_location=os.environ.get("TNS_ADMIN"),
        wallet_password=os.environ.get("ATD_WALLET_PASSWORD"))
    cred = config.resolve_job_cred(conn, PATHS[0], None)
    env = config.get_default_browser_env(conn)
    if cred:  # path-owner personal profile (not expected for the service catalog)
        env = dict(env or {})
        env.update({"cred_user": cred["fusion_login"], "cred_pwd": cred["fusion_pwd"],
                    "cred_tg_chat": cred.get("tg_chat")})
    with sync_playwright() as p:
        browser, ctx = auth.authenticate(p, env, headless=True)
        page = ctx.new_page()
        page.set_default_timeout(ca.STEP_TIMEOUT)
        for path in PATHS:
            print(f"===== {path} =====")
            changed = edit_one(page, path)
            print(f"[edit] {'SAVED' if changed else 'unchanged'}: {path}")
        browser.close()


if __name__ == "__main__":
    main()
