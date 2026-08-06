# PAY — Outsource Payroll (App 215) — Functions List

Functional inventory of the JET SPA (`Jet/js/views/<x>.html` + `viewModels/<x>.js`) and the ORDS API (`db/04_pay_ords.sql`). Update this file in the SAME change as any view/method/endpoint change.

## Overview (dashboard)
- `refresh()` — reload the /stats figures and expiring-contracts list.
- `toggleRegion()` / `toggleRegionMax()` — collapse / maximize the expiring-contracts region.
- `openContract(row)` — deep-link a row into the Contracts page drawer.
- `go(route)` — header shortcut (New Company).

## Companies
- `load()` / `onPage()` — server-paged register (search debounce, status + category filters).
- `exportCsv()` — CSV of the visible register (UTF-8 BOM).
- `toggleTable()` / `toggleTableMax()` — region collapse / maximize.
- `openNew()` / `openEdit(row)` — company drawer (Profile / Supplier References / Documents tabs; suppliers+docs enabled after first save).
- `save()` — create/update via POST/PUT companies (validation errors surfaced in-drawer).
- Supplier references: `supNew()` / `supEdit(s)` / `supPick(lovItem)` (type-ahead over the Fusion supplier extract, auto-fills bank details) / `supSave()` / `supCancel()` / `supToggleDefault()` (one default per purpose).
- Documents: `docUpload()` (raw-binary, MAX_UPLOAD_MB), `docView(d)`, `docDelete(d)`, `loadDocs()`.

## Contracts
- `load()` / `onPage()` — register (search, company, status, BU, expiring ≤60d filters).
- `exportCsv()`, `toggleTable()`, `toggleTableMax()`.
- `openNew()` / `openEdit(row)` / `openVersion(v)` — drawer (Details / Margin Rules / Documents tabs) with amendment-chain version chips.
- `save()` — create/update; company's active supplier refs feed the site-scope select.
- `amend()` — clone as next version (new draft), old version → SUPERSEDED.
- Margin rules: `mrNew()` / `mrEdit(m)` / `mrSave()` (overlap per scope rejected server-side) / `mrCancel()` / `mrToggleVat()`.
- `toggleExpiryBlocking()`, documents as on Companies (source type PAY_CONTRACT).

## DCT Bank Accounts
- `load()`, `openNew()` / `openEdit(row)`, `save()`, `toggleActive()`.

## API Endpoints (ORDS — pay.rest, /ords/admin/pay/)
| Method | Path | Purpose |
|---|---|---|
| GET | boot | Identity flags + PAY_* lookups + banks |
| GET | stats | Overview KPIs + expiring contracts (top 10) |
| GET | companies | Paged register (search/status/cat/limit/offset) |
| POST | companies | Create company (PAY_ADMIN) |
| GET | companies/:id | Company + supplier refs + contracts summary |
| PUT | companies/:id | Update company (PAY_ADMIN) |
| POST | companies/:id/suppliers | Add supplier reference (validated vs ATD_SUPPLIERS) |
| PUT | suppliers/:sid | Update supplier reference |
| GET | contracts | Paged register (search/companyid/status/bu/expiring) |
| POST | contracts | Create contract (PAY_ADMIN) |
| GET | contracts/:id | Contract + margin rules + version chain |
| PUT | contracts/:id | Update contract |
| POST | contracts/:id/amend | Clone as next version; old → SUPERSEDED |
| POST | contracts/:id/margin-rules | Add margin rule (overlap-guarded) |
| PUT | margin-rules/:rid | Update margin rule |
| GET | banks | DCT funding bank accounts |
| POST | banks | Create bank (PAY_ADMIN) |
| PUT | banks/:id | Update bank (PAY_ADMIN) |
| GET | lov/suppliers?search= | Type-ahead over ATD_SUPPLIERS (top 30, primary bank row) |
| GET | docs?type=&id= | Documents of a company/contract (DCT_DOCUMENTS, module PAY) |
| PUT | docs?type=&id=&file_name=&mime_type= | Raw-binary upload (PAY_ADMIN, MAX_UPLOAD_MB → 413) |
| DELETE | docs/:docId | Soft-delete a document (PAY_ADMIN) |
| GET | docs/:docId/file | Media download |

## Services / Data layer
| Service | Role |
|---|---|
| `services/payService.js` | The ONE client for /pay/ (register, drawers, LOV, docs) |
| `services/api.js` | Re-export of shared fetch wrapper (Bearer + 401 redirect) |
| `services/authService.js` | Session reader (Admin JET writes the session) |
| `services/config.js` | apiBase /pay · authBase /dct |
| Server | `DCT_PAY_PKG` (validated writes + renewal sweep) · `DCT_PAY_RENEWAL_JOB` daily 07:20 UTC |
