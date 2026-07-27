#!/usr/bin/env python3
"""Style the VBAFE budget-override workbook into the distributable template.

Takes the workbook saved from Excel (with the VBAFE layout already inside) and
produces the branded template: colored data grid, editable-column highlight,
bilingual Instructions sheet. The VBAFE config lives in veryHidden _VBCS_*/
_VBAFE_* sheets + 2 custom doc properties - openpyxl 3.1.5 preserves both
(verified 2026-07-27; it re-encodes shared strings inline, which Excel and the
add-in read identically). Re-run after any re-publish from Excel:

    python3 style_template.py "Project Budget Overrid.xlsx" iFinance_Budget_Override_Template.xlsx
"""
import sys
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.formatting.rule import FormulaRule

SRC = sys.argv[1] if len(sys.argv) > 1 else 'Project Budget Overrid.xlsx'
OUT = sys.argv[2] if len(sys.argv) > 2 else 'iFinance_Budget_Override_Template.xlsx'

BRAND      = '3F6F5F'   # GL green
BRAND_SOFT = 'EDF4F0'
GOLD       = 'C9A227'
EDIT_GREEN = 'C6EFCE'   # light green for the editable Override Budget column
TECH       = '8FA8A0'   # muted green for the add-in's Change/Status columns
LAST_ROW   = 3000       # pre-format this far so future downloads inherit


def cf_fill(color):
    """Fill for CONDITIONAL formatting. In dxf fills Excel paints the
    background slot - setting only fgColor renders BLACK (hit live
    2026-07-27), so set both."""
    return PatternFill(start_color=color, end_color=color, fill_type='solid')

wb = openpyxl.load_workbook(SRC)
ws = wb['Xl Budget']

# ---- data sheet -----------------------------------------------------------
ws.sheet_properties.tabColor = BRAND
ws.freeze_panes = 'A2'

head_fill = PatternFill('solid', fgColor=BRAND)
tech_fill = PatternFill('solid', fgColor=TECH)
gold_fill = PatternFill('solid', fgColor=GOLD)
head_font = Font(bold=True, color='FFFFFF')
center    = Alignment(horizontal='center', vertical='center', wrap_text=True)
thin      = Border(bottom=Side(style='medium', color=GOLD))

for col in 'ABCDEFGHIJKLMN':
    c = ws[f'{col}1']
    c.font, c.alignment, c.border = head_font, center, thin
    c.fill = tech_fill if col in 'AB' else (gold_fill if col == 'K' else head_fill)
ws.row_dimensions[1].height = 26

widths = {'A': 10, 'B': 16, 'C': 11, 'D': 15, 'E': 26, 'F': 20, 'G': 20,
          'H': 38, 'I': 14, 'J': 15, 'K': 15, 'L': 18, 'M': 18, 'N': 8}
for col, w in widths.items():
    ws.column_dimensions[col].width = w
ws.column_dimensions['N'].hidden = True          # opaque row key - not for users

for r in range(2, LAST_ROW + 1):                 # amounts as 1,234.56
    ws.cell(row=r, column=10).number_format = '#,##0.00'
    ws.cell(row=r, column=11).number_format = '#,##0.00'

# The add-in REPAINTS the header and data region with its own style on every
# download, so all lasting decoration must be conditional formatting - CF
# renders on top of whatever cell fill the add-in writes. Header ranges are
# non-overlapping so no rule-priority games are needed.
wf = Font(bold=True, color='FFFFFF')
ws.conditional_formatting.add('A1:B1',
    FormulaRule(formula=['TRUE'], fill=cf_fill(TECH), font=wf))
ws.conditional_formatting.add('C1:J1',
    FormulaRule(formula=['TRUE'], fill=cf_fill(BRAND), font=wf))
ws.conditional_formatting.add('K1',
    FormulaRule(formula=['TRUE'], fill=cf_fill(GOLD), font=wf))
ws.conditional_formatting.add('L1:N1',
    FormulaRule(formula=['TRUE'], fill=cf_fill(BRAND), font=wf))

# editable-column light-green wash + soft banding, any row count
ws.conditional_formatting.add(
    f'K2:K{LAST_ROW}',
    FormulaRule(formula=['TRUE'], fill=cf_fill(EDIT_GREEN)))
ws.conditional_formatting.add(
    f'C2:J{LAST_ROW}',
    FormulaRule(formula=['AND($D2<>"",MOD(ROW(),2)=0)'], fill=cf_fill(BRAND_SOFT)))

