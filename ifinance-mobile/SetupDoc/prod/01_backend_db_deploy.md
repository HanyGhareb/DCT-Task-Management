# prod/01 — Backend DB deploy (PROD)

Same script as dev (`db/v2/28_push_tokens.sql`), deployed to the production ADB.
Idempotent. Coordinate with the DBA and do it in a change window.

## Pre-flight
- [ ] dev/01–03 passed (push proven end-to-end on a dev build).
- [ ] Confirm you are on the **production** `prod_mcp` connection.
- [ ] Take note of current objects (so rollback is clean): none of
  `DCT_DEVICE_TOKENS`, `DCT_PUSH_OUTBOX`, `DCT_PUSH_PKG`, `TRG_DCT_NOTIF_PUSH`,
  `DCT_PUSH_SWEEP` should pre-exist on a first deploy.

## Step 1 — Deploy
Fresh SQLcl session (no prior `ALTER SESSION SET CURRENT_SCHEMA=PROD`):
```
SET ECHO ON
@c:\claude\DCT-task-management\DCT-Task-Management\db\v2\28_push_tokens.sql
EXIT;
```
```powershell
& "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe" -name prod_mcp "@c:\tmp\run_28.sql"
```
Expect `=== 28_push_tokens.sql complete ===`, zero `ORA-`.

## Step 2 — Network ACL (ADMIN, one time)
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
Security note: this grants outbound HTTP to `exp.host` only. If/when you migrate
off Expo Push to direct FCM/APNs, swap the host (`fcm.googleapis.com`,
`api.push.apple.com`) and re-point `DCT_PUSH_PKG.send_pending`.

## Step 3 — Verify (same as dev/01 Step 3) + confirm ORDS
```sql
SELECT method, uri_template
FROM   user_ords_handlers h JOIN user_ords_templates t ON h.template_id = t.id
WHERE  t.uri_template LIKE 'devices%';
```
Expect `POST devices/register` and `DELETE devices/:token`.

## Step 4 — Update the runbook
Append the deploy date + result to `ifinance-mobile/docs/deployment-notes.md`
("Deployment history").

## Rollback
Same drops as dev/01; then re-run `11_dct_ords.sql` to remove the `/devices`
handlers. The trigger drop immediately stops new outbox rows.

## Done when
- Objects VALID, sweep ENABLED, ACL granted on PROD, ORDS handlers listed.
- Next: **prod/02_eas_prod_build_submit.md**.
