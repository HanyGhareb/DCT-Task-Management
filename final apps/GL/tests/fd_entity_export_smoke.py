"""User-authorized built-in quick-login check of configured entity exports."""
import re,json,time
from pathlib import Path
from fd_report_live_smoke import req,ROOT
u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",(ROOT/'final apps/Admin/Jet/js/services/authService.js').read_text())[0]
_,b=req('POST','/dct/auth/login',body=dict(username=u,password=p));tok=b['sessionId']
_,f=req('GET','/gl/actuals/filters',tok);period=f['defaultPeriod'];_,cube=req('GET','/gl/fd/status?period='+period,tok)
results=[];runs=[]
for entity in sorted(set([e['code'] for e in cube['entities']]+['UNCLASSIFIED'])):
 s,b=req('POST','/gl/fd/report',tok,dict(period=period,entity=entity,format='PDF'))
 results.append([entity+' accepted by report validator',s==200 and bool(b.get('runId'))]);print(entity,s,flush=True)
 if s==200:runs.append(b['runId'])
deadline=time.monotonic()+300
pending=set(runs)
while pending and time.monotonic()<deadline:
 for run in list(pending):
  s,b=req('GET',f'/gl/fd/report/{run}',tok)
  if b.get('status') in ('SUCCESS','FAILED'):
   results.append([f'Entity test report {run} completes',b['status']=='SUCCESS']);pending.remove(run)
 if pending:time.sleep(3)
results.append(['All entity report runs finished',not pending])
Path('/tmp/fd-deep/entity-results.json').write_text(json.dumps(results,indent=2))
print(f'{sum(ok for _,ok in results)}/{len(results)} passed')
raise SystemExit(0 if all(ok for _,ok in results) else 1)
