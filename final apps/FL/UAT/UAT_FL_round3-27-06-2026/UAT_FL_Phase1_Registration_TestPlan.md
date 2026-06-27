# UAT — Freelancers Phase 1 (Registration revamp) — Round 3 (27-06-2026)

Scope: AI document extraction, dual-channel registration (staff JET + public Portal,
email-OTP), requestor + line-manager capture, **line-manager-first** approval,
duplicate detection (exact block / fuzzy flag / FL-Admin override), bank capture →
account on approval.

**Pre-reqs for the live run:** (1) `AI_FEATURES_ENABLED='Y'` (FREELANCERS module
settings) for the AI cases; (2) instance SMTP configured for OTP email delivery —
otherwise read the code from `DCT_FL_REG_OTP` for testing; (3) FL dev-proxy on :8080;
(4) a DRAFT registration + a sample Passport/EID/Bank-letter image.

Status legend: P=Pass · F=Fail · B=Blocked · N/A.

| # | Area | Case | Steps | Expected | Type | Status |
|---|------|------|-------|---------|------|--------|
| 1 | AI gate | AI disabled | `AI_FEATURES_ENABLED=N`, POST `…/extract` | HTTP 400 "AI document extraction is disabled" | Error | |
| 2 | AI extract | Passport | Enable AI, upload passport, AI Extract | Fields (passport no, DOB, names) returned + confidence; review modal | Happy | |
| 3 | AI extract | Emirates ID | Upload EID, AI Extract | `emirates_id`, DOB extracted; EID Luhn warning if invalid | Happy | |
| 4 | AI extract | Bank letter | Upload bank letter, AI Extract | IBAN/bank/holder extracted; IBAN mod-97 warning if invalid | Happy | |
| 5 | AI extract | Apply to form | In modal untick one field, Apply | Only ticked fields copied into the form; never overwrites silently | Edge | |
| 6 | AI extract | Cross-doc name mismatch | Extract two docs with different names | Warning "Name differs from the … document" | Edge | |
| 7 | AI extract | Auto-expiry | Extract passport with expiry | `DCT_DOCUMENTS.expiry_date` set for that doc | Happy | |
| 8 | AI extract | Oversize (>20MB) | Extract a huge file | HTTP 413 | Boundary | |
| 9 | Dedup | Exact EID block | Two regs same Emirates ID, submit 2nd | Submit blocked (-20001), dup banner shown | Error | |
| 10 | Dedup | Exact email block | Reg email = existing freelancer email, submit | Blocked; banner lists the match (matchedOn=Email) | Error | |
| 11 | Dedup | Fuzzy flag | Same name+DOB, different IDs, submit | Allowed; `dup_status=REVIEW`, banner shows "Similar" | Edge | |
| 12 | Dedup | FL-Admin override | On a blocked exact, FL_ADMIN clicks Override, resubmit | `dup_status=OVERRIDDEN`; submit succeeds | Happy | |
| 13 | Dedup | Non-admin override | Non-FL_ADMIN POST override | HTTP 403 | Error | |
| 14 | Line mgr | Required to submit | Submit with no line-manager email | Blocked "line manager email is required" (-20140) | Error | |
| 15 | Line mgr | Unknown email | Line-manager email not a DCT user, submit | Blocked (-20141) | Error | |
| 16 | Line mgr | Resolve hint | Enter valid LM email, blur | "✓ <name>" hint shown | Happy | |
| 17 | Approval | LM is step 1 | Submit; check approval instance | current step = USER_SPECIFIC "Line Manager Endorsement"; `dynamic_approver_user_id` = LM | Happy | |
| 18 | Approval | LM sees inbox item | Login as LM, open approvals | The registration appears in pending | Happy | |
| 19 | Approval | Chain order | LM approves → FL_MANAGER → FL_ADMIN | Moves through each step; final approval fires | Happy | |
| 20 | Approval | Final → master row | FL_ADMIN approves | `DCT_FL_FREELANCERS` row + primary bank account created; docs re-pointed; status APPROVED | Happy | |
| 21 | OTP | Start | POST `reg/public/start {email}` | 200; PENDING row in `DCT_FL_REG_OTP`, code emailed | Happy | |
| 22 | OTP | Verify OK | POST `verify` with correct code | 200 + `intakeToken` | Happy | |
| 23 | OTP | Wrong code | verify wrong code | 400; attempts++ | Error | |
| 24 | OTP | Max attempts | Exceed `REG_OTP_MAX_ATTEMPTS` | status LOCKED, 400 | Boundary | |
| 25 | OTP | Expired | verify after `REG_OTP_EXPIRY_MIN` | 400 "No valid verification code" | Boundary | |
| 26 | OTP | Rate limit | >3 starts in 10 min | 400 "Too many verification requests" | Boundary | |
| 27 | Public | Create draft | PUT `reg/public/:token` with name/DOB/nationality | Draft created, `submitted_by=SELF`, `email_verified=Y` | Happy | |
| 28 | Public | Missing required | PUT without name/DOB/nationality | 400 | Error | |
| 29 | Public | Doc upload | POST docs (docTypeCode) + PUT file | Doc stored under the reg | Happy | |
| 30 | Public | AI extract | POST `…/extract` as applicant | Fields returned (gated by AI setting) | Happy | |
| 31 | Public | Submit | POST `reg/public/:token/submit` | Submitted; line-manager-first instance created | Happy | |
| 32 | Public | Gate off | Both `FEATURE_FL_PORTAL` and `ALLOW_SELF_REGISTRATION`=N, start | 403 | Error | |
| 33 | Bank | On approval | Reg has IBAN; approve | Primary `DCT_FL_BANK_ACCOUNTS` row created from reg bank fields | Happy | |
| 34 | i18n | Arabic labels | Switch lookups/portal to AR | Arabic renders correctly (no mojibake) | Happy | |
| 35 | Regression | Existing FL flows | Contracts/vouchers/approvals unaffected | All module approvals still route by role | Regression | |

**Automated smoke already executed (2026-06-27, PROD):** #1 (AI gate→400), #9/#10 dedup
detection (`find_duplicates` returned exact email match), #21/#25-shape (OTP create +
future expiry), dedup JSON well-formed. All FL/AI DB objects VALID.

**Remaining = live UI/E2E** (Playwright via `webapp-testing`, model on
`assessment-3/phase4/tests/uat_run_fl.py`) once the two ops pre-reqs are in place; emit
the dated workbook + Word results + `evidence_*` into this round folder per the Admin UAT
convention.
