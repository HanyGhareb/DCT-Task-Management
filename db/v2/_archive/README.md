# Archived DB scripts — do NOT run these

## 11b_dct_inbox_userspecific.sql · 11c_dct_inbox_step_approvers.sql
**Retired 2026-07-14** by the Workflow Platform (DWP).

Both were surgical re-definitions of the `/dct/approvals/pending` and
`/dct/approvals/:id/action` ORDS handlers. They existed only because the approval
engine lived *inside ORDS handler text*: `db/v2/11_dct_ords.sql` rebuilds those
handlers from scratch, so every behaviour patch had to be re-applied afterwards.
That is the origin of the "re-run 11c after any 11 re-run" rule in CLAUDE.md — a
deployment coupling that broke production more than once.

Their logic now lives in real database objects, where it belongs:

| was | is now |
|---|---|
| 11c's inbox cursor (and 11b's earlier version of it) | `PROD.DCT_WF_INBOX_V` (`db/v2/64`) |
| 11c's POST action body | `PROD.DCT_WF_COMPAT.ACT_ON_LEGACY` (`db/v2/65`) — a **verbatim** lift |

`db/v2/11` now contains thin facades over those two objects, so **re-running 11
reproduces this state instead of reverting it.** The coupling is dead.

Proof that this changed nothing: `db/v2/64t` (the view returns byte-identical rows
to the old handler for all 18 active users) and `db/v2/66t` (the live ORDS response
keeps every key, type and format).

**Re-running 11b or 11c would resurrect the old ORDS-embedded engine and undo all
of the above.** They are kept only for historical diff.
