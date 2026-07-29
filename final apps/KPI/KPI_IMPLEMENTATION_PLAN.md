# Finance KPI App 213 — Detailed UX Implementation Plan

**Status:** IN PROGRESS — Phase 0 started; production build waits for Phase 0 decisions and Phase 1 prototype sign-off  
**Target release:** 2.0.0  
**Architecture:** Oracle JET/Knockout SPA + ORDS + `DCT_KPI_PKG` + DCT Workflow Platform (DWP)  
**Related documents:** `KPI_PLAN.md`, `KPI_REDESIGN_PLAN.md`, `STATUS.md`, `docs/functions_list.md`

## 1. Objective

Rebuild the KPI frontend around the work performed by preparers, approvers, executives,
and KPI administrators while preserving the deployed KPI calculation engine, DWP process,
reporting infrastructure, shared authentication contract, and existing ORDS routes.

The release is successful when:

- a preparer can find and submit the current measurement unassisted in under 5 minutes;
- an approver can understand and decide a submission in under 2 minutes;
- an executive can answer “How are we doing on Cash?” in no more than 2 clicks;
- no primary workflow requires knowledge of matrices, bands, provenance, workflow instances,
  or internal KPI codes;
- every primary workflow works with keyboard only and in both English/LTR and Arabic/RTL;
- unit, API, browser, accessibility, workflow-regression, and business UAT gates pass.

## 2. Scope and guardrails

### 2.1 In scope

- Task-first Home page.
- Guided measurement wizard.
- Contextual approval-review page.
- Plain-language executive Scorecard.
- Per-KPI detail pages.
- Simplified Reports page.
- Admin-only KPI setup and calendar screens.
- Due dates, task aggregation, preparer assignment, and evidence-checklist support needed by
  the new experience.
- Semantic HTML, keyboard support, explicit error states, responsive layouts, and complete
  EN/AR localization.
- Feature-flagged migration from v1.2.0 to v2.0.0.

### 2.2 Preserved without redesign

- Existing nine `DCT_KPI_*` core tables and their historical data.
- KPI calculation methods and scoring semantics.
- `KPI_RESULT_APPROVAL` DWP execution and server-provided outcome vocabulary.
- `/wf/` worklist/action/history security model.
- Existing briefing-book execution infrastructure.
- Shared session, shell, module-access gate, notifications, audit, and document storage.

### 2.3 Non-negotiable technical rules

- Additive database and API changes only until cutover.
- No dynamic SQL in KPI suggestion or task aggregation logic.
- No hard-coded approval outcomes in the KPI UI; render `task.outcomes[]`.
- Do not duplicate shared shell, workflow, upload, toast, or i18n implementations.
- All labels and messages must be i18n keys; no new user-facing strings embedded in view models.
- Existing v1 routes remain available behind the feature flag until signed UAT and rollback
  validation are complete.

## 3. Experience and visual direction

Use a **calm executive finance workspace** aesthetic: restrained, precise, bilingual, and
trustworthy. Preserve the KPI gold identity but use it selectively for the primary action,
selected navigation, and meaningful score highlights. Supporting sections should use quiet
white surfaces instead of repeating gold gradient headers.

Design rules:

1. One primary action per screen.
2. Show the next required action before analysis or history.
3. Use questions and business language instead of column or framework terminology.
4. Reveal scoring rules, provenance detail, and workflow history only on demand.
5. Show deadlines as both dates and relative urgency, for example “Due 31 Jul · 3 days left”.
6. Pair every score with an interpretation such as “Above target” or “Needs attention”.
7. Hide administrative controls from preparers and approvers.
8. Use one SVG icon family; remove emoji and character icons from production controls.
9. Do not render empty charts. Use a helpful empty state and the next action instead.
10. Respect `prefers-reduced-motion`; transitions must never delay task completion.

## 4. Personas and target journeys

| Persona | Landing priority | Primary journey |
|---|---|---|
| Preparer | Due, draft, returned work | Home → Continue measurement → Figures/Assessment → Evidence → Review → Submit |
| Section Head / Finance Director | Waiting approvals | Home → Review submission → inspect evidence/history → choose server-provided outcome |
| Executive viewer | Current performance | Scorecard → KPI detail → trend/history |
| KPI administrator | Exceptions and setup | Home → Administration → calendar/definitions/assignments |

Target navigation:

