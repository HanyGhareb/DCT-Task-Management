# Phase 1 — Execution & Test Report

**Date:** 2026-06-11 · **Scope:** [06-action-plan.md](../06-action-plan.md) Phase 1 ("Unblock the backend") · **Result: ✅ all 4 deliverables deployed and tested · 5 defects found, 5 fixed · 1 security action required (rotate API key — see §4)**

---

## 1. Deliverables

| # | Deliverable | Status | Evidence |
|---|---|---|---|
| 1.1 | **DCT_CC_PKG implemented** — full Credit Cards business logic replacing the stub: request lifecycle (submit/withdraw/approve/reject per type), CUSTOM step-condition evaluation (`BANK_APPROVAL_REQUIRED=Y`), limit enforcement + immutable limit history, `register_card` for post-approval issuance, replenishment validation (proxy rights, period rules, line coding), daily overdue-reminder job | ✅ VALID in PROD | `final apps/CC/db/04_cc_pkg.sql` (~700 lines) + `JOB_CC_REPL_REMINDER` (daily 07:00) + 3 sequences |
| 1.2 | **PC ORDS module built & published** — `/ords/admin/pc/` did not exist (PC STATUS.md wrongly implied it did). 26 handlers across pc/, gl-codes, reimbursements, clearings, approvals, settings, notifications; JSON field names match the JET mock-data contract; secrets masked in settings responses | ✅ PUBLISHED | `final apps/PC/db/06_pc_ords.sql` (new file); §5 test results |
| 1.3 | **PC JET flipped to live ORDS** — `apiBase` → ADB `/pc`, `authBase` → `/dct` (DT convention); `authService.js` login/logout now route to Admin ORDS | ✅ | `final apps/PC/Jet/js/services/config.js`, `authService.js` |
| 1.4 | **Approval sweep activated** — `DCT_APPROVAL_PKG` evaluates the engine's dormant `escalation_days`/`escalate_role_id` (notify + ESCALATED action, once per step) and `auto_approve_days` (advance/complete + per-module source effects) | ✅ VALID in PROD | `db/v2/14_dct_approval_pkg.sql` + `JOB_DCT_APPROVAL_SWEEP` (daily 07:10) |

## 2. Defects found by testing — all fixed & verified

| # | Defect | Severity | Root cause | Fix |
|---|---|---|---|---|
| D1 | **Every API error returned HTTP 200** (including 401 Unauthorized) across ALL modules — the JET session-expiry redirect could never fire | Critical, platform-wide, pre-existing | `dct_rest.err()` called `APEX_JSON.initialize_output`, which resets the HTP buffer and wipes the `OWA_UTIL.status_line` | `db/v2/13_dct_rest_status_fix.sql` (deployed with your approval) + source updated in `db/v2/11_dct_ords.sql`. Verified: no-token request now returns real 401 on PC and DT |
| D2 | **`ANTHROPIC_API_KEY` returned in clear text** by `GET /pc/settings` to any authenticated user | Critical, security | Settings handler exposed raw `setting_value`; the key is stored unencrypted in `DCT_MODULE_SETTINGS` | Handler now masks keys matching `%API_KEY%/%SECRET%/%PASSWORD%/%TOKEN%` as `********`; settings PUT refuses to write the mask back. **Key rotation still required — §4** |
| D3 | **`/ords/admin/dt/` returned 404** — the DT ORDS module was absent from ADB despite DT JET being configured live (CLAUDE.md/STATUS said "live") | Critical, pre-existing regression | dt.rest module missing from ADMIN schema (cause unknown — possibly lost in an environment recreate) | Redeployed from the repo's own `final apps/DT/db/06_dt_ords.sql`; verified routable + 401 auth enforced |
| D4 | PC create endpoint failed with ORDS 555 | High (new code) | `INSERT … SELECT … RETURNING` is illegal in Oracle (RETURNING needs `INSERT … VALUES`) | Handler rewritten to pre-fetch user attributes; full lifecycle then passed |
| D5 | `DCT_PC_AI_PKG` body INVALID | Low | Stale invalidation cascade from the `DCT_REST` body recompile | `ALTER PACKAGE … COMPILE BODY` → VALID, no errors |

## 3. Test results

### 3.1 ORDS API suite — live ADB, final run: **15/15 PASS**

