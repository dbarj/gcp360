-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_IOT_DEVICES_CONFIGS'
@@&&fc_table_loader. 'GCP_IOT_DEVICES_CREDENTIALS'
@@&&fc_table_loader. 'GCP_IOT_DEVICES_STATES'
@@&&fc_table_loader. 'GCP_IOT_DEVICES'
@@&&fc_table_loader. 'GCP_IOT_REGISTRIES_CREDENTIALS'
@@&&fc_table_loader. 'GCP_IOT_REGISTRIES'
-----------------------------------------

DEF title = 'Iot Devices Configs'
DEF main_table = 'GCP_IOT_DEVICES_CONFIGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_DEVICES_CONFIGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iot Devices Credentials'
DEF main_table = 'GCP_IOT_DEVICES_CREDENTIALS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_DEVICES_CREDENTIALS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iot Devices States'
DEF main_table = 'GCP_IOT_DEVICES_STATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_DEVICES_STATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iot Devices'
DEF main_table = 'GCP_IOT_DEVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_DEVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iot Registries Credentials'
DEF main_table = 'GCP_IOT_REGISTRIES_CREDENTIALS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_REGISTRIES_CREDENTIALS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iot Registries'
DEF main_table = 'GCP_IOT_REGISTRIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IOT_REGISTRIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------