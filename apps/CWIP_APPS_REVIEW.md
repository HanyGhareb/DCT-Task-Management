# CWIP Applications — Business, Data and Reimplementation Review

## 1. Purpose and evidence

This document reviews the following Oracle APEX applications:

| Application | APEX ID | Export | Business role |
|---|---:|---|---|
| CWIP Payments Management | 130 | `apps/cwip-payments/f130.zip` | Internal project, contract and payment-certificate administration and approval |
| CWIP Payment - Ex | 109 | `apps/cwip-payment-ex/f109.zip` | External contractor/consultant portal for preparing and tracking payment recommendations |
| CWIP Change Management | 142 | `apps/cwip-change-mgmt/f142.zip` | Contract change control from variation identification through approved variation order |

The review is based on the split APEX exports dated 25 March 2024 and the older payment package sources under `apps/cwip-payments/docs`, including the 22 January 2022 backup. No live database data dictionary, table DDL, constraints, triggers, or source for the change-management workflow packages was supplied. Consequently:

- A table or view listed below is **observed** when it is referenced by an APEX component or supplied package.
- Columns are documented only when visible in page sources or package SQL.
- Relationships without DDL are **inferred**, not asserted as physical foreign keys.
- Package behavior is described in detail only where source exists. Other package behavior is inferred from calls and page actions.

This is a static design review, not a live APEX import or database compilation test.

## 2. End-to-end business landscape

The three applications implement one connected capital-works lifecycle:

```text
Project / contract / team setup (App 130)
                  |
                  +--> Contract change control (App 142)
                  |      VR -> BM -> PACOF -> VO
                  |                         |
                  |                         +--> revised contract value/time
                  |
External payment preparation (App 109)
                  |
                  +--> Internal payment review and approval (App 130)
                         recommendation -> staged approval -> final decision
                         documents/comments/more-info/delegation/reminders
```

Shared identity and reference objects include employees, external users, projects, contracts, project roles, project teams, organizations, vendors and lookup values. App 109 owns the external-user experience; apps 130 and 142 are primarily internal-user applications.

## 3. App 130 — CWIP Payments Management

### 3.1 Business purpose and actors

App 130 is the internal operational hub. It maintains the project/contract context required by both payment and change processes and controls payment recommendation review.

Observed or implied actors are:

- CWIP/project administrators: configure roles, teams, users, projects, locations, contracts, vendors and securities.
- External consultants/contractors: represented by `DCT_EXT_USERS`; invited and granted project/contract access.
- Project delivery roles: PMC, cost consultant, lead consultant, project manager, senior project manager, general project manager, document controllers and reviewers.
- PME/TPC leadership and technical reviewers.
- Finance reviewers/approvers.
- Delegates and information providers.

Role routing is data-driven through `PROJECT_ROLE`, `PROJECT_ROLE_CATEGORY` and `CWIP_TEAM`, but the supplied workflow body also embeds numeric role IDs, creating a fragile dependency on seed data.

### 3.2 Business processes

#### A. Project and contract administration

1. Maintain project records and project attributes, including status, location, assets, progress, budget package and cost adjustments (pages 20–23 and 59–67).
2. Define role categories and project roles (pages 2, 3 and 54).
3. assign internal and external people to the project team with effective dates and active status (pages 4, 22 and 23).
4. Maintain contract details and link contracts to projects (pages 24 and 35).
5. Maintain contract documents, invoices, end users, vendor/bank details and contractual securities (pages 33–35, 49, 66, 70 and 71).
6. Invite external users and stakeholders, then grant project and contract access (pages 5, 6, 10–13 and 44–48).

The project-team setup is a prerequisite for workflow submission: the payment package resolves approvers from active `CWIP_TEAM` assignments within their effective dates.

#### B. Payment recommendation preparation

1. A payment recommendation is created for a contract (page 68; older detail/action pages are also present).
2. Supporting documents and comments are attached (pages 17, 18 and 69).
3. Amounts and contract context are obtained from the recommendation, invoices, contract/project and vendor objects.
4. The recommendation can remain draft, be previewed (page 29), and be listed/reported (pages 30, 41 and 43).
5. The submitter invokes `CWIP_REC_PAYMENT_WORKFLOW.SUBMIT`.

#### C. Payment recommendation workflow

The supplied 2024-era body shows this state model:

- Header (`CWIP_PAYMENT_RECOMMENDATION.APPROVAL_STATUS`): Draft/initial state → `In-Progress`; terminal or exceptional values include `Approved`, `Rejected`, `Returned`, `Stopped` and `Hold`.
- Work item (`CWIP_PAYMENT_REC_APPROVAL_HISTORY.STATUS`): `Submitted`, `Pending`, `Approved`, `Rejected`, `Returned`, `Beaten`, `Delegated`, `More Info`, `Replied`, `Hold`, `Notified` and `Stopped`.
- Work-item actions include `Recommend/Return`, `Forward/Return` and `Approve/Reject`.

The workflow operates as follows:

