# PoC — read an AP invoice from Fusion via the extract‑job session (2026‑06‑30)

## Goal
Prove we can **access Oracle Fusion**, go to **Payables**, search a specific invoice
number, and return its **description** — using the *same* access the OTBI‑ATD extract
job uses (the semi‑attended SSO/MFA browser session). Requested as a precursor /
feasibility check for the AP write‑back action framework.

## Result — `INV/HQ/26032465`  ✅

> **Description (invoice line):**
> **"FAM Trip - Deccan Herald India - Ramadan FAM Trip Attractions Booking (23-27 Feb 2026)"**

Header captured at the same time:

| Field | Value |
|---|---|
| Supplier or Party | NIRVANA TRAVEL & TOURISM L.L.C |
| Supplier Site | ABU DHABI |
| Invoice Amount | 26,304.25 AED (Unpaid 26,304.25) |
| Invoice Date | 10/03/2026 (Creation 19/06/2026) |
| Invoice Type | Standard |
| Business Unit | Department of Culture and Tourism |
| Payment Terms / Currency | Immediate / AED |
| Status | Validation: *Needs revalidation* · Approval: *Required* · Holds: 1 |
| Line 1 | 25,066.99 — PO 4511020063… — Receipt 4513075148 — Ship‑to Nation Tower |
| Tax | VAT INPUT STD‑REC 1,237.26 |

## How it ran
- Host: worker VM **atd-vm181** (192.168.1.181), reusing `auth_state_FUSION_ADGOV.json`.
- Session had expired → one MFA number was surfaced (Telegram/Authenticator) and
  approved by the operator; the run then proceeded with no further prompts.
- Path: Navigator → **Payables** → **Invoices** → **Tasks** → **Manage Invoices** →
  fill *Invoice Number* → **Search** → open invoice → read line **Description**.
- Tooling: [`fusion_invoice_lookup.py`](fusion_invoice_lookup.py) (clean, reusable).

## Key technical outcomes
- **`fscmRestApi` → HTTP 401** even with a full UI cookie session ⇒ REST is not an
  option under federated SSO; the **UI robot is the channel** (read *and* write).
- **JS `el.click()`** is required to defeat ADF pointer‑interception; Navigator
  sub‑items are lazy (expand the group first).
- The line **Description** is CSS‑truncated in the grid but available in full via
  `textContent`.

## Evidence
See [`evidence/`](evidence/):
1. `01_payables_invoices_workarea.png` — the Payables → Invoices workarea (Gov of Abu Dhabi Fusion).
2. `02_manage_invoices_search_result.png` — Manage Invoices search returning the row for `INV/HQ/26032465`.
3. `03_invoice_detail.png` — the opened invoice (supplier, amounts, line with the description).

## Honest constraints
- **Semi‑attended:** unattended only while the saved session is valid; MFA approval
  needed on expiry (observed to expire within minutes of light, intermittent use).
- Throughput shares the single‑browser lock with the extract/discover tasks.
- The **write** (Create Invoice) selectors are still a first cut — tune on a Fusion
  test pod before the first live save. The **read** path is verified.
