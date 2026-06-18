# Analytics Loader (App 208) — Enhancement Backlog

Prioritised suggestions after the App 208 build + round-1 UAT (2026-06-18). Grouped by
effort/strategic horizon. None are blockers — the platform is complete and verified.

> **Delivered 2026-06-18 — Minimal job create + auto-prepare.** Adding a job now needs only the
> analysis path (target table optional); job name/env/target/stage table are auto-derived and
> the staging table + column map are prepared by the runner on first run (`prepare.py`). This
> also covers most of #5 below (a paste-paths bulk import is now a thin loop over the minimal
> `POST /atd/jobs`). See `docs/deployment-notes.md` → "Auto-prepare contract".
>
> **Delivered 2026-06-18 — Schema-drift auto-adapt + warn.** Preparation now runs every load:
> new analysis columns are `ALTER TABLE ADD`-ed, outgrown text columns are widened, removed
> columns load NULL (warned), and incompatible type changes warn loudly (Telegram + run-log).
> See `docs/deployment-notes.md` → "Schema drift".
>
> **Delivered 2026-06-18 — Re-prepare action + atomic reload** (APP_VERSION 1.3.0). The
> incompatible-change recovery gap is now closed: Job Detail → **Re-map** clears
> `column_map_json` (next run re-derives it); **Rebuild table** also drops + recreates the
> table from the live data (`POST /jobs/:name/reprepare {"rebuild":"Y"}`). Separately,
> `TRUNCATE_INSERT` is now an **atomic replace** (`DELETE` in-transaction, not `TRUNCATE`), so a
> failed reload rolls back and the table keeps its prior load. See `docs/deployment-notes.md`
> → deployment history 2026-06-18.

## Quick wins (small, high value)
1. **Per-job scheduling (use the `schedule` column).** Jobs already carry a `schedule`
   (DBMS_SCHEDULER calendar) but Track B ignores it — every cycle re-runs all jobs. Add a
   cron/interval field in the Job form and have `enqueue` (or a tiny "due jobs" filter) queue
   **only jobs that are due**. Cuts redundant loads and OTBI export pressure as the job count grows.
2. **Incremental loads (watermark) instead of full TRUNCATE every 15 min.** For large or
   append-only analyses, add a `MERGE`-on-key or a date-watermark param so a run pulls only new
   rows. The UI already exposes `loadMode`/`keyColumns`; add a "last-loaded" watermark per job.
3. **Heartbeat / "stale scheduler" warning.** The dashboard shows `lastFinished`; add a banner
   when no run has completed in > N minutes (e.g. 2× the schedule) so a dead Task Scheduler /
   expired Entra session is obvious at a glance.
4. **Failure + truncation alerting.** `notify.py` already does Telegram; wire a post-run hook to
   push FAILED / truncation alerts (and an optional daily summary). The dashboard "Alerts" panel
   covers the in-app view; this covers off-hours.
5. **Bulk job import.** They plan *many* analyses — a "paste analysis paths → create jobs" bulk
   action (or CSV import) beats adding them one-by-one. Pairs well with `add_analysis.py`'s
   auto-derive (column map + CREATE TABLE).

## Next (medium)
6. **Role separation (least privilege).** Today every endpoint is `SYS_ADMIN`. Add an
   `ATD_OPERATOR` role (enqueue / reset / monitor) distinct from `ATD_ADMIN` (edit jobs/envs/
   targets + Runner Settings). Enterprises want operators who can run but not reconfigure.
7. **Run-log retention + purge job.** `ATD_LOAD_RUN_LOG` grows unbounded. Add a retention setting
   (keep N days) + a small scheduled purge. Surface a row-count **trend per job** on the dashboard
   so drift / silent truncation is visible over time.
8. **Per-job staging tables (multi-host safety).** The shared queue (#3 steps 1–3) is built and
   UAT-clean; before running **many** workers in parallel, give each job its own `ATD_STG_<job>`
   so two jobs never `TRUNCATE` the same table. (#3 step 4 from `otbi-atd/docs/scaling-design.md`.)
9. **"Run now" semantics.** The app enqueues; execution needs a worker tick. Either shorten the
   schedule on demand, or add a host-local agent endpoint (the dev-proxy `/__local` idea) so an
   operator can trigger a cycle immediately. Show "queued — runs at next worker tick (≤ schedule)".

## Enterprise / strategic
10. **Secrets → OCI Vault + instance principal** (on the OCI VM). Removes *all* passwords from the
    host (`env.ps1` shrinks to nothing): the VM authenticates to Vault + ADB with its own identity.
    The Runner Settings page already manages the non-secret config; this finishes the secret half.
11. **Worker fleet rollout (#3 steps 4–5).** Stand up N OCI VMs each running `runner.py --worker`;
    the `SKIP LOCKED` queue + `reap_stale` already partition work safely. Throughput scales linearly.
12. **Track A (BIP SOAP API) for MFA-free unattended runs.** The pod exposes
    `ExternalReportWSSService.runReport`. Wrapping the analyses as BIP reports + a non-MFA service
    account removes the browser **and** MFA entirely — the endgame for a large fleet. Plugs into the
    same control tables (`extract_track='API'`), so jobs migrate piecemeal.

## Nice-to-have
13. **Connection test buttons** — "Test environment" (reach the pod) / "Test target" (DB reachable),
    surfaced on the Environments/Targets forms (needs a host agent for the OTBI side).
14. **Vault/dark theme** for the ops console (cosmetic; the platform already supports brand theming).

---

**Recommended next two:** (1) per-job scheduling + (2) incremental loads — together they make the
15-min cadence cheap and correct at scale, which is exactly where the "many analyses" plan is headed.
