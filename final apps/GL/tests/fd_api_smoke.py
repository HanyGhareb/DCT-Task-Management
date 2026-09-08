#!/usr/bin/env python3
"""API smoke for the GL FD Dashboard / Budget Status endpoint (GL/db/42).

Hits ORDS directly (no dev-proxy needed). Auth = the Admin quick-login
credentials (same source as dof_api_smoke.py). Read-only.

Checks: 401 / 400 paths, envelope shape, internal arithmetic (rows sum to
totals, sectors[] sums to rows, Fund = Budget - Actual - Encumbrance at every
row) and the RECONCILIATION with the Financial Performance tab
(GET /gl/fmr/entity: overall + per-entity Budget/Actual/Funds Available must
match to the cent -- both pages sit on the same view + the same rules).

Run: python3 fd_api_smoke.py
"""
import json, re, sys, time, urllib.request, urllib.error

ORDS = "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH = "/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"

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


def req(method, path, tok=None, body=None):
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
            return resp.status, json.loads(payload or b"{}")
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read() or b"{}")
        except Exception:
            return e.code, {}


def close(a, b, tol=0.01):
    return abs((a or 0) - (b or 0)) <= tol


def main():
    u, p = re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",
                      open(AUTH).read())[0]
    st, s = req("POST", "/dct/auth/login", body={"username": u, "password": p})
    if st != 200 or "sessionId" not in s:
        sys.exit(f"login failed: {st} {s}")
    tok = s["sessionId"]
    print(f"logged in as {u}")

    print("\n-- error paths")
    st, _ = req("GET", "/gl/fd/status?period=09-2026")
    check("no token -> 401", st == 401, st)
    st, b = req("GET", "/gl/fd/status", tok)
    check("no period -> 400", st == 400, (st, b))
    st, b = req("GET", "/gl/fd/status?period=2026-09", tok)
    check("bad period format -> 400", st == 400, (st, b))
    st, b = req("GET", "/gl/fd/status?period=13-2026", tok)
    check("month 13 -> 400", st == 400, (st, b))

    print("\n-- default period (same rule as the FMR tab)")
    st, f = req("GET", "/gl/actuals/filters", tok)
    check("actuals/filters 200", st == 200, st)
    period = f.get("defaultPeriod") or "09-2026"
    st, d0 = req("GET", f"/gl/fd/status?period={period}", tok)
    th = d0.get("thresholds") or {}
    check("thresholds{near,over} echoed (v1.105.0 state pills / map heat)",
          st == 200 and isinstance(th.get("near"), (int, float)) and isinstance(th.get("over"), (int, float)) and th["near"] < th["over"], th)
    print("\n-- year series (approach A, v1.107.0): the same cube for every loaded period of the year")
    per = d0.get("periods") or []; ser = d0.get("series") or []; mm = period[:2]
    check("periods[] = MM-YYYY of the year, ascending, contains the requested period",
          per and all(re.match(r"^(0[1-9]|1[0-2])-\d{4}$", x) and x.endswith(period[3:]) for x in per)
          and per == sorted(per) and period in per, per)
    check("series[] present with compact keys s/c/e/ch/m", ser and all(set(x) >= {"s", "c", "e", "ch", "m"} for x in ser), len(ser))
    check("series m keyed by MM with 5-number arrays",
          all(all(re.match(r"^(0[1-9]|1[0-2])$", k) and isinstance(v, list) and len(v) == 5 for k, v in x["m"].items()) for x in ser))
    byk = {(r["sector"], r["costCenter"], r["entity"], r["chapter"]): r for r in d0["rows"]}
    sm = [0, 0, 0, 0]; keys = 0; bad = 0
    for x in ser:
        m = x["m"].get(mm)
        if not m: continue
        keys += 1
        for i in range(4): sm[i] += m[i]
        r = byk.get((x["s"], x["c"], x["e"], x["ch"]))
        if not r or not close(r["budget"], m[0]) or not close(r["actual"], m[1]) or not close(r["encumbrance"], m[2]) or not close(r["fundsAvailable"], m[3]): bad += 1
    check("series at the requested period == rows[] key for key", keys == len(d0["rows"]) and bad == 0, (keys, len(d0["rows"]), bad))
    t0 = d0["totals"]
    check("series at the requested period sums to totals{}",
          close(sm[0], t0["budget"]) and close(sm[1], t0["actual"]) and close(sm[2], t0["encumbrance"]) and close(sm[3], t0["fundsAvailable"]))
    xb = (d0.get("excludedByPeriod") or {}).get(mm) or {}
    check("excludedByPeriod[MM] == excluded{} for the requested period",
          close(xb.get("budget"), d0["excluded"]["budget"]) and close(xb.get("actual"), d0["excluded"]["actual"]) and xb.get("combinations") == d0["excluded"]["combinations"], (xb, d0["excluded"]))
    # an earlier period of the same year derived from the series must equal a direct call for it
    if len(per) > 1:
        p1 = per[0]; st1, d1 = req("GET", f"/gl/fd/status?period={p1}", tok)
        s1 = [0, 0, 0, 0]
        for x in ser:
            m = x["m"].get(p1[:2])
            if m:
                for i in range(4): s1[i] += m[i]
        t1 = d1["totals"]
        check(f"series at {p1} == a direct call's totals (client-side period switch is exact)",
              st1 == 200 and close(s1[0], t1["budget"]) and close(s1[1], t1["actual"]) and close(s1[2], t1["encumbrance"]) and close(s1[3], t1["fundsAvailable"]), (s1, t1))
        check(f"the {p1} call ships the same periods[] (one request per YEAR)", d1.get("periods") == per)
    print(f"  period = {period}")

    print("\n-- envelope")
    t0 = time.time()
    st, d = req("GET", f"/gl/fd/status?period={period}", tok)
    dt = time.time() - t0
    check("fd/status 200", st == 200, (st, d))
    check("responds in < 15s", dt < 15, f"{dt:.1f}s")
    if st != 200:
        sys.exit(1)
    for k in ("period", "year", "scope", "entities", "chapters", "sectors", "rows", "excluded", "totals"):
        check(f"has {k}", k in d, list(d.keys()))
    check("period echoed", d.get("period") == period, d.get("period"))
    check("year = period year", d.get("year") == int(period[3:]), d.get("year"))
    check("scope = GL / BG 1|3|5 / CH1-5 (v1.112.0)",
          d["scope"].get("basis") == "GL" and d["scope"].get("budgetGroup") == "1|3|5"
          and d["scope"].get("chapters") == "CH1|CH2|CH3|CH4|CH5"
          and d["scope"].get("budgetGroupByChapter") == "CH1:1|CH2:1|CH3:1|CH4:3|CH5:5", d["scope"])
    ents = [e["code"] for e in d["entities"]]
    check("entities = DCT/MUSEUMS/ALC/MASTERPIECES", ents == ["DCT", "MUSEUMS", "ALC", "MASTERPIECES"], ents)
    chs = [c["code"] for c in d["chapters"]]
    check("chapters = CH1..CH5", chs == ["CH1", "CH2", "CH3", "CH4", "CH5"], chs)
    check("chapter alt names present", all(c.get("alt") for c in d["chapters"]), d["chapters"])
    rows = d["rows"]
    check("rows present", len(rows) > 10, len(rows))
    check("rows carry the 4 measures + combinations",
          all(all(k in r for k in ("sector", "sectorName", "entity", "chapter", "budget", "actual",
                                   "encumbrance", "fundsAvailable", "combinations")) for r in rows))
    check("row entities within the LOV", all(r["entity"] in ents for r in rows))
    check("row chapters within the LOV", all(r["chapter"] in chs for r in rows))
    check("rows carry costCenter + costCenterName",
          all(r.get("costCenter") and r.get("costCenterName") for r in rows))
    check("grain unique (sector,costCenter,entity,chapter)",
          len({(r["sector"], r["costCenter"], r["entity"], r["chapter"]) for r in rows}) == len(rows))
    check("has costCenters[] LOV", isinstance(d.get("costCenters"), list) and len(d["costCenters"]) > 20,
          len(d.get("costCenters") or []))
    check("costCenters[] carry code/name/sector/sectorName/budget",
          all(all(k in c for k in ("code", "name", "sector", "sectorName", "budget")) for c in d["costCenters"]))
    check("every row cost centre in costCenters[]",
          {r["costCenter"] for r in rows} <= {c["code"] for c in d["costCenters"]})
    cc_sector = {}
    for r in rows:
        cc_sector.setdefault(r["costCenter"], set()).add(r["sector"])
    check("a cost centre belongs to ONE sector", all(len(v) == 1 for v in cc_sector.values()),
          {k: v for k, v in cc_sector.items() if len(v) > 1})
    check("costCenters[] sector attribution == rows", all(cc_sector.get(c["code"], {c["sector"]}) == {c["sector"]} for c in d["costCenters"]))
    check("costCenters[] budget == sum(rows) per cost centre",
          all(close(c["budget"], sum(r["budget"] for r in rows if r["costCenter"] == c["code"]), 0.05) for c in d["costCenters"]))
    check("costCenters[] sorted budget desc",
          all(d["costCenters"][i]["budget"] >= d["costCenters"][i + 1]["budget"] for i in range(len(d["costCenters"]) - 1)))

    print("\n-- arithmetic")
    tot = d["totals"]
    for m in ("budget", "actual", "encumbrance", "fundsAvailable"):
        check(f"sum(rows.{m}) == totals.{m}", close(sum(r[m] for r in rows), tot[m], 0.05),
              (sum(r[m] for r in rows), tot[m]))
    bad = [r for r in rows if not close(r["budget"] - r["actual"] - r["encumbrance"], r["fundsAvailable"], 1.0)]
    check("Fund = Budget - Actual - Encumbrance on every row", not bad, bad[:3])
    by_sector = {}
    for r in rows:
        by_sector.setdefault(r["sector"], [0, 0, 0, 0])
        for i, m in enumerate(("budget", "actual", "encumbrance", "fundsAvailable")):
            by_sector[r["sector"]][i] += r[m]
    sec_ok = all(close(s["budget"], by_sector.get(s["code"], [0])[0], 0.05) for s in d["sectors"])
    check("sectors[] budget == sum(rows) per sector", sec_ok)
    check("sectors[] sorted budget desc",
          all(d["sectors"][i]["budget"] >= d["sectors"][i + 1]["budget"] for i in range(len(d["sectors"]) - 1)))
    check("every row sector in sectors[]", {r["sector"] for r in rows} <= {s["code"] for s in d["sectors"]})
    ex = d["excluded"]
    check("excluded reported (bg-1 no-chapter / CH6 remainder)", all(k in ex for k in ("budget", "actual", "combinations")), ex)

    print("\n-- reconciliation vs Financial Performance (GET /gl/fmr/entity)")
    st, fm = req("GET", f"/gl/fmr/entity?period={period}", tok)
    check("fmr/entity 200", st == 200, st)
    # FMR = Chapters 1-3 on Budget Group 1 ONLY; the cube's CH4/CH5 rows (bg 3/5) sit outside it
    r13 = [r for r in rows if r["chapter"] in ("CH1", "CH2", "CH3")]
    r45 = [r for r in rows if r["chapter"] in ("CH4", "CH5")]
    check("CH4 (Subsidy, bg 3) rows in the cube with budget", any(r["chapter"] == "CH4" and r["budget"] > 0 for r in r45))
    check("CH5 (Aids & Grants, bg 5) rows in the cube", any(r["chapter"] == "CH5" for r in r45))
    check("totals = CH1-5 rows summed", close(sum(r["budget"] for r in rows), tot["budget"]) and close(sum(r["actual"] for r in rows), tot["actual"]))
    if st == 200:
        ov = fm["overall"]
        t13 = {k: sum(r[k] for r in r13) for k in ("budget", "actual", "fundsAvailable")}
        check("overall budget == CH1-3 rows", close(ov["budget"], t13["budget"]), (ov["budget"], t13["budget"]))
        check("overall actual == CH1-3 rows", close(ov["actual"], t13["actual"]), (ov["actual"], t13["actual"]))
        check("overall fundsAvailable == CH1-3 rows",
              close(ov["fundsAvailable"], t13["fundsAvailable"]), (ov["fundsAvailable"], t13["fundsAvailable"]))
        for e in fm["entities"]:
            eb = sum(r["budget"] for r in r13 if r["entity"] == e["code"])
            ea = sum(r["actual"] for r in r13 if r["entity"] == e["code"])
            ef = sum(r["fundsAvailable"] for r in r13 if r["entity"] == e["code"])
            check(f"entity {e['code']} budget/actual/funds == fmr",
                  close(eb, e["budget"]) and close(ea, e["actual"]) and close(ef, e["fundsAvailable"]),
                  ((eb, e["budget"]), (ea, e["actual"]), (ef, e["fundsAvailable"])))

    print("\n-- sector filter semantics (client-side, but prove the cube supports it)")
    top = d["sectors"][0]["code"]
    sub = [r for r in rows if r["sector"] == top]
    check("top sector has rows in >= 1 chapter", len({r["chapter"] for r in sub}) >= 1, top)
    mss = [r for r in rows if r["entity"] == "MUSEUMS"]
    check("MSS rows present (cross-BU)", len(mss) > 0)
    check("MSS has all 3 core chapters", {"CH1", "CH2", "CH3"} <= {r["chapter"] for r in mss}, {r["chapter"] for r in mss})

    print("\n-- figure drill (GET /gl/fd/lines, GL/db/43)")
    st, _ = req("GET", f"/gl/fd/lines?period={period}&metric=budget")
    check("lines: no token -> 401", st == 401, st)
    st, b = req("GET", f"/gl/fd/lines?period={period}", tok)
    check("lines: no metric -> 400", st == 400, (st, b))
    st, b = req("GET", f"/gl/fd/lines?period={period}&metric=plan", tok)
    check("lines: bad metric -> 400", st == 400, (st, b))
    st, b = req("GET", f"/gl/fd/lines?period={period}&metric=budget&chapter=CH9", tok)
    check("lines: bad chapter -> 400", st == 400, (st, b))
    st, b = req("GET", f"/gl/fd/lines?period={period}&metric=budget&entity=XYZ", tok)
    check("lines: bad entity -> 400", st == 400, (st, b))

    def cube(pred, m):
        return sum(r[m] for r in rows if pred(r))
    m_col = {"budget": "budget", "actual": "actual", "encumbrance": "encumbrance", "fundsavailable": "fundsAvailable"}
    for ch in chs:
        for metric, col in m_col.items():
            st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter={ch}&metric={metric}", tok)
            ok = st == 200
            exp = cube(lambda r: r["chapter"] == ch, col)
            check(f"lines {ch}/{metric}: 200 + total == cube figure", ok and close(dl.get("total"), exp, 0.05),
                  (st, dl.get("total") if ok else dl, exp))
            if ok and metric == "budget":
                check(f"lines {ch}: rows == count, all non-zero, all carry a combination",
                      len(dl["rows"]) == dl["count"] and all(r[col] != 0 and r["combination"] for r in dl["rows"]),
                      (len(dl["rows"]), dl["count"]))
                check(f"lines {ch}: no row whose {metric} displays as 0 (|value| >= 0.5 AED)",
                      all(abs(r[col]) >= 0.5 for r in dl["rows"]),
                      [r[col] for r in dl["rows"] if abs(r[col]) < 0.5][:5])
                keys = [c["key"] for c in dl["columns"]]
                check(f"lines {ch}: columns = combination..fundsAvailable",
                      keys == ["combination", "chapter", "costCenter", "account", "sector", "appropriation",
                               "budget", "actual", "encumbrance", "fundsAvailable"], keys)
                check(f"lines {ch}: fundsAvailable column flagged pn (sign tint)",
                      [c for c in dl["columns"] if c["key"] == "fundsAvailable"][0].get("pn") is True)
                accts = [r["account"][:6] for r in dl["rows"]]
                check(f"lines {ch}: sorted by account (GL segment)", accts == sorted(accts))
                combos = dl.get("combos") or {}
                distinct = {r["combination"] for r in dl["rows"]}
                cov = len([c for c in distinct if c in combos]) / max(1, len(distinct))
                check(f"lines {ch}: combos side-map covers the rows (>= 80%)", cov >= 0.8, f"{cov:.0%} of {len(distinct)}")
                one = combos[next(iter(combos))] if combos else {}
                check(f"lines {ch}: combo carries the 10 segment code+desc pairs",
                      all(k in one for k in ("entityCode", "costCenterCode", "accountCode", "appropriationCode",
                                             "budgetGroupCode", "entitySpecificCode", "future1Code", "future2Code",
                                             "intercompanyCode", "programCode", "accountDesc")), list(one.keys()))
                check(f"lines {ch}: Fund = Budget - Actual - Enc on every drill row",
                      all(close(r["budget"] - r["actual"] - r["encumbrance"], r["fundsAvailable"], 1.0) for r in dl["rows"]))
    st, dl = req("GET", f"/gl/fd/lines?period={period}&metric=budget", tok)
    check("lines: no chapter == grand total budget", st == 200 and close(dl["total"], tot["budget"], 0.05),
          (dl.get("total"), tot["budget"]))
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH2&metric=actual&entity=MUSEUMS", tok)
    exp = cube(lambda r: r["chapter"] == "CH2" and r["entity"] == "MUSEUMS", "actual")
    check("lines: entity=MUSEUMS CH2 actual == cube", st == 200 and close(dl["total"], exp, 0.05), (dl.get("total"), exp))
    two = [d["sectors"][0]["code"], d["sectors"][1]["code"]]
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH2&metric=encumbrance&sector={two[0]}|{two[1]}", tok)
    exp = cube(lambda r: r["chapter"] == "CH2" and r["sector"] in two, "encumbrance")
    check("lines: sector any-of (2 sectors) CH2 encumbrance == cube", st == 200 and close(dl["total"], exp, 0.05),
          (dl.get("total"), exp))
    check("lines: sector-filtered rows carry only those sectors",
          st == 200 and {r["sector"] for r in dl["rows"]} <= {s["name"] for s in d["sectors"] if s["code"] in two},
          {r["sector"] for r in dl.get("rows", [])})
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH1&metric=fundsavailable&sector={two[0]}", tok)
    check("lines: Fund Available drill (user report) hides sub-AED remainders yet still reconciles",
          st == 200 and all(abs(r["fundsAvailable"]) >= 0.5 for r in dl["rows"])
          and close(dl["total"], cube(lambda r: r["chapter"] == "CH1" and r["sector"] == two[0], "fundsAvailable"), 0.05),
          (st, dl.get("total"), [r["fundsAvailable"] for r in dl.get("rows", []) if abs(r["fundsAvailable"]) < 0.5][:5]))
    # department (cost centre) filter, any-of, on top of a sector
    top_ccs = [c["code"] for c in d["costCenters"] if c["sector"] == two[0]][:2]
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH2&metric=budget&sector={two[0]}&costcenter={'|'.join(top_ccs)}", tok)
    exp = cube(lambda r: r["chapter"] == "CH2" and r["sector"] == two[0] and r["costCenter"] in top_ccs, "budget")
    check("lines: costcenter any-of (2 depts) + sector CH2 budget == cube", st == 200 and close(dl["total"], exp, 0.05),
          (dl.get("total"), exp, top_ccs))
    check("lines: costcenter echo + rows only those cost centres",
          st == 200 and dl.get("costcenter") == '|'.join(top_ccs)
          and all(r["costCenter"][:7] in top_ccs for r in dl["rows"]), [r["costCenter"] for r in dl.get("rows", [])][:3])
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH4&metric=budget", tok)
    check("lines: CH4 budget drill (bg 3) == cube CH4 budget", st == 200 and close(dl["total"], cube(lambda r: r["chapter"] == "CH4", "budget"), 0.05),
          (st, dl.get("total") if st == 200 else dl, cube(lambda r: r["chapter"] == "CH4", "budget")))
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH5&metric=encumbrance", tok)
    check("lines: CH5 encumbrance drill (bg 5) == cube CH5 encumbrance", st == 200 and close(dl["total"], cube(lambda r: r["chapter"] == "CH5", "encumbrance"), 0.05))
    st, dl = req("GET", f"/gl/fd/lines?period={period}&metric=budget", tok)
    check("lines: no chapter = Chapters 1-5 together == totals.budget", st == 200 and close(dl["total"], tot["budget"], 0.05), (st, dl.get("total") if st == 200 else dl))
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH6&metric=budget", tok)
    check("lines: chapter=CH6 -> 400", st == 400, st)
    st, dl = req("GET", f"/gl/fd/lines?period={period}&chapter=CH3&metric=fundsavailable&entity=DCT&sector={two[0]}", tok)
    exp = cube(lambda r: r["chapter"] == "CH3" and r["entity"] == "DCT" and r["sector"] == two[0], "fundsAvailable")
    check("lines: entity + sector + CH3 fundsavailable == cube", st == 200 and close(dl["total"], exp, 0.05),
          (dl.get("total"), exp))

    print(f"\n{PASS} passed, {FAIL} failed")
    sys.exit(1 if FAIL else 0)


if __name__ == "__main__":
    main()
