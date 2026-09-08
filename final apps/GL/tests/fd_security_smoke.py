"""Authorized temporary-account report isolation tests; always remove test users."""
import json,re,secrets,subprocess,time
from pathlib import Path
from fd_report_live_smoke import req,ROOT
OUT=Path('/tmp/fd-deep/security');OUT.mkdir(parents=True,exist_ok=True)
results=[]
def check(name,ok,detail=None):
 results.append(dict(name=name,passed=bool(ok),detail=detail));print(('PASS ' if ok else 'FAIL ')+name,flush=True)
tag='UAT_FD_'+time.strftime('%Y%m%d%H%M%S')
users=[]
try:
 auth=(ROOT/'final apps/Admin/Jet/js/services/authService.js').read_text();u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",auth)[0]
 s,b=req('POST','/dct/auth/login',body=dict(username=u,password=p));assert s==200;admin=b['sessionId']
 for label,roles in [('ALLOW',['GL_ANALYST']),('DENY',[])]:
  username=tag+'_'+label;password='Fd9!'+secrets.token_urlsafe(24)
  s,b=req('POST','/dct/users/',admin,dict(username=username,password=password,displayName='Temporary Budget Status UAT '+label,email=username.lower()+'@example.invalid',isActive='Y',isExternal='N',roles=roles))
  assert s in (200,201) and b.get('userId'),(s,b);users.append(username)
  s,b=req('POST','/dct/auth/login',body=dict(username=username,password=password));assert s==200,(s,b)
  if label=='ALLOW':allowed=b['sessionId']
  else:denied=b['sessionId']
 _,filters=req('GET','/gl/actuals/filters',admin);period=filters['defaultPeriod']
 s,_=req('GET','/gl/fd/status?period='+period,denied);check('Account without report permission can read dashboard',s==200,s)
 s,b=req('POST','/gl/fd/report',denied,dict(period=period,format='PDF'));check('Print denied without report privilege',s==403,s)
 s,b=req('POST','/gl/fd/report',allowed,dict(period=period,format='PDF',presentation='tiles',entity='ALL'));check('Allowed temporary account can queue report',s==200,s);assert s==200;run=b['runId']
 for suffix in ['', '/file']:
  s,_=req('GET',f'/gl/fd/report/{run}'+suffix,denied);check('Denied account blocked from report'+suffix,s==403,s)
  s,_=req('GET',f'/gl/fd/report/{run}'+suffix,admin);check('Another privileged user cannot access report'+suffix,s==404,s)
 deadline=time.monotonic()+300
 while time.monotonic()<deadline:
  s,b=req('GET',f'/gl/fd/report/{run}',allowed)
  if b.get('status') in ('SUCCESS','FAILED'):break
  time.sleep(3)
 check('Owner report completes',b.get('status')=='SUCCESS',b.get('status'))
 s,b=req('GET',f'/gl/fd/report/{run}/file',allowed,binary=True);check('Owner can download own PDF',s==200 and isinstance(b,bytes) and b.startswith(b'%PDF'),s)
 if s==200 and isinstance(b,bytes):(OUT/'owner.pdf').write_bytes(b)
finally:
 if users:
  names=','.join("'"+x+"'" for x in users)
  sql=f"""whenever sqlerror exit failure rollback
set serveroutput on
begin
 delete from prod.dct_sessions where user_id in (select user_id from prod.dct_users where username in ({names}));
 delete from prod.dct_user_roles where user_id in (select user_id from prod.dct_users where username in ({names}));
 delete from prod.dct_users where username in ({names});
 dbms_output.put_line('REMOVED_ACCOUNTS='||sql%rowcount);
 commit;
end;
/
select count(*) remaining_test_accounts from prod.dct_users where username in ({names});
exit
"""
  path=OUT/'cleanup.sql';path.write_bytes(sql.replace('\n','\r\n').encode())
  cleanup=subprocess.run(['sql','-name','prod_mcp','@'+str(path)],capture_output=True,text=True,timeout=90)
  (OUT/'cleanup.log').write_text(cleanup.stdout+cleanup.stderr)
  check('Temporary accounts and sessions removed',cleanup.returncode==0 and 'REMOVED_ACCOUNTS='+str(len(users)) in cleanup.stdout)
 (OUT/'results.json').write_text(json.dumps(results,indent=2))
print(f"{sum(r['passed'] for r in results)}/{len(results)} passed",flush=True)
raise SystemExit(0 if all(r['passed'] for r in results) else 1)
