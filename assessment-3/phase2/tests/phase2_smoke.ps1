# Phase 2 smoke test - DT module_code fix + PC re-smoke + PC write (status history).
# Credentials parsed at runtime from the repo quick-login list; never printed.
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
  if (-not $login.sessionId) { throw "no sessionId" }
  $script:tok = $login.sessionId
  "user=$($login.displayName), token received"
}
if (-not $tok) { Write-Host 'Login failed - aborting'; exit 1 }
$h = @{ Authorization = "Bearer $tok" }

# ---------- DT: Phase 2.0 fix verification ----------
Step 'DT no-token returns 401' {
  try { Invoke-RestMethod -Uri "$base/dt/settings/" | Out-Null; throw 'expected 401' }
  catch { if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -eq 401) { 'got 401 as expected' } else { throw $_ } }
}
Step 'GET /dt/settings/ returns rows (was empty before module_code fix)' {
  $r = (Invoke-RestMethod -Uri "$base/dt/settings/" -Headers $h).items
  if (@($r).Count -lt 1) { throw 'still empty - module_code fix not effective' }
  "$(@($r).Count) settings rows"
}
Step 'DT settings have no clear-text secrets' {
  $r = (Invoke-RestMethod -Uri "$base/dt/settings/" -Headers $h).items
  $bad = @($r | Where-Object { $_.settingKey -match 'API_KEY|SECRET|PASSWORD|TOKEN' -and $_.settingValue -and $_.settingValue -ne '********' })
  if ($bad.Count -gt 0) { throw "unmasked secret keys: $(($bad | ForEach-Object settingKey) -join ',')" }
  'all secret-like values masked or null'
}
Step 'GET /dt/approval-templates/ returns rows (was empty)' {
  $r = (Invoke-RestMethod -Uri "$base/dt/approval-templates/" -Headers $h).items
  if (@($r).Count -lt 1) { throw 'no DT approval templates returned' }
  "templates: $((@($r) | ForEach-Object { $_.templateCode }) -join ', ')"
}
Step 'GET /dt/notifications/ (NULL module_code rows now included)' {
  $r = (Invoke-RestMethod -Uri "$base/dt/notifications/" -Headers $h).items
  "count=$(@($r).Count)"
}
Step 'GET /dt/requests/ (DT_REQUESTS_V fixed)' {
  $r = (Invoke-RestMethod -Uri "$base/dt/requests/" -Headers $h).items
  "count=$(@($r).Count)"
}

# ---------- PC: read re-smoke ----------
Step 'GET /pc/settings - secrets still masked' {
  $r = @(Invoke-RestMethod -Uri "$base/pc/settings" -Headers $h)
  $key = $r | Where-Object { $_.settingKey -eq 'ANTHROPIC_API_KEY' }
  if ($key -and $key.settingValue -and $key.settingValue -ne '********') { throw 'API key NOT masked' }
  "$($r.Count) settings; API key masked"
}
Step 'GET /pc/pc/stats' {
  $r = Invoke-RestMethod -Uri "$base/pc/pc/stats" -Headers $h
  "activePc=$($r.activePc) pendingPc=$($r.pendingPc)"
}
Step 'GET /pc/pc/all' { "count=" + @(Invoke-RestMethod -Uri "$base/pc/pc/all" -Headers $h).Count }
Step 'GET /pc/gl-codes' {
  $r = @(Invoke-RestMethod -Uri "$base/pc/gl-codes" -Headers $h)
  if ($r.Count -lt 1) { throw 'no gl codes' }
  $script:glId = ($r | Select-Object -First 1).ccId
  "count=$($r.Count); using ccId=$script:glId for write test"
}

# ---------- PC: write test (pre-approved) - verifies status history ----------
$pcId = $null; $pcNum = $null
Step 'POST /pc/ creates PHASE2 SMOKE TEST petty cash' {
  $body = @{
    amount      = 150
    pcType      = 'TEMPORARY'
    purpose     = 'PHASE2 SMOKE TEST - safe to ignore'
    codingType  = 'GL'
    dueDate     = (Get-Date).AddDays(30).ToString('yyyy-MM-dd')
    budgetLines = @(@{ amount = 150; ccId = $script:glId; description = 'PHASE2 SMOKE TEST line' })
  } | ConvertTo-Json -Depth 4
  $r = Invoke-RestMethod -Method Post -Uri "$base/pc/pc/" -Headers $h -ContentType 'application/json' -Body $body
  if (-not $r.pcId) { throw "no pcId in response" }
  $script:pcId = $r.pcId; $script:pcNum = $r.pcNumber
  "created $($r.pcNumber) (id=$($r.pcId), status=$($r.status))"
}
Step 'POST approvals action REJECTED (cleanup, leaves terminal status)' {
  if (-not $script:pcId) { throw 'no pc created' }
  $pend = @(Invoke-RestMethod -Uri "$base/pc/approvals/pending" -Headers $h)
  $mine = $pend | Where-Object { $_.requestRef -eq $script:pcNum }
  if (-not $mine) { throw "instance for $script:pcNum not in pending list" }
  $body = @{ action = 'REJECTED'; comments = 'PHASE2 SMOKE TEST rejection - automated cleanup' } | ConvertTo-Json
  $r = Invoke-RestMethod -Method Post -Uri "$base/pc/approvals/$($mine.instanceId)/action" -Headers $h -ContentType 'application/json' -Body $body
  "instance $($mine.instanceId) action=$($r.action)"
}

$pass = @($results | Where-Object result -eq 'PASS').Count
$fail = @($results | Where-Object result -eq 'FAIL').Count
Write-Host ""
Write-Host "=== PHASE 2 SMOKE SUMMARY: $pass passed, $fail failed ==="
if ($pcNum) { Write-Host "Write-test artifact: $pcNum (REJECTED, labelled PHASE2 SMOKE TEST)" }
$results | ConvertTo-Json -Depth 3 | Out-File -Encoding utf8 c:\tmp\phase2_smoke_results.json
