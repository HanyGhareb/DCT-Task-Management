"""Verify download_csv's classification against the REAL OTBI endpoint (reuses the
saved session -> no MFA):
  * the configured GL_BALANCES path  -> returns CSV
  * a deliberately-bogus path        -> ReportError (authenticated 'Path not found'),
                                        NOT SessionExpired (which would wrongly trigger
                                        re-auth + MFA)."""
import json
import config
import auth
import extract
from playwright.sync_api import sync_playwright

conn = config.connect()
cur = conn.cursor()
cur.execute("select env_name, analytics_base_url, nvl(credential_ref, env_name) "
            "from prod.atd_otbi_env where enabled='Y' and extract_track='BROWSER' and rownum=1")
e, u, r = cur.fetchone()
env = {"env_name": e, "analytics_base_url": u, "credential_ref": r}
cur.execute("select source_ref, params_json from prod.atd_otbi_jobs where job_name='GL_BALANCES'")
row = cur.fetchone()
good = row[0]
params = json.loads(row[1]) if row and row[1] else None
bogus = "/users/haghareb@dctabudhabi.ae/No/Such/Report/Does/Not/Exist"

with sync_playwright() as p:
    b, x = auth.authenticate(p, env)          # reuse saved session; no MFA if valid
    print("[1] good path (%s)" % good)
    try:
        csv = extract.download_csv(x, env, good, params)
        print("    -> CSV ok, %d bytes [PASS]" % len(csv))
    except Exception as ex:  # noqa: BLE001
        print("    -> %s [FAIL] :: %s" % (type(ex).__name__, str(ex)[:90]))
    print("[2] bogus path (expect ReportError, NOT SessionExpired)")
    try:
        extract.download_csv(x, env, bogus)
        print("    -> no exception [FAIL]")
    except extract.ReportError as ex:
        print("    -> ReportError [PASS] :: %s" % str(ex)[:90])
    except extract.SessionExpired as ex:
        print("    -> SessionExpired [FAIL: would trigger useless re-auth] :: %s" % str(ex)[:90])
    except Exception as ex:  # noqa: BLE001
        print("    -> %s [FAIL] :: %s" % (type(ex).__name__, str(ex)[:90]))
    b.close()
