"""otbi-atd Track B : SSO/MFA session handling (Abu Dhabi Government federation).

Login chain proven on the live pod (2026-06-17):
  Oracle IDCS sign-in  ->  "ADGOV-Employees-Login"  ->  Microsoft Entra ID
  (username + password)  ->  Microsoft Authenticator push with NUMBER MATCHING.

Fully-headless login is impossible (a human must approve the push), so we:
  * reuse a saved session (auth_state_<env>.json) and validate it cheaply;
  * only when it has expired, run the cred flow, SURFACE the match number, and
    wait for the human to approve in Authenticator; then save the session.

Credentials resolve from env vars named by the env's credential_ref:
  <REF>_USER / <REF>_PWD   (fallback: OTBI_USER / OTBI_PWD).
The match number is printed AND written to ATD_MFA_NUMFILE (default
otbi_mfa_number.txt) so a wrapper/notifier can relay it.
"""
import os
import re
import socket
import time
from pathlib import Path

import notify

STATE_DIR = Path(os.environ.get("ATD_STATE_DIR", ".")).resolve()
NUMFILE = os.environ.get("ATD_MFA_NUMFILE", str(STATE_DIR / "otbi_mfa_number.txt"))
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "Chrome/124 Safari/537.36")


def _state_path(env_name):
    return STATE_DIR / f"auth_state_{env_name}.json"


def _creds(env):
    ref = (env.get("credential_ref") or "").strip()
    u = os.environ.get(f"{ref}_USER") or os.environ.get("OTBI_USER")
    p = os.environ.get(f"{ref}_PWD") or os.environ.get("OTBI_PWD")
    if not u or not p:
        raise RuntimeError(f"missing creds for credential_ref={ref!r} "
                           f"(set {ref}_USER/{ref}_PWD or OTBI_USER/OTBI_PWD)")
    return u, p


def _first(page, sels):
    for s in sels:
        try:
            l = page.locator(s)
            if l.count() > 0 and l.first.is_visible():
                return l.first
        except Exception:
            pass
    return None


def _validate(ctx, env):
    page = ctx.new_page()
    try:
        page.goto(env["analytics_base_url"].rstrip("/") + "/saw.dll?bieehome",
                  wait_until="domcontentloaded")
        time.sleep(3)
        u = page.url.lower()
        ok = "/analytics" in u and "signin" not in u and "login.microsoft" not in u
    except Exception:
        ok = False
    page.close()
    return ok


def surface_number(num, env_name):
    msg = num or "see login screen"
    host = os.environ.get("ATD_WORKER_ID") or socket.gethostname()   # which VM is asking
    try:
        with open(NUMFILE, "w") as fh:
            fh.write(msg)
    except OSError:
        pass
    print(f"[auth][{host}][{env_name}] >>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: {msg}",
          flush=True)
    default = ("OTBI sign-in on {host} ({env}): open Microsoft Authenticator and enter "
               "number {number} to approve. (expires in a few minutes)")
    text = notify.render("ATD_MFA_MSG", default, number=msg, env=env_name, host=host)
    if msg and str(msg) not in text:        # template dropped the number -> append it so it's never lost
        text = f"{text} (number: {msg})"
    if host and host not in text:           # always identify the VM, even if the DB template omits {host}
        text = f"[{host}] {text}"
    notify.send(text)


def _login(ctx, env, wait_secs):
    user, pwd = _creds(env)
    page = ctx.new_page()
    page.set_default_timeout(30000)
    page.goto(env["analytics_base_url"].rstrip("/") + "/saw.dll?bieehome",
              wait_until="domcontentloaded")
    time.sleep(4)

    fed = _first(page, ['text=ADGOV-Employees-Login', 'a:has-text("ADGOV")',
                        'span:has-text("ADGOV")'])
    if fed:
        fed.click(); time.sleep(6)

    em = _first(page, ['input[type="email"]', 'input[name="loginfmt"]', '#i0116',
                       'input[type="text"]'])
    if em:
        em.fill(user)
    nx = _first(page, ['#idSIButton9', 'input[type="submit"]', 'button:has-text("Next")'])
    if nx:
        nx.click(); time.sleep(4)
    pw = _first(page, ['input[type="password"]', '#i0118', 'input[name="passwd"]'])
    if pw:
        pw.fill(pwd)
    sb = _first(page, ['#idSIButton9', 'input[type="submit"]', 'button:has-text("Sign in")'])
    if sb:
        sb.click(); time.sleep(6)

    # surface number-matching value — poll: the number-match screen can take several
    # seconds to render after the password submit (a single look races it).
    num = ""
    for _ in range(12):                       # up to ~36s
        try:
            el = page.locator('#idRichContext_DisplaySign, .display-sign, [aria-label*="number"]')
            if el.count() > 0:
                num = (el.first.inner_text() or "").strip()
        except Exception:
            pass
        if not num:
            try:
                m = re.search(r"\b(\d{2})\b", page.inner_text("body"))
                if m:
                    num = m.group(1)
            except Exception:
                pass
        if num:
            break
        time.sleep(3)
    surface_number(num, env["env_name"])

    # wait for approval -> analytics (handle the "Stay signed in?" page)
    for _ in range(max(1, wait_secs // 3)):
        time.sleep(3)
        u = page.url.lower()
        try:
            bd = page.inner_text("body").lower()
        except Exception:
            bd = ""
        if "stay signed in" in bd:
            y = _first(page, ['#idSIButton9', 'button:has-text("Yes")'])
            if y:
                y.click(); time.sleep(5); continue
        if "/analytics" in u and "signin" not in u and "login.microsoft" not in u:
            page.close()
            return
    page.close()
    raise RuntimeError("MFA not approved within timeout — session not established")


def authenticate(p, env, headless=True, wait_secs=None):
    """Return (browser, context) with an authenticated OTBI session for env."""
    if wait_secs is None:
        wait_secs = int(os.environ.get("ATD_MFA_WAIT", "420"))  # time to receive NN + approve
    state = _state_path(env["env_name"])
    browser = p.chromium.launch(headless=headless)
    if state.exists():
        ctx = browser.new_context(storage_state=str(state), ignore_https_errors=True,
                                  accept_downloads=True)
        if _validate(ctx, env):
            return browser, ctx
        ctx.close()
    ctx = browser.new_context(ignore_https_errors=True, accept_downloads=True, user_agent=UA)
    _login(ctx, env, wait_secs)
    ctx.storage_state(path=str(state))
    return browser, ctx
