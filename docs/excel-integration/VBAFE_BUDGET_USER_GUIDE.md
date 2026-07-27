# Excel Budget Override — Oracle Visual Builder Add-in for Excel (VBAFE)

**Live since 2026-07-27.** End users maintain a **BUDGET_USER** figure (their own
override of the Fusion budget) for every project budget line **directly inside
Microsoft Excel**, over the new `xl.rest` ORDS module. Server side is
`db/v2/106_xl_budget.sql` + `db/v2/107_xl_budget_ords.sql`.

---

## 1. Architecture (why there is no column on ATD_PROJECTS_BUDGET)

`ATD_PROJECTS_BUDGET` is reloaded from Fusion — the daily *Projects Budget Full*
job is TRUNCATE_INSERT **with the real table as its stage**, so a user-typed
column there would be **wiped every day**. The user figure therefore lives in:

| Object | Purpose |
|---|---|
| `PROD.DCT_PROJECT_BUDGET_USER` | The override rows. PK = the extract natural key (`project_id, task_id, expenditure_type, accounting_period` — verified unique, no NULL periods). Reload-proof by construction. |
| `PROD.DCT_PROJECT_BUDGET_XL_V` | What Excel sees: every `ATD_PROJECTS_BUDGET` row joined to `ATD_PROJECTS` / `ATD_TASKS` (project & task number + name) and to the override. Also usable from SQL/reports. |
| `PROD.DCT_XL_PKG` | Basic-auth validation, opaque `row_id` codec, list/item emission, save logic. |
| ORDS module `xl.rest` at `/ords/admin/xl/` | The Excel-facing API (below). |

The row identity Excel carries is `row_id` — an opaque url-safe encoding of the
natural key, so the API needs no surrogate table and is always current.

`BUDGET_USER` is **not yet used by any report or the Budget Utilization view**
— wiring it into `DCT_BUDGET_UTILIZATION_V` / GL pages is a separate, conscious
change when the business asks for it.

## 2. API

Base: `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl/`

| Route | Behaviour |
|---|---|
| `GET openapi` | Public, metadata-only: the hand-authored OpenAPI 3.0 description the Excel add-in consumes (full BudgetRow schema, `readOnly` on every field except `budget_user`, PUT body schema). **This is the URL to give the add-in** — the built-in `/ords/admin/open-api-catalog/xl/` is useless for it: ORDS cannot derive field schemas for a custom PL/SQL module, so the add-in "finds 1 business object" but lists nothing to select. |
| `GET budget/` | Budget rows (single page, default limit 10000). **`?year=` and `?period=` (MM-YYYY) are MANDATORY — 400 without both** (business rule 2026-07-27: users must pick a Budget Year and Accounting Period before downloading). Optional `?search=` `?limit=` `?offset=`. Row identity field is `id` (opaque; matches the `{id}` path parameter so the add-in can pair collection and item paths). |
| `GET budget/:id` | One row. |
| `PUT budget/:id` | Body `{"budget_user": <number\|null>}`. Number = set/replace the override (row stamped with the signed-in user + Dubai time). **null / blank = clear** (override row deleted). Every other field in the body is ignored — `budget_user` is the ONLY writable field, enforced server-side. |
| POST / DELETE | **Do not exist** → HTTP 405. Users cannot create or delete budget rows from Excel. |

**Auth = HTTP Basic with normal i-Finance credentials** (the only scheme VBAFE
supports for ORDS). The module carries no ORDS privilege; `DCT_XL_PKG`
validates the `Authorization: Basic` header itself against `DCT_USERS`
(**`auth_method='DB'`, active users only** — LDAP/SAML placeholder accounts are
rejected because `dct_auth` cannot verify their passwords). Success is silent;
failures are audit-logged via `dct_auth.authenticate`. No database accounts are
ever given to end users. Missing/invalid credentials → `401` +
`WWW-Authenticate: Basic` (that challenge is what makes Excel prompt for login).

Currently **any active DB-auth user may read and update**. To tighten later,
add a role/privilege check in `DCT_XL_PKG.require_user` (or `save_item`) — e.g.
`dct_auth.has_role` or a Security Console `DCT_SEC.has_priv` gate.

## 3. Building the Excel workbook (one-time, on Windows)

Prerequisites: **Windows desktop Excel** (Microsoft 365 or 2016+; the add-in
does not run on Mac or Excel on the web) + the
**Oracle Visual Builder Add-in for Excel** (free download from oracle.com —
search "Visual Builder Add-in for Excel"; current 4.x MSI, needs .NET).

1. New blank workbook → **Oracle Visual Builder** ribbon tab → **Designer**.
2. Choose **REST Service** and paste the **service description URL**:
   `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl/openapi`
   (NOT the `open-api-catalog` URL — that auto-generated document has no field
   schemas for a custom module, so the wizard reports one business object but
   shows nothing to select.)
