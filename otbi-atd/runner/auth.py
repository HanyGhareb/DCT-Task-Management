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

Per-user OTBI credential profiles (db/62): the caller may put a PERSONAL
credential override into the env dict — cred_user / cred_pwd / cred_tg_chat.
A personal identity gets its OWN persistent Chromium profile + saved-state file
(suffix __<slug-of-cred_user>), its own MFA lock row (FUSION_MFA:<login>), and
its number-match push goes to cred_tg_chat. The DEFAULT (service-account)
identity keeps today's exact paths and lock name, byte-for-byte — a deploy of
this file costs no MFA.
"""
import os
import json
import re
import socket
import time
from pathlib import Path

import notify

STATE_DIR = Path(os.environ.get("ATD_STATE_DIR", ".")).resolve()
NUMFILE = os.environ.get("ATD_MFA_NUMFILE", str(STATE_DIR / "otbi_mfa_number.txt"))
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "Chrome/124 Safari/537.36")


def _ident(env):
    """Filesystem-safe slug of the PERSONAL identity ('' = default/service
    account). Derived from the env dict's cred_user override (db/62)."""
    user = (env.get("cred_user") or "").strip()
    if not user:
        return ""
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", user.lower())[:80]


def _state_path(env_name, ident=""):
    # default identity keeps the historical path (no migration, no MFA storm)
    suffix = f"__{ident}" if ident else ""
    return STATE_DIR / f"auth_state_{env_name}{suffix}.json"


def _profile_path(env_name, ident=""):
    """Permanent, VM-local Chromium profile (never shared between workers)."""
    safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", env_name)
    suffix = f"__{ident}" if ident else ""
    return STATE_DIR / f"chrome_{_worker_id()}_{safe}{suffix}"


def _worker_id():
    return (os.environ.get("ATD_WORKER_ID") or socket.gethostname())[:120]


def _creds(env):
    # personal credential override (db/62) wins over the env-var service account
    cu = (env.get("cred_user") or "").strip()
    if cu:
        cp = env.get("cred_pwd")
        if not cp:
            raise RuntimeError(f"personal credential for {cu!r} has no password")
        return cu, cp
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


def _apps_url(env):
    explicit = (env.get("fusion_apps_url") or "").strip()
    if explicit:
        return explicit.rstrip("/") + "/"
    match = re.match(r"^(https?://[^/]+)", env["analytics_base_url"], re.IGNORECASE)
    return (match.group(1) + "/") if match else env["analytics_base_url"]


def _import_legacy_state(ctx, state, profile):
    """One-time cookie bridge so rollout does not discard today's working session."""
    marker = profile / ".legacy_state_imported"
    if marker.exists() or not state.exists():
        return
    try:
        payload = json.loads(state.read_text(encoding="utf-8"))
        cookies = payload.get("cookies") or []
        if cookies:
            ctx.add_cookies(cookies)
        marker.write_text("imported\n", encoding="utf-8")
        print(f"[auth][{_worker_id()}] imported saved cookies into persistent profile", flush=True)
    except Exception as exc:
        print(f"[auth][{_worker_id()}] saved-session migration skipped: {exc}", flush=True)


def _remembered_account(page, user):
    """Find the configured Microsoft account tile on the account picker."""
    try:
        matches = page.get_by_text(user, exact=False)
        for index in range(matches.count()):
            item = matches.nth(index)
            if item.is_visible():
                return item
    except Exception:
        pass
    return None


