-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_DAGS'
@@&&fc_table_loader. 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_DATA'
@@&&fc_table_loader. 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_PLUGINS'
@@&&fc_table_loader. 'GCP_COMPOSER_ENVIRONMENTS'
@@&&fc_table_loader. 'GCP_DATA_CATALOG_ENTRIES'
@@&&fc_table_loader. 'GCP_DATA_CATALOG_ENTRY_GROUPS'
@@&&fc_table_loader. 'GCP_DATA_CATALOG_TAGS'
@@&&fc_table_loader. 'GCP_DATA_CATALOG_TAXONOMIES_POLICY_TAGS'
@@&&fc_table_loader. 'GCP_DATA_CATALOG_TAXONOMIES'
@@&&fc_table_loader. 'GCP_DATAFLOW_JOBS'
@@&&fc_table_loader. 'GCP_DATAPROC_AUTOSCALING_POLICIES'
@@&&fc_table_loader. 'GCP_DATAPROC_CLUSTERS'
@@&&fc_table_loader. 'GCP_DATAPROC_JOBS'
@@&&fc_table_loader. 'GCP_DATAPROC_WORKFLOW_TEMPLATES'
@@&&fc_table_loader. 'GCP_PUBSUB_LITE_SUBSCRIPTIONS'
@@&&fc_table_loader. 'GCP_PUBSUB_LITE_TOPICS'
@@&&fc_table_loader. 'GCP_PUBSUB_SNAPSHOTS'
@@&&fc_table_loader. 'GCP_PUBSUB_SUBSCRIPTIONS'
@@&&fc_table_loader. 'GCP_PUBSUB_TOPICS'
-----------------------------------------

DEF title = 'Composer Environments Storage Dags'
DEF main_table = 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_DAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPOSER_ENVIRONMENTS_STORAGE_DAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Composer Environments Storage Data'
DEF main_table = 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_DATA'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPOSER_ENVIRONMENTS_STORAGE_DATA t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Composer Environments Storage Plugins'
DEF main_table = 'GCP_COMPOSER_ENVIRONMENTS_STORAGE_PLUGINS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPOSER_ENVIRONMENTS_STORAGE_PLUGINS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Composer Environments'
DEF main_table = 'GCP_COMPOSER_ENVIRONMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPOSER_ENVIRONMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Data Catalog Entries'
DEF main_table = 'GCP_DATA_CATALOG_ENTRIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATA_CATALOG_ENTRIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Data Catalog Entry Groups'
DEF main_table = 'GCP_DATA_CATALOG_ENTRY_GROUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATA_CATALOG_ENTRY_GROUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Data Catalog Tags'
DEF main_table = 'GCP_DATA_CATALOG_TAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATA_CATALOG_TAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Data Catalog Taxonomies Policy Tags'
DEF main_table = 'GCP_DATA_CATALOG_TAXONOMIES_POLICY_TAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATA_CATALOG_TAXONOMIES_POLICY_TAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Data Catalog Taxonomies'
DEF main_table = 'GCP_DATA_CATALOG_TAXONOMIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATA_CATALOG_TAXONOMIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dataflow Jobs'
DEF main_table = 'GCP_DATAFLOW_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATAFLOW_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dataproc Autoscaling Policies'
DEF main_table = 'GCP_DATAPROC_AUTOSCALING_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATAPROC_AUTOSCALING_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dataproc Clusters'
DEF main_table = 'GCP_DATAPROC_CLUSTERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATAPROC_CLUSTERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dataproc Jobs'
DEF main_table = 'GCP_DATAPROC_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATAPROC_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dataproc Workflow Templates'
DEF main_table = 'GCP_DATAPROC_WORKFLOW_TEMPLATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DATAPROC_WORKFLOW_TEMPLATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Pubsub Lite Subscriptions'
DEF main_table = 'GCP_PUBSUB_LITE_SUBSCRIPTIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PUBSUB_LITE_SUBSCRIPTIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Pubsub Lite Topics'
DEF main_table = 'GCP_PUBSUB_LITE_TOPICS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PUBSUB_LITE_TOPICS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Pubsub Snapshots'
DEF main_table = 'GCP_PUBSUB_SNAPSHOTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PUBSUB_SNAPSHOTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Pubsub Subscriptions'
DEF main_table = 'GCP_PUBSUB_SUBSCRIPTIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PUBSUB_SUBSCRIPTIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Pubsub Topics'
DEF main_table = 'GCP_PUBSUB_TOPICS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PUBSUB_TOPICS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------