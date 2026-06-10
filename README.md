# i-Finance — DCT Finance Division Platform

Multi-module Oracle APEX + Oracle JET SPA platform for the Finance Division of a UAE government organisation, running on Oracle Autonomous Database (ADB) 23ai in OCI.

App 200 (Admin) is the central identity provider; all module apps authenticate through it.

---

## Repository Layout

```
final apps/          ← ALL live production code lives here
  Admin/Jet/         ← App 200 — JET SPA (auth, users, roles, settings)
  PC/Jet/            ← App 201 — Petty Cash JET SPA
  DT/Jet/            ← App 204 — Duty Travel JET SPA
  HR/Jet/            ← App 205 — HR JET SPA
  FL/                ← App 203 — Freelancers (APEX only; no JET SPA yet)
  CC/                ← App 202 — Credit Cards (APEX only; no JET SPA yet)
  SHARED_JET_ARCHITECTURE.md   ← session contract, module checklist
  SHARED_APEX_ARCHITECTURE.md  ← APEX auth scheme, app items, LOVs

db/v2/               ← Shared DCT_* DDL, packages, ORDS setup
  install.sql        ← master script: runs 01→12 in order
  01_dct_ddl.sql     ← 24 DCT_* tables
  03_dct_auth_pkg.sql← DCT_AUTH package
  11_dct_ords.sql    ← all ORDS module definitions (Admin /dct/ path)
  12_dct_master_data.sql ← reference tables (grades, countries, GL codes…)
  _archive/          ← applied patches and diagnostic scripts (read-only)

apps/ifinance-v2/    ← LEGACY: vanilla JS prototype (localStorage only)
                       Do not add features here

docs/                ← operational guides (APEX setup, MCP, test scenarios)
  _legacy/           ← historical proposals and project plans (archived)

myDoc/               ← Oracle Wallet connection files
                       NOTE: Wallet_prod.zip must NOT be committed (see .gitignore)
```

---

## Module Status

| Module | App ID | DB + ORDS | JET SPA | APEX Pages |
|--------|--------|-----------|---------|------------|
| Admin  | 200 | ✅ Complete | ✅ Live ORDS | ✅ Users/Roles built |
| Petty Cash | 201 | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |
| Credit Cards | 202 | ⬜ Pkg stub only | ⬜ Not started | ⬜ Pending in Builder |
| Freelancers | 203 | ✅ Complete | ⬜ Not started | ⬜ Pending in Builder |
| Duty Travel | 204 | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |
| HR | 205 | ✅ Complete | ✅ Complete | ⬜ Pending in Builder |

See each module's `STATUS.md` for detailed per-layer progress.

---

## Running a JET SPA Locally

Every JET module has `dev-proxy.py` in its `Jet/` folder. It serves static files on port 8080 and proxies `/ords/` requests to ADB (adds CORS headers).

```bash
# Example — Duty Travel
cd "final apps/DT/Jet"
python dev-proxy.py
# Open http://localhost:8080
```

Toggle mock vs live ORDS in `js/services/config.js`:
```js
// apiBase: null,            // mock mode — no network calls
apiBase: '/ords/admin/dct',  // live via dev-proxy
```

The Admin app must be running (or a valid session must exist in localStorage) for module apps to show the main shell — they redirect to `../Admin/Jet/index.html` when no session is found.

---

## Database Connection

```powershell
C:\claude\tools\sqlcl\sqlcl\bin\sql.exe -name prod_mcp
```

- Connect alias `prod_mcp` uses the wallet in `myDoc/`
- All packages and objects must be in PROD schema; when running as ADMIN prefix with `prod.`
- Add `SET DEFINE OFF` at top of every seed script (`&` triggers substitution prompts)

---

## Key Architecture Documents

| Document | Purpose |
|---|---|
| [CLAUDE.md](CLAUDE.md) | AI agent guidance — architecture rules, gotchas, conventions |
| [final apps/SHARED_JET_ARCHITECTURE.md](final%20apps/SHARED_JET_ARCHITECTURE.md) | JET SPA session contract, service patterns, KO binding rules |
| [final apps/SHARED_APEX_ARCHITECTURE.md](final%20apps/SHARED_APEX_ARCHITECTURE.md) | APEX auth scheme, standard app items, LOVs, module checklist |
| [final apps/DT/STATUS.md](final%20apps/DT/STATUS.md) | DT module reference — most complete status example |
| [docs/APEX_SETUP.md](docs/APEX_SETUP.md) | APEX Builder setup guide for new module apps |
