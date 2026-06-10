# i-Finance — AGENTS.md

> **This file describes the legacy prototype only.**
> The active production codebase is documented in **[CLAUDE.md](CLAUDE.md)**.
> All development should target `final apps/` — not `apps/ifinance-v2/`.

---

## Legacy Prototype (apps/ifinance-v2/)

The original `apps/ifinance-v2/frontend/` directory is a vanilla JS + localStorage proof-of-concept built before the Oracle APEX + JET SPA platform existed. It is **archived and superseded** by the production codebase in `final apps/`.

**Do not add features to `apps/ifinance-v2/`.** It will not be deployed.

For all active work, refer to [CLAUDE.md](CLAUDE.md) which covers:
- Oracle JET SPA architecture (custom KO router, ORDS services, session contract)
- Oracle APEX 24.2 page creation workflow
- Database schema (DCT_* tables in PROD schema)
- ORDS setup rules for ADB managed ORDS
- Module status and per-module conventions
