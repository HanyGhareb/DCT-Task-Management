# otbi-atd DEDICATED discovery runner (Windows Task Scheduler, every 1 minute).
# Separate from the data loader (run_atd.ps1): this drains ONLY the subject-area
# column-picker discovery queue. `python runner.py --discover` early-exits with NO
# browser/MFA when the queue is empty, so this is free when idle and only launches
# the scraper when a subject area is actually QUEUED. Logs to ..\run-discover.log.
#
# Single-browser lock: the discover task and the loader task (run_atd.ps1) must NOT
# drive an OTBI browser at the same time (one Fusion SSO session -> concurrent pages
# corrupt each other, e.g. "folder did not load children"). Both acquire the SAME
# exclusive lock file; if the other runner holds it, this cycle is skipped.
$ErrorActionPreference = 'Continue'
$dir  = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log  = Join-Path $dir '..\run-discover.log'
$lock = Join-Path $dir '..\.otbi_runner.lock'
Set-Location $dir

$fs = $null
try { $fs = [System.IO.File]::Open($lock, 'OpenOrCreate', 'ReadWrite', 'None') }
catch { exit 0 }                      # loader (or a prior discover) is running -> skip

try {
  . (Join-Path $dir 'env.ps1') | Out-Null
  $out = (& python runner.py --discover 2>&1 | Out-String)
  Add-Content -Path $log -Encoding utf8 -Value (
    "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [discover] ===`r`n" + $out.TrimEnd() +
    "`r`n--- end discover (exit $LASTEXITCODE) ---")
}
finally {
  if ($fs) { $fs.Close() }
  Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
