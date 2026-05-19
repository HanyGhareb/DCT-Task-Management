# AI-Assisted Clearing & Reimbursement — Full Implementation Plan

## 1. Overview

```
User opens existing Expense Report (DRAFT)
       │
       ▼ clicks "Extract Lines from Documents"
[APEX Page 71] ──► [ORDS /extract endpoint]
                           │
                           ▼
                  [PL/SQL PCH_AI_PKG]
                  calls Anthropic API
                  (APEX_WEB_SERVICE)
                           │
                           ▼
                  Returns JSON: extracted items
                           │
                           ▼
[APEX Page 71] displays extracted items table
+ validation: Rule 1 (duplicate ref#)
+ validation: Rule 2 (date within 3 months)
                           │
                    ┌──────┴──────┐
               VALID items     INVALID items
                    │              │
               Inserted as     Shown with
               expense report  reason; user
               lines           edits or removes
                    │
                    ▼
         User submits Expense Report
         → existing approval workflow
```

---

## 2. Database Schema (PROD schema)

### 2.1 Three New Tables

#### Request Header — `PROD.PCH_AI_CLEAR_REQUESTS`

| Column | Type | Notes |
|---|---|---|
| `request_id` | NUMBER (identity) | PK |
| `request_num` | VARCHAR2(30) | Unique, e.g. `CLR-2026-00045` |
| `expense_report_id` | NUMBER | FK → existing EXPENSE_REPORTS — links AI lines to the report being cleared |
| `request_type` | VARCHAR2(20) | `CLEARING` or `REIMBURSEMENT` |
| `employee_num` | VARCHAR2(20) | NOT NULL |
| `employee_name` | VARCHAR2(200) | |
| `department` | VARCHAR2(200) | |
| `status` | VARCHAR2(30) | `DRAFT` \| `SUBMITTED` \| `APPROVED` \| `REJECTED` |
| `total_amount_aed` | NUMBER(15,2) | |
| `notes` | VARCHAR2(4000) | |
| `source_files` | CLOB | JSON array of uploaded file names |
| `ai_raw_response` | CLOB | Full Anthropic API response (audit trail) |
| `created_by` | VARCHAR2(100) | |
| `created_at` | TIMESTAMP | Default SYSTIMESTAMP |
| `updated_by` | VARCHAR2(100) | |
| `updated_at` | TIMESTAMP | Maintained by trigger |

#### Expense Line Items — `PROD.PCH_AI_CLEAR_LINES`

| Column | Type | Notes |
|---|---|---|
| `line_id` | NUMBER (identity) | PK |
| `request_id` | NUMBER | FK → PCH_AI_CLEAR_REQUESTS |
| `line_num` | NUMBER | Line ordering |
| `item_name` | VARCHAR2(500) | Extracted expense description |
| `category` | VARCHAR2(100) | Mapped to approved category list |
| `expense_date` | DATE | Date on receipt/invoice |
| `amount` | NUMBER(15,2) | Original amount |
| `currency` | VARCHAR2(10) | ISO 4217, default `AED` |
| `amount_aed` | NUMBER(15,2) | AED equivalent |
| `vendor_name` | VARCHAR2(500) | Shop/vendor name |
| `reference_number` | VARCHAR2(200) | Invoice no., order no., barcode |
| `validation_status` | VARCHAR2(20) | `VALID` \| `INVALID` \| `NEEDS_REVIEW` \| `PENDING` |
| `validation_errors` | VARCHAR2(1000) | JSON array of error codes |
| `is_included` | VARCHAR2(1) | `Y`/`N` — user can exclude a line |
| `ai_confidence` | NUMBER(3) | 0–100 confidence score from AI |
| `source_file` | VARCHAR2(500) | Which uploaded file this came from |
| `created_at` | TIMESTAMP | Default SYSTIMESTAMP |

#### Reference Number Registry — `PROD.PCH_AI_USED_REFERENCES`