- **Home** — role-aware action inbox.
- **Scorecard** — executive summary.
- **KPIs** — four business KPI pages and history.
- **Reports** — one-click briefing book and one-page scorecard.
- **Administration** — KPI admin only; definitions, calendar, evidence requirements, and
  assignments.

Notifications remain in the shared top-bar bell and are removed from primary side navigation.

## 5. Phase 0 — Business decisions and baseline

**Goal:** eliminate decisions that would otherwise force UI or schema rework.

### 5.1 Business workshop

1. Observe at least one preparer completing the current quarterly or annual process.
2. Observe one Section Head or Finance Director reviewing a real submission.
3. Record task sequence, required source documents, handoffs, recurring questions, and terms
   users do not understand.
4. Rank pain points as blocking, high-friction, or cosmetic.
5. Capture the current completion time and number of assisted steps as the UX baseline.

### 5.2 Decisions to document in `STATUS.md`

1. Confirm each KPI’s responsible preparer(s).
2. Confirm whether unstarted work is visible to:
   - designated KPI preparers only (**recommended**), or
   - every `KPI_USER`.
3. Confirm Section Head resolution: preparer’s line manager or a fixed role holder.
4. Name the actual `KPI_FIN_DIRECTOR` holder and remove the placeholder assignment.
5. Confirm annual and quarterly submission due dates for 2026 and 2027.
6. Confirm required and optional evidence types for every KPI.
7. Confirm whether missing required evidence blocks submission (**recommended**) or produces
   a warning.
8. Confirm Revenue Growth GL account scope.
9. Confirm scorecard weights and whether they must total exactly 100%.
10. Confirm KPI 4 cadence.
11. Confirm which roles may view all departments’ KPI results.

### 5.3 Bilingual glossary

Create `docs/KPI_GLOSSARY.md` containing the approved English and Arabic label for every
business concept. At minimum resolve:

- Measurement, Achievement, Target, Score, Due, Draft, Returned, Awaiting approval.
- “From GL” and “Entered manually”.
- Submit, Approve, Return, Reject, Evidence, Supporting document.
- Names, descriptions, figure questions, and score interpretations for all four KPIs.

### 5.4 Baseline and gate

- Record desktop and mobile screenshots of every current route.
- Run the current unit, API, and browser suites and archive results.
- Record current counts: PL/SQL 36/36, API 56/56, browser 20/20, and 0 invalid objects.
- **Exit gate:** business decisions, assignment matrix, evidence matrix, due-date matrix, and
  bilingual glossary signed off by the product owner.

## 6. Phase 1 — Clickable UX blueprint

**Goal:** validate information architecture before production code or schema changes.

### 6.1 Prototype screens

Build disposable, clickable prototypes using realistic data for:

1. Home with mixed due, draft, returned, and approval tasks.
2. Home zero-state for a new preparer.
3. Numeric measurement wizard.
4. Weighted-criteria measurement wizard.
5. Evidence checklist and upload state.
6. Review-and-submit state, including validation errors.
7. Approval review with evidence and dynamic outcomes.
8. Scorecard with complete data, partial data, and no data.
9. KPI detail page.
10. Reports and Administration/calendar pages.

### 6.2 Prototype states

Every prototype must include loading, empty, error, read-only, overdue, returned, and
completed states—not only the happy path. Produce desktop (1440 px), tablet (768 px), and
mobile (390 px) layouts in English and Arabic.

### 6.3 Usability script

Ask representative users to perform these tasks without coaching:

- Find the Cash Q2 measurement and continue it.
- Use the system figure, override one value, and explain the override.
- Attach the required document and submit.
- Review a returned submission and find the approver comment.
- Approve a submitted result after checking its evidence.
- Determine whether Cash is above target and improving.
- Generate the annual briefing book.

Record completion time, wrong turns, questions, and terminology issues. Iterate until the
target journeys are understood without explanation.

### 6.4 Gate

- Accessibility review of the prototype’s focus order and reading order.
- Product owner, preparer, approver, and executive representative approve the blueprint.
- **Exit gate:** signed screenshots/wireframes and an agreed component/state inventory.

## 7. Phase 2 — Additive data model and package groundwork

**Goal:** supply due dates, ownership, and evidence requirements without disturbing existing
results or workflow instances.

Create `db/08_kpi_ux2.sql` as a rerunnable additive deployment.

### 7.1 Due dates

1. Add nullable `due_date DATE` to `DCT_KPI_PERIODS`.
2. Backfill existing periods with the signed-off dates; use `end_date` only as an explicit
   temporary fallback.
