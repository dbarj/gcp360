-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_MONITORING_DASHBOARDS'
-----------------------------------------

DEF title = 'Monitoring Dashboards'
DEF main_table = 'GCP_MONITORING_DASHBOARDS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_MONITORING_DASHBOARDS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------