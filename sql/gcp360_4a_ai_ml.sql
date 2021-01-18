-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_AI_PLATFORM_JOBS'
@@&&fc_json_loader. 'GCP_AI_PLATFORM_MODELS'
@@&&fc_json_loader. 'GCP_AI_PLATFORM_VERSIONS'
@@&&fc_json_loader. 'GCP_ML_ENGINE_JOBS'
@@&&fc_json_loader. 'GCP_ML_ENGINE_MODELS'
@@&&fc_json_loader. 'GCP_ML_ENGINE_VERSIONS'
-----------------------------------------

DEF title = 'Ai Platform Jobs'
DEF main_table = 'GCP_AI_PLATFORM_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_AI_PLATFORM_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Ai Platform Models'
DEF main_table = 'GCP_AI_PLATFORM_MODELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_AI_PLATFORM_MODELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Ai Platform Versions'
DEF main_table = 'GCP_AI_PLATFORM_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_AI_PLATFORM_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Ml Engine Jobs'
DEF main_table = 'GCP_ML_ENGINE_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ML_ENGINE_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Ml Engine Models'
DEF main_table = 'GCP_ML_ENGINE_MODELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ML_ENGINE_MODELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Ml Engine Versions'
DEF main_table = 'GCP_ML_ENGINE_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ML_ENGINE_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------