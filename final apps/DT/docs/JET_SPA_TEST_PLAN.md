# DT JET SPA — API Mode Test Plan

**App:** Duty Travel (App 204) — Oracle JET SPA  
**Mode:** Real ORDS API (`/ords/admin/dt` + `/ords/admin/dct` for auth)  
**Dev server:** `python -m http.server 8080` from `final apps/DT/Jet/`  
**Login:** `ADMIN / iFinance@2026`

---

## Pre-flight

- [ ] Server running at `http://localhost:8080`
- [ ] `config.js` has `apiBase` set (not null)
- [ ] Hard refresh (`Ctrl+Shift+R`) before starting
- [ ] Clear `ifinance_jet_session` from localStorage if stale

---

## Scenarios

### 1. Login
- [ ] Login page shows for unauthenticated user
- [ ] Quick-login buttons visible (dev mode banner shown)
- [ ] Login with `ADMIN / iFinance@2026` → redirects to Dashboard
- [ ] User avatar shows initials in header
- [ ] Dropdown shows display name and email

### 2. Dashboard
- [ ] 4 stat cards load (Active Requests, Draft Requests, Pending Settlement, Total Advance)
- [ ] Recent Travel Requests table loads (or empty state if no data)
- [ ] "New Travel Request" button visible
- [ ] Quick Actions section visible for admin/finance/approver roles

### 3. My Requests
- Navigate: sidebar → My Travel → My Requests
- [ ] Request list loads (or empty state)
- [ ] Status badges render correctly
- [ ] Clicking a row opens Request Detail

### 4. New Travel Request
- Navigate: sidebar → My Travel → New Request
- [ ] Form loads with all fields
- [ ] Fill: Travel Purpose, Mission Type (Business Mission), Trip Type (External)
- [ ] Set Departure Date and Return Date
- [ ] Add 1 destination: select a country, set from/to dates
- [ ] Per diem rate auto-calculates
- [ ] Save as Draft → navigates back to My Requests, draft appears
- [ ] Reopen draft → edit and Submit → status changes to SUBMITTED

### 5. Request Detail / Track
- Navigate: My Requests → click a submitted request
- [ ] Request details display correctly
- [ ] Approval timeline shows (Pending step)
- [ ] Documents section loads
- [ ] Status badge shows SUBMITTED

### 6. Approvals (Approver role)
- Login as a user with DT_MANAGER or DT_ADMIN role
- Navigate: sidebar → Approvals → Pending Approvals
- [ ] Submitted request appears in queue
- [ ] Click row → Review screen opens
- [ ] Click Approve → status changes to APPROVED
- [ ] Request disappears from pending queue

### 7. Disbursement Queue (Finance)
- Navigate: sidebar → Finance → Disbursement Queue
- [ ] APPROVED requests appear
- [ ] Click "Mark Advance Paid" → status changes to ADVANCE_PAID
- [ ] Row disappears from queue

### 8. Settlement (after travel)
- Navigate: My Travel → My Settlements
- [ ] List loads (or empty state)
- Navigate: My Requests → click TRAVELLED request → "Create Settlement"
- [ ] Settlement form opens pre-filled with travel dates
- [ ] Adjust actual dates, add expense lines
- [ ] Save Draft → appears in My Settlements
- [ ] Reopen and Submit → status SUBMITTED

### 9. Settlement Closure Queue
- Navigate: Finance → Settlement Closure
- [ ] Approved settlements appear
- [ ] Click Close → settlement status → CLOSED, request status → CLOSED

### 10. Per Diem Rates (Config)
- Navigate: Configuration → Per Diem Rates
- [ ] Rate table loads with rateKey, grade, daily rate, status
- [ ] Click Edit → form opens
- [ ] Change daily rate → Save → table updates

### 11. Country Groups (Config)
- Navigate: Configuration → Country Groups
- [ ] Groups list loads
- [ ] Click a group → expands to show member countries

### 12. Document Requirements (Config)
- Navigate: Configuration → Document Requirements
- [ ] Doc requirements table loads
- [ ] Filter by REQUEST/SETTLEMENT works
- [ ] Click Edit → toggle mandatory/active → Save

### 13. Module Settings (Config)
- Navigate: Configuration → Module Settings
- [ ] Settings list loads (SETTLEMENT_REQUIRED, etc.)
- [ ] Click Edit → change value → Save

### 14. Notifications
- Navigate: header bell icon
- [ ] Notifications list loads
- [ ] Mark as read works

### 15. Logout
- Click user avatar → dropdown → Logout
- [ ] Session cleared from localStorage
- [ ] Redirected to login page (mock) or Admin portal (API mode)

---

## Known API Mode Notes

- Auth uses Admin ORDS module (`/ords/admin/dct/auth/login`)
- All DT data uses DT ORDS module (`/ords/admin/dt/...`)
- `approvalService.startWorkflow` is a no-op in API mode — server handles it via `/submit` endpoints
- Submit flow: create/update as DRAFT first, then POST to `/submit` endpoint (atomically creates approval instance)
- Mock credentials (NASER.ALKHAJA etc.) only work in mock mode (`apiBase: null`)
