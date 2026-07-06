# Duty Travel (App 204) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the Duty
> Travel JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/DT/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Duty Travel** · ORDS base: `/ords/admin/dt`

---

## 1. Authentication
**Login** (`login`) — `login` · `quickLogin`.

## 2. Dashboard
**Dashboard** (`dashboard`) — landing + quick navigation.
- `newRequest` · `openRequest` · `viewRequests` / `viewApprovals` / `viewDisburse`.

## 3. Travel Requests

**My Requests** (`myRequests`) — requester's own travel requests.
- `newRequest` / `openDetail`.

**All Requests** (`allRequests`) — admin-wide request list.
- `reload` · `openDetail` · `fmt`.

**Request Form** (`requestForm`) — create/edit a travel request with destinations.
- `addDest` / `removeDest` · `saveDraft` / `submit` · `cancel`.

**Request Detail** (`requestDetail`) — view + lifecycle actions.
- `editRequest` / `cancelRequest` · `startSettle` · `payAdvance`.
- Approve/Reject/Return: `openApproveModal` / `openRejectModal` / `openReturnModal` / `submitAction` / `closeActionModal` · `goBack` · `fmt`.

## 4. Settlements

**My Settlements** (`mySettlements`) — requester's settlements.
- `openDetail` · `fmt`.

**All Settlements** (`allSettlements`) — admin-wide settlements.
- `openDetail` · `fmt`.

**Settlement Form** (`settlementForm`) — settle a trip with expense lines.
- `addExpenseLine` / `removeExpenseLine` · `saveDraft` / `submit` · `goBack` · `fmt`.

## 5. Approvals
**Approvals** (`approvals`) — approval inbox.
- `openApprove` / `openReject` / `openReturn` / `submitAction` / `closeModal` · `viewDetail` · `fmt`.

## 6. Processing Queues

**Disbursement Queue** (`disbursementQueue`) — pay travel advances.
- `payAdvance` · `viewDetail` · `fmt`.

**Closure Queue** (`closureQueue`) — close settled trips.
- `closeSettlement` · `viewDetail` · `fmt`.

## 7. Reports
**Travel Report** (`travelReport`) — reporting view.
- `fmt`.

## 8. Configuration

**Per-Diem Rates** (`perDiemRates`) — per-diem rate master.
- `startEdit` / `saveEdit` / `cancelEdit` · `fmt`.

**Country Groups** (`countryGroups`) — country grouping for rates.
- `toggleGroup` / `isExpanded`.

**Approval Rules** (`approvalRules`) — approval template selection.
- `selectTemplate` · `conditionLabel`.

**Document Requirements** (`docRequirements`) — required-document config.
- `startEdit` / `saveEdit` / `cancelEdit`.

**Module Settings** (`moduleSettings`) — module settings + region appearance.
- `saveAll` · `resetDefaults`.

## 9. Notifications
**Notifications** (`notifications`) — `markRead` / `markAllRead` · `typeIcon` / `timeAgo`.

---

## API Endpoints (ORDS)

Module `dt.rest` · base path **`/ords/admin/dt/`** · defined in `final apps/DT/db/06_dt_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). Everything else — including DT's own notifications
(listed below) — hits `/ords/admin/dt/`.

| Area | Method & Path |
|---|---|
| Dashboard | `GET dashboard/` |
| Requests | `GET requests/` · `POST requests/` · `GET requests/:id` · `PUT requests/:id` · `POST requests/:id/submit` · `POST requests/:id/cancel` · `POST requests/:id/pay-advance` · `POST requests/:id/mark-travelled` · `GET requests/:id/destinations` |
| Settlements | `GET settlements/` · `POST settlements/` · `GET settlements/:id` · `PUT settlements/:id` · `POST settlements/:id/submit` · `POST settlements/:id/close` |
| Approvals | `GET approvals/pending` · `POST approvals/:id/action` · `GET approval-templates/` · `GET approval-templates/:id/steps` |
| Per-Diem & Countries | `GET perdiem-rates/lookup` · `GET perdiem-rates/` · `POST perdiem-rates/` · `PUT perdiem-rates/:id` · `DELETE perdiem-rates/:id` · `GET country-groups/` · `PUT country-groups/:code` · `GET countries/` |
| Doc Requirements | `GET doc-requirements/` · `PUT doc-requirements/:id` |
| Settings | `GET settings/` · `PUT settings/:id` |
| Notifications | `GET notifications/` · `POST notifications/mark-all-read` · `POST notifications/:id/read` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/dt`). |
| `authService` | login / session validate. |
| `dtService` | requests, destinations, queues, rates, config. |
| `settlementService` | settlements + expense lines. |
| `approvalService` | approval inbox + actions. |
| `settingService` | module/system settings. |
| `notificationService` | notifications + count. |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
