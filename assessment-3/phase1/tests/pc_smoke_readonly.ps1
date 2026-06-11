# Phase 1 smoke test (READ-ONLY) - PC ORDS module on ADB.
# No data is created or modified. Credentials parsed at runtime from the repo's
# existing quick-login list; never printed.
$ErrorActionPreference = 'Stop'
$repo = 'c:\claude\DCT-task-management\DCT-Task-Management'
$base = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

$auth = Get-Content "$repo\final apps\PC\Jet\js\services\authService.js" -Raw
if ($auth -match "username:\s*'ADMIN',\s*password:\s*'([^']+)'") { $pwd = $Matches[1] }
else { throw 'ADMIN quick-login entry not found' }

$results = @()
function Step($name, $script) {
  try {
    $out = & $script
    $script:results += [pscustomobject]@{ test = $name; result = 'PASS'; detail = "$out" }
    Write-Host "PASS  $name - $out"
  } catch {
    $script:results += [pscustomobject]@{ test = $name; result = 'FAIL'; detail = $_.Exception.Message }
    Write-Host "FAIL  $name - $($_.Exception.Message)"
  }
}

$tok = $null
Step 'AUTH login via /dct/auth/login' {
  $body  = @{ username = 'ADMIN'; password = $pwd } | ConvertTo-Json
  $login = Invoke-RestMethod -Method Post -Uri "$base/dct/auth/login" -ContentType 'application/json' -Body $body
  if (-not $login.sessionId) { throw "no sessionId: $($login | ConvertTo-Json -Compress)" }
  $script:tok = $login.sessionId
  "user=$($login.displayName), token received"
}
if (-not $tok) { Write-Host 'Login failed - aborting'; exit 1 }
$h = @{ Authorization = "Bearer $tok" }

Step 'No-token request returns 401' {
  try { Invoke-RestMethod -Uri "$base/pc/settings" | Out-Null; throw 'expected 401' }
  catch { if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -eq 401) { 'got 401 as expected' } else { throw $_ } }
}
Step 'GET /pc/settings' {
  $r = @(Invoke-RestMethod -Uri "$base/pc/settings" -Headers $h)
  if ($r.Count -lt 1) { throw 'no settings rows' }
  "$($r.Count) settings; e.g. $($r[0].settingKey)=$($r[0].settingValue)"
}
Step 'GET /pc/pc/stats' {
  $r = Invoke-RestMethod -Uri "$base/pc/pc/stats" -Headers $h
  "activePc=$($r.activePc) pendingPc=$($r.pendingPc) totalFloat=$($r.totalFloatFormatted) orgPendingApprovals=$($r.orgPendingApprovals)"
}
Step 'GET /pc/pc/ (my petty cash)'   { "count=" + @(Invoke-RestMethod -Uri "$base/pc/pc/" -Headers $h).Count }
Step 'GET /pc/pc/all (admin list)'   { "count=" + @(Invoke-RestMethod -Uri "$base/pc/pc/all" -Headers $h).Count }
Step 'GET /pc/gl-codes' {
  $r = @(Invoke-RestMethod -Uri "$base/pc/gl-codes" -Headers $h)
  "count=$($r.Count); first ccCode=$($r[0].ccCode)"
}
Step 'GET /pc/reimbursements/all'    { "count=" + @(Invoke-RestMethod -Uri "$base/pc/reimbursements/all" -Headers $h).Count }
Step 'GET /pc/clearings/all'         { "count=" + @(Invoke-RestMethod -Uri "$base/pc/clearings/all" -Headers $h).Count }
Step 'GET /pc/approvals/pending'     { "count=" + @(Invoke-RestMethod -Uri "$base/pc/approvals/pending" -Headers $h).Count }
Step 'GET /pc/approval-templates' {
  $r = @(Invoke-RestMethod -Uri "$base/pc/approval-templates" -Headers $h)
  if ($r.Count -lt 1) { throw 'no PC approval templates' }
  "templates: $(($r | ForEach-Object { $_.templateCode }) -join ', ')"
}
Step 'GET /pc/approval-templates/{id}/steps' {
  $t = @(Invoke-RestMethod -Uri "$base/pc/approval-templates" -Headers $h)[0]
  $r = @(Invoke-RestMethod -Uri "$base/pc/approval-templates/$($t.templateId)/steps" -Headers $h)
  "$($r.Count) steps for $($t.templateCode)"
}
Step 'GET /pc/notifications/'        { "count=" + @(Invoke-RestMethod -Uri "$base/pc/notifications/" -Headers $h).Count }
Step 'GET /pc/pc/activity'           { "count=" + @(Invoke-RestMethod -Uri "$base/pc/pc/activity" -Headers $h).Count }

$pass = @($results | Where-Object result -eq 'PASS').Count
$fail = @($results | Where-Object result -eq 'FAIL').Count
Write-Host "`n=== READ-ONLY SMOKE SUMMARY: $pass passed, $fail failed ==="
$results | ConvertTo-Json -Depth 3 | Out-File -Encoding utf8 c:\tmp\pc_smoke_results.json

