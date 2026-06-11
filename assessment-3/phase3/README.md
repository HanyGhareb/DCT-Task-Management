# Phase 3 — Frontend Foundation: Execution + Test Report

**Executed:** 2026-06-11 · Plan: [00-phase3-plan.md](00-phase3-plan.md) · Mockups (user-approved, rev 3): [mockups/](mockups/) · Test evidence: [tests/](tests/)

**Result: ✅ all five items (3.1–3.5) shipped and verified live.** Three ORDS modules redeployed (user-approved); 15/15 endpoint smoke tests pass; browser verification covers all four apps' shells, the Admin charts/pagination, and the full EN↔AR round trip including server-side language persistence.

---

## 1. What shipped

### 3.1 Shared asset layer — `final apps/shared/`
| Piece | Content |
|---|---|
| `css/platform.css` | ONE stylesheet for all apps: design tokens (settings-driven brand, light "Ledger" tier, dark chrome), the approved page-level shell (fixed top bar + **module switcher dropdown** + full-height side navigation), every legacy component class restyled (cards, tables, badges, forms, login, modals…), new skeleton/toast/pager/chart-card components, IBM Plex Sans Arabic + logical properties (RTL free), legacy variable aliases so existing views keep working, `data-theme` mappings for the old Appearance themes |
| `css/vault.css` | Vault dark tier lifted verbatim from Admin (rm-*/re-*), + Arabic font mapping |
| `css/themes.css` | moved from the four identical per-app copies |
| `js/api.js` | the ONE fetch wrapper (Bearer, tolerant parsing, 401→`config.adminPortalUrl` redirect, non-401→toast with `{silent}` opt-out). Each app's `services/api.js` is now a 1-line re-export |
| `js/i18n.js` | `t()` with live language switching (no reload), localStorage `ifinance_lang` + Latin digits in AR (`fmtNum`/`fmtDate`) |
| `js/toast.js` / `js/skeleton.js` / `js/pager.js` | toast stack (cap 4, RTL-aware) · `<list-skeleton>` shimmer rows · `<list-pager>` (envelope `total` mode + ORDS-native `hasMore` mode) |
| `js/chartLoader.js` | Chart.js glue: CSS-var palette, AR font + RTL legends/tooltips, **auto `chart.destroy()` via KO node disposal** (no leaked canvases on route change) |
| `js/shell.js` | module registry (6 modules incl. FL/CC as "soon"), `applyBrand(hex)` deriving dark/soft from ONE stored hex, `initBrand(module, settingFetch)` |
| `i18n/common.{en,ar}.json` | shell/nav/status/pager/empty-state/toast strings |

**Wiring (all 4 apps):** dev-proxy.py serves `/shared/*` from the sibling folder (~7-line `translate_path` patch); `index.html` rebuilt to the approved page-level shell (top bar + switcher + EN|ع toggle + full-height side-nav); `main.js` adds `shared` + `chartjs` RequireJS paths and boots after `i18n.init()`; `appController.js` gets i18n + module switcher + per-module nav with `labelKey`s; **`css/app.css` per app collapsed to brand tokens only** (Admin 15 lines, PC/DT ~20, HR keeps its module-specific employee-card/audit/sort styles). Brand color is **settings-driven**: `shell.initBrand` applies the registry default then overrides from the module's `THEME_BRAND_COLOR` setting (Admin: system settings; PC/DT: module settings via `settingService.getValue`).

### 3.2 i18n EN/AR + RTL
- Mechanism in all 4 apps: header `EN | ع` toggle, `<html lang dir>` flip, IBM Plex Sans Arabic, logical-properties layout (verified mirrored in browser for all four apps).
- **Admin:** fully translated shell/nav + 7 views fully converted (dashboard, users, auditLog, login, notifications, pendingApprovals, systemSettings) + translated titles/subtitles on the remaining 11 views. PC/DT/HR: translated shell/nav per the approved scope.
- **Server persistence:** new `prefs/` GET + `prefs/:prefkey` PUT over `DCT_USER_PREFERENCES`; Admin PUTs `LANG` on toggle and applies it at login (verified: toggling AR in one browser made a fresh login come up in Arabic).

### 3.3 Async-state standard
Tri-state pattern (skeleton → data/empty → error+toast+retry) live on the 4 big lists and 4 dashboards; `shared/api.js` toasts non-401 failures globally. The error leg was exercised for real during testing (see §3 finding 4).

### 3.4 Server-side pagination
| Endpoint | Change | Verified live |
|---|---|---|
| `GET /dct/users/` | `{items,total,limit,offset}` + `search`/`status` binds | total/limit/offset + search + offset paging ✓ |
| `GET /dct/audit/` | same (replaces hardcoded FETCH FIRST 200) + `action` filter | "1–50 of 92" in the UI ✓ |
| `GET /pc/pc/all` | **raw array → envelope** + paging + `search`/`status` (JET shim tolerates both shapes) | envelope + status filter ✓ |
| `GET /dt/requests/` | admin branch paged; `mine=Y`/`advancePending=Y` untouched | envelope + mine regression ✓ |
| `GET /hr/employees/` | no handler change — ORDS-native paging consumed properly (fixes the **silent first-50-only bug**); filters now server-side | hasMore mode wired |
VMs rewritten (Admin users/auditLog, PC allPettyCash, DT allRequests, HR employees): client-side `filtered` computeds → server query with 300 ms debounced search + shared `<list-pager>`.

