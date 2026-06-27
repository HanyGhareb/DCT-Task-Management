-- ===========================================================================
-- General Ledger (App 210) - Layer 1 - bridge synonyms GL_SRC_* -> ATD_GL_*
-- ---------------------------------------------------------------------------
-- The GL classification layer references the Fusion-loaded base tables only
-- through these GL_SRC_* synonyms. When the base tables are later renamed
-- (ATD_GL_*_LIST -> GL_*_LIST, ATD_GL_ACCOUNTS_COMBINATIONS -> GL_ACCOUNTS_
-- COMBINATIONS) ONLY this file is re-run with the new targets - no view,
-- package or ORDS change is needed. The GL_SRC_ prefix is deliberately
-- distinct from the future GL_* table names so it never collides on rename.
--
-- RUN THIS IN ITS OWN FRESH SQLcl SESSION (must NOT follow an
-- ALTER SESSION SET CURRENT_SCHEMA = PROD, or synonyms self-reference -> ORA-01471).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM prod.gl_src_combinations    FOR prod.atd_gl_accounts_combinations;
CREATE OR REPLACE SYNONYM prod.gl_src_entity          FOR prod.atd_gl_entity_codes_list;
CREATE OR REPLACE SYNONYM prod.gl_src_cost_centers    FOR prod.atd_gl_cost_centers_list;
CREATE OR REPLACE SYNONYM prod.gl_src_account         FOR prod.atd_gl_account_list;
CREATE OR REPLACE SYNONYM prod.gl_src_appropriation   FOR prod.atd_gl_appropriation_list;
CREATE OR REPLACE SYNONYM prod.gl_src_budget_group    FOR prod.atd_gl_budget_group_list;
CREATE OR REPLACE SYNONYM prod.gl_src_entity_specific FOR prod.atd_gl_cost_entity_specific_li;
CREATE OR REPLACE SYNONYM prod.gl_src_future1         FOR prod.atd_gl_future1_list;
CREATE OR REPLACE SYNONYM prod.gl_src_future2         FOR prod.atd_gl_future2_list;
CREATE OR REPLACE SYNONYM prod.gl_src_intercompany    FOR prod.atd_gl_intercompany_list;
CREATE OR REPLACE SYNONYM prod.gl_src_program         FOR prod.atd_gl_program_list;
CREATE OR REPLACE SYNONYM prod.gl_src_balances        FOR prod.atd_gl_balances;

PROMPT GL_SRC_* bridge synonyms created.
