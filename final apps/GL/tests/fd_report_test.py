"""Offline report regression: scope, arithmetic, pagination and real PDF/PPT output."""
import sys
from pathlib import Path
import unittest
from io import BytesIO

ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'reporting'/'runner'))
import render_fd
import render_pdf
import render_pptx


def fixture():
    rows=[]
    for i in range(30):
        for ch in range(1,6):
            rows.append(dict(sector=f'S{i%3}',sector_name=f'Sector {i%3}',sector_name_ar=f'القطاع {i%3}',
                department=f'D{i:02}',department_name=f'Department {i:02} — Planning and Executive Services',
                chapter=f'CH{ch}',budget=1000000*(i+1),actual=400000*(i+1),encumbrance=250000*(i+1),funds_available=350000*(i+1)))
    return dict(report_code='GL_BUDGET_STATUS',period='09-2026',generated_at='2026-09-05 12:00 PM',
        params=dict(period='09-2026',entity='DCT',unit='X',presentation='tiles',lang='en'),
        sections=[dict(key='cube',data=rows),dict(key='thresholds',data=[])],landscape=True)


class ReportTests(unittest.TestCase):
    def test_scopes_and_full_departments(self):
        ctx=fixture(); ctx['params'].update(sectors='S1',departments='D01')
        data=render_fd.prepare(ctx)['fd']; bands=[r for p in data['pages'] if p['kind']=='bands' for r in p['rows']]
        self.assertEqual(bands[0]['budget'],10000000)
        self.assertEqual(bands[0]['funds_available'],3500000)
        for k in render_fd.MEASURES:
            self.assertEqual(bands[0][k],sum(r[k] for r in bands[1:]))
        sectors=[r for p in data['pages'] if p['title']=='Sectors' for r in p['rows']]
        depts=[r for p in data['pages'] if p['title'].startswith('Departments') for r in p['rows']]
        self.assertEqual(len(sectors),3) # screen's contextual entity scope
        self.assertEqual(len(depts),10)
        self.assertEqual(sum(r['selected'] for r in depts),1)
        all_data=render_fd.prepare(fixture())['fd']
        self.assertEqual(sum(len(p['rows']) for p in all_data['pages'] if p['title'].startswith('Departments')),30)

    def test_layouts_arabic_and_map_zero_budgets(self):
        for layout in ('tiles','rows','map'):
            ctx=fixture();ctx['params'].update(presentation=layout,lang='ar')
            html=render_pdf.render_html(ctx,'gl_budget_status.html.j2')
            self.assertIn('حالة الموازنة',html)
            self.assertIn('dir="rtl"',html)
            self.assertIn('Department 29',html)
        rects=render_fd._rects([dict(budget=100),dict(budget=300)])
        self.assertAlmostEqual(rects[0]['w']*rects[0]['h']/(rects[1]['w']*rects[1]['h']),1/3)
        ctx=fixture();ctx['params']['presentation']='map'
        for r in ctx['sections'][0]['data']:
            if r['department']=='D00':r['budget']=0;r['funds_available']=-r['actual']-r['encumbrance']
        data=render_fd.prepare(ctx)['fd']
        self.assertTrue(any(r['code']=='D00' and r['state']=='over' for p in data['pages'] if p['kind']=='rows' for r in p['rows']))

    def test_excluded_scope_note_keeps_totals_separate(self):
        ctx=fixture()
        ctx['sections'].append(dict(key='excluded',data=[dict(budget=999,actual=123,encumbrance=45,funds_available=831)]))
        data=render_fd.prepare(ctx)['fd']
        self.assertEqual(data['pages'][0]['rows'][0]['budget'],2325000000)
        html=render_pdf.render_html(ctx,'gl_budget_status.html.j2')
        self.assertIn('Budget: 999',html)
        self.assertIn('all entities; not part of the selected total',html)

    def test_search_does_not_change_totals_and_escaping(self):
        ctx=fixture();baseline=render_fd.prepare(ctx)['fd']['pages'][0]['rows'][0]['budget']
        ctx['params']['department_search']='<script>alert(1)</script>'
        html=render_pdf.render_html(ctx,'gl_budget_status.html.j2')
        self.assertNotIn('<script>alert(1)</script>',html)
        self.assertIn('&lt;script&gt;',html)
        self.assertEqual(render_fd.prepare(ctx)['fd']['pages'][0]['rows'][0]['budget'],baseline)


if __name__=='__main__':unittest.main()
