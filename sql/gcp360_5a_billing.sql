-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_BILLING_BUDGETS'
-----------------------------------------

DEF title = 'Billing Budgets'
DEF main_table = 'GCP_BILLING_BUDGETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BILLING_BUDGETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------