3. Add a constraint ensuring `due_date >= start_date` when populated.
4. Update `ensure_periods` so new periods receive the configured default due date without
   overwriting an administrator’s edited date.
5. Repoint reminder logic to `due_date` for T-7, T-1, due-today, and overdue notifications.
6. Make reminder sends idempotent so the sweep cannot create duplicate notices for the same
   result/period/reminder stage.

### 7.2 KPI assignments

If Phase 0 confirms designated preparers, add `DCT_KPI_ASSIGNMENTS`:

- `assignment_id`, `kpi_id`, `user_id`, `assignment_role` (`PREPARER` initially),
  `effective_from`, `effective_to`, `is_active`, audit columns;
- unique active assignment rule for `kpi_id + user_id + assignment_role`;
- foreign keys to KPI definitions and users;
- indexes beginning with `user_id` and `kpi_id` for Home-task queries.

Do not change DWP participant resolution: approval continues to resolve from the actual
`prepared_by` user and configured Finance Director role.

### 7.3 Evidence checklist

Reuse the shared document model:

1. Seed KPI-specific rows in `DCT_DOCUMENT_TYPES` where a suitable shared type does not exist.
2. Seed `DCT_DOC_REQUIREMENTS` with `source_module='KPI_MGMT'` and
   `context_code=<KPI_CODE>`.
3. Change `DCT_KPI_PKG.add_evidence` to accept an optional `doc_req_id`, validate that it is
   active and belongs to the result’s KPI, then populate `DCT_DOCUMENTS.doc_req_id`,
   `doc_type_id`, and `is_required`.
4. Retain `KPI_EVIDENCE` as the “Other supporting document” fallback for optional uploads.
5. Enhance `submit_result` to identify missing mandatory requirements and return a stable,
   user-translatable error code plus missing requirement IDs.

### 7.4 Package and view changes

1. Extend period/result views with due date, relative task status inputs, and preparer name.
2. Add one Home-task view if it materially simplifies ORDS, for example
   `DCT_KPI_MY_TASK_V`; do not mix it with DWP eligibility logic.
3. Use `DCT_WF_INBOX_V WHERE user_id = :current_user_id` for approvals so the `/wf/`
   authorization contract remains authoritative.
4. Add package methods for administrator due-date and assignment updates.
5. Add unit cases for due-date boundaries, assignment visibility, evidence-requirement
   validation, reminder idempotency, and preservation of existing period dates.

### 7.5 Database gate

- Fresh install and upgrade-from-current both succeed.
- Re-running `db/08_kpi_ux2.sql` changes no data unexpectedly.
- Existing 36 unit tests remain green; new tests pass.
- `USER_ERRORS` and invalid-object checks return zero.
- Existing approved, submitted, returned, and draft results remain unchanged.

## 8. Phase 3 — Additive ORDS contracts

**Goal:** provide screen-oriented payloads and admin maintenance routes while retaining all
existing endpoints.

Add handlers rerunnably in `db/09_kpi_ux2_ords.sql`, or append through the established
`db/06_kpi_ords.sql` helper pattern and synchronize the install script.

### 8.1 `GET /kpi/mytasks`

Return the current user’s actionable Home payload in one request:

```json
{
  "asOf": "2026-07-28T10:30:00+04:00",
  "counts": { "due": 1, "drafts": 2, "returned": 1, "approvals": 1 },
  "due": [],
  "drafts": [],
  "returned": [],
  "approvals": []
}
```

Measurement task fields:

- `resultId` (nullable for unstarted work), `kpiId`, localized names, period ID/label;
- `dueDate`, `daysRemaining`, normalized urgency (`OVERDUE`, `DUE_SOON`, `UPCOMING`);
- status, completion summary, required evidence count, uploaded evidence count;
- one route/action descriptor (`START`, `CONTINUE`, `REVISE`, `VIEW`).

Approval items must be sourced from `DCT_WF_INBOX_V` and include the original worklist item,
including `outcomes[]`. Never reconstruct eligibility or outcome buttons in KPI SQL.

Rules:

- Unstarted items appear only for an assigned preparer, unless the approved Phase 0 fallback
  is “all KPI users”.
- Draft and returned items appear to their preparer plus KPI administrators.
- Approval items appear only when the current user has a materialized inbox row.
- Sort overdue first, then nearest due date, then KPI display order.

