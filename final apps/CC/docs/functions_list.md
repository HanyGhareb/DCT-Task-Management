# Credit Cards (App 202) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the Credit
> Cards JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/CC/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Credit Cards** · Brand: `#B0721E` · ORDS base: `/ords/admin/cc`

---

## 1. Authentication
**Login** (`login`) — `doLogin` · `quickLogin`.

## 2. Dashboard
**Dashboard** (`dashboard`) — KPI landing (display-only).

## 3. My Card
**My Card** (`myCard`) — cardholder's own card + quick actions.
- `newRequest` (new card transaction request) · `newReplenishment` · `statusBadge` / `changeBadge`.

## 4. Card Requests

**Requests** (`requests`) — request list (my / all scope).
- `newRequest` / `openDetail` · `reload` · `setScope` · `statusBadge` / `typeLabel`.

**New Request** (`requestNew`) — guided request creation.
- `next` · `pickType` / `pickFile` · `createDraft` / `saveDraftAndExit` / `submit` · `back`.

**Request Detail** (`requestDetail`) — view/act on a request.
- `submit` · `withdraw` · `statusBadge` / `typeLabel` · `back`.

## 5. Replenishments

**Replenishments** (`replenishments`) — replenishment list.
- `createNew` / `openNew` / `openDetail` · `reload` · `setScope` · `statusBadge`.

**Replenishment Detail** (`replenishmentDetail`) — replenishment with coding lines.
- `addLine` / `removeLine` / `saveLines` / `markDirty` · `submit` · `statusBadge` · `back`.

## 6. All Cards (Admin)
**All Cards** (`allCards`) — card registry; register new cards.
- `openRegister` / `registerCard` · `reload` · `statusBadge`.

## 7. Proxies
**Proxies** (`proxies`) — delegate card usage to a proxy user.
- `openNew` / `createProxy` · `deactivate` · `reload`.

## 8. Approvals
**Approvals** (`approvals`) — unified approvals inbox (delegation-aware).
- `startApprove` / `startReject` / `startReturn` / `startAction` · `confirmAction` / `cancelAction` · `getStepArray` / `stepState` · `moduleChip`.

## 9. Notifications
**Notifications** (`notifications`) — `markRead` / `markAll` · `typeClass`.

## 10. Configuration
**Module Settings** (`moduleSettings`) — module settings + region appearance.
- `saveAll`.

---

## API Endpoints (ORDS)

Module `cc.rest` · base path **`/ords/admin/cc/`** · defined in `final apps/CC/db/09_cc_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). Everything else — including CC's own notifications
(listed below) — hits `/ords/admin/cc/`.

| Area | Method & Path |
|---|---|
| Dashboard | `GET dashboard/stats` · `GET dashboard/charts` |
| Cards | `GET cards/` · `POST cards/register` · `GET cards/:id` · `GET cards/:id/limit-history` |
| Requests | `GET requests/` · `POST requests/` · `GET requests/:id` · `PUT requests/:id` · `POST requests/:id/submit` · `POST requests/:id/withdraw` |
| Documents | `GET doc-requirements` · `GET documents/` · `POST documents/` · `PUT documents/:id/file` · `GET documents/:id/file` *(media)* |
| Replenishments | `GET replenishments/` · `POST replenishments/` · `GET replenishments/:id` · `PUT replenishments/:id` · `PUT replenishments/:id/lines` · `POST replenishments/:id/submit` |
| Proxies | `GET proxies/` · `POST proxies/` · `PUT proxies/:id` |
| Approvals | `GET approvals/pending` · `POST approvals/:id/action` |
| Reference | `GET lookups` · `GET gl-codes` |
| Settings | `GET settings` · `PUT settings/:id` |
| Notifications | `GET notifications/` · `POST notifications/:id/read` · `POST notifications/mark-all-read` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/cc`). |
| `authService` | login / session validate. |
| `ccService` | cards, requests, replenishments, proxies, approvals. |
| `notificationService` | notifications + count. |