1. Validate that required active team roles exist for the recommendation's contract/project.
2. Insert the submitter into approval history and mark the recommendation `In-Progress`.
3. Build the route from project/team assignments. The current supplied body contains route builders for project manager, PME reviewer, PME site reviewer, project document controller, senior project manager, PME HQ document controller, general project manager, PME director, TPC user/director/reviewers/technical support, PMC, cost consultant, lead consultant and finance/reviewer.
4. Activate one step by setting its history rows to `Pending` and recording the received timestamp. Multiple people may exist at a step.
5. An approver can approve/recommend/forward, reject/return, delegate, request more information, hold, or stop the process (pages 15, 19, 25–28, 38–40, 51–58).
6. When one parallel assignee completes the step, remaining pending rows may be marked `Beaten` (the legacy term for no-longer-actionable sibling assignments).
7. Approval activates the next applicable step; final approval updates the header and expires remaining actions.
8. Rejection versus return is determined from the current action type. A return sends the business document back for correction; a final rejection closes it.
9. Delegation expires/relabels the original task and creates a pending task for the delegate.
10. More-information requests create records in `CWIP_PAYMENT_REC_MORE_INFO`; replies reactivate workflow activity.
11. Hold changes the header to `Hold`; later activity can return it to `In-Progress`.
12. Notifications, reminders and outcome emails are sent; approval-report templates can include signatures.

The exact route is conditional and has changed since 2022. The backup package lacks some of the newer PME review/document-controller stages. This must be treated as version drift, not as two simultaneously valid specifications.

#### D. Supporting processes

- Signature capture and signed payment recommendation output (pages 36–37; APEX Signature plug-in and report layouts).
- OTP/direct-action express approval (pages 38–40 and 57–58).
- Document library and notification history (pages 31–32).
- Reminder administration and email/job/activity reporting (pages 53, 55 and standard administration pages).

### 3.3 Observed data model

#### Core transaction tables

| Object | Type | Purpose / important observed columns |
|---|---|---|
| `CWIP_PAYMENT_RECOMMENDATION` | Table | Payment header. Key `PAYMENT_RECOMMENDATION_ID`; contract reference; recommendation date; approval status; submitted/final decision metadata. |
| `CWIP_PAYMENT_REC_APPROVAL_HISTORY` | Table | Workflow task/audit rows. Recommendation ID, step number, person/type, role, action required, received/action dates, status, comments, delegation/on-behalf indicators, approval type/code, email and notification status. |
| `CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS` | Table | Recommendation BLOB attachments and metadata. |
| `CWIP_PAYMENT_RECOMMENDATION_COMMENTS` | Table | Threaded/business comments for a recommendation. |
| `CWIP_PAYMENT_REC_MORE_INFO` | Table | Information requests and replies between workflow participants. |
| `CWIP_PAYMENT_REC_REMINDERS` | Table | Pending-action reminder configuration/history. |
| `CWIP_CONTRACT_INVOICES` | Table | Contract invoice/payment evidence used by recommendations. |
| `CWIP_PAYMENTS_CONFIGURATION` | Table | Payment rules/configuration. |
| `CWIP_PAYMENT_RECOMMENDATION_V` | View | Denormalized recommendation reporting/display source. |

#### Project and contract tables/views

| Object | Type | Purpose |
|---|---|---|
| `PROJECT` | Table | Project master. |
| `PROJECT_ROLE_CATEGORY` / `PROJECT_ROLE` | Tables | Workflow and team role taxonomy. |
| `CWIP_TEAM` | Table | Person-to-project role assignment with person type, status and effective dates. |
| `CWIP_CONTRACT` | Table | Contract master and financial/schedule attributes. |
| `CWIP_CONTRACT_PROJECTS` | Table | Contract-to-project bridge. |
| `CWIP_CONTRACTS_V` | View | Enriched contract display/reporting view. |
| `CWIP_CONTRACT_DOCUMENTS` / `CWIP_DOCUMENTS` | Tables | Contract/project document storage. |
| `CWIP_CONTRACT_END_USERS` | Table | Authorized/assigned contract end users. |
| `CWIP_CONTRACT_CONTRACTUAL_SECURITIES` | Table | Contract-to-security association. |
| `CWIP_CONTRACTUAL_SECURITIES_LIST` | Table or view | Security instrument catalog/list. Exact type requires dictionary confirmation. |
| `CWIP_PROJECT_STATUS_LOOKUP`, `CWIP_PROJECT_LOCATIONS` | Tables | Project classifications. |
| `CWIP_PROJECT_PROGRESS`, `CWIP_PROJECT_COST_ADJUSTMENT`, `CWIP_PROJECT_BUDGET_SPLIT`, `CWIP_PROJECT_ASSETS` | Tables | Project controls and financial/progress detail. |

#### Shared people, supplier and reference objects

