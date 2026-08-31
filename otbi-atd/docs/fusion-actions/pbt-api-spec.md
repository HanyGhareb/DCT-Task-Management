# Project Budget Transactions (PBT) — API reference

Sanitised reference for the **Project Budget Transactions** VBCS application
(`ADG_FIN / adg_fin_pbt_view_app`), derived from two browser HAR captures taken
2026-08-16 and verified live against worker VM `atd-vm180` the same day.

**No credentials, cookies or session tokens are recorded here.** The HARs the
spec was derived from carried live session material and were deleted after
extraction.

---

## 1. What this actually is

The VBCS page is a thin client. Every data call goes to a **plain ORDS REST
service**:

```
https://apex.aderp.addigital.gov.ae/ords/dge_custom/extn/fin010/Budgets/...
```

The browser never talks to that host directly — it calls the **VBCS proxy**,
which authenticates to ORDS *server-side* (visible as `vb-proxy-header-
authentication` in the response `Server-Timing` header). The ORDS credential is
held by VBCS and is **not obtainable from the browser**.

Proxy URL prefix (everything below is appended to this):

```
https://oic-vbcs-dge-oic-prod-vb-axsqv5rxfcdo.builder.me-abudhabi-2.ocp.oraclecloud29.com
  /ic/builder/rt/ADG_FIN/0.1;profile=prod_configuration
  /services/auth/1.1/proxy/finance-ords-services
  /uri/https/apex.aderp.addigital.gov.ae/ords/dge_custom/extn/fin010/Budgets
```

App entry point (must be loaded once to establish the session):

```
https://oic-vbcs-dge-oic-prod-vb-axsqv5rxfcdo.builder.me-abudhabi-2.ocp.oraclecloud29.com
  /ic/builder/rt/ADG_FIN/0.1/webApps/adg_fin_pbt_view_app/
```

### Access route (decided 2026-08-16)

* **Route A — ADB calls ORDS directly.** Ruled out by the user: the `dge_custom`
  ORDS credential is not available to us.
* **Route B — worker VM through the VBCS proxy. IN USE.** A worker's *existing*
  Fusion SSO session already covers the VBCS host: opening the app URL with the
  saved `auth_state_FUSION_ADGOV.json` lands on the app (title
  `Project GL Budgets`) with **no sign-in redirect and no MFA push**. The three
  endpoints are then called with `fetch(..., {credentials:'include'})` from the
  page context — JSON in, JSON out, **no DOM scraping**.

> Verified 2026-08-16 on atd-vm180 using a fresh context built from the saved
> `storage_state` (never the live Chromium profile, so a running worker is
> undisturbed).

---

## 2. Endpoints

### 2.1 Master — `GET /Transactions`

| Parameter | Required | Notes |
|---|---|---|
| `bu_arr` | yes | JSON **array** of business-unit names, URL-encoded |
| `p_transaction_type` | yes | `Additional` \| `Estimated-Cost` \| `Annual-Budget` (**hyphenated** — unhyphenated guesses silently return 0 rows) |
| `p_business_unit` | **no** | Single BU. **Omit it to get every BU in `bu_arr` in one call.** |
| `p_transaction_date` | **no** | `YYYY-MM-DD`. **Omit it to get the entire dataset in one call.** |

Response is an ORDS envelope: `{items:[…], hasMore, limit, offset, count, links}`.

**`limit` / `offset` are ignored** by this handler (`limit` always echoes `0`,
`hasMore` always `false`) — there is no pagination to drive; the full result set
arrives in one body.

`p_trx_year` is *recognised but filters to zero rows* in every form tried — do
not use it. `p_date_from` / `p_date_to` are silently ignored (they return the
unfiltered set), so **there is no server-side date range**: pull everything and
filter client-side, or call once per day.

### 2.2 Lines — `GET /Transactions/{type}/{transaction_num}/lines`

`{type}` is the same hyphenated value (`Additional`, `Estimated-Cost`,
`Annual-Budget`). Returns a bare `{items:[…]}` — **no** `count`/`hasMore`.

Measured cost: **~0.11 s per call**, max 29 lines seen on one transaction.

