# otbi-atd scheduled ACTION wrapper (Windows Task Scheduler, e.g. every 5 minutes).
# Drains the Fusion write-back queue (prod.atd_action_request) via the shared SSO
# session — the INVERSE of the extract loader. Appends to ..\run-actions.log:
#   --actions : perform each queued action INSIDE Fusion (first type: AP_INVOICE)
#
# Idempotent + semi-attended: each action pre-checks Fusion (no duplicate invoices),
# and writes are gated by ATD_ACTION_LIVE=1 in env.ps1 (else dry-run: probe + form
# validation only, nothing saved). MFA is approved by a human only when the saved
# SSO session expires (same as the extract jobs).
#
# Single-browser lock: this task shares the SAME exclusive lock file as the loader
# (run_atd.ps1) and discover (run_atd_discover.ps1) — one Fusion SSO session must
# never drive concurrent browsers. If another task holds the lock, this cycle is
# skipped and retried on the next tick. Schedule with MultipleInstances=IgnoreNew.
$ErrorActionPreference = 'Continue'
$dir  = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log  = Join-Path $dir '..\run-actions.log'
$lock = Join-Path $dir '..\.otbi_runner.lock'
Set-Location $dir

$fs = $null
try { $fs = [System.IO.File]::Open($lock, 'OpenOrCreate', 'ReadWrite', 'None') }
catch { exit 0 }                      # loader/discover is running -> skip this cycle

try {
  . (Join-Path $dir 'env.ps1') | Out-Null

  $out = (& python runner.py --actions 2>&1 | Out-String)
  Add-Content -Path $log -Encoding utf8 -Value (
    "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [actions] ===`r`n" + $out.TrimEnd() +
    "`r`n--- end actions (exit $LASTEXITCODE) ---")
}
finally {
  if ($fs) { $fs.Close() }
  Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
