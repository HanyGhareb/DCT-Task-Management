# APEX Builder Runbook — Cross-UI SSO Hand-off (App 200)

**Feature:** single sign-on between the JET suite and APEX App 200, both directions,
via one-time hand-off codes (`db/v2/41_dct_sso.sql` + `41b_dct_sso_ords.sql`).
This runbook is the **manual APEX Builder part** — per the platform rule, pages are
built in Builder (24.2), never hand-authored as page SQL scripts.

## How it works

- **JET → APEX:** every JET app's topbar shows an **APEX** button when
  `FEATURE_SSO_HANDOFF = Y`. Click → `POST /dct/sso/code` issues a one-time code →
  a new tab opens `f?p=200:9999:0::::P9999_SSO_CODE:<code>` → the Before-Header
  process below resolves the username (`peek_username`) and calls
  `apex_authentication.login(username, 'SSO$'||code)` → `dct_auth.authenticate`
  recognises the `SSO$` sentinel and redeems the code (single-use) → the normal
  APEX login flow completes (session rotation, `post_login`, `SET_APP_ITEMS`).
- **APEX → JET:** the navigation-bar entry targets page 9996, whose Before-Header
  process issues an `APEX2JET` code and redirects to `<JET_SSO_URL>#sso=<code>`;
  the Admin JET app exchanges it at `POST /dct/auth/sso` for a bearer session.

Codes: 32 random bytes, SHA-256 at rest, TTL `SSO_CODE_TTL_SECS` (default 60 s),
single-use, direction-bound, audited (`SSO_ISSUE` / `SSO_REDEEM` in `dct_audit_log`).

## Prerequisites (already scripted — verify before Builder work)

1. `db/v2/41_dct_sso.sql` deployed (DCT_SSO_CODES + DCT_SSO_PKG + DCT_AUTH body + settings).
2. `db/v2/41b_dct_sso_ords.sql` deployed in a fresh SQLcl session
   (`POST /dct/sso/code` + `POST /dct/auth/sso` + `dct_sso_pkg` synonym).
3. Settings present: `FEATURE_SSO_HANDOFF` (leave `N` until everything below is done),
   `SSO_CODE_TTL_SECS`, `APEX_SSO_URL`, `JET_SSO_URL`.
   **`JET_SSO_URL` must point DIRECTLY at the Admin JET app's `index.html`**
   (dev: `http://localhost:8080/Admin/Jet/index.html`) — the Admin app owns the
   `#sso=` exchange hook. Never point it at a lander or a module app: module apps
   redirect session-less visitors to Admin **and drop the URL fragment**, so the
   one-time code is silently lost (hit 2026-07-06 — the root `/index.html` on the
   shared dev-proxy serves whichever app the proxy was started from, e.g. FL).

## 1. Page 9999 (Login) — JET → APEX landing

### 1a. Page item `P9999_SSO_CODE`
- **Type:** Hidden
- **Value Protected:** No (it must accept a value from the URL)
- **Session State Protection:** Unrestricted
- **Maintain session state:** Per Request (Memory Only) — the code must not persist

