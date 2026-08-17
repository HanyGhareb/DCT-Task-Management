# Excel Budget Change — Oracle Visual Builder Add-in for Excel (VBAFE)

**Live since 2026-07-27; reworked to the signed-change model 2026-08-17.**
End users post a **BUDGET CHANGE (+/-)** against a project budget line for a
chosen accounting period **directly inside Microsoft Excel**, over the
`xl.rest` ORDS module. Server side is `db/v2/106_xl_budget.sql` +
`db/v2/107_xl_budget_ords.sql`.

---

## 0. What changed in v2 (2026-08-17)

| | v1 (2026-07-27) | **v2 (now)** |
|---|---|---|
| The figure | `budget_user` — **replaced** the Fusion budget | **`budget_change`** — a **signed amount ADDED** to it (negative subtracts) |
| Sheet grain | one row per **accounting period** (12 per line) | one row per **budget line** (project × task × expenditure type) |
| Budget shown | that period's budget | **Annual Budget + YTD Budget**, plus the **Adjusted** figures |
| Download scope | year + period | year + period + **Business Unit** + **Project Type** (all four with pick-lists) |
| Clearing | blank cell | blank cell **or 0** |
| GL page effect | budget replaced where an override exists | the change is **added to Annual AND YTD Budget** |

**Breaking on purpose:** a PUT that still sends `budget_user` is rejected with
**400** naming the new workbook. A v1 workbook cannot silently write a delta
into a field that used to mean an absolute figure.

**Migration:** the 179 stored v1 rows were deleted and the column renamed
(`106.1a`, guarded — it runs exactly once). They were absolute replacements and
are meaningless as change amounts.

---

## 1. Architecture (why there is no column on ATD_PROJECTS_BUDGET)

`ATD_PROJECTS_BUDGET` is reloaded from Fusion — the daily *Projects Budget Full*
job is TRUNCATE_INSERT **with the real table as its stage**, so a user-typed
column there would be **wiped every day**. The user figure therefore lives in:

| Object | Purpose |
|---|---|
| `PROD.DCT_PROJECT_BUDGET_USER` | The change rows. PK = the extract natural key (`project_id, task_id, expenditure_type, accounting_period`). Reload-proof by construction. |
| `PROD.DCT_PROJECT_BUDGET_XL_V` | Period-grain convenience view for SQL/reporting: every `ATD_PROJECTS_BUDGET` row joined to `ATD_PROJECTS` / `ATD_TASKS` (incl. **business unit + project type**) and to the change, plus `budget_adjusted`. |
| `PROD.DCT_XL_PKG` | Basic-auth validation, opaque `row_id` codec, the line-grain query, LOVs, save logic, OpenAPI. |
| ORDS module `xl.rest` at `/ords/admin/xl/` | The Excel-facing API (below). |

The row identity Excel carries is `id` — an opaque url-safe encoding of
`project_id | task_id | period | expenditure_type`, so the API needs no
surrogate table and is always current. **The period inside the id is the period
the change is booked to.**

### The un-phased budget (why the code looks the way it does)

The Fusion budget is **not cashflow-phased**: 1,736 of the 1,779 FY2026 lines
have exactly **one** period row and 1,570 of those sit in `01-2026`. So a change
booked at `08-2026` normally has **no matching budget row at all**. Consequences,
each load-bearing:

* `save_item` validates that the **line exists in the budget year**, not that a
  budget row exists at that exact period;
* `DCT_BUDGET_UTILIZATION_V` builds its `pb` aggregate from a **`pb_src`
  UNION ALL** (budget rows contribute `budget`, change rows contribute `chg`) —
  an outer join from the budget table would silently drop those changes;
* the GL drawer (`GL/db/15`) and the budget drill (`GL/db/07`) do the same.

## 2. API

Base: `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl/`

