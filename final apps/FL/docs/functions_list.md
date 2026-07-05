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

## 4. Freelancers

**Freelancers** (`freelancers`) — approved freelancer directory.
- `openItem` · `reload` · `badgeFor`.

**Freelancer Detail** (`freelancerDetail`) — profile tabs (contracts, docs, bank, status).
- `setTab` · `openContract` / `openDoc` / `openBank` / `openStatus`.
- `saveBank` / `saveDoc` / `saveStatus` · `makePrimary` · `reload` · `back` · `conBadge` / `expChip` / `statusBadge`.

## 5. Contracts

**Contracts** (`contracts`) — contract list.
- `openNew` / `openItem` · `reload` · `badgeFor` / `billPct`.

**Contract Editor** (`contractEdit`) — draft/submit a contract.
- `saveDraft` / `submit` · `back`.

**Contract Detail** (`contractDetail`) — contract lifecycle (amend, renew, voucher).
- `setTab` · `openEdit` · `submit` · `generateVoucher`.
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

**Voucher Detail** (`voucherDetail`) — voucher lifecycle.
- `saveDraft` / `submit` · `markPaid` · `openContract` · `reload` · `back` · `statusBadge` / `payBadge`.

## 8. Documents
**Documents** (`documents`) — document register with expiry tracking.
- `openFreelancer` · `reload` · `expChip`.

## 9. Approvals
**Approvals** (`approvals`) — unified approvals inbox (delegation-aware).
- `startApprove` / `startReject` / `startReturn` / `startAction` · `confirmAction` / `cancelAction` · `getStepArray` / `stepState` · `moduleChip`.

## 10. Notifications
**Notifications** (`notifications`) — `markRead` / `markAll` · `typeClass`.

## 11. Configuration
**Module Settings** (`moduleSettings`) — module settings + region appearance + **Registration Documents** (required/optional per document + Photo required — UD-FL-01 US-10).
- `saveAll` (persists dirty settings **and** dirty doc-requirement toggles via `flService.updateDocRequirement`).

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
