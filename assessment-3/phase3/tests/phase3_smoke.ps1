# Phase 3 smoke test - pagination envelopes, stats/charts endpoints, prefs round-trip.
# Credentials parsed at runtime from the repo quick-login list; never printed.
$ErrorActionPreference = 'Stop'
$repo = 'c:\claude\DCT-task-management\DCT-Task-Management'
$base = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

$auth = Get-Content "$repo\final apps\Admin\Jet\js\services\authService.js" -Raw
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
Step 'AUTH login' {
  $body  = @{ username = 'ADMIN'; password = $pwd } | ConvertTo-Json
  $login = Invoke-RestMethod -Method Post -Uri "$base/dct/auth/login" -ContentType 'application/json' -Body $body
  if (-not $login.sessionId) { throw 'no sessionId' }
  $script:tok = $login.sessionId
  "user=$($login.displayName)"
}
if (-not $tok) { Write-Host 'Login failed - aborting'; exit 1 }
$h = @{ Authorization = "Bearer $tok" }

# ---- dct.admin ----
Step 'users/ paginated envelope' {
  $r = Invoke-RestMethod -Uri "$base/dct/users/?limit=5&offset=0" -Headers $h
  if ($null -eq $r.total) { throw 'no total' }
  if (@($r.items).Count -gt 5) { throw 'limit ignored' }
  "total=$($r.total) items=$(@($r.items).Count) limit=$($r.limit)"
}
Step 'users/ search bind' {
  $r = Invoke-RestMethod -Uri "$base/dct/users/?limit=5&search=admin" -Headers $h
  "matches=$($r.total)"
}
Step 'users/ offset page 2' {
  $r1 = Invoke-RestMethod -Uri "$base/dct/users/?limit=2&offset=0" -Headers $h
  $r2 = Invoke-RestMethod -Uri "$base/dct/users/?limit=2&offset=2" -Headers $h
  if ($r1.total -gt 2 -and @($r2.items).Count -gt 0 -and $r1.items[0].userId -eq $r2.items[0].userId) { throw 'offset not applied' }
  "page1[0]=$($r1.items[0].username) page2 count=$(@($r2.items).Count)"
}
Step 'audit/ paginated envelope + action filter' {
  $r = Invoke-RestMethod -Uri "$base/dct/audit/?limit=10&action=LOGIN" -Headers $h
  if ($null -eq $r.total) { throw 'no total' }
  $bad = @($r.items | Where-Object { $_.action -ne 'LOGIN' })
  if ($bad.Count -gt 0) { throw 'action filter leaked other actions' }
  "total LOGIN=$($r.total) items=$(@($r.items).Count)"
}
Step 'stats/ keys' {
  $r = Invoke-RestMethod -Uri "$base/dct/stats/" -Headers $h
  if ($null -eq $r.activeUsers) { throw 'no activeUsers' }
  if ($null -eq $r.approvalCycle) { throw 'no approvalCycle' }
  if ($null -eq $r.activity) { throw 'no activity' }
  "activeUsers=$($r.activeUsers) cycleRows=$(@($r.approvalCycle).Count) activityDays=$(@($r.activity).Count)"
}
Step 'stats/ 401 without token' {
  try { Invoke-RestMethod -Uri "$base/dct/stats/" | Out-Null; throw 'expected 401' }
  catch { if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -eq 401) { 'got 401' } else { throw $_ } }
}
Step 'prefs/ round-trip' {
  Invoke-RestMethod -Method Put -Uri "$base/dct/prefs/LANG" -Headers $h -ContentType 'application/json' -Body (@{ value = 'ar' } | ConvertTo-Json) | Out-Null
  $r = Invoke-RestMethod -Uri "$base/dct/prefs/" -Headers $h
  $row = @($r.items) | Where-Object { $_.key -eq 'LANG' }
  if (-not $row -or $row.value -ne 'ar') { throw 'LANG pref not persisted' }
  Invoke-RestMethod -Method Put -Uri "$base/dct/prefs/LANG" -Headers $h -ContentType 'application/json' -Body (@{ value = 'en' } | ConvertTo-Json) | Out-Null
  'PUT ar -> GET ar -> PUT en OK'
}

# ---- pc.rest ----
Step 'pc/all envelope (no raw array)' {
  $r = Invoke-RestMethod -Uri "$base/pc/pc/all?limit=5" -Headers $h
  if ($null -eq $r.total) { throw 'still raw array / no total' }
  "total=$($r.total) items=$(@($r.items).Count)"
}
Step 'pc/all search+status binds' {
  $r = Invoke-RestMethod -Uri "$base/pc/pc/all?limit=5&status=REJECTED" -Headers $h
  $bad = @($r.items | Where-Object { $_.status -ne 'REJECTED' })
  if ($bad.Count -gt 0) { throw 'status filter leaked' }
  "REJECTED total=$($r.total)"
}
Step 'pc/charts keys' {
  $r = Invoke-RestMethod -Uri "$base/pc/pc/charts" -Headers $h
  if ($null -eq $r.floatsByOrg) { throw 'no floatsByOrg' }
  if ($null -eq $r.tempAgeing) { throw 'no tempAgeing' }
  "orgs=$(@($r.floatsByOrg).Count) ageingBuckets=$(@($r.tempAgeing).Count)"
}

# ---- dt.rest ----
Step 'dt requests/ paginated envelope' {
  $r = Invoke-RestMethod -Uri "$base/dt/requests/?limit=5&offset=0" -Headers $h
  if ($null -eq $r.total) { throw 'no total' }
  "total=$($r.total) items=$(@($r.items).Count)"
}
Step 'dt requests/?mine=Y regression' {
  $r = Invoke-RestMethod -Uri "$base/dt/requests/?mine=Y" -Headers $h
  if ($null -eq $r.items) { throw 'mine branch broken' }
  "mine count=$(@($r.items).Count)"
}
Step 'dt dashboard/ chart series' {
  $r = Invoke-RestMethod -Uri "$base/dt/dashboard/" -Headers $h
  if ($null -eq $r.monthlySpend) { throw 'no monthlySpend' }
  if ($null -eq $r.statusFunnel) { throw 'no statusFunnel' }
  "months=$(@($r.monthlySpend).Count) funnelRows=$(@($r.statusFunnel).Count) activeRequests=$($r.activeRequests)"
}

# ---- hr (unchanged, native paging assertion) ----
Step 'hr employees/ native paging fields' {
  $r = Invoke-RestMethod -Uri "$base/hr/employees/?offset=0&limit=5" -Headers $h
  if ($null -eq $r.items) { throw 'no items' }
  "items=$(@($r.items).Count) hasMore=$($r.hasMore) limit=$($r.limit)"
}

$pass = @($results | Where-Object result -eq 'PASS').Count
$fail = @($results | Where-Object result -eq 'FAIL').Count
Write-Host ""
Write-Host "=== PHASE 3 SMOKE SUMMARY: $pass passed, $fail failed ==="
$results | ConvertTo-Json -Depth 3 | Out-File -Encoding utf8 c:\tmp\phase3_smoke_results.json
