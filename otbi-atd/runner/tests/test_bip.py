"""Unit tests for bip.py (BIP .xdo export URL + XLSX->CSV conversion).

Run from runner/:  python -m pytest tests/test_bip.py -q     (needs openpyxl)
"""
import csv
import io
import os
import sys
from datetime import datetime

import openpyxl
import pytest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import bip  # noqa: E402

CMAP = {
    "Business Unit": "BUSINESS_UNIT",
    "Document Type": "DOCUMENT_TYPE",
    "Document Number": "DOCUMENT_NUMBER",
    "Status": "STATUS",
    "Preparer/Buyer": "PREPARER_BUYER",
    "Submitted for Approval Date": "SUBMITTED_FOR_APPROVAL_DATE",
    "Pending with Last Approver": "PENDING_WITH_LAST_APPROVER",
    "Pending Approval Days": "PENDING_APPROVAL_DAYS",
}


def _wb_bytes(rows):
    wb = openpyxl.Workbook()
    ws = wb.active
    for r in rows:
        ws.append(r)
    buf = io.BytesIO()
    wb.save(buf)
    return buf.getvalue()


def _sample_xlsx():
    return _wb_bytes([
        ["ADG Document Status Report", None, None, None, None, None, None, None, None],
        ["Business Unit: All   Status: PENDING APPROVAL", None, None, None, None, None, None, None, None],
        [None, None, None, None, None, None, None, None, None],
        # header row: 8 wanted + 1 extra column the report ships that we must IGNORE
        ["Business Unit", "Document Type", "Document Number", "STATUS", "Preparer/Buyer",
         "Submitted for Approval Date", "Pending with Last Approver", "Pending Approval Days",
         "Total Amount"],
        ["ADGE BU", "REQUISITION", "REQ-1001", "PENDING APPROVAL", "Jasim M",
         datetime(2026, 7, 1, 9, 30, 0), "Head of Procurement", 15.0, 1234.56],
        # no Document Number -> excluded
        ["ADGE BU", "STANDARD", None, "PENDING APPROVAL", "Someone",
         datetime(2026, 7, 2), "Approver X", 3.0, 99],
        # fully blank separator -> excluded
        [None, None, None, None, None, None, None, None, None],
        ["ADGE BU", "STANDARD", "PO-2002", "PENDING APPROVAL", "Fatima A",
         datetime(2026, 7, 10, 14, 5, 6), None, 5.5, 42],
    ])


def test_build_export_url_strips_directives_and_repeats_arrays():
    url = bip.build_export_url(
        "https://host/xmlpserver",
        "/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo",
        "xlsx",
        {"_xt": "ADG Document Status Report",
         "_paramsP_BU": "*",
         "_paramsP_DOCTYPE": ["REQUISITION", "STANDARD"],
         "_paramsP_STATUS": "PENDING APPROVAL",
         "_atd_require": "Document Number"})
    assert url.startswith("https://host/xmlpserver/Custom/ADGE%20Procurement%20Reports/"
                          "Purchasing/ADG%20Document%20Status%20Report.xdo?")
    assert "_xpt=1" in url and "_xf=xlsx" in url and "_xautorun=true" in url
    assert url.count("_paramsP_DOCTYPE=") == 2
    assert "_paramsP_DOCTYPE=REQUISITION" in url and "_paramsP_DOCTYPE=STANDARD" in url
    assert "PENDING+APPROVAL" in url or "PENDING%20APPROVAL" in url
    assert "_atd_require" not in url


def test_xmlp_base_prefers_env_column_and_derives_fallback():
    assert bip.xmlp_base({"xmlpserver_base_url": "https://h/xmlpserver/"}) == "https://h/xmlpserver"
    assert bip.xmlp_base({"xmlpserver_base_url": None,
                          "analytics_base_url": "https://h/analytics"}) == "https://h/xmlpserver"
    with pytest.raises(RuntimeError):
        bip.xmlp_base({"env_name": "X", "analytics_base_url": "https://h/other"})


def test_xlsx_to_csv_projects_mapped_columns_and_filters_rows():
    out = bip.xlsx_to_csv(_sample_xlsx(), CMAP, require_header="Document Number")
    rows = list(csv.reader(io.StringIO(out)))
    assert rows[0] == list(CMAP.keys())          # header = map keys, map order
    assert len(rows) == 3                        # 2 data rows survive the filters
    r1, r2 = rows[1], rows[2]
    assert r1 == ["ADGE BU", "REQUISITION", "REQ-1001", "PENDING APPROVAL", "Jasim M",
                  "2026-07-01 09:30:00", "Head of Procurement", "15"]
    assert r2[2] == "PO-2002" and r2[6] == "" and r2[7] == "5.5"
    assert "Total Amount" not in out             # unmapped column never emitted


def test_xlsx_to_csv_header_matching_is_case_insensitive():
    # sheet header says 'STATUS'; the map key is 'Status' and must still match,
    # and the emitted header must be the MAP's text (so load.resolve_pairs hits)
    out = bip.xlsx_to_csv(_sample_xlsx(), CMAP, require_header="Document Number")
    assert out.splitlines()[0].split(",")[3] == "Status"


def test_xlsx_to_csv_missing_mapped_header_raises():
    bad = _wb_bytes([["Only", "Wrong", "Headers"], ["a", "b", "c"]])
    with pytest.raises(RuntimeError):
        bip.xlsx_to_csv(bad, CMAP)


def test_xlsx_to_csv_no_map_takes_all_headers():
    out = bip.xlsx_to_csv(_sample_xlsx())
    header = out.splitlines()[0]
    assert "Total Amount" in header              # unmapped mode keeps everything


def test_loader_parses_converted_csv():
    """The converted CSV must resolve through load.resolve_pairs (end-to-end of
    the text contract: emitted header text == column_map keys)."""
    from prepare import resolve_pairs
    out = bip.xlsx_to_csv(_sample_xlsx(), CMAP, require_header="Document Number")
    raw_headers = next(csv.reader(io.StringIO(out)))
    pairs = resolve_pairs(CMAP, raw_headers)
    assert [c for _, c in pairs] == list(CMAP.values())
