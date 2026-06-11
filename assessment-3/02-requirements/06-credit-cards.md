# Credit Cards (App 202) — Requirements & Feature Assessment

**Purpose:** Corporate credit-card administration: card lifecycle requests (issue, limit change, replacement, closure), monthly replenishment (expense statement) submission with line-level budget coding, proxy submitters, and an immutable limit-change audit trail.

**Primary sources:** `final apps/CC/STATUS.md`, `final apps/CC/db/01_cc_ddl.sql` (8 tables), `06_cc_card_limit_history.sql`, `07_cc_consolidate_delegation.sql`. **`04_cc_pkg.sql` is a stub — business logic not implemented.**

---

## 1. Actors

| Actor | Capabilities |
|---|---|
| Cardholder | Card requests, monthly replenishments |
| Proxy (`dct_cc_proxies`) | Submit replenishments on behalf of a cardholder (`on_behalf_of_user_id`) |
| CC Admin (`IS_CC_ADMIN`) | Card registry, doc requirements, limits |
| CC Finance (`IS_CC_FINANCE`) | Replenishment review, statement reconciliation |

## 2. Functional requirements

### 2.1 Card registry (DDL implemented)
- Card master with app-generated number `CC-YYYY-NNNNN`, holder, bank-required personal data (mother name, nationality), credit limit — `dct_credit_cards`.
- Status machine encodes in-flight operations: ACTIVE | INACTIVE | UNDER_PROCESS | REPLACEMENT_IN_PROGRESS | CLOSING_IN_PROGRESS | INCREASING/DECREASING_IN_PROGRESS.

### 2.2 Card lifecycle requests (DDL implemented)
- Request types NEW_CARD | INCREASE_LIMIT | DECREASE_LIMIT | CLOSE_CARD | REPLACEMENT (reason DAMAGED | LOST | EXPIRING | OTHER) — `dct_cc_requests`, statuses DRAFT → SUBMITTED → UNDER_REVIEW → APPROVED/REJECTED/RETURNED/WITHDRAWN.
- Mandatory documents per request type — `dct_cc_doc_requirements` (display-sequenced), uploads in `dct_cc_attachments` (line-level via `reference_id`).

### 2.3 Monthly replenishment (DDL implemented)
- One statement per card per month (`period_month`/`period_year` unique), numbered `CCM-YYYY-MM-NNNNN`; header-level GL coding with line overrides — `dct_cc_replenishments` + `dct_cc_reimb_lines` (merchant, receipt flag).
- Proxy submission supported (`dct_cc_proxies`, date-bounded, granted-by tracked).

### 2.4 Limit audit (implemented incl. trigger)
- Immutable `dct_cc_card_limit_history` (INITIAL | INCREASE | DECREASE, old/new limit, originating request) — `06_cc_card_limit_history.sql`.

### 2.5 Requirements that exist only as intent (nothing implements them)
- **All business logic** — card request processing, status transitions, limit enforcement, replenishment validation, statement generation — is pending in the `DCT_CC_PKG` stub (`final apps/CC/STATUS.md` next-steps §1).
- Bank statement import/reconciliation (matching bank transactions to submitted lines) is implied by "statements" in STATUS.md but has **no table** — a requirement to confirm with the business.

## 3. Current status (verified 2026-06-11)

| Layer | Status | Evidence |
|---|---|---|
| DB + views + seed + alterations | ✅ Deployed | `final apps/CC/db/` 01→03, 05→07 |
| PL/SQL | ⬜ **Stub only — the single biggest backend blocker in the platform** | `04_cc_pkg.sql` |
| ORDS | ⬜ Not started | no ORDS file |
| JET SPA | ⬜ **No `Jet/` folder** (CLAUDE.md table is stale here) | `final apps/CC/STATUS.md` |
| APEX | ⬜ Not started | STATUS.md checklist |

## 4. Gaps & recommendations

| # | Gap | Recommendation | Effort |
|---|---|---|---|
| C1 | DCT_CC_PKG stub | Implement first — everything downstream (ORDS, JET, APEX) depends on it. Mirror DCT_FL_PKG structure: request approval callbacks, status transitions, limit-history writes | L |
| C2 | Card status machine conflates state and in-flight operation (e.g. INCREASING_IN_PROGRESS) | Derive in-flight state from open `dct_cc_requests` instead; shrink card status to ACTIVE / INACTIVE / CLOSED (DB proposal §6) | M |
| C3 | No replenishment ↔ bank-statement reconciliation model | Confirm requirement; if real, add `dct_cc_statements` + matching table before building UI | M |
| C4 | No UI | Scaffold JET from HR template after C1; reuse PC's reimbursement views as the pattern for replenishments | L |
| C5 | Proxy model duplicates the platform delegation concept (`dct_delegations`) | `07_cc_consolidate_delegation.sql` already moved this direction — finish consolidating onto `dct_delegations` scope=MODULE | M |
| C6 | Card data is sensitive (limits, personal data for banks) | Mask card numbers in views; restrict mother-name/nationality columns to CC Admin role | S |
