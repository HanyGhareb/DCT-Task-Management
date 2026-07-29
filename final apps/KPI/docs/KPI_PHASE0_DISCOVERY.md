# Finance KPI App 213 — Phase 0 Discovery Pack

**Status:** IN PROGRESS  
**Started:** 2026-07-28  
**Purpose:** business decisions and verified baseline required before the v2 UX blueprint  
**Exit gate:** product-owner sign-off on decisions, assignments, evidence, due dates, and glossary

## 1. Current-state conclusion

The KPI platform is functionally complete, but the v1.2.0 interface failed end-user review
because it exposes the configurable framework before the user's task. The primary problem is
information architecture and language, not the deployed calculation or workflow engine.

Evidence reviewed:

- `KPI_PLAN.md`, `KPI_REDESIGN_PLAN.md`, and `KPI_IMPLEMENTATION_PLAN.md`;
- all nine current JET routes and view models;
- English and Arabic application dictionaries;
- database definitions, seeded KPI content, calculation package, DWP process, and ORDS routes;
- UAT round 1 workbook, generated results document, and 18 desktop screenshots.

## 2. Verified technical baseline

| Area | Recorded baseline | Phase 0 interpretation |
|---|---|---|
| PL/SQL | 36/36 recorded PASS | Calculation baseline; requires rerun with live DB credentials |
| ORDS API | 56/56 recorded PASS | Endpoint baseline; requires rerun with three live session tokens |
| Browser smoke | 20/20 recorded PASS | Route/component presence, not task usability |
| UAT round 1 | 18/18 recorded PASS | Automated functional run; not end-user acceptance |
| Database objects | 0 INVALID recorded | Requires fresh pre-build snapshot |
| Report | 8-page briefing book generated | Preserve reporting control plane |
| End-user review | FAILED: “not clear, not simple” | Governing UX result for the redesign |

Live test rerun is currently pending because `KPI_TOK_ADMIN`, `KPI_TOK_USER`, and
`KPI_TOK_SYS` are not available in this workspace session.

### Baseline evidence concern

The generated UAT results mark KPI-18 “Arabic interface with RTL layout” as PASS while its
recorded actual value is `ltr`. This result cannot be accepted as valid RTL evidence. The
current Playwright smoke source performs an explicit `document.documentElement.dir == 'rtl'`
check, but the live bilingual baseline must be rerun and archived before Phase 0 closes.

## 3. Current route inventory

| Current route | Intended job | Baseline issue | v2 disposition |
|---|---|---|---|
| `dashboard` | Understand performance | Default landing for all roles; mixes onboarding, operational counts, scorecards, and chart | Replace with `scorecard`; Home becomes default |
| `results` | Start/open measurements | Requires understanding a KPI × period matrix and clickable empty cells | Keep as admin calendar/optional overview; replace user path with tasks and KPI pages |
| `resultEntry` | Complete a measurement | Long page combines scoring rules, entry, criteria, evidence, and history | Replace with guided wizard |
| `myWorklist` | Act on approvals | Separate destination; compact row actions lack decision context | Replace with Home approval tasks + review page |
| `reports` | Generate briefing book | Functional but uses reporting-platform language | Simplify to one primary report action |
| `kpiList` | Configure registry | Appropriate for administrators | Retain under Administration with clearer validation |
| `kpiEdit` | Configure KPI | Very dense multi-purpose editor | Split into focused admin sections/screens |
| `notifications` | View alerts | Duplicates top-bar notification access | Remove from primary navigation; retain route/deep links |
| `login` | Authentication fallback | Module normally delegates to Admin | Preserve shared authentication behavior |

## 4. Verified usability findings

### Blocking

1. There is no authoritative mapping from KPI to responsible preparer, so a task-first Home
   cannot safely decide who sees unstarted work.
2. Submission due dates are not stored; task urgency and meaningful reminders cannot be shown.
3. Required evidence is currently a single yes/no rule, not a business checklist by KPI.
4. The Finance Director role holder is a placeholder and must be confirmed before production
   approval routing is considered operationally complete.

### High friction

1. The default page prioritizes analysis instead of “what do I need to do now?”.
2. Preparers must infer that a matrix cell creates or opens work.
3. Measurement entry presents internal terms including bands, provenance, contribution, and
   figure A/B before the business question.
4. Approvers can act from a worklist row without first seeing a decision-ready submission
   summary and evidence.
5. Oversized titles, repeated gradient section bars, and equal visual weight make operational
   pages feel denser than their underlying task.
6. Empty scorecards still allocate space to chart/reporting structures instead of explaining
   the next useful action.

### Accessibility and resilience

1. Several cards, matrix cells, guide steps, and disclosure headers are clickable `<div>`
   elements without complete keyboard semantics.