def _silent_recover(page, ctx, env, user, timeout_secs=35):
    """Follow the normal browser SSO path before considering credentials or MFA."""
    page.goto(_apps_url(env), wait_until="domcontentloaded")
    time.sleep(3)
    ok = _first(page, ['button:has-text("OK")', 'input[value="OK"]'])
    if ok:
        ok.click(); time.sleep(2)
    fed = _first(page, ['text=ADGOV-Employees-Login', 'a:has-text("ADGOV")',
                        'span:has-text("ADGOV")'])
    if fed:
        fed.click(); time.sleep(5)
    account = _remembered_account(page, user)
    if account:
        account.click(); time.sleep(4)
    deadline = time.monotonic() + timeout_secs
    while time.monotonic() < deadline:
        try:
            body = page.inner_text("body").lower()
        except Exception:
            body = ""
        if "stay signed in" in body:
            yes = _first(page, ['#idSIButton9', 'button:has-text("Yes")'])
            if yes:
                yes.click(); time.sleep(4); continue
        if _first(page, ['input[type="password"]', '#i0118', 'input[name="passwd"]']):
            return False
        if "login.microsoftonline.com" not in page.url.lower() and "signin" not in page.url.lower():
            if _validate(ctx, env):
                _record_mfa("SESSION_OK", env["env_name"])
                return True
        time.sleep(1)
    return _validate(ctx, env)


def _record_mfa(status, env_name, number=None, delivery=None):
    """Publish best-effort MFA state for the ATD Worker Fleet dashboard."""
    host = _worker_id()
    delivery = delivery or {}
    try:
        import config
        conn = config.connect()
        try:
            conn.cursor().execute(
                "merge into prod.atd_worker_heartbeat t "
                "using (select :w worker_id from dual) s on (t.worker_id=s.worker_id) "
                "when matched then update set "
                " mfa_status=:st, mfa_number=:num, mfa_env=:env, "
                " mfa_detected=case when :st in ('DETECTED','DELIVERED','FAILED') "
                "                   then systimestamp else mfa_detected end, "
                " mfa_delivered=case when :st='DELIVERED' then systimestamp else mfa_delivered end, "
                " mfa_message_id=:mid, mfa_error=:err, mfa_updated=systimestamp "
                "when not matched then insert "
                " (worker_id,last_seen,status,mfa_status,mfa_number,mfa_env,mfa_detected,"
                "  mfa_delivered,mfa_message_id,mfa_error,mfa_updated) values "
                " (:w,systimestamp,'IDLE',:st,:num,:env,"
                "  case when :st in ('DETECTED','DELIVERED','FAILED') then systimestamp end,"
                "  case when :st='DELIVERED' then systimestamp end,:mid,:err,systimestamp)",
                w=host[:120], st=status, num=number, env=env_name,
                mid=(delivery.get("message_id") if str(delivery.get("message_id", "")).isdigit()
                     else None), err=(delivery.get("error") or None))
            conn.commit()
        finally:
            conn.close()
    except Exception as exc:
        print(f"[auth] MFA dashboard status update failed: {exc}", flush=True)


def _mfa_lock_name(env):
    """Per-account MFA serialization: personal identities lock on their OWN row
    (FUSION_MFA:<login>) so two different humans can approve in parallel, while
    all default/service-account logins keep serializing on the historical
    FUSION_MFA row. Column widened to 200 in db/62."""
    user = (env.get("cred_user") or "").strip()
    return f"FUSION_MFA:{user.lower()}"[:200] if user else "FUSION_MFA"


def _acquire_mfa_slot(env_name, wait_secs, lock_name="FUSION_MFA"):
    """Acquire the MFA lease for `lock_name`, waiting without creating a challenge."""
    import config
    host = _worker_id()
    slot_wait = int(os.environ.get("ATD_MFA_SLOT_WAIT", "1200"))
    lease_secs = max(900, wait_secs + 300)
    deadline = time.monotonic() + slot_wait
    waiting = False
    while True:
        conn = config.connect()
        try:
            cur = conn.cursor()
            # ensure the row exists (per-account rows are created lazily; the
            # UPDATE-based acquire would otherwise silently no-op forever)
            cur.execute(
                "insert into prod.atd_mfa_lock (lock_name) "
                "select :n from dual where not exists "
                "(select 1 from prod.atd_mfa_lock where lock_name=:n)",
                n=lock_name)
            cur.execute(
                "update prod.atd_mfa_lock set owner_worker=:w,acquired_at=systimestamp,"
                "lease_expires=systimestamp+numtodsinterval(:sec,'SECOND') "
                "where lock_name=:n and "
                "(owner_worker is null or owner_worker=:w or lease_expires<systimestamp)",
                w=host, sec=lease_secs, n=lock_name)
            acquired = cur.rowcount == 1
            owner = None
            if not acquired:
                cur.execute("select owner_worker from prod.atd_mfa_lock "
                            "where lock_name=:n", n=lock_name)
                row = cur.fetchone(); owner = row[0] if row else None
            conn.commit()
        finally:
            conn.close()
        if acquired:
            _record_mfa("REQUESTED", env_name)
            print(f"[auth][{host}] acquired MFA slot ({lock_name})", flush=True)
            return
        if not waiting:
            _record_mfa("WAITING_MFA", env_name)
            print(f"[auth][{host}] waiting for MFA slot {lock_name} (owner={owner})", flush=True)
            waiting = True
        if time.monotonic() >= deadline:
            raise RuntimeError(f"MFA slot unavailable after {slot_wait}s (owner={owner})")
        time.sleep(3)


