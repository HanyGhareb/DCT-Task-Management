"""Unit tests for the PBT extract handler - no network, no DB.

Every case here is a real gotcha found while probing the live API
(docs/fusion-actions/pbt-api-spec.md section 5), not a hypothetical.
"""
import os
import sys
from datetime import datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from actions import pa_budget_trx as pbt   # noqa: E402


# --- dates: THREE different formats, varying by type ------------------------
def test_header_date_iso():
    assert pbt._date("2026-08-07") == datetime(2026, 8, 7)


def test_header_creation_date_is_dd_mm_yyyy():
    # header creation_date arrives as 07-08-2026 = 7 August, NOT 8 July
    assert pbt._date("07-08-2026") == datetime(2026, 8, 7)


def test_additional_line_date_is_dd_mon_yy():
    assert pbt._date("07-AUG-26") == datetime(2026, 8, 7)


def test_approval_date_is_iso_timestamp():
    assert pbt._date("2026-08-07T04:19:57Z") == datetime(2026, 8, 7, 4, 19, 57)


def test_unparseable_date_is_null_not_crash():
    assert pbt._date("not a date") is None
    assert pbt._date(None) is None
    assert pbt._date("") is None


# --- numbers: commitments ships as a STRING ---------------------------------
def test_commitments_string_becomes_number():
    assert pbt._num("528250") == 528250


def test_number_passthrough_and_commas():
    assert pbt._num(3749807.24) == 3749807.24
    assert pbt._num("1,234.50") == 1234.5


def test_bad_number_is_null():
    assert pbt._num("N/A") is None
    assert pbt._num(None) is None
    assert pbt._num("") is None


# --- text -------------------------------------------------------------------
def test_long_text_truncated_to_column_width():
    assert len(pbt._text("x" * 9000, "notes")) == 4000
    assert len(pbt._text("x" * 9000, "cost_center")) == 400


def test_non_string_scalar_becomes_text():
    assert pbt._text(2026) == "2026"


# --- row hash: the SHALLOW sync's change detector ---------------------------
def _hdr(**over):
    row = {k: None for k, _c, _t in pbt.HEADER_FIELDS}
    row.update({"identifier": 27690, "transaction_num": "012185",
                "transaction_type": "Additional", "status": "Baselined",
                "transaction_date": "2026-08-07"})
    row.update(over)
    return row


def test_hash_is_stable_for_identical_rows():
    assert pbt._row_hash(_hdr()) == pbt._row_hash(_hdr())


def test_hash_changes_when_status_changes():
    assert pbt._row_hash(_hdr()) != pbt._row_hash(_hdr(status="Rejected"))


def test_hash_ignores_fields_outside_the_header_contract():
    # an unknown field appearing upstream must not churn every row into the
    # "changed" bucket on the next sync
    assert pbt._row_hash(_hdr()) == pbt._row_hash(_hdr(brand_new_field="x"))


# --- scope filtering (the API has no server-side range) ---------------------
D = pbt._date


def test_range_filter_is_inclusive_both_ends():
    m = {"transaction_date": "2026-08-07", "status": "Baselined",
         "business_unit": "Department of Culture and Tourism"}
    bus = ["Department of Culture and Tourism"]
    assert pbt._in_scope(m, D("2026-08-07"), D("2026-08-07"), None, bus)
    assert pbt._in_scope(m, D("2026-08-01"), D("2026-08-31"), None, bus)
    assert not pbt._in_scope(m, D("2026-08-08"), D("2026-08-31"), None, bus)
    assert not pbt._in_scope(m, D("2026-07-01"), D("2026-08-06"), None, bus)


def test_status_filter():
    m = {"transaction_date": "2026-08-07", "status": "Entered",
         "business_unit": "DCT"}
    assert pbt._in_scope(m, None, None, ["Entered"], ["DCT"])
    assert not pbt._in_scope(m, None, None, ["Baselined"], ["DCT"])


def test_bu_filter():
    m = {"transaction_date": "2026-08-07", "status": "Baselined",
         "business_unit": "Museum Shared Services"}
    assert pbt._in_scope(m, None, None, None, ["Museum Shared Services"])
    assert not pbt._in_scope(m, None, None, None, ["Abrahamic Family House"])


def test_full_scope_only_when_unfiltered():
    # deletion reconciliation must NOT fire on a partial pull, or a date-ranged
    # run would report every transaction outside its range as "missing"
    assert pbt._full_scope(None, None, None)
    assert not pbt._full_scope(D("2026-01-01"), None, None)
    assert not pbt._full_scope(None, None, ["Baselined"])


# --- generated SQL ----------------------------------------------------------
def test_merge_is_keyed_on_identifier_and_casts_every_bind():
    sql = pbt._merge_sql("prod.t", pbt.HEADER_FIELDS,
                         [("load_run_id", "NUMBER")])
    assert "ON (t.identifier = s.identifier)" in sql
    assert "CAST(:identifier AS NUMBER)" in sql
    assert "CAST(:transaction_date AS DATE)" in sql
    assert "t.identifier = s.identifier" not in sql.split("UPDATE SET")[1]


def test_every_type_has_a_table_and_field_map():
    for t in pbt.DEFAULT_TYPES:
        assert t in pbt.LINE_TABLE
        assert t in pbt.LINE_FIELDS
        cols = [c for _j, c, _k in pbt.LINE_FIELDS[t]]
        assert len(cols) == len(set(cols)), f"{t} has duplicate columns"


def test_line_field_counts_match_the_observed_payloads():
    # 34 / 21 / 38 fields as measured from the live API
    assert len(pbt.LINE_FIELDS["Additional"]) == 34
    assert len(pbt.LINE_FIELDS["Estimated-Cost"]) == 21
    assert len(pbt.LINE_FIELDS["Annual-Budget"]) == 38
    assert len(pbt.HEADER_FIELDS) == 20
    assert len(pbt.APPROVAL_FIELDS) == 8   # + transaction_num/trx_type/seq_no


def test_hyphenated_type_codes_are_the_literal_api_values():
    # a wrong value returns HTTP 200 with ZERO rows, never an error
    assert pbt.DEFAULT_TYPES == ["Additional", "Estimated-Cost", "Annual-Budget"]
