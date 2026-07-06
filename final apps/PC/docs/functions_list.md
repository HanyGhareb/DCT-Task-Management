# Petty Cash (App 201) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the Petty
> Cash JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/PC/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Petty Cash** · ORDS base: `/ords/admin/pc`

---

## 1. Authentication
**Login** (`login`) — `doLogin` · `quickLogin` · `onKeyDown`.

## 2. Dashboard
**Dashboard** (`dashboard`) — landing + quick navigation.
- `newRequest` / `newClear` / `newReimb` · `viewMy` / `viewApprovals`.

## 3. Petty Cash Requests

**My Petty Cash** (`myPettyCash`) — requester's own requests.
- `newRequest` / `viewDetail` · `fmtAmount` / `fmtDate` / `statusClass` / `statusLabel` / `typeLabel`.

**All Petty Cash** (`allPettyCash`) — admin-wide list + disburse.
- `viewDetail` · `disburse` · `reload` · `fmtAmount` / `fmtDate` / `statusClass`.

**PC Request Form** (`pcRequest`) — create a petty-cash request with coding lines.
- `addLine` / `removeLine` · `saveDraft` / `saveForm` / `submit` · `cancel`.
- Reference cascades: `refreshAppropriations` / `refreshCostCenters` / `refreshExpenditureTypes` / `refreshTaskNumbers` · `getFundAvailable`.

**PC Detail** (`pcDetail`) — view + lifecycle actions.
- `editRequest` · `disburse` · `newClear` / `newReimb` · `viewClear` / `viewReimb` · `back` · `actionClass` / `statusClass` / `fmtAmount` / `fmtDate`.

## 4. Clearings

**Clearing** (`clearing`) — my clearings list.
- `newClearing` / `viewDetail` · `fmtAmount` / `fmtDate` / `statusClass`.

**All Clearings** (`allClearings`) — admin-wide clearings.
- `viewDetail` · `fmtAmount` / `fmtDate` / `statusClass`.

**Clear Detail** (`clearDetail`) — clearing form with lines.
- `addLine` / `removeLine` · `saveForm` · `cancel` · `fmtAmount`.

## 5. Reimbursements

**Reimbursements** (`reimbursements`) — my reimbursements list.
- `newReimb` / `viewDetail` · `fmtAmount` / `fmtDate` / `statusClass`.

**All Reimbursements** (`allReimbursements`) — admin-wide reimbursements.
- `viewDetail` · `fmtAmount` / `fmtDate` / `statusClass`.

**Reimb Detail** (`reimbDetail`) — reimbursement form with lines.
- `addLine` / `removeLine` · `saveForm` · `cancel` · `fmtAmount`.

## 6. Approvals
**Approvals** (`approvals`) — approval inbox across PC document types.
- `openModal` / `submitAction` / `closeModal` · `viewSource` · `typeClass` / `typeLabel` / `fmtAmount` / `fmtDate`.

**Fusion AP write-back (backend, no UI).** On a reimbursement's final approval, both the interactive
approve handler (`06_pc_ords.sql`) and the auto-approval sweep (`db/v2/14` `apply_final_approval`)
call `DCT_PC_FUSION_PKG.enqueue_fusion_action(reimb_id)` — a **no-op unless** PETTY_CASH setting
`FUSION_POST_REIMB=Y` (or the row's `post_to_fusion='Y'`). It builds an AP-invoice payload
(`build_ap_invoice_payload`) and enqueues an idempotent `AP_INVOICE` action (keyed by `reimb_number`)
into `ATD_ACTION_REQUEST`; the Analytics-Loader runner (`runner.py --actions`) creates the invoice in
Fusion and calls back `receive_fusion_result(reimb_id, invoice_id)` → reimbursement
`fusion_status=POSTED` + `fusion_invoice_id`. New columns on `DCT_PC_REIMBURSEMENTS`:
`post_to_fusion`, `fusion_status`, `fusion_invoice_id`, `fusion_pushed_at`. Script: `db/07_pc_fusion.sql`.

## 7. Configuration

**GL Codes** (`glCodes`) — GL code combination master.
- `addRow` / `startEdit` / `saveEdit` / `saveNew` / `deleteRow` / `cancelEdit`.

**Approval Rules** (`approvalRules`) — approval template selection.
- `selectTemplate` · `condTypeLabel` / `templateTypeLabel` / `typeClass`.

**Module Settings** (`moduleSettings`) — module settings + region appearance.
- `saveAll` · `resetDefault`.

## 8. Notifications
**Notifications** (`notifications`) — `markRead` / `markAllRead` · `typeIcon` / `fmtDate`.

---

## API Endpoints (ORDS)

Module `pc.rest` · base path **`/ords/admin/pc/`** · defined in `final apps/PC/db/06_pc_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). Everything else — including PC's own notifications
(listed below) — hits `/ords/admin/pc/`.

| Area | Method & Path |
|---|---|
| Petty Cash | `GET pc/stats` · `GET pc/activity` · `GET pc/charts` · `GET pc/all` · `GET pc/` · `POST pc/` · `GET pc/:id` · `PUT pc/:id` · `GET pc/:id/lines` · `POST pc/:id/disburse` |
| GL Codes | `GET gl-codes` · `POST gl-codes` · `PUT gl-codes/:id` · `DELETE gl-codes/:id` |
| Reimbursements | `GET reimbursements/all` · `GET reimbursements/` · `POST reimbursements/` · `GET reimbursements/:id` · `PUT reimbursements/:id` · `GET reimbursements/:id/lines` |
| Clearings | `GET clearings/all` · `GET clearings/` · `POST clearings/` · `GET clearings/:id` · `PUT clearings/:id` · `GET clearings/:id/lines` |
| Approvals | `GET approvals/pending` · `POST approvals/:id/action` · `GET approval-templates` · `GET approval-templates/:id/steps` |
| Settings | `GET settings` · `PUT settings/:id` · `POST settings/:id/reset` |
| Notifications | `GET notifications/` · `POST notifications/mark-all-read` · `POST notifications/:id/read` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/pc`). |
| `authService` | login / session validate. |
| `pcService` | petty-cash requests + reference cascades + GL codes. |
| `clearService` | clearings + lines. |
| `reimbService` | reimbursements + lines. |
| `approvalService` | approval inbox + actions. |
| `settingService` | module/system settings. |
| `notificationService` | notifications + count. |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
