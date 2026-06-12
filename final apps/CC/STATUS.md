# Credit Cards Module (App 202) — Status

**Last updated:** 2026-06-12 (Phase 4)  
**App alias:** CC | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | CC_* tables, sequences, triggers |
| Views | ✅ Complete | 02_cc_views.sql deployed (Phase 4: created_by joins on username) |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups |
| PL/SQL Package | ✅ Complete | DCT_CC_PKG deployed 2026-06-11 — request lifecycle, CUSTOM bank-step conditions, limit history, register_card, replenishments, daily reminder job |
| Alterations | ✅ Complete | 05_cc_alter_audit_cols.sql + 06 + 07 |
| ORDS REST | ✅ Complete | `cc.rest` live at `/ords/admin/cc/` (~27 templates over DCT_CC_PKG); smoke 17/17 |
| JET SPA | ✅ Complete | `Jet/` live, 13 views, brand #B0721E, browser check clean |
| UAT workbook | ✅ Generated | `UAT/UAT_CC_TestScript.xlsx` — 29 cases / 8 areas |
| APEX App Shell | ⬜ Not started | Must be built in APEX Builder |
| APEX Pages | ⬜ Not started | Must be built in APEX Builder |

---

## DB Files (`final apps/CC/db/`)

| File | Status | Contents |
|---|---|---|
| `install.sql` | ✅ | Master install script |
| `01_cc_ddl.sql` | ✅ Deployed | DDL: CC_* tables (cards, transactions, limits, statements…) |
| `02_cc_views.sql` | ✅ Deployed | CC views |
| `03_cc_seed.sql` | ✅ Deployed | Module registration, roles, permissions, settings, lookups |
| `04_cc_pkg.sql` | ✅ Deployed | DCT_CC_PKG spec + body (VALID) + 3 sequences + JOB_CC_REPL_REMINDER (daily 07:00). Approval source_module values: CC_REQUEST / CC_REPLENISHMENT |
| `05_cc_alter_audit_cols.sql` | ✅ Deployed | Added audit columns |
| `06_cc_card_limit_history.sql` | ✅ Deployed | Card limit history table + trigger |
| `07_cc_consolidate_delegation.sql` | ✅ Deployed | Delegation consolidation alteration |
| `08_cc_unified_adoption.sql` | ✅ Deployed | Phase 2: unified docs/lines, lookup-first, CC synonyms |
| `09_cc_ords.sql` | ✅ Deployed | Phase 4: `cc.rest` module + ADMIN synonyms (run in a FRESH session) |

---

## APEX App 202 — Setup Checklist

| Component | Status | Notes |
|---|---|---|
| App shell (App 202) | ⬜ Not started | Create in APEX Builder |
| Subscribe DCT Auth scheme | ⬜ Not started | Shared Components → Auth Schemes → Subscribe from App 200 |
| Standard app items | ⬜ Not started | APP_USER_ID, APP_EMP_NUM, APP_EMP_NAME, APP_ORG_ID, APP_IS_ADMIN, APP_IS_MANAGER, APP_PENDING_APPROVAL_COUNT |
| CC-specific app items | ⬜ Not started | APP_IS_CC_ADMIN, APP_IS_CC_FINANCE |
| SET_APP_ITEMS process | ⬜ Not started | On New Session, standard block + CC extension |
| Common LOVs (9) | ⬜ Not started | Subscribe from App 200 |
| CC-specific LOVs | ⬜ Not started | LOV_CC_CARD_TYPE, LOV_CC_TRANSACTION_TYPE, LOV_CC_STATUS |
| Authorization schemes | ⬜ Not started | Subscribe standard from App 200; add IS_CC_ADMIN, IS_CC_FINANCE locally |

---

## JET SPA — Live (Phase 4, 2026-06-12)

`final apps/CC/Jet/` — 13 view/VM pairs on the shared layer, brand #B0721E
(live from THEME_BRAND_COLOR): dashboard (limits-by-org + 6-month
replenishment compliance charts), **My Card** (card visual, limit-history
timeline, replenishment-due banner), 3-step **New Request wizard** (type
tiles → details → mandatory-doc checklist with upload gate), requests
(Mine/All toggle) + detail (submit/withdraw), replenishments + merchant
lines editor (per-line GL/PROJECT coding + receipt flags), approvals
(comment-mandatory, delegation `actingFor`), All Cards (+register drawer),
proxies, module settings, notifications.
Run locally: `python Jet/dev-proxy.py` → http://localhost:8080 (or enter via
the Admin module switcher — CC is live there).

UAT: `UAT/UAT_CC_TestScript.xlsx` (29 cases). Test scripts:
`assessment-3/phase4/tests/` (smoke + Playwright + seed).
4. Scaffold VMs following `final apps/SHARED_JET_ARCHITECTURE.md`

---

## Immediate Next Steps

1. ~~Implement DCT_CC_PKG~~ ✅ Done 2026-06-11 (see assessment-3/phase1/). NEW_CARD issuance: approval does NOT auto-create the card (bank data is not on the request) — CC Admin calls `dct_cc_pkg.register_card` after the bank issues it.

2. **APEX Builder — create App 202 shell:**
   - New app: ID 202, alias `CC`, schema PROD, Theme 42
   - Subscribe to App 200's `DCT Auth` scheme → set as current
   - Add standard + CC-specific app items

3. **Build page content in APEX Builder** — document page list in `docs/` first.

---

## Key API Gotchas (learned during build)

| Issue | Fix |
|---|---|
| `dct_user_roles` date column | `end_date` (not `valid_to`) |
| `dct_auth.has_role` | Takes `VARCHAR2` username, returns `BOOLEAN` (not NUMBER) |
| `dct_lookup_values` columns | `value_code` / `value_name_en` / `display_order` |
| `dct_gl_code_combinations` | No `cc_concat_segments` — concatenate 9 segment codes manually |
| CC card limits | Limit history tracked in separate table (step 6); query `CC_CARD_LIMIT_HISTORY` for audit trail |
| APEX `WHENEVER SQLERROR ROLLBACK` | Rolls back ALL uncommitted blocks — fix all errors before running |
| ORDS handlers | All execute as ADMIN; every PROD object needs an `ADMIN` synonym if not already present |

## Phase 2 update (2026-06-11) - unified-structure adoption (assessment-3/phase2/)
- Card statuses simplified to ACTIVE | INACTIVE | CLOSED (default INACTIVE); *_IN_PROGRESS retired - DCT_CC_CARD_V derives pending_operation from open requests.
- Documents -> unified DCT_DOCUMENTS / DCT_DOC_REQUIREMENTS (11 reqs re-seeded, mapped to DCT_DOCUMENT_TYPES); replenishment lines -> DCT_BUDGET_CODING_LINES (source_type CC_REPL); every transition logged to DCT_REQUEST_STATUS_HISTORY.
- Dropped: DCT_CC_ATTACHMENTS, DCT_CC_REIMB_LINES, DCT_CC_DOC_REQUIREMENTS. New script: 08_cc_unified_adoption.sql (run after db/v2/15, then re-run 02 + 04).
- Status/type CHECKs removed; 6 CC_* lookup categories seeded (lookup-first, validated via DCT_LOOKUP_PKG).
- Full write-path exercised in PROD (CCR-2026-00001..3, card CC-2026-00001 CLOSED) - see assessment-3/phase2/README.md.
