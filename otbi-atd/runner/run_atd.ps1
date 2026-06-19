# otbi-atd scheduled LOADER wrapper (Windows Task Scheduler, every 15 minutes).
# Dot-sources the git-ignored env.ps1 (creds + Telegram + oracledb mode) then drains
# the build + load queues, appending each phase to ..\run.log:
#   --build : build + load any QUEUED "Add New OTBI Analysis" requests
#   (plain) : load all enabled jobs
# Subject-area DISCOVERY has its own dedicated 1-minute task (run_atd_discover.ps1) —
# it is intentionally NOT run here. Each phase early-exits cheaply (no browser/MFA)
# when its queue is empty.
$ErrorActionPreference = 'Continue'
$dir = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log = Join-Path $dir '..\run.log'
Set-Location $dir
. (Join-Path $dir 'env.ps1') | Out-Null

function Invoke-AtdPhase($label, $phaseArgs) {
  $out = (& python runner.py @phaseArgs 2>&1 | Out-String)
  Add-Content -Path $log -Encoding utf8 -Value (
    "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$label] ===`r`n" + $out.TrimEnd() +
    "`r`n--- end $label (exit $LASTEXITCODE) ---")
}

Invoke-AtdPhase 'build' @('--build')
Invoke-AtdPhase 'load'  @()
