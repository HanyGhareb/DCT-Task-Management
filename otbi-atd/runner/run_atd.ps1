# otbi-atd scheduled-runner wrapper (Windows Task Scheduler).
# Dot-sources the git-ignored env.ps1 (creds + Telegram + oracledb mode) then
# runs the loader for all enabled jobs, appending to ..\run.log.
$ErrorActionPreference = 'Continue'
$dir = 'C:\claude\DCT-task-management\DCT-Task-Management\otbi-atd\runner'
$log = Join-Path $dir '..\run.log'
Set-Location $dir
. (Join-Path $dir 'env.ps1') | Out-Null
$out = (& python runner.py 2>&1 | Out-String)
Add-Content -Path $log -Encoding utf8 -Value (
  "=== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===`r`n" + $out.TrimEnd() +
  "`r`n--- end (exit $LASTEXITCODE) ---")
