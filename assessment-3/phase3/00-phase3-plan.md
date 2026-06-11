# Plan: Phase 3 — Frontend Foundation (mockups-first)

## Context

Phases 1–2 are deployed and tested. Phase 3 of the approved action plan (`assessment-3/06-action-plan.md` §3.1–3.5) builds the frontend foundation across the four JET SPAs (Admin, PC, DT, HR): one shared CSS/JS source of truth, EN/AR i18n with RTL, an async-state standard (skeletons/toast/tri-state), server-side pagination on the big lists, and Chart.js dashboards. Per the user: **create `assessment-3/phase3/` with a `mockups/` folder and show the design before any implementation starts**, and use the `/frontend-design`, `/senior-frontend`, `/ui-design-system` skills for the design/build work.

**Facts verified in exploration (corrections to assumptions):**
- `app.css` is ~90% duplicated (Admin 1145 lines is the superset incl. the Vault section; PC 422 / DT 442 / HR 547) but brand **variable names differ per app** (`--brand-red` vs `--brand-green`…) — extraction is a rename to neutral tokens (`--brand`, `--nav-active-*`), with back-compat aliases kept in each app.css.
- `api.js` is near-identical (only the expired-session redirect differs); HR's variant has the most robust error parsing — use it as the base.
- **No i18n exists anywhere**; fonts are Outfit/Fira Code (no Arabic glyphs) scoped to the Vault tier; base font is Oracle Sans. Session object has **no language field**; `dct_user_preferences` table exists but has no ORDS endpoint.
- Pagination reality: Admin `users/` unbounded `{items}`; Admin `audit/` hardcoded FETCH FIRST 200; PC `pc/all` returns a **raw array** (no envelope); DT `requests/` unbounded `{items}` with `?mine=Y` filter binds; **HR `employees/` already pages natively** (ORDS source_type_query, items_per_page 50, `?offset=` works — today's real bug is the UI silently shows only the first 50).
- Chart.js is not loaded anywhere. Gotcha: its UMD calls anonymous `define()` — must load via `requirejs.config.paths`, never a `<script>` tag; charts must be destroyed on route change (the custom KO `module` binding cleans child nodes).
- Each app is served by its own `dev-proxy.py` rooted at the app folder, so `final apps/shared/` needs a small `translate_path` patch mapping `/shared/*` → the sibling folder.
- Stats endpoints today: PC `pc/stats` (cards), DT `dashboard/` (cards + 5 recent), HR `reports/headcount/` + `reports/expiry-alerts/?days=` (reusable for charts), Admin has none.

## Execution conventions

Same as Phases 1–2: SQLcl `sql -name prod_mcp` via runner files in `c:\tmp`, fresh session for ORDS/synonym scripts (ORA-01471), `prod.` prefixes, `SET DEFINE OFF`. **ORDS module redeploys (dct.admin, pc.rest, dt.rest, hr.rest) are approval-gated** — each module redeployed at most once, with all of this phase's endpoint work bundled in. Skills: `/frontend-design` + `/ui-design-system` guide the mockups & shared design tokens; `/senior-frontend` conventions guide the JS work.

---

## Phase 3.0 — Mockups first ✋ USER REVIEW GATE

Create `assessment-3/phase3/` containing `00-phase3-plan.md` (this plan) and `mockups/` with **3 standalone HTML files** (self-contained, double-click to open, same pattern as `assessment-3/04-uiux/mockups/`). **No app code is touched until the user approves these.**

| Mockup | Demonstrates |
|---|---|
| `01-design-system.html` | Shared token sheet on the light tier + a Vault-dark panel side by side (same tokens, two tiers per design rec §9); **brand switcher** flipping one `:root` override between Admin red `#C74634` / PC green `#2E7D32` / DT blue `#0572CE` / HR teal `#1a7f5a`; full app shell (header, sidebar, cards, table, badges, forms); **EN ↔ ع toggle** that flips `dir="rtl"`, switches to IBM Plex Sans Arabic, and proves the mirrored layout; amounts keep Latin digits in AR |
| `02-dashboards.html` | All 4 module dashboards (tab switcher) with **real Chart.js 4 loaded via RequireJS paths** (proves the AMD gotcha is solved): Admin (approval cycle-time bar + 30-day activity trend line), PC (outstanding floats by org + TEMPORARY ageing stacked), DT (monthly spend vs advances line + status funnel), HR (headcount approved-vs-filled + doc-expiry horizon); theme-aware colors from CSS vars; one chart demoed in RTL with Arabic labels |
| `03-list-pattern.html` | The paginated list standard: skeleton shimmer rows → data; shared pager (prev/next, page-size 25/50/100, "26–50 of 312"); 300 ms debounced search; buttons to force each tri-state (skeleton / data / empty-state / error → **toast** top-end, auto-dismiss, RTL-aware) |

Exit gate: user approves the mockups → visual decisions frozen → implementation begins.

## Phase 3.1 — Shared asset layer `final apps/shared/`

```
final apps/shared/
  css/platform.css   ← ~450 lines extracted from the 4 app.css (shell/header/sidebar/cards/
                       tables/badges/forms/empty-state), neutral tokens, LOGICAL PROPERTIES,
                       + new skeleton/toast/pager styles + [lang="ar"] font rules
  css/themes.css     ← moved from the (identical) per-app copies
  css/vault.css      ← Vault section lifted from Admin app.css (rm-*/re-* + Outfit/Fira imports)
  js/api.js          ← unified fetch wrapper (HR variant as base; expired-session redirect via
                       new config.adminPortalUrl per app; error→toast hook with {silent} opt-out)
  js/i18n.js  js/toast.js  js/skeleton.js  js/pager.js  js/chartLoader.js
  i18n/common.en.json  common.ar.json     (per-app strings live in each app: js/i18n/app.{en,ar}.json)
```

- **dev-proxy.py** (all 4 apps, same ~7-line patch): override `translate_path` to map `/shared/*` → `../../shared`.
- **index.html** (all 4): link `/shared/css/platform.css` + `/shared/css/themes.css` before `css/app.css` (brand overrides win by order); Admin also links `vault.css`.
- **main.js** (all 4): `paths: { 'shared': '/shared/js', 'chartjs': 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min' }`.
- **js/services/api.js** (all 4) becomes a re-export `define(['shared/api'], function(a){return a;})` so ~30 service files are untouched.
- **css/app.css** per app shrinks to brand tokens + true module-specific rules (~40–120 lines), keeping back-compat aliases (`--brand-red: var(--brand)` etc.) so existing view HTML doesn't lose color.
- **Docs same commit:** rewrite the CSS-propagation rule in `final apps/SHARED_JET_ARCHITECTURE.md` (+ shared-layer contract, two-tier rule) and `CLAUDE.md` ("edit platform.css once").

## Phase 3.2 — i18n EN/AR + RTL

- `shared/js/i18n.js` (~80-line AMD module): `t(key, params)` reading a `lang` observable + a revision observable so **live language switching** re-evaluates every KO binding without reload; flat keys (`"users.title"`); fallback ar→en→key; `setLang()` flips `<html lang dir>` and persists to localStorage `ifinance_lang` (shared across the 4 same-origin apps); `fmtNum`/`fmtDate` keep **Latin digits in Arabic** (`ar-AE-u-nu-latn`).
- Fonts: IBM Plex Sans Arabic (+ Plex Mono for Vault) imported in platform.css; `html[lang="ar"]` switches the body font and the `--vault-font/--vault-mono` tokens.
- RTL comes mostly free: platform.css is written with logical properties during the 3.1 extraction; a few `[dir="rtl"]` overrides (sidebar border, chevrons).
- Header gets an `EN | ع` toggle in all 4 apps; each `appController.js` exposes `self.t`/`self.lang` and awaits `i18n.init()` before the first route.
- Optional server persistence: new `prefs/` GET/PUT over `dct_user_preferences` bundled into the dct.admin redeploy (no second deploy).
- **Scope:** Admin's 18 views fully translated (the bulk of the effort); PC/DT/HR get the mechanism + translated shell/nav via `common.*.json` (view bodies stay English, degrade gracefully, translated when next touched). ORDS-emitted English `statusLabel`s flagged as a known follow-up.

## Phase 3.3 — Async-state standard

- platform.css: `.skeleton` shimmer (+ `prefers-reduced-motion` guard), `.toast-host`/`.toast--*` (logical inset → RTL-safe).
- `shared/js/toast.js` (singleton host, `error/success/info`, stack cap 4); `shared/js/skeleton.js` (`<list-skeleton params="rows: 8">` KO component).
- `shared/js/api.js`: non-401 failures → `toast.error()` then re-reject (`{silent:true}` opt-out); 401 keeps the redirect.
- Tri-state contract documented in SHARED_JET_ARCHITECTURE.md; retrofit the 4 big lists + 4 dashboards: `Admin users.html/auditLog.html/dashboard.html`, `PC allPettyCash.html/dashboard.html`, `DT allRequests.html/dashboard.html`, `HR employees.html/dashboard.html`.

## Phase 3.4 — Server-side pagination (ORDS redeploys approval-gated)

Envelope: `{ items, total, limit, offset }`. Handler pattern: guarded `TO_NUMBER([COLON]limit)` capped at 200, default 50; `OFFSET … ROWS FETCH NEXT … ROWS ONLY`; `COUNT(*)` with the same WHERE.

| Endpoint | Change | Redeploy |
|---|---|---|
| `GET /dct/users/` (db/v2/11 ~304) | limit/offset/search/status binds + total | **dct.admin** (bundles audit + stats/ + prefs/) |
| `GET /dct/audit/` (~1003) | replace FETCH FIRST 200 with envelope + filters | same deploy |
| `GET /pc/pc/all` (PC 06 ~206) | **raw array → envelope** + paging + search/status binds; `pcService.js` + `allPettyCash.js` updated in the same change, with a temporary both-shapes shim until deployed | **pc.rest** (bundles pc/charts) |
| `GET /dt/requests/` (DT 06 ~147) | paging on the admin branch; `mine=Y` untouched; uniform envelope | **dt.rest** (bundles dashboard/ extension) |
| `GET /hr/employees/` | **no handler change** — ORDS native paging already live; pager consumes `{items,hasMore,offset,limit}`; wire existing `:search/:org_id/:grade` filters server-side in the VM | hr.rest only if a count endpoint is added |

Frontend: `shared/js/pager.js` KO component (supports `total` mode and `hasMore` mode); VM rewrites swap client-side `filteredX` computeds for server query + 300 ms `rateLimit` debounced search: `Admin users.js / auditLog.js`, `PC allPettyCash.js`, `DT allRequests.js`, `HR employees.js`.

## Phase 3.5 — Chart.js dashboards (2 per module)

- `shared/js/chartLoader.js`: builds palette from CSS vars (`--brand`, `--text-secondary`, `--border-color`), sets Arabic font + `rtl/textDirection` when `lang()==='ar'`, exports `makeChart(canvas, cfg)` registering a KO dispose callback → `chart.destroy()` (prevents leaked charts on route change).
- Endpoints (bundled into the 3.4 deploys): **Admin NEW `stats/`** in db/v2/11 (approval cycle time per module from `dct_approval_instances` 90d; audit actions/logins by day 30d) · **PC new `pc/charts`** (floats by org from `dct_pc_admin_v`; TEMPORARY ageing buckets by `disbursed_date`) · **DT extend `dashboard/`** additively (`monthlySpend` 12-month series; `statusFunnel` counts) · **HR reuse** `reports/headcount/` + `reports/expiry-alerts/?days=90` (no DB change).
- Each `views/dashboard.html` + `viewModels/dashboard.js` (4 apps) gains two chart cards with the tri-state pattern.

## Phase 3.6 — Test + report

- `assessment-3/phase3/tests/phase3_smoke.ps1` (phase2 harness pattern; creds parsed from repo, never printed): pagination envelopes on all 5 endpoints (incl. HR `?offset=50` second page), search binds, `mine=Y` regression, new `stats/`/`pc/charts`/extended `dashboard/` keys, 401s, prefs round-trip.
- Browser pass per app via its dev-proxy (webapp-testing skill where useful): `/shared/*` resolves; brand colors per app; EN→AR mirrors layout + Plex Arabic + Latin digits + persists on reload; skeleton/empty/error/toast states; pager + debounced search round-trip; both charts render, survive route-away/back, recolor with theme.
- Report → `assessment-3/phase3/README.md` (phase2 pattern) + update `CLAUDE.md`, `SHARED_JET_ARCHITECTURE.md`, action plan (mark Phase 3), memory.

## Order, risks, effort

**Order:** 3.0 mockups → user gate → 3.1 shared layer (RTL pass inside the extraction) → 3.2 + 3.3 → 3.4 + 3.5 endpoint drafts → one gated redeploy per ORDS module → VM/dashboard wiring → 3.6.
**Top risks:** pc/all envelope is breaking (shim until deploy lands) · Chart.js must never be script-tagged · brand-var rename needs aliases or views lose color · `urlArgs` doesn't cache-bust `<link>` CSS (hard-refresh when testing) · ORDS redeploy = brief module outage (gated, once per module).
**Effort:** ≈ 10–12 dev-days end-to-end; mockups 0.5–1 day.

## Approval gates
1. **Mockup review** (3.0) — implementation starts only after user approval of the three mockups.
2. **ORDS redeploys**: dct.admin, pc.rest, dt.rest (and hr.rest only if a count endpoint is added) — ask before each (or batch-approve).