`DCT_EXT_USERS`, `EMPLOYEES_V`, `DCT_EMPLOYEES_LIST2`, `DCT_EMPLOYEES_LOOKUPS`, `DCT_EMPLOYEES_SIGNATURES`, `DCT_HR_ORGANIZATIONS`, `ORGANIZATIONS_V`, `DCT_LOOKUPS`, `DCT_LOOKUP_VALUES`, `CWIP_LOOKUP_VALUES`, `VENDORS`, `VENDOR_CONTACTS`, `VENDORS_BANK_ACCOUNTS`, `FA_ASSETS` and `HRSS_CONFIGURATIONS` are observed dependencies.

#### Packages

| Package | Responsibility | Evidence |
|---|---|---|
| `CWIP_REC_PAYMENT_WORKFLOW` | Submit, route, approve/reject/return, stop, delegate, request/reply to information, hold and validate | Supplied bodies plus APEX calls |
| `CWIP_REC_PAYMENT_EMAILS` | Action-required, comment, reminder, confirmation and result email generation | 2022 spec/body and APEX calls |
| `CWIP_REC_PAYMENT_UTIL` | Workflow dates/durations and contract variation calculation | APEX calls |
| `CWIP_REC_PAYMENT_EXT_APP` | Validate external/direct-action requests | APEX call |
| `DCT_UTIL` | OTP, number spelling and application email-test settings | APEX calls |
| `USER_DETAILS` | Employee display/email lookup | Package and APEX calls |
| `EXT_USERS` | External authentication/user services | App 109 authentication and pages |

Inferred principal relationships are: project 1:M contract-project M:1 contract; project 1:M team; contract 1:M payment recommendation; recommendation 1:M documents/comments/more-info/reminders/approval-history; person and role references from team and approval history.

### 3.4 Verified review findings

- The supplied `CWIP_REC_PAYMENT_WORKFLOW.pls` is a package **body**, despite its filename. `CWIP_REC_PAYMENT_WORKFLOW-body` is another, shorter body. They differ materially. There is no current package specification alongside them.
- In the longer body's `VALIDATE_PAYMENT_REC`, `l_error_message` is commented out but subsequently assigned. Unless a package/global declaration exists outside the supplied text, this body cannot compile.
- The General Project Manager validation checks `l_contract_manager_count` instead of `l_general_project_manager_count`.
- Numeric role IDs are embedded throughout routing logic, tying behavior to mutable lookup data.
- Workflow state, work assignment and immutable audit history are combined in one table, causing terms such as `Beaten` and `Expired` to carry technical rather than business meaning.
- APEX pages call workflow/email packages directly and repeat action orchestration across normal, express and external pages.
- Both `NATIVE_APEX_ACCOUNTS` and a scheme named `DCT` are present; the selected `DCT` scheme is also APEX Accounts and redirects logout to app 100. This is not a modern shared identity/session architecture.
- Direct-action/OTP pages and external links expand the security surface. Token hashing, expiry, single use, binding to action/document/user and audit behavior cannot be proven from the export.
- The export contains duplicate/backup-style pages (for example express direct action and its backup), duplicated navigation entries, and extensive generated administration pages that obscure the core application surface.

## 4. App 109 — CWIP Payment - Ex

### 4.1 Business purpose and actors

App 109 is a reduced external portal over the same payment schema. It authenticates with custom function `EXT_USERS.AUTHENTICATE_EXT_USER`, shows only contracts granted to the external identity, and lets that user prepare and follow payment recommendations.

### 4.2 Business processes

1. Authenticate an external user and resolve their `DCT_EXT_USERS` identity/profile.
2. List accessible contracts and open contract details (pages 2, 3 and 12). Access is derived from external-user/project/contract grants and `CWIP_TEAM`/contract-project associations.
3. Create or edit a payment recommendation for the selected contract (page 4).
4. Upload supporting recommendation documents and add comments (pages 5–6).
5. Submit through the same `CWIP_REC_PAYMENT_WORKFLOW.SUBMIT` package.
6. View “My Payment Recommendations” and interim payment certificates (pages 7 and 30).
7. Respond to more-information requests (page 28).
8. Where assigned an actionable step, approve/reject through page 8 using the same workflow package.
9. Maintain profile/password and create service requests (pages 9–11).
10. Trigger internal/action-required email communication (page 13).

The portal therefore does not own a second payment process; it is another channel over App 130's payment objects and workflow.

### 4.3 Data model and packages

App 109 uses the same core objects as App 130: `CWIP_CONTRACT`, `CWIP_CONTRACT_PROJECTS`, `CWIP_CONTRACTS_V`, `CWIP_CONTRACT_INVOICES`, `CWIP_PAYMENT_RECOMMENDATION`, `CWIP_PAYMENT_RECOMMENDATION_V`, recommendation documents/comments, approval history, more-info, configuration, `CWIP_TEAM`, roles, employees, vendors and lookups. Its portal-specific dependency is `DCT_EXT_USERS` plus the project/contract access structures maintained in App 130.

Observed package calls are `CWIP_REC_PAYMENT_WORKFLOW` (submit, approve, reject, stop and more-info reply), `CWIP_REC_PAYMENT_EMAILS`, `DCT_UTIL` and the `EXT_USERS` authentication package/function.

