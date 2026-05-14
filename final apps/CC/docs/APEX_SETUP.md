# APEX Setup Guide — Credit Cards App 202
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-13

---

## Prerequisites

Before building App 202, confirm the following are complete:

- [ ] Shared V2 framework installed (`db/v2/install.sql` + `db/v2/01b_dct_ddl_alterations.sql`)
- [ ] Credit Cards module installed (`final apps/CC/db/install.sql`)
- [ ] `DCT_GL_CODE_COMBINATIONS` data loaded (V2 shared table — managed via App 200)
- [ ] App 200 (i-Finance Hub) is live and `DCT_AUTH` package is deployed
- [ ] Sequences created (see `final apps/CC/app/01_sequences.sql`)
- [ ] Shared components SQL run (see `final apps/CC/app/02_shared_components.sql`)

---

## Step 1 — Run Pre-Build SQL

Run in order via SQLcl (`sqlcl -name prod_mcp`):

```
cd "final apps/CC/db"
< install.sql

cd "final apps/CC/app"
< 01_sequences.sql
< 02_shared_components.sql
```

---

## Step 2 — Create the Application

In APEX Builder → **App Gallery → Create**:

| Property | Value |
|---|---|
| Name | Credit Cards — DCT |
| Application ID | 202 |
| Schema | PROD |
| Authentication | (set in Step 4) |
| Theme | Universal Theme (42) |
| Theme Style | Vita (override with Oracle Fusion CSS in Step 9) |
| Language | English |
| Date Format | DD-MON-YYYY |
| Timestamp Format | DD-MON-YYYY HH24:MI:SS |

---

## Step 3 — Application Definition Settings

**Shared Components → Application Definition:**

| Setting | Value |
|---|---|
| Application Alias | CC |
| Logo | DCT Credit Cards |
| Error Handling | (default APEX error handling) |
| Substitution: `APP_NAME` | Credit Cards |
| Substitution: `APP_MODULE` | CREDIT_CARDS |
| Substitution: `SCHEMA` | PROD |

---

## Step 4 — Authentication Scheme

> **Shared Architecture Rule:** Subscribe to App 200's scheme — do not create a standalone scheme.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 1.

**Shared Components → Authentication Schemes → Create:**

| Property | Value |
|---|---|
| Creation Method | Subscribe to Authentication Scheme from another Application |
| Source Application | 200 |
| Source Scheme | DCT Auth |

Set as **Current** authentication scheme.

---

## Step 5 — Application Items

> **Shared Architecture Rule:** Standard items must use identical names and protection levels across all apps.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 2.

**Standard items (same in every module app):**

| Name | Scope | Session State Protection |
|---|---|---|
| `APP_USER_ID` | Application | Restricted — May not be set from browser |
| `APP_EMP_NUM` | Application | Restricted — May not be set from browser |
| `APP_EMP_NAME` | Application | Unrestricted |
| `APP_ORG_ID` | Application | Restricted — May not be set from browser |
| `APP_IS_ADMIN` | Application | Restricted — May not be set from browser |
| `APP_IS_MANAGER` | Application | Restricted — May not be set from browser |
| `APP_PENDING_APPROVAL_COUNT` | Application | Unrestricted |

**Credit Cards module-specific items (App 202 only):**

| Name | Scope | Session State Protection |
|---|---|---|
| `APP_IS_CC_ADMIN` | Application | Restricted — May not be set from browser |
| `APP_HAS_ACTIVE_CARD` | Application | Restricted — May not be set from browser |
| `APP_MY_CC_ID` | Application | Restricted — May not be set from browser |

---

## Step 6 — SET_APP_ITEMS Application Process

> **Shared Architecture Rule:** Standard block + module-specific extension.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Section 3.

**Shared Components → Application Processes → Create:**

| Property | Value |
|---|---|
| Name | SET_APP_ITEMS |
| Sequence | 10 |
| Process Point | On New Session |
| Source | See `final apps/CC/app/02_shared_components.sql` output |

Copy the full PL/SQL block from the `02_shared_components.sql` output into the Source field.

---

## Step 7 — Authorization Schemes

> **Shared Architecture Rule:** Standard schemes subscribed from App 200; module-specific schemes created locally.
> See `final apps/SHARED_APEX_ARCHITECTURE.md` Sections 4 & 6.