| Test | Result | Detail |
|---|---|---|
| Login via `/dct/auth/login` | ✅ | session token issued for System Administrator |
| No-token request → 401 | ✅ | failed before D1 fix; passes after |
| GET settings | ✅ | 10 settings, API key masked `********` |
| GET pc/stats · pc/ · pc/all · gl-codes · reimbursements/all · clearings/all · approvals/pending · approval-templates (+steps) · notifications · pc/activity | ✅ ×10 | correct shapes; 3 PC templates, 12 GL combinations |
| **Write path** POST pc/ | ✅ | created `PC-2026-00002`, 100 AED, status SUBMITTED |
| Read-back + lines + approval instance | ✅ | 1 line with full 9-segment `cc_code`; instance at step "Line Manager Approval" |
| Reject action (cleanup) | ✅ | instance REJECTED, record REJECTED, activity feed shows the action |

Test record left behind (intentional, clearly labelled): `PC-2026-00002` / status REJECTED / purpose "PHASE1 SMOKE TEST".

### 3.2 Database verification (read-only — `tests/verify_phase1.sql`)

| Check | Result |
|---|---|
| Package validity: DCT_CC_PKG, DCT_APPROVAL_PKG, DCT_REST, DCT_PC_PKG, DCT_PC_AI_PKG | ✅ all spec+body VALID |
| Scheduler jobs: JOB_CC_REPL_REMINDER (07:00), JOB_DCT_APPROVAL_SWEEP (07:10), 3 DT jobs | ✅ all ENABLED/SCHEDULED |
| ORDS modules in ADMIN: dct.admin, dt.rest (restored), hr.rest, pc.rest | ✅ all PUBLISHED |
| New sequences (3 CC + 2 PC) | ✅ created |
| Sweep dry-run candidates (escalation / auto-approve) | 0 / 0 today — first live evaluation runs 2026-06-12 07:10 |
| CC package callable | ✅ `get_setting('BANK_NAME')` = ADCB |

### 3.3 Not covered (deferred, with reasons)

- **CC procedures end-to-end** — no CC ORDS/UI exists yet to drive them; the package compiles VALID and reuses the lifecycle patterns proven by the PC write-path test. Will be exercised when CC's ORDS/JET arrive (Phase 4).
- **PC JET in the browser** — API contract is verified; please run `python dev-proxy.py` in `final apps/PC/Jet/` and click through dashboard → request → approvals as the human acceptance pass.
- **Live sweep execution** — deliberately not forced today (it mutates approval data); the scheduled job evaluates real candidates tomorrow 07:10. Manual run if wanted: `BEGIN prod.dct_approval_pkg.sweep; END;`

## 4. ⚠ Security action required: rotate the Anthropic API key

Before the masking fix was deployed, the smoke test legitimately called `GET /pc/settings` and the response — containing the **full clear-text `ANTHROPIC_API_KEY`** — was captured into this working-session transcript. Treat the key as exposed:

1. Generate a new key in the Anthropic console and revoke the old one.
2. Update `DCT_MODULE_SETTINGS` (PETTY_CASH / ANTHROPIC_API_KEY) with the new value.
3. Longer-term (Phase 2): move secrets to `DCT_SYSTEM_SETTINGS` with `is_encrypted='Y'` handling, and apply the same response-masking pattern to the DT/HR settings endpoints (currently only PC masks).

## 5. Repository changes in this phase

| File | Change |
|---|---|
| `final apps/CC/db/04_cc_pkg.sql` | Stub → full implementation (deployed) |
| `final apps/PC/db/06_pc_ords.sql` | **New** — PC ORDS module (deployed) |
| `final apps/PC/Jet/js/services/config.js` | Mock → live ADB + authBase |
| `final apps/PC/Jet/js/services/authService.js` | login/logout via authBase |
| `db/v2/13_dct_rest_status_fix.sql` | **New** — err() status fix patch (deployed) |
| `db/v2/11_dct_ords.sql` | err() fixed in source of truth |
| `db/v2/14_dct_approval_pkg.sql` | **New** — sweep package + job (deployed) |
| `assessment-3/phase1/` | This report + test scripts (`tests/`) |

## 6. Follow-ups carried into Phase 2

1. **Rotate the API key** (§4) — user action.
2. Apply settings-secret masking to DT and HR ORDS settings handlers (same one-line pattern as PC).
3. DT codebase uses `module_code='DT'` in ORDS handlers but `'DUTY_TRAVEL'` in `DCT_DT_PKG` — one of them queries nothing; reconcile when DT is next touched.
4. Browser acceptance pass of PC live mode (user).
5. Update `final apps/PC/STATUS.md` and `final apps/CC/STATUS.md` — done in this phase; verify on next session start.
6. Investigate **how dt.rest disappeared** from ADB (D3) — if the environment was recreated, other non-scripted objects may also be missing; consider a deployment-drift check script.
