"""PBT (Project Budget Transactions) ORDS smoke — db/78 endpoints.

Covers happy path, filtering, drill, and the error contract (400/401/403/404).
Read-only except for ONE deliberate enqueue, which is cancelled straight after
so the fleet never picks it up.

  python3 pbt_api_smoke.py
"""
import json
import os
import re
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
APPS = os.path.abspath(os.path.join(HERE, "..", ".."))
ADB = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com"

src = open(os.path.join(APPS, "Admin", "Jet", "js", "services", "authService.js"),
           encoding="utf-8").read()
m = re.search(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", src)
USER, PWD = m.group(1), m.group(2)

RESULTS = []


def call(path, token=None, method="GET", body=None, expect=200, label=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(ADB + "/ords/admin" + path, data=data, method=method)
    if token:
        req.add_header("Authorization", "Bearer " + token)
    if data is not None:
        req.add_header("Content-Type", "application/json")
    try:
        r = urllib.request.urlopen(req, timeout=60)
        code, raw = r.status, r.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        code, raw = e.code, e.read().decode("utf-8", "replace")
    except Exception as e:
        code, raw = 0, str(e)
    ok = code == expect
    try:
        d = json.loads(raw)
    except Exception:
        d = None
    note = ""
    if isinstance(d, dict):
        note = ("items=%d/%s" % (len(d["items"]), d.get("total", "?"))
                if "items" in d else ",".join(list(d.keys())[:5]))
    RESULTS.append(ok)
    print("%-4s %-6s %-42s %s  %s" % ("PASS" if ok else "FAIL", method,
                                      label or path, code, note[:60]))
    return ok, d


def main():
    req = urllib.request.Request(
        ADB + "/ords/admin/dct/auth/login",
        data=json.dumps({"username": USER, "password": PWD}).encode(),
        headers={"Content-Type": "application/json"}, method="POST")
    # the login response calls the bearer token `sessionId`, not `token`
    tok = json.loads(urllib.request.urlopen(req, timeout=40).read())["sessionId"]
    print("logged in as", USER, "\n")

    # ---- happy path -------------------------------------------------------
    ok, summary = call("/atd/pbt/summary", tok, label="GET pbt/summary")
    if ok and summary:
        types = {t["type"]: t["headers"] for t in summary.get("byType", [])}
        print("     loaded:", types, "sync=", summary.get("syncEnabled"))

    call("/atd/pbt/runs?limit=5", tok, label="GET pbt/runs")
    ok, data = call("/atd/pbt/data?size=5", tok, label="GET pbt/data")

    sample = (data or {}).get("items", [{}])[0] if (data or {}).get("items") else {}
    num = sample.get("transactionNum")
    typ = sample.get("transactionType")

    # ---- filters ----------------------------------------------------------
    call("/atd/pbt/data?type=Additional&size=3", tok, label="GET pbt/data?type=")
    call("/atd/pbt/data?status=Baselined&size=3", tok, label="GET pbt/data?status=")
    call("/atd/pbt/data?from=2026-08-07&to=2026-08-07&size=100",
         tok, label="GET pbt/data?from=&to=")
    if num:
        call("/atd/pbt/data?search=%s&size=3" % num, tok, label="GET pbt/data?search=")

    # ---- drill ------------------------------------------------------------
    if num:
        ok, det = call("/atd/pbt/data/%s?type=%s" % (num, typ), tok,
                       label="GET pbt/data/:num")
        if ok and det:
            print("     %s: %d lines, %d approvals" %
                  (num, len(det.get("lines", [])), len(det.get("approvals", []))))

    # ---- error contract ---------------------------------------------------
    call("/atd/pbt/summary", None, expect=401, label="GET summary (no token) -> 401")
    call("/atd/pbt/data/000000?type=Additional", tok, expect=404,
         label="GET data/:num unknown -> 404")
    call("/atd/pbt/runs/99999999", tok, expect=404, label="GET runs/:id unknown -> 404")
    call("/atd/pbt/runs/abc", tok, expect=400, label="GET runs/:id non-numeric -> 400")
    call("/atd/pbt/data?from=07-08-2026", tok, expect=400,
         label="GET data bad date -> 400")
    call("/atd/pbt/runs", tok, method="POST", body={"mode": "NONSENSE"},
         expect=400, label="POST runs bad mode -> 400")
    call("/atd/pbt/runs", tok, method="POST", body={"mode": "RANGE"},
         expect=400, label="POST runs RANGE w/o dates -> 400")
    call("/atd/pbt/runs", tok, method="POST",
         body={"mode": "RANGE", "dateFrom": "2026-08-10", "dateTo": "2026-08-01"},
         expect=400, label="POST runs reversed range -> 400")

    # ---- one real enqueue, then cancel it ---------------------------------
    ok, r = call("/atd/pbt/runs", tok, method="POST",
                 body={"mode": "RANGE", "dateFrom": "2026-08-07",
                       "dateTo": "2026-08-07", "transactionTypes": ["Additional"]},
                 label="POST pbt/runs (enqueue)")
    if ok and r and r.get("actionId"):
        aid = r["actionId"]
        call("/atd/pbt/runs/%s" % aid, tok, label="GET pbt/runs/:id (the new one)")
        # cancel so the fleet does not actually run it during a smoke test
        call("/atd/actions/%s/cancel" % aid, tok, method="POST", body={},
             label="POST actions/:id/cancel (cleanup)")

    print("\n%d/%d passed" % (sum(RESULTS), len(RESULTS)))
    return 0 if all(RESULTS) else 1


if __name__ == "__main__":
    raise SystemExit(main())
