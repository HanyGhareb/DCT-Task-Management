#!/usr/bin/env python3
"""API smoke for the GL DOF endpoints (GL/db/17 + db/v2/111).

Hits ORDS directly (no dev-proxy needed). Auth = the Admin quick-login
credentials, same source as lov_verify.py. Upload/notes tests use budget
year 2030 so live data is untouched; the script cleans its own rows up
via the same endpoints (PUT with empty text deletes; cashflow rows are
re-upserted to 0 and left — they are inert for real years).

Run: python3 dof_api_smoke.py
"""
import json, re, sys, urllib.request, urllib.error

ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
TEST_YEAR = 2030

PASS = 0
FAIL = 0


def check(name, ok, detail=""):
    global PASS, FAIL
    if ok:
        PASS += 1
        print(f"  PASS  {name}")
    else:
        FAIL += 1
        print(f"  FAIL  {name}  {detail}")


def req(method, path, tok=None, body=None, raw=False):
    url = ORDS + path
    data = json.dumps(body).encode() if body is not None else None
    headers = {}
    if body is not None:
        headers["Content-Type"] = "application/json"
    if tok:
        headers["Authorization"] = "Bearer " + tok
    r = urllib.request.Request(url, data=data, method=method, headers=headers)
    try:
        with urllib.request.urlopen(r, timeout=120) as resp:
            payload = resp.read()
            return resp.status, (payload if raw else json.loads(payload or b"{}"))
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b"{}")
        except Exception:
            return e.code, {}


