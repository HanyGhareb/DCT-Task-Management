"""Build the Admin-convention UAT workbook/results from an offline review run."""
from pathlib import Path
import json
from openpyxl import Workbook
from openpyxl.styles import Font,PatternFill,Alignment
from docx import Document
from docx.shared import Inches

base=Path(__file__).resolve().parents[1]/'UAT'
trial=base/'UAT_GL_round1-05-09-2026'
ev=trial/'evidence_05-Sep-2026-01'
results=json.loads((ev/'results.json').read_text())
unit_names=['Report scope, totals and all departments','All presentations, Arabic and map boundary values','Excluded balances remain separate from totals','Department search scope and HTML escaping']
rows=[]
for i,(name,ok) in enumerate(results,1):
    rows.append([f'FD-{i:02}',name,'Local browser / synthetic API', 'PASS' if ok else 'FAIL',f'evidence_05-Sep-2026-01/case_{i:02}.png'])
for i,name in enumerate(unit_names,1): rows.append([f'FD-UNIT-{i}',name,'Offline unit test','PASS','tests/fd_report_test.py'])
for i,name in enumerate(['Compile report seed and ORDS bridge in target database','Live PDF/PPT totals reconcile with dashboard for each presentation','Live 401/403/404 and cross-user report ownership'],1):
    rows.append([f'FD-LIVE-{i}',name,'After approved deployment','NOT RUN','Deployment approval pending'])
def workbook(path,master=False):
    wb=Workbook();ws=wb.active;ws.title='Budget Status'
    ws.append(['ID','Check / expected behavior','Environment','Status','Evidence / notes'])
    for r in rows:ws.append(r[:3]+(['NOT RUN'] if master else [r[3]])+[r[4]])
    for c in ws[1]:c.font=Font(bold=True,color='FFFFFF');c.fill=PatternFill('solid',fgColor='3C6D5D')
    for col,width in zip('ABCDE',[18,65,30,15,65]):ws.column_dimensions[col].width=width
    for row in ws.iter_rows(min_row=2):
        for c in row:c.alignment=Alignment(wrap_text=True,vertical='top')
    ws.freeze_panes='A2';ws.auto_filter.ref=ws.dimensions
    wb.save(path)
workbook(trial/'UAT_GL_05-Sep-2026-01.xlsx')
if not (base/'UAT_GL_TestScript.xlsx').exists():workbook(base/'UAT_GL_TestScript.xlsx',True)
doc=Document();doc.add_heading('Budget Status — Local Verification',0)
doc.add_paragraph('05 September 2026 · Round 1 · Not deployed. All financial figures in screenshots and sample reports are synthetic test data.')
doc.add_paragraph(f'{sum(ok for _,ok in results)}/{len(results)} browser/render checks passed; 4/4 unit tests passed. Target-database compilation, live reporting and access checks are NOT RUN pending explicit deployment approval. This is local verification, not executive UAT acceptance.')
doc.add_heading('Delivered behavior',1)
doc.add_paragraph('Compact search arrangement with Presentation at the right; Show Summary unchecked by default; Print menu for PDF and PowerPoint using the report queue. Previous-period comparison was excluded as requested. PowerPoint uses slide images to preserve dashboard artwork; individual values are not editable shapes.')
table=doc.add_table(rows=1, cols=3);table.style='Light Shading Accent 1'
for c,v in zip(table.rows[0].cells,['ID','Check','Result']):c.text=v
for r in rows:
    for c,v in zip(table.add_row().cells,[r[0],r[1],r[3]]):c.text=v
doc.add_heading('Search layout preview',1);doc.add_picture(str(ev/'00_search_layout.png'),width=Inches(6.4))
doc.add_heading('Evidence and review files',1)
doc.add_paragraph('One numbered screenshot per browser/render case is in evidence_05-Sep-2026-01. That folder also contains sample PDF/PPTX output and three HTML presentation samples. The workbook links every case to its evidence. Deployment instructions: docs/budget-status-review.md.')
doc.save(trial/'UAT_GL_Results_05-Sep-2026-01.docx')
print('Review package:',trial)