### 4.4 Review findings

- Authorization is split between page SQL filters, external-user grants and workflow package checks. Every read and mutation needs server-side object-level authorization; page filtering alone is insufficient.
- The portal duplicates internal payment form, document, comment and action behavior, increasing drift risk.
- Custom password handling cannot be assessed without the `EXT_USERS` package. Password hashes, lockout, reset-token handling, MFA and session invalidation require verification before reuse.
- The export still includes generic APEX administration/activity/feedback pages not central to the external business journey.

## 5. App 142 — CWIP Change Management

### 5.1 Business purpose and lifecycle

App 142 governs contract change through four linked document types:

1. **VR — Variation Request:** register a potential scope/cost/time change, its reason, estimate basis, funding source, documents and initial assessment.
2. **BM — Benchmark/Business Memo request:** evaluate a selected set of VRs using configured evaluation methods and supporting documents.
3. **PACOF/BACOF:** prepare the approval/committee form from BM and VR information and attach supporting forms. The export uses both spellings: UI objects/pages say PACOF while database/package objects say `BACOF`; this is a material naming inconsistency.
4. **VO — Variation Order:** formalize the approved contract change, cost items, value and schedule effects; calculate revised agreement value and approved VO totals.

The observed relationship is many-to-many between BM and VR through `BM_VR_REQUESTS`, and between BACOF/PACOF and VR through `BACOF_VR_REQUESTS`. A VO is linked to a contract and appears to consume the approved upstream change record(s), although the exact FK is not visible in supplied DDL.

### 5.2 Business processes

#### A. Reference setup

Administrators maintain VR change reasons, estimate bases, funding sources and BM evaluation methods (pages 4–9 and 13–14). These use `DCT_LOOKUPS_EXTENDED` and `DCT_LOOKUP_VALUES`.

#### B. Variation Request

1. Create/edit the VR and associate project/contract data (pages 2–3).
2. Capture change reason, estimate basis, funding source, amount/schedule information and attachments (page 10).
3. Submit through `VR_WORKFLOW2.SUBMIT`/the VR submission UI (page 11).
4. Approvers act through common or VR-specific approval pages (pages 29–30).

#### C. BM

1. Create a BM request (pages 15–16).
2. Associate one or more VRs (`BM_VR_REQUESTS`, page 17), select evaluation method and attach documents (page 18).
3. Submit via `BM_WORKFLOW.SUBMIT` (page 26).
4. Approve, reject, return, delegate, stop/withdraw or cancel via pages 30–31.

#### D. PACOF/BACOF

1. Create the committee/approval form (pages 19–20).
2. Attach BM/VR forms and documents (pages 21–22; `BACOF_VR_REQUESTS`).
3. Submit via `BACOF_WORKFLOW.SUBMIT` (page 27).
4. Complete the common action set through pages 30 and 32.

#### E. Variation Order

1. Create the VO from project/contract/change context (pages 23–24).
2. Capture contract baseline, change description, payment method, schedule impact, revised completion date and value.
3. Maintain itemized cost summary (`VO_REQUESTS_COST_SUMMARY`, page 25).
4. Compute approved VO count/value and revised contract value using `CONTRACT_UTIL` and `VO_UTIL`.
5. Submit via `VO_WORKFLOW.SUBMIT` (page 28) and act through pages 30 and 33.

Across VR, BM, BACOF and VO, the common page 30 dispatches by request type to `APPROVE`, `REJECT`, `DELEGATE`, `RETURN`, `STOP` and `CANCEL`. Rejection, return, delegation and withdrawal require comments/person selection in the UI.

### 5.3 Observed data model

| Object | Type | Purpose |
|---|---|---|
| `VR_REQUESTS` | Table | Variation request header |
| `VR_REQUESTS_DOCUMENTS` | Table | VR BLOB attachments |
| `VR_REQUESTS_APPROVAL_HISTORY` | Table | VR workflow/action history |
| `BM_REQUESTS` | Table | BM header |
| `BM_VR_REQUESTS` | Bridge table | BM-to-VR association |
| `BM_REQUESTS_DOCUMENTS` | Table | BM attachments |
| `BM_REQUESTS_APPROVAL_HISTORY` | Table | BM workflow/action history |
| `BACOF_REQUESTS` | Table | PACOF/BACOF header |
| `BACOF_VR_REQUESTS` | Bridge table | BACOF-to-VR association |
| `BACOF_REQUESTS_DOCUMENTS` | Table | BACOF attachments/attached forms |
| `BACOF_REQUESTS_APPROVAL_HISTORY` | Table | BACOF workflow/action history |
| `VO_REQUESTS` | Table | Variation order header, contract/value/schedule and decision metadata |
| `VO_REQUESTS_COST_SUMMARY` | Table | Itemized VO cost lines |
| `VO_REQUESTS_APPROVAL_HISTORY` | Table | VO workflow/action history |
| `DCT_LOOKUPS_EXTENDED`, `DCT_LOOKUP_VALUES` | Tables/views | Change reasons, estimate bases, funding sources and evaluation methods |

