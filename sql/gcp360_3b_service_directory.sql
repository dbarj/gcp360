-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_SERVICE_DIRECTORY_ENDPOINTS'
@@&&fc_table_loader. 'GCP_SERVICE_DIRECTORY_LOCATIONS'
@@&&fc_table_loader. 'GCP_SERVICE_DIRECTORY_NAMESPACES'
@@&&fc_table_loader. 'GCP_SERVICE_DIRECTORY_SERVICES'
-----------------------------------------

DEF title = 'Service Directory Endpoints'
DEF main_table = 'GCP_SERVICE_DIRECTORY_ENDPOINTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICE_DIRECTORY_ENDPOINTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Service Directory Locations'
DEF main_table = 'GCP_SERVICE_DIRECTORY_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICE_DIRECTORY_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Service Directory Namespaces'
DEF main_table = 'GCP_SERVICE_DIRECTORY_NAMESPACES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICE_DIRECTORY_NAMESPACES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Service Directory Services'
DEF main_table = 'GCP_SERVICE_DIRECTORY_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICE_DIRECTORY_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------