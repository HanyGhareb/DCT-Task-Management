# Credit Cards Module (App 202) — Status

**Last updated:** 2026-06-10  
**App alias:** CC | **Schema:** PROD | **APEX version:** 24.2

---

## Overall Progress

| Layer | Status | Detail |
|---|---|---|
| Database DDL | ✅ Complete | CC_* tables, sequences, triggers |
| Views | ✅ Complete | 02_cc_views.sql deployed |
| Seed Data | ✅ Complete | Module, roles, permissions, settings, lookups |
| PL/SQL Package | ⬜ Not started | 04_cc_pkg.sql stub exists — business logic not yet implemented |
| Alterations | ✅ Complete | 05_cc_alter_audit_cols.sql + 06 + 07 |
| JET SPA | ⬜ Not started | No Jet/ folder yet |
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
| `04_cc_pkg.sql` | ⬜ Stub only | DCT_CC_PKG — stub file, business logic not yet written |
| `05_cc_alter_audit_cols.sql` | ✅ Deployed | Added audit columns |
| `06_cc_card_limit_history.sql` | ✅ Deployed | Card limit history table + trigger |
| `07_cc_consolidate_delegation.sql` | ✅ Deployed | Delegation consolidation alteration |

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

## JET SPA — Not Started

No `Jet/` folder exists. Credit Cards module is currently APEX-only.

To start the JET SPA:
1. Create `final apps/CC/Jet/` by copying the HR module structure as a template
2. Update branding (brand-cube `CC`, title, brand-name)
3. Add `apiBase: '/ords/admin/cc'` in `config.js`
4. Scaffold VMs following `final apps/SHARED_JET_ARCHITECTURE.md`

---

## Immediate Next Steps

1. **Implement DCT_CC_PKG** in `04_cc_pkg.sql` — the stub is in place; write the business logic (card management, transaction processing, limit enforcement, statement generation).

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