| Column | Type | Notes |
|---|---|---|
| `ref_id` | NUMBER (identity) | PK |
| `reference_number` | VARCHAR2(200) | NOT NULL |
| `vendor_name` | VARCHAR2(500) | |
| `line_id` | NUMBER | FK → PCH_AI_CLEAR_LINES |
| `request_id` | NUMBER | FK → PCH_AI_CLEAR_REQUESTS |
| `employee_num` | VARCHAR2(20) | |
| `registered_at` | TIMESTAMP | Default SYSTIMESTAMP |
| — | UNIQUE | `(reference_number, vendor_name)` |

### 2.2 Supporting Objects

```sql
-- Sequence for human-readable request numbers
CREATE SEQUENCE PROD.PCH_CLEAR_REQ_SEQ START WITH 1;

-- Fast lookup for duplicate reference check
CREATE INDEX PROD.idx_pch_refs_refnum ON PROD.PCH_AI_USED_REFERENCES(reference_number);

-- updated_at trigger on PCH_AI_CLEAR_REQUESTS (same pattern as DCT_ tables)
```

### 2.3 Expense Category List (LOV / Seed Data)

14 approved categories:

1. Meals & Entertainment
2. Transport & Travel
3. Accommodation
4. Office Supplies
5. IT Equipment
6. Communication
7. Maintenance & Repair
8. Training & Development
9. Medical
10. Utilities
11. Postage & Courier
12. Marketing
13. Professional Services
14. Other

---

## 3. PL/SQL Package: `PROD.PCH_AI_PKG`

### 3.1 Public API

| Procedure / Function | Purpose |
|---|---|
| `extract_expenses(p_file_blob, p_mime_type, p_file_name)` | Calls Anthropic API; returns extracted items as JSON |
| `validate_lines(p_request_id)` | Runs both validation rules on all lines; updates `validation_status` |
| `validate_single(p_ref_num, p_vendor, p_expense_date, p_line_id)` | Returns validation result + error codes for one line |
| `submit_request(p_request_id)` | Sets status = SUBMITTED; registers all valid ref#s in `PCH_AI_USED_REFERENCES` |
| `generate_request_num` | Returns next `CLR-YYYY-NNNNN` string |
| `save_request(...)` | Create or update request header |
| `save_line(...)` | Create or update a single expense line |
| `delete_line(p_line_id)` | Remove a line from a DRAFT request |
| `get_request_json(p_request_id)` | Returns full request + all lines as JSON (consumed by ORDS) |

### 3.2 Anthropic API Call Pattern

```sql
-- API key stored in APEX Application Settings (encrypted) — never in code
v_api_key := apex_application.get_preference('ANTHROPIC_API_KEY');

-- POST to Anthropic Messages API
apex_web_service.make_rest_request(
    p_url         => 'https://api.anthropic.com/v1/messages',
    p_http_method => 'POST',
    p_body        => build_extraction_payload(p_file_blob, p_mime_type),
    p_parm_name   => apex_t_varchar2('anthropic-version', 'x-api-key', 'content-type'),
    p_parm_value  => apex_t_varchar2('2023-06-01', v_api_key, 'application/json')
);
```

> **ADB Network Prerequisite:** Requires `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` grant for `api.anthropic.com` on the ADB instance.

**Model:** `claude-haiku-4-5-20251001` — fast and low-cost for extraction tasks.

### 3.3 Extraction Prompt

```
You are a financial document parser. Extract ALL expense line items from the document.
Return ONLY a JSON array — no explanation, no markdown, no surrounding text.

Each object must have exactly these keys:
  "item_name"        - expense description
  "category"         - closest match from approved list (see below)
  "expense_date"     - format YYYY-MM-DD, or null if unreadable
  "amount"           - number, or null if unreadable
  "currency"         - ISO 4217 code (e.g. AED, USD), default "AED"
  "vendor_name"      - shop or vendor name
  "reference_number" - invoice number, order number, or barcode; null if absent

Approved categories: Meals & Entertainment, Transport & Travel, Accommodation,
Office Supplies, IT Equipment, Communication, Maintenance & Repair,
Training & Development, Medical, Utilities, Postage & Courier,
Marketing, Professional Services, Other

If a field is genuinely unreadable, use null. Never invent or guess data.
```

---

## 4. ORDS API Endpoints