def _release_mfa_slot(lock_name="FUSION_MFA"):
    import config
    host = _worker_id()
    try:
        conn = config.connect()
        try:
            cur = conn.cursor()
            cur.execute("update prod.atd_mfa_lock set owner_worker=null,acquired_at=null,"
                        "lease_expires=null where lock_name=:n and owner_worker=:w",
                        w=host, n=lock_name)
            conn.commit()
        finally:
            conn.close()
        print(f"[auth][{host}] released MFA slot ({lock_name})", flush=True)
    except Exception as exc:
        # The lease is the crash/reconnect safety net if an explicit release fails.
        print(f"[auth][{host}] MFA slot release failed (lease will expire): {exc}", flush=True)


def surface_number(num, env_name, tg_chat=None, who=None):
    """Surface the Entra number-match value to the approving human.

    tg_chat/who: per-user OTBI identity (db/62) — the push goes to that user's
    OWN Telegram chat and names the Fusion account so they know what they are
    approving. Default (None) keeps the global chat + template untouched."""
    msg = num or "see login screen"
    host = os.environ.get("ATD_WORKER_ID") or socket.gethostname()   # which VM is asking
    vm = host[4:] if host.startswith("atd-") else host               # short name, e.g. vm181
    try:
        with open(NUMFILE, "w") as fh:
            fh.write(msg)
    except OSError:
        pass
    print(f"[auth][{host}][{env_name}] >>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: {msg}",
          flush=True)
    # Placeholders: {number} {vm} (short, e.g. vm181) {host} (full id) {env}
    default = "{number} - {vm} OTP for OTBI (use MS Authenticator - expires in a few minutes)"
    text = notify.render("ATD_MFA_MSG", default, number=msg, env=env_name, host=host, vm=vm)
    if msg and str(msg) not in text:        # template dropped the number -> append it so it's never lost
        text = f"{text} (number: {msg})"
    if vm and vm not in text:               # always identify the VM, even if the template omits it
        text = f"[{vm}] {text}"
    if who:                                 # personal identity: say WHICH account is signing in
        text = f"[{who}] {text}"
    delivered = notify.send(text, chat_id=tg_chat)
    info = notify.last_delivery()
    _record_mfa("DELIVERED" if delivered else "FAILED", env_name, msg, info)
    return delivered


_MFA_NUMBER_SELECTORS = (
    '#idRichContext_DisplaySign',
    '.display-sign',
    '[data-bind*="DisplaySign"]',
    '[data-bind*="displaySign"]',
)


def _grab_number(page, timeout_ms=30000, poll_secs=0.35):
    """Return the Entra number-match value, or ``''`` after a bounded wait.

    All known MFA-specific selectors are checked on every poll.  Deliberately do not
    scan the whole page for an arbitrary two-digit value: dates and other sign-in text
    can look like a number-match value (the previously observed false ``07``).
    """
    deadline = time.monotonic() + max(0, timeout_ms) / 1000
    while True:
        for selector in _MFA_NUMBER_SELECTORS:
            try:
                matches = page.locator(selector)
                for index in range(matches.count()):
                    candidate = re.sub(r"\s+", "", matches.nth(index).inner_text() or "")
                    if re.fullmatch(r"\d{2}", candidate):
                        return candidate
            except Exception:
                # Entra replaces parts of the DOM while rendering the challenge; a
                # detached locator on one poll is normal and should not end detection.
                pass
        if time.monotonic() >= deadline:
            return ""
        time.sleep(poll_secs)


