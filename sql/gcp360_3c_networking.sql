-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_NETWORK_MANAGEMENT_CONNECTIVITY_TESTS'
-----------------------------------------

DEF title = 'Network Management Connectivity Tests'
DEF main_table = 'GCP_NETWORK_MANAGEMENT_CONNECTIVITY_TESTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_NETWORK_MANAGEMENT_CONNECTIVITY_TESTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------