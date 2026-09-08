# Budget Status — deployed 06 September 2026

Approved scope: compact search criteria at left, readable Presentation rail at right, Show Summary unchecked by default, and Print → PDF / PowerPoint using the Projects Budget Utilization reporting workflow. No previous-period comparison was added.

## Behavior

- Presentation has a 250–300 px rail on desktop, with wrapped descriptions. Criteria occupy three columns; Entity and the existing explanatory hint span those columns. Below 1000 px the rail stacks; below 600 px criteria use two columns.
- `fdShowSummary` starts false on each page load and returns to false on Reset. As of v1.115.1 it gates formatted summaries for all chapter/total rings, Fund figures, sector cards and department cards in Composition tiles, Ledger rows and Proportional map. Unchecking closes any open summary immediately. Native amount hints and click/keyboard selection/drill actions remain available.
- Print uses the existing `.gen` dropdown and authenticated enqueue → status poll → download pattern. Requests freeze period, entity, selected sectors/departments, presentation, display units, language, both sorts and department text search. It prevents concurrent requests and exports during data loading/errors. A failed report/download restores the button; polling ends after six minutes.
- Exports contain total and all five chapter bands, sectors and every matching department (no screen top-N limit). A separate report-scope page carries the dashboard basis and global excluded balances, outside selected totals. The contextual scopes follow the screen: sector cards follow Entity; departments also follow selected sectors; chapter totals also follow selected departments. Department text search affects department listings, not the totals. Selection labels explain these scopes.
- PDF is paginated landscape; PowerPoint embeds the same paginated dashboard artwork as slide images, preserving visual layout (figures are not individually editable PowerPoint shapes). Map output adds a complete ledger for legibility of tiny cells. Report templates use the existing GL colors and state thresholds.
- Reports query GL balances at generation time; amounts can reflect a refresh that happened after the browser loaded. Basis matches `/fd/status`: CH1–3/BG1, CH4/BG3, CH5/BG5; appropriation 301439 is carved out as Masterpieces before ES-based entity mapping.
- EN/AR text is included. No recipients are seeded: Print is a download action.

## Local validation

`tests/fd_report_test.py`: offline scope/arithmetic, all departments, three presentations, Arabic, map area, zero budgets, department search and HTML escaping.

`tests/fd_review_browser.py`: real Chromium against local source, with all `/ords/` calls intercepted using synthetic fixtures. Checks layout, summary mouse/keyboard interaction, preserved drill/card behavior, PDF/PPT downloads, exact filter payload, permission/report/download failure recovery, mobile widths, Arabic and all three report layouts. Generates genuine sample PDF/PPT files and screenshots. Samples are illustrative, not production financial data.

The live browser regression was updated to opt into ring summaries explicitly and passed **190/190** against the deployed page. The report API suite passed **51/51**, including six genuine PDF/PPTX jobs (runs 1002–1007), all three presentations, selected entity/sector/department scopes, Arabic PPTX, file downloads and PDF-total reconciliation. The actual Print menu and layout suite passed **14/14** (including two further real downloads). Local validation also passed 28 browser/render checks and 4 unit tests.

Both database scripts compiled/executed successfully via SQLcl. All three workers are active. No report recipients were seeded; no delivery records were created. Live 401/400/404 paths passed. The 403 recovery path was exercised locally with an intercepted response; privilege and requesting-user ownership guards were reviewed in the deployed handlers, but no separate live user was provisioned for a cross-user test.

The independent ENTITY-classification rollout occurred during deployment. The seed detects the currently deployed `fd/status` handler and selects matching entity semantics; re-run it after changing that handler. Live tests confirmed parity after the classification rollout.

## Deployment record and repeat-deployment checklist

User approval: “go ahead” on 06 September 2026. Budget Status shipped in GL **1.113.0**, release **20260905201058** (previous **20260904081416**), as an overlay of only index.html, js/app.js and css/app.css. Concurrent later GL releases preserve this feature; the Print/layout suite was repeated against **1.115.0** and passed **14/14**. Worker backups: `/opt/rpt-worker/backups/budget-status-20260906` on vm180/181/182. Live evidence and results are in `UAT/UAT_GL_round2-06-09-2026/`.

1. Preserve/back up currently deployed GL assets and reporting worker files. The workspace contains unrelated uncommitted changes; select this change's hunks rather than deploying the whole working tree blindly.
2. In PROD via SQLcl, run `reporting/db/41_rpt_gl_budget_status.sql` (definition only; no recipient seed). Validate `source_ref` JSON and the cube SELECT with representative entity/period binds.
3. In a fresh ADMIN SQLcl session, run `final apps/GL/db/49_gl_fd_report_ords.sql` (additive bridge). Preserve this in the post-05 rerun list. Verify POST/GET/file require `GL_RUN_BRIEFING_BOOK`; status and files require the requesting user's run ownership.
4. Deploy `reporting/runner/render_fd.py`, `templates/gl_budget_status.html.j2` and the small `GL_BUDGET_STATUS` dispatch additions in `render_pdf.py` / `render_pptx.py`. Restart the worker using its established runbook. Do not include unrelated renderer changes without reviewing them.
5. Bump GL `APP_VERSION` from the actual deployed value and deploy only reviewed GL `index.html`, `js/app.js`, `css/app.css`. This change shipped as 1.113.0; preserve subsequent version bumps.
6. Live-check EN/AR, summary default and toggles, PDF/PPT for all three presentations, selected entity/sector/department, 401/403/404, cross-user run isolation and a failed job. Compare exported totals with `/fd/status` from the same data refresh.
7. Record the actual deployment/version and live results in STATUS.md and deployment-notes.md after it ships.

Rollback: on later shared releases, reverse only the Budget Status hunks (do not roll back unrelated later work). Restore the prior GL assets and worker files only if no subsequent changes depend on them; disable the `GL_BUDGET_STATUS` definition and remove only the three `fd/report` templates if needed. No existing table or balance data is altered.

## 06 September correction — Show Summary applies to every graph (v1.115.1)

User clarified that sectors and departments must follow the checkbox too. Added
the same early guard to `fdTrCard` used by `fdTrOver`. No database/report renderer
changes. Deployed GL-only index.html/app.js overlay **20260906020630**, previous
**20260905202533**. Targeted browser test covers all rings/Fund, sector/department
cards in all three presentations, immediate closure, preserved selection and Arabic.
Staged verification: 66/66. Live verification: **67/67**, with evidence in UAT round3-06-09-2026.
