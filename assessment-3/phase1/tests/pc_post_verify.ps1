$ErrorActionPreference = 'Stop'
$repo = 'c:\claude\DCT-task-management\DCT-Task-Management'
$base = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
$auth = Get-Content "$repo\final apps\PC\Jet\js\services\authService.js" -Raw
if ($auth -match "username:\s*'ADMIN',\s*password:\s*'([^']+)'") { $pwd = $Matches[1] } else { throw 'no cred' }
$login = Invoke-RestMethod -Method Post -Uri "$base/dct/auth/login" -ContentType 'application/json' -Body (@{username='ADMIN';password=$pwd}|ConvertTo-Json)
$h = @{ Authorization = "Bearer $($login.sessionId)" }
$pcId = 2

$r = Invoke-RestMethod -Uri "$base/pc/pc/$pcId" -Headers $h
"READBACK: pcNumber=$($r.pcNumber) status=$($r.status) amount=$($r.amount) employee=$($r.employeeName) approvalStatus=$($r.approvalStatus)"

$lines = Invoke-RestMethod -Uri "$base/pc/pc/$pcId/lines" -Headers $h
$lines | ForEach-Object { "LINE: num=$($_.lineNum) amount=$($_.amount) ccId=$($_.ccId) ccCode=$($_.ccCode)" }

$pend = Invoke-RestMethod -Uri "$base/pc/approvals/pending" -Headers $h
$mine = $pend | Where-Object { $_.sourceRecordId -eq $pcId -and $_.requestType -eq 'PETTY_CASH' }
if (-not $mine) { throw 'new PC not found in pending approvals' }
"PENDING: instanceId=$($mine.instanceId) step='$($mine.currentStep)' amount=$($mine.amount) submittedBy=$($mine.submittedBy)"

$act = Invoke-RestMethod -Method Post -Uri "$base/pc/approvals/$($mine.instanceId)/action" -Headers $h -ContentType 'application/json' -Body (@{action='REJECTED';comments='Phase 1 smoke test cleanup - intentional rejection of test record'}|ConvertTo-Json)
"ACTION: ok=$($act.ok) action=$($act.action)"

$chk = Invoke-RestMethod -Uri "$base/pc/pc/$pcId" -Headers $h
"FINAL: status=$($chk.status) (expected REJECTED)"

$activity = Invoke-RestMethod -Uri "$base/pc/pc/activity" -Headers $h
$activity | Select-Object -First 2 | ForEach-Object { "ACTIVITY: $($_.requestRef) $($_.action) by $($_.actionedBy)" }
