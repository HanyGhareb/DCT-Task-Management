# Phase 4 — FL backend smoke (PROD). Exercises the full lifecycle end-to-end;
# the records it creates are the FL UAT seed (labelled 'UAT seed').
# Creds parsed at runtime from the Admin quick-login config — never printed.
$ErrorActionPreference = 'Stop'
$ords = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin'
$auth = Get-Content "c:\claude\DCT-task-management\DCT-Task-Management\final apps\Admin\Jet\js\services\authService.js" -Raw
function PwdOf($u) { [regex]::Match($auth, "username:\s*'" + [regex]::Escape($u) + "',\s*password:\s*'([^']+)'").Groups[1].Value }
function Login($u) {
  $r = Invoke-RestMethod -Method Post -Uri "$ords/dct/auth/login" -ContentType 'application/json' `
        -Body (@{ username = $u; password = (PwdOf $u) } | ConvertTo-Json)
  @{ tok = @{ Authorization = "Bearer $($r.sessionId)" }; uid = $r.userId }
}
function J($o) { $o | ConvertTo-Json -Depth 6 }
function ErrBody($e) { try { (New-Object IO.StreamReader($e.Exception.Response.GetResponseStream())).ReadToEnd() } catch { $e.Exception.Message } }
$pass = 0; $fail = 0
function Check($name, $cond) {
  if ($cond) { $script:pass++; Write-Host "PASS  $name" } else { $script:fail++; Write-Host "FAIL  $name" }
}

$admin = Login 'ADMIN'
$fl = "$ords/fl"

# ── reference data ───────────────────────────────────────────────────────────
$lk = Invoke-RestMethod -Uri "$fl/lookups" -Headers $admin.tok
Check 'lookups: billing units + nationalities + orgs + docTypes' `
  (@($lk.billingUnits).Count -ge 3 -and @($lk.nationalities).Count -gt 10 -and @($lk.orgs).Count -gt 3 -and @($lk.docTypes).Count -gt 5)
$gl = Invoke-RestMethod -Uri "$fl/gl-codes" -Headers $admin.tok
$cc = @($gl | ForEach-Object { $_.ccId })[0]
Check "gl-codes raw array (ccId=$cc)" ($null -ne $cc)
$st = Invoke-RestMethod -Uri "$fl/settings" -Headers $admin.tok
Check 'module settings list' (@($st.items).Count -ge 15)
$ds = Invoke-RestMethod -Uri "$fl/dashboard/stats" -Headers $admin.tok
Check 'dashboard/stats keys' ($null -ne $ds.activeFreelancers)
$dc = Invoke-RestMethod -Uri "$fl/dashboard/charts" -Headers $admin.tok
Check 'dashboard/charts arrays' ($null -ne $dc.spendByOrg -and $null -ne $dc.docExpiry)

$natEG = @($lk.nationalities | Where-Object { $_.code -eq 'EG' })
$nat = if ($natEG) { 'EG' } else { @($lk.nationalities)[0].code }

# ── registration lifecycle ───────────────────────────────────────────────────
$reg = Invoke-RestMethod -Method Post -Uri "$fl/registrations/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  firstNameEn='Layla'; lastNameEn='Hassan'; firstNameAr='ليلى'; lastNameAr='حسن'
  dateOfBirth='1992-04-18'; nationalityCode=$nat
  email='layla.hassan.uat@example.com'; mobile='+971502347788'
  specialization='Content production'; notes='UAT seed registration'
})
Check "registration created ($($reg.registrationNumber))" ($reg.ok -eq $true)

# submit must fail without photo (PHOTO_REQUIRED=Y)
$code = 0
try { Invoke-RestMethod -Method Post -Uri "$fl/registrations/$($reg.registrationId)/submit" -Headers $admin.tok -ContentType 'application/json' -Body '{}' }
catch { $code = [int]$_.Exception.Response.StatusCode }
Check 'submit without photo blocked (500 w/ msg)' ($code -ge 400)

# tiny 1x1 jpeg photo
$jpeg = '/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wAARCAABAAEDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3+iiigD//2Q=='
$null = Invoke-RestMethod -Method Put -Uri "$fl/registrations/$($reg.registrationId)/photo" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ photo_data_b64 = $jpeg; mime_type='image/jpeg'; file_name='layla.jpg' })
$img = Invoke-WebRequest -Uri "$fl/registrations/$($reg.registrationId)/photo" -Headers $admin.tok -UseBasicParsing
Check 'registration photo PUT + media GET' ($img.Headers['Content-Type'] -like 'image/jpeg*')

