"""otbi-atd : Fusion write-back ACTIONS (the inverse of the extract jobs).

An action performs something INSIDE Oracle Fusion (first type: AP_INVOICE) using
the SAME authenticated browser session the extract jobs use — no service account,
no separate auth. The worker (runner.py --actions) claims an ATD_ACTION_REQUEST
off the queue (FOR UPDATE SKIP LOCKED), authenticates once per env (reusing the
saved SSO session; MFA only on expiry), then dispatch() routes by action_type.

Each handler returns (fusion_id, ref):
  fusion_id  the id read back from Fusion after the write (e.g. InvoiceId) — used
             for the queue's mark_action_done and the source-module callback;
  ref        a short human note (e.g. "created", "existing (idempotent skip)").

WRITES MUST BE IDEMPOTENT: a retried run must never create a duplicate. Every
handler pre-checks Fusion for an object carrying the action's idem_key and, if it
already exists, returns that id instead of creating again.

Safety: handlers do NOT save to Fusion unless ATD_ACTION_LIVE=1. Without it they
perform the idempotency probe + form validation only and raise DryRun, so a row
is never silently written during setup/testing.
"""
import json


class DryRun(RuntimeError):
    """Raised when ATD_ACTION_LIVE != 1 — navigation + idempotency were checked
    but nothing was saved in Fusion."""


def dispatch(ctx, env, action):
    """Route an action row to its handler. Returns (fusion_id, ref)."""
    from . import ap_invoice, ppm_task_addl

    atype = (action.get("action_type") or "").upper()
    raw = action.get("payload_json")
    data = json.loads(raw) if raw else {}

    if atype == "AP_INVOICE":
        return ap_invoice.create(ctx, env, data, action)
    if atype == "PPM_TASK_ADDL_INFO":
        return ppm_task_addl.update(ctx, env, data, action)

    raise RuntimeError(f"unknown action_type: {atype!r}")
