#!/usr/bin/env python3
"""API smoke for the data-driven ENTITY classification (GL/db/47 + 48, 2026-09-06).

Read-only checks on the seeded state, then a self-cleaning round trip: a
throwaway Entity value + a rule on a NON-default segment (Cost Centre), the
guards (one Entity rule per combination, Entity-only segment picking, default
only on Entity), the live-view resolution (asof = today => DCT_GL_COA_V), and
the FD / FMR routes agreeing entity-by-entity to the cent. Deletes what it made.

Run: python3 entity_class_api_smoke.py
"""
import json, re, sys, time, urllib.request, urllib.error, datetime

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
        with urllib.request.urlopen(r, timeout=180) as resp:
            return resp.status, json.loads(resp.read() or b"{}")
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read() or b"{}")
        except Exception: return e.code, {}


def close(a, b, tol=0.01): return abs((a or 0) - (b or 0)) <= tol


def main():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'", open(AUTH).read())[0]
    st, s = req("POST", "/dct/auth/login", body={"username": u, "password": p})
    if st != 200 or "sessionId" not in s: sys.exit(f"login failed: {st} {s}")
    tok = s["sessionId"]; print(f"logged in as {u}")
    today = datetime.date.today().isoformat()

    print("\n-- seeded model")
    st, d = req("GET", "/gl/segments", tok)
    segs = d.get("items", [])
    check("GET /gl/segments = the 10 canonical segments in position order", st == 200 and len(segs) == 10
          and [x["position"] for x in segs] == list(range(1, 11)) and segs[5]["key"] == "ENTITY_SPECIFIC" and segs[6]["key"] == "APPROPRIATION", [x.get("key") for x in segs])
    st, d = req("GET", "/gl/boot", tok)
    dims = {x["code"]: x for x in d.get("dimensions", [])}
    check("boot lists the ENTITY dimension (segment ENTITY_SPECIFIC)", "ENTITY" in dims and dims["ENTITY"]["segmentKey"] == "ENTITY_SPECIFIC", list(dims))
    st, d = req("GET", "/gl/class-values?type=ENTITY", tok)
    vals = {x["valueCode"]: x for x in d.get("items", [])}
    check("ENTITY values DCT/MUSEUMS/ALC/MASTERPIECES, DCT flagged default", set(["DCT", "MUSEUMS", "ALC", "MASTERPIECES"]) <= set(vals)
          and vals["DCT"]["isDefault"] == "Y" and all(vals[k]["isDefault"] == "N" for k in ("MUSEUMS", "ALC", "MASTERPIECES")), {k: v.get("isDefault") for k, v in vals.items()})
    st, d = req("GET", "/gl/mappings?type=ENTITY", tok)
    rules = d.get("items", [])
    keyed = {(r["segmentKey"], r["segmentValue"]): r["valueCode"] for r in rules}
    check("3 seeded rules on TWO different segments", keyed.get(("ENTITY_SPECIFIC", "4510700")) == "MUSEUMS" and keyed.get(("ENTITY_SPECIFIC", "4510600")) == "ALC"
          and keyed.get(("APPROPRIATION", "301439")) == "MASTERPIECES", keyed)
    check("mapping rows carry segmentKeyName + segmentDesc", all(r.get("segmentKeyName") for r in rules) and any(r.get("segmentDesc") for r in rules), rules[:1])
    st, d = req("GET", "/gl/segments/ACCOUNT/values?type=ENTITY&search=452201&limit=5", tok)
    check("segment values work for a NON-classification segment (ACCOUNT)", st == 200 and any(x["segmentValue"] == "452201" for x in d.get("items", [])), d.get("items", [])[:2])
    st, d = req("GET", "/gl/segments/APPROPRIATION/values?type=ENTITY&search=301439", tok)
    it = [x for x in d.get("items", []) if x["segmentValue"] == "301439"]
    check("appropriation 301439 shows its current Entity value id", it and it[0].get("currentValueId") == vals["MASTERPIECES"]["classValueId"], it)
    st, d = req("GET", "/gl/segments/NOPE/values", tok)
    check("unknown segment key -> 404", st == 404, st)
    st, d = req("GET", "/gl/combinations?entity=MASTERPIECES&limit=10", tok)
    check("explorer entity filter + columns (Masterpieces = the 301439 combinations)", st == 200 and d.get("total", 0) >= 1
          and all(x["entityClassCode"] == "MASTERPIECES" and x["appropriationCode"] == "301439" and x["entityClassSource"] == "RULE" for x in d["items"]), (d.get("total"), d.get("items", [])[:1]))
    st, d = req("GET", "/gl/combinations?entity=DCT&limit=1", tok)
    check("DCT combinations come from the DEFAULT", d.get("total", 0) > 5000 and d["items"][0]["entityClassSource"] == "DEFAULT", d.get("total"))
    st, d = req("GET", "/gl/combinations?entity=UNCLASSIFIED&limit=1", tok)
    check("no Unclassified combination while DCT is the default", st == 200 and d.get("total") == 0, d.get("total"))

    print("\n-- pages read the data-driven entity (FD vs FMR to the cent)")
    st, f = req("GET", "/gl/actuals/filters", tok); period = f.get("defaultPeriod") or "09-2026"
    st, fd = req("GET", f"/gl/fd/status?period={period}", tok)
    ents = fd.get("entities", [])
    check("FD entities[] come from the classification (4 seeded, DCT default first)", [e["code"] for e in ents] == ["DCT", "MUSEUMS", "ALC", "MASTERPIECES"] and ents[0].get("isDefault") == "Y" and bool(ents[1].get("name")), ents)  # name is data (seeded MSS, renamed Museums 2026-09-06) -- never a literal
    st, fm = req("GET", f"/gl/fmr/entity?period={period}", tok)
    fme = {e["code"]: e for e in fm.get("entities", [])}
    ok = True; det = []
    for code in ["DCT", "MUSEUMS", "ALC", "MASTERPIECES"]:
        rows = [r for r in fd.get("rows", []) if r["entity"] == code and r["chapter"] in ("CH1", "CH2", "CH3")]
        b = sum(r["budget"] for r in rows); a = sum(r["actual"] for r in rows)
        if code not in fme or not close(b, fme[code]["budget"]) or not close(a, fme[code]["actual"]): ok = False
        det.append((code, round(b, 2), round(fme.get(code, {}).get("budget", -1), 2)))
    check("FD chapter 1-3 rows == FMR entity totals per entity (budget + actual)", ok, det)
    check("no Unclassified entity on the pages today", "UNCLASSIFIED" not in fme and all(r["entity"] != "UNCLASSIFIED" for r in fd.get("rows", [])))
    base_dct = fme["DCT"]["budget"]

    print("\n-- round trip: a rule on a non-default segment + the guards (self-cleaning)")
    cv = mid = None
    try:
        st, d = req("POST", "/gl/class-values", tok, {"type": "ENTITY", "valueCode": "ZZ_SMOKE_ENT", "nameEn": "ZZ smoke entity", "nameAr": "", "altName1": "", "altName2": "", "altName3": "", "tag": "", "parentValueId": None, "displayOrder": 9999, "isActive": "Y", "isDefault": "N"})
        check("create throwaway Entity value (refresh queued)", st in (200, 201) and d.get("classValueId") and d.get("refreshQueued") == "Y", (st, d)); cv = d.get("classValueId")
        st, d = req("POST", "/gl/mappings", tok, {"type": "ENTITY", "segmentKey": "COST_CENTER", "segmentValue": "4512400", "classValueId": cv, "startDate": today, "endDate": None, "notes": "smoke"})
        check("Entity rule on the COST CENTRE segment accepted", st in (200, 201) and d.get("mapId"), (st, d)); mid = d.get("mapId")
        st, d = req("GET", f"/gl/combinations?asof={today}&entity=ZZ_SMOKE_ENT&limit=3", tok)
        check("live view resolves cost centre 4512400 to the new entity (asof = today)", st == 200 and d.get("total", 0) > 0 and all(x["costCenterCode"] == "4512400" and x["entityClassSource"] == "RULE" for x in d["items"]), (st, d.get("total")))
        st, d = req("GET", f"/gl/combinations?asof={today}&entity=DCT&search=4512400&limit=1", tok)
        check("those combinations left the DCT default", d.get("total") == 0, d.get("total"))
        st, d = req("POST", "/gl/mappings", tok, {"type": "ENTITY", "segmentKey": "ENTITY_SPECIFIC", "segmentValue": "4510000", "classValueId": cv, "startDate": today, "endDate": None, "notes": "smoke overlap"})
        check("a rule that would give a combination TWO Entity rules is refused (400, names the other rule)", st == 400 and "ONE Entity rule" in (d.get("error") or "") and "301439" in (d.get("error") or ""), (st, d))
        st, d = req("POST", "/gl/mappings", tok, {"type": "ENTITY", "segmentKey": "ACCOUNT", "segmentValue": "452201", "classValueId": cv, "startDate": today, "endDate": None, "notes": "smoke acct"})
        check("cross-SEGMENT overlap is caught too (account 452201 sits on one MSS combination -> 400)", st == 400 and "4510700" in (d.get("error") or ""), (st, d))
        st, d = req("POST", "/gl/mappings", tok, {"type": "ENTITY", "segmentKey": "ACCOUNT", "segmentValue": "324566", "classValueId": cv, "startDate": today, "endDate": None, "notes": "smoke acct"})
        acct_mid = d.get("mapId") if st in (200, 201) else None
        check("a second rule on yet another segment (ACCOUNT 324566, DCT-default combinations only) is accepted", st in (200, 201) and acct_mid, (st, d))
        if acct_mid:
            st, d = req("DELETE", f"/gl/mappings/{acct_mid}", tok); check("cleanup: delete the ACCOUNT rule", st == 200, (st, d))
        st, d = req("GET", "/gl/class-values?type=SECTOR", tok); sec = d["items"][0]
        st, d = req("POST", "/gl/mappings", tok, {"type": "SECTOR", "segmentKey": "ACCOUNT", "segmentValue": "452201", "classValueId": sec["classValueId"], "startDate": today, "endDate": None, "notes": "smoke"})
        check("Sector rules may NOT pick another segment (400)", st == 400 and "Only Entity" in (d.get("error") or ""), (st, d))
        st, d = req("PUT", f"/gl/class-values/{sec['classValueId']}", tok, {"isDefault": "Y"})
        check("a default value is Entity-only (400 on Sector)", st == 400, (st, d))
        st, d = req("PUT", f"/gl/mappings/{mid}", tok, {"endDate": today})
        check("PUT keeps the rule's segment + end-dates it", st == 200, (st, d))
        st, d = req("GET", f"/gl/mappings?type=ENTITY&valueid={cv}", tok)
        row = (d.get("items") or [{}])[0]
        check("rule row shows COST_CENTER + description + end date", row.get("segmentKey") == "COST_CENTER" and row.get("segmentDesc") and row.get("endDate") == today, row)
    finally:
        if mid:
            st, d = req("DELETE", f"/gl/mappings/{mid}", tok); check("cleanup: delete the rule", st == 200 and d.get("refreshQueued") == "Y", (st, d))
        if cv:
            st, d = req("DELETE", f"/gl/class-values/{cv}", tok); check("cleanup: delete the value", st == 200, (st, d))
    print("  waiting 45 s for the queued snapshot refresh (one-off job, +3 s start, -20042 retry) ...")
    time.sleep(45)
    st, d = req("GET", "/gl/combinations?entity=ZZ_SMOKE_ENT&limit=1", tok)
    check("snapshot back to normal after the queued refresh", st == 200 and d.get("total") == 0, d.get("total"))
    st, fm2 = req("GET", f"/gl/fmr/entity?period={period}", tok)
    check("FMR DCT budget unchanged after the round trip", close({e["code"]: e for e in fm2.get("entities", [])}.get("DCT", {}).get("budget"), base_dct), base_dct)
    print(f"\n{PASS}/{PASS + FAIL} passed")
    sys.exit(0 if FAIL == 0 else 1)


if __name__ == "__main__":
    main()
