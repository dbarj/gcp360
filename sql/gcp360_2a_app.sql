-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_APP_DOMAIN_MAPPINGS'
@@&&fc_table_loader. 'GCP_APP_FIREWALL_RULES'
@@&&fc_table_loader. 'GCP_APP_INSTANCES'
@@&&fc_table_loader. 'GCP_APP_REGIONS'
@@&&fc_table_loader. 'GCP_APP_SERVICES'
@@&&fc_table_loader. 'GCP_APP_SSL_CERTIFICATES'
@@&&fc_table_loader. 'GCP_APP_VERSIONS'
-----------------------------------------

DEF title = 'App Domain Mappings'
DEF main_table = 'GCP_APP_DOMAIN_MAPPINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_DOMAIN_MAPPINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Firewall Rules'
DEF main_table = 'GCP_APP_FIREWALL_RULES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_FIREWALL_RULES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Instances'
DEF main_table = 'GCP_APP_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Regions'
DEF main_table = 'GCP_APP_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Services'
DEF main_table = 'GCP_APP_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Ssl Certificates'
DEF main_table = 'GCP_APP_SSL_CERTIFICATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_SSL_CERTIFICATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'App Versions'
DEF main_table = 'GCP_APP_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APP_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------