$null = Invoke-RestMethod -Method Post -Uri "$fl/registrations/$($reg.registrationId)/submit" -Headers $admin.tok -ContentType 'application/json' -Body '{}'
$rd = Invoke-RestMethod -Uri "$fl/registrations/$($reg.registrationId)" -Headers $admin.tok
Check 'registration SUBMITTED + instance' ($rd.status -eq 'SUBMITTED' -and $rd.approvalInstanceId -gt 0)

# pending queue + 2-step approval (FL_MANAGER then FL_ADMIN; ADMIN bypasses via SYS_ADMIN)
$q = Invoke-RestMethod -Uri "$fl/approvals/pending" -Headers $admin.tok
$item = @($q.items) | Where-Object { $_.requestRef -eq $rd.registrationNumber }
Check 'registration visible in FL pending queue' ($null -ne $item)
foreach ($i in 1..2) {
  try {
    $null = Invoke-RestMethod -Method Post -Uri "$fl/approvals/$($item.instanceId)/action" -Headers $admin.tok -ContentType 'application/json' `
      -Body (J @{ action='APPROVED'; comments="UAT seed - registration approval step $i" })
  } catch { Write-Host "  step ${i}: $(ErrBody $_)" }
}
$rd2 = Invoke-RestMethod -Uri "$fl/registrations/$($reg.registrationId)" -Headers $admin.tok
Check 'registration APPROVED after 2 steps' ($rd2.status -eq 'APPROVED')

$fls = Invoke-RestMethod -Uri "$fl/freelancers/?search=layla.hassan.uat" -Headers $admin.tok
$frl = @($fls.items)[0]
Check "freelancer auto-created ($($frl.vendorNumber))" ($null -ne $frl)

# bank account
$ba = Invoke-RestMethod -Method Post -Uri "$fl/freelancers/$($frl.freelancerId)/bank-accounts" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  bankName='ADCB'; accountNumber='1234567890'; iban='AE070331234567890123456'
  accountName='Layla Mahmoud Hassan'; isPrimary='Y'; notes='UAT seed'
})
Check 'bank account created' ($ba.ok -eq $true)

# ── contract lifecycle (below 50k -> single approval step) ──────────────────
$con = Invoke-RestMethod -Method Post -Uri "$fl/contracts/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  freelancerId=$frl.freelancerId; title='UAT seed - Content Production Retainer'
  startDate='2026-06-01'; endDate='2026-11-30'; totalAmount=24000
  billingMethod='MONTHLY'; orgId=1; codingType='GL'; ccIdGl=$cc
})
Check "contract created ($($con.contractNumber))" ($con.ok -eq $true)
$null = Invoke-RestMethod -Method Post -Uri "$fl/contracts/$($con.contractId)/submit" -Headers $admin.tok -ContentType 'application/json' -Body '{}'
$q2 = Invoke-RestMethod -Uri "$fl/approvals/pending" -Headers $admin.tok
$ci = @($q2.items) | Where-Object { $_.requestRef -eq $con.contractNumber }
$null = Invoke-RestMethod -Method Post -Uri "$fl/approvals/$($ci.instanceId)/action" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ action='APPROVED'; comments='UAT seed - contract approval (under 50k threshold)' })
$cd = Invoke-RestMethod -Uri "$fl/contracts/$($con.contractId)" -Headers $admin.tok
Check 'contract ACTIVE after 1 step (<50k skips FL_ADMIN)' ($cd.status -eq 'ACTIVE')
$sch = Invoke-RestMethod -Uri "$fl/contracts/$($con.contractId)/schedule" -Headers $admin.tok
Check "payment schedule auto-generated ($(@($sch.items).Count) rows)" (@($sch.items).Count -eq 6)

# ── voucher: generate from schedule -> invoice -> submit -> approve -> paid ──
$row1 = @($sch.items)[0]
$vch = Invoke-RestMethod -Method Post -Uri "$fl/vouchers/" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ scheduleId = $row1.scheduleId })
Check "voucher generated from schedule ($($vch.voucherNumber))" ($vch.ok -eq $true)
$code = 0
try { Invoke-RestMethod -Method Post -Uri "$fl/vouchers/$($vch.voucherId)/submit" -Headers $admin.tok -ContentType 'application/json' -Body '{}' }
catch { $code = [int]$_.Exception.Response.StatusCode }
Check 'voucher submit blocked without invoice' ($code -ge 400)
$null = Invoke-RestMethod -Method Put -Uri "$fl/vouchers/$($vch.voucherId)" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ invoiceNumber='INV-UAT-001'; invoiceDate='2026-06-10' })
$null = Invoke-RestMethod -Method Post -Uri "$fl/vouchers/$($vch.voucherId)/submit" -Headers $admin.tok -ContentType 'application/json' -Body '{}'
$q3 = Invoke-RestMethod -Uri "$fl/approvals/pending" -Headers $admin.tok
$vi = @($q3.items) | Where-Object { $_.requestRef -eq $vch.voucherNumber }
$null = Invoke-RestMethod -Method Post -Uri "$fl/approvals/$($vi.instanceId)/action" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ action='APPROVED'; comments='UAT seed - voucher approval' })
$vd = Invoke-RestMethod -Uri "$fl/vouchers/$($vch.voucherId)" -Headers $admin.tok
Check 'voucher APPROVED' ($vd.status -eq 'APPROVED')
$sch2 = Invoke-RestMethod -Uri "$fl/contracts/$($con.contractId)/schedule" -Headers $admin.tok
Check 'schedule row VOUCHER_GENERATED' ((@($sch2.items) | Where-Object { $_.scheduleId -eq $row1.scheduleId }).status -eq 'VOUCHER_GENERATED')
$null = Invoke-RestMethod -Method Post -Uri "$fl/vouchers/$($vch.voucherId)/mark-paid" -Headers $admin.tok -ContentType 'application/json' `
  -Body (J @{ paymentReference='UAT-PAY-001' })
$vd2 = Invoke-RestMethod -Uri "$fl/vouchers/$($vch.voucherId)" -Headers $admin.tok
Check 'voucher PAID via mark-paid' ($vd2.paymentStatus -eq 'PAID')

# ── deliverable + amendment + renewal + profile change + document ────────────
$del = Invoke-RestMethod -Method Post -Uri "$fl/deliverables/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  contractId=$con.contractId; title='UAT seed - June content batch'; deliverableDate='2026-06-10'; quantity=4
})
$null = Invoke-RestMethod -Method Post -Uri "$fl/deliverables/$($del.deliverableId)/accept" -Headers $admin.tok -ContentType 'application/json' -Body '{}'
$dl = Invoke-RestMethod -Uri "$fl/deliverables/?contractId=$($con.contractId)" -Headers $admin.tok
Check 'deliverable created + ACCEPTED' ((@($dl.items)[0]).status -eq 'ACCEPTED')

