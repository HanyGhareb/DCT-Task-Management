#!/usr/bin/env python3
"""Style the VBAFE budget-change workbook into the distributable template.

Takes the workbook saved from Excel (with the VBAFE layout already inside) and
produces the branded template: colored data grid, editable-column highlight,
bilingual Instructions sheet. The VBAFE config lives in veryHidden _VBCS_*/
_VBAFE_* sheets + 2 custom doc properties - openpyxl 3.1.5 preserves both
(verified 2026-07-27; it re-encodes shared strings inline, which Excel and the
add-in read identically). Re-run after any re-publish from Excel:

    python3 style_template.py "Project Budget Overrid.xlsx" iFinance_Budget_Override_Template.xlsx

v2 (2026-08-17): the editable figure is a SIGNED BUDGET CHANGE added to the
Fusion budget, the sheet is LINE grain (annual + YTD budget per line) and the
download is scoped by Business Unit / Project Type / Accounting Period. The
column layout therefore changed - so this script now resolves every column by
its HEADER TEXT instead of a hard-coded letter, and simply skips a column the
workbook does not have. Add a header alias below rather than a letter.
"""
import sys
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.formatting.rule import FormulaRule
from openpyxl.utils import get_column_letter

SRC = sys.argv[1] if len(sys.argv) > 1 else 'Project Budget Overrid.xlsx'
OUT = sys.argv[2] if len(sys.argv) > 2 else 'iFinance_Budget_Override_Template.xlsx'

BRAND      = '3F6F5F'   # GL green
BRAND_SOFT = 'EDF4F0'
GOLD       = 'C9A227'
EDIT_GOLD  = 'FDF3D0'   # soft gold wash for the editable Budget Change column
ADJ_BLUE   = 'EAF1F7'   # adjusted (derived) figures
TECH       = '8FA8A0'   # muted green for the add-in's Change/Status columns
LAST_ROW   = 3000       # pre-format this far so future downloads inherit

# header text -> role. Matching is case/space-insensitive on the leading text,
# so "Budget Change (+/-)" also matches the alias "budget change".
EDITABLE = ('budget change',)                     # gold, user types here
TECHNICAL = ('change', 'status')                  # the add-in's own columns
HIDDEN = ('row id', 'key', 'id')                  # opaque row key
MONEY = ('annual budget', 'ytd budget', 'budget change',
         'total change on line', 'adjusted annual', 'adjusted ytd')
ADJUSTED = ('adjusted annual', 'adjusted ytd', 'total change on line')
WIDTHS = {'project number': 14, 'project name': 26, 'task number': 18,
          'task name': 22, 'expenditure type': 38, 'accounting period': 16,
          'business unit': 24, 'project type': 20, 'annual budget': 18,
          'ytd budget': 18, 'budget change': 16, 'total change on line': 16,
          'adjusted annual': 18, 'adjusted ytd': 18, 'reason category': 20,
          'comments': 30, 'change updated by': 16, 'change updated at': 18}


def cf_fill(color):
    """Fill for CONDITIONAL formatting. In dxf fills Excel paints the
    background slot - setting only fgColor renders BLACK (hit live
    2026-07-27), so set both."""
    return PatternFill(start_color=color, end_color=color, fill_type='solid')


def norm(v):
    return ' '.join(str(v or '').lower().split())


def role_of(header):
    h = norm(header)
    if any(h.startswith(a) for a in EDITABLE):
        return 'edit'
    if h in TECHNICAL:
        return 'tech'
    if h in HIDDEN:
        return 'hide'
    if any(h.startswith(a) for a in ADJUSTED):
        return 'adj'
    return 'read'


wb = openpyxl.load_workbook(SRC)
ws = wb['Xl Budget']

# ---- resolve the layout from row 1 ---------------------------------------
cols = {}
for idx, cell in enumerate(ws[1], start=1):
    if cell.value is None:
        continue
    cols[idx] = (norm(cell.value), role_of(cell.value), get_column_letter(idx))
