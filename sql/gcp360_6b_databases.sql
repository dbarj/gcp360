-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_BIGTABLE_APP_PROFILES'
@@&&fc_table_loader. 'GCP_BIGTABLE_BACKUPS'
@@&&fc_table_loader. 'GCP_BIGTABLE_CLUSTERS'
@@&&fc_table_loader. 'GCP_BIGTABLE_INSTANCES_TABLES'
@@&&fc_table_loader. 'GCP_BIGTABLE_INSTANCES'
@@&&fc_table_loader. 'GCP_DATASTORE_INDEXES'
@@&&fc_table_loader. 'GCP_FIRESTORE_INDEXES_COMPOSITE'
@@&&fc_table_loader. 'GCP_FIRESTORE_INDEXES_FIELDS'
@@&&fc_table_loader. 'GCP_SPANNER_BACKUPS'
@@&&fc_table_loader. 'GCP_SPANNER_DATABASES_SESSIONS'
@@&&fc_table_loader. 'GCP_SPANNER_DATABASES'
@@&&fc_table_loader. 'GCP_SPANNER_INSTANCE_CONFIGS'
@@&&fc_table_loader. 'GCP_SPANNER_INSTANCES'
@@&&fc_table_loader. 'GCP_SQL_BACKUPS'
@@&&fc_table_loader. 'GCP_SQL_DATABASES'
@@&&fc_table_loader. 'GCP_SQL_FLAGS'
@@&&fc_table_loader. 'GCP_SQL_INSTANCES'
@@&&fc_table_loader. 'GCP_SQL_SSL_CERTS'
@@&&fc_table_loader. 'GCP_SQL_SSL_CLIENT_CERTS'
@@&&fc_table_loader. 'GCP_SQL_TIERS'
@@&&fc_table_loader. 'GCP_SQL_USERS'
-----------------------------------------

DEF title = 'Bigtable App Profiles'
DEF main_table = 'GCP_BIGTABLE_APP_PROFILES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BIGTABLE_APP_PROFILES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Bigtable Backups'
DEF main_table = 'GCP_BIGTABLE_BACKUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BIGTABLE_BACKUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Bigtable Clusters'
DEF main_table = 'GCP_BIGTABLE_CLUSTERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BIGTABLE_CLUSTERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Bigtable Instances Tables'
DEF main_table = 'GCP_BIGTABLE_INSTANCES_TABLES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BIGTABLE_INSTANCES_TABLES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Bigtable Instances'
DEF main_table = 'GCP_BIGTABLE_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BIGTABLE_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Datastore Indexes'
DEF main_table = 'GCP_DATASTORE_INDEXES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATASTORE_INDEXES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firestore Indexes Composite'
DEF main_table = 'GCP_FIRESTORE_INDEXES_COMPOSITE'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIRESTORE_INDEXES_COMPOSITE t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firestore Indexes Fields'
DEF main_table = 'GCP_FIRESTORE_INDEXES_FIELDS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIRESTORE_INDEXES_FIELDS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Spanner Backups'
DEF main_table = 'GCP_SPANNER_BACKUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SPANNER_BACKUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Spanner Databases Sessions'
DEF main_table = 'GCP_SPANNER_DATABASES_SESSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SPANNER_DATABASES_SESSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Spanner Databases'
DEF main_table = 'GCP_SPANNER_DATABASES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SPANNER_DATABASES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Spanner Instance Configs'
DEF main_table = 'GCP_SPANNER_INSTANCE_CONFIGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SPANNER_INSTANCE_CONFIGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Spanner Instances'
DEF main_table = 'GCP_SPANNER_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SPANNER_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Backups'
DEF main_table = 'GCP_SQL_BACKUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_BACKUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Databases'
DEF main_table = 'GCP_SQL_DATABASES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_DATABASES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Flags'
DEF main_table = 'GCP_SQL_FLAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_FLAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Instances'
DEF main_table = 'GCP_SQL_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Ssl Certs'
DEF main_table = 'GCP_SQL_SSL_CERTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_SSL_CERTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Ssl Client Certs'
DEF main_table = 'GCP_SQL_SSL_CLIENT_CERTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_SSL_CLIENT_CERTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Tiers'
DEF main_table = 'GCP_SQL_TIERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_TIERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Sql Users'
DEF main_table = 'GCP_SQL_USERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SQL_USERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------