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
from actions import ap_invoice, ppm_task_addl, DryRun  # noqa: E402


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

    # PPM_TASK_ADDL_INFO: payload validation (all three keys required)
    p, t, o = ppm_task_addl.validate_payload(
        {"projectNumber": "4511000682", "taskNumber": "Annual Reports",
         "orgReference": 4510195})
    assert (p, t, o) == ("4511000682", "Annual Reports", "4510195")
    for bad in ({}, {"projectNumber": "X"},
                {"projectNumber": "X", "taskNumber": "Y"},
                {"projectNumber": "X", "taskNumber": "Y", "orgReference": " "}):
        try:
            ppm_task_addl.validate_payload(bad)
            assert False, f"payload {bad} must be rejected"
        except RuntimeError as e:
            assert "payload needs" in str(e)

    # dispatch routes PPM_TASK_ADDL_INFO to its handler (validation fires first,
    # so no browser is touched with a bad payload)
    try:
        actions.dispatch(None, env, {"action_type": "PPM_TASK_ADDL_INFO",
                                     "payload_json": "{}"})
        assert False
    except RuntimeError as e:
        assert "PPM_TASK_ADDL_INFO payload needs" in str(e)

    # NOTE: like AP_INVOICE, the navigate/fill/save path needs Playwright and is
    # exercised by the HEADED smoke harness (smoke_ppm_task.py).

    _test_ar_invoice_rebill(env)

    print("ALL ACTION UNIT TESTS PASSED")


def _ar_payload(**over):
    """A valid AR_INVOICE_REBILL payload, overridable per test."""
    p = {
        "invoiceNumber": "INV00583863",
        "cm": {"transactionDate": "2026-02-28", "accountingDate": "2026-02-28",
               "creditReason": "Tax rate error", "comments": "correcting VAT"},
        "duplicate": {"transactionDate": "2026-02-28",
                      "accountingDate": "2026-02-28"},
        "lines": [{"lineNumber": 3, "memoLine": "Revenue fees",
                   "taxClassification": "VAT OUTPUT - STD",
                   "projectNumber": "4511000037", "taskNumber": "Entertainer Permit"},
                  {"lineNumber": 1, "memoLine": "Entertainer Permit",
                   "projectNumber": "4511000037", "taskNumber": "Entertainer Permit"}],
    }
    p.update(over)
    return p


