#!/usr/bin/env python3
"""Read-only PAY Phase 1.1 browser smoke against the live ORDS API."""
import json, os, sys
from playwright.sync_api import sync_playwright

base=os.environ.get('PAY_BASE','http://localhost:8215')
tok=os.environ.get('PAY_TOK')
if not tok: sys.exit('Set PAY_TOK')
session={'sessionId':tok,'userId':int(os.environ.get('PAY_UID','1')),'username':os.environ.get('PAY_USERNAME','ADMIN'),'displayName':'System Administrator','roles':['SYS_ADMIN'],'rolesCsv':'SYS_ADMIN'}
checks=[]
def ok(name,value): checks.append(bool(value)); print(('PASS' if value else 'FAIL'),name)

with sync_playwright() as p:
  browser=p.chromium.launch(headless=True)
  ctx=browser.new_context(viewport={'width':1600,'height':1000})
  ctx.add_init_script("localStorage.setItem('ifinance_jet_session',"+json.dumps(json.dumps(session))+")")
  page=ctx.new_page(); errors=[]; page.on('pageerror',lambda e:errors.append(str(e)))
  page.goto(base+'/index.html'); page.wait_for_load_state('networkidle'); page.wait_for_timeout(1200)
  ok('dashboard governance regions',page.locator('.ap-region').count()>=3)
  ok('renewal monitor shown',page.get_by_text('Contract Renewal Monitor',exact=True).count()==1)
  ok('data quality shown',page.get_by_text('Governance Data Quality',exact=True).count()==1)
  page.locator('.nav-item',has_text='Companies').click(); page.wait_for_timeout(1200)
  if page.locator('.data-table tbody tr').count():
    page.locator('.data-table tbody tr').first.click(); page.wait_for_timeout(800)
    labels=page.locator('.ap-tabs .ap-tab').all_inner_texts()
    ok('company governance tabs',all(x in labels for x in ['Contacts','Compliance','Ownership','Performance']))
    page.locator('.ap-tab',has_text='Contacts').click(); page.wait_for_timeout(200)
    ok('contacts tab renders',page.locator('.dw-b .data-table').count()>=1)
    page.locator('.dw-h .btn',has_text='Close').click()
  else: ok('company row available',False)
  page.locator('.nav-item',has_text='Contracts').click(); page.wait_for_timeout(1200)
  if page.locator('.data-table tbody tr').count():
    page.locator('.data-table tbody tr').first.click(); page.wait_for_timeout(800)
    labels=page.locator('.ap-tabs .ap-tab').all_inner_texts()
    ok('contract governance tabs',all(x in labels for x in ['Commercial Controls','Fees','Renewal','Amendments']))
    page.locator('.ap-tab',has_text='Commercial Controls').click(); page.wait_for_timeout(200)
    page.evaluate("require(['knockout'],function(ko){window.__payVer=ko.dataFor(document.querySelector('.dw-drawer')).govForm.rowVersion()})")
    page.wait_for_timeout(100)
    ok('optimistic version loaded',page.evaluate('window.__payVer') is not None)
  else:
    page.locator('.page-actions .btn-primary',has_text='New Contract').click(); page.wait_for_timeout(300)
    labels=page.locator('.ap-tabs .ap-tab').all_inner_texts()
    ok('contract governance tabs',all(x in labels for x in ['Commercial Controls','Fees','Renewal','Amendments']))
    page.locator('.dw-h .btn',has_text='Close').click(); page.wait_for_timeout(200)
  page.locator(".lang-pill button",has_text='ع').click(); page.wait_for_timeout(800)
  ok('Arabic RTL',page.locator('html[dir=rtl]').count()==1)
  ok('no JavaScript errors',not errors)
  browser.close()
print('%d/%d PASS'%(sum(checks),len(checks)))
sys.exit(0 if all(checks) else 1)