### Standard Schemes — Subscribe from App 200

**Shared Components → Authorization Schemes → Create → From Existing Scheme in another Application**

| Scheme Name | Source App |
|---|---|
| `IS_ADMIN` | 200 |
| `IS_MANAGER` | 200 |
| `IS_MANAGER_OR_ADMIN` | 200 |

### Common LOVs — Subscribe from App 200

**Shared Components → List of Values → Create → From Existing LOV in another Application**

Subscribe all 9 common LOVs: `LOV_DCT_EMPLOYEES`, `LOV_DCT_EMPLOYEES_BY_ORG`, `LOV_DCT_ORGANIZATIONS`, `LOV_DCT_ROLES`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_MONTHS`, `LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`

### Credit Cards Module-Specific Schemes — Create Locally

**Shared Components → Authorization Schemes → Create:**

### IS_CC_ADMIN
| Property | Value |
|---|---|
| Name | IS_CC_ADMIN |
| Scheme Type | PL/SQL Function Body (returning Boolean) |
| Expression | `RETURN :APP_IS_CC_ADMIN = 'Y';` |
| Caching | Once per session |

### IS_MANAGER_OR_ADMIN (local — uses CC_ADMIN)
| Property | Value |
|---|---|
| Name | IS_MANAGER_OR_ADMIN |
| Scheme Type | PL/SQL Function Body |
| Expression | `RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_CC_ADMIN = 'Y';` |
| Caching | Once per session |

### IS_OWN_CARD
| Property | Value |
|---|---|
| Name | IS_OWN_CARD |
| Scheme Type | PL/SQL Function Body |
| Expression | `DECLARE v NUMBER; BEGIN SELECT 1 INTO v FROM prod.dct_credit_cards WHERE cc_id = :P2_CC_ID AND holder_user_id = :APP_USER_ID; RETURN TRUE; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE; END;` |
| Caching | Once per page view |

### IS_PROXY_SUBMITTER
| Property | Value |
|---|---|
| Name | IS_PROXY_SUBMITTER |
| Scheme Type | PL/SQL Function Body |
| Expression | See `02_shared_components.sql` output for full expression |
| Caching | Once per page view |

---

## Step 8 — Navigation Menu

**Shared Components → Navigation Menu → Desktop Navigation Menu → Create Entry** (in order):

| Seq | Label | Icon | Target | Auth Scheme |
|---|---|---|---|---|
| 10 | Home | fa-home | f?p=202:1 | — |
| 20 | My Credit Card | fa-credit-card | f?p=202:2 | — |
| 30 | New Request | fa-plus-circle | f?p=202:3 | — |
| 40 | My Replenishments | fa-calendar-check-o | f?p=202:11 | — |
| 50 | Approve / Reject | fa-thumbs-up | f?p=202:6 | IS_MANAGER_OR_ADMIN |
| 55 | *(separator)* | — | — | IS_CC_ADMIN |
| 60 | All Credit Cards | fa-list | f?p=202:4 | IS_CC_ADMIN |
| 70 | All Requests | fa-list-alt | f?p=202:5 | IS_CC_ADMIN |
| 80 | All Replenishments | fa-list-ol | f?p=202:13 | IS_CC_ADMIN |
| 90 | Proxy Management | fa-users | f?p=202:14 | IS_CC_ADMIN |
| 100 | Document Requirements | fa-file-text-o | f?p=202:7 | IS_CC_ADMIN |
| 105 | *(separator)* | — | — | IS_ADMIN |
| 110 | Approval Rules | fa-sitemap | f?p=202:9 | IS_ADMIN |
| 120 | Module Settings | fa-cog | f?p=202:10 | IS_ADMIN |

---

## Step 9 — Apply Oracle Fusion CSS

**Shared Components → User Interface Attributes → CSS:**

Paste the Oracle Fusion theme CSS (same as App 200 — copy from App 200's Shared Components → User Interface Attributes → CSS → Inline).

---

## Step 10 — Build Pages

Build pages in this order:

1. **Page 9999** — Login
2. **Page 0** — Global Page (notification badge region)
3. **Page 1** — Home Dashboard
4. **Page 2** — My Credit Card (IR + card detail)
5. **Page 7** — Document Requirements (IG — build early to test required docs)
6. **Page 3** — Card Request Form
7. **Page 4** — All Credit Cards (IR)
8. **Page 5** — All Requests (IR)
9. **Page 6** — Pending Approvals (IR)
10. **Page 8** — Delegation (Form + IR)
11. **Page 11** — My Replenishments (IR)
12. **Page 12** — Replenishment Form (Form + IG lines)
13. **Page 13** — All Replenishments (IR)
14. **Page 14** — Proxy Management (IG)
15. **Page 9** — Approval Rules (Master-Detail)
16. **Page 10** — Module Settings (IG)

---

## Step 11 — GL Segment LOVs

Create 9 module-specific cascade LOVs for replenishment budget coding (same pattern as App 201):

`LOV_GL_ENTITY_CODE`, `LOV_GL_APPROPRIATION`, `LOV_GL_COST_CENTER`, `LOV_GL_ENTITY_SPECIFIC`, `LOV_GL_BUDGET_GROUP_CODE`, `LOV_GL_ACCOUNT`, `LOV_GL_IC`, `LOV_GL_FUTURE1`, `LOV_GL_FUTURE2`

Queries are in `final apps/CC/app/02_shared_components.sql` output.

In the Replenishment Form IG (Page 12), set each column's **Cascading LOV Parent Item** to the upstream segment column.

---

## Step 12 — Test Checklist

### Employee Flow
- [ ] Login as employee — see own card on Page 2 (empty if no card assigned)
- [ ] Raise New Card request → status = DRAFT, can edit and submit
- [ ] Submit New Card request → approval instance created, status = SUBMITTED
- [ ] Submit Increase Limit request → correct template fires (CC_CHANGE_APPROVAL)
- [ ] Submit Replacement with reason = LOST → replacement_reason saved

### Approval Flow
- [ ] Login as CC Admin → see pending request on Page 6
- [ ] Approve → instance advances or closes, card status updates
- [ ] Reject → request status = REJECTED, card status unchanged
- [ ] Return → request status = RETURNED, employee can edit and resubmit

### Replenishment Flow
- [ ] Employee with ACTIVE card → Page 11 shows empty list
- [ ] New Replenishment (Page 12) → set period month/year, enter header coding
- [ ] Add expense lines → coding defaults from header, can override per line
- [ ] Upload receipt on line → DCT_CC_ATTACHMENTS record with reference_id = line_id
- [ ] Lines sum validates against total_amount before submit
- [ ] Duplicate period blocked (unique constraint on cc_id + month + year)

### Proxy Flow
- [ ] CC Admin assigns proxy on Page 14
- [ ] Login as proxy user → can open Page 12 for the card they proxy
- [ ] IS_PROXY_SUBMITTER scheme returns TRUE

### Delegation Flow
- [ ] Approver delegates on Page 8 — active delegation record
- [ ] Delegate user appears in pending approvals queue

### Admin Flows
- [ ] Page 7 — add/edit/deactivate document requirements per request type
- [ ] Page 9 — Approval Rules: add step to CC_NEW_CARD_APPROVAL
- [ ] Page 10 — Module Settings: change BANK_APPROVAL_REQUIRED to N, verify bank step skips

---

## Step 13 — Export Application

After all pages are built and tested:

```sql
SELECT apex_export.get_application(
  p_application_id          => 202,
  p_split                   => FALSE,
  p_with_date               => TRUE,
  p_with_ir_public_reports  => TRUE,
  p_with_translations       => FALSE
).getclob()
FROM dual;
```

Save export to `final apps/CC/app/f202.sql`.

---

## Troubleshooting

| Issue | Fix |
|---|---|
| App items not set | Check SET_APP_ITEMS process — ensure it fires On New Session |
| IS_CC_ADMIN always false | Verify CC_ADMIN role assigned to user in DCT_USER_ROLES |
| GL cascade LOV empty | Verify DCT_GL_CODE_COMBINATIONS has data and IS_ACTIVE='Y' |
| Replenishment duplicate error | Unique constraint on (cc_id, period_month, period_year) — only one per month |
| Proxy submitter not allowed | Check DCT_CC_PROXIES: is_active='Y', start_date <= today, end_date >= today |
| Approval instance not created | Verify DCT_APPROVAL_TEMPLATES.IS_ACTIVE='Y' for CREDIT_CARDS module |
| Line sum validation error | Ensure IG saves before validation runs — use IG Save as a page process before validation |