| Route | Behaviour |
|---|---|
| `GET openapi` | Public, metadata-only: the hand-authored OpenAPI 3.0 description the add-in consumes (full `BudgetLine` schema, `readOnly` on everything except the three writable fields, live `enum` lists on the four download parameters, the `/lov/{kind}` collection). **This is the URL to give the add-in** — the built-in `/ords/admin/open-api-catalog/xl/` is useless for it: ORDS cannot derive field schemas for a custom PL/SQL module, so the add-in "finds 1 business object" but lists nothing to select. |
| `GET budget/` | One row per budget **line**. **`budget_year` + `accounting_period` (MM-YYYY) are MANDATORY — 400 without both**, and the period must belong to the year. `business_unit` defaults to **`Department of Culture and Tourism`**, `project_type` to **`DCT OPEX Project Type`** — both matched on the **exact** stored name. Short aliases `year` / `period` / `bu` / `ptype` also accepted. Optional `search`, `limit`, `offset`. |
| `GET budget/:id` | One line. |
| `PUT budget/:id` | Body `{"budget_change": <number\|null>, "reason_category"?: <code\|null>, "comments"?: <text\|null>}`. **Positive adds, negative subtracts; `null`, blank or `0` deletes the change.** `reason_category` is validated against lookup **`XL_OVERRIDE_REASON`** (System issues / Request not received / Budget reallocation / Data correction / Other; manage in Admin → Lookups; the OpenAPI ships the codes as an enum). Both classification fields are PARTIAL — only keys present in the body are applied. Sending `budget_user` → **400**. |
| `GET lov/:kind` | Pick lists: `business-units`, `project-types`, `periods` (`?budget_year=` scopes it), `budget-years`, `reasons`. Shape `{items:[{id,value,label}], count}` — the shape the add-in wants for a list of values. |
| POST / DELETE | **Do not exist** → HTTP 405. Users cannot create or delete budget rows from Excel. |

### Row shape (`BudgetLine`)

`id` · `budget_year` · `business_unit` · `project_type` · `project_number` ·
`project_name` · `task_number` · `task_name` · `expenditure_type` ·
`accounting_period` (the selected one — where a change lands) ·
**`budget_annual`** (Fusion, all periods) · **`budget_ytd`** (Fusion, periods ≤
the selected one) · **`budget_change`** *(writable)* · `reason_category`
*(writable)* · `comments` *(writable)* · `line_change_total` (all saved changes
on the line) · `adjusted_annual` · `adjusted_ytd` · `budget_change_updated_by` ·
`budget_change_updated_at`.

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

### Scope note — Abrahamic Family House

`business_unit=Abrahamic Family House` currently returns **0 lines**: all 45 AFH
budget lines reference task ids that are **absent from the `ATD_TASKS` extract**,
so they are excluded here exactly as they are excluded from the GL Budget
Utilization page (platform rule: a missing master = cancelled, `task_key`
`'#…'`). Widening the tasks extract to AFH would light both up together.

## 3. Rebuilding the workbook (one-time, on Windows) — REQUIRED for v2