if not any(r == 'edit' for _, r, _ in cols.values()):
    print('WARNING: no "Budget Change" column found - is this the v2 workbook?')

# ---- data sheet -----------------------------------------------------------
ws.sheet_properties.tabColor = BRAND
ws.freeze_panes = 'A2'

head_font = Font(bold=True, color='FFFFFF')
center    = Alignment(horizontal='center', vertical='center', wrap_text=True)
thin      = Border(bottom=Side(style='medium', color=GOLD))
fills     = {'tech': PatternFill('solid', fgColor=TECH),
             'edit': PatternFill('solid', fgColor=GOLD),
             'adj':  PatternFill('solid', fgColor=BRAND),
             'read': PatternFill('solid', fgColor=BRAND),
             'hide': PatternFill('solid', fgColor=TECH)}

for idx, (name, role, letter) in cols.items():
    c = ws[f'{letter}1']
    c.font, c.alignment, c.border = head_font, center, thin
    c.fill = fills[role]
    for key, w in WIDTHS.items():
        if name.startswith(key):
            ws.column_dimensions[letter].width = w
            break
    else:
        ws.column_dimensions[letter].width = 12
    if role == 'hide':
        ws.column_dimensions[letter].hidden = True     # opaque row key
    if any(name.startswith(m) for m in MONEY):         # amounts as 1,234.56
        for r in range(2, LAST_ROW + 1):
            ws.cell(row=r, column=idx).number_format = '#,##0.00'

# The add-in REPAINTS the header and data region with its own style on every
# download, so all lasting decoration must be conditional formatting - CF
# renders on top of whatever cell fill the add-in writes.
wf = Font(bold=True, color='FFFFFF')
for idx, (name, role, letter) in cols.items():
    colour = {'tech': TECH, 'edit': GOLD}.get(role, BRAND)
    ws.conditional_formatting.add(f'{letter}1',
        FormulaRule(formula=['TRUE'], fill=cf_fill(colour), font=wf))
    if role == 'edit':      # soft gold wash + a bold sign on the typed value
        ws.conditional_formatting.add(f'{letter}2:{letter}{LAST_ROW}',
            FormulaRule(formula=['TRUE'], fill=cf_fill(EDIT_GOLD)))
        ws.conditional_formatting.add(f'{letter}2:{letter}{LAST_ROW}',
            FormulaRule(formula=[f'{letter}2<0'], font=Font(bold=True, color='B3261E')))
        ws.conditional_formatting.add(f'{letter}2:{letter}{LAST_ROW}',
            FormulaRule(formula=[f'{letter}2>0'], font=Font(bold=True, color='1F7A4D')))
    elif role == 'adj':     # derived figures read as a result, not an input
        ws.conditional_formatting.add(f'{letter}2:{letter}{LAST_ROW}',
            FormulaRule(formula=['TRUE'], fill=cf_fill(ADJ_BLUE)))

read_letters = [l for _, (_, r, l) in sorted(cols.items()) if r == 'read']
if read_letters:                                       # soft banding, any row count
    first, last = read_letters[0], read_letters[-1]
    ws.conditional_formatting.add(
        f'{first}2:{last}{LAST_ROW}',
        FormulaRule(formula=[f'AND(${first}2<>"",MOD(ROW(),2)=0)'], fill=cf_fill(BRAND_SOFT)))

# ---- Instructions sheet ---------------------------------------------------
if 'Instructions' in wb.sheetnames:
    del wb['Instructions']
ins = wb.create_sheet('Instructions', 0)
ins.sheet_properties.tabColor = GOLD
ins.sheet_view.showGridLines = False
ins.column_dimensions['A'].width = 3
ins.column_dimensions['B'].width = 4
ins.column_dimensions['C'].width = 78
ins.column_dimensions['D'].width = 4
ins.column_dimensions['E'].width = 78

