"""
API test suite for the Task Management ORDS module (tm.rest, /ords/admin/tm/).

Run:
    set TM_BASE=https://<host>/ords/admin      (or http://localhost:8080/ords/admin via dev-proxy)
    set TM_USER=ADMIN
    set TM_PASS=********                         # never hardcode; read from env
    pytest "final apps/TM/tests/api" -v

Covers the four mandatory classes per resource: Happy / Edge / Error(400/401/404) /
Boundary. A valid token is fetched once via /dct/auth/login; a tampered token
exercises 401. Created teams are left in place (no destructive cleanup endpoint);
use a disposable DB or the UAT cleanup script to reset.
"""
import os
import pytest
import requests

BASE = os.environ.get("TM_BASE", "http://localhost:8080/ords/admin").rstrip("/")
USER = os.environ.get("TM_USER")
PASS = os.environ.get("TM_PASS")

pytestmark = pytest.mark.skipif(not (USER and PASS),
                                reason="set TM_USER / TM_PASS env vars to run live API tests")


def _auth_header(tok):
    return {"Authorization": f"Bearer {tok}"}


@pytest.fixture(scope="session")
def token():
    r = requests.post(f"{BASE}/dct/auth/login",
                      json={"username": USER, "password": PASS}, timeout=30)
    assert r.status_code == 200, f"login failed: {r.status_code} {r.text}"
    body = r.json()
    tok = body.get("token") or body.get("sessionToken")
    assert tok, f"no token in login response: {list(body)}"
    return tok


# ---------- Auth / error handling ----------
def test_boot_requires_auth():
    assert requests.get(f"{BASE}/tm/boot", timeout=30).status_code == 401   # no token

def test_boot_rejects_bad_token():
    r = requests.get(f"{BASE}/tm/boot", headers=_auth_header("not-a-real-token"), timeout=30)
    assert r.status_code == 401

def test_unknown_team_is_404(token):
    r = requests.get(f"{BASE}/tm/teams/999999999", headers=_auth_header(token), timeout=30)
    assert r.status_code == 404


# ---------- Happy path ----------
def test_boot_returns_lookups_and_roles(token):
    j = requests.get(f"{BASE}/tm/boot", headers=_auth_header(token), timeout=30).json()
    assert any(l["category"] == "TM_TEAM_TYPE" for l in j["lookups"])     # 14 TM_* sets seeded
    assert any(r["code"] == "LEADER" for r in j["roles"])                 # team-role templates

def test_dashboard_shape(token):
    j = requests.get(f"{BASE}/tm/dashboard", headers=_auth_header(token), timeout=30).json()
    for k in ("myTeams", "myOpenTasks", "myOverdue", "openRisks", "deliverablesDue"):
        assert k in j

@pytest.fixture(scope="session")
def team_id(token):
    body = {"nameEn": "API Test Team", "type": "INTERNAL", "class": "STRATEGIC", "category": "PROJECT"}
    r = requests.post(f"{BASE}/tm/teams", headers=_auth_header(token), json=body, timeout=30)
    assert r.status_code == 201, r.text
    return r.json()["teamId"]

def test_team_created_and_listed(token, team_id):
    j = requests.get(f"{BASE}/tm/teams?search=API Test Team", headers=_auth_header(token), timeout=30).json()
    assert {"items", "total", "limit", "offset"} <= j.keys()              # pagination envelope
    assert any(t["teamId"] == team_id for t in j["items"])

def test_create_then_status_task(token, team_id):
    r = requests.post(f"{BASE}/tm/tasks", headers=_auth_header(token),
                      json={"teamId": team_id, "title": "API task", "dueDate": "2026-12-31"}, timeout=30)
    tid = r.json()["taskId"]
    assert tid > 0
    r2 = requests.post(f"{BASE}/tm/tasks/status", headers=_auth_header(token),
                       json={"taskId": tid, "status": "DONE"}, timeout=30)
    assert r2.status_code == 200


# ---------- Validation (400) + Boundary ----------
@pytest.mark.parametrize("bad", [
    {"nameEn": "", "type": "INTERNAL", "class": "STRATEGIC"},             # empty required name
    {"nameEn": "X", "type": "NOPE", "class": "STRATEGIC"},                # invalid lookup -> 400 (-20090)
    {"nameEn": "X", "class": "STRATEGIC"},                                # missing required type
])
def test_team_validation_400(token, bad):
    r = requests.post(f"{BASE}/tm/teams", headers=_auth_header(token), json=bad, timeout=30)
    assert r.status_code == 400

@pytest.mark.parametrize("length,expected", [(1, 201), (200, 201), (201, 400)])
def test_team_name_length_boundary(token, length, expected):
    body = {"nameEn": "X" * length, "type": "INTERNAL", "class": "OPERATIONAL"}
    r = requests.post(f"{BASE}/tm/teams", headers=_auth_header(token), json=body, timeout=30)
    assert r.status_code == expected                                      # ok up to 200, 400 at 201

def test_progress_boundary_400(token, team_id):
    r = requests.post(f"{BASE}/tm/tasks", headers=_auth_header(token),
                      json={"teamId": team_id, "title": "OverPct", "progress": 101}, timeout=30)
    assert r.status_code == 400                                           # pct 101 -> -20001

def test_reminder_pref_boundary_400(token):
    r = requests.post(f"{BASE}/tm/prefs", headers=_auth_header(token),
                      json={"leadDays": -1}, timeout=30)
    assert r.status_code == 400                                           # negative lead_days

def test_documents_empty_filter_is_200(token):
    r = requests.get(f"{BASE}/tm/documents?search=__nomatch__", headers=_auth_header(token), timeout=30)
    assert r.status_code == 200                                           # empty set, never 500
