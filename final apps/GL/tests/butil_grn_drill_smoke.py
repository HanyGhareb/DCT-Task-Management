import json, re, urllib.request
BASE="https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin"
AUTH="/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",open(AUTH).read())[0]
r=urllib.request.Request(BASE+"/dct/auth/login",data=json.dumps({"username":u,"password":p}).encode(),method="POST",headers={"Content-Type":"application/json"})
tok=json.loads(urllib.request.urlopen(r,timeout=60).read())["sessionId"]
def api(path):
    q=urllib.request.Request(BASE+"/gl"+path,headers={"Authorization":"Bearer "+tok})
    return json.loads(urllib.request.urlopen(q,timeout=300).read())
ok=fail=0
def ck(n,c,x=""):
    global ok,fail
    print(("PASS " if c else "FAIL ")+n+" "+str(x)); ok,fail=(ok+1,fail) if c else (ok,fail+1)
# aggregate drill (the drawer in the screenshot): YTD 07-2026, OPEX type
d=api("/butil/lines?year=2026&metric=grn&period=07-2026&projecttype=DCT%20OPEX%20Project%20Type")
keys=[c["key"] for c in d["columns"]]
ck("columns", keys==["project","projectName","task","etype","receipt","line","date","po","poLine","supplier","currency","rate","invoicedAed","uninvoicedAed","relatedInvoices","amount"], keys)
ck("amount last (footer total aligns)", keys[-1]=="amount")
rows=d["rows"]
ck("rows returned", len(rows)>0, len(rows))
ck("projectName populated", any(r.get("projectName") for r in rows))
ck("etype populated", any(r.get("etype") for r in rows))
ck("relatedInvoices populated", any(r.get("relatedInvoices") for r in rows))
multi=[r["relatedInvoices"] for r in rows if "," in (r.get("relatedInvoices") or "")]
ck("comma-separated lists present", len(multi)>0, multi[:1])
# reconciliation: total unchanged vs the page KPI (compare to /butil totals)
b=api("/butil?year=2026&period=07-2026&projecttype=DCT%20OPEX%20Project%20Type&limit=1")
ck("drill total == page Actual GRN", abs(d["total"]-b["totals"]["actualGrn"])<0.01, (round(d["total"],2), round(b["totals"]["actualGrn"],2)))
# invoiced/uninvoiced sanity on one row with invoices
s=[r for r in rows if r.get("relatedInvoices")][0]
ck("invoiced numeric", isinstance(s.get("invoicedAed"),(int,float)), s.get("invoicedAed"))
# row-drill mode unchanged (no new columns)
one=[r for r in rows if r.get("project")][0]
rd=api("/butil/lines?year=2026&metric=grn&project="+urllib.parse.quote(one["project"]))
rkeys=[c["key"] for c in rd["columns"]]
ck("row-drill columns unchanged", rkeys==["receipt","line","date","po","poLine","supplier","currency","rate","invoicedAed","uninvoicedAed","relatedInvoices","amount"], rkeys)
# regression: ap metric untouched
a=api("/butil/lines?year=2026&metric=ap&period=07-2026&projecttype=DCT%20OPEX%20Project%20Type")
ck("ap metric intact", [c["key"] for c in a["columns"]][:3]==["project","task","invoice"])
print("---"); print(f"{ok} passed, {fail} failed")