### 8.2 Result presentation contract

Additive enhancements to `GET /results/:id`:

- plain-language figure question labels;
- due date and target interpretation;
- requirement checklist with satisfied document metadata;
- next approval step/role display data where safely available;
- stable validation codes suitable for localized client messages.

Do not remove or rename existing fields.

### 8.3 Evidence upload contract

Extend `PUT /results/:id/docs` with optional `doc_req_id`. Reject a requirement belonging to
another KPI/result context. Return the saved requirement and document metadata.

### 8.4 Admin contracts

- `PUT /periods/:id` — update due date/status; KPI admin only.
- `GET /kpis/:id/assignments` — active and future assignments.
- `POST /kpis/:id/assignments` — replace/upsert the signed assignment set.
- `GET /kpis/:id/evidence-requirements` — configured checklist.
- `POST /kpis/:id/evidence-requirements` — replace/upsert requirements.

### 8.5 API security and tests

For every new handler test:

- 200 happy path;
- 400 malformed date/body/relationship;
- 401 missing or invalid session;
- 403 role or task-eligibility failure;
- 404 unknown record;
- boundary: no tasks, many tasks, overdue dates, nullable due date, inactive assignment,
  duplicate requirement, empty replacement set, and upload size/type limits.

Add cross-user tests proving one preparer cannot see another preparer’s unstarted tasks and
one approver cannot receive another user’s outcome set.

**Exit gate:** all existing 56 API cases plus new endpoint and security cases pass.

## 9. Phase 4 — SPA foundation, routing, and design system

**Goal:** create a stable v2 shell before building feature screens.

### 9.1 Feature flag and routes

1. Seed `FEATURE_KPI_UX_V2` in module settings, default `N` outside development.
2. Return the flag from `GET /kpi/boot`.
3. Add routes:
   - `home`
   - `scorecard`
   - `kpis`
   - `kpiDetail/:id`
   - `measurement/:id/step/:step`
   - `approval/:taskId`
   - `reports`
   - `adminKpis`, `adminKpi/:id`, `adminCalendar`, `adminAssignments`
4. Parse IDs from the hash so reload, copied links, notifications, and browser Back work.
5. Replace volatile `_state` as the only record identifier; retain it only for optional
   transient filters.
6. When the feature flag is off, continue routing to the v1.2.0 pages.

### 9.2 Client services

Extend `Jet/js/services/kpiService.js` with:

- `getMyTasks()`;
- due-date/calendar save methods;
- assignment and evidence-requirement methods;
- enhanced evidence upload with requirement ID.

Continue using `shared/wfService.js` for workflow actions and history.

### 9.3 Reusable KPI components

Create small Knockout components only where reused by two or more screens:

- `kpi-task-card`;
- `kpi-status-chip`;
- `kpi-score-summary`;
- `kpi-stepper`;
- `kpi-evidence-checklist`;
- `kpi-error-state`.

Each component must define loading/empty/error behavior, semantic element choice, keyboard
interaction, and EN/AR layout behavior.

### 9.4 CSS foundation

Refactor `Jet/css/app.css` into documented v2 sections without copying shared platform CSS:

- task layout and urgency tokens;
- score and status tokens with non-color indicators;
- wizard and sticky action footer;
- evidence drop zone;
- scorecard/KPI-detail layouts;
- responsive breakpoints;
- focus-visible and reduced-motion rules;
- print rules for the one-page scorecard if that output route is selected.

### 9.5 Global UI states

Every route view model exposes `loading`, `error`, and `retry`. Add an `aria-live="polite"`
status region for save/upload/submission feedback. Route-load failures must render an error
page with Retry and Home actions instead of only writing to the console.

**Exit gate:** feature-flag switching, deep linking, refresh, Back, EN/AR switching, error
recovery, and keyboard navigation pass before feature-screen development continues.

## 10. Phase 5 — Home implementation

**Files:** new `views/home.html`, `viewModels/home.js`; update `appController.js`, i18n files,
service and CSS.

### 10.1 Build steps

1. Load `/mytasks` once on entry and on explicit Refresh.
2. Lead with a short personalized heading and the most urgent task.
3. Render four role-aware sections:
   - Due now;
   - My drafts;
   - Returned to me;
   - Waiting for my approval.