### 1b. PAGE-level security (gotcha — hit 2026-07-06)
- Page 9999 → **Security → Page Access Protection** must be **Unrestricted**.
  If it is "Arguments Must Have Checksum" (this app's previous value), the hand-off
  URL throws **"Session state protection violation"** before the process ever runs.
  Safe to relax on the login page — no session state exists pre-authentication.
  (Page 9996 needs no change; it receives no URL arguments.)

### 1c. Process `SSO_AUTO_LOGIN`
- **Process Point:** Before Header
- **Sequence:** before everything else on the page
- **Server-side Condition:** Item is NOT NULL → `P9999_SSO_CODE`
- **Source:**

```sql
DECLARE
    l_uname VARCHAR2(100);
BEGIN
    l_uname := prod.dct_sso_pkg.peek_username(:P9999_SSO_CODE);
    IF l_uname IS NOT NULL THEN
        -- Full native login flow: session rotation, the scheme's
        -- post-authentication procedure and SET_APP_ITEMS all fire.
        apex_authentication.login(
            p_username => l_uname,
            p_password => 'SSO$' || :P9999_SSO_CODE);
    END IF;
    :P9999_SSO_CODE := NULL;
EXCEPTION
    WHEN OTHERS THEN
        -- Invalid / expired / disabled: fall through to the normal login form.
        :P9999_SSO_CODE := NULL;
END;
```

No other change to the login page — a bad code simply shows the usual form.

## 2. Page 9996 "Go to JET" — APEX → JET hand-off

Create a new blank page **9996**, alias `GO_JET`:
- **Authentication:** Page Requires Authentication (this is essential — the code
  is issued for `:APP_USER`)
- No regions needed.

### Process `SSO_GO_JET`
- **Process Point:** Before Header
- **Source:**

```sql
DECLARE
    l_code VARCHAR2(64);
    l_url  VARCHAR2(500);
    l_ok   BOOLEAN := FALSE;
BEGIN
    BEGIN
        l_code := prod.dct_sso_pkg.issue_code(
            p_username   => :APP_USER,
            p_direction  => 'APEX2JET',
            p_session_id => TO_CHAR(:APP_SESSION),
            p_agent      => OWA_UTIL.get_cgi_env('HTTP_USER_AGENT'));

        SELECT setting_value INTO l_url
        FROM   prod.dct_system_settings
        WHERE  setting_key = 'JET_SSO_URL';

        l_ok := TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            l_ok := FALSE;   -- feature disabled or misconfigured
    END;

    IF l_ok THEN
        apex_util.redirect_url(l_url || '#sso=' || l_code);
    ELSE
        -- bounce to the home page (friendly-URL-safe)
        apex_util.redirect_url(apex_page.get_url(p_page => 1));
    END IF;
END;
```

> **Gotchas (hit 2026-07-06):**
> 1. `apex_util.redirect_url` works by raising APEX's internal stop-engine
>    exception. A `WHEN OTHERS` wrapped around it catches that *success signal*
>    and a fallback redirect then replaces the good one — the browser lands on a
>    broken relative `f?p` URL (404 under friendly URLs). **Never wrap
>    `redirect_url` in an exception handler** — scope handlers to the fallible
>    work and branch with a flag, as above.
> 2. Do not reference `apex_application.g_stop_apex_engine` by name — on this
>    APEX 24.2 instance it fails validation with PLS-00302.
> 3. Literal `'f?p=' || :APP_ID …` fallbacks resolve wrongly under friendly
>    URLs — use `apex_page.get_url`.

## 3. Navigation-bar entry

**Shared Components → Navigation Bar List** → add entry:
- **Label:** `Open i-Finance Portal` (Arabic translation if the nav bar is translated)
- **Target:** page **9996**
- Optional icon: `fa-external-link`

Module APEX apps subscribe to App 200's shared components; when their pages are
built later, verify the subscribed auth scheme uses a **shared session cookie
name** so APEX↔APEX SSO also holds (out of scope for this wave).

## 4. Enable + smoke test

1. Flip `FEATURE_SSO_HANDOFF` → `Y` (Admin → System Settings, category SECURITY).
2. **JET → APEX:** log in to any JET app → click the **APEX** topbar button →
   a new tab must land in App 200 already authenticated as the same user
   (check `:APP_USER`, and that app items like `USER_ID` / `IS_ADMIN` are populated).
3. **APEX → JET:** log in to App 200 directly → navigation bar → *Open i-Finance
   Portal* → the Admin JET app must land on the dashboard without a login form.
4. **Replay check:** copy the used `f?p...P9999_SSO_CODE:<code>` URL into a new
   private window → must show the normal login form (code is single-use).
5. **Audit check:** `SSO_ISSUE` / `SSO_REDEEM` rows in Admin → Audit Log.

## App mapping — JET module → its own APEX app (41c, 2026-07-06)

The shared-shell APEX button sends the calling JET module's app number
(`POST /dct/sso/code` body `{ app }`, derived from the URL path). The handler
targets that APEX app's login page **only if the app id is on the
`APEX_SSO_APPS` allowlist** (CSV, seeded `200`); anything else falls back to
App 200. `APEX_SSO_URL` is now a template (`f?p=%APP%:9999:0::::P9999_SSO_CODE:`).

**To onboard a module's APEX app (e.g. Petty Cash 201) once it is built:**
1. The app subscribes to App 200's `DCT Auth` scheme (standard checklist) —
   the `SSO$` sentinel then works automatically.
2. On ITS login page 9999, repeat §1a–§1c exactly as in App 200
   (hidden item `P9999_SSO_CODE`, Page Access Protection **Unrestricted**,
   Before-Header `SSO_AUTO_LOGIN` process).
3. Append the app id to the `APEX_SSO_APPS` setting (e.g. `200,201`).
   No code deployment needed — the JET side already sends its app number.

Until an app is allowlisted, its JET users land in App 200 (safe default).

## Notes / limitations (v1)

- **No unified logout:** logging out of one UI does not end the other UI's
  session (each expires by its own idle timeout). Align APEX *Maximum Session
  Idle Time* with `SESSION_TIMEOUT_MINS` (480) for consistency.
- The code transits once as a GET parameter on the APEX side; this is the
  standard authorization-code trust model (short TTL + single-use + hashed at rest).
- A real password literally starting with `SSO$` would be mis-routed at the APEX
  login — do not issue such passwords.

## Status (as of 2026-07-06) + improvement backlog

**LIVE both directions** (`FEATURE_SSO_HANDOFF=Y`): db/v2/41 + 41b + 41c deployed;
App 200 Builder side wired (9999 item+process, page 9996 GO_JET, nav entry);
app mapping active (`APEX_SSO_APPS='200'`, `APEX_SSO_URL` = `%APP%` template);
`JET_SSO_URL = http://localhost:8080/Admin/Jet/index.html` (dev). Verified:
PL/SQL unit 19/19, API smoke 13/13, mapping smoke 6/6, browser E2E 7/7,
cold-start APEX→JET PASS. Tests live in `assessment-3/phase4/tests/`
(`sso_plsql_unit.sql`, `sso_smoke.py`, `sso_map_smoke.py`, `sso_e2e.py`).

Backlog, roughly by value:

1. **Point `JET_SSO_URL` at the production web tier** — the nginx web tier
   (`webtier/`, OCI `ifinance-web`) now serves `final apps/`; when users work
   through it, APEX→JET must redirect there, not to localhost. Single setting.
2. **Onboard module APEX apps as they are built** (PC 201, CC 202, FL 203,
   DT 204, HR 205, TM 207): wire each app's 9999 like App 200 (§1a–1c) + append
   the id to `APEX_SSO_APPS`. App 211 (BI) exists TODAY and could be wired first.
3. **Reverse-direction mapping** — page 9996 always lands in the Admin JET app;
   accept a target module so APEX 201 lands in the PC JET app (Admin exchanges
   the code, then bounces to the module app with the session in place).
4. **Unified logout** — JET logout also closes the APEX session and vice versa
   (needs an APEX-session↔DCT-session link; `dct_sessions.issued_session_id`
   on the SSO code already records the origin session).
5. **Hardening** — rotate the PROD DB password (it transited chat 2026-07-06);
   optional IP-binding of codes; rate-limit `POST /sso/code`.
6. **Align idle timeouts** — APEX Maximum Session Idle Time vs
   `SESSION_TIMEOUT_MINS` (480).
7. **Formal UAT round** for the SSO wave per the Admin UAT convention
   (workbook + results doc + evidence folder).
