-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_KMS_IMPORT_JOBS'
@@&&fc_json_loader. 'GCP_KMS_KEYRINGS'
@@&&fc_json_loader. 'GCP_KMS_KEYS_VERSIONS'
@@&&fc_json_loader. 'GCP_KMS_KEYS'
@@&&fc_json_loader. 'GCP_KMS_LOCATIONS'
-----------------------------------------

DEF title = 'Kms Import Jobs'
DEF main_table = 'GCP_KMS_IMPORT_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_KMS_IMPORT_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Kms Keyrings'
DEF main_table = 'GCP_KMS_KEYRINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_KMS_KEYRINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Kms Keys Versions'
DEF main_table = 'GCP_KMS_KEYS_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_KMS_KEYS_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Kms Keys'
DEF main_table = 'GCP_KMS_KEYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_KMS_KEYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Kms Locations'
DEF main_table = 'GCP_KMS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_KMS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------