4. Hide empty sections; do not display four zero counters.
5. For a completely empty Home, show the approved three-step onboarding and link to Scorecard.
6. Each card gets exactly one primary route action and an optional View details link.
7. Show overdue/due-soon language and required-document progress.
8. Send approval cards to the approval-review route, not to inline table buttons.
9. Add a compact admin exception summary for missing calendar dates, missing assignments,
   or invalid weight totals.
10. Refresh tasks after submission, return, approval, language switch, and browser focus if
    the cached payload is stale.

### 10.2 Home acceptance

- A preparer identifies the next task without opening another page.
- Returned work shows the return reason or a direct “View comment” route.
- An approver sees only tasks they may act upon.
- An executive without tasks sees a calm zero-state, not an empty operational dashboard.
- Mobile cards keep deadline, status, and primary action above the fold.

## 11. Phase 6 — Guided measurement wizard

**Files:** new `views/measurement.html`, `viewModels/measurement.js`, wizard/evidence components;
reuse result and document service calls.

### 11.1 Shared wizard behavior

1. Load result, KPI definition, score bands, evidence requirements, and documents.
2. Resolve the initial step from the route and redirect invalid/inaccessible steps.
3. Display `Step n of m`, completion state, and last-saved feedback.
4. Save a draft before Next; prevent moving forward after a failed save.
5. Register dirty state with `shared/formGuard`.
6. Allow Back without data loss.
7. Lock editing for submitted/approved results and present a read-only summary.
8. Preserve draft values across reloads through server saves, not only browser storage.

### 11.2 Step 1A — Numeric figures

1. Present each figure as a plain-language question.
2. Show unit and formatting adjacent to the input.
3. Present the system suggestion in a separate callout with source name and refresh time.
4. Provide “Use system figure” as a real button.
5. When the entered value differs from the suggestion, reveal and require the override reason
   if the business confirms that rule.
6. Validate finite numeric values, permitted sign/range, and required fields before Next.
7. Move formula and band details behind an accessible “How this is scored” disclosure.

### 11.3 Step 1B — Weighted assessment

1. Show one criterion at a time or a short vertical list based on prototype results.
2. Present level descriptions as semantic radio options, not clickable `<div>` elements.
3. Show weight as secondary context.
4. Require justification according to the signed business rule.
5. Show “4 of 4 criteria complete”; do not foreground contribution calculations.

### 11.4 Step 2 — Evidence

1. Render the checklist from the API, with Required/Optional and Satisfied/Missing status.
2. Support drag-drop, Browse, upload progress, cancel where supported, retry, download, and
   delete while editable.
3. Validate allowed MIME types, extension consistency, zero-byte files, and maximum size on
   both client and server.
4. Retain raw-binary upload; do not introduce base64 payloads.
5. Allow “Other supporting document” uploads independently of checklist requirements.

### 11.5 Step 3 — Review and submit

1. Show Achievement, score in words, target comparison, and prior-period comparison.
2. Summarize figures/criteria, source, explanations, and evidence completeness.
3. Display the next approver in business language when it can be determined accurately;
   otherwise show the configured approval stages without promising a named user.
4. Offer Edit links back to prior steps.
5. Keep one primary Submit button.
6. Replace the native confirm dialog with an accessible confirmation dialog summarizing that
   editing will be locked.
7. On success, route to a submission receipt showing reference, timestamp, and expected next
   step, then update Home.
8. On server validation failure, map stable codes to localized messages and link directly to
   the step needing correction.

### 11.6 Wizard acceptance

- Both numeric and rubric KPIs can be completed with keyboard only.
- Draft saves survive refresh and browser restart.
- Required evidence and missing criteria cannot be bypassed.
- Repeated Submit clicks create only one workflow instance.
- A normal preparer flow meets the under-5-minute usability target.

## 12. Phase 7 — Approval review

**Files:** new `views/approvalReview.html`, `viewModels/approvalReview.js`; reuse
`wf-action-bar`, `wf-timeline`, and `shared/wfService.js`.

### 12.1 Build steps

1. Load the selected task from the authoritative worklist and reject direct access if it is no
   longer actionable by the current user.
2. Load the linked KPI result and evidence.
3. Present a concise decision summary: achievement, score interpretation, target, prior
   period, due/submitted dates, and preparer.
4. Show figures and provenance in plain language; expose system-versus-manual detail without
   making it the page headline.
5. Show preparer notes and criterion justifications.
6. Support evidence preview where browser-safe and authenticated download otherwise.
7. Show workflow timeline collapsed below the decision content.
8. Render the shared `wf-action-bar` with the task’s server-provided outcomes.
9. Preserve shared/server comment rules; Return and Reject must require comments when declared
   by the outcome metadata.
