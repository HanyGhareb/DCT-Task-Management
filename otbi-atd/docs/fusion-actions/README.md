# Fusion Actions — docs & scripts hub

This folder collects everything about driving **Oracle Fusion** from the i‑Finance
platform using the **OTBI‑ATD semi‑attended browser session** (the same SSO/MFA
login the extract jobs use). It covers both directions:

- **Read** Fusion (proof‑of‑concept, 2026‑06‑30): look up an AP invoice by number
  and return its description / header. See [poc-invoice-read.md](poc-invoice-read.md)
  and the reusable script [`fusion_invoice_lookup.py`](fusion_invoice_lookup.py).
- **Write** Fusion (action framework, built 2026‑06‑21): create AP invoices from
  approved Petty Cash. The source lives with the runner/DB (see *Source map* below);
  this README is the index + the hard‑won findings.

> **Mechanism:** UI robot (Playwright) over the shared, already‑authenticated browser
> context — **no service account, no REST**. **Semi‑attended:** runs unattended while
> the saved Fusion session is valid; when it expires a human approves ONE Microsoft
> Authenticator number (pushed to Telegram, tagged with the VM). Runs on the worker
> fleet `atd-vm180/181/182`.

---

## Findings that shape the design

1. **`fscmRestApi` is NOT usable with this access — HTTP 401.**
   Even with a *full* Fusion UI cookie session (37 cookies incl. `JSESSIONID`,
   `_WL_AUTHCOOKIE_JSESSIONID`, `ORA_FND_SESSION_*`, established by loading
   `/fscmUI/faces/FuseWelcome`), the Payables REST resource returns **401 (empty
   body)** via every request channel. The federated **ADGOV SSO** login provides no
   Fusion‑local password and no OAuth client, so REST Basic/OAuth can't be satisfied.
   → **Both reads and writes must go through the UI robot.** This validates the
   original action‑framework decision (UI, not API).

2. **ADF intercepts normal clicks.** Playwright `.click()` on Navigator/menu items
   fails with *"…div intercepts pointer events"*. Fire the element's own handler
   in‑DOM instead: `locator.first.evaluate("el => el.click()")`. (Same gotcha the
   JET UAT runners hit.)

3. **Navigator items are lazy.** The `Payables → Invoices` sub‑item isn't in the DOM
   until the **Payables** group is expanded first.

4. **Idempotency for writes is mandatory** (a retried browser run must never create a
   duplicate invoice). Built via a UNIQUE `idem_key`, a pre‑save existence check, a
   `DONE`‑never‑resurrected queue, and an `ATD_ACTION_LIVE=1` dry‑run gate.

---

## Proven Payables navigation (read path)

```
/fscmUI/faces/FuseWelcome
  → a[title="Navigator"]                                    (normal click)
  → a#groupNode_payables                                    (JS click — expand Payables)
  → a#pt1:_UISnvr:0:nv_itemNode_payables_payables_invoices  (JS click — open workarea)
  → [title="Tasks"]                                         (JS click — open Tasks drawer)
  → a:has-text("Manage Invoices")                           (JS click)
  → input aria-label=" Invoice Number"  (fill)  →  button "Search"
  → a:has-text("<invoice number>")                          (JS click — open invoice)
  → read line "Description" (full textContent; CSS truncates display only)
```

Evidence screenshots: [`evidence/`](evidence/)
(`01_payables_invoices_workarea`, `02_manage_invoices_search_result`, `03_invoice_detail`).

---

## Run the read PoC

On a worker VM (runner + saved session live there):

```bash
KEY=/c/tmp/atd-provision/keys/atd_id_ed25519
scp -i $KEY otbi-atd/docs/fusion-actions/fusion_invoice_lookup.py root@192.168.1.181:/root/otbi-atd/runner/
ssh -i $KEY root@192.168.1.181 \
  "cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh && \
   ~/otbi-atd/venv/bin/python -u fusion_invoice_lookup.py 'INV/HQ/26032465'"
# add --json for machine output, --headed to watch the browser.
# If the session expired: approve the one MFA number (Telegram / Authenticator).
```

The tool prints the header summary (best-effort — *Supplier Site* can mis-pick an
adjacent value) and the **line description as length-ranked candidates**; the top
candidate is the invoice description (the AP line Description is the longest free text
on the row). Verified on `INV/HQ/26032465` → top candidate
*"FAM Trip - Deccan Herald India - Ramadan FAM Trip Attractions Booking (23-27 Feb 2026)"*.

> **Pushing scripts to the VM:** stream as base64 in the *same* SSH command
> (`base64 file | ssh VM "base64 -d > dest && …run…"`). Plain `scp` followed by a
> separate run was observed to leave a **0‑byte file** when an earlier backgrounded
> transfer was interrupted — the base64‑in‑one‑shot method is race‑free.

---

## Source map — the write‑back action framework (already deployed)

| Layer | File(s) |
|---|---|
| Action queue + pkg | `otbi-atd/db/19_atd_action_queue.sql` (`ATD_ACTION_REQUEST`, `ATD_ACTION_PKG`) |
| PC source pkg | `final apps/PC/db/07_pc_fusion.sql` (`DCT_PC_FUSION_PKG`) |
| Configurable invoice type | `otbi-atd/db/23_fusion_doctype_map.sql` (`DCT_FUSION_DOCTYPE_MAP`) |
| Employee→supplier map | `otbi-atd/db/21_emp_supplier_map.sql` (`DCT_EMP_SUPPLIER_MAP`) |
| Explicit Fusion apps URL | `otbi-atd/db/22_fusion_apps_url.sql` (`ATD_OTBI_ENV.fusion_apps_url`) |
| ORDS `/atd/actions*` | `otbi-atd/db/20_atd_action_ords.sql` |
| HR supplier‑map ORDS | `final apps/HR/db/07_hr_supplier_map_ords.sql` |
| Approval hooks | `final apps/PC/db/06_pc_ords.sql`, `db/v2/14_dct_approval_pkg.sql` |
| Runner (write) | `otbi-atd/runner/actions/` (`__init__.py`, `ap_invoice.py`), `runner.py --actions` |
| Runner (read PoC) | `otbi-atd/docs/fusion-actions/fusion_invoice_lookup.py` |
| Scheduler | `otbi-atd/runner/run_atd_actions.ps1` |
| Plan / build log | `C:\Users\hanyg\.claude\plans\as-we-build-otbi-atd-graceful-minsky.md` |

All `FUSION_POST_*` gates default **N** (dormant). The AP‑invoice **write** selectors
in `actions/ap_invoice.py` are a first cut and still need a headed tune on a Fusion
**test** pod before the first live save; the **read** path in this folder is verified.