2. Native `title` attributes carry important help content that is unavailable or unreliable
   for touch and keyboard users.
3. Some request failures are silently caught, leaving an empty page with no Retry action.
4. Current templates have limited explicit label/input association and live-region feedback.
5. Mobile route screenshots and formal accessibility evidence do not exist in UAT round 1.

### Content/data observation to resolve

The seeded Revenue and Cash labels describe the numerator as “(B)” and denominator as “(A)”
while the package stores and calculates `figure_a / figure_b`. The numeric calculation is
internally consistent because source A is the numerator, but exposing A/B terminology creates
avoidable ambiguity. The v2 interface should use business questions only; the business owner
must confirm the final wording in the glossary.

## 5. Decision register

`PENDING` decisions block the Phase 1 sign-off. Recommended choices are proposals, not assumed
business approval.

| ID | Decision | Current state | Recommended choice | Business owner | Status |
|---|---|---|---|---|---|
| D01 | Responsible preparer(s) per KPI | No per-KPI mapping | Designated active preparers per KPI | Finance KPI owner | PENDING |
| D02 | Who sees unstarted work? | Any KPI user can currently initiate | Assigned preparers; KPI admin sees exceptions | Finance KPI owner | PENDING |
| D03 | Section Head resolver | Line manager with KPI_ADMIN fallback | Keep line manager if HR hierarchy is authoritative | Finance/HR | PENDING |
| D04 | Final approver holder | `KPI_FIN_DIRECTOR`; ADMIN placeholder noted | Assign named incumbent plus controlled backup | Finance Director | PENDING |
| D05 | 2026/2027 due dates | Period end only; no due date | Store explicit submission due date per period | Finance KPI owner | PENDING |
| D06 | Evidence checklist | One generic KPI evidence document | Required/optional types per KPI | Finance KPI owner | PENDING |
| D07 | Missing required evidence | At least one document blocks evidence-required KPI | Block each missing mandatory checklist item | Finance KPI owner | PENDING |
| D08 | Revenue GL account scope | Source configured but business scope open | Approve account/natural-account range in writing | Revenue/GL owner | PENDING |
| D09 | Scorecard weights | 25% each | Confirm weights and enforce total = 100% | Finance leadership | PENDING |
| D10 | Financial-law cadence | Annual result with mixed-frequency notes | Keep annual only if business confirms | Finance KPI owner | PENDING |
| D11 | Cross-department visibility | KPI roles are module-wide | KPI admin/executive view all; preparers assigned scope | Security owner | PENDING |
| D12 | Override reason rule | Required when suggested value is changed | Keep mandatory with visible comparison | Finance KPI owner | PENDING |
| D13 | One-page scorecard format | Not implemented | Controlled bilingual PDF via Reporting Platform | Executive sponsor | PENDING |

## 6. Role and assignment matrix — business completion required

Enter user IDs/usernames, not only display names, so implementation can be validated against
`DCT_USERS`. A primary and backup may be effective-dated.

| KPI | Primary preparer | Backup preparer | Section Head | Can view all? | Status |
|---|---|---|---|---|---|
| Revenue Growth | TBC | TBC | TBC | TBC | PENDING |
| Optimization Plan | TBC | TBC | TBC | TBC | PENDING |
| Cash Management and Financial Planning | TBC | TBC | TBC | TBC | PENDING |
| Compliance with Financial Law | TBC | TBC | TBC | TBC | PENDING |
| Final approval — all KPIs | N/A | TBC delegate | `KPI_FIN_DIRECTOR`: TBC | Yes | PENDING |
| KPI administration | `KPI_ADMIN`: TBC | TBC | N/A | Yes | PENDING |

Validation questions:

1. May one KPI have multiple simultaneous preparers?
2. Does the first preparer to start a result become its owner, or must ownership be explicit?
3. Who covers leave, transfer, or inactive-user cases?
4. May KPI admins edit another preparer’s draft, or only reassign it?

## 7. Due-date matrix — business completion required

Dates below are deliberately blank. Period end dates must not be presented as approved
submission deadlines unless the owner explicitly confirms that rule.

| Measurement | 2026 due date | 2027 due date | Reminder stages | Status |
|---|---|---|---|---|
| Annual | TBC | TBC | Proposed T-7, T-1, due day, overdue | PENDING |
| Q1 | TBC | TBC | Proposed T-7, T-1, due day, overdue | PENDING |
| Q2 | TBC | TBC | Proposed T-7, T-1, due day, overdue | PENDING |
| Q3 | TBC | TBC | Proposed T-7, T-1, due day, overdue | PENDING |
| Q4 | TBC | TBC | Proposed T-7, T-1, due day, overdue | PENDING |

Confirm whether deadlines are shared across all KPIs or can vary by KPI. The implementation
plan currently assumes a period-level date; KPI-specific dates require a different key.