EN = [
    'Open the Oracle Visual Builder ribbon tab and click Download Data.',
    'Sign in with your normal i-Finance username and password.',
    'Pick the four download parameters from their lists: Budget Year, Accounting Period '
    '(MM-YYYY), Business Unit and Project Type. Year and Period are mandatory; Business Unit '
    'defaults to Department of Culture and Tourism and Project Type to DCT OPEX Project Type.',
    'One row per budget line is downloaded, showing the Annual Budget and the YTD Budget '
    '(the budget up to and including the period you picked).',
    'Type your adjustment in the gold "Budget Change" column ONLY: a POSITIVE amount is ADDED '
    'to the budget line, a NEGATIVE amount is SUBTRACTED. Leave the cell blank (or type 0) to '
    'remove a change. The change is recorded against the accounting period you downloaded.',
    'Optionally pick a Reason Category and type Comments for the change.',
    'Click Upload Changes to send your edits.',
    'Check the Status column - every changed row should show "Update Succeeded".',
    'On the Budget Utilization page tick "Select to include Budget Override" to see the '
    'Annual and YTD Budget move by your changes.',
]
AR = [
    'افتح تبويب Oracle Visual Builder ثم اضغط Download Data.',
    'سجّل الدخول باسم المستخدم وكلمة المرور الخاصة بنظام i-Finance.',
    'اختر معايير التنزيل الأربعة من قوائمها: سنة الميزانية، والفترة المحاسبية بصيغة MM-YYYY، '
    'ووحدة الأعمال، ونوع المشروع. السنة والفترة إلزاميتان، وتكون وحدة الأعمال افتراضياً '
    '«دائرة الثقافة والسياحة» ونوع المشروع «DCT OPEX Project Type».',
    'يتم تنزيل صف واحد لكل بند موازنة يعرض الموازنة السنوية والموازنة منذ بداية السنة '
    '(حتى الفترة المختارة).',
    'أدخل التعديل في عمود «Budget Change» الذهبي فقط: القيمة الموجبة تُضاف إلى بند الموازنة '
    'والقيمة السالبة تُخصم منه. اترك الخلية فارغة (أو أدخل 0) لإلغاء التغيير. ويُسجَّل التغيير '
    'على الفترة المحاسبية التي نزّلتها.',
    'يمكنك اختيار فئة السبب وكتابة ملاحظات للتغيير.',
    'اضغط Upload Changes لرفع التعديلات.',
    'تحقق من عمود Status — يجب أن تظهر "Update Succeeded" لكل صف معدّل.',
    'في صفحة استخدام الموازنة فعّل «حدد لتضمين الموازنة المعدّلة» لترى الموازنة السنوية '
    'ومنذ بداية السنة وقد تغيّرت بمقدار تعديلاتك.',
]

ins.merge_cells('B2:E2')
t = ins['B2']
t.value = 'i-Finance - Project Budget Change'
t.font = Font(bold=True, size=16, color='FFFFFF')
t.fill = PatternFill('solid', fgColor=BRAND)
t.alignment = Alignment(horizontal='center', vertical='center')
ins.row_dimensions[2].height = 30

ins.merge_cells('B3:E3')
s = ins['B3']
s.value = ('Add to or subtract from a budget line for one accounting period, from Excel  |  '
           'إضافة مبلغ إلى بند الموازنة أو خصمه لفترة محاسبية واحدة من برنامج إكسل')
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
    ins.row_dimensions[row].height = 44
    row += 1

row += 1
for txt_en, txt_ar, fill in (
    ('Dark-green headers = read-only data from Oracle Fusion',
     'الأعمدة ذات الرأس الأخضر الداكن = بيانات للعرض فقط من أوراكل فيوجن', BRAND_SOFT),
    ('Gold column = editable (Budget Change, + adds / - subtracts)',
     'العمود الذهبي = قابل للتعديل (Budget Change، + إضافة / - خصم)', EDIT_GOLD),
    ('Blue columns = the result after your change (Adjusted Annual / Adjusted YTD)',
     'الأعمدة الزرقاء = الناتج بعد التغيير (Adjusted Annual / Adjusted YTD)', ADJ_BLUE)):
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
print('columns:', ', '.join(f'{l}={n}[{r}]' for _, (n, r, l) in sorted(cols.items())))