Shared dependencies are `PROJECT`, `PROJECT_ROLE`, `CWIP_TEAM`, `CWIP_CONTRACT_PROJECTS`, `CWIP_CONTRACT_END_USERS`, `EMPLOYEES_V`, `DCT_EMPLOYEES_LIST2`, `DCT_EXT_USERS`, `DCT_HR_ORGANIZATIONS` and `ORGANIZATIONS_DETAILS_V`.

Observed packages are `VR_WORKFLOW2`, `BM_WORKFLOW`, `BACOF_WORKFLOW`, `VO_WORKFLOW`, `CONTRACT_UTIL`, `VO_UTIL` and `USER_DETAILS`. The export also contains a call to `VR_WORKFLOW.SUBMIT` while actions use `VR_WORKFLOW2`, indicating another version boundary that must be resolved from the database source.

### 5.4 Review findings

- Four near-identical workflow packages and four approval-history tables duplicate core behavior and invite inconsistent fixes.
- `PACOF` versus `BACOF`, and `VR_WORKFLOW` versus `VR_WORKFLOW2`, are unresolved naming/version inconsistencies.
- Page 30 contains a request-type dispatcher with repeated package calls. This belongs in a tested domain API, not page PL/SQL.
- App 142 uses custom `AUTHENTICATE_USER_UAT`; an environment-specific UAT authenticator should not be the production identity boundary.
- The app relies on shared App 130 project/team/contract data without a documented ownership/API boundary.
- Contract calculations are exposed through many scalar package calls, which can cause repeated SQL execution and inconsistent point-in-time values.

## 6. Recommended target design

### 6.1 Product boundaries

Reimplement this as one CWIP domain with two experiences:

- **Internal CWIP application:** project/contract setup, change management, payment review, administration and reporting.
- **External supplier portal:** contract visibility, payment submission, documents, comments and information responses only.

Keep internal and external navigation separate, but serve both through the same versioned business APIs and canonical domain packages. Do not copy page logic between apps.

### 6.2 Canonical data model

Preserve domain tables for projects, contracts, change requests and payment recommendations, but normalize shared concerns:

- `CWIP_PARTY` / party identities linked to the platform's canonical users, employees and supplier contacts.
- `CWIP_PROJECT_PARTICIPANT` and `CWIP_CONTRACT_ACCESS` with natural role codes, effective dates and explicit scope.
- `CWIP_DOCUMENT` plus document links, version, classification, checksum, malware-scan state and retention metadata rather than one attachment table per process.
- Canonical lookup codes with stable natural keys; never route by numeric surrogate IDs.
- A single workflow platform for instances, steps, tasks, participants, outcomes, delegation, information requests and immutable events.
- A status-history/event table distinct from the mutable current header state.
- Explicit optimistic-lock version columns and database constraints for statuses, amounts, dates and parent relationships.

Before migration, obtain dictionary DDL and profile every legacy status/code. Build a mapping table; do not silently coerce unknown values such as `Beaten`.

### 6.3 Workflow redesign

Use the repository's existing native DCT Workflow Platform (`DCT_WF_*`, `DCT_WF_ENGINE`, `DCT_WF_INBOX_V`) rather than adding another APEX-native or package-per-document engine. Define separate versioned processes for PAYMENT, VR, BM, PACOF and VO while sharing:

- role/principal resolution by stable role code;
- action vocabulary (recommend, forward, approve, reject, return, delegate, request information, reply, hold/resume, withdraw/cancel);
- parallel-task/quorum semantics;
- timeouts, reminders, escalation and substitution;
- bilingual notification templates;
- one cross-module worklist and full event timeline;
- simulation before publishing a workflow version.

Business actions should be idempotent and transactional. Lock the document/task row, validate the actor and expected version, record the event, advance workflow, enqueue notifications, and commit once. Email must not be the transaction boundary.

### 6.4 APEX/application architecture

- Target `final apps/`, consistent with repository production guidance; do not add features to the archived prototype.
- Use the central App 200 identity/session contract and platform roles. External portal identity must use a hardened dedicated portal session consistent with the existing platform pattern.
- Build task-focused pages: portfolio dashboard, project/contract workspace, change workspace, payment workspace, unified worklist and audit timeline.
- Replace large duplicate forms with reusable modal/task components and shared LOVs.
- Put mutations behind packages/ORDS handlers; pages call a small API and do not update workflow/history tables directly.
- Enforce authorization in the database/API for every record, attachment and task; APEX authorization schemes remain defense in depth.
- Use accessible Universal Theme/JET patterns, responsive layouts, clear status badges and an action bar driven by allowed outcomes.
- Use declarative validations for immediate feedback and repeat all material validations server-side.

### 6.5 Security and controls

