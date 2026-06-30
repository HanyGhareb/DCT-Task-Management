# i-Finance Reporting runner — scheduled wrapper (Windows Task Scheduler).
# Dot-sources the git-ignored env.ps1 (DB + SMTP secrets) then drains the report
# queue (claims QUEUED PYTHON runs, renders, archives, emails), appending to
# ..\rpt-run.log. Each run early-exits cheaply when the queue is empty.
#
# Own exclusive lock (.rpt_runner.lock) prevents two reporting cycles overlapping.
# NOTE: the headless Chromium used for PDF rendering is a fresh local instance and
# is independent of the OTBI Fusion SSO session, so this does NOT share the
# otbi-atd browser lock.
$ErrorActionPreference = 'Continue'
$dir  = 'C:\claude\DCT-task-management\DCT-Task-Management\reporting\runner'
$log  = Join-Path $dir '..\rpt-run.log'
$lock = Join-Path $dir '..\.rpt_runner.lock'
Set-Location $dir

$fs = $null
try { $fs = [System.IO.File]::Open($lock, 'OpenOrCreate', 'ReadWrite', 'None') }
catch { exit 0 }                      # a prior reporting cycle is still running -> skip

try {
  . (Join-Path $dir 'env.ps1') | Out-Null
  $venv = Join-Path $dir '.venv\Scripts\python.exe'
  $py = if (Test-Path $venv) { $venv } else { 'python' }
  $out = (& $py runner.py 2>&1 | Out-String)
  Add-Content -Path $log -Encoding utf8 -Value (
    "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [reporting] ===`r`n" + $out.TrimEnd() +
    "`r`n--- end (exit $LASTEXITCODE) ---")
}
finally {
  if ($fs) { $fs.Close() }
  Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
