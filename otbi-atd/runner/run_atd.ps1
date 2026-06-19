# otbi-atd scheduled-runner wrapper (Windows Task Scheduler).
# Dot-sources the git-ignored env.ps1 (creds + Telegram + oracledb mode) then
# drains all three runner queues, appending to ..\run.log:
#   --discover : scrape any QUEUED subject areas for the column picker
#   --build    : build + load any QUEUED "Add New OTBI Analysis" requests
#   (plain)    : load all enabled jobs
# Each phase early-exits cheaply (no browser/MFA) when its queue is empty, so a
# single scheduled cycle keeps every queue self-draining like the load queue.
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

Invoke-AtdPhase 'discover' @('--discover')
Invoke-AtdPhase 'build'    @('--build')
Invoke-AtdPhase 'load'     @()