- Central SSO/MFA for employees; strong password hashing or federated identity for external users.
- Server-side row-level access based on project/contract/task participation.
- Short-lived, hashed, single-use action tokens; bind token to user, document, action and nonce. Prefer authenticated actions over email-link approval.
- File allowlist, size limit, content sniffing, malware scanning, checksum and authorization-controlled streaming.
- No BLOBs or sensitive details in debug logs or email bodies.
- Segregation-of-duties rules, including submitter/approver conflicts and delegation restrictions.
- Immutable audit events containing actor, effective principal, action, timestamp, before/after status, comment and correlation ID.

### 6.6 Reporting and integration

- Create documented reporting views rather than embedding complex queries in APEX regions.
- Snapshot contractual amounts used in an approval so later contract changes cannot rewrite historical meaning.
- Produce payment/VO PDFs from a canonical read model and store the generated artifact/version/checksum at final approval.
- Expose integration through versioned ORDS endpoints and outbox-based events; do not couple other systems directly to page processes.
- Add operational dashboards for aging, bottlenecks, returns, delegation, overdue tasks and payment/change exposure.

## 7. Delivery plan

### Phase 0 — discovery and controls

1. Export current database DDL, package specs/bodies, triggers, jobs, grants, synonyms and view definitions.
2. Confirm the live versions of all workflow packages, especially payment body variants and `VR_WORKFLOW`/`VR_WORKFLOW2`.
3. Profile record counts, statuses, orphan rows, duplicate team roles and invalid effective dates.
4. Interview business owners to confirm the meaning of VR, BM and PACOF/BACOF, approval matrices, thresholds and segregation rules.
5. Freeze a glossary and source-to-target mapping.

### Phase 1 — platform foundation

1. Register CWIP in central identity/module access.
2. Define canonical role codes, authorization policies, document service and audit/event model.
3. Configure and test versioned DCT workflow definitions for the five processes.
4. Build API contracts and automated database tests before pages.

### Phase 2 — change management

Rebuild reference setup and VR → BM → PACOF → VO in sequence. This establishes approved changes and revised contract values before payment calculations depend on them.

### Phase 3 — payments and portal

Rebuild internal payment administration and approval, then the external submission portal over the same APIs. Add documents, comments, more-information and signed final output.

### Phase 4 — migration and rollout

1. Rehearse migration repeatedly with reconciliation by document, amount, status and task count.
2. Preserve legacy IDs as source keys and import immutable history events.
3. Run workflow parity/shadow tests and role-based UAT.
4. Cut over by process cohort, retain read-only legacy access, and monitor aging/error/security metrics.

## 8. Acceptance criteria

The reimplementation should not be accepted until:

- every in-scope legacy record and attachment is reconciled;
- every status has an approved mapping or documented exception;
- workflow simulation and automated tests cover all routes and outcomes;
- unauthorized record/task/document access tests return denial at the API layer;
- duplicate submissions and repeated actions are idempotent;
- financial totals and revised contract values reconcile to signed-off legacy reports;
- the external portal passes authentication, session, password/reset and file-upload security testing;
- no APEX page performs direct workflow-history DML;
- all deployed packages/objects are valid and the live APEX application passes import/runtime validation.

## 9. Database objects to obtain and verify

The standalone, editable checklist for the database owner is [CWIP_DATABASE_OBJECT_CHECKLIST.md](CWIP_DATABASE_OBJECT_CHECKLIST.md). The sections below retain the same dependency summary within this review.

### 9.1 Important limitation

Current database DDL was not available for this review. The lists below were reconstructed from SQL and PL/SQL references in the three APEX exports and the payment workflow documents. They identify the **legacy database objects that the applications appear to require**; they are not a claim that every object still exists, that its inferred type is correct, or that it should be reproduced unchanged in the new implementation.

Please update the `Verified` column as each object is checked against the current database. For each object, record the schema owner, actual object type, current name or replacement name, and whether its DDL/source has been collected.

Status meanings:

- **Required-core:** directly supports a primary business transaction or workflow.
- **Required-shared:** master/reference/security data needed by core pages or routing.
- **Supporting:** administration, reporting or an ancillary feature; confirm whether it remains in scope.
- **Type-check:** referenced by SQL, but the available documents do not prove whether it is a table, view or synonym.

### 9.2 Payment and external portal transaction objects

These objects are shared by App 130 and App 109.

| Object to check | Expected type | Classification | Why it is required | Verified |
|---|---|---|---|---|
| `CWIP_PAYMENT_RECOMMENDATION` | Table | Required-core | Payment recommendation header and lifecycle status | [ ] |
| `CWIP_PAYMENT_REC_APPROVAL_HISTORY` | Table | Required-core | Payment workflow steps, assignees, actions and history | [ ] |
| `CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS` | Table | Required-core | Payment supporting attachments | [ ] |
| `CWIP_PAYMENT_RECOMMENDATION_COMMENTS` | Table | Required-core | Payment comments/collaboration | [ ] |
| `CWIP_PAYMENT_REC_MORE_INFO` | Table | Required-core | More-information requests and replies | [ ] |
| `CWIP_PAYMENT_REC_REMINDERS` | Table | Supporting | Workflow reminders and reminder history/configuration | [ ] |
| `CWIP_CONTRACT_INVOICES` | Table | Required-core | Contract invoice/payment evidence | [ ] |
| `CWIP_PAYMENTS_CONFIGURATION` | Table | Required-core | Payment workflow/business configuration | [ ] |
| `CWIP_PAYMENT_RECOMMENDATION_V` | View | Required-core | Enriched payment display/report query source | [ ] |

