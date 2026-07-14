# Freelancers (App 203) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the
> Freelancers JET SPA exposes, organised by functional area. (The external
> self-service Portal under `FL/Portal/` is a separate plain-KO SPA — not covered here.)
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/FL/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Freelancers** · Brand: `#7C4DBE` · ORDS base: `/ords/admin/fl`

---

## 1. Authentication
**Login** (`login`) — `doLogin` · `quickLogin`.

## 2. Dashboard
**Dashboard** (`dashboard`) — KPI landing (display-only).

## 3. Registrations

**Registrations** (`registrations`) — freelancer registration applications.
- `openNew` / `openItem` · `reload` · `badgeFor`.

**Registration Editor** (`registrationEdit`) — create/edit a registration. Inline per-field validation (`checkField`), required-documents checklist + How-to-Complete panel.
- `saveDraft` / `submit` · `checkField` · `pickPhoto` / `photoSelected` · `back`.
- Required docs (raw-binary upload via shared `docUpload.choose` + `putBinary`): `loadRegDocs` · `pickDocFile` · `removeDoc` · `viewDoc` · `missingDocs` (computed `docChecklist`).
- **Approval History region** (shown once submitted): `loadApprovalHistory` renders the route steps (approver, status, received-on, acted-on, by, comments) + who it is pending with; `stepClass(status)` badge helper; computed `showApproval` / `canForceApprove`. **`forceApprove`** (FL_ADMIN) drives the approval to completion, recorded as a `[FORCE APPROVAL]` action.

## 4. Freelancers

**Freelancers** (`freelancers`) — approved freelancer directory.
- `openItem` · `reload` · `badgeFor`.

**Freelancer Detail** (`freelancerDetail`) — profile tabs (contracts, docs, bank, status).
- `setTab` · `openContract` / `openDoc` / `openBank` / `openStatus`.
- `saveBank` / `saveDoc` / `saveStatus` · `makePrimary` · `reload` · `back` · `conBadge` / `expChip` / `statusBadge`.

## 5. Contracts

**Contracts** (`contracts`) — contract list.
- `openNew` / `openItem` · `reload` · `badgeFor` / `billPct`.

