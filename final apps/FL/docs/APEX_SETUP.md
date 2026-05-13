# APEX Setup Guide — Freelancers App 203
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-14

---

## Prerequisites

- [ ] Shared V2 framework installed (`db/v2/install.sql`)
- [ ] Petty Cash module installed (`final apps/PC/db/install.sql`) — provides `DCT_GL_CODE_COMBINATIONS`
- [ ] Freelancers module DB installed (`final apps/FL/db/01_fl_ddl.sql`, `02_fl_views.sql`, `03_fl_seed.sql`)
- [ ] App 200 (i-Finance Hub) is live and `DCT_AUTH` package is deployed
- [ ] Sequences created (`final apps/FL/app/01_sequences.sql`)

---

## Step 1 — Run Pre-Build SQL

```
sql -name prod_mcp < "final apps/FL/db/01_fl_ddl.sql"
sql -name prod_mcp < "final apps/FL/db/02_fl_views.sql"
sql -name prod_mcp < "final apps/FL/db/03_fl_seed.sql"
sql -name prod_mcp < "final apps/FL/app/01_sequences.sql"
```

---

## Step 2 — Create the Application

In APEX Builder → **App Gallery → Create**:

| Property | Value |
|---|---|
| Name | Freelancers — DCT |
| Application ID | 203 |
| Schema | PROD |
| Theme | Universal Theme (42) |
| Theme Style | Vita |
| Language | English |
| Date Format | DD-MON-YYYY |
| Timestamp Format | DD-MON-YYYY HH24:MI:SS |

---

## Step 3 — Application Definition

**Shared Components → Application Definition:**

| Setting | Value |
|---|---|
| Application Alias | FL |
| Logo | DCT Freelancers |
| Substitution: `APP_NAME` | Freelancers |
| Substitution: `APP_MODULE` | FREELANCERS |
| Substitution: `SCHEMA` | PROD |

---

## Step 4 — Authentication Scheme

Subscribe to App 200's scheme — do not create a standalone scheme.

**Shared Components → Authentication Schemes → Create:**

| Property | Value |
|---|---|
| Creation Method | Subscribe to Authentication Scheme from another Application |
| Source Application | 200 |
| Source Scheme | DCT Auth |

Set as **Current** authentication scheme.

---

## Step 5 — Application Items

**Standard items (subscribe from App 200 pattern — create identically):**

| Name | Scope | Protection |
|---|---|---|
| `APP_USER_ID` | Application | Restricted |
| `APP_EMP_NUM` | Application | Restricted |
| `APP_EMP_NAME` | Application | Unrestricted |
| `APP_ORG_ID` | Application | Restricted |
| `APP_IS_ADMIN` | Application | Restricted |
| `APP_IS_MANAGER` | Application | Restricted |
| `APP_PENDING_APPROVAL_COUNT` | Application | Unrestricted |

**Freelancers module-specific items:**

| Name | Scope | Protection |
|---|---|---|
| `APP_IS_FL_ADMIN` | Application | Restricted |
| `APP_FL_FREELANCER_ID` | Application | Restricted |

---

## Step 6 — SET_APP_ITEMS Application Process

**Shared Components → Application Processes → Create:**

| Property | Value |
|---|---|
| Name | SET_APP_ITEMS |
| Sequence | 10 |
| Process Point | On New Session |

Copy the full PL/SQL block from `final apps/FL/app/02_shared_components.sql`.

---

## Step 7 — Authorization Schemes

### Standard Schemes — Subscribe from App 200
`IS_ADMIN`, `IS_MANAGER`, `IS_MANAGER_OR_ADMIN`

### Common LOVs — Subscribe from App 200
`LOV_DCT_EMPLOYEES`, `LOV_DCT_EMPLOYEES_BY_ORG`, `LOV_DCT_ORGANIZATIONS`,
`LOV_DCT_ROLES`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_MONTHS`,
`LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`

### Freelancers Module-Specific Schemes — Create Locally

**IS_FL_ADMIN**
| Property | Value |
|---|---|
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_FL_ADMIN = 'Y';` |
| Caching | Once per session |

**IS_FL_MANAGER_OR_ADMIN**
| Property | Value |
|---|---|
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_FL_ADMIN = 'Y';` |
| Caching | Once per session |

**IS_FREELANCER**
| Property | Value |
|---|---|
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_FL_FREELANCER_ID IS NOT NULL;` |
| Caching | Once per page view |