### 2.3 Approval trail — `GET /Transactions/ApprovalHistory`

| Parameter | Notes |
|---|---|
| `transaction_id` | the **`transaction_num`** (e.g. `012185`), not `identifier` |
| `trx_type` | hyphenated type |

⚠ **The response rows carry no transaction identifier of their own** — the
caller must stamp `transaction_num` onto each row when storing.

### 2.4 Other (not used by the extract)

* `GET /getCostCenter?p_organization_id=…` — cost-centre LOV
* `GET …/bu/projType`, `GET …/url/Apex` — LOV / config lookups

---

## 3. Measured volumes (2026-08-16)

| Type | Rows | Year span | Business units |
|---|---|---|---|
| `Additional` | 1,132 (DCT only) | 2026-01-20 → 2026-08-16 | +193 MSS, +16 AFH |
| `Estimated-Cost` | 519 (all BUs) | 2026 only | DCT 409 · MSS 93 · AFH 17 |
| `Annual-Budget` | 327 (all BUs) | **2014 → 2025** | DCT 321 · AFH 6 |

`Additional` statuses: Baselined 1,046 · Entered 73 · Baselining Failed 11 ·
Pending Approval 1 · Rejected 1.

**Full master pull ≈ 10 s; all child line calls ≈ 2.2 min.** A complete refresh
of a type is a ~3-minute job — no incremental windowing needed for correctness.

Business units seen in `bu_arr`: `Department of Culture and Tourism`,
`Abrahamic Family House`, `Museum Shared Services`, `AFH Ledger`, `DCT Ledger`,
`AFH_MB`, `DCT_MB`, `DCT_YB`, `AFH_YB`. Only the first three return rows; the
rest are placeholders.

---

## 4. Field inventory

### 4.1 Header — **identical 20 fields for all three types**

This is what makes one shared header table viable; the payload already carries
`transaction_type` as a discriminator.

| Field | Type | Note |
|---|---|---|
| `identifier` | number | **surrogate PK** — stable, use as the MERGE key |
| `transaction_num` | text | the business document number, e.g. `012185` |
| `project_type` | text | e.g. `DCT OPEX Project Type` |
| `status` | text | Baselined / Entered / Baselining Failed / Pending Approval / Rejected |
| `transaction_date` | date `YYYY-MM-DD` | the filter/search date |
| `trx_year` | text(4) | |
| `dept_1st_level_approver` | text | email, or `FSCM_DATA` for migrated rows |
| `business_unit` | text | |
| `transaction_type` | text | `Additional` etc. |
| `decree_no` | text | e.g. `DCT-QH-3078-2026` |
| `organization` | text | |
| `project_num`, `project_name`, `project_num_1`, `project_id` | null in every sample | header-level project fields are unpopulated |
| `project_approved_cost`, `project_estimated_cost`, `project_total_cost` | number | 0 for `Additional` |
| `changein_duration` | text(1) | |
| `creation_date` | **`DD-MM-YYYY`** | ⚠ different format from `transaction_date` |

### 4.2 Lines — **the shape DIFFERS per type**

| | `Additional` | `Estimated-Cost` | `Annual-Budget` |
|---|---|---|---|
| field count | **34** | **21** | **38** |

Common to all three: `identifier` (**PK**), `transaction_num`, `project_num`,
`project_name`, `task_num`, `task_name`, `expenditure_type`, `cost_center`,
`notes`, `created_by`, `last_updated_by`, `creation_date`, `last_updated_date`,
`baseline_status`, `baseline_error`, `transaction_line_error`,
`gl_funds_available`, `code_combination`.

**`Additional` only:** `additional_amount`, `total_annual_budget`,
`fund_available`, `current_annual_budget`, `approved_annual_budget`,
`revised_project_cost`, `total_actual`, `previous_year_actual`,
`current_year_actual`, `commitments`, `acc_annual_budget`, `period_from`,
`period_to`, `validation_status`, `jv_status`, `line_status`.

**`Estimated-Cost` only:** `estimated_cost`, `current_year_budget`,
`line_status`.

