"""Export fidelity tests: browser numeric formatting and long-label pagination."""
import copy,json,os,subprocess,sys
from pathlib import Path
from playwright.sync_api import sync_playwright
from fd_report_test import fixture
import render_fd,render_pdf
ROOT=Path(__file__).resolve().parents[3];OUT=Path(os.environ.get('FD_DEEP_OUT','/tmp/fd-deep/report-before'));OUT.mkdir(parents=True,exist_ok=True)
results=[]
def check(name,ok,detail=None):
 results.append(dict(name=name,passed=bool(ok),detail=detail));print(('PASS ' if ok else 'FAIL ')+name,flush=True)
source=(ROOT/'final apps/GL/Jet/js/app.js').read_text()
formatters=source[source.index('    self.money ='):source.index('    /* ════ snapshot refresh')]
formatters+=source[source.index('    self.buNum ='):source.index('    self.toggleBuSec =')]
values=[0,-0.1,2.5,-2.5,2500,-2500,1250000,-1250000,12345678,1000000000,1005000000]
js='var self={buUnit:()=>unit};var unit;'+formatters+';process.stdout.write(JSON.stringify(Object.fromEntries(["X","K","M","B","auto"].map(u=>{unit=u;return [u,'+json.dumps(values)+'.map(v=>self.buNum(v))]}))));'
expected=json.loads(subprocess.check_output(['node','-e',js]))
for unit in expected:
 for value, want in zip(values,expected[unit]):
  ctx=fixture();ctx['params']['unit']=unit
  ctx['sections'][0]['data']=[dict(sector='S',sector_name='S',department='D',department_name='D',chapter='CH1',budget=value,actual=0,encumbrance=0,funds_available=value)]
  got=render_fd.prepare(ctx)['fd']['pages'][0]['rows'][0]['figures'][0]['text']
  check(f'{unit} {value} matches dashboard formatting',got==want,dict(expected=want,actual=got))
with sync_playwright() as p:
 b=p.chromium.launch(headless=True);page=b.new_page(viewport={'width':1280,'height':720})
 for lang in ['en','ar']:
  for layout in ['tiles','rows','map']:
   ctx=fixture();ctx['params'].update(lang=lang,presentation=layout)
   for row in ctx['sections'][0]['data']:
    row['sector_name']='Strategy and Corporate Planning / '+('Department Coordination ' * 8)
    row['sector_name_ar']='التخطيط الاستراتيجي وإدارة البرامج والمشاريع والتنسيق المؤسسي '*4
    row['department_name']=row['department']+' '+('Financial Planning and Strategy Coordination ' * 5)
   html=render_pdf.render_html(ctx,'gl_budget_status.html.j2');page.set_content(html)
   overlaps=page.evaluate("""()=>Array.from(document.querySelectorAll('.report-page')).flatMap((p,i)=>{let y=p.querySelector('footer').getBoundingClientRect().top;return Array.from(p.querySelectorAll('.tile,.ledger tbody tr,.band,.scope-line')).filter(e=>e.getBoundingClientRect().bottom>y-5).map(e=>({page:i+1,text:e.innerText.slice(0,60),bottom:e.getBoundingClientRect().bottom,footer:y}))})""")
   check(lang+' '+layout+' long names do not overlap footer',not overlaps,overlaps)
   expected=render_fd.prepare(ctx)['fd']['pages']
   for kind,selector in [('tiles','.tile'),('rows','.ledger tbody tr'),('bands','.band')]:
    count=sum(len(p['rows']) for p in expected if p['kind']==kind)
    check(lang+' '+layout+' pagination preserves all '+kind,page.locator(selector).count()==count)
   check(lang+' '+layout+' page numbers reflect actual page count',page.locator('footer span:last-child').last.inner_text().endswith(' / '+str(page.locator('.report-page').count())))
   if overlaps:
    i=overlaps[0]['page']-1;page.locator('.report-page').nth(i).screenshot(path=str(OUT/f'{lang}-{layout}-overflow.png'))
 b.close()
(OUT/'results.json').write_text(json.dumps(results,indent=2));print(f"{sum(r['passed'] for r in results)}/{len(results)} passed")
raise SystemExit(0 if all(r['passed'] for r in results) else 1)
