"""Worker Fleet round smoke — db/85 (pause/resume, sessionAccount/paused fields,
age auto re-login settings) + db/42 rework (runs ?vm= filter).

Pauses ONE worker briefly and resumes it straight after; waits for the paused
heartbeat so the runner-side gate is proven live, not just the flag.

  python3 fleet_api_smoke.py
"""
import json
import os
import re
import time
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
    except Exception as e:  # noqa: BLE001
        code, raw = 0, str(e)
    ok = code == expect
    try:
        d = json.loads(raw)
    except Exception:  # noqa: BLE001
        d = None
    RESULTS.append(ok)
    print(("PASS" if ok else "FAIL"),
          label or f"{method} {path}", f"-> {code} (want {expect})")
    return d


def check(cond, label):
    RESULTS.append(bool(cond))
    print(("PASS" if cond else "FAIL"), label)


def main():
    d = call("/dct/auth/login", method="POST",
             body={"username": USER, "password": PWD}, label="login")
    # the login response calls the bearer token `sessionId`, not `token`
    tok = d.get("sessionId") or d.get("token")

    # ---- workers list: new fields present -------------------------------
    w = call("/atd/workers", tok, label="GET /atd/workers")
    items = (w or {}).get("items") or []
    check(items, "workers list non-empty")
    check(all("paused" in i for i in items), "every worker ships paused")
    check(all("sessionAccount" in i for i in items), "every worker ships sessionAccount")
    check(any(i.get("sessionAccount") for i in items), "sessionAccount populated")
    vm = items[0]["workerId"]

    # ---- pause -> live PAUSED heartbeat -> resume -----------------------
    call(f"/atd/workers/{vm}/pause", tok, method="POST", body={},
         label=f"POST pause {vm}")
    w2 = call("/atd/workers", tok, label="workers after pause")
    row = [i for i in (w2 or {}).get("items", []) if i["workerId"] == vm][0]
    check(row.get("paused") == "Y", "paused flag = Y after pause")
    paused_seen = ""
    for _ in range(10):                     # idle beat is ~15s; wait up to ~50s
        time.sleep(5)
        w3 = call("/atd/workers", tok, label="poll for PAUSED heartbeat")
        r3 = [i for i in (w3 or {}).get("items", []) if i["workerId"] == vm][0]
        if r3.get("status") == "PAUSED":
            paused_seen = "PAUSED"
            break
    check(paused_seen == "PAUSED", f"runner heartbeat flipped to PAUSED on {vm}")
    call(f"/atd/workers/{vm}/resume", tok, method="POST", body={},
         label=f"POST resume {vm}")
    w4 = call("/atd/workers", tok, label="workers after resume")
    r4 = [i for i in (w4 or {}).get("items", []) if i["workerId"] == vm][0]
    check(r4.get("paused") == "N", "paused flag = N after resume")

    # ---- pause/resume error contract ------------------------------------
    call("/atd/workers/no-such-vm/pause", tok, method="POST", body={},
         expect=404, label="pause unknown vm -> 404")
    call(f"/atd/workers/{vm}/pause", method="POST", body={},
         expect=401, label="pause w/o token -> 401")

    # ---- Run Logs ?vm= filter (db/42 rework) ----------------------------
    a = call("/atd/runs?limit=5", tok, label="GET /atd/runs (unfiltered)")
    check((a or {}).get("total", 0) > 0, "runs exist")
    f = call(f"/atd/runs?vm={vm}&limit=50", tok, label=f"GET /atd/runs?vm={vm}")
    fitems = (f or {}).get("items") or []
    check(all(i.get("host") == vm for i in fitems), "every filtered run row is that VM")
    check((f or {}).get("total", 0) <= (a or {}).get("total", 0),
          "filtered total <= unfiltered total")
    g = call("/atd/runs?vm=no-such-vm&limit=5", tok, label="runs for unknown vm")
    check((g or {}).get("total") == 0, "unknown vm -> 0 rows")

    # ---- age auto re-login settings seeded ------------------------------
    c = call("/atd/config", tok, label="GET /atd/config")
    keys = {i.get("key") or i.get("configKey") for i in ((c or {}).get("items") or [])}
    check("ATD_AGE_RELOGIN" in keys, "ATD_AGE_RELOGIN seeded")
    check("ATD_AGE_RELOGIN_HOURS" in keys, "ATD_AGE_RELOGIN_HOURS seeded")

    print("=" * 50)
    print(f"{sum(RESULTS)}/{len(RESULTS)} checks passed")
    return 0 if all(RESULTS) else 1


if __name__ == "__main__":
    raise SystemExit(main())
