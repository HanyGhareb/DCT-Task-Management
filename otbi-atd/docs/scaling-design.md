# otbi-atd — Multi-host scaling design (#3, the shared queue)

**Status:** proposed (not built). Goal: let **N hosts** drain **one** `ATD_OTBI_JOBS` queue with
**no overlap**, so throughput scales by adding hosts. Builds on what's already live: `oracledb`
default load (155×) + `priority`/`run_order` ordering (`db/11`).

---

## The idea in one line
Each host is a **worker** that atomically **claims** the next unclaimed job, runs it, marks it
done, and repeats — Oracle's `SELECT … FOR UPDATE SKIP LOCKED` guarantees each job goes to exactly
one worker. No central scheduler, no per-host job lists.

```
              ATD_OTBI_JOBS  (one queue: priority, run_order, status, claimed_by, claimed_at)
                       │   SKIP LOCKED → each READY job to exactly one host
        ┌──────────────┼──────────────┐
      Host A         Host B         Host C        (add more = faster)
   claim→run→done  claim→run→done  claim→run→done
```

---

## Step 1 — DB: add claim columns (`db/12_atd_job_queue.sql`, rerunnable ALTER)
```sql
ALTER TABLE prod.atd_otbi_jobs ADD (
  run_status  VARCHAR2(12) DEFAULT 'READY' NOT NULL,  -- READY|CLAIMED|DONE|FAILED
  claimed_by  VARCHAR2(120),                          -- host id that holds it
  claimed_at  TIMESTAMP,                              -- when claimed (for lease expiry)
  last_run_id NUMBER                                  -- FK-ish to ATD_LOAD_RUN_LOG
);
-- index for the claim probe
CREATE INDEX prod.ix_atd_jobs_claim ON prod.atd_otbi_jobs (run_status, priority, run_order);
```
> Guard each ADD against ORA-01430 (already exists) like `db/11`. `enabled='N'` jobs are never
> claimed. A run resets `run_status='READY'` for the batch it intends to process.

## Step 2 — DB: `claim_next()` (the atomic grab) in `DCT_ATD_PKG` or a thin function
```sql
FUNCTION claim_next(p_host VARCHAR2) RETURN VARCHAR2 IS  -- returns job_name or NULL
  CURSOR c IS
    SELECT job_name FROM prod.atd_otbi_jobs
     WHERE enabled='Y' AND run_status='READY'
     ORDER BY priority, run_order, job_name
     FOR UPDATE SKIP LOCKED;
  v job_name%TYPE;
BEGIN
  OPEN c; FETCH c INTO v;
  IF c%FOUND THEN
    UPDATE prod.atd_otbi_jobs
       SET run_status='CLAIMED', claimed_by=p_host, claimed_at=SYSTIMESTAMP
     WHERE job_name=v;
  END IF;
  CLOSE c; COMMIT;       -- COMMIT releases the row lock; the status flag now owns it
  RETURN v;
END;
```
`SKIP LOCKED` means two hosts calling this at the same instant each get a **different** job (or
NULL when the queue is empty) — never the same one.

## Step 3 — Runner: `--worker` loop
```
python runner.py --worker            # drain the queue, then exit
python runner.py --worker --forever  # keep polling (for a long-lived service)
```
Loop per worker (host id = `$env:COMPUTERNAME`/hostname, or `ATD_WORKER_ID`):
```
auth once per env (reuse saved session; MFA→Telegram only if expired)
while True:
    name = claim_next(host)          # one DB round-trip
    if not name: break               # queue drained
    job = load job row
    try:  extract → oracledb load → log SUCCESS;  set run_status='DONE', last_run_id
    except: log FAILED;              set run_status='FAILED'
```
Auth grouping stays: a worker authenticates per env the first time it claims a job for that env.

## Step 4 — Per-job staging (so parallel jobs never collide)
Today TRUNCATE_INSERT writes straight into the target. With many workers, two jobs must never
truncate the same table. Rule: **each job loads into its own staging table** (`ATD_STG_<job>`),
then swaps/merges into the final table. `add_analysis.py` already emits a per-job table; extend it
to always emit a private stage + a final, with `load_mode` deciding swap (TRUNCATE_INSERT) vs
MERGE on `key_columns`.

## Step 5 — Lease timeout (crash recovery)
If a worker dies mid-job, its row stays `CLAIMED` forever. A reaper (a `claim_next` precondition,
or a tiny scheduler job) resets stale claims:
```sql
UPDATE prod.atd_otbi_jobs
   SET run_status='READY', claimed_by=NULL, claimed_at=NULL
 WHERE run_status='CLAIMED'
   AND claimed_at < SYSTIMESTAMP - INTERVAL '30' MINUTE;   -- ATD_LEASE_MINUTES
```
Then another worker re-claims it. (FAILED jobs are left for inspection, not auto-retried, unless
you opt in.)

---

## What you run, at any scale
Put the **same runner** on each host; each runs `python runner.py --worker` (on a schedule or as a
service). They all pull from the one ADB queue. 200 jobs / 3 hosts ≈ 3× faster; / 10 hosts ≈ 10×.
`priority`/`run_order` decide what gets grabbed first.

## Auth at scale (the real ceiling)
Every **browser** host needs its own occasional MFA approval (its own saved session). Fine for a
few hosts; painful for many. The endgame is **Track A** — the BIP SOAP service-account API
(no browser, no MFA), which plugs into the **same** queue (`extract_track='API'`). Migrate jobs
piecemeal; the control tables already support both tracks.

## Build order (each independently shippable)
1. ✅ `oracledb` default (done) — removes the load bottleneck; precondition for parallelism paying off.
2. **Step 1+2+3** — claim columns + `claim_next()` + `--worker` (the multi-host enabler).
3. **Step 4** — per-job staging (safe parallel writes to distinct tables).
4. **Step 5** — lease timeout + reaper (resilience).
5. Later — Track A API track for MFA-free fleet growth.

## Test plan
- **Unit:** two python threads call `claim_next` against a seeded queue → assert disjoint claim
  sets, no dupes, all jobs claimed exactly once.
- **System:** run 2 `--worker` processes on one host over 6 jobs → each job has exactly one
  SUCCESS run-log row; faster wall-clock than serial.
- **Crash:** kill a worker mid-job → after lease expiry another worker completes it.
