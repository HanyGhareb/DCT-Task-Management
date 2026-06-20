# dev/01 — Backend DB deploy (push infrastructure)

Deploys `db/v2/28_push_tokens.sql`: device-token table, push outbox, the
notification→push trigger, `DCT_PUSH_PKG`, the sweep job, and the `/dct/devices`
ORDS endpoints. **Idempotent** — safe to re-run.

> For dev/test this is the same ADB as the rest of the platform (there is one
> ADB). If you maintain a separate test instance, point SQLcl at it instead.

## Prerequisites
- SQLcl at `C:\claude\tools\sqlcl\sqlcl\bin\sql.exe`, connection alias `prod_mcp`.
- The script must run in a **fresh** SQLcl session — do **not** run it after any
  `ALTER SESSION SET CURRENT_SCHEMA = PROD` in the same session, or the ADMIN
  synonyms self-reference (ORA-01471).

## Step 1 — Run the script
Create a CRLF runner (the `@script` form hangs without a trailing `EXIT`, and a
piped file can pick up a BOM — use a runner file that `@`s the absolute path):

`c:\tmp\run_28.sql`:
```
SET ECHO ON
@c:\claude\DCT-task-management\DCT-Task-Management\db\v2\28_push_tokens.sql
EXIT;
```

Run it:
```powershell
& "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe" -name prod_mcp "@c:\tmp\run_28.sql"
```
Expect `=== 28_push_tokens.sql complete ===` and no `ORA-`/compilation errors.

## Step 2 — Grant the Expo network ACL (ONE TIME, ADMIN)
The sweep job calls `https://exp.host`. Without an ACL it cannot send and outbox
rows go to `FAILED` after 5 attempts. Run as ADMIN:
```sql
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => 'exp.host',
    ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                        principal_name => 'PROD',
                        principal_type => xs_acl.ptype_db));
END;
/
```
(This block is also section 8 of the SQL script, commented out.)

## Step 3 — Verify objects
```sql
SELECT object_name, object_type, status
FROM   all_objects
WHERE  owner = 'PROD'
  AND  object_name IN ('DCT_DEVICE_TOKENS','DCT_PUSH_OUTBOX','DCT_PUSH_PKG','TRG_DCT_NOTIF_PUSH')
ORDER  BY object_type;

SELECT job_name, enabled, state FROM all_scheduler_jobs WHERE job_name = 'DCT_PUSH_SWEEP';
```
All should be `VALID` / `ENABLED`.

## Step 4 — Smoke-test the endpoint
Get a real `sessionId` (log into the web app, or `POST /dct/auth/login`), then:
```bash
curl -X POST "https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/dct/devices/register" \
  -H "Authorization: Bearer <sessionId>" \
  -H "Content-Type: application/json" \
  -d '{"token":"ExponentPushToken[test-xxxx]","platform":"IOS","appVersion":"1.0.0"}'
```
Expect `{"ok":true}`, then:
```sql
SELECT user_id, platform, is_active FROM prod.dct_device_tokens WHERE push_token LIKE 'ExponentPushToken[test%';
```

## Rollback (dev only)
```sql
BEGIN DBMS_SCHEDULER.DROP_JOB('PROD.DCT_PUSH_SWEEP', TRUE); END;
/
DROP TRIGGER prod.trg_dct_notif_push;
DROP PACKAGE prod.dct_push_pkg;
DROP TABLE   prod.dct_push_outbox PURGE;
DROP TABLE   prod.dct_device_tokens PURGE;
-- ORDS handlers: re-run 11_dct_ords.sql to rebuild the module without /devices.
```

## Done when
- 4 objects VALID, sweep job ENABLED, ACL granted, `register` returns `{"ok":true}`.
- Next: **dev/02_eas_dev_build.md**.