**IS_OWN_CONTRACT**
| Property | Value |
|---|---|
| Scheme Type | PL/SQL Function Body |
| Expression | See `02_shared_components.sql` |
| Caching | Once per page view |

---

## Step 8 — Module-Specific LOVs

Create in **Shared Components → List of Values**:

| LOV Name | Query Source |
|---|---|
| `LOV_FL_NATIONALITY` | See `02_shared_components.sql` |
| `LOV_FL_FREELANCERS` | See `02_shared_components.sql` |
| `LOV_FL_BILLING_UNIT` | See `02_shared_components.sql` |
| `LOV_FL_PAYMENT_METHOD` | See `02_shared_components.sql` |
| `LOV_FL_PAY_GROUP` | See `02_shared_components.sql` |
| `LOV_FL_DOCUMENT_TYPE` | See `02_shared_components.sql` |
| `LOV_FL_BILLING_METHOD` | See `02_shared_components.sql` |
| `LOV_FL_CODING_TYPE` | See `02_shared_components.sql` |

### GL Segment LOVs — Subscribe from App 201 or App 202
`LOV_GL_ENTITY_CODE`, `LOV_GL_APPROPRIATION`, `LOV_GL_COST_CENTER`,
`LOV_GL_ENTITY_SPECIFIC`, `LOV_GL_BUDGET_GROUP_CODE`, `LOV_GL_ACCOUNT`,
`LOV_GL_IC`, `LOV_GL_FUTURE1`, `LOV_GL_FUTURE2`

---

## Step 9 — Navigation Menu

**Shared Components → Navigation Menu → Desktop Navigation Menu:**

| Seq | Label | Icon | Target | Auth Scheme |
|---|---|---|---|---|
| 10 | Home | fa-home | f?p=203:1 | IS_FL_MANAGER_OR_ADMIN |
| 20 | Freelancers | fa-user-tie | f?p=203:20 | IS_FL_ADMIN |
| 30 | Registrations | fa-user-plus | f?p=203:22 | IS_FL_MANAGER_OR_ADMIN |
| 40 | Contracts | fa-file-text-o | f?p=203:30 | IS_FL_ADMIN |
| 50 | Vouchers | fa-money | f?p=203:40 | IS_FL_ADMIN |
| 60 | Deliverables | fa-check-square-o | f?p=203:50 | IS_FL_MANAGER_OR_ADMIN |
| 70 | Document Expiry | fa-clock-o | f?p=203:60 | IS_FL_ADMIN |
| 75 | *(separator)* | — | — | IS_FL_ADMIN |
| 80 | Pending Approvals | fa-thumbs-up | f?p=203:42 | IS_FL_MANAGER_OR_ADMIN |
| 85 | *(separator)* | — | — | IS_ADMIN |
| 90 | Approval Rules | fa-sitemap | f?p=203:71 | IS_ADMIN |
| 100 | Module Settings | fa-cog | f?p=203:70 | IS_ADMIN |
| 110 | My Profile | fa-id-card-o | f?p=203:10 | IS_FREELANCER |
| 120 | My Contracts | fa-file-text-o | f?p=203:11 | IS_FREELANCER |
| 130 | My Vouchers | fa-money | f?p=203:12 | IS_FREELANCER |
| 140 | My Deliverables | fa-check-square-o | f?p=203:13 | IS_FREELANCER |
| 150 | My Documents | fa-folder-open-o | f?p=203:14 | IS_FREELANCER |

---

## Step 10 — Apply Oracle Fusion CSS

**Shared Components → User Interface Attributes → CSS → Inline:**
Copy from App 200's CSS (same Oracle Fusion theme).

---

## Step 11 — Build Pages

Build in this order:

