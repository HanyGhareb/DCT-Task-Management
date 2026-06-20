-- ===========================================================================
-- otbi-atd : 22 explicit Fusion Applications base URL on ATD_OTBI_ENV
-- The OTBI analytics host and the ERP apps UI / fscmRestApi can differ per pod.
-- Make the apps base EXPLICIT instead of deriving it from analytics_base_url.
-- The action driver (ap_invoice._apps_base) prefers this column.
-- Rerunnable. Schema-qualified PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- column (guarded for rerun)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_env ADD (fusion_apps_url VARCHAR2(400))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- default it to the analytics host (scheme://host) where not already set
UPDATE prod.atd_otbi_env
   SET fusion_apps_url =
       REGEXP_SUBSTR(analytics_base_url, '^https?://[^/]+')
 WHERE fusion_apps_url IS NULL
   AND analytics_base_url IS NOT NULL;
COMMIT;

SET ECHO OFF
PROMPT otbi-atd 22 fusion_apps_url : done
