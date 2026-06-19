# otbi-atd DEDICATED discovery runner (Windows Task Scheduler, every 1 minute).
# Separate from the data loader (run_atd.ps1): this drains ONLY the subject-area
# column-picker discovery queue. `python runner.py --discover` early-exits with NO
# browser/MFA when the queue is empty, so this is free when idle and only launches
# the scraper when a subject area is actually QUEUED. Logs to ..\run-discover.log.
$ErrorActionPreference = 'Continue'
$dir = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log = Join-Path $dir '..\run-discover.log'
Set-Location $dir
. (Join-Path $dir 'env.ps1') | Out-Null
$out = (& python runner.py --discover 2>&1 | Out-String)
Add-Content -Path $log -Encoding utf8 -Value (
  "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [discover] ===`r`n" + $out.TrimEnd() +
  "`r`n--- end discover (exit $LASTEXITCODE) ---")
