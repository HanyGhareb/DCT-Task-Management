"""API tests for the /rpt/templates* endpoints (reporting/db/20a).

Covers Happy / Edge / Error (400/401/403/404/409/413) / Boundary.
Run: pytest reporting/tests/test_templates_api.py -v
Env override: RPT_ORDS_BASE, RPT_ADMIN_USER/PW, RPT_PLAIN_USER/PW.
"""
import os
import uuid

import pytest
import requests

ORDS = os.environ.get(
    "RPT_ORDS_BASE",
    "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin")
ADMIN = (os.environ.get("RPT_ADMIN_USER", "ADMIN"),
         os.environ.get("RPT_ADMIN_PW", "iFinance@2026"))
PLAIN = (os.environ.get("RPT_PLAIN_USER", "NASER.ALKHAJA"),
         os.environ.get("RPT_PLAIN_PW", "Manager@2026"))

TPL_BODY = b"<html><body>{{ report_name }} :: {{ row_count }}</body></html>"
OCTET = {"Content-Type": "application/octet-stream"}


def login(creds):
    r = requests.post(ORDS + "/dct/auth/login",
                      json={"username": creds[0], "password": creds[1]}, timeout=60)
    r.raise_for_status()
    return {"Authorization": "Bearer " + r.json()["sessionId"]}


@pytest.fixture(scope="module")
def adm():
    return login(ADMIN)


@pytest.fixture(scope="module")
def tpl_name():
    name = f"pytest_{uuid.uuid4().hex[:8]}.j2"
    yield name
    requests.delete(f"{ORDS}/rpt/templates/{name}", headers=login(ADMIN), timeout=60)


# --- happy path -------------------------------------------------------------

def test_upload_creates(adm, tpl_name):
    r = requests.put(f"{ORDS}/rpt/templates/{tpl_name}?descr=pytest",
                     data=TPL_BODY, headers={**adm, **OCTET}, timeout=60)
    assert r.status_code == 200, r.text
    j = r.json()
    assert j["ok"] is True and j["created"] is True
    assert j["fileSize"] == len(TPL_BODY)


def test_list_contains_upload(adm, tpl_name):
    r = requests.get(f"{ORDS}/rpt/templates/", headers=adm, timeout=60)
    assert r.status_code == 200
    items = {i["name"]: i for i in r.json()["items"]}
    assert tpl_name in items
    it = items[tpl_name]
    assert it["kind"] == "HTML"
    assert it["fileSize"] == len(TPL_BODY)
    assert it["usedBy"] == 0
    assert it["description"] == "pytest"


def test_download_roundtrip(adm, tpl_name):
    r = requests.get(f"{ORDS}/rpt/templates/{tpl_name}", headers=adm, timeout=60)
    assert r.status_code == 200
    assert r.content == TPL_BODY
    assert "attachment" in r.headers.get("Content-Disposition", "")


def test_replace_not_created(adm, tpl_name):
    body2 = TPL_BODY + b"<!-- v2 -->"
    r = requests.put(f"{ORDS}/rpt/templates/{tpl_name}",
                     data=body2, headers={**adm, **OCTET}, timeout=60)
    assert r.status_code == 200
    assert r.json()["created"] is False
    r = requests.get(f"{ORDS}/rpt/templates/{tpl_name}", headers=adm, timeout=60)
    assert r.content == body2


def test_delete(adm):
    name = f"pytest_{uuid.uuid4().hex[:8]}.j2"
    requests.put(f"{ORDS}/rpt/templates/{name}", data=TPL_BODY,
                 headers={**adm, **OCTET}, timeout=60)
    r = requests.delete(f"{ORDS}/rpt/templates/{name}", headers=adm, timeout=60)
    assert r.status_code == 200
    r = requests.delete(f"{ORDS}/rpt/templates/{name}", headers=adm, timeout=60)
    assert r.status_code == 404


# --- auth -------------------------------------------------------------------

def test_401_no_token():
    assert requests.get(f"{ORDS}/rpt/templates/", timeout=60).status_code == 401


def test_403_non_admin(tpl_name):
    h = login(PLAIN)
    assert requests.get(f"{ORDS}/rpt/templates/", headers=h, timeout=60).status_code == 403
    r = requests.put(f"{ORDS}/rpt/templates/{tpl_name}", data=TPL_BODY,
                     headers={**h, **OCTET}, timeout=60)
    assert r.status_code == 403


# --- validation / errors ----------------------------------------------------

def test_400_bad_extension(adm):
    r = requests.put(f"{ORDS}/rpt/templates/evil.txt", data=TPL_BODY,
                     headers={**adm, **OCTET}, timeout=60)
    assert r.status_code == 400


def test_400_empty_body(adm):
    r = requests.put(f"{ORDS}/rpt/templates/empty_test.j2", data=b"",
                     headers={**adm, **OCTET}, timeout=60)
    assert r.status_code == 400


def test_404_unknown_download(adm):
    r = requests.get(f"{ORDS}/rpt/templates/no_such_{uuid.uuid4().hex[:6]}.j2",
                     headers=adm, timeout=60)
    assert r.status_code == 404


def test_409_delete_in_use(adm):
    """A template referenced by a definition must refuse deletion."""
    r = requests.get(f"{ORDS}/rpt/templates/", headers=adm, timeout=60)
    used = [i["name"] for i in r.json()["items"] if i["usedBy"] > 0]
    if not used:
        pytest.skip("no DB template is referenced by a definition yet")
    r = requests.delete(f"{ORDS}/rpt/templates/{used[0]}", headers=adm, timeout=60)
    assert r.status_code == 409


# --- boundary ---------------------------------------------------------------

@pytest.mark.slow
def test_413_oversize(adm):
    """TEMPLATE_MAX_MB defaults to 10 -- an 11 MB body must 413."""
    if os.environ.get("RPT_SKIP_SLOW") == "1":
        pytest.skip("slow test skipped by env")
    big = b"x" * (11 * 1024 * 1024)
    r = requests.put(f"{ORDS}/rpt/templates/oversize_test.j2", data=big,
                     headers={**adm, **OCTET}, timeout=300)
    assert r.status_code == 413
