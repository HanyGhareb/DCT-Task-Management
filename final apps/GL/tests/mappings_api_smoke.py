#!/usr/bin/env python3
"""API smoke for the classification ASSIGNMENT routes (GL/db/05 + 46) -- the
Chart of Accounts row drawer / Manage CoA Mapping modal write path.

Self-cleaning: creates a throwaway SECTOR value + one assignment on a bogus
segment value, exercises PUT /gl/mappings/:id (end date set / cleared / before
start = 400 / partial body / unknown id = 404 / no token = 401), then deletes
both. Regression for the 2026-09-04 defect: PUT returned an uncatchable ORDS
555 on every call (scalar subquery inside a PL/SQL expression, PLS-00405) --
fixed by GL/db/46.

Run: python3 mappings_api_smoke.py
"""
import json, re, sys, urllib.request, urllib.error

ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
PASS = FAIL = 0


def check(name, ok, detail=""):
    global PASS, FAIL
    if ok: PASS += 1; print(f"  PASS  {name}")
    else:  FAIL += 1; print(f"  FAIL  {name}  {detail}")


def req(method, path, tok=None, body=None):
    data = json.dumps(body).encode() if body is not None else None
    headers = {"Content-Type": "application/json"} if body is not None else {}
    if tok: headers["Authorization"] = "Bearer " + tok
    r = urllib.request.Request(ORDS + path, data=data, method=method, headers=headers)
    try:
        with urllib.request.urlopen(r, timeout=120) as resp:
            return resp.status, json.loads(resp.read() or b"{}")
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read() or b"{}")
        except Exception: return e.code, {}


def main():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    st, s = req("POST", "/dct/auth/login", body={"username": u, "password": p})
    if st != 200 or "sessionId" not in s: sys.exit(f"login failed: {st} {s}")
    tok = s["sessionId"]; print(f"logged in as {u}")
    cv = mid = None
    try:
        st, b = req("POST", "/gl/class-values", tok, {"type": "SECTOR", "valueCode": "ZZ_SMOKE_MAP", "nameEn": "ZZ smoke mapping",
                                                     "nameAr": "", "altName1": "", "altName2": "", "altName3": "", "tag": "",
                                                     "parentValueId": None, "displayOrder": 9999, "isActive": "Y"})
        check("create throwaway sector value", st == 200 and b.get("classValueId"), (st, b)); cv = b.get("classValueId")
        st, b = req("POST", "/gl/mappings", tok, {"type": "SECTOR", "segmentValue": "ZZSMOKE9", "classValueId": cv,
                                                 "startDate": "2026-01-01", "endDate": None, "notes": "smoke"})
        check("create assignment on a bogus segment", st == 200 and b.get("mapId"), (st, b)); mid = b.get("mapId")

        def row():
            st, d = req("GET", f"/gl/mappings?type=SECTOR&valueid={cv}", tok)
            return ([x for x in d.get("items", []) if x.get("mapId") == mid] or [{}])[0]

        st, b = req("PUT", f"/gl/mappings/{mid}", tok, {"classValueId": cv, "startDate": "2026-01-01", "endDate": "2026-12-31", "notes": "smoke"})
        check("PUT end date -> 200 (was 555)", st == 200 and b.get("ok") == 1, (st, b))
        check("end date persisted", row().get("endDate") == "2026-12-31", row())
        st, b = req("PUT", f"/gl/mappings/{mid}", tok, {"classValueId": cv, "startDate": "2026-01-01", "endDate": None, "notes": "smoke 2"})
        check("PUT clears the end date + notes", st == 200 and not row().get("endDate") and row().get("notes") == "smoke 2", (st, row()))
        st, b = req("PUT", f"/gl/mappings/{mid}", tok, {"classValueId": cv, "startDate": "2026-01-01", "endDate": "2025-12-31", "notes": "smoke"})
        check("end before start -> 400 with the rule", st == 400 and "before start" in (b.get("error") or ""), (st, b))
        st, b = req("PUT", f"/gl/mappings/{mid}", tok, {"startDate": "2026-02-01"})
        check("partial PUT keeps the class value (NVL against the current row)", st == 200 and row().get("startDate") == "2026-02-01", (st, row()))
        st, b = req("PUT", "/gl/mappings/999999999", tok, {"endDate": "2026-12-31"})
        check("unknown id -> 404", st == 404, (st, b))
        st, b = req("PUT", f"/gl/mappings/{mid}", None, {"endDate": "2026-12-31"})
        check("no token -> 401", st == 401, st)
    finally:
        if mid:
            st, b = req("DELETE", f"/gl/mappings/{mid}", tok); check("cleanup: delete assignment", st == 200, (st, b))
        if cv:
            st, b = req("DELETE", f"/gl/class-values/{cv}", tok); check("cleanup: delete value", st == 200, (st, b))
    print(f"\n{PASS}/{PASS + FAIL} passed")
    sys.exit(0 if FAIL == 0 else 1)


if __name__ == "__main__":
    main()
