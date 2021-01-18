-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_FILESTORE_INSTANCES'
@@&&fc_json_loader. 'GCP_FILESTORE_LOCATIONS'
@@&&fc_json_loader. 'GCP_FILESTORE_REGIONS'
@@&&fc_json_loader. 'GCP_FILESTORE_ZONES'
@@&&fc_json_loader. 'GCP_REDIS_INSTANCES'
@@&&fc_json_loader. 'GCP_REDIS_REGIONS'
@@&&fc_json_loader. 'GCP_REDIS_ZONES'
-----------------------------------------

DEF title = 'Filestore Instances'
DEF main_table = 'GCP_FILESTORE_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FILESTORE_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Filestore Locations'
DEF main_table = 'GCP_FILESTORE_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FILESTORE_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Filestore Regions'
DEF main_table = 'GCP_FILESTORE_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FILESTORE_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Filestore Zones'
DEF main_table = 'GCP_FILESTORE_ZONES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FILESTORE_ZONES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Redis Instances'
DEF main_table = 'GCP_REDIS_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_REDIS_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Redis Regions'
DEF main_table = 'GCP_REDIS_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_REDIS_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Redis Zones'
DEF main_table = 'GCP_REDIS_ZONES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_REDIS_ZONES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------