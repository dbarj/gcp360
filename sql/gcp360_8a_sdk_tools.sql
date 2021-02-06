-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_COMPONENTS_REPOSITORIES'
@@&&fc_table_loader. 'GCP_COMPONENTS'
@@&&fc_table_loader. 'GCP_CONFIG_CONFIGURATIONS'
@@&&fc_table_loader. 'GCP_CONFIG'
@@&&fc_table_loader. 'GCP_SOURCE_REPOS'
-----------------------------------------

DEF title = 'Components Repositories'
DEF main_table = 'GCP_COMPONENTS_REPOSITORIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPONENTS_REPOSITORIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Components'
DEF main_table = 'GCP_COMPONENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPONENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Config Configurations'
DEF main_table = 'GCP_CONFIG_CONFIGURATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONFIG_CONFIGURATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Config'
DEF main_table = 'GCP_CONFIG'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONFIG t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Source Repos'
DEF main_table = 'GCP_SOURCE_REPOS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SOURCE_REPOS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------