$amd = Invoke-RestMethod -Method Post -Uri "$fl/contracts/$($con.contractId)/amendments" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  reason='UAT seed - scope increase'; newTotalAmount=30000; changeSummary='Two extra deliverables per month'
})
Check "amendment created (#$($amd.amendmentNumber)) - left DRAFT for UAT" ($amd.ok -eq $true)

$rnl = Invoke-RestMethod -Method Post -Uri "$fl/renewals/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  originalContractId=$con.contractId; newStartDate='2026-12-01'; newEndDate='2027-05-31'
  newTotalAmount=26000; reason='UAT seed - renewal for next half-year'
})
Check "renewal created ($($rnl.renewalNumber)) - left DRAFT for UAT" ($rnl.ok -eq $true)

$pcr = Invoke-RestMethod -Method Post -Uri "$fl/profile-changes/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  freelancerId=$frl.freelancerId; changeType='PHONE'; currentValue='+971502347788'
  requestedValue='+971509998800'; reason='UAT seed - new number'
})
Check 'profile change created - left DRAFT for UAT' ($pcr.ok -eq $true)

$passport = @($lk.docTypes | Where-Object { $_.code -eq 'PASSPORT' })[0]
$doc = Invoke-RestMethod -Method Post -Uri "$fl/documents/" -Headers $admin.tok -ContentType 'application/json' -Body (J @{
  freelancerId=$frl.freelancerId; docTypeId=$passport.docTypeId; documentName='passport.pdf'
  sourceType='FREELANCER'; expiryDate=(Get-Date).AddDays(25).ToString('yyyy-MM-dd'); isRequired='Y'
  notes='UAT seed - expiring soon'
})
$docs = Invoke-RestMethod -Uri "$fl/documents/?freelancerId=$($frl.freelancerId)" -Headers $admin.tok
Check 'document created + EXPIRING_SOON' ((@($docs.items)[0]).expiryStatus -eq 'EXPIRING_SOON')

# 401 without session
$code = 0
try { Invoke-RestMethod -Uri "$fl/freelancers/" } catch { $code = [int]$_.Exception.Response.StatusCode }
Check 'no session -> 401' ($code -eq 401)

Write-Host ''
Write-Host "RESULT: $pass passed, $fail failed"
if ($fail -gt 0) { exit 1 }
