import json, re, urllib.request
BASE="http://localhost:8097"; AUTH="/root/DCT-Task-Management/final apps/Admin/Jet/js/services/authService.js"
def login():
    u,p=re.findall(r"username:\s*'([^']+)',\s*password:\s*'([^']+)'",open(AUTH).read())[0]
    r=urllib.request.Request(BASE+"/ords/admin/dct/auth/login",data=json.dumps({"username":u,"password":p}).encode(),method="POST",headers={"Content-Type":"application/json"})
    return json.loads(urllib.request.urlopen(r,timeout=60).read())
def main():
    from playwright.sync_api import sync_playwright
    s=login(); tok=s["sessionId"]
    with sync_playwright() as p:
        b=p.chromium.launch(headless=True); pg=b.new_page(viewport={"width":1700,"height":1000})
        pg.add_init_script("localStorage.setItem('ifinance_jet_session',%s);localStorage.setItem('gl_lang','en');"%json.dumps(json.dumps(s)))
        pg.goto(BASE+"/index.html"); pg.wait_for_function("window.ko && !!window.ko.dataFor(document.body)",timeout=120000)
        pg.evaluate("ko.dataFor(document.body).go('butil')")
        pg.wait_for_function("ko.dataFor(document.body).buFiltersLoaded && ko.dataFor(document.body).buFiltersLoaded()",timeout=120000)
        pg.wait_for_timeout(2000)
        r=pg.evaluate("""async () => {
          const vm=ko.dataFor(document.body);
          const d=await (await fetch('/ords/admin/gl/butil/lov?year=2026',{headers:{'Authorization':'Bearer %s'}})).json();
          const out={dtasks:d.tasks.length, dprojects:d.projects.length};
          // does the $data fix stop the throw?
          try{ vm.buProjects([]); vm.buProjects(d.projects); out.projSet='OK '+vm.buProjects().length; }catch(e){ out.projSet='THROW: '+e; }
          try{ vm.buCcs([]); vm.buCcs(d.costCenters); out.ccSet='OK '+vm.buCcs().length; }catch(e){ out.ccSet='THROW: '+e; }
          try{ vm.buTasks([]); vm.buTasks(d.tasks); out.taskSet='OK '+vm.buTasks().length; }catch(e){ out.taskSet='THROW: '+e; }
          out.projOptions=document.querySelectorAll('#bu-proj-dl option').length;
          out.taskOptions=document.querySelectorAll('#bu-task-dl option').length;
          // now invoke the real loadBuLovs (reset guard by changing year trick not possible; call directly)
          out.buYear=vm.buYear();
          return out;
        }""" % tok)
        print(json.dumps(r, indent=1))
main()
