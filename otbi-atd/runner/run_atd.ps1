# otbi-atd scheduled LOADER wrapper (Windows Task Scheduler, every 15 minutes).
# Dot-sources the git-ignored env.ps1 (creds + Telegram + oracledb mode) then drains
# the build + load queues, appending each phase to ..\run.log:
#   --build : build + load any QUEUED "Add New OTBI Analysis" requests
#   (plain) : load all enabled jobs
# Subject-area DISCOVERY has its own dedicated 1-minute task (run_atd_discover.ps1) —
# it is intentionally NOT run here. Each phase early-exits cheaply (no browser/MFA)
# when its queue is empty.
#
# Single-browser lock: the loader and the discover task must NOT drive an OTBI browser
# at the same time (one Fusion SSO session -> concurrent pages corrupt each other).
# Both acquire the SAME exclusive lock file; if discover holds it, this cycle is skipped
# (the loader retries on its next 15-min tick).
$ErrorActionPreference = 'Continue'
$dir  = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log  = Join-Path $dir '..\run.log'
$lock = Join-Path $dir '..\.otbi_runner.lock'
Set-Location $dir

$fs = $null
try { $fs = [System.IO.File]::Open($lock, 'OpenOrCreate', 'ReadWrite', 'None') }
catch { exit 0 }                      # discover (or a prior loader) is running -> skip

try {
  . (Join-Path $dir 'env.ps1') | Out-Null

  function Invoke-AtdPhase($label, $phaseArgs) {
    $out = (& python runner.py @phaseArgs 2>&1 | Out-String)
    Add-Content -Path $log -Encoding utf8 -Value (
      "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$label] ===`r`n" + $out.TrimEnd() +
      "`r`n--- end $label (exit $LASTEXITCODE) ---")
  }

  Invoke-AtdPhase 'build' @('--build')
  Invoke-AtdPhase 'load'  @()
}
finally {
  if ($fs) { $fs.Close() }
  Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