1. **Page 9999** — Login
2. **Page 9998** — Self-Registration (public, no auth)
3. **Page 0** — Global Page (notification badge)
4. **Page 1** — Home Dashboard (admin/manager KPIs)
5. **Page 20** — All Freelancers (IR)
6. **Page 21** — Freelancer Detail (Form)
7. **Page 22** — Registration Requests (IR)
8. **Page 23** — Registration Form
9. **Page 30** — All Contracts (IR)
10. **Page 31** — Contract Form
11. **Page 32** — Contract Detail + Schedule sub-region
12. **Page 33** — Amendment Form
13. **Page 34** — Renewal Requests (IR)
14. **Page 35** — Renewal Form
15. **Page 40** — All Vouchers (IR)
16. **Page 41** — Voucher Form
17. **Page 42** — Pending Approvals (IR)
18. **Page 50** — Deliverables — Accept/Reject (IR)
19. **Page 60** — Document Expiry Dashboard (IR)
20. **Page 70** — Module Settings (IG)
21. **Page 71** — Approval Rules (Master-Detail)
22. **Page 10** — My Profile (freelancer portal)
23. **Page 11** — My Contracts (freelancer)
24. **Page 12** — My Vouchers (freelancer)
25. **Page 13** — My Deliverables (freelancer — submit)
26. **Page 14** — My Documents (freelancer)

---

## Step 12 — Test Checklist

### Registration Flow
- [ ] Public page 9998 — self-registration with photo, nationality, Emirates ID (required for AE)
- [ ] Staff submits registration on behalf → submitted_by = STAFF
- [ ] Approval: FL Manager → FL Admin → auto-creates freelancer profile + bank account

### Contract Flow
- [ ] New contract → GL/PROJECT coding, billing method selection
- [ ] On approval → payment schedule auto-generated (MONTHLY/WEEKLY/PER_COUNT)
- [ ] Billing status on contract view: NOT_PAID / PARTIALLY_PAID / FULLY_PAID

### Amendment / Direct Edit
- [ ] ALLOW_DIRECT_CONTRACT_EDIT = N → Amendment Form shown; approval required
- [ ] ALLOW_DIRECT_CONTRACT_EDIT = Y → Direct edit; version_number increments
- [ ] Validation: cannot reduce total below paid amount; start_date locked if payments exist

### Voucher Flow
- [ ] Generate from schedule row → invoice fields required if VOUCHER_REQUIRE_INVOICE = Y
- [ ] Default payment_method, pay_group, description from module settings
- [ ] Post to Fusion = Y → pushed on approval
- [ ] payment_status = PAID → schedule row status = PAID

### Deliverable Flow
- [ ] Freelancer submits deliverable on P13 with attachment
- [ ] Admin accepts on P50 → status = ACCEPTED
- [ ] VOUCHER_REQUIRE_ACCEPTED_DELIVERABLE = Y → voucher blocked without accepted deliverable

### Document Expiry
- [ ] Upload document with expiry_date → alert_days_before set from module setting
- [ ] Document Expiry Dashboard (P60) shows VALID / EXPIRING_SOON / EXPIRED badges
- [ ] BLOCK_CONTRACT_ON_EXPIRED_DOC = Y → contract submission blocked for freelancer with expired docs

### Renewal Flow
- [ ] Create renewal from P34/P35 — form pre-fills from original contract
- [ ] On approval → new contract created with renewed_from_contract_id set
- [ ] Original contract status → COMPLETED

### Self-Service Portal
- [ ] Login as freelancer (email matching DCT_FL_FREELANCERS.email)
- [ ] APP_FL_FREELANCER_ID set; IS_FREELANCER auth scheme returns TRUE
- [ ] Pages 10–14 show only own data; admin pages inaccessible

---

## Step 13 — Export Application

```sql
SELECT apex_export.get_application(
  p_application_id          => 203,
  p_split                   => FALSE,
  p_with_date               => TRUE,
  p_with_ir_public_reports  => TRUE,
  p_with_translations       => FALSE
).getclob()
FROM dual;
```

Save to `final apps/FL/app/f203.sql`.

---

## Troubleshooting

| Issue | Fix |
|---|---|
| APP_FL_FREELANCER_ID always NULL | Verify freelancer email matches APEX login username (APP_USER) |
| IS_FREELANCER always false | Check SET_APP_ITEMS process — ensure it runs On New Session |
| National ID not enforced for AE | Verify NATIONAL_ID_REQUIRED_FOR_AE = Y in module settings and PL/SQL validation on P9998/P23 |
| Payment schedule not generated | Verify AUTO_GENERATE_PAYMENT_SCHEDULE = Y and contract status = APPROVED |
| Voucher amount cap error | SUM of vouchers exceeds contract total — check remaining amount logic |
| Expiry alert not sent | Check DBMS_SCHEDULER job; verify DCT_FL_PKG.SEND_EXPIRY_ALERTS compiled |
| Renewal blocked | Verify no other DRAFT/SUBMITTED renewal exists for same contract |
