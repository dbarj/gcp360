-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_RUN_CONFIGURATIONS'
@@&&fc_table_loader. 'GCP_RUN_DOMAIN_MAPPINGS'
@@&&fc_table_loader. 'GCP_RUN_REGIONS'
@@&&fc_table_loader. 'GCP_RUN_REVISIONS'
@@&&fc_table_loader. 'GCP_RUN_ROUTES'
@@&&fc_table_loader. 'GCP_RUN_SERVICES'
-----------------------------------------

DEF title = 'Run Configurations'
DEF main_table = 'GCP_RUN_CONFIGURATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_CONFIGURATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Run Domain Mappings'
DEF main_table = 'GCP_RUN_DOMAIN_MAPPINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_DOMAIN_MAPPINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Run Regions'
DEF main_table = 'GCP_RUN_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Run Revisions'
DEF main_table = 'GCP_RUN_REVISIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_REVISIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Run Routes'
DEF main_table = 'GCP_RUN_ROUTES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_ROUTES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Run Services'
DEF main_table = 'GCP_RUN_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RUN_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------