For these objects, the most important items to recover are all primary/foreign/check constraints, status defaults, recommendation numbering logic, amount/currency columns, audit columns, BLOB metadata, indexes supporting inbox queries, and any triggers that change status or populate keys.

### 9.3 Project, contract and team objects

These are shared foundations for all three applications.

| Object to check | Expected type | Classification | Why it is required | Verified |
|---|---|---|---|---|
| `PROJECT` | Table or synonym | Required-shared, Type-check | Project master used throughout all apps | [ ] |
| `PROJECT_ROLE_CATEGORY` | Table | Required-shared | Groups project/workflow roles | [ ] |
| `PROJECT_ROLE` | Table | Required-shared | Role definitions used by teams and workflow routing | [ ] |
| `CWIP_TEAM` | Table | Required-shared | Project participants, roles, person types and effective dates | [ ] |
| `CWIP_CONTRACT` | Table | Required-shared | Contract master, value, schedule and vendor information | [ ] |
| `CWIP_CONTRACT_PROJECTS` | Table | Required-shared | Contract-to-project association | [ ] |
| `CWIP_CONTRACTS_V` | View | Required-shared | Enriched contract source used by internal and external pages | [ ] |
| `CWIP_CONTRACT_DOCUMENTS` | Table | Required-shared | Contract attachments | [ ] |
| `CWIP_DOCUMENTS` | Table | Supporting | Project/general document library | [ ] |
| `CWIP_CONTRACT_END_USERS` | Table | Required-shared | Contract end-user assignments/access | [ ] |
| `CWIP_CONTRACT_CONTRACTUAL_SECURITIES` | Table | Supporting | Contract-to-security association | [ ] |
| `CWIP_CONTRACTUAL_SECURITIES_LIST` | Table/view/synonym | Supporting, Type-check | Contractual-security catalog/report source | [ ] |
| `CWIP_PROJECT_STATUS_LOOKUP` | Table | Required-shared | Project status configuration | [ ] |
| `CWIP_PROJECT_LOCATIONS` | Table | Required-shared | Project location configuration | [ ] |
| `CWIP_PROJECT_PROGRESS` | Table | Supporting | Project progress detail | [ ] |
| `CWIP_PROJECT_COST_ADJUSTMENT` | Table | Required-shared | Project/contract cost adjustments | [ ] |
| `CWIP_PROJECT_BUDGET_SPLIT` | Table | Supporting | Project budget package/split detail | [ ] |
| `CWIP_PROJECT_ASSETS` | Table | Supporting | Project asset associations | [ ] |

The critical relationships to verify are project-to-contract, project-to-team, team-to-role/person, contract-to-end-user, contract-to-invoice, and contract-to-payment recommendation. Confirm whether these are enforced by foreign keys or only by application code.

### 9.4 Change-management transaction objects

These objects are required by App 142.

| Object to check | Expected type | Classification | Why it is required | Verified |
|---|---|---|---|---|
| `VR_REQUESTS` | Table | Required-core | Variation Request header | [ ] |
| `VR_REQUESTS_DOCUMENTS` | Table | Required-core | VR attachments | [ ] |
| `VR_REQUESTS_APPROVAL_HISTORY` | Table | Required-core | VR workflow history/tasks | [ ] |
| `BM_REQUESTS` | Table | Required-core | BM request header | [ ] |
| `BM_VR_REQUESTS` | Table | Required-core | BM-to-VR bridge | [ ] |
| `BM_REQUESTS_DOCUMENTS` | Table | Required-core | BM attachments | [ ] |
| `BM_REQUESTS_APPROVAL_HISTORY` | Table | Required-core | BM workflow history/tasks | [ ] |
| `BACOF_REQUESTS` | Table | Required-core | PACOF/BACOF request header | [ ] |
| `BACOF_VR_REQUESTS` | Table | Required-core | BACOF-to-VR bridge | [ ] |
| `BACOF_REQUESTS_DOCUMENTS` | Table | Required-core | BACOF attachments/attached forms | [ ] |
| `BACOF_REQUESTS_APPROVAL_HISTORY` | Table | Required-core | BACOF workflow history/tasks | [ ] |
| `VO_REQUESTS` | Table | Required-core | Variation Order header | [ ] |
| `VO_REQUESTS_COST_SUMMARY` | Table | Required-core | VO itemized cost lines | [ ] |
| `VO_REQUESTS_APPROVAL_HISTORY` | Table | Required-core | VO workflow history/tasks | [ ] |

For these objects, verify request-number generation, project/contract keys, upstream links between VR/BM/BACOF/VO, monetary and schedule fields, current status, submit/final decision/cancellation fields, row versioning, attachment structure and all workflow-history columns. The physical relationship from an approved BACOF/PACOF to its VO is especially important because it is not proven by the export.