3. Authentication: **Basic** → sign in with your i-Finance username/password.
4. Pick the **/budget/** collection → create a **Table Layout** on the sheet.
5. In the **Layout Designer**:
   - The OpenAPI document already flags every field **readOnly except
     `budget_user`**, so the add-in should pre-configure the columns; verify in
     the Business Object Field Editor and adjust if needed. The server ignores
     other fields anyway — the flags just give users the right visual
     affordance.
   - **Disable Create and Delete** for the layout (no POST/DELETE handlers
     exist, so the add-in cannot use them regardless).
   - Optional: retitle headers (e.g. `budget_user` → "User Budget") and hide
     `row_id`.
6. **Mandatory download filter** (Layout Designer → Download tab): the OpenAPI
   marks `budget_year` and `accounting_period` as required query parameters —
   the names deliberately MATCH the row fields so the add-in's **Search** form
   ("Budget Year equals … AND Accounting Period equals …") transmits them
   directly. Either use that Search (prompts at every download), or add two
   **Download Parameters** named exactly `budget_year` (e.g. 2026) and
   `accounting_period` (MM-YYYY, e.g. 01-2026). The server also accepts the
   short names `year`/`period`, and rejects any download without both filters
   (HTTP 400), so the rule cannot be bypassed.
7. **Download Data** → the selected year/period rows appear. Edit `BUDGET_USER` cells → **Upload
   Changes**. The add-in PUTs one request per changed row and writes the
   per-row result into its Status column. Blank the cell + upload = clears the
   override.
7. Save the workbook — the service configuration travels inside it. Distribute
   the file to end users (or use the ribbon's **Publish** to lock the design);
   each user signs in with their own i-Finance credentials on first use.

Known VBAFE/ORDS quirks (Oracle-documented): a successful create can be
mis-reported ("Create Failed") — not applicable here since create is disabled;
PUT on ORDS AutoREST behaves as upsert — also not applicable, our custom PUT
returns 404 for unknown rows.

## 3b. Template repository + GL integration (2026-07-27)

The workbook is now managed in the platform **VB template repository**
(`db/v2/108`: `DCT_XL_TEMPLATE`/`_VERSION` — one repo for EVERY VBAFE process;
each version stores BOTH the unpublished **master** (admin-only) and the
**published** end-user copy; exactly ONE version is active per template):

- **End users** download the active published workbook from the GL Budget
  Utilization page ("Budget Override from Excel" region → Download Excel
  Template) or `GET /ords/admin/xl/templates/download?code=BUDGET_OVERRIDE`
  (bearer session). Masters and inactive versions are SYS_ADMIN-only.
- **Admins** manage templates in **ATD (OTBI Loader) → VB Templates**: create
  processes, add versions, upload master/published files, activate, download,
  delete inactive versions.
- **GL page:** "Consider Override Budget = Y/N" checkbox (default N) — when Y
  every budget figure and all butil reports take `NVL(budget_user, budget)`;
  separate **Override Budget KPI** (always shows entered overrides + line
  count) with a drawer listing each overridden period row (fusion vs override,
  who/when) and **in-place editing** (`POST /gl/butil/override`).

## 4. The distributable template

`docs/excel-integration/iFinance_Budget_Override_Template.xlsx` — the styled
workbook to hand to end users (generated 2026-07-27 from the user-built
`Project Budget Overrid.xlsx`, kept alongside as the unstyled master):

- **Instructions** sheet first (EN + AR): sign-in, mandatory Budget Year +
  Accounting Period, edit-the-gold-column, upload, status check, color legend.
- **Xl Budget** grid: green brand header, gold **Override Budget** header +
  soft-gold column wash (conditional formatting to row 3000, so it survives
  add-in rewrites at any row count), zebra banding on the data area, frozen
  header row, `#,##0.00` on both amount columns, hidden **Key** column.
- Regenerate after any layout re-publish from Excel with
  `python3 style_template.py "<source>.xlsx" iFinance_Budget_Override_Template.xlsx`.
- **Why scripting this is safe:** this VBAFE version stores its config in six
  `veryHidden` `_VBCS_*`/`_VBAFE_*` sheets + 2 custom doc properties — all
  standard parts that openpyxl 3.1.5 preserves (it re-encodes shared strings
  inline; Excel and the add-in read them identically). No `customXml` parts
  are involved. Verified: config blobs + sheet states + props survive the
  round-trip byte-checked.

## 5. Operations

- **Re-run rules:** `xl.rest` is its own ORDS module — re-runs of `db/v2/11`
  do NOT touch it. 106 and 107 are both rerunnable (107 in a **fresh** SQLcl
  session, synonym rule). No `dct_views_rebuild` involvement: nothing was added
  to any `ATD_*` table.
- **db/v2/50 module gate:** not applicable — the `xl` handlers never call
  `dct_rest.validate_session`; auth is self-contained (documented in 107's
  header).
- **Deployed + verified 2026-07-27:** curl battery 11/11 — 401+challenge /
  bad-password 401 / list+item 200 with all columns / PUT set + clear +
  non-numeric 400 / bogus id 404 / POST+DELETE 405 / OpenAPI catalog 200.
- Overrides survive extract reloads by design; if a budget line disappears
  from Fusion, its override row simply stops joining (harmless orphan; clean up
  with a DELETE on `DCT_PROJECT_BUDGET_USER` if ever desired).