All endpoints under module `/ords/admin/pch/` (extend existing ADB ORDS module):

| Method | Path | Package Call | Notes |
|---|---|---|---|
| `POST` | `/pch/ai/extract` | `PCH_AI_PKG.extract_expenses` | Receives base64 file + mime type; returns extracted lines JSON |
| `POST` | `/pch/ai/validate` | `PCH_AI_PKG.validate_lines` | Validates all lines for a request; returns updated statuses |
| `GET` | `/pch/clear/requests` | — | List current employee's requests |
| `POST` | `/pch/clear/requests` | `PCH_AI_PKG.save_request` | Create new DRAFT request |
| `GET` | `/pch/clear/requests/:id` | `PCH_AI_PKG.get_request_json` | Get request header + all lines |
| `PUT` | `/pch/clear/requests/:id` | `PCH_AI_PKG.save_request` | Update request header |
| `POST` | `/pch/clear/requests/:id/lines` | `PCH_AI_PKG.save_line` | Add or edit a line |
| `DELETE` | `/pch/clear/requests/:id/lines/:lid` | `PCH_AI_PKG.delete_line` | Remove a line |
| `POST` | `/pch/clear/requests/:id/submit` | `PCH_AI_PKG.submit_request` | Submit request for approval |

---

## 5. APEX Pages (f101)

> Build in APEX Builder 24.2 first, then export via `apex_export.get_application`.

| Page | Name | Template | Description |
|---|---|---|---|
| **70** | AI Clearing Requests | Interactive Report | User's requests list — status badge, total amount, date, actions |
| **71** | New Clearing Request | Wizard (3 steps) | Upload → Review → Submit |
| **72** | Clearing Request Detail | Form + Interactive Grid | View/edit lines after creation |
| **73** | Edit Line (modal) | Dialog | Edit a single extracted line item |
| **75** | Admin: All Clearing Requests | Interactive Report | AP Accountant view; bulk status update |

### Page 71 — Wizard Detail

#### Step 1 — Upload
- File Browse item: accepts `.pdf`, `.xlsx`, `.xls`, `.csv`
- Up to **5 files**, **10 MB each**
- SheetJS (xlsx.js, CDN) loaded on this page only — auto-converts Excel → CSV before upload
- **"Extract with AI"** button calls ORDS `/extract` via APEX AJAX
- Spinner/progress region during extraction (typically 3–8 seconds)

#### Step 2 — Review Extracted Items
- Interactive Grid with all extracted lines
- Editable columns: Item Name, Category (select list), Date, Amount, Currency, Vendor, Reference#
- **Status badge column:**
  - 🟢 **VALID** — passes both validation rules
  - 🔴 **INVALID** — inline reason shown (see rules below)
  - 🟡 **NEEDS REVIEW** — AI could not extract date or reference number
- Row actions: toggle include/exclude, delete row
- **"Add Row"** button for manual line entry
- **"Re-validate"** button refreshes validation after any edit

#### Step 3 — Summary & Submit
- Summary card per currency: item count + total amount
- Warning count for remaining INVALID items (user must remove or acknowledge)
- Request type selector (Clearing / Reimbursement)
- Notes field
- **"Submit Request"** button → calls `/submit` endpoint

---

## 6. Validation Rules

### Rule 1 — No Duplicate Reference Numbers

```
INVALID if: (reference_number, vendor_name) already exists in PCH_AI_USED_REFERENCES
         OR same reference appears in another SUBMITTED/APPROVED request

NEEDS_REVIEW if: reference_number IS NULL
                 (can still submit with manager acknowledgement)

Scope: company-wide (an invoice is issued once regardless of employee)
```

**Duplicate within same request:** If the same reference appears twice in the same upload, mark the second occurrence INVALID with error `DUPLICATE_IN_BATCH`.

### Rule 2 — Expense Date Within 3 Months

```
INVALID if: expense_date < ADD_MONTHS(TRUNC(SYSDATE), -3)
INVALID if: expense_date > TRUNC(SYSDATE)   ← future dates not allowed
NEEDS_REVIEW if: expense_date IS NULL
```

### Error Codes (stored in `validation_errors` JSON array)

