# UAT — BI · Reporting (App 211) — Round 1

- **Date:** 2026-07-01
- **Build:** APP_VERSION 1.0.1 (Jet) · ORDS `rpt.rest` `/ords/admin/rpt/` (live PROD)
- **Driver:** Playwright (headless Chromium) against a local `dev-proxy` → live ADB ORDS
- **Auth:** Admin quick-login (ADMIN) writes the shared `ifinance_jet_session`
- **Result: 15 / 15 PASS** · evidence: `evidence_01-Jul-2026-01/` (15 screenshots + `results.json`)

## Scope of this round
Triggered by two defects the user reported on the forms: **(a)** create/edit forms didn't close on
Save/Cancel and **(b)** they didn't follow the platform drawer + table standard. Full review + fix +
regression of the whole app.

## Fixes verified
1. **Forms converted to the shared `<edit-drawer>`** (right-edge slide-in) — replaced the legacy
   `modal-overlay`/`modal-box` markup in **Reports** (create/edit), **Report Detail → Schedule** and
   **Report Detail → Recipient**. Robust close on Cancel / Save / Esc / scrim.
2. **Latent KO binding bug fixed (found during the review):** the *Default params* placeholder
   `{"period":null}` was inside a KO `attr:{ placeholder:'…' }` binding. Its literal `"` ended the
   `data-bind="…"` HTML attribute early, leaving KO an unbalanced binding that threw and **left every
   field after it unbound** (Email subject / body / Enabled rendered with no labels). Moved the
   brace/quote placeholders to static single-quoted HTML attributes; all 13 drawer fields now bind.
   (Fixed in both `reports.html` and `reportDetail.html`.)

## Cases
| # | Case | Result |
|---|---|---|
| AUTH | Admin quick-login writes shared session | PASS |
| C01 | Dashboard — 4 KPI cards + Recent Runs table | PASS |
| C02 | Reports list — GL_BUDGET_ACTUAL, engine PYTHON, formats PDF,XLSX | PASS |
| C03 | New Report opens the `<edit-drawer>` | PASS |
| C04 | **Cancel closes the drawer** (reported bug) | PASS |
| C05 | **Create report via drawer — Save closes + row persists** | PASS |
| C06 | Edit report via drawer — Save persists the change | PASS |
| C07 | GL detail — Definition + Schedules + Recipients sections | PASS |
| C08 | Schedule drawer opens + Cancel closes | PASS |
| C09 | Add recipient via drawer — Save closes + appears | PASS |
| C10 | Run History lists runs incl. a SUCCESS | PASS |
| C11 | Run detail — Summary + Generated Files (Download) + Deliveries | PASS |
| C11b | Download a generated file (authed BLOB) — 763,597-byte PDF | PASS |
| C12 | Settings — config rows (EMAIL_ENABLED toggle, SMTP_HOST/PORT, PDF_RENDERER) | PASS |
| C13 | Cleanup — delete the UAT report (cascade) | PASS |

All test artifacts created during the run (`UAT_DRAWER_TEST` definition + its recipient) were deleted
in C13; PROD is left clean (only the two pilot definitions remain).

## Console / network
- 1 non-fatal console error: `401` on `/dct/settings/` — the shared region-theme probe; falls back to
  the platform default (documented, harmless).
- **Zero** non-200 responses from `/ords/admin/rpt/*`.

## Standard-compliance review (other screens)
Dashboard, Run History, Run Detail and Settings already use the platform `.data-table`/`.data-table-wrap`,
`.kpi`, `.switch-row`, top-right `.page-actions` and `.section-heading-row` — no changes needed.