10. After a successful action, show a receipt and return to Home with refreshed tasks.
11. If another approver has already acted, show “This task is no longer available” and refresh
    rather than treating it as a generic failure.

### 12.2 Approval acceptance

- No action is possible without eligibility from `/wf/worklist`.
- No approval verb is hard-coded in the KPI view model or template.
- Approver can inspect all decision-critical information without leaving the screen.
- Return comment becomes visible from the preparer’s Home and wizard.
- Typical review meets the under-2-minute usability target.

## 13. Phase 8 — Scorecard, KPI pages, reports, and administration

### 13.1 Scorecard

1. Make Scorecard a separate executive route, not the preparer landing page.
2. Lead with a plain-language overall interpretation and data coverage.
3. Show four KPI cards with current score, target comparison, previous-year comparison, trend,
   and completeness.
4. Make cards semantic links to KPI detail pages.
5. Show approved values as the official score and clearly distinguish incomplete years.
6. Do not render a chart when fewer than two meaningful data points exist.
7. Add “Last refreshed” and selected year.

### 13.2 KPI detail page

1. Explain what the KPI measures in approved business language.
2. Show current-year periods as a simple status list with due date and action.
3. Show achievement/target trend and approved history.
4. Provide evidence and approval history for completed periods.
5. Keep formulas and score bands behind “How this KPI is scored”.
6. Show KPI code only as secondary reference metadata.

### 13.3 Reports

1. Default to the current year.
2. Present the Briefing Book as one primary action.
3. Preserve enqueue, poll, ready, failed, retry, and authenticated download states.
4. Add a one-page scorecard output using the choice approved in Phase 1:
   - reporting definition/template for controlled PDF output (**preferred**), or
   - print CSS for an immediate browser print view.
5. Add generated-at, report year, status, and last download information.

### 13.4 Administration

Separate tasks into focused screens rather than one long editor:

- KPI basics and bilingual content.
- Targets and scoring.
- Criteria and maturity descriptions.
- Evidence requirements.
- Calendar and due dates.
- Assigned preparers.

Add inline validation for duplicate codes, invalid band coverage, criteria weight total,
scorecard weight total, missing Arabic text, past due dates, and assignments to inactive users.
Keep soft deactivation and show the impact before confirming.

**Exit gate:** executive answers the Cash question in two clicks; administrator can configure
a new year without database assistance; reports succeed for complete and partial years.

## 14. Phase 9 — Accessibility, localization, resilience, and performance

### 14.1 Accessibility checklist

- Use `<button>`, `<a>`, native inputs, fieldsets, legends, and tables appropriately.
- No primary interaction on a non-focusable `<div>`.
- Add `aria-expanded`/`aria-controls` to disclosures.
- Associate every label, help message, and error with its control.
- Maintain a logical heading hierarchy and landmark structure.
- Provide visible `:focus-visible` treatment meeting contrast requirements.
- Ensure all target sizes are at least 44×44 CSS pixels where practical.
- Never communicate urgency, score, completion, or validation by color alone.
- Announce saves, uploads, validation summaries, and route errors through live regions.
- Move focus to the route heading, dialog heading, or validation summary after state changes.
- Provide chart text/table equivalents.
- Verify 200% zoom, high contrast, reduced motion, and keyboard-only use.

### 14.2 Arabic/RTL checklist

- Translate every new key before route completion.
- Use logical CSS properties (`margin-inline-*`, `padding-block-*`) throughout.
- Mirror directional icons while keeping numbers and dates readable.
- Use Latin digits where required by the platform rule.
- Validate Arabic truncation, line height, date phrasing, and screen-reader order.
- Test mixed Arabic/English KPI codes, filenames, currencies, and user names.

### 14.3 Resilience

Every route implements distinct loading, empty, error, permission-denied, session-expired,
stale-task, and success states. Errors include a plain explanation, Retry, and a safe route.
Silent `.catch(function () {})` patterns are not permitted in new KPI v2 screens.

### 14.4 Performance budgets

- Home uses one KPI task request plus existing shell calls.
- Avoid repeated definition/band fetches during a wizard session; cache per route lifetime.
- Do not load chart code until the Scorecard route requires it.
- Avoid polling except for active report generation.
- Target interactive Home rendering within 2 seconds on the production web tier under normal
  API latency; record actual timings during UAT.