def main():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                      open(AUTH).read())[0]
    st, s = req("POST", "/dct/auth/login", body={"username": u, "password": p})
    if st != 200 or "sessionId" not in s:
        sys.exit(f"login failed: {st} {s}")
    tok = s["sessionId"]
    print(f"logged in as {u}")

    # -- 401 unauthenticated ------------------------------------------------
    st, _ = req("GET", "/gl/dof/yoy?year=2026")
    check("yoy 401 without token", st == 401, st)

    # -- 400 validation -----------------------------------------------------
    st, _ = req("GET", "/gl/dof/yoy", tok)
    check("yoy 400 without year", st == 400, st)
    st, _ = req("GET", "/gl/dof/yoy?year=2026&period=13-2026", tok)
    check("yoy 400 bad period", st == 400, st)
    st, _ = req("POST", "/gl/dof/register", tok, {"report": "NOPE", "year": 2026})
    check("register 400 bad report", st == 400, st)

    # -- YoY dataset --------------------------------------------------------
    st, d = req("GET", "/gl/dof/yoy?year=2026", tok)
    check("yoy 200", st == 200, st)
    rows = d.get("rows", [])
    det = [r for r in rows if r.get("rowType") == "DETAIL"]
    tot = [r for r in rows if r.get("rowType") == "CHTOTAL"]
    gr = [r for r in rows if r.get("rowType") == "GRAND"]
    check("yoy has detail rows", len(det) > 50, len(det))
    check("yoy has chapter totals", len(tot) >= 4, len(tot))
    check("yoy has one grand total", len(gr) == 1, len(gr))
    if gr and det:
        sd = sum(r["actualYtd"] for r in det)
        check("yoy grand total reconciles",
              abs(sd - gr[0]["actualYtd"]) < 1, f"{sd} vs {gr[0]['actualYtd']}")
    ebs = [r for r in det if r.get("ebsAccount")]
    check("yoy carries EBS account codes", len(ebs) > 10, len(ebs))

    # -- BU dataset ---------------------------------------------------------
    st, d = req("GET", "/gl/dof/butil?year=2026", tok)
    check("butil 200", st == 200, st)
    brows = d.get("rows", [])
    check("butil has appropriation rows", len(brows) >= 10, len(brows))
    if brows:
        r0 = brows[0]
        for k in ("initBudget", "revBudget", "initCfYtd", "revCfYtd",
                  "actualYtd", "variance", "hasCf"):
            if k not in r0:
                check(f"butil key {k}", False, "missing")
                break
        else:
            check("butil row keys complete", True)

    # -- Quarterly dataset --------------------------------------------------
    st, d = req("GET", "/gl/dof/quarterly?year=2026", tok)
    check("quarterly 200", st == 200, st)
    qrows = d.get("rows", [])
    check("quarterly has rows", len(qrows) >= 10, len(qrows))
    if qrows:
        ab = sum(r["approvedBudget"] for r in qrows)
        check("quarterly approved budget > 0", ab > 1e9, ab)
        a_sum = sum(r["act1"] + r["act2"] + r["act3"] + r["act4"] for r in qrows)
        check("quarterly actuals > 0", a_sum > 1e6, a_sum)

    # -- cashflow summary (before upload) ----------------------------------
    st, d = req("GET", "/gl/cashflow/summary", tok)
    check("cashflow summary 200", st == 200, st)

    # -- GL cashflow upload (test year) -------------------------------------
    rows = [
        {"entity": "451", "program": "0", "costCenter": "9110000",
         "budgetGroup": "1", "account": "411121", "entitySpecific": "0",
         "appropriation": "100103", "intercompany": "0", "future1": "0",
         "future2": "0", "period": f"01-{TEST_YEAR}", "cfType": "APPROVED",
         "amount": 1000},
        {"entity": "451", "program": "0", "costCenter": "9110000",
         "budgetGroup": "1", "account": "411121", "entitySpecific": "0",
         "appropriation": "100103", "intercompany": "0", "future1": "0",
         "future2": "0", "period": f"01-{TEST_YEAR}", "cfType": "REVISED",
         "amount": 1200},
    ]
    st, d = req("POST", "/gl/cashflow", tok, {"sourceFile": "smoke.xlsx", "rows": rows})
    check("gl cashflow upload 200", st == 200, st)
    check("gl cashflow upload ok=2", d.get("ok") == 2, d)
    # idempotent re-upload = update, not duplicate
    st, d = req("POST", "/gl/cashflow", tok, {"sourceFile": "smoke.xlsx", "rows": rows})
    check("gl cashflow re-upload ok=2", d.get("ok") == 2, d)
    st, d = req("POST", "/gl/cashflow", tok,
                {"rows": [{"appropriation": "100103", "period": "BAD",
                           "cfType": "APPROVED", "amount": 1}]})
    check("gl cashflow bad period rejected per-row",
          st == 200 and d.get("errors") == 1, (st, d))

    # -- Projects cashflow upload -------------------------------------------
    prows = [{"project": "SMOKE-P1", "task": "1.1", "etype": "Smoke Test",
              "period": f"02-{TEST_YEAR}", "cfType": "APPROVED", "amount": 555}]
    st, d = req("POST", "/gl/cashflow/projects", tok,
                {"sourceFile": "smoke.xlsx", "rows": prows})
    check("project cashflow upload ok=1", st == 200 and d.get("ok") == 1, (st, d))

    st, d = req("GET", "/gl/cashflow/summary", tok)
    gy = [y for y in d.get("glYears", []) if y["year"] == TEST_YEAR]
    py = [y for y in d.get("projectYears", []) if y["year"] == TEST_YEAR]
    check("summary shows GL test year", len(gy) == 2, gy)
    check("summary shows project test year", len(py) == 1, py)

    # BU dataset for the test year should surface the CF row
    st, d = req("GET", f"/gl/dof/butil?year={TEST_YEAR}&period=03-{TEST_YEAR}", tok)
    # DETAIL rows only -- the dataset also carries CHTOTAL/GRAND total rows (v1.54.0)
    cf_rows = [r for r in d.get("rows", []) if r.get("hasCf") == "Y" and r.get("rowType", "DETAIL") == "DETAIL"]
    check("butil test year surfaces CF-only appropriation",
          st == 200 and len(cf_rows) == 1
          and cf_rows[0]["initCfYtd"] == 1000 and cf_rows[0]["revCfYtd"] == 1200,
          (st, cf_rows))

    # -- notes --------------------------------------------------------------
    note = {"year": TEST_YEAR, "appropriation": "100103", "noteType": "REASON",
            "text": "smoke reason"}
    st, d = req("PUT", "/gl/dof/notes", tok, note)
    check("note save", st == 200 and d.get("status") == "SAVED", (st, d))
    st, d = req("GET", f"/gl/dof/notes?year={TEST_YEAR}", tok)
    check("note listed", st == 200 and d.get("total") == 1, (st, d))
    st, d = req("GET", f"/gl/dof/butil?year={TEST_YEAR}", tok)
    rsn = [r for r in d.get("rows", []) if r.get("reason") == "smoke reason"]
    check("butil embeds saved reason", len(rsn) == 1, d.get("rows"))
    note["text"] = ""
    st, d = req("PUT", "/gl/dof/notes", tok, note)
    check("note delete", st == 200 and d.get("status") == "DELETED", (st, d))

    # -- register 404 (unknown run) -----------------------------------------
    st, _ = req("GET", "/gl/dof/register/999999999", tok)
    check("register poll 404 unknown run", st == 404, st)

    print(f"\n{PASS} passed, {FAIL} failed")
    sys.exit(1 if FAIL else 0)


if __name__ == "__main__":
    main()
