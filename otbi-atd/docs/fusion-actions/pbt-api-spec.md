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
