# Advanced Feature Proposals

Ranked by **impact ÷ effort**, with what each builds on. Effort: S < 1 week · M = 1–3 weeks · L = 1–2 months (single developer, this codebase's velocity).

---

## 1. Unified Approvals Inbox — impact ★★★★★ / effort M

One queue in Admin for every pending approval across PC/DT/HR/FL/CC. `dct_approval_instances` is already cross-module, so this is one ORDS endpoint + one JET view — no schema work. Adds the platform's single biggest daily-use win for managers. **Mockup:** `04-uiux/mockups/approvals-inbox-concept.html`.

## 2. Extend AI clearing platform-wide (receipt OCR + auto-coding) — impact ★★★★★ / effort M–L

`DCT_PC_AI_PKG` already exists for PC clearing (pending only an API key in `DCT_SYSTEM_SETTINGS`). Generalize it into `DCT_AI_PKG`:
- **DT settlements** — parse receipts into `dt_settlement_lines` with suggested expense categories.
- **CC replenishments** — the killer use case: photograph a month of card receipts, get `dct_cc_reimb_lines` drafted with merchant names and GL suggestions. Worth designing into DCT_CC_PKG from day one since it's not written yet.
- Confidence scores on every suggested line; below-threshold lines flagged for human review.
Uses the Claude API; key handling pattern already established by PC.

## 3. Approval escalation + auto-approve sweep — impact ★★★★ / effort S

The engine's `escalation_days`, `escalate_role_id`, `auto_approve_days` columns are populated by seeds but **nothing evaluates them**. One daily `JOB_DCT_APPROVAL_SWEEP` job (pattern: the 3 existing DT jobs in `final apps/DT/db/04_dct_dt_pkg.sql`) closes the loop, plus an escalation notification via `DCT_NOTIFY`. Cheapest high-impact item in this list.

## 4. Cross-module spend analytics — impact ★★★★ / effort M

Once `dct_budget_coding_lines` exists (DB proposal §3), one materialized view powers: spend by GL account / org / project across all modules, month trend, budget-vs-actual. Surface as an Admin "Finance Analytics" view with Chart.js (UI rec §6) and a scheduled refresh. Without the unified table this requires a fragile 6-way UNION — which is exactly why the DB proposal pays for itself.

## 5. Notification delivery: email + digest — impact ★★★★ / effort M

`dct_notifications` is in-app only. Add `APEX_MAIL`/OCI Email delivery for APPROVAL_PENDING and expiry alerts, plus a daily digest option per user (`dct_user_preferences`). Approvers who don't open the app are today's silent bottleneck — this directly attacks approval cycle time.

## 6. Document OCR + expiry intelligence — impact ★★★ / effort M

On top of unified `dct_documents` (DB proposal §2): extract expiry dates from uploaded passports/IDs/insurance automatically (same AI plumbing as #2), validate document type matches the requirement rule, and drive the existing expiry-alert job from extracted dates. Eliminates the main manual-entry error source in DT/FL compliance.

## 7. OCI IAM / SAML SSO — impact ★★★ / effort L

`dct_users.auth_method` already enumerates OCI_IAM | SAML. Implement as an additional APEX authentication scheme + JET redirect flow, keeping DB auth for external users (freelancers). Sequence **after** module rollout — it touches every app's login path; doing it mid-build multiplies testing.

## 8. PWA / mobile approvals — impact ★★★ / effort M

The JET SPAs are static-file apps — adding a manifest + service worker makes them installable. Scope it to the **Approvals Inbox** (#1) first: approve/reject from a phone is where mobile genuinely matters in this platform; full module UIs on mobile are not worth the effort yet.

## 9. Fusion ERP integration (complete the stub) — impact ★★★ / effort L

`DCT_FL_PKG` has the push-to-Fusion voucher stub and callback receiver. Implement against Fusion AP REST, add a FAILED-voucher retry queue and reconciliation report. Later, the same channel serves PC reimbursements and CC replenishment postings — design the integration table generically (`dct_erp_outbox`: source_module, payload, status, attempts).

## 10. Delegation self-service + enforcement — impact ★★ / effort S–M

`dct_delegations` table exists; no UI, and approval resolution doesn't consistently honor it (DB review §2.10). Add the Admin view (out-of-office style: delegate, scope, dates) and fix `get_effective_user()` usage in the approval engine. Small, but it unblocks real-world leave coverage — a guaranteed early complaint otherwise.

---

## Suggested adoption order

```
Quarter 1: #3 escalation sweep → #1 unified inbox → #10 delegation
           (all pure platform, no module dependencies)
Quarter 2: DB unification (03-database) lands with CC build → #4 analytics → #5 email
Quarter 3: #2 AI clearing rollout (PC live first, then CC, DT) → #6 doc OCR
Later    : #8 PWA on the inbox → #9 Fusion → #7 SSO last, when the platform is stable
```