| Code | Rule | Message shown to user |
|---|---|---|
| `DUPLICATE_REF` | Rule 1 | "Reference number already used in a previous request" |
| `DUPLICATE_IN_BATCH` | Rule 1 | "Reference number appears more than once in this upload" |
| `DATE_TOO_OLD` | Rule 2 | "Expense date is older than 3 months" |
| `DATE_FUTURE` | Rule 2 | "Expense date is in the future" |
| `REF_MISSING` | Rule 1 | "Reference number could not be extracted — please enter manually" |
| `DATE_MISSING` | Rule 2 | "Expense date could not be extracted — please enter manually" |

---

## 7. File Handling Details

### PDF Files
- Sent to Anthropic API as `document` content type with base64 encoding
- Anthropic natively reads PDFs — no pre-processing required
- Multi-page receipts PDF → single API call; all items extracted in one pass
- Max 100 pages per file (Anthropic limit)

### Excel / CSV Files
- **Client-side conversion:** SheetJS (xlsx.js) converts `.xlsx`/`.xls` → CSV string in the browser
- CSV string sent to ORDS as plain text
- PL/SQL sends as plain text content block to Claude
- Pure `.csv` files: no conversion, sent directly

### Storage
- Original uploaded files stored as BLOB in `PCH_AI_CLEAR_REQUESTS` (compliance audit)
- `ai_raw_response` CLOB stores the full Anthropic API JSON response for debugging

---

## 8. Security & Configuration

| Concern | Solution |
|---|---|
| API key exposure | Stored in APEX Application Settings (encrypted) — never in JS or page source |
| ADB network access | `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` grant required for `api.anthropic.com` |
| Page authorization | Pages 70–73: `EMPLOYEE` role (same as existing f101 pages) |
| Admin page | Page 75: `AP_ACCOUNTANTS` authorization scheme |
| Rate limiting | PL/SQL package includes retry logic + exponential backoff for HTTP 429 |
| Audit trail | All AI extractions logged with raw response; original files retained as BLOBs |
| CORS | All Anthropic API calls are server-side (PL/SQL); no API key ever reaches the browser |

---

## 9. Build Sequence

| Phase | Deliverable | Status | Scripts |
|---|---|---|---|
| **1** | DB schema — extend budget line tables, create `DCT_PC_USED_REFERENCES` + `DCT_PC_AI_EXTRACT_LOG`, add AI summary cols to request headers | ✅ Done | `db/phase1_ai_schema.sql` |
| **2** | PL/SQL package `PROD.DCT_PC_AI_PKG` (spec + body) — Anthropic API call via `DBMS_CLOUD`, extraction, validation, register refs | ✅ Done | `db/phase2a_ai_pkg_spec.sql`, `db/phase2b_ai_pkg_body.sql` |
| **3** | ORDS endpoints — 5 handlers added to `dct.admin` module under `pch/` prefix | ✅ Done | `db/phase3_ords_endpoints.sql` |
| **4** | APEX Page 71 — Upload + Review wizard (core feature) | ⏳ Pending | — |
| **5** | APEX Page 70 (list) + Page 72 (detail/edit) | ⏳ Pending | — |
| **6** | Validation wired end-to-end + edge case testing | ⏳ Pending | — |
| **7** | Admin Page 75 | ⏳ Pending | — |
| **8** | UAT + prompt tuning | ⏳ Pending | — |

**Total estimate: ~6.5 working days**

---

## 11. Phase 1–3 Implementation Notes

### DB Objects Created / Altered

