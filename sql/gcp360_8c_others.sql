-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_EVENTARC_TRIGGERS'
@@&&fc_table_loader. 'GCP_WORKSPACE_ADD_ONS_DEPLOYMENTS'
-----------------------------------------

DEF title = 'Eventarc Triggers'
DEF main_table = 'GCP_EVENTARC_TRIGGERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_EVENTARC_TRIGGERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Workspace Add Ons Deployments'
DEF main_table = 'GCP_WORKSPACE_ADD_ONS_DEPLOYMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_WORKSPACE_ADD_ONS_DEPLOYMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------