**Contract Editor** (`contractEdit`) — draft/submit a contract on the Legal-Affairs **termsheet** (Phase 2: Engagement / Commercial Terms / Routing sections + review mode).
- `saveDraft` / `submit` (submit pre-validates the termsheet — `validateTermsheet`) · `back`.
- Email→user lookups: `lookupContractManager` · `lookupLineManager` · `lookupMemoFrom` · `lookupMemoTo`.
- Required-documents checklist (context `FL/CONTRACT`): `refreshRequirements` · `uploadRequirement` (files the document on the **freelancer's record**, with expiry, so it satisfies their future contracts too) · `viewDoc` / `downloadDoc`. A requirement is satisfied by an **unexpired document on the freelancer's record** (preferred, shown as "From freelancer record") or a contract-only copy; an expired profile copy is flagged with its expiry date instead of counting (db/33).
- **Budget Allocation** (db/31): Title + Terms of Payment are lookup selects (`titleOptions` / `paymentTermOptions` from `FL_CONTRACT_TITLE` / `FL_PAYMENT_TERMS`; Title optional). Allocation level defaults to **Project** — `budgetYear` (start-date year) · dependent LOVs `buProjects` / `buTasks` / `buEtypes` over the project balances view · fund flag `fund` / `fundBusy` / `fundBreakdown` / `fundShortMsg` (green = line covers the contract total; red = shortfall + raise a Fund Transfer / request additional fund). GL level = cascading segment LOVs `glEntities` / `glCostCentres` / `glAccounts` → `glCombos` (`glComboHint`). New `flService` methods: `getLookupValues` · `getBudgetProjects` / `getBudgetTasks` / `getBudgetEtypes` / `checkBudgetFund` · `getGlSegments` / `getGlCombinations`.
- **Searchable LOVs**: all 10 LOV fields on this form (Freelancer, Title, Terms of Payment, Project, Task, Expenditure Type, GL Entity / Cost Centre / Account / Combination) use the `<lov-input>` type-ahead component (`Jet/js/components/lovInput.js`) — type to filter, resolves to the code, "No match" when it can't. Server-side search behind the capped lists: `searchBuProjects` · `searchGlCombos`.

**Contract Detail** (`contractDetail`) — contract lifecycle (amend, renew, voucher, chain, termsheet PDF).
- `setTab` · `openEdit` · `submit` · `generateVoucher`.
- **Approval Chain tab** (Phase 2): `loadApprovalHistory` (7-step timeline w/ named approvers) · `stepBadge` · `canForceApprove` / `forceApprove` (FL_ADMIN).
- **Termsheet PDF** (Phase 2, D1/D3): `generateTermsheet` — enqueue `FL_CONTRACT_TERMSHEET` via the bridge, poll (`tsBusy`/`tsLabel`), download, then auto-file on the contract (doc type `TERMSHEET`).

**Approver Assignments** (`approverMap`) — Phase 2 (D2), Admin nav, FL_ADMIN-gated mutations. Who endorses per role per org unit (department → sector fallback → any role holder).
- `reload` · `openAdd` / `saveAdd` · `lookupApprover` · `toggleActive` · `remove`.
- Amendments: `openAmendment` / `saveAmendment` / `submitAmendment`.
- Renewals: `openRenewal` / `saveRenewal` / `submitRenewal`.
- `reload` · `back` · `statusBadge` / `schedBadge`.

## 6. Deliverables
**Deliverables** (`deliverables`) — accept/reject contract deliverables.
- `accept` · `openReject` / `confirmReject` · `reload` · `badgeFor`.

## 7. Payments

**Payment Schedule** (`paymentSchedule`) — scheduled payments + bulk voucher generation.
- `generateVoucher` · `openBulk` / `runBulk` · `openContract` · `reload` · `badgeFor` / `isOverdue`.

**Vouchers** (`vouchers`) — payment voucher list.
- `openItem` · `reload` · `badgeFor` / `payBadge`.

**Voucher Detail** (`voucherDetail`) — voucher lifecycle (db/35 + db/36 + db/37).
- `saveDraft` / `submit` · `markPaid` · `openContract` · `reload` · `back` · `statusBadge` / `payBadge`.
- **Admin edit of a generated voucher** (`editable` / `adminEdit` / `adminHint`): an FL_ADMIN/SYS_ADMIN may change **amount, due date, payment period, pay group and description** while the voucher is DRAFT *or* SUBMITTED (never once APPROVED / REJECTED / CANCELLED / PAID); the server 403s those fields for anyone else and re-syncs the payment-schedule row the voucher came from.
- **Payment method / pay group** come from the managed lookups `FL_PAYMENT_METHOD` (**EFT · Ratabi · Trust**) and `FL_PAY_GROUP` (`paymentMethods` / `payGroups`); a stored value whose lookup entry has been retired is re-injected as its own option (`keepStored`) so historical vouchers never blank.
- **Invoice number** is system-generated from `INVOICE_NUMBER_TEMPLATE` when `INVOICE_NUMBER_AUTO`=Y (`autoInvoice` / `invoiceHint`); the field falls back to user entry when the setting is off.
- **Payment period From → To** + due/invoice facts + the contract's value / paid-to-date bar in the summary rail (`billingLabel` · `contractPct`).
- **Budget Allocation**: project + name, task, expenditure type or GL combination, with live budget / actual / commitment / obligation / fund-available figures and a green-red fund verdict (`budget` / `hasBudget` / `budgetYear` / `budgetNote` / `usedPct` / `money`).
- **Attachments** (source_type `VOUCHER`): `reloadAttachments` · `addAttachment` · `removeAttachment` · `viewAttachment` / `downloadAttachment` · `fileSizeTxt`. New `flService.getVoucherDocuments(id)`.

**Payment schedule status** mirrors the voucher: `PENDING → VOUCHER_GENERATED (Generated) → VOUCHER_APPROVED (Approved) → PAID`; a rejected voucher releases the period back to Pending (`paymentSchedule`: `statusLabel` / `badgeFor`).

## 8. Documents
**Documents** (`documents`) — document register with expiry tracking.
- `openFreelancer` · `reload` · `expChip` · `hasFile` / `viewDoc` / `downloadDoc` (per-row **View / Download** of the stored file).

The same View / Download actions appear on the **freelancer detail → Documents tab** (`freelancerDetail`: `hasFile` / `viewDoc` / `downloadDoc` / `fileSizeTxt`) and on the **registration editor** document checklist (`registrationEdit`: `viewDoc` / `downloadDoc`). All three go through the shared FL service `docFile` (`js/services/docFile.js` — `view` / `download` / `hasFile`), which pulls `GET /fl/documents/:id/file` with the Bearer token via `api.fetchBlobUrl` (never the raw ADB host — that bypasses the web-tier proxy and sends no token) and opens the tab synchronously so the pop-up blocker doesn't swallow it. Non-inline types (Word/Excel) download instead of opening a blank tab.

## 9. Approvals
**Approvals** (`approvals`) — unified approvals inbox (delegation-aware).
- `startApprove` / `startReject` / `startReturn` / `startAction` · `confirmAction` / `cancelAction` · `getStepArray` / `stepState` · `moduleChip`.

## 10. Notifications
**Notifications** (`notifications`) — `markRead` / `markAll` · `typeClass`.

## 11. Configuration
**Module Settings** (`moduleSettings`) — module settings + region appearance + **Registration Documents** and **Contract Documents** checklists (db/34).
- Each document row has TWO switches: **Shown/Hidden** (`is_active` — hidden documents never appear on the checklist) and **Required/Optional** (`is_mandatory` — optional ones appear but never block submission), plus **Add a document** from the doc-type catalogue. Photo Required (registration) stays a module setting.
- `saveAll` (persists dirty settings **and** dirty doc-requirement toggles via `flService.patchDocRequirement`) · `addRegDoc` / `addConDoc` · `addRegOptions` / `addConOptions`.
- New `flService` methods: `getDocRequirementsAdmin(context, includeHidden)` · `patchDocRequirement(id, {isMandatory, isActive, displaySeq})` · `addDocRequirement({contextCode, docTypeId, isMandatory})` · `getDocTypeCatalog()`.

---

## API Endpoints (ORDS)

Module `fl.rest` · base path **`/ords/admin/fl/`** · defined in `final apps/FL/db/08_fl_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). Everything else — including FL's own notifications
(listed below) — hits `/ords/admin/fl/`.
The `portal/*` endpoints serve the external freelancer self-service Portal (separate
`ifinance_portal_session` auth — NOT `dct_rest.validate_session`).

| Area | Method & Path |
|---|---|
| Dashboard | `GET dashboard/stats` · `GET dashboard/charts` |
| Registrations | `GET registrations/` · `POST registrations/` · `GET registrations/:id` · `PUT registrations/:id` · `POST registrations/:id/submit` · `PUT registrations/:id/photo` · `GET registrations/:id/photo` *(media)* · `GET registrations/:id/documents` |
| Doc requirements | `GET doc-requirements/?context=…` · `PUT doc-requirements/:id` *(FL_ADMIN — toggle `isMandatory` required/optional; UD-FL-01 US-10)* |
| Freelancers | `GET freelancers/` · `GET freelancers/:id` · `PUT freelancers/:id` · `PUT freelancers/:id/photo` · `GET freelancers/:id/photo` *(media)* · `POST freelancers/:id/bank-accounts` · `PUT bank-accounts/:id` · `POST freelancers/:id/portal-invite` |
| Contracts | `GET contracts/` · `POST contracts/` · `GET contracts/:id` · `PUT contracts/:id` · `POST contracts/:id/submit` · `GET contracts/:id/schedule` · `GET contracts/:id/amendments` · `POST contracts/:id/amendments` · `POST amendments/:id/submit` |
| Contracts — Phase 2 termsheet (db/28) | `GET contracts/:id/requirements` · `GET contracts/:id/approval-history` · `POST contracts/:id/force-approve` |
| Vouchers — enhancements (db/35, db/36, db/37) | `POST vouchers/` *(stamps the schedule row + auto invoice number)* · `GET vouchers/:id` *(+ periodStart/periodEnd, full budget block, contract position)* · `GET vouchers/:id/documents` · `PUT vouchers/:id` *(admin-editable: amount / dueDate / periodLabel are FL_ADMIN-only → 403; DRAFT for anyone, SUBMITTED for an admin; re-syncs the payment-schedule row)* |
| Document checklists — FL_ADMIN (db/34) | `GET doc-requirements/?context=&all=Y` · `POST doc-requirements/` · `PUT doc-requirements/:id` *(partial: isMandatory / isActive / displaySeq)* · `GET doc-types/` |
| Contract LOVs + Budget Allocation (db/31) | `GET lookup-values?cat=` · `GET budget/projects?year=&search=` · `GET budget/tasks?year=&project=` · `GET budget/etypes?year=&project=&task=` · `GET budget/check?year=&project=&task=&etype=&amount=` · `GET gl/segments?seg=entity\|costcenter\|account` · `GET gl/combinations?entity=&costcenter=&account=&search=` |
| Termsheet PDF bridge (db/29) | `POST contracts/:id/termsheet-pdf` · `GET contracts/:id/termsheet-pdf/:runId` · `GET contracts/:id/termsheet-pdf/:runId/pdf` · `POST contracts/:id/termsheet-pdf/:runId/attach` |
| Approver assignments (db/28) | `GET approver-map/` · `POST approver-map/` · `PUT approver-map/:id` · `DELETE approver-map/:id` |
| Renewals | `GET renewals/` · `POST renewals/` · `POST renewals/:id/submit` |
| Payment Schedule | `GET schedule/` · `POST schedule/bulk-generate` |
| Vouchers | `GET vouchers/` · `POST vouchers/` · `GET vouchers/:id` · `PUT vouchers/:id` · `POST vouchers/:id/submit` · `POST vouchers/:id/mark-paid` |
| Deliverables | `GET deliverables/` · `POST deliverables/` · `POST deliverables/:id/accept` · `POST deliverables/:id/reject` |
| Documents | `GET documents/` · `POST documents/` · `PUT documents/:id/file` · `GET documents/:id/file` *(media)* · `DELETE documents/:id` |
| Profile Changes | `GET profile-changes/` · `POST profile-changes/` · `POST profile-changes/:id/submit` |
| Approvals | `GET approvals/pending` · `POST approvals/:id/action` |
| Reference | `GET lookups` · `GET gl-codes` |
| Settings | `GET settings` · `PUT settings/:id` |
| Notifications | `GET notifications/` · `POST notifications/:id/read` · `POST notifications/mark-all-read` |
| Portal (external) | `POST portal/auth/login` · `POST portal/auth/set-password` · `POST portal/auth/logout` · `GET portal/me` · `GET portal/contracts` · `GET portal/schedule` · `GET portal/vouchers` |
| Phase 1 — AI / dedup / lookup (auth) | `POST registrations/:id/documents/:docId/extract` (AI extract) · `GET registrations/:id/duplicates` · `POST registrations/:id/duplicate-override` (FL_ADMIN) · `GET users/lookup?email=` |
| Approval history + force (auth) — `final apps/FL/db/24_fl_reg_approval_history.sql`, additive to `fl.rest` | `GET registrations/:id/approval-history` (route steps + actions + pending-with; any FL user) · `POST registrations/:id/force-approve` `{comments}` (FL_ADMIN/SYS_ADMIN → drives `DCT_FL_PKG.act_on_approval` to completion, recorded as `[FORCE APPROVAL]`) |
| Phase 1 — Public self-registration (token-gated; gate = `FEATURE_FL_PORTAL` OR `ALLOW_SELF_REGISTRATION`) | `POST reg/public/start` *(returns `devCode` when `REG_OTP_DEV_ECHO=Y`)* · `POST reg/public/verify` *(returns `aiEnabled`)* · `GET reg/public/nationalities` · `GET reg/public/:token` *(returns `aiEnabled` + `photoRequired`/`docsRequiredForSubmit`/`hasPhoto`/`docRequirements[]` — UD-FL-01)* · `POST reg/public/:token/draft` *(empty draft, documents-first)* · `PUT reg/public/:token` · `POST reg/public/:token/documents` · `PUT reg/public/:token/documents/:docId/file` · `PUT reg/public/:token/photo` *(raw-binary personal photo → `photo_blob`, `MAX_UPLOAD_MB` 413 guard; UD-FL-01 US-09)* · `POST reg/public/:token/documents/:docId/extract` *(returns `detectedKind`/`typeMismatch`)* · `POST reg/public/:token/submit` *(`-20132` photo-required now maps to 400)* |

**Registration editor (`registrationEdit`) — Phase 1 methods:** `resolveLineManager` (email→DCT user hint), `loadDuplicates` / `overrideDuplicate`, `runExtract` / `applyExtract` / `closeAi` (AI review modal). New `flService` methods: `extractRegistrationDocument`, `getRegistrationDuplicates`, `overrideRegistrationDuplicate`, `lookupUser`. Backend packages: `DCT_FL_AI_PKG.extract_document`, `DCT_FL_REG_PKG.{find_duplicates,add_duplicate_override,start_public_registration,verify_public_otp,public_email,public_registration_id,set_public_registration}`.

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/fl`). |
| `authService` | login / session validate. |
| `flService` | registrations, freelancers, contracts, deliverables, vouchers, documents. |
| `notificationService` | notifications + count. |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
