# Duty Travel (App 204) — Requirements & Feature Assessment

**Purpose:** End-to-end business travel: request → approval → advance payment → travel → settlement → closure, with per-diem calculation by destination country and employee grade, allowances, document requirements, and finance queues.

**Primary sources:** `final apps/DT/STATUS.md` (most complete module doc), `final apps/DT/db/01_dt_ddl.sql` (8 tables), `final apps/DT/db/04_dct_dt_pkg.sql` (12 procs + 3 scheduler jobs), `final apps/DT/Jet/` (19 views, **live ORDS**), `final apps/DT/db/06_dt_ords.sql`.

---

## 1. Actors

9 roles seeded (`final apps/DT/db/02_dt_seed.sql`), 17 permissions. Effective actors:

| Actor | Capabilities |
|---|---|
| Employee | Create/submit travel requests, upload required documents, submit settlements |
| Manager (`IS_DT_MANAGER`) | Approve requests per template |
| Finance (`IS_DT_FINANCE`) | Advance payment (disbursement) queue, settlement review, closure queue |
| DT Admin (`IS_DT_ADMIN`) | Per-diem rate master, country groups, doc requirements, approval rules, settings |

## 2. Functional requirements

### 2.1 Travel request (implemented)
- Mission type BUSINESS_MISSION | TRAINING; trip type INTERNAL | EXTERNAL; multi-leg destinations (`dt_destinations`) each with its own per-diem calc — `dt_requests` (42 cols).
- Per diem snapshot: `employee_grade_code` captured at creation; `total_days` is a virtual column; `total_per_diem_aed` and `total_advance_aed` computed by `DCT_DT_PKG.CALC_PER_DIEM`.
- Optional allowances (ticket, accommodation, visa, local transport, other) toggled by module settings (e.g. INCLUDE_TICKET_ALLOWANCE).
- Budget coding GL or PROJECT at header level (`cc_id_gl` FK exists).
- Status flow: DRAFT → SUBMITTED → APPROVED → ADVANCE_PAID → TRAVELLED → CLOSED (plus REJECTED / RETURNED / CANCELLED).
- JET: `requestForm.html`, `myRequests.html`, `requestDetail.html`, `allRequests.html`.

### 2.2 Per-diem rate engine (implemented — distinctive feature)
- Three configurable rate structures via module setting RATE_STRUCTURE: PER_COUNTRY | TIER_BASED | REGION_BASED (`dt_per_diem_rates` keyed by rate_key + grade_code, date-effective; `dt_country_groups` maps 249 countries to tiers/regions).
- Half-day policy configurable (LOV_DT_HALF_DAY_POLICY).
- JET admin views: `perDiemRates.html`, `countryGroups.html`.

### 2.3 Document requirements (implemented)
- Required documents per mission/trip type, driven by `dt_doc_requirements` (12 seeded rules); uploads in `dt_documents` with expiry dates and alert lead-time.
- JET: `docRequirements.html`.

### 2.4 Settlement & closure (implemented)
- Post-travel settlement statement: claimed vs approved amounts, lines with coding; results in reimbursement to employee or recovery — `dt_settlement` (28 cols) + `dt_settlement_lines`.
- Finance queues: `disbursementQueue.html` (advance payment), `closureQueue.html`.
- Scheduler jobs: `JOB_DT_SET_TRAVELLED` (auto status flip on departure date), `JOB_DT_AUTO_CLOSE`, `JOB_DT_STL_ALERTS` (`final apps/DT/STATUS.md`).

### 2.5 Reporting (implemented)
- `travelReport.html` — travel report generation.

### 2.6 Inferred requirements (not written down)
- Finance disbursement flag `finance_disbursed_yn` implies a payment-confirmation handshake with treasury that has no documented procedure.
- 2 approval templates seeded (likely request vs settlement) — the routing rules themselves are only discoverable by querying seed data.

## 3. Current status (verified 2026-06-11)

| Layer | Status | Evidence |
|---|---|---|
| DB + views + seed + package + 3 jobs | ✅ Deployed | `final apps/DT/db/` 01→04 |
| ORDS | ✅ Live `/ords/admin/dt/` | `06_dt_ords.sql`; JET config points at ADB |
| JET SPA | ✅ 19 views, live mode | `final apps/DT/Jet/js/services/config.js` |
| APEX | App 204 shell + 18 page shells deployed; **page content not built** | `05_apex_204_setup.sql`, `final apps/DT/STATUS.md` |

DT is the reference module — the most complete vertically and the template the others should follow.

## 4. Gaps & recommendations

| # | Gap | Recommendation | Effort |
|---|---|---|---|
| D1 | APEX page content pending (18 shells) | Build per `docs/APEX_PAGE_PLAN.md` in Builder, suggested order in STATUS.md | L |
| D2 | Denormalized totals (`total_per_diem_aed`, `total_advance_aed`) recalculated manually | Compound trigger on `dt_destinations` or expose via view (DB proposal §5) | S |
| D3 | Settlement has no budget-line unification with other modules | Adopt `dct_budget_coding_lines` (DB proposal §3) | M |
| D4 | No itinerary/calendar visualization; destinations are a plain table | Trip timeline component on `requestDetail.html` (see mockups) | M |
| D5 | Per-diem rates have no bulk import (249 country groups maintained row-by-row) | CSV upload endpoint + APEX Data Load page | M |
| D6 | `dt_*` prefix breaks the `dct_*` convention used by every other module | Document as accepted exception, or rename in the unification migration (DB proposal §7) | — |
