-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_GAME_LOCATIONS'
@@&&fc_json_loader. 'GCP_GAME_SERVERS_CLUSTERS'
@@&&fc_json_loader. 'GCP_GAME_SERVERS_CONFIGS'
@@&&fc_json_loader. 'GCP_GAME_SERVERS_DEPLOYMENTS'
@@&&fc_json_loader. 'GCP_GAME_SERVERS_REALMS'
@@&&fc_json_loader. 'GCP_HEALTHCARE_DATASETS'
@@&&fc_json_loader. 'GCP_HEALTHCARE_DICOM_STORES'
@@&&fc_json_loader. 'GCP_HEALTHCARE_FHIR_STORES'
@@&&fc_json_loader. 'GCP_HEALTHCARE_HL7V2_STORES'
-----------------------------------------

DEF title = 'Game Locations'
DEF main_table = 'GCP_GAME_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_GAME_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Game Servers Clusters'
DEF main_table = 'GCP_GAME_SERVERS_CLUSTERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_GAME_SERVERS_CLUSTERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Game Servers Configs'
DEF main_table = 'GCP_GAME_SERVERS_CONFIGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_GAME_SERVERS_CONFIGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Game Servers Deployments'
DEF main_table = 'GCP_GAME_SERVERS_DEPLOYMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_GAME_SERVERS_DEPLOYMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Game Servers Realms'
DEF main_table = 'GCP_GAME_SERVERS_REALMS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_GAME_SERVERS_REALMS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Healthcare Datasets'
DEF main_table = 'GCP_HEALTHCARE_DATASETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_HEALTHCARE_DATASETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Healthcare Dicom Stores'
DEF main_table = 'GCP_HEALTHCARE_DICOM_STORES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_HEALTHCARE_DICOM_STORES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Healthcare Fhir Stores'
DEF main_table = 'GCP_HEALTHCARE_FHIR_STORES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_HEALTHCARE_FHIR_STORES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Healthcare Hl7V2 Stores'
DEF main_table = 'GCP_HEALTHCARE_HL7V2_STORES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_HEALTHCARE_HL7V2_STORES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------