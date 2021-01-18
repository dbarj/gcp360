-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_FUNCTIONS_EVENT_TYPES'
@@&&fc_json_loader. 'GCP_FUNCTIONS_REGIONS'
@@&&fc_json_loader. 'GCP_FUNCTIONS'
-----------------------------------------

DEF title = 'Functions Event Types'
DEF main_table = 'GCP_FUNCTIONS_EVENT_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FUNCTIONS_EVENT_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Functions Regions'
DEF main_table = 'GCP_FUNCTIONS_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FUNCTIONS_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Functions'
DEF main_table = 'GCP_FUNCTIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FUNCTIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------