## 15. Phase 10 — Test strategy

### 15.1 PL/SQL

Add tests for:

- due-date creation, edit, backfill, and boundary validation;
- task ownership and effective-date boundaries;
- required evidence completion and wrong-context requirement rejection;
- manual override rules;
- repeat submission idempotency;
- reminder idempotency and overdue transitions;
- preservation of all existing score boundary tests.

### 15.2 API

Extend `tests/test_kpi_api.py` for every new route and role boundary. Use separate tokens for
two preparers, KPI admin, Section Head, Finance Director, and unauthorized user where feasible.
Keep synthetic years and isolate generated test data.

### 15.3 Browser/E2E

Replace route-presence checks with task completion scenarios:

1. Preparer starts and submits numeric KPI with system suggestion.
2. Preparer overrides a suggestion and supplies justification.
3. Preparer completes rubric KPI and required evidence.
4. Missing evidence routes the user back to Evidence.
5. Section Head returns with comment; preparer revises and resubmits.
6. Section Head and Finance Director approve; Scorecard updates.
7. Report runs, polls, and downloads.
8. Admin edits due date, assignment, target, and evidence requirement.
9. Deep link/reload/Back behavior.
10. EN/LTR and AR/RTL at desktop and mobile widths.

### 15.4 Accessibility automation and manual testing

- Add axe-core checks for every core route and dialog with zero serious/critical violations.
- Add keyboard scripts for Home, wizard, evidence, approval outcomes, and admin calendar.
- Manually test with at least one screen reader available to the team.
- Document unavoidable third-party JET/shared-component findings separately; do not suppress
  KPI-owned violations.

### 15.5 Regression

- Existing `/kpi/` routes remain byte/field compatible where documented.
- `/wf/worklist` continues to work for other modules.
- Shared components are changed only with fleet-wide regression tests.
- APP_VERSION cache behavior and shared shell module switching remain correct.
- Database install ends with zero invalid objects.

## 16. Phase 11 — Business UAT and training

Create UAT round 2 from real role-based journeys rather than route checks.

1. Prepare realistic 2026 data and named user accounts.
2. Give testers only the quick-reference guide; do not coach during measured scenarios.
3. Capture completion time, assistance required, errors, confidence rating, and comments.
4. Require evidence screenshots for every UAT case.
5. Classify defects:
   - P0: security/data corruption;
   - P1: cannot complete primary journey;
   - P2: high friction or misleading result;
   - P3: cosmetic.
6. Re-demo any P1/P2 correction to the user who raised it.
7. Create bilingual quick-reference guides for preparer, approver, and administrator.

UAT exit criteria:

- 100% P0/P1 cases pass;
- no open P2 issue accepted without product-owner sign-off;
- timed UX targets met by representative users;
- EN and AR signed off;
- security and accessibility gates pass;
- product owner signs the cutover decision.

## 17. Phase 12 — Deployment, rollout, and rollback

### 17.1 Deployment sequence

1. Take pre-deployment object-status and row-count snapshots.
2. Deploy `db/08_kpi_ux2.sql`.
3. Recompile and confirm zero invalid objects.
4. Run PL/SQL tests.
5. Deploy new ORDS handlers in a fresh SQLcl session.
6. Run API tests, including old endpoints.
7. Deploy frontend with `FEATURE_KPI_UX_V2=N`.
8. Smoke-test v1 and direct v2 routes as an authorized test user.
9. Enable the flag for KPI admins/pilot users if per-user targeting is supported; otherwise use
   a short controlled pilot window.
10. Complete production pilot scenarios in EN and AR.
11. Enable v2 for all KPI users.
12. Bump `APP_VERSION` to `2.0.0`, deploy through `webtier/deploy_frontend.sh`, and verify cache
    invalidation.
13. Monitor task counts, ORDS errors, report failures, and workflow actions during the first
    business cycle.

### 17.2 Rollback

- Primary rollback is configuration-only: set `FEATURE_KPI_UX_V2=N` to restore v1 routes.
- Do not drop additive columns, assignments, due dates, or evidence mappings during rollback.
- Existing v1 routes and payloads remain operational for at least one completed KPI cycle.
- If an ORDS additive handler is defective, disable/redefine only that template; do not rerun
  broad modules unrelated to KPI.
- If reminders malfunction, disable the KPI reminder job without disabling measurement entry
  or workflow actions.