# ---- Instructions sheet ---------------------------------------------------
if 'Instructions' in wb.sheetnames:
    del wb['Instructions']
ins = wb.create_sheet('Instructions', 0)
ins.sheet_properties.tabColor = GOLD
ins.sheet_view.showGridLines = False
ins.column_dimensions['A'].width = 3
ins.column_dimensions['B'].width = 4
ins.column_dimensions['C'].width = 72
ins.column_dimensions['D'].width = 4
ins.column_dimensions['E'].width = 72

EN = [
    'Open the Oracle Visual Builder ribbon tab and click Download Data.',
    'Sign in with your normal i-Finance username and password.',
    'Enter the Budget Year (e.g. 2026) and the Accounting Period in MM-YYYY form (e.g. 01-2026). Both are mandatory.',
    'Edit ONLY the light-green "Override Budget" column. Leave a cell blank to remove your override.',
    'Click Upload Changes to send your edits.',
    'Check the Status column - every changed row should show "Update Succeeded".',
]
AR = [
    'افتح تبويب Oracle Visual Builder ثم اضغط Download Data.',
    'سجّل الدخول باسم المستخدم وكلمة المرور الخاصة بنظام i-Finance.',
    'أدخل سنة الميزانية (مثال 2026) والفترة المحاسبية بصيغة MM-YYYY (مثال 01-2026) — كلاهما إلزامي.',
    'عدّل عمود "Override Budget" الأخضر الفاتح فقط، واترك الخلية فارغة لإلغاء التعديل.',
    'اضغط Upload Changes لرفع التعديلات.',
    'تحقق من عمود Status — يجب أن تظهر "Update Succeeded" لكل صف معدّل.',
]

ins.merge_cells('B2:E2')
t = ins['B2']
t.value = 'i-Finance - Project Budget Override'
t.font = Font(bold=True, size=16, color='FFFFFF')
t.fill = PatternFill('solid', fgColor=BRAND)
t.alignment = Alignment(horizontal='center', vertical='center')
ins.row_dimensions[2].height = 30

ins.merge_cells('B3:E3')
s = ins['B3']
s.value = 'Maintain your budget override figures directly from Excel  |  تعديل أرقام الميزانية مباشرة من برنامج إكسل'
s.font = Font(italic=True, color='666666')
s.alignment = Alignment(horizontal='center')

row = 5
for i, (en, ar) in enumerate(zip(EN, AR), start=1):
    n = ins.cell(row=row, column=2, value=i)
    n.font = Font(bold=True, color=GOLD, size=12)
    n.alignment = Alignment(horizontal='center', vertical='top')
    e = ins.cell(row=row, column=3, value=en)
    e.alignment = Alignment(wrap_text=True, vertical='top')
    a = ins.cell(row=row, column=5, value=ar)
    a.alignment = Alignment(wrap_text=True, vertical='top', horizontal='right', readingOrder=2)
    ins.row_dimensions[row].height = 30
    row += 1

row += 1
for txt_en, txt_ar, fill in (
    ('Dark-green headers = read-only data from Oracle Fusion',
     'الأعمدة ذات الرأس الأخضر الداكن = بيانات للعرض فقط من أوراكل فيوجن', BRAND_SOFT),
    ('Light-green column = editable (Override Budget)',
     'العمود الأخضر الفاتح = قابل للتعديل (Override Budget)', EDIT_GREEN)):
    c = ins.cell(row=row, column=3, value=txt_en)
    c.fill = PatternFill('solid', fgColor=fill)
    a = ins.cell(row=row, column=5, value=txt_ar)
    a.fill = PatternFill('solid', fgColor=fill)
    a.alignment = Alignment(horizontal='right', readingOrder=2)
    row += 1

row += 1
n = ins.cell(row=row, column=3,
             value='Rows cannot be added or deleted from Excel. For access issues contact the Finance system administrator.')
n.font = Font(italic=True, color='888888')
a = ins.cell(row=row, column=5,
             value='لا يمكن إضافة أو حذف صفوف من إكسل. للمساعدة يرجى التواصل مع مسؤول النظام.')
a.font = Font(italic=True, color='888888')
a.alignment = Alignment(horizontal='right', readingOrder=2)

wb.active = wb['Instructions']
wb.save(OUT)
print('written', OUT)
