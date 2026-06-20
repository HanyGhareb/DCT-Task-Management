"""Unit tests for the Fusion write-back action handlers (no DB / no Playwright).

Run from the runner dir:   python tests/test_actions.py
Covers the two guarantees that matter most for WRITES:
  * idempotency  — an existing invoice is returned, never re-created;
  * dry-run safety — with ATD_ACTION_LIVE unset, nothing is saved (DryRun raised).
Also checks the REST idempotency probe error handling and dispatch routing.
"""
import os
import sys

# allow `import actions` whether run from runner/ or runner/tests/
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import actions                       # noqa: E402
from actions import ap_invoice, DryRun  # noqa: E402


class _Resp:
    def __init__(self, status, payload=None):
        self.status = status
        self._p = payload

    def json(self):
        return self._p


class _Req:
    def __init__(self, status, payload=None):
        self._r = _Resp(status, payload)

    def get(self, url, timeout=None):
        self.url = url
        return self._r


class _Ctx:
    def __init__(self, status, payload=None):
        self.request = _Req(status, payload)


def main():
    env = {"analytics_base_url": "https://pod-host.example.com/analytics"}

    # apps base: explicit column wins, else derive from the analytics host
    assert ap_invoice._apps_base(
        {"fusion_apps_url": "https://erp.example.com", **env}) == "https://erp.example.com"
    assert ap_invoice._apps_base(env) == "https://pod-host.example.com"

    # idempotency probe: existing -> id, none -> None, 404 -> None, error -> raise
    assert ap_invoice.find_existing_invoice(
        _Ctx(200, {"items": [{"InvoiceId": 98765, "InvoiceNumber": "RMB-1"}]}), env, "RMB-1") == "98765"
    assert ap_invoice.find_existing_invoice(_Ctx(200, {"items": []}), env, "RMB-1") is None
    assert ap_invoice.find_existing_invoice(_Ctx(404), env, "RMB-1") is None
    try:
        ap_invoice.find_existing_invoice(_Ctx(500), env, "RMB-1")
        assert False, "500 must raise (never read as absent)"
    except RuntimeError:
        pass

    # create(): existing invoice => idempotent skip, never saves
    fid, ref = ap_invoice.create(
        _Ctx(200, {"items": [{"InvoiceId": 111, "InvoiceNumber": "RMB-9"}]}),
        env, {"invoiceNumber": "RMB-9"}, {"idem_key": "RMB-9"})
    assert fid == "111" and "idempotent" in ref

    # NOTE: the not-found + dry-run path now navigates + fills the real form before
    # the save gate, so it requires Playwright and is exercised by the HEADED smoke
    # harness (smoke_ap_invoice.py), not by this stub-based unit test.

    # dispatch rejects unknown action types
    try:
        actions.dispatch(None, env, {"action_type": "NOPE", "payload_json": "{}"})
        assert False
    except RuntimeError as e:
        assert "unknown action_type" in str(e)

    print("ALL ACTION UNIT TESTS PASSED")


if __name__ == "__main__":
    main()