- Document the exact flag value, job state, frontend release symlink, and DB scripts used for
  every rollback rehearsal.

### 17.3 Retirement

After one successful complete KPI cycle and written product-owner approval:

1. Remove v1 navigation entries and obsolete routes.
2. Retire unused v1 templates/view models and i18n keys.
3. Keep API compatibility unless a separately approved deprecation is issued.
4. Remove the temporary feature flag only after rollback is no longer required.
5. Update `STATUS.md`, `docs/functions_list.md`, deployment notes, and training guides.

## 18. File-level work list

### Database and ORDS

- `db/08_kpi_ux2.sql` — due dates, assignments, evidence requirements, views/package changes.
- `db/09_kpi_ux2_ords.sql` — Home, calendar, assignments, and requirements handlers.
- `db/07_kpi_jobs.sql` — due-date reminder behavior and idempotency.
- `db/install.sql` — append scripts in correct order.
- `db/test/kpi_smoke_test.sql` — new package/business-rule cases.
- `tests/test_kpi_api.py` — new route/security/boundary cases.

### Frontend

- `Jet/js/appController.js` — feature flag, new navigation, parameterized routes, route errors.
- `Jet/js/services/kpiService.js` — additive v2 client methods.
- `Jet/js/views/home.html` + `viewModels/home.js`.
- `Jet/js/views/measurement.html` + `viewModels/measurement.js`.
- `Jet/js/views/approvalReview.html` + `viewModels/approvalReview.js`.
- `Jet/js/views/scorecard.html` + `viewModels/scorecard.js`.
- `Jet/js/views/kpiDetail.html` + `viewModels/kpiDetail.js`.
- Admin calendar/assignment/requirement views and view models.
- `Jet/js/components/` — KPI-only reusable components.
- `Jet/js/i18n/app.en.json` and `app.ar.json` — glossary-aligned keys.
- `Jet/css/app.css` — v2 component, responsive, accessibility, and optional print rules.
- `Jet/index.html` — APP_VERSION only at release; avoid unrelated shared-shell changes.
- `tests/browser_smoke.py` — route smoke retained but updated for v2.
- New Playwright workflow/accessibility suite if keeping smoke tests compact.

### Reporting and documentation

- `reporting/runner/templates/kpi_briefing_book.html.j2` — language/visual refresh.
- New one-page scorecard definition/template if selected.
- `docs/KPI_GLOSSARY.md`.
- `docs/functions_list.md`.
- `docs/deployment-notes.md`.
- `STATUS.md`.
- UAT workbook, evidence folder, and bilingual quick-reference guides.

## 19. Recommended delivery slices and effort

Indicative effort assumes one engineer with timely business access; it is a planning range,
not a commitment.

| Slice | Deliverable | Estimate |
|---|---|---:|
| Discovery | Decisions, glossary, baseline | 2–4 working days |
| Blueprint | Clickable prototypes and 2–3 review rounds | 4–7 days |
| Data/API | Due dates, assignments, evidence, `/mytasks`, tests | 5–8 days |
| SPA foundation | Routing, flag, components, error/accessibility foundation | 3–5 days |
| Home + wizard | Core preparer journey | 7–10 days |
| Approvals | Contextual review and workflow integration | 3–5 days |
| Scorecard/KPI/report/admin | Remaining production screens | 6–9 days |
| Hardening/UAT/cutover | E2E, accessibility, UAT, docs, deployment | 5–8 days |

Expected total: **35–56 engineer-days**, with calendar time driven mainly by prototype and
business sign-off cycles. Do not compress the schedule by skipping Phase 0 or Phase 1; reduce
secondary administration/report enhancements first if a smaller first release is required.

## 20. Definition of done

Release 2.0.0 is done only when:

- all Phase 0 business decisions are reflected in configuration and documentation;
- signed prototypes match the implemented primary flows;
- the feature flag and rollback procedure are tested in production-like conditions;
- all new endpoints have role, record-level, and negative security tests;
- existing calculation and workflow behavior is unchanged except for approved additions;
- timed preparer, approver, and executive usability targets pass;
- EN/LTR and AR/RTL functional UAT pass;
- keyboard testing and accessibility automation pass;
- briefing book and one-page scorecard are accepted;
- zero invalid database objects remain after deployment;
- `STATUS.md`, functions list, deployment notes, and user guides are current;
- the product owner signs the production cutover.