def _test_ar_invoice_rebill(env):
    from actions import ar_invoice_rebill as r  # noqa: E402

    # ---- payload normalisation ------------------------------------------
    p = r.validate_payload(_ar_payload())
    assert p["cm"]["finish"] == "COMPLETE_AND_CLOSE", "finish defaults to complete"
    assert p["cm"]["transactionNumber"] == "INV00583863CM", "CM number defaults"
    assert p["duplicate"]["transactionSource"] == "DCT Manual", "source defaults"
    assert [l["lineNumber"] for l in p["lines"]] == [1, 3], "lines sorted by number"
    assert p["lines"][0]["taxClassification"] == "", "tax class optional per line"

    # an explicit CM number and finish survive normalisation
    p2 = r.validate_payload(_ar_payload(
        cm={"transactionNumber": "MYCM-1", "finish": "save",
            "transactionDate": "2026-02-28", "accountingDate": "2026-02-28"}))
    assert p2["cm"]["transactionNumber"] == "MYCM-1"
    assert p2["cm"]["finish"] == "SAVE", "finish is case-insensitive"

    # ---- payload rejections ---------------------------------------------
    bad = [
        ({"invoiceNumber": ""}, "invoiceNumber"),
        (_ar_payload(cm={"finish": "MAYBE", "transactionDate": "d",
                         "accountingDate": "d"}), "cm.finish"),
        (_ar_payload(cm={"transactionDate": "", "accountingDate": "d"}),
         "cm.transactionDate"),
        (_ar_payload(duplicate={"accountingDate": "d"}),
         "duplicate.transactionDate"),
        (_ar_payload(lines=[]), "at least one line"),
        (_ar_payload(lines=[{"lineNumber": "x", "memoLine": "m",
                             "projectNumber": "p", "taskNumber": "t"}]),
         "whole number"),
        (_ar_payload(lines=[{"lineNumber": 0, "memoLine": "m",
                             "projectNumber": "p", "taskNumber": "t"}]), ">= 1"),
        (_ar_payload(lines=[{"lineNumber": 1, "memoLine": "m",
                             "projectNumber": "p", "taskNumber": "t"},
                            {"lineNumber": 1, "memoLine": "m",
                             "projectNumber": "p", "taskNumber": "t"}]),
         "listed twice"),
        (_ar_payload(lines=[{"lineNumber": 1, "projectNumber": "p",
                             "taskNumber": "t"}]), "memoLine is required"),
        (_ar_payload(lines=[{"lineNumber": 1, "memoLine": "m",
                             "taskNumber": "t"}]), "projectNumber and taskNumber"),
        # memo line is the MATCHING KEY (user rule 2026-07-26): a payload that
        # repeats one is ambiguous by construction and must be rejected
        (_ar_payload(lines=[{"memoLine": "Same Memo", "projectNumber": "p",
                             "taskNumber": "t"},
                            {"memoLine": "same memo", "projectNumber": "p",
                             "taskNumber": "t"}]),
         "appears twice"),
    ]
    for payload, want in bad:
        try:
            r.validate_payload(payload)
            assert False, "payload must be rejected (%s): %r" % (want, payload)
        except RuntimeError as e:
            assert want in str(e), "expected %r in %r" % (want, str(e))

    # ---- the PROD allowlist guard ---------------------------------------
    prev = os.environ.get("ATD_AR_REBILL_ALLOW")
    try:
        os.environ["ATD_AR_REBILL_ALLOW"] = "inv00583863 , OTHER-1"
        r._check_allowlist("INV00583863")          # case-insensitive match
        r._check_allowlist("other-1")
        try:
            r._check_allowlist("INV99999999")
            assert False, "an off-list invoice must be refused"
        except RuntimeError as e:
            assert "not in ATD_AR_REBILL_ALLOW" in str(e)
        os.environ.pop("ATD_AR_REBILL_ALLOW")
        r._check_allowlist("ANYTHING")             # unset = go-live, no limit
    finally:
        if prev is None:
            os.environ.pop("ATD_AR_REBILL_ALLOW", None)
        else:
            os.environ["ATD_AR_REBILL_ALLOW"] = prev

    # ---- Fusion date handling -------------------------------------------
    # Fusion's date fields are dd/mm/yyyy; the API speaks ISO. Getting this
    # wrong is silent and expensive: 2026-03-04 typed raw has a valid but WRONG
    # dd/mm reading, so it would post to the wrong accounting period.
    assert r._fusion_date("2026-02-28") == "28/02/2026"
    assert r._fusion_date("28/02/2026") == "28/02/2026", "already-Fusion passes through"
    assert r._fusion_date("") == ""
    p3 = r.validate_payload(_ar_payload())
    assert p3["cm"]["transactionDate"] == "2026-02-28", "stored as given (ISO)"

    # ---- lineNumber is OPTIONAL: memo line matches, position numbers ----
    pauto = r.validate_payload(_ar_payload(lines=[
        {"memoLine": "First Memo", "projectNumber": "p", "taskNumber": "t"},
        {"memoLine": "Second Memo", "projectNumber": "p", "taskNumber": "t",
         "taxClassification": "VAT OUTPUT - STD"},
    ]))
    assert [ln["lineNumber"] for ln in pauto["lines"]] == [1, 2], \
        "absent lineNumbers default to payload position"
    assert pauto["lines"][1]["taxClassification"] == "VAT OUTPUT - STD"
    for badpay, want in (
        (_ar_payload(cm={"transactionDate": "28-02-2026", "accountingDate": "2026-02-28"}),
         "cm.transactionDate must be"),
        (_ar_payload(cm={"transactionDate": "2026-02-28", "accountingDate": "Feb 2026"}),
         "cm.accountingDate must be"),
        (_ar_payload(duplicate={"transactionDate": "2026/02/28",
                                "accountingDate": "2026-02-28"}),
         "duplicate.transactionDate must be"),
    ):
        try:
            r.validate_payload(badpay)
            assert False, "a malformed date must be rejected: %s" % want
        except RuntimeError as e:
            assert want in str(e), "expected %r in %r" % (want, str(e))

    # ---- the results grid, keyed by the ADF id scheme -------------------
    # Shape as diag_ar.py measured it on the ADGOV pod: {rowIndex: {comp: text}},
    # cl1 = Transaction Number, cl3 = Original Transaction Number (credit memos
    # only). A positional header->td scraper returned 13 rows of menu text here,
    # which is why this is id-keyed.
    grid = {"0": {r.GRID_TXN_NUMBER: "INV1"},
            "1": {r.GRID_TXN_NUMBER: "INV1CM", r.GRID_ORIG_TXN: "INV1"}}

    real_rows = r._grid_rows
    try:
        # readability assertion: the probe must SEE the invoice before it is
        # allowed to answer "no credit memo"
        r._grid_rows = lambda page: grid
        assert r._grid_assert_readable(None, "inv1", "t") == grid
        r._grid_rows = lambda page: {}
        try:
            r._grid_assert_readable(None, "INV1", "credit-memo probe")
            assert False, "an unreadable grid must raise, never answer 'absent'"
        except RuntimeError as e:
            assert "cannot be trusted" in str(e)

        # the probe that stops a duplicate credit memo
        r._grid_rows = lambda page: grid
        assert r._existing_credit_memo(None, "INV1") == "INV1CM"
        # an invoice with no credit memo: readable grid, honest None
        r._grid_rows = lambda page: {"0": {r.GRID_TXN_NUMBER: "INV2"}}
        assert r._existing_credit_memo(None, "INV2") is None
        # ...but if the grid cannot be read, it must RAISE rather than return
        # None -- returning None here is what would create a second credit memo
        r._grid_rows = lambda page: {"0": {r.GRID_TXN_NUMBER: "SOMETHINGELSE"}}
        try:
            r._existing_credit_memo(None, "INV2")
            assert False, "a grid without the invoice must raise"
        except RuntimeError as e:
            assert "cannot be trusted" in str(e)
    finally:
        r._grid_rows = real_rows

    # ---- the duplicate stamp probe --------------------------------------
    # The stamp is DISABLED by default (user decision 2026-07-25: write nothing
    # into a customer-visible field), so the probe must be INERT -- and must say
    # so by returning None rather than pretending to have checked.
    real_rows = r._grid_rows
    real_stamp_on = r.STAMP_ENABLED
    try:
        stamp = r.STAMP_TEMPLATE.format(invoice="INV1")
        r._grid_rows = lambda page: {"0": {r.GRID_TXN_NUMBER: "45110096148",
                                           "cl9": "x " + stamp + " y"}}
        r.STAMP_ENABLED = False
        assert r._existing_duplicate(None, "INV1") is None, \
            "with the stamp off the probe must not claim to have found one"
        # ...and still works when the stamp is switched back on
        r.STAMP_ENABLED = True
        assert r._existing_duplicate(None, "INV1") == "45110096148"
        assert r._existing_duplicate(None, "INV2") is None
    finally:
        r._grid_rows = real_rows
        r.STAMP_ENABLED = real_stamp_on

    # ---- document-number validation -------------------------------------
    # Stage 9 once captured the COLUMN HEADER "Transaction Number" and reported
    # DONE, which would have written that string into the AR register as the
    # invoice identifier. A capture that is not a number must fail.
    assert r._valid_doc_number("45110096150")
    assert r._valid_doc_number(" 45110096149 ")
    assert not r._valid_doc_number("Transaction Number")
    assert not r._valid_doc_number("Document Number")
    assert not r._valid_doc_number("")
    assert not r._valid_doc_number(None)
    assert not r._valid_doc_number("12345")          # too short
    assert not r._valid_doc_number("INV00584150CM")  # a transaction number

    # ---- retry guard on the invoice-creating commit ---------------------
    # attempt > 1 with no confirmed duplicate must refuse rather than risk a
    # second completed invoice
    class _Saga:
        def __init__(self, a):
            self.attempt = a

    run = r._Run(None, "b", r.validate_payload(_ar_payload()), _Saga(2))
    try:
        r._stage_dup_complete(run)
        assert False, "a retry with no confirmed duplicate must refuse"
    except RuntimeError as e:
        assert "Refusing to complete a second invoice" in str(e)
    run.new_txn_number = "45110096148"   # confirmed -> allowed past the guard
    prev_live = os.environ.get("ATD_ACTION_LIVE")
    try:
        os.environ.pop("ATD_ACTION_LIVE", None)
        try:
            r._stage_dup_complete(run)
            assert False, "should reach the dry-run gate, not the retry guard"
        except DryRun:
            pass
    finally:
        if prev_live is None:
            os.environ.pop("ATD_ACTION_LIVE", None)
        else:
            os.environ["ATD_ACTION_LIVE"] = prev_live

    # ---- memo-line verification stops the robot coding the wrong row ----
    real_cell = r._line_cell
    try:
        r._line_cell = lambda page, no, hdr: {"text": "Entertainer Permit", "id": "x"}
        assert r._verify_memo_line(None, {"lineNumber": 1,
                                          "memoLine": "entertainer permit"})
        try:
            r._verify_memo_line(None, {"lineNumber": 1, "memoLine": "Something Else"})
            assert False, "a memo-line mismatch must abort"
        except RuntimeError as e:
            assert "memo line mismatch" in str(e)
        r._line_cell = lambda page, no, hdr: None
        try:
            r._verify_memo_line(None, {"lineNumber": 7, "memoLine": "m"})
            assert False, "a missing line must abort"
        except RuntimeError as e:
            assert "not found on the duplicate" in str(e)
    finally:
        r._line_cell = real_cell

    # ---- duplicate line-grid row matching -------------------------------
    # The request names a LINE NUMBER; the ADF grid is addressed by ROW INDEX.
    # They usually differ by one, but the sample invoice has two lines sharing
    # the memo line "Entertainer Permit", so a wrong match taxes the wrong line.
    grid = {"0": "Entertainer Permit",
            "1": "Entertainer Permit",
            "2": "Revenue fees from Urgent request"}
    real_grid = r._dup_line_rows
    try:
        r._dup_line_rows = lambda p: grid
        assert r._dup_row_for_line(None, {"lineNumber": 3,
                                          "memoLine": "Revenue fees from Urgent request"}) == "2"
        assert r._dup_row_for_line(None, {"lineNumber": 1,
                                          "memoLine": "Entertainer Permit"}) == "0"
        assert r._dup_row_for_line(None, {"lineNumber": 2,
                                          "memoLine": "Entertainer Permit"}) == "1"
        for line, want in (
            ({"lineNumber": 1, "memoLine": "Something Else"}, "refusing to change"),
            ({"lineNumber": 9, "memoLine": "Entertainer Permit"}, "refusing to guess"),
        ):
            try:
                r._dup_row_for_line(None, line)
                assert False, "must abort rather than guess: %r" % line
            except RuntimeError as e:
                assert want in str(e), "expected %r in %r" % (want, str(e))
        # patch the WAIT, not the read -- _dup_row_for_line polls for 60s
        real_wait2 = r._wait_for_line_grid
        try:
            r._wait_for_line_grid = lambda page, timeout=60: {}
            try:
                r._dup_row_for_line(None, {"lineNumber": 1, "memoLine": "x"})
                assert False, "an unreadable grid must abort"
            except RuntimeError as e:
                assert "still unreadable" in str(e)
        finally:
            r._wait_for_line_grid = real_wait2
    finally:
        r._dup_line_rows = real_grid

    # ---- stage table: resume_from() assumes contiguous 1..N -------------
    nums = [n for n, _, _ in r.STAGES]
    assert nums == list(range(1, len(r.STAGES) + 1)), \
        "stage numbers must be contiguous from 1 -- resume_from() walks them"
    assert len({c for _, c, _ in r.STAGES}) == len(r.STAGES), \
        "stage codes must be unique (they key ATD_ACTION_STEP)"

    # ---- dry-run gate ---------------------------------------------------
    prev_live = os.environ.get("ATD_ACTION_LIVE")
    try:
        os.environ.pop("ATD_ACTION_LIVE", None)
        run = r._Run(None, "https://erp.example.com", r.validate_payload(_ar_payload()), None)
        try:
            run.gate("Complete and Close")
            assert False, "the gate must raise DryRun when ATD_ACTION_LIVE is unset"
        except DryRun as e:
            assert "nothing committed" in str(e)
        os.environ["ATD_ACTION_LIVE"] = "1"
        run.gate("Complete and Close")   # live: no raise
    finally:
        if prev_live is None:
            os.environ.pop("ATD_ACTION_LIVE", None)
        else:
            os.environ["ATD_ACTION_LIVE"] = prev_live

    # ---- grid row resolution must never fall through to "whichever row" ---
    # On 45110096152 line 3's row-specific Details icon missed, the old code
    # fell back to a bare [title="Details"] that opens the FIRST row, and
    # line 3's Project/Task were written over line 1's -- while the stage
    # reported "project/task set on lines 1,2,3". The grid lookup itself is
    # the first line of defence: it matches on memo line and refuses to guess.
    grid = {"0": "Public speaker permit", "1": "Event Permit",
            "2": "Revenue fees from Urgent request"}
    real_rows = r._dup_line_rows
    try:
        r._dup_line_rows = lambda page: grid
        # payload line numbers do NOT match Fusion's row order here (Fusion
        # line 1 is Public speaker permit) -- the memo line is what decides
        assert r._dup_row_for_line(None, {"lineNumber": 1,
                                          "memoLine": "Event Permit"}) == "1"
        assert r._dup_row_for_line(None, {"lineNumber": 3,
                                          "memoLine": "Revenue fees from Urgent request"}) == "2"
        # a memo line that is not on the duplicate must RAISE, never resolve
        try:
            r._dup_row_for_line(None, {"lineNumber": 2, "memoLine": "Parking Fee"})
            assert False, "an absent memo line must raise, not pick a row"
        except RuntimeError as e:
            assert "refusing to change a line that was not requested" in str(e)
        # and an unreadable grid must raise rather than default to row 0.
        # Patch the WAIT, not the read: _dup_row_for_line polls for 60s before
        # giving up (the grid renders asynchronously), and a unit test must not
        # sit through that.
        real_wait = r._wait_for_line_grid
        try:
            r._wait_for_line_grid = lambda page, timeout=60: {}
            try:
                r._dup_row_for_line(None, {"lineNumber": 1,
                                           "memoLine": "Event Permit"})
                assert False, "an unreadable grid must raise"
            except RuntimeError as e:
                assert "still unreadable" in str(e)
        finally:
            r._wait_for_line_grid = real_wait

        # the wait itself: returns as soon as the grid appears, and gives up
        # rather than looping forever
        calls = {"n": 0}

        def _late(page):
            calls["n"] += 1
            return grid if calls["n"] >= 2 else {}

        r._dup_line_rows = _late
        assert r._wait_for_line_grid(None, timeout=10) == grid
        assert calls["n"] >= 2, "the wait must re-read, not answer from one look"
        r._dup_line_rows = lambda page: {}
        assert r._wait_for_line_grid(None, timeout=1) == {}
    finally:
        r._dup_line_rows = real_rows

    # ---- pre-commit header-date guard -----------------------------------
    # Stage 7's line saves make Fusion re-run the invoicing rule, which resets
    # the header Accounting Date to the revenue-schedule start (measured on
    # 45110096152: 28/02 -> 18/02). Stage 6's verified fill cannot catch that,
    # so stage 8 re-reads the field before completing.
    run = r._Run(None, "https://erp.example.com", r.validate_payload(_ar_payload()), None)
    real_read, real_fill = r._read_by_id_suffix, r._fill_verified
    try:
        seen = {"reads": [], "fills": []}

        # (a) both dates already correct -> nothing is re-typed
        r._read_by_id_suffix = lambda p, s, **k: "28/02/2026"
        r._fill_verified = lambda *a, **k: seen["fills"].append(a) or True
        r._reassert_header_dates(run)
        assert not seen["fills"], "a correct date must not be re-typed"

        # (b) accounting date drifted and the re-fill HOLDS -> repaired quietly
        state = {"v": "18/02/2026"}

        def _read_drift(p, s, **k):
            seen["reads"].append(s)
            return state["v"] if "inputDate9" in s else "28/02/2026"

        def _fill_ok(page, what, value, **k):
            state["v"] = value
            seen["fills"].append(what)
            return True

        r._read_by_id_suffix, r._fill_verified = _read_drift, _fill_ok
        r._reassert_header_dates(run)
        assert state["v"] == "28/02/2026", "the drifted date must be re-set"
        assert any("accounting date" in f for f in seen["fills"])

        # (c) drifted and the re-fill does NOT hold -> refuse to complete.
        #     Completing here would post the invoice to a period nobody asked
        #     for, which is the whole reason this guard exists.
        r._read_by_id_suffix = lambda p, s, **k: ("18/02/2026" if "inputDate9" in s
                                                  else "28/02/2026")
        r._fill_verified = lambda *a, **k: True
        try:
            r._reassert_header_dates(run)
            assert False, "a date that will not hold must raise, not complete"
        except RuntimeError as e:
            assert "accounting date nobody requested" in str(e)

        # (d) unreadable field (the Edit Transaction resume page uses other
        #     ids) -> warn and continue, so a resume is never blocked
        r._read_by_id_suffix = lambda p, s, **k: None
        r._reassert_header_dates(run)
    finally:
        r._read_by_id_suffix, r._fill_verified = real_read, real_fill

    # ---- dispatch routes AR_INVOICE_REBILL (validation fires before any
    #      browser work, so a bad payload never reaches Fusion) -----------
    try:
        actions.dispatch(None, env, {"action_type": "AR_INVOICE_REBILL",
                                     "payload_json": "{}"})
        assert False
    except RuntimeError as e:
        assert "AR_INVOICE_REBILL payload needs invoiceNumber" in str(e)

    print("  AR_INVOICE_REBILL unit tests passed")


if __name__ == "__main__":
    main()