### 9.5 People, organization, supplier and lookup objects

| Object to check | Expected type | Classification | Why it is required | Verified |
|---|---|---|---|---|
| `DCT_EXT_USERS` | Table | Required-shared | External identities, profiles and portal access | [ ] |
| `EMPLOYEES_V` | View | Required-shared | Internal employee identity/display data | [ ] |
| `DCT_EMPLOYEES_LIST2` | Table/view/synonym | Required-shared, Type-check | Employee LOV/routing source | [ ] |
| `DCT_EMPLOYEES_LOOKUPS` | Table/view/synonym | Supporting, Type-check | Employee-related lookup data | [ ] |
| `DCT_EMPLOYEES_SIGNATURES` | Table | Supporting | Approver signature storage | [ ] |
| `DCT_HR_ORGANIZATIONS` | Table/view/synonym | Required-shared, Type-check | Organization reference | [ ] |
| `ORGANIZATIONS_V` | View | Required-shared | Organization display source used by payments | [ ] |
| `ORGANIZATIONS_DETAILS_V` | View | Required-shared | Organization display source used by change management | [ ] |
| `DCT_LOOKUPS` | Table/view/synonym | Required-shared, Type-check | Shared lookup definitions | [ ] |
| `DCT_LOOKUP_VALUES` | Table | Required-shared | Shared lookup values | [ ] |
| `DCT_LOOKUPS_EXTENDED` | Table/view/synonym | Required-shared, Type-check | App 142 change/evaluation lookup source | [ ] |
| `CWIP_LOOKUP_VALUES` | Table | Required-shared | CWIP-specific lookup values | [ ] |
| `VENDORS` | Table/view/synonym | Required-shared, Type-check | Supplier master used by contracts/payments | [ ] |
| `VENDOR_CONTACTS` | Table/view/synonym | Supporting, Type-check | Supplier contact details | [ ] |
| `VENDORS_BANK_ACCOUNTS` | Table/view/synonym | Supporting, Type-check | Supplier bank-account display | [ ] |
| `FA_ASSETS` | Table/view/synonym | Supporting, Type-check | Asset reference used by project assets | [ ] |
| `HRSS_CONFIGURATIONS` | Table | Supporting | Shared configuration referenced by pages | [ ] |

Determine which of these are locally owned tables and which are views/synonyms over ERP, HR or integration schemas. For external sources, also capture the upstream owner, refresh mechanism, natural key, refresh frequency and whether the CWIP applications are permitted to write or only read.

### 9.6 APEX/platform support objects to confirm

The exports also reference Oracle/APEX operational objects such as `APEX$TEAM_DEV_FILES`, `USER_SCHEDULER_JOBS`, `USER_SCHEDULER_JOB_RUN_DETAILS` and `ALL_SEQUENCES`. These are not CWIP business tables and normally should not be recreated. Confirm whether any custom code incorrectly depends on them before redesign.

### 9.7 Package and view source required

Table DDL alone will not reveal the complete business behavior. Collect the current specification and body for:

- `CWIP_REC_PAYMENT_WORKFLOW`
- `CWIP_REC_PAYMENT_EMAILS`
- `CWIP_REC_PAYMENT_UTIL`
- `CWIP_REC_PAYMENT_EXT_APP`
- `VR_WORKFLOW` and `VR_WORKFLOW2`
- `BM_WORKFLOW`
- `BACOF_WORKFLOW`
- `VO_WORKFLOW`
- `CONTRACT_UTIL`
- `VO_UTIL`
- `EXT_USERS`
- `USER_DETAILS`
- `DCT_UTIL`

Also collect the complete SQL for every object identified as a view, plus dependent views referenced by that SQL. This will reveal hidden base tables not visible directly in the APEX exports.

### 9.8 What to provide for each table

For each confirmed table, the preferred evidence package is:

1. `DBMS_METADATA.GET_DDL('TABLE', ...)` output, including constraints.
2. Index DDL, especially unique and function-based indexes.
3. Trigger and sequence/identity definitions.
4. Table and column comments.
5. Row count and anonymized samples of distinct status/type/action codes.
6. Grants and synonyms.
7. Dependent views and packages.
8. Whether the table is active, obsolete, replaced, or read-only.

A compact update can use this format:

| Object | Owner | Actual type | Exists now? | DDL/source added at | Replacement/notes |
|---|---|---|---|---|---|
| `CWIP_PAYMENT_RECOMMENDATION` |  |  |  |  |  |

### 9.9 Other evidence required for a build-ready specification

In addition to database object definitions, obtain:

- production role/lookup seed data and approval thresholds;
- anonymized records covering every document status and route;
- report/output requirements and current signed forms;
- notification/reminder/escalation rules;
- retention, data-classification and external-user security requirements;
- integration inventory for ERP, vendor, contract, employee and asset data.

Until these are supplied, exact cardinalities, physical foreign keys, object ownership, the complete approval matrices and some object types remain discovery items rather than facts.
