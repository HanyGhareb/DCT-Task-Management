"""Read-only probe: is this VM's saved Fusion session still alive?

Attaches to the saved storage state exactly like step_ar_rebill's
attach_existing_session and runs auth._validate. Prints VALID or EXPIRED.
Never logs in, never writes anything.
"""
import sys
from playwright.sync_api import sync_playwright

import auth
import config


def main():
    conn = config.connect()
    config.apply_runner_config(conn)
    e = config.get_default_browser_env(conn)
    conn.close()
    env = {"env_name": e["env_name"],
           "analytics_base_url": e["analytics_base_url"],
           "fusion_apps_url": e.get("fusion_apps_url"),
           "credential_ref": e.get("credential_ref") or e["env_name"]}
    state = auth._state_path(env["env_name"])
    if not state.exists():
        print("NO-STATE")
        return 2
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(storage_state=str(state),
                                  ignore_https_errors=True)
        ok = auth._validate(ctx, env)
        ctx.close()
        browser.close()
    print("VALID" if ok else "EXPIRED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