Prerequisites: **Windows desktop Excel** (Microsoft 365 or 2016+; the add-in
does not run on Mac or Excel on the web) + the **Oracle Visual Builder Add-in
for Excel**. The v5.0 current-user MSI (no admin rights needed) is hosted in the
template repository as template code **`VBAFE_ADDIN`** — end users get it from
the GL butil page ("Change the budget in bulk from Excel" panel → "Add-in not
installed?"), or `GET /ords/admin/xl/templates/download?code=VBAFE_ADDIN`.

> **The v2 layout cannot be generated outside Excel.** The API, the GL page and
> the styling script are v2 already; until the workbook below is rebuilt and
> published, the distributed workbook still shows the v1 columns and its uploads
> fail with the `budget_user` 400.

1. ATD → **VB Templates** → download the **master** of `BUDGET_OVERRIDE`.
2. Open it → **Oracle Visual Builder** ribbon → **Manage Catalogs** → refresh
   the catalog from
   `https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl/openapi`
   (NOT the `open-api-catalog` URL). Authentication: **Basic**.
3. **Layout Designer → Columns**: the business object now exposes the v2 fields.
   Show `business_unit`, `project_type`, `project_number/name`,
   `task_number/name`, `expenditure_type`, `accounting_period`,
   **`budget_annual`**, **`budget_ytd`**, **`budget_change`** (editable),
   `reason_category` (editable), `comments` (editable), `line_change_total`,
   `adjusted_annual`, `adjusted_ytd`, the two `…updated_…` fields; hide `id`.
   The OpenAPI already flags everything except the three writable fields
   `readOnly`, so the add-in pre-configures them.
4. **Disable Create and Delete** for the layout (no POST/DELETE handlers exist).
5. **Download parameters + their lists** — the four parameter names deliberately
   MATCH the row fields, so the add-in's **Search** form ("Budget Year equals …
   AND Accounting Period equals … AND Business Unit equals … AND Project Type
   equals …") transmits them directly:
   * each parameter's OpenAPI schema carries a live **`enum`**, which the add-in
     renders as a drop-down;
   * for a searchable list instead, configure a **List of Values** on the search
     field against the `/lov/{kind}` business object (identity field `id`,
     display field `label`).
6. **Publish**, save the workbook, then re-style it:
   `python3 style_template.py "<saved>.xlsx" iFinance_Budget_Override_Template.xlsx`
   (the script resolves columns by **header text**, so it follows whatever
   layout you published; it warns if no *Budget Change* column is present).
7. Upload BOTH files (master + published) as **version 2** of `BUDGET_OVERRIDE`
   in ATD → VB Templates and **Activate** it.

Known VBAFE/ORDS quirks (Oracle-documented): a successful create can be
mis-reported ("Create Failed") — not applicable here since create is disabled;
PUT on ORDS AutoREST behaves as upsert — also not applicable, our custom PUT
returns 404 for an unknown line.

## 3b. Template repository + GL integration

The workbook is managed in the platform **VB template repository**
(`db/v2/108`: `DCT_XL_TEMPLATE`/`_VERSION` — one repo for EVERY VBAFE process;
each version stores BOTH the unpublished **master** (admin-only) and the
**published** end-user copy; exactly ONE version is active per template):

- **End users** download the active published workbook from the GL Budget
  Utilization page (Budget Change drawer → "Download the Excel template") or
  `GET /ords/admin/xl/templates/download?code=BUDGET_OVERRIDE` (bearer session).
  Masters and inactive versions are SYS_ADMIN-only.
- **Admins** manage templates in **ATD (OTBI Loader) → VB Templates**.
- **GL page:** the **"Select to include Budget Override"** checkbox (default
  off) — when on, every budget figure on the page and in all butil reports has
  the signed change **added** (Annual Budget, YTD Budget, Fund Available,
  Utilization). A change counts in YTD from **its own accounting period**
  onward. The separate **Budget Change (+/-)** KPI tile always shows the net
  change and the changed-line count, and opens a drawer listing each change
  (Annual/YTD Fusion budget, the signed change, Adjusted Annual/YTD, reason,
  comments, who/when) with **in-place editing** (`POST /gl/butil/override`,
  body field `budget_change`).

## 4. The distributable template

`docs/excel-integration/iFinance_Budget_Override_Template.xlsx` — the styled
workbook handed to end users, generated by `style_template.py` from the
workbook saved out of Excel (kept alongside as the unstyled master):

- **Instructions** sheet first (EN + AR): sign-in, the four download parameters,
  the +/- rule, "blank or 0 clears", upload, status check, colour legend.
- **Xl Budget** grid: green brand header, **gold Budget Change header + soft
  gold column wash** with the typed value bold red when negative / green when
  positive, blue **Adjusted** columns, zebra banding on the read-only area,
  frozen header row, `#,##0.00` on every amount, hidden key column.
- **Why scripting this is safe:** this VBAFE version stores its config in six
  `veryHidden` `_VBCS_*`/`_VBAFE_*` sheets + 2 custom doc properties — all
  standard parts that openpyxl 3.1.5 preserves. No `customXml` parts are
  involved. Verified: config blobs + sheet states + props survive the
  round-trip byte-checked.

## 5. Operations

- **Re-run rules:** `xl.rest` is its own ORDS module — re-runs of `db/v2/11` do
  NOT touch it. 106 and 107 are both rerunnable (107 in a **fresh** SQLcl
  session, synonym rule). No `dct_views_rebuild` involvement: nothing was added
  to any `ATD_*` table.
  **A re-run of `106` invalidates `DCT_BUDGET_UTILIZATION_V` and its dependants
  only if the table shape changes; the 2026-08-17 rename did — deploy order was
  106 → 107 → `db/v2/37` → `GL/db/07` + `GL/db/15`, then recompile to 0 INVALID.**
- **db/v2/50 module gate:** not applicable — the `xl` handlers never call
  `dct_rest.validate_session`; auth is self-contained (documented in 107's header).
- **Verified 2026-08-17:** API battery 40/41 (the one "failure" was the test's
  own expectation for AFH, see the scope note) + GL end-to-end 18/18 +
  SQL reconciliation (ovr flag a no-op with no changes; annual and YTD both move
  by the change; a change at a period with no budget row still counts; YTD
  excludes it before its period) + browser smoke `final apps/GL/tests/
  butil_change_browser_smoke.py` **31/31** EN + AR/RTL.
- Changes survive extract reloads by design; if a budget line disappears from
  Fusion, its change row simply stops joining (harmless orphan; clean up with a
  DELETE on `DCT_PROJECT_BUDGET_USER` if ever desired).