**`Annual-Budget` only:** `project_phase`, `estimated_task_cost`,
`variation_task_cost`, `approved_task_cost`, `previous_year_budget`,
`current_year_budget`, `approved_budget`, `proposed_budget`,
`available_project_cost`, `attachment`.

### 4.3 Approval history — 9 fields

`submitter_name`, `trx_type`, `assignee_username`, `assignment_state`,
`creation_date` (ISO timestamp `…Z`), `change_amount` (Y/N), `view_amount`
(Y/N), `priority` (number), `dept_1st_level_approval_flag` (Y/N).

---

## 4b. The FULL fin010 surface — what else the service exposes

Discovered 2026-08-17 from the ORDS **OpenAPI catalog**
(`/ords/dge_custom/open-api-catalog/extn/`, 194 KB, OpenAPI 3.0.0, 175 paths of
which **29 are fin010**). The plain `metadata-catalog` does NOT publish methods —
only the OpenAPI document does. Read-only discovery; **no write was ever issued**.

### Write-capable endpoints (9)

| Path | Methods | What it plainly is |
|---|---|---|
| `/fin010/Budgets/Transactions` | GET, **POST** | create a transaction header |
| `/fin010/Budgets/Transactions/{p_trx_type}/lines` | **POST** | create detail lines |
| `/fin010/Budgets/Transactions/attachments` | GET, **POST** | attachments |
| `/fin010/Budgets/Transactions/{p_trx_type}/attachments` | GET, **POST** | attachments per type |
| `/fin010/Budgets/Transactions/attachments/{identifier}/delete` | **DELETE** | remove an attachment |
| `/fin010/Budgets/Transactions/attachments/lines/{identifier}/delete` | **DELETE** | remove a line attachment |
| `/fin010/budget/transactions/{trx_num}/submit` | **POST** | submit for approval |
| `/fin010/budget/transactions/{trx_num}/withdraw` | **POST** | withdraw a submission |
| `/fin010/Budgets/getCostCenter` | GET, **POST** | almost certainly a query-by-POST, not a create |

### The three answers

* **CREATE — yes.** Header, lines, attachments, plus submit/withdraw workflow actions.
* **UPDATE — NO.** There is **no PUT and no PATCH anywhere in fin010**. Editing an
  existing transaction is not exposed as REST at all.
* **DELETE — attachments ONLY.** No delete endpoint exists for a transaction or a
  detail line.

### Two caveats before anyone builds on this

1. **"Create a new record on dge.extn.finance" is ORDS boilerplate**, auto-generated
   for *any* POST handler — it is not evidence of semantics. `POST getCostCenter` is
   obviously a search, not a create. Treat the verb list as authoritative and the
   summaries as noise.
2. **The payload shapes are undocumented.** These are custom PL/SQL handlers whose
   body binds as a raw string, so the OpenAPI schema is literally
   `{body: string}` — no field list (the same limitation our own `/xl/` module has).
   Building a write would need a HAR of the UI performing that exact action.

### So how do the UI's ✕ Delete and "Validate and Save" work?

They do **not** use DELETE or PUT — there are none. Both are encoded **inside the
body of a POST**, which is exactly why the OpenAPI body is an opaque
`{body: string}`. Read verbatim out of the app's own `vb-app-bundle.js` action
chains (no write was executed to learn this):

**Delete a transaction (✕ on the Transactions grid)** — chain `deleteSelectedRowData`:
1. guard `GET /fin010/checkBaselinedRecords` — refuses with *"Transaction Number
   … cannot be deleted because Journals for this transaction …"*;
2. then `POST /fin010/Budgets/Transactions` with
   ```json
   { "username": "<user>", "delete": "<transaction_num>" }
   ```

**Edit / delete detail lines ("Validate and Save", ✕ on the Details grid)** —
the ✕ (`deleteSelectedRow`) touches **no server at all**: it drops the row from
the client array and appends its `identifier` to `$application.variables.deletedRows`.
Saving then does the whole thing in ONE call — chain `saveLinesChain`:
```json
POST /fin010/Budgets/Transactions/{p_trx_type}/lines
{ "username": "<user>",
  "lines":  [ …every current line, edited and unedited… ],
  "delete": [ …identifiers removed in the UI… ] }
```