## 8. Evidence matrix — business completion required

| KPI | Proposed evidence | Required? | Allowed formats | Business confirmation |
|---|---|---:|---|---|
| Revenue Growth | GL revenue extract/reconciliation | TBC | PDF/XLSX TBC | PENDING |
| Optimization Plan | Approved optimization plan | Yes (proposed) | PDF TBC | PENDING |
| Optimization Plan | Savings calculation/support | Yes (proposed) | PDF/XLSX TBC | PENDING |
| Optimization Plan | Implementation/results evidence | Yes (proposed) | PDF/XLSX TBC | PENDING |
| Cash Management | Actual-versus-forecast reconciliation | TBC | PDF/XLSX TBC | PENDING |
| Financial Law Compliance | Compliance checklist | Yes (proposed) | PDF/XLSX TBC | PENDING |
| Financial Law Compliance | Supporting circular/report submissions | TBC | PDF TBC | PENDING |
| All KPIs | Other supporting document | Optional | Current upload allow-list TBC | PENDING |

For each row confirm maximum count, accepted formats, whether one file may satisfy multiple
requirements, and whether the requirement blocks submission.

## 9. Structured workshop script

### Preparer session — 45 minutes

1. Ask the user to explain the real KPI cycle without showing the application.
2. Identify how they know work is due and who asks for it.
3. Observe them locate and complete one current v1 measurement.
4. Do not coach; record every hesitation, wrong route, and term they ask about.
5. Ask which source values they trust, how they reconcile them, and when they override them.
6. Ask what evidence they expect for each KPI and when it becomes available.
7. Ask what they need to see after submission and after a return.
8. Measure time to find, start, save, attach, review, and submit.

### Approver session — 30 minutes

1. Ask what evidence is required before approving each KPI.
2. Observe them open and decide a submission in v1.
3. Record any information they must obtain outside the app.
4. Confirm meanings and consequences of Approve, Return, and Reject.
5. Confirm when comments are mandatory.
6. Measure time to locate, understand, and decide the request.

### Executive session — 20 minutes

1. Ask “How are we doing overall?” and “How are we doing on Cash?”.
2. Observe where the user looks first and what comparison they expect.
3. Confirm preferred score interpretation and whether 1–5 or percentage should lead.
4. Confirm the content and distribution format of the one-page scorecard.

## 10. Usability baseline capture sheet

Complete during observed sessions; automated test duration is not a substitute.

| Scenario | User/role | Time | Wrong turns | Assistance | Completed? | Notes |
|---|---|---:|---:|---:|---:|---|
| Find current measurement | TBC | TBC | TBC | TBC | TBC | |
| Complete numeric KPI | TBC | TBC | TBC | TBC | TBC | |
| Complete rubric KPI | TBC | TBC | TBC | TBC | TBC | |
| Attach evidence and submit | TBC | TBC | TBC | TBC | TBC | |
| Review and approve | TBC | TBC | TBC | TBC | TBC | |
| Find Cash performance | TBC | TBC | TBC | TBC | TBC | |

Post-task questions (1–5): confidence, clarity, effort, trust in calculation, and likelihood of
needing help next time.

## 11. Screenshot and test-evidence baseline

Existing UAT evidence contains `case_01.png` through `case_18.png`, all 1440×900 desktop.
The set covers dashboard, registry, configuration, period generation, result calculations,
evidence, workflow, scorecard, report, and language switching.

Required additions before Phase 0 exit:

- authenticated desktop screenshot of every current route in English;
- authenticated desktop screenshot of core routes in Arabic/RTL;
- 390×844 mobile screenshots for dashboard, results, result entry, worklist, and reports;
- error and empty states for every core route;
- visible keyboard focus evidence on the main flow;
- corrected Arabic direction assertion and output.

## 12. Phase 0 completion checklist

- [x] Review implementation, documentation, i18n, UAT report, and screenshot inventory.
- [x] Establish functional-versus-usability baseline distinction.
- [x] Create decision register.
- [x] Create role/assignment template.
- [x] Create due-date template.
- [x] Create evidence template.
- [x] Draft bilingual glossary in `KPI_GLOSSARY.md`.
- [ ] Run observed preparer session.
- [ ] Run observed approver session.
- [ ] Run executive session.
- [ ] Obtain named role holders and assignments.
- [ ] Obtain approved deadlines.
- [ ] Obtain approved evidence requirements.
- [ ] Obtain signed bilingual glossary.
- [ ] Rerun and archive live PL/SQL/API/browser baseline.
- [ ] Capture desktop/mobile EN/AR route screenshots.
- [ ] Product owner signs Phase 0 exit gate.

Phase 1 prototypes must not be treated as approved production design until every unchecked
business item above is resolved or explicitly deferred by the product owner.

