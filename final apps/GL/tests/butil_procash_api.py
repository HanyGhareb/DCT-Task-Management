"""Budget Utilization - the Procash figure (App 210 / GL, /gl/butil?procash=).

Proves the parameter end to end against live data: the figure appears on its own,
the flag adjusts Fund Available, an invoiced procash drops out (so nothing is ever
counted twice against the AP actual), and GL-coded procash is reported as unmapped
rather than silently dropped.

Auth: IFINANCE_TOKEN=<session id>. The fixture project/task/expenditure type at the
top must exist in DCT_BUDGET_UTILIZATION_V for the year under test.

Run: IFINANCE_TOKEN=... python3 butil_procash_api.py
"""
import json, os, sys, time, urllib.request, urllib.error
B='https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
TOK=os.environ['IFINANCE_TOKEN']; TAG='BUTIL-PCH-'+time.strftime('%Y%m%d%H%M%S')
PROJ,TASK,ET='4517000039','4510747','491811 - Heritage culture assts'
AMT=1000.0
res=[]
def call(p,m='GET',b=None):
    d=json.dumps(b).encode() if b is not None else None
    r=urllib.request.Request(B+p,data=d,method=m); r.add_header('Authorization','Bearer '+TOK)
    if d: r.add_header('Content-Type','application/json')
    try:
        x=urllib.request.urlopen(r,timeout=240); return x.status, json.loads(x.read() or b'null')
    except urllib.error.HTTPError as e:
        try: return e.code, json.loads(e.read() or b'null')
        except Exception: return e.code, None
def check(n,c,d=''):
    res.append((n,bool(c))); print(('  PASS  ' if c else '  FAIL  ')+n+(('   -> '+str(d)) if d and not c else ''))

q='/gl/butil?year=2026&limit=50&project='+PROJ+'&task='+TASK   # narrow to the coded line
c,before=call(q); check('butil responds before any procash', c==200, c)
base_fund=before['totals']['fundAvailable']; base_actual=before['totals']['actualAp']+before['totals']['actualGrn']
check('the response now carries a procash figure', 'procash' in before['totals'], list(before['totals']))
check('procash is zero before any is recorded', before['totals']['procash']==0, before['totals']['procash'])

_,lovs=call('/ap/procash/meta/lovs'); bu=lovs['businessUnits'][0]
c,made=call('/ap/procash','POST',{'bankReference':TAG,'businessUnit':bu,'payeeName':'Butil check',
  'amount':AMT,'currencyCode':'AED','paymentDate':'2026-08-18','description':'butil procash check'})
pid=made['procashId']
c,_=call('/ap/procash/%s/lines'%pid,'POST',{'codingBasis':'PROJECT','projectNumber':PROJ,
  'taskNumber':TASK,'expenditureType':ET,'amount':AMT})
check('a procash line is coded to the budget line', c==200, c)

c,off=call(q)
check('procash appears as its own figure', off['totals']['procash']==AMT, off['totals']['procash'])
check('with the parameter OFF, Fund Available is unchanged', off['totals']['fundAvailable']==base_fund,
      (base_fund, off['totals']['fundAvailable']))
check('the row carries the procash figure too',
      any(r['procash']==AMT for r in off['items']), [r.get('procash') for r in off['items']])

c,on=call(q+'&procash=Y')
check('with the parameter ON, Fund Available drops by the procash',
      abs(on['totals']['fundAvailable'] - (base_fund - AMT)) < 0.005,
      (base_fund, on['totals']['fundAvailable']))
check('the unadjusted fund is still reported alongside',
      abs(on['totals']['fundAvailableExProcash'] - base_fund) < 0.005, on['totals'].get('fundAvailableExProcash'))
check('the row fund drops by the row procash',
      any(abs((r['fundAvailable'] + r['procash']) - rr['fundAvailable']) < 0.005
          for r, rr in zip(on['items'], off['items']) if r['procash'] > 0),
      [(r['procash'], r['fundAvailable']) for r in on['items']])
check('the flag is echoed back', on.get('includeProcash')=='Y', on.get('includeProcash'))

# once the invoice is linked the figure must disappear (no double count)
call('/ap/procash/%s/submit'%pid,'POST',{}); call('/ap/procash/%s/process'%pid,'POST',{})
_,inv=call('/ap/procash/meta/invoices')
free=[i for i in inv['items'] if i['alreadyLinked']=='N']
c,_=call('/ap/procash/%s/invoice'%pid,'POST',{'invoiceId':free[0]['invoiceId']})
c,after=call(q)
check('an invoiced procash leaves the figure (never counted twice)',
      after['totals']['procash']==0, after['totals']['procash'])

# GL-coded procash cannot sit on a budget line -> reported separately
call('/ap/procash/%s/invoice'%pid,'DELETE')
_,gl=call('/ap/procash/meta/gl?search=451')
c,made2=call('/ap/procash','POST',{'bankReference':TAG+'-GL','businessUnit':bu,'payeeName':'GL coded',
  'amount':500,'currencyCode':'AED','paymentDate':'2026-08-18'})
pid2=made2['procashId']
call('/ap/procash/%s/lines'%pid2,'POST',{'codingBasis':'GL','glCombination':gl['items'][0]['code'],'amount':500})
c,un=call(q)
check('GL-coded procash is reported as unmapped, not dropped',
      un['totals']['procashUnmapped'] >= 500, un['totals'].get('procashUnmapped'))

for p in (pid,pid2): call('/ap/procash/%s/cancel'%p,'POST',{})
ok=sum(1 for _,k in res if k)
print('\n=== %d passed, %d failed ==='%(ok,len(res)-ok))
print('cleanup rows LIKE', TAG+'%')
sys.exit(0 if ok==len(res) else 1)