So the semantics are: **UPDATE = re-post the entire line set** (the handler
reconciles), and **DELETE = name the identifiers in the `delete` field of that
same POST**. Rows whose `identifier` starts `G_` are client-generated and never
saved, so they are excluded from `deletedRows`.

Guards the UI enforces (a server-side write would have to respect them):
`deleteableModes = Entered / Rejected / Baselining Failed`,
`attachUploadModes = Entered / Rejected / Draft`, `allowDeleteHdrRecords()` for
the header button, and `checkLineDeleteStatus()` which blocks deleting a line
once journals exist.

## 4c. The write contract — CAPTURED LIVE 2026-08-17

Confirmed end-to-end from a HAR of a real add-line → save → delete-line →
delete-header sequence performed by the user on a throwaway record. This is the
observed wire format, not inference.

**Add / edit lines** — `POST /fin010/Budgets/Transactions/{p_trx_type}/lines`
```json
{ "username": "user@dctabudhabi.ae",
  "lines": [ { …one object per line CURRENTLY in the grid… } ],
  "delete": null }
```
Response: **HTTP 200 with an EMPTY body** (no id echoed back).

A new line carries a **client-generated `identifier` prefixed `G_`**
(`"G_0811675640"`); the server assigns the real numeric id. `transaction_num`
on the line names its header. The object mixes real columns with UI-only
scratch fields that are sent verbatim — `dirtyFlag`, `disableEdits`, `rowIndex`,
`rowKey`, `taskValError`, `validationError`, `orig_revised_project_cost`.

Business fields observed on a line: `project_num`, `project_name`, `task_num`,
`task_name`, `expenditure_type`, `cost_center`, `code_combination`,
`period_from`/`period_to`, `project_start_date`/`project_end_date`,
`project_phase`, `line_status` (`"Draft"`), `notes`, and the money set
`additional_amount`, `budget_transfer`, `commitments`, `acc_annual_budget`,
`approved_annual_budget`, `current_annual_budget`, `total_annual_budget`,
`previous_year_budget`, `current_year_budget`, `approved_budget`,
`previous_year_actual`, `current_year_actual`, `total_actual`, `fund_available`,
`gl_funds_available`, `revised_project_cost`, `available_project_cost`,
`estimated_task_cost`, `approved_task_cost`, `revised_task_cost`,
`variation_task_cost`.

**Delete a line** — the SAME endpoint, with the line simply absent from `lines`
and its REAL identifier in `delete`:
```json
{ "username": "…", "lines": [], "delete": "101703" }
```
So `lines` is the full post-edit set (`tableDataADP.data`) and `delete` is a
**string**, not an array — multiple removals are concatenated into it.

**Delete a header** — `POST /fin010/Budgets/Transactions` (no DELETE verb):
```json
{ "username": "…", "delete": "006686" }     ->  {"trx_num":"006686"}
```
Preceded by the guard `GET /fin010/checkBaselinedRecords?p_transaction_num=…`,
which must answer `{"count": 0}`.

**Create a header** — the SAME endpoint, discriminated by the top-level key:
`header` = create, `delete` = delete. Captured 2026-08-17:
```json
POST /fin010/Budgets/Transactions
{ "username": "haghareb@dctabudhabi.ae",
  "header": {
    "business_unit": "Department of Culture and Tourism",
    "project_type": "DCT OPEX Project Type",
    "transaction_type": "Additional",
    "status": "Entered",
    "transaction_date": "2026-08-17",
    "trx_year": "2026-08-17",
    "creation_date": "2026-08-16T23:55:59.280Z",
    "decree_no": "000",
    "dept_1st_level_approver": "hany.abdelaal@adpic.gov.ae",
    "transaction_num": null,
    "person_id": 300000142264020,
    "user_id":   300000142708375 } }
->  {"trx_num":"012531"}
```
* `transaction_num: null` — the server assigns it and returns it as `trx_num`.
* ⚠ **`trx_year` is sent as a full DATE**, not a year (`"2026-08-17"`), even
  though the read API returns `trx_year: "2026"`. Send the date.
