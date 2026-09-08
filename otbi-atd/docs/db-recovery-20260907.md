# Queue-poll database recovery — 2026-09-07

Observed: all three ATD workers exited on September 5 around 02:43 Dubai
with DPY-4011 at claim_next. VM182 first logged the disconnect on its idle
path. This confirms a lost DB connection, not whether the original disruption
was Oracle maintenance or a network event.

The patch pings the control connection before each forever-worker iteration,
reconnects on a narrow connection-error allowlist using capped backoff/jitter,
and rebuilds the run_one closure after reconnection. Browser/context maps stay
in memory. A disconnect during claim_next is not replayed; unknown claims
remain subject to the existing lease/reaper mechanism. This may delay an
unknown committed claim until lease expiry. Active job writes and Fusion actions
are not automatically retried by this change. Other error paths retain their
existing behavior.

Four isolated tests pass (healthy connection, transient reconnect failure,
non-connectivity error, fresh connection without replay). Python compile
checks pass locally and on each worker.

Installed runner.py + db_recovery.py on VM180/181/182; original runner hashes
matched HEAD on all three before installation. Backup on each VM:
/root/otbi-atd/runner/runner.py.pre-db-recovery-20260907.

Activation pending: the running Python workers have not been restarted, to
preserve in-memory Fusion contexts. A future worker restart loads the patch.
Runtime recovery has not been fault-injected on production.