| Object | Type | Change |
|---|---|---|
| `PROD.DCT_PC_CLEAR_BUDGET_LINES` | Table (altered) | +11 cols: ITEM_NAME, CATEGORY, EXPENSE_DATE, VENDOR_NAME, REFERENCE_NUMBER, CURRENCY, VALIDATION_STATUS, VALIDATION_ERRORS, IS_AI_EXTRACTED, IS_INCLUDED, AI_CONFIDENCE, SOURCE_FILE |
| `PROD.DCT_PC_REIMB_BUDGET_LINES` | Table (altered) | Same 12 cols as above |
| `PROD.DCT_PC_CLEARING` | Table (altered) | +3 cols: AI_LAST_EXTRACTED_AT, AI_TOTAL_LINES, AI_VALID_LINES |
| `PROD.DCT_PC_REIMBURSEMENTS` | Table (altered) | Same 3 cols |
| `PROD.DCT_PC_USED_REFERENCES` | Table (created) | Company-wide ref# registry; function-based unique index on `(reference_number, NVL(vendor_name,'~~NULL~~'))` |
| `PROD.DCT_PC_AI_EXTRACT_LOG` | Table (created) | Anthropic API audit log per file per call |
| `PROD.DCT_PC_AI_PKG` | Package (created) | VALID — spec + body |

### ORDS Endpoints (module `dct.admin`, prefix `/ords/admin/dct/`)

| Method | Path | Action |
|---|---|---|
| POST | `pch/ai/extract/:request_type/:request_id` | Upload raw file (BLOB body), AI extracts lines |
| POST | `pch/ai/validate/:request_type/:request_id` | Run Rule 1 + Rule 2, return counts |
| GET | `pch/lines/:request_type/:request_id` | Fetch all AI lines as JSON array |
| DELETE | `pch/lines/:request_type/:request_id/:line_id` | Remove one line |
| POST | `pch/refs/:request_type/:request_id` | Lock ref#s into registry on submit |

### API Key Setup (required before testing)

```sql
UPDATE prod.dct_module_settings ms
SET    ms.setting_value = '<your-anthropic-api-key>',
       ms.updated_by = 'ADMIN', ms.updated_at = SYSTIMESTAMP
WHERE  ms.module_id  = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'PETTY_CASH')
AND    ms.setting_key = 'ANTHROPIC_API_KEY';
COMMIT;
```

### Extract Endpoint — Client Call Pattern

```javascript
// Frontend calls: POST to /ords/admin/dct/pch/ai/extract/CLEARING/123
// Body: raw file bytes   Headers: Content-Type + X-File-Name
await fetch(`${ORDS_BASE}/pch/ai/extract/${requestType}/${requestId}`, {
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${session.token}`,
        'Content-Type': file.type,        // e.g. 'application/pdf'
        'X-File-Name':  file.name
    },
    body: file                            // raw File object — no base64 needed
});
```

---

## 10. Design Decisions — Status

| # | Question | Decision |
|---|---|---|
| 1 | Linkage to existing expense reports | ✅ **Linked** — each AI clearing request links to an existing `EXPENSE_REPORT` record via `expense_report_id`; the AI extraction populates the expense lines of that report |
| 2 | Multi-currency handling | ✅ **Store as-is** — amounts stored in original currency; no automatic conversion |
| 3 | Reference number uniqueness scope | ✅ **Company-wide** — once a `(reference_number, vendor_name)` pair appears in any accepted request, it is blocked for all employees |
| 4 | Approval workflow | ✅ **Same existing workflow** — no separate flow; this feature only automates the manual data-entry step for end users populating expense lines |
| 5 | ADB network ACL for `api.anthropic.com` | ✅ **Action required** — need to request `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` grant from OCI admin before Phase 2 |

### Schema impact of Decision 1

`PCH_AI_CLEAR_REQUESTS` gains a foreign key to the existing expense reports table:

```sql
expense_report_id  NUMBER NOT NULL REFERENCES PROD.EXPENSE_REPORTS(expense_report_id)
```

The flow becomes:
1. User opens an existing Expense Report (in DRAFT status)
2. Clicks **"Extract Lines from Documents"**
3. Uploads PDFs/Excel → AI extracts → validated lines are inserted as expense report line items
4. User reviews, adjusts, then submits the Expense Report through the normal approval chain

### Rule 1 — Duplicate Reference Scope (confirmed)

The `UNIQUE (reference_number, vendor_name)` constraint on `PCH_AI_USED_REFERENCES` enforces this company-wide. Once Employee A's request is **submitted** (not just drafted), that `(reference_number, vendor_name)` pair is registered and any future upload by any employee containing the same pair will be flagged `INVALID` with error `DUPLICATE_REF`.
