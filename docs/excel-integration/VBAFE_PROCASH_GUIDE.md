# Procash Transactions — Oracle Visual Builder Add-in for Excel (VBAFE)

**Module:** Accounts Payable (App 212) · **API:** `xl.rest` at `/ords/admin/xl/procash/*`
**Deployed:** 2026-08-17 · **Template code:** `PROCASH_ENTRY`

A **procash transaction** records a manual payment pushed through the bank portal
directly, outside Fusion Payables. This guide covers capturing those payments from
Excel; the same data is editable in the AP app (Procash Transactions page).

---

## 1. What the add-in talks to

| Sheet / business object | Route | What it is |
|---|---|---|
| **Single** | `/xl/procash/single/` | One header **and** one detail line in a single row — the fastest path for a one-line payment. |
| **Headers** | `/xl/procash/headers/` | Header fields only. Use with **Lines** when a payment carries several detail lines. |
| **Lines** | `/xl/procash/lines/` | Detail lines. Each row finds its header through **`bank_reference`**, so that column must be filled on every line. |
| **Invoice Update** | `/xl/procash/invoices/` | The after-the-fact reconciliation: put the Fusion payable invoice number in `invoice_number`. Everything else is read-only. |

Service description (this is the URL you give the add-in):

```
https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl/procash/openapi
```

Pick lists are available at `/xl/procash/lov/<kind>` where kind is
`business-units`, `currencies`, `statuses`, `coding-bases`, `projects` or `etypes`
(`projects` and `etypes` accept `?search=`).

**Sign-in:** HTTP Basic with your i-Finance username and password. The handler
validates the credentials against `DCT_USERS` itself — database-authenticated
active users only. `/xl/` is ORDS-public and self-authenticating, so the
`db/v2/50` module gate deliberately does not apply to it.

---

## 2. The rules the server enforces

Every Excel write runs through `DCT_AP_PROCASH_PKG` — the *same* package the web
app calls. There is no second rule set for Excel, so a spreadsheet can never put
the data into a state the UI would have refused:

- Only a **DRAFT** transaction can be edited. Once it is submitted, in approval,
  processed or invoiced, Excel writes are refused (403).
- A detail line is coded **either** by project + task + expenditure type **or** by
  GL combination — never both. The project trio is validated against the masters,
  the GL combination against the chart of accounts (canonical 10-segment order).
- Lines must add up to the header amount before the transaction can be
  **submitted**. While it is a draft the mismatch is only a warning.
- `invoice_number` is accepted **only** on a PROCESSED transaction, and only when
  that invoice already exists in the loaded Fusion AP data. An invoice created in
  Fusion today becomes pickable after the next ATD extract run.
- The same invoice cannot be linked to two procash transactions.
- Amounts: `amount` is in the transaction currency; `exchange_rate` may be left
  blank to take the current rate (AED is always 1); `amount_aed` is derived.

A refused row comes back as an HTTP error and **nothing is written** — the request
rolls back on its own. Fix the row and publish again.

---

## 3. First-time setup (once per user, on Windows)

1. Install the add-in — `vbafe-installer-current-user.msi` in this folder.
2. Download the starter workbook: **AP app → Procash Transactions → Download Excel
   template**, or `GET /xl/templates/download?code=PROCASH_ENTRY`.
3. In Excel: **Oracle Visual Builder → Designer → Add Business Object**, paste the
   OpenAPI URL above, sign in with your i-Finance credentials.
4. Bind each sheet to its object (Single / Headers / Lines / Invoices), keeping the
   column order the starter workbook ships with.
5. Save the bound workbook and hand it back to a SYS_ADMIN to upload as the
   **published** file of a new version (ATD → VB Templates), so everyone else gets
   a workbook that is ready to use.

> The starter workbook in the repository carries the sheets, the column headers and
> a read-me — but **not** the add-in's own bindings, because those are created by
> Excel on a Windows desktop. Step 3–5 is the one manual step in this pipeline.

---

## 4. Day-to-day use

**Capture a one-line payment**
1. Open the workbook, sheet **Single**, click **Download Data** to see existing rows.
2. Add a row: bank reference, business unit, payee, payment date, currency, amount,
   then the four line columns (`line_coding_basis`, project/task/expenditure type
   **or** `line_gl_combination`, `line_amount`).
3. **Upload Changes**. The server stamps `payment_number` (PCH-#####) and `status`
   DRAFT; download again to see them.

**Capture a payment with several lines**
1. Sheet **Headers**: add the payment, upload, download again to pick up its
   payment number.
2. Sheet **Lines**: one row per line, each carrying the same `bank_reference`.
3. Upload. Check `header_amount` against the lines you entered — they must match
   before anyone can submit the payment.

**Reconcile the invoice**
1. Sheet **Invoice Update** lists PROCESSED payments (and already-invoiced ones).
2. Type the Fusion invoice number into `invoice_number` and upload. The server
   snapshots the invoice supplier, date and amount, moves the transaction to
   INVOICED, and flags `amount_mismatch = Y` when the invoice amount differs from
   what was paid.

Submitting, approving and marking a payment processed are **not** Excel actions —
they happen in the AP app (or on the workflow platform when
`PROCASH_APPROVAL_MODE` is set to WORKFLOW).

---

## 5. Deployment / maintenance

| Piece | Where |
|---|---|
| API package | `db/v2/121_xl_procash.sql` (`DCT_XL_PROCASH_PKG`) |
| Routes | **inside `db/v2/107_xl_budget_ords.sql`** — 107 `DELETE_MODULE`s `xl.rest`, so a separate additive script would be wiped by the next 107 re-run |
| Business rules | `final apps/AP/db/09_procash_pkg.sql` (`DCT_AP_PROCASH_PKG`) |
| Starter workbook | `docs/excel-integration/templates/procash_entry_template.xlsx` |
| Template registry | `DCT_XL_TEMPLATE` code `PROCASH_ENTRY` (managed in ATD → VB Templates) |
| Tests | `final apps/AP/tests/procash_xl_test.sql` (17 assertions over the write paths) |

**Deploy order:** `121` → re-run `107` (fresh SQLcl session, as ADMIN).

**Gotchas already paid for:**
- The row identity field must be **`id`**, matching the `{id}` path parameter, or
  the add-in cannot update a row.
- The ORDS auto-generated `open-api-catalog` of a *custom* module carries no field
  schemas — the add-in then "finds 1 business object" and lists nothing to select.
  That is why `emit_openapi` is hand-authored.
- A refused write rolls the request back. In a SQL*Plus/SQLcl harness that also
  undoes the harness's own fixtures, so `procash_xl_test.sql` commits its fixtures
  and cleans up explicitly instead of relying on a closing ROLLBACK.
- Calling the package outside ORDS needs `OWA.init_cgi_env` first, or
  `OWA_UTIL.mime_header` raises ORA-06502.