* `creation_date` is client-supplied, ISO-8601 with milliseconds and `Z`.
* `person_id` / `user_id` identify the chosen **approver** and come from the
  approvers LOV — they are NOT the submitting user's ids.

**Header LOVs:**
```
GET Budgets/approvers?p_business_unit_name=…[&limit=&offset=][&q=…]
    -> person_number, full_name, user_name, user_email, person_id, user_id  (1,697 rows for DCT)
GET Budgets/getCostCenter?p_organization_id=…
    -> org_name, cost_center, organization_id, organization
```
The approvers resource accepts **native ORDS filtering** — the UI's type-ahead
sends `q={"$or":[{"full_name":{"$instr":"Hany"}},{"person_number":{"$instr":"Hany"}}]}`.
That is a different query dialect from the custom handlers elsewhere in fin010.

**The LOV/validation chain a line insert depends on** (all GET):
```
annual/projects?p_business_unit=&p_cost_center=&p_project_type=   -> project_number, project_name
annual/{proj}/tasks?p_cost_center=                                -> task_number, task_name, cost_center
annual/{proj}/exp?p_cost_center=&p_task_number=                   -> expenditure_type
Budgets/{proj}/details?p_exp_name={expTypeId}&p_task_num=&p_year=  -> the budget figures that pre-fill the line
Budgets/Transactions/lines/statusValidate?exp_type=&p_transaction_num=&prj_num=  -> {"Count":"0"} = ok to add
```
Note `p_exp_name` takes the expenditure type's **numeric id** (300000004294397),
not the display string.

⚠ **Nothing here has been exercised by us.** Every figure above came from the
user's own browser session. A write action must gate on `ATD_ACTION_LIVE` like
every other Fusion write, and must respect the UI's guards (deletable only in
Entered / Rejected / Baselining Failed; `checkLineDeleteStatus` blocks a line
once journals exist).

### Read endpoints we do NOT currently use

`/additionalFunds/export` (the page's own Export) · `/Budgets/{p_proj_num}/details`,
`/{p_proj_num}/expTypedetails`, `/{p_proj_num}/{p_task_num}/details` ·
`/annual/projects`, `/annual/{proj}/tasks`, `/annual/{proj}/exp`,
`/annual/{proj}/{task}/exp` · `/project/templates`, `/project/{num}/totalCost` ·
`/checkBaselinedRecords` · `/Budgets/approvers` ·
`/Budgets/Transactions/lines/statusValidate`,
`/Budgets/Transactions/{p_trx_type}/lines/validate` ·
`/ProjectBudgetTransaction/getProjBudgGLReport`, `…/getProjBudgGLDrillDownReport` ·
`/bu/projType`, `/url/Apex`.

---

## 5. Gotchas (each cost a probe to find)

1. **Type values are hyphenated.** `Estimated-Cost`, not `Estimated Cost` or
   `Estimated`. A wrong value returns **HTTP 200 with 0 rows**, never an error.
2. **Omitting `p_business_unit` widens, not narrows** — it returns every BU in
   `bu_arr`. There is no "all" sentinel.
3. **Omitting `p_transaction_date` returns the whole dataset.** Combined with
   (2), one call gets everything for a type.
4. **`limit`/`offset` are inert.** Never assume pagination; never assume a cap
   either (1,132 rows came back in a single body).
5. **`creation_date` format varies BY TYPE**: header `DD-MM-YYYY`; `Additional`
   lines `DD-MON-YY`; `Estimated-Cost` / `Annual-Budget` lines `YYYY-MM-DD`.
   Parse defensively — never a single `TO_DATE` mask.
6. **`commitments` arrives as a STRING** (`"528250"`) while every neighbouring
   money field is a JSON number.
7. **Approval rows carry no transaction key** — stamp it from the request.
8. **`transaction_id` on ApprovalHistory means `transaction_num`**, not
   `identifier`.
9. `p_trx_year` exists but filters everything out; `p_date_from`/`p_date_to`
   are ignored. No server-side range filtering of any kind.
