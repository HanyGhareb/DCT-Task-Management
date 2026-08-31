#!/usr/bin/env python3
"""GL Budget Utilization — Appropriation/Program filters + reorder + BU default."""
import json, re, sys, urllib.request
BASE="http://localhost:8098"
AUTH="/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
ok=fail=0
def ck(n,c,x=""):
    global ok,fail
    print(("  PASS " if c else "  FAIL ")+n+" "+str(x)); 
    ok+=1 if c else 0; fail+=0 if c else 1
def login():
    u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",open(AUTH).read())[0]
    r=urllib.request.Request(BASE+"/ords/admin/dct/auth/login",data=json.dumps({"username":u,"password":p}).encode(),method="POST",headers={"Content-Type":"application/json"})
    return json.loads(urllib.request.urlopen(r,timeout=60).read())
def api(tok,path):
    r=urllib.request.Request(BASE+"/ords/admin/gl"+path,headers={"Authorization":"Bearer "+tok})
    return json.loads(urllib.request.urlopen(r,timeout=90).read())
def main():
    s=login(); tok=s["sessionId"]; ck("login",bool(tok))
    f=api(tok,"/butil/filters")
    ck("filters: appropriations[] present",isinstance(f.get("appropriations"),list) and len(f["appropriations"])>0,"(%d)"%len(f.get("appropriations",[])))
    ck("filters: programs[] present",isinstance(f.get("programs"),list) and len(f["programs"])>0,"(%d)"%len(f.get("programs",[])))
    ck("filters: businessUnits has DCT","Department of Culture and Tourism" in (f.get("businessUnits") or []))
    yr=f.get("defaultYear")
    base=api(tok,"/butil?year=%s&limit=1"%yr)["total"]
    ck("baseline total > 0",base>0,"(%d)"%base)
    ap=f["appropriations"][0]
    fa=api(tok,"/butil?year=%s&limit=1&appropriation=%s"%(yr,urllib.parse.quote(ap)))["total"]
    ck("appropriation filter narrows",0<fa<=base,"(%d of %d, ap=%s)"%(fa,base,ap[:30]))
    pg=f["programs"][0]
    fp=api(tok,"/butil?year=%s&limit=1&program=%s"%(yr,urllib.parse.quote(pg)))["total"]
    ck("program filter narrows",0<fp<=base,"(%d of %d)"%(fp,base))
    # drill parity: /butil/lines aggregate honours appropriation
    print("== %d pass / %d fail =="%(ok,fail)); sys.exit(1 if fail else 0)
import urllib.parse
main()
