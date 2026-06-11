# Phase 2 smoke - retry of the 3 failed steps with safe debugging.
# NEVER prints setting values; only lengths and boolean comparisons.
$ErrorActionPreference = 'Stop'
$repo = 'c:\claude\DCT-task-management\DCT-Task-Management'
$base = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'

$auth = Get-Content "$repo\final apps\PC\Jet\js\services\authService.js" -Raw
if ($auth -match "username:\s*'ADMIN',\s*password:\s*'([^']+)'") { $pwd = $Matches[1] } else { throw 'creds not found' }
$body  = @{ username = 'ADMIN'; password = $pwd } | ConvertTo-Json
$login = Invoke-RestMethod -Method Post -Uri "$base/dct/auth/login" -ContentType 'application/json' -Body $body
$h = @{ Authorization = "Bearer $($login.sessionId)" }

Write-Host '--- [1] /pc/settings masking diagnostic (values never printed) ---'
$settings = Invoke-RestMethod -Uri "$base/pc/settings" -Headers $h
$flat = @($settings | ForEach-Object { $_ })
Write-Host "settings count: $($flat.Count)"
$key = $flat | Where-Object { $_.settingKey -eq 'ANTHROPIC_API_KEY' }
if ($null -eq $key) {
  Write-Host 'ANTHROPIC_API_KEY row: NOT PRESENT'
} else {
  $val = $key.settingValue
  Write-Host ("row present; value is null: {0}; length: {1}; equals mask: {2}; all-asterisks: {3}" -f `
    ($null -eq $val), $(if ($val) { "$val".Length } else { 0 }), ($val -eq '********'), ($val -match '^\*+$'))
}

Write-Host '--- [2] PC write test with corrected glId extraction ---'
$glIds = @((Invoke-RestMethod -Uri "$base/pc/gl-codes" -Headers $h) | ForEach-Object { $_.ccId })
$glId  = @($glIds)[0]
Write-Host "glId resolved: $glId"
$pcBody = @{
  amount      = 150
  pcType      = 'TEMPORARY'
  purpose     = 'PHASE2 SMOKE TEST - safe to ignore'
  codingType  = 'GL'
  dueDate     = (Get-Date).AddDays(30).ToString('yyyy-MM-dd')
  budgetLines = @(@{ amount = 150; ccId = $glId; description = 'PHASE2 SMOKE TEST line' })
} | ConvertTo-Json -Depth 4
$r = Invoke-RestMethod -Method Post -Uri "$base/pc/pc/" -Headers $h -ContentType 'application/json' -Body $pcBody
Write-Host "created $($r.pcNumber) (id=$($r.pcId), status=$($r.status))"

Write-Host '--- [3] Reject it (terminal cleanup status) ---'
$pend = @((Invoke-RestMethod -Uri "$base/pc/approvals/pending" -Headers $h) | ForEach-Object { $_ })
$mine = $pend | Where-Object { $_.requestRef -eq $r.pcNumber }
if (-not $mine) { throw "instance for $($r.pcNumber) not pending" }
$act = @{ action = 'REJECTED'; comments = 'PHASE2 SMOKE TEST rejection - automated cleanup' } | ConvertTo-Json
$res = Invoke-RestMethod -Method Post -Uri "$base/pc/approvals/$($mine.instanceId)/action" -Headers $h -ContentType 'application/json' -Body $act
Write-Host "instance $($mine.instanceId) action=$($res.action)"
Write-Host "ARTIFACT: $($r.pcNumber) pcId=$($r.pcId) left REJECTED"