def _login(ctx, env, wait_secs):
    user, pwd = _creds(env)
    page = ctx.new_page()
    page.set_default_timeout(30000)
    if _silent_recover(page, ctx, env, user):
        page.close()
        return False

    # Silent recovery reached a real credential page. Only now use the password.
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

    # Poll every MFA-specific selector together.  Keep the wait bounded so a Microsoft
    # markup/login error cannot consume minutes before the operator is notified.
    capture_wait_ms = int(os.environ.get("ATD_MFA_CAPTURE_WAIT_MS", "30000"))
    num = _grab_number(page, timeout_ms=capture_wait_ms)
    if not num:
        # Never reload a live number-match page: Entra can reissue the challenge and
        # make the number shown to the operator differ from the one in Authenticator.
        try:
            page_state = re.sub(r"\s+", " ", page.inner_text("body") or "")[:300]
            page_url = page.url.split("?", 1)[0]
        except Exception:
            page_state, page_url = "unavailable", "unavailable"
        page.close()
        raise RuntimeError(
            f"MFA number not found in Entra challenge within {capture_wait_ms / 1000:g}s; "
            f"page={page_url}; state={page_state}"
        )
    surface_number(num, env["env_name"],
                   tg_chat=env.get("cred_tg_chat"),
                   who=env.get("cred_user") or None)

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
        if "login.microsoft" not in u and "signin" not in u:
            # Entra normally returns to the Fusion welcome page, not directly to
            # OTBI. Validate Analytics in a second tab before declaring success.
            if _validate(ctx, env):
                _record_mfa("APPROVED", env["env_name"])
                page.close()
                return True
    _record_mfa("EXPIRED", env["env_name"])
    page.close()
    raise RuntimeError("MFA not approved within timeout — session not established")


def authenticate(p, env, headless=True, wait_secs=None, force=False):
    """Return (browser, context) with an authenticated OTBI session for env.

    force=True skips the saved-session reuse/validate and goes straight to a fresh
    login (MFA). Use it when the caller already KNOWS the session is dead (e.g. the
    self-heal after a Go-URL login bounce) — `_validate` only checks the cheap
    bieehome page, which can still load when the data-export session has died, so
    trusting it there would silently reuse the dead session."""
    if wait_secs is None:
        wait_secs = int(os.environ.get("ATD_MFA_WAIT", "420"))  # time to receive NN + approve
    ident = _ident(env)                     # '' = default/service identity
    lock_name = _mfa_lock_name(env)
    state = _state_path(env["env_name"], ident)
    profile = _profile_path(env["env_name"], ident)
    profile.mkdir(parents=True, exist_ok=True, mode=0o700)
    ctx = p.chromium.launch_persistent_context(
        str(profile), headless=headless, ignore_https_errors=True,
        accept_downloads=True, user_agent=UA)
    browser = ctx.browser
    if not ident:   # the legacy cookie bridge belongs to the service identity only
        _import_legacy_state(ctx, state, profile)
    if not force and _validate(ctx, env):
        return browser, ctx
    acquired = False
    try:
        _acquire_mfa_slot(env["env_name"], wait_secs, lock_name)
        acquired = True
        used_mfa = _login(ctx, env, wait_secs)
        ctx.storage_state(path=str(state))
        if not used_mfa:
            # No Entra challenge (persistent Microsoft sign-in carried the login).
            # Record the terminal state or the dashboard pill sticks on REQUESTED
            # and the operator waits for a number that will never arrive.
            _record_mfa("SESSION_OK", env["env_name"])
            print(f"[auth][{_worker_id()}] Fusion session recovered from persistent Microsoft sign-in (no MFA)",
                  flush=True)
        return browser, ctx
    except Exception:
        try:
            browser.close()
        except Exception:
            pass
        raise
    finally:
        if acquired:
            _release_mfa_slot(lock_name)
