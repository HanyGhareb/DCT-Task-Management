# Accounts Receivable Module (App 206) — Status

**Function 1: Event P&L Analysis** — AI document classification + expense/revenue
extraction for post-event files (Revenue Assurance).

Built 2026-06-12. Design grounded in real samples
(`E:\hany\DCT\Athba\OneDrive_2026-06-11\Hany - P&L Automation Initiative\`):
the approved 18-cost/16-revenue "Enhanced" category taxonomy, the trusted-source
matrix, and five real document types (audit report, BOQ/commercial proposal,
contract, organizer P&L, post-event report).

## Component status

| Component | Status | Notes |
|---|---|---|
| DB (11 `DCT_AR_*` tables + triggers) | ✅ Deployed | `db/01_ar_ddl.sql` — dedicated `file_blob` in `DCT_AR_EVENT_FILES` (not shared DCT_DOCUMENTS, per user decision) |
| Seeds (lookups, module, roles, settings, categories) | ✅ Deployed | `db/02_ar_seed.sql` — 14 doc categories, 34 P&L categories (workbook verbatim), 10 AR_* lookup categories, 11 settings |
| AI package `DCT_AR_AI_PKG` | ✅ Deployed + live-tested | `db/03_ar_ai_pkg.sql` — classify / extract (lines+KPIs+findings+event-meta per category flags), per-line basis, idempotent re-extract, scheduler job, size guard (>20 MB) |
| Reporting views (4) | ✅ Deployed | `db/04_ar_views.sql` |
| ORDS `ar.rest` at `/ords/admin/ar/` | ✅ Published + smoke-tested | `db/05_ar_ords.sql` — ~30 handlers; run in a FRESH SQLcl session (synonyms) |
| JET SPA (`Jet/`) | ✅ Built | 10 routes: dashboard, events, eventForm, eventDetail (overview/files/P&L/findings tabs), uploadWizard, whatIf, reports, pnlCategories, docCategories, settings |
| Platform registration | ✅ Done | `shared/js/shell.js` MODULES + `mod.ar` i18n keys + `AR` in all dev-proxy `SIBLING_APPS` + `DCT_MODULES` row (App 206) |
| APEX pages | ⬜ Not started |
| AR Customer DB (`DCT_AR_CUSTOMERS` + lookups + AR_WS_* settings) | ✅ Deployed 2026-07-08 | `db/08_ar_customer_ddl.sql` — secrets in DCT_SYSTEM_SETTINGS (encrypted) |
| AR Customer WS package `DCT_AR_WS_PKG` | ✅ Deployed + unit-tested (mock 8/8) | `db/09_ar_customer_ws_pkg.sql` — envelope/gateway/parse/mock; STAGE reachable from ADB, PROD awaits IP whitelisting |
| AR Customer ORDS (`customers/*` ×9, additive) | ✅ Published + API-smoked 12/12 | `db/10_ar_customer_ords.sql` — RE-RUN after any 05 re-run |
| AR Customer JET pages (`arCustomers` + `arCustomerForm`) | ✅ Built + browser-smoked 19/19 | APP_VERSION 4.6.0; 67-field form, Fusion lookup modal, mock banner | Per standing rule: build in APEX Builder 24.2 first |

## AI live-test results

**Power Slap 16 audit report (3.5 MB PDF, event EVT-TEST-0001):**
- Classification: `AUDIT_REPORT_FINAL` @ 98% confidence (auto-confirmed ≥ 85 threshold)
- 10 P&L lines: actual revenue incl. **negative VAT deduction**, 6 BUDGET lines
  totalling **AED 3,441,079** (= the contract's total event cost, exactly)
- 4 audit findings incl. **AED 47,500** potential revenue loss
- 8 KPIs (tickets, footfall, gross revenue 289,417)
- Event meta prefilled: ETHARA / Space42 Arena / DCT-P-BPA-SC-25-00148 / 100% share

**Daz BOQ 2025 (894 KB XLSX via client text rendition, event EVT-2026-0001):**
- Full ORDS upload path: metadata POST + raw-binary PUT + scheduler AI job
- Classification: `BOQ` @ 95% (from the CSV text rendition)
- **189 P&L lines** with quantity × unit-cost, mapped categories
  (BUDGET expense ≈ AED 25.0M + FORECAST revenue ≈ AED 5.35M)

**Browser E2E (Playwright via dev-proxy):** login → module switcher → dashboard
(6 KPI tiles) → events list → event detail (all 4 tabs) → what-if — zero console errors.

## Hard-won implementation gotchas (apply to future modules)

- **ORDS body binds may be dereferenced only ONCE** — assign `:body` to a local
  BLOB first; a second reference silently yields NULL.
- **`:body_blob` is NOT available on this ORDS version** — it binds as VARCHAR2
  (PLS-00382). Use `:body` for raw-binary handlers. (HR's `documents/file/:id`
  PUT uses `:body_blob` and has the same latent bug.)
- **Raw-binary handlers must respond via `:status_code` only** — OWA/JSON output
  in that context 555s.
- **`APEX_JSON.STRINGIFY` has no CLOB overload** — >32k content raises ORA-06502.
  `dct_ar_ai_pkg.json_escape_clob` is the safe escaper. (DCT_PC_AI_PKG has the
  same latent bug for large CSVs.)
- **max_tokens 32000 + truncation salvage** — big BOQs produce 150+ items; on
  parse failure `repair_json` cuts back to the last complete object
  (status `OK_TRUNCATED`, warning surfaced in the Files tab).
- **AI scheduler jobs are created by the ORDS handler (ADMIN)** — PROD does not
  have CREATE JOB and doesn't need it.

## Key settings (Admin → AR → Module Settings)

- **AI providers live in `DCT_AR_AI_PROVIDERS`** (2026-06-13, `07_ar_ai_providers.sql`)
  managed via the settings page's **Manage Providers** popup — per row: code, name,
  api_format (lookup `AR_API_FORMAT`: ANTHROPIC|GEMINI wire protocol), model,
  write-only api_key (`hasKey` flag over REST), optional base_url override, active flag.
  Migrated rows: ANTHROPIC (Claude key set, model claude-haiku-4-5-20251001) and
  GEMINI (no key yet, gemini-flash-latest). The old `AI_MODEL` / `ANTHROPIC_API_KEY`
  / `GEMINI_MODEL` / `GEMINI_API_KEY` setting rows were **removed**;
  `06_ar_patch_gemini.sql` is superseded — do not re-run it.
- `AI_PROVIDER` = the selected `provider_code` (validated against active registry rows).
- `REQUIRE_HUMAN_REVIEW` = Y (N ⇒ AI results auto-confirm straight to dashboards)
- `AUTO_CLASSIFY_ON_UPLOAD` = Y, `MIN_CONFIDENCE_AUTOCONFIRM` = 85 (now a 50–100 pick-list)
- `ENABLE_ALT_FILE_NAME` = N, `ALT_FILE_NAME_FORMAT` = `{EVENT_NAME}-{CATEGORY}-{ORIGINAL_NAME}`
- `DEFAULT_CURRENCY` / `MAX_FILE_SIZE_MB` are pick-lists; `THEME_BRAND_COLOR` is a
  native colour picker (`value_type` 'COLOR' — `chk_dct_modset_valtype` extended platform-wide).

## 2026-06-13 Module Settings redesign

- **Grouped regions** (AI Provider & Models / AI Processing & Review Gate /
  File Handling / Defaults & Appearance + auto "Other" for future keys),
  **per-region Save** that PUTs only dirty fields, dirty-row highlight + unsaved
  counter, **inline audit line** (updated by · at) under every field — settings GET
  now returns `updatedBy`/`updatedAt`.
- **AI provider registry** + `/providers/` ORDS CRUD (GET/POST/PUT/:id/DELETE/:id);
  DELETE blocked for the selected provider and for the last active row; POST/PUT
  validate api_format via `dct_lookup_pkg.validate_lookup`. `DCT_AR_AI_PKG` resolves
  the active row by the `AI_PROVIDER` setting (fallback: first active) and dispatches
  on `api_format`, so an extra Anthropic/Gemini-compatible provider works without code.
- **Shared fix**: ADB ORDS returns HTML 400 for bodyless requests carrying
  `Content-Type: application/json` (every DELETE) — `shared/js/api.js` now sets the
  header only when a body exists.
- Verified: ORDS smoke 17/17, browser E2E 22/22 (regions, dirty/save round-trip,
  popup add/edit/delete, selected-provider guard, zero console errors), AI regression
  classify OK with model read from the registry (extract_log #34).

## 2026-06-12 round-2 changes

- **Gemini AI provider** (`06_ar_patch_gemini.sql` + pkg rework): provider-neutral
  `payload_begin`/`payload_finish`/`call_ai`/`response_json`; Gemini envelope =
  `{"contents":[{"parts":[…]}],"generationConfig":{…}}`, auth = `x-goog-api-key`
  header, answer at `$.candidates[0].content.parts[last].text`.
- **429 auto-retry**: `call_ai` retries once after 30 s on rate-limit. NOTE:
  DBMS_CLOUD raises **ORA-20429** itself for HTTP 429 (not our -20002 wrapper).
- **Per-file Retry button** (Files tab, shown on FAILED rows) → `POST /files/:id/process`
  → scheduler job → `dct_ar_ai_pkg.process_file` (classify if needed, then extract;
  same event-status flow as process_event). Live-tested: 2 stuck 429 files recovered.
- **Module Settings page fixed** — VM never called `reload()`; eternal skeleton.
- **Search boxes** on P&L Categories + Document Categories (client-side filter).
- **docCategories.html foreach fixed** — bare `pnlBasis`/`requiredFor`/`description`
  bindings killed the list after row 1 (APEX_JSON NULL-skip); now `$data.*`.
- ORDS settings handlers mask/protect ANY `%API_KEY` setting.

## Known limitations / next phase

- `.msg` (Outlook binary) files upload + store but have no text rendition → AI
  classification skips them with a clear error; classify manually.
- PDFs > 20 MB are stored but not AI-processed (Claude doc API limit) — split/compress.
- Legacy `.doc` / `.xls` (pre-2007 binary) — no client-side text extraction yet.
- Later phases (proposed): FX rates master, approval workflow on P&L closure
  (DCT_APPROVAL_*), cross-event benchmarking dashboards, OCI bucket bulk ingestion,
  per-event "ask the documents" AI chat.