### 3.5 Chart.js dashboards (2 per module)
- Loaded via RequireJS `paths` (never a `<script>` tag — the UMD's anonymous `define()` breaks under RequireJS).
- **Admin** (NEW `GET /dct/stats/`): approval cycle-time by module (90d) + logins-vs-actions trend (30d) + live headline counts. **PC** (NEW `GET /pc/pc/charts`): outstanding floats by org + TEMPORARY ageing buckets. **DT** (extended `GET /dt/dashboard/`, additive): monthly advances-vs-per-diem + status funnel. **HR** (existing `reports/headcount/` + `reports/expiry-alerts/?days=90`): approved-vs-filled headcount + doc expiry horizon.
- Charts re-render in Arabic (RTL legends/tooltips) and are destroyed on route change.

## 2. Deploys + tests

- **Redeployed (user-approved, fresh sessions):** `dct.admin` (pagination + stats + prefs + drift fixes), `pc.rest` (envelope + charts), `dt.rest` (paging + dashboard series). `hr.rest` untouched.
- **[tests/phase3_smoke.ps1](tests/phase3_smoke.ps1): 15/15 PASS** — envelopes, search/status/action binds, offset paging, stats/charts keys, `mine=Y` regression, prefs round-trip, 401s.
- **Browser (Playwright, [tests/](tests/)):** all 4 apps boot on the shared shell with correct brands and working module switcher; Admin end-to-end: 2 dashboard charts with live stats, users list + pager, audit "1–50 of 92", full AR pass (mirrored chrome, Arabic nav/views, Latin digits), language persists via server pref; PC/DT/HR shells verified incl. AR. Zero non-network JS console errors.

## 3. Pre-existing platform bugs found and fixed along the way

1. **`GET /dct/settings/` returned HTTP 555 since inception** — the handler referenced `setting_type`/`is_editable`/`display_order`, columns that never existed on `DCT_SYSTEM_SETTINGS` (real: `value_type`/`category`/`is_system`). Fixed + secret masking added (`%API_KEY%/%SECRET%/%PASSWORD%/%TOKEN%` + `is_encrypted` → `********`, PUT refuses the mask) — the Admin settings endpoint had the same leak class fixed for PC in Phase 1.
2. **`GET /dct/notifications/` returned HTTP 555 since inception** — referenced `title`/`body`; the real columns are `title_en`/`body_en`. Fixed (this is why the Admin bell count never worked).
3. **`prefs/` 555** — two causes fixed: missing ADMIN synonym for `dct_user_preferences` (now in db/v2/11's synonym block, with `dct_approval_*` added for self-sufficiency) and the `:key` bind renamed `:prefkey`.
4. **KO crash on nullable API fields** — `APEX_JSON.write` skips NULLs, so bare `text: employeeNumber` bindings throw ReferenceError when the field is absent (this also explains odd legacy behavior). Convention adopted: **bind optional fields as `$data.field || ''`** (documented in SHARED_JET_ARCHITECTURE.md).
5. `authService.getUnreadCount` ran pre-login (guaranteed 401/555 on the login screen) — now guarded + silent.

## 4. Known follow-ups

- Deep-body translation of the remaining 11 Admin views (titles/subtitles done; tables/forms inside still English) and PC/DT/HR view bodies — mechanical `t()` conversion, dictionary pattern established.
- ORDS-emitted English `statusLabel`s (DT) — map client-side via i18n keys when DT views are next touched.
- Pre-login theme fetch 401 (cosmetic console entry on the login page) — guard `themeService`/`_applyServerTheme` behind login.
- `THEME_BRAND_COLOR` rows are not yet seeded in `DCT_SYSTEM_SETTINGS`/`DCT_MODULE_SETTINGS` — apps fall back to registry defaults until an admin creates them (one row per module; the Settings UI can do it).
- `dct_employees` has 6 rows but `GET /hr/employees/` returned 0 items in the smoke — investigate the HR query's join/filters when HR is next touched (pre-existing; handler untouched this phase).
- HR brand-from-settings hook not wired (HR has no settingService); uses the registry default teal.

## 5. Files changed (summary)

**New:** `final apps/shared/` (3 css + 7 js + 2 i18n json), per-app `js/i18n/app.{en,ar}.json` (4 apps), `assessment-3/phase3/` (plan, mockups ×3, tests ×4, this report).
**Modified:** all 4 apps' `index.html`, `main.js`, `appController.js`, `css/app.css`, `dev-proxy.py`, `services/api.js`, `services/config.js` · Admin: userService/auditService/authService/settingService-consumers, dashboard/users/auditLog/login/notifications/pendingApprovals/systemSettings views+VMs, 11 more view headers · PC: pcService, allPettyCash, dashboard · DT: dtService, allRequests, dashboard, 03_dt_views (earlier) · HR: hrService, employees, dashboard · `db/v2/11_dct_ords.sql` (pagination, stats, prefs, synonyms, settings/notifications fixes), `final apps/PC/db/06_pc_ords.sql`, `final apps/DT/db/06_dt_ords.sql`.
