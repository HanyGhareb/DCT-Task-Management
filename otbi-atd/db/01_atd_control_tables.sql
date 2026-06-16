-- ===========================================================================
-- otbi-atd : 01 control tables
-- Source of truth for the OTBI -> ATD automation. Both tracks (API + browser)
-- read these. Secrets are referenced by name only (credential_ref), never
-- stored here as plaintext.
-- Rerunnable. Schema-qualified to PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ---------------------------------------------------------------------------
-- Section 1 : ATD_OTBI_ENV  (source side - the OTBI / Fusion pod + account)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_otbi_env CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_otbi_env (
  env_name            VARCHAR2(60)   NOT NULL,
  description         VARCHAR2(400),
  analytics_base_url  VARCHAR2(400),               -- e.g. https://host/analytics
  xmlpserver_base_url VARCHAR2(400),               -- e.g. https://host/xmlpserver
  auth_type           VARCHAR2(20)  DEFAULT 'WSS' NOT NULL,  -- WSS|BASIC|OAUTH|SESSION
  credential_ref      VARCHAR2(200),               -- name/key in the secret store
  oauth_token_url     VARCHAR2(400),
  extract_track       VARCHAR2(10)  DEFAULT 'API' NOT NULL,  -- API|BROWSER
  wallet_ref          VARCHAR2(200),               -- optional outbound TLS wallet ref
  enabled             CHAR(1)       DEFAULT 'Y' NOT NULL,
  created_at          TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at          TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_atd_otbi_env PRIMARY KEY (env_name),
  CONSTRAINT ck_atd_env_auth  CHECK (auth_type IN ('WSS','BASIC','OAUTH','SESSION')),
  CONSTRAINT ck_atd_env_track CHECK (extract_track IN ('API','BROWSER')),
  CONSTRAINT ck_atd_env_enab  CHECK (enabled IN ('Y','N'))
);

-- ---------------------------------------------------------------------------
-- Section 2 : ATD_TARGET_DB  (load side - which database / schema receives data)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_target_db CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_target_db (
  target_name     VARCHAR2(60)  NOT NULL,
  description     VARCHAR2(400),
  db_kind         VARCHAR2(20)  DEFAULT 'LOCAL_ATP' NOT NULL,  -- LOCAL_ATP|REMOTE
  db_link         VARCHAR2(128),               -- REMOTE via DB link (Track A)
  schema_name     VARCHAR2(128),               -- target schema (default = current)
  tns_alias       VARCHAR2(128),               -- Track B connection alias
  wallet_ref      VARCHAR2(200),               -- Track B wallet ref
  credential_ref  VARCHAR2(200),               -- Track B remote DB creds
  enabled         CHAR(1)       DEFAULT 'Y' NOT NULL,
  created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_atd_target_db PRIMARY KEY (target_name),
  CONSTRAINT ck_atd_tgt_kind CHECK (db_kind IN ('LOCAL_ATP','REMOTE')),
  CONSTRAINT ck_atd_tgt_enab CHECK (enabled IN ('Y','N'))
);

-- ---------------------------------------------------------------------------
-- Section 3 : ATD_OTBI_JOBS  (the per-analysis jobs)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_otbi_jobs CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_otbi_jobs (
  job_name        VARCHAR2(80)  NOT NULL,
  env_name        VARCHAR2(60)  NOT NULL,
  target_name     VARCHAR2(60)  NOT NULL,
  source_ref      VARCHAR2(1000) NOT NULL,      -- BIP report path (API) or analysis path (browser)
  output_format   VARCHAR2(20)  DEFAULT 'csv' NOT NULL,
  params_json     CLOB,                          -- {"P_PERIOD":"2026-05", ...}
  stage_table     VARCHAR2(128) NOT NULL,
  final_table     VARCHAR2(128),
  load_mode       VARCHAR2(20)  DEFAULT 'TRUNCATE_INSERT' NOT NULL,  -- TRUNCATE_INSERT|MERGE
  key_columns     VARCHAR2(1000),               -- comma list, for MERGE
  column_map_json CLOB,                          -- {"CSV Header":"TARGET_COL", ...}
  schedule        VARCHAR2(400),                 -- DBMS_SCHEDULER calendar string
  enabled         CHAR(1)       DEFAULT 'Y' NOT NULL,
  created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_atd_otbi_jobs PRIMARY KEY (job_name),
  CONSTRAINT fk_atd_job_env    FOREIGN KEY (env_name)    REFERENCES prod.atd_otbi_env (env_name),
  CONSTRAINT fk_atd_job_target FOREIGN KEY (target_name) REFERENCES prod.atd_target_db (target_name),
  CONSTRAINT ck_atd_job_load   CHECK (load_mode IN ('TRUNCATE_INSERT','MERGE')),
  CONSTRAINT ck_atd_job_enab   CHECK (enabled IN ('Y','N')),
  CONSTRAINT ck_atd_job_pjson  CHECK (params_json IS NULL OR params_json IS JSON),
  CONSTRAINT ck_atd_job_cjson  CHECK (column_map_json IS NULL OR column_map_json IS JSON)
);

-- ---------------------------------------------------------------------------
-- Section 4 : ATD_LOAD_RUN_LOG  (run audit for both tracks)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_load_run_log CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_load_run_log (
  run_id        NUMBER GENERATED ALWAYS AS IDENTITY,
  job_name      VARCHAR2(80) NOT NULL,
  track         VARCHAR2(10),                    -- API|BROWSER
  started       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  finished      TIMESTAMP,
  status        VARCHAR2(20) DEFAULT 'RUNNING' NOT NULL,  -- RUNNING|SUCCESS|FAILED
  row_count     NUMBER,
  csv_checksum  VARCHAR2(64),
  message       CLOB,
  CONSTRAINT pk_atd_run_log PRIMARY KEY (run_id)
);

CREATE INDEX prod.ix_atd_run_log_job ON prod.atd_load_run_log (job_name, started DESC);

-- ---------------------------------------------------------------------------
-- Section 5 : EXAMPLE staging + final pair (safe to drop / replace per analysis)
-- Demonstrates the load contract; the package loads CSV columns into stage by
-- name then MERGEs into final on the job's key_columns.
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_stg_example';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
CREATE TABLE prod.atd_stg_example (
  invoice_id   VARCHAR2(60),
  amount       NUMBER,
  load_ts      TIMESTAMP DEFAULT SYSTIMESTAMP
);

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_example';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
CREATE TABLE prod.atd_example (
  invoice_id   VARCHAR2(60) PRIMARY KEY,
  amount       NUMBER,
  updated_ts   TIMESTAMP DEFAULT SYSTIMESTAMP
);

SET ECHO OFF
PROMPT otbi-atd 01 control tables : done
