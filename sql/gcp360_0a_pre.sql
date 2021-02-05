-- https://docs.oracle.com/en/database/oracle/oracle-database/12.2/adjsn/loading-external-json-data.html#GUID-52EFC452-5E65-4148-8070-1FA588A6E697

-- Costs Table - Updated in Aug/2018

-- Define custom gcp360 functions
DEF gcp360_collector  = '&&moat369_sw_base./sh/gcp_json_export.sh'
DEF gcp360_tables     = '&&moat369_sw_base./sh/gcp_table_json.csv'
DEF gcp360_columns    = '&&moat369_sw_base./sh/gcp_cols_json.csv'
DEF fc_json_loader    = '&&moat369_sw_folder./gcp360_fc_json_loader.sql'
DEF fc_json_metadata  = '&&moat369_sw_folder./gcp360_fc_json_metadata.sql'
DEF fc_gen_select     = '&&moat369_sw_folder./gcp360_fc_gen_select.sql'

DEF gcp360_tzcolformat = 'YYYY-MM-DD"T"HH24:MI:SS.FF6TZH:TZM'
DEF moat369_sw_desc_linesize = 150

@@&&fc_def_output_file. gcp360_log_json 'internal_json.log'
@@&&fc_seq_output_file. gcp360_log_json
@@&&fc_clean_file_name. "gcp360_log_json" "gcp360_log_json_nopath" "PATH"

@@&&fc_def_output_file. gcp360_log_csv 'internal_csv.log'
@@&&fc_seq_output_file. gcp360_log_csv
@@&&fc_clean_file_name. "gcp360_log_csv" "gcp360_log_csv_nopath" "PATH"


-- Generate JSON Outputs
SET TERM ON
PRO Getting JSON Files
PRO Please wait ...
@@&&fc_set_term_off.

-- Check gcp360_exec_mode variable
@@&&fc_def_empty_var. gcp360_exec_mode
@@&&fc_set_value_var_nvl. 'gcp360_exec_mode' '&&gcp360_exec_mode.' 'REPORT_ONLY'
@@&&fc_validate_variable. gcp360_exec_mode NOT_NULL

-- Check gcp360_load_mode variable
-- Default value: PRE_LOAD if moat369_sections is unset, otherwise ON_DEMAND
@@&&fc_def_empty_var. gcp360_load_mode
@@&&fc_set_value_var_nvl. 'gcp360_load_mode' '&&gcp360_load_mode_param.' '&&gcp360_load_mode.'
COL gcp360_load_mode NEW_V gcp360_load_mode
SELECT DECODE('&&gcp360_load_mode.',NULL,DECODE('&&moat369_sections.',NULL,'PRE_LOAD','ON_DEMAND'),'&&gcp360_load_mode.') gcp360_load_mode FROM DUAL;
COL gcp360_load_mode clear
@@&&fc_validate_variable. gcp360_load_mode NOT_NULL

-- Check gcp360_clean_on_exit variable
-- Default value: OFF if gcp360_load_mode is OFF, otherwise ON
@@&&fc_def_empty_var. gcp360_clean_on_exit
-- COL gcp360_clean_on_exit NEW_V gcp360_clean_on_exit
-- SELECT DECODE('&&gcp360_clean_on_exit.',NULL,DECODE('&&gcp360_load_mode.','OFF','OFF','ON'),'&&gcp360_clean_on_exit.') gcp360_clean_on_exit FROM DUAL;
-- COL gcp360_clean_on_exit clear
@@&&fc_set_value_var_nvl. 'gcp360_clean_on_exit' '&&gcp360_clean_on_exit.' 'OFF'
@@&&fc_validate_variable. gcp360_clean_on_exit NOT_NULL
@@&&fc_validate_variable. gcp360_clean_on_exit ON_OFF

-- Define ADB variables
@@&&fc_def_empty_var. gcp360_adb_cred
@@&&fc_def_empty_var. gcp360_adb_uri


-- Check gcp360_skip_billing variable
@@&&fc_def_empty_var. gcp360_skip_billing
@@&&fc_set_value_var_nvl. 'gcp360_skip_billing' '&&gcp360_skip_billing.' 'N'
@@&&fc_validate_variable. gcp360_skip_billing NOT_NULL
@@&&fc_validate_variable. gcp360_skip_billing Y_N

-- Check gcp360_tables_override variable. This variable will replace gcp360_tables default value.
@@&&fc_def_empty_var. gcp360_tables_override
@@&&fc_set_value_var_nvl. 'gcp360_tables' '&&gcp360_tables_override.' '&&gcp360_tables.'

SET TERM ON
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- Check gcp360_exec_mode variable
DECLARE
  V_VAR         VARCHAR2(30)  := 'gcp360_exec_mode';
  V_VAR_CONTENT VARCHAR2(500) := '&&gcp360_exec_mode.';
BEGIN
  IF V_VAR_CONTENT NOT IN ('FULL','REPORT_ONLY','LOAD_ONLY') THEN
    RAISE_APPLICATION_ERROR(-20000, 'Invalid value for ' || V_VAR || ': "' || V_VAR_CONTENT || '" in 00_config.sql. Valid values are "FULL", "REPORT_ONLY" or "LOAD_ONLY".');
  END IF;
END;
/

-- Check gcp360_load_mode variable
DECLARE
  V_VAR         VARCHAR2(30)  := 'gcp360_load_mode';
  V_VAR_CONTENT VARCHAR2(500) := '&&gcp360_load_mode.';
BEGIN
  IF V_VAR_CONTENT NOT IN ('PRE_LOAD','ON_DEMAND', 'OFF') THEN
    RAISE_APPLICATION_ERROR(-20000, 'Invalid value for ' || V_VAR || ': "' || V_VAR_CONTENT || '" in 00_config.sql. Valid values are "PRE_LOAD", "ON_DEMAND" or "OFF".');
  END IF;
END;
/

-- Check gcp360_exec_mode variable
DECLARE
  V_VAR         VARCHAR2(30)  := 'gcp360_exec_mode';
  V_VAR_CONTENT VARCHAR2(500) := '&&gcp360_exec_mode.';
BEGIN
  IF '&&gcp360_exec_mode.' = 'LOAD_ONLY' and '&&gcp360_load_mode.' in ('OFF','ON_DEMAND') THEN
    RAISE_APPLICATION_ERROR(-20000, 'Invalid combination. When gcp360_exec_mode is "LOAD_ONLY", gcp360_load_mode must be set as "PRE_LOAD". Found: "&&gcp360_load_mode."');
  END IF;
END;
/

-- Check gcp360_exec_mode variable
BEGIN
  IF ('&&gcp360_adb_cred.' IS NULL and '&&gcp360_adb_uri.' IS NOT NULL) OR
     ('&&gcp360_adb_cred.' IS NOT NULL and '&&gcp360_adb_uri.' IS NULL) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Invalid combination. When using Autonomous DB mode, both gcp360_adb_cred and gcp360_adb_uri must be defined."');
  END IF;
END;
/

-- Check Database version
BEGIN
  IF '&&is_ver_ge_12_2.' = 'N' AND '&&gcp360_load_mode.' != 'OFF' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Database must be at least 12.2 as the tool uses DBMS_JSON.' || CHR(10) ||
    'Check https://docs.oracle.com/en/database/oracle/oracle-database/12.2/newft/new-features.html#GUID-71B4582E-A6E2-425D-8D0C-A60D70F7050C');
  END IF;
END;
/

-- Check "compatible" parameter
DECLARE
  V_RESULT      VARCHAR2(30);
  V_1_DIG       NUMBER;
  V_2_DIG       NUMBER;
BEGIN
  select value into v_result from v$parameter where name='compatible';
  V_1_DIG := SUBSTR(v_result,1,instr(v_result,'.'));
  V_2_DIG := SUBSTR(v_result,instr(v_result,'.')+1,instr(v_result,'.',1,2)-instr(v_result,'.')-1);
  IF NOT (V_1_DIG>12 OR (V_1_DIG=12 AND V_2_DIG>=2))  AND '&&gcp360_load_mode.' != 'OFF' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Database compatible parameter must be at least 12.2 to run this tool (Long Identifiers).' || CHR(10) ||
   'Check https://docs.oracle.com/en/database/oracle/oracle-database/12.2/sqlrf/Database-Object-Names-and-Qualifiers.html#GUID-75337742-67FD-4EC0-985F-741C93D918DA');
  END IF;
END;
/

-- Check "max_string_size" parameter
DECLARE
  V_RESULT      VARCHAR2(30);
BEGIN
  select value into v_result from v$parameter where name='max_string_size';
  IF UPPER(V_RESULT) != 'EXTENDED' AND '&&gcp360_load_mode.' != 'OFF' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Database must have extended max_string_size parameter to work with this tool.' || CHR(10) ||
   'Check https://docs.oracle.com/database/121/REFRN/GUID-D424D23B-0933-425F-BC69-9C0E6724693C.htm#REFRN10321');
  END IF;
END;
/

-- Check UTL_FILE permission
DECLARE
  V_RESULT      NUMBER;
BEGIN
  select count(*) into V_RESULT from all_procedures where owner='SYS' and object_name='UTL_FILE';
  IF V_RESULT = 0 THEN
    RAISE_APPLICATION_ERROR(-20000, 'SYS.UTL_FILE package is not visible by current user. Check if you have execute permissions.');
  END IF;
END;
/

-- Check UTL_COMPRESS permission
DECLARE
  V_RESULT      NUMBER;
BEGIN
  select count(*) into V_RESULT from all_procedures where owner='SYS' and object_name='UTL_COMPRESS';
  IF V_RESULT = 0 THEN
    RAISE_APPLICATION_ERROR(-20000, 'SYS.UTL_COMPRESS package is not visible by current user. Check if you have execute permissions.');
  END IF;
END;
/

WHENEVER SQLERROR CONTINUE
@@&&fc_set_term_off.

----------------------------------------
-- Define Local or ADB skip variables
----------------------------------------

COL gcp360_loc_skip NEW_V gcp360_loc_skip
COL gcp360_loc_code NEW_V gcp360_loc_code
COL gcp360_adb_skip NEW_V gcp360_adb_skip
COL gcp360_adb_code NEW_V gcp360_adb_code
SELECT DECODE('&&gcp360_adb_cred.','','','&&fc_skip_script.') gcp360_loc_skip,
       DECODE('&&gcp360_adb_cred.','','&&fc_skip_script.','') gcp360_adb_skip,
       DECODE('&&gcp360_adb_cred.','','','--') gcp360_loc_code,
       DECODE('&&gcp360_adb_cred.','','--','') gcp360_adb_code
FROM DUAL;
COL gcp360_loc_skip clear
COL gcp360_loc_code clear
COL gcp360_adb_skip clear
COL gcp360_adb_code clear

@@&&gcp360_adb_skip.&&moat369_sw_folder./gcp360_fc_validate_adb.sql

-- Print execution mode

@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO SET TERM ON
PRO &&gcp360_adb_code.PRO GCP360 running for Autonomous Database mode
PRO &&gcp360_loc_code.PRO GCP360 running for Local Database mode
PRO @@&&fc_set_term_off.
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_step_file.
HOS rm -f "&&gcp360_step_file."
UNDEF gcp360_step_file

----------------------------------------
-- Load JSON list in gcp360_json_files
----------------------------------------

@@&&fc_def_empty_var. gcp360_json_zip
@@&&gcp360_loc_skip.&&moat369_sw_folder./gcp360_fc_json_extractor.sql

@@&&fc_def_output_file. gcp360_json_files 'gcp_json_export_list.txt'
@@&&fc_clean_file_name. gcp360_json_files gcp360_json_files_nopath "PATH"

-- If Local
@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_zip_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO HOS unzip -Z -1 &&gcp360_json_zip. | &&cmd_grep. -E '.json$' > &&gcp360_json_files.
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_loc_skip.&&gcp360_step_file.
@@&&fc_zip_driver_files. &&gcp360_step_file.
UNDEF gcp360_step_file

-- If ADB
@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_zip_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO @@&&fc_spool_start.
PRO SPO &&gcp360_json_files.
PRO SELECT object_name from 
PRO table(DBMS_CLOUD.LIST_OBJECTS (
PRO        credential_name      => '&&gcp360_adb_cred.',
PRO        location_uri         => '&&gcp360_adb_uri.'))
PRO WHERE REGEXP_LIKE(object_name,'.json$') OR REGEXP_LIKE(object_name,'.json.gz$')
PRO ;;
PRO SPO OFF
PRO @@&&fc_spool_end.
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_adb_skip.&&gcp360_step_file.
@@&&fc_zip_driver_files. &&gcp360_step_file.
UNDEF gcp360_step_file

----------------------------------------
-- Load CSV list in gcp360_csv_files
----------------------------------------

@@&&fc_def_empty_var. gcp360_csv_files
@@&&moat369_sw_folder./gcp360_fc_csv_extractor.sql

@@&&fc_def_output_file. gcp360_csv_files 'gcp_csv_export_list.txt'
@@&&fc_clean_file_name. gcp360_csv_files gcp360_csv_files_nopath "PATH"

-- If Local
@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_csv_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO HOS unzip -Z -1 &&gcp360_csv_report_zip. | &&cmd_grep. -E '.csv.gz$' > &&gcp360_csv_files.
PRO HOS unzip -Z -1 &&gcp360_csv_report_zip. | &&cmd_grep. -E '.csv$' >> &&gcp360_csv_files.
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_loc_skip.&&gcp360_step_file.
@@&&fc_zip_driver_files. &&gcp360_step_file.
UNDEF gcp360_step_file

-- If ADB
@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_csv_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO @@&&fc_spool_start.
PRO SPO &&gcp360_csv_files.
PRO SELECT object_name from 
PRO table(DBMS_CLOUD.LIST_OBJECTS (
PRO        credential_name      => '&&gcp360_adb_cred.',
PRO        location_uri         => '&&gcp360_adb_uri.'))
PRO WHERE REGEXP_LIKE(object_name,'.csv$') OR REGEXP_LIKE(object_name,'.csv.gz$')
PRO ;;
PRO SPO OFF
PRO @@&&fc_spool_end.
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_adb_skip.&&gcp360_step_file.
@@&&fc_zip_driver_files. &&gcp360_step_file.
UNDEF gcp360_step_file

----------------------------------------
-- Compression Flag
----------------------------------------

@@&&fc_set_value_var_nvl2. 'gcp360_tab_compression' '&&gcp360_adb_skip.' 'COMPRESS' 'COMPRESS FOR QUERY HIGH'

----------------------------------------

-- The load of those tables inside the database is no longer using External Directories.

-- @@&&fc_def_output_file. gcp360_jsoncol_file 'gcp360_jsoncol_file.csv'
-- @@&&fc_clean_file_name. gcp360_jsoncol_file gcp360_jsoncol_file_nopath "PATH"
-- HOS cp -a &&gcp360_columns. &&gcp360_jsoncol_file.

-- @@&&fc_def_output_file. gcp360_jsontab_file 'gcp360_jsontab_file.csv'
-- @@&&fc_clean_file_name. gcp360_jsontab_file gcp360_jsontab_file_nopath "PATH"
-- HOS cp -a &&gcp360_tables. &&gcp360_jsontab_file.

----------------------------------------
-- Load ALL GCP360 tool tables
----------------------------------------

@@&&moat369_sw_folder./gcp360_fc_exttables_create.sql

----------------------------------------

--
COL skip_billing_sql NEW_V skip_billing_sql
SELECT DECODE('&&gcp360_skip_billing.','N','','&&fc_skip_script.') skip_billing_sql FROM DUAL;
COL skip_billing_sql clear
--
COL skip_section_json NEW_V skip_section_json
SELECT DECODE('&&gcp360_load_mode.','OFF','&&fc_skip_script.','') skip_section_json FROM DUAL;
COL skip_section_json clear

--
COL skip_section_repusage NEW_V skip_section_repusage
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_repusage
FROM   ALL_TABLES
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_REPORTS_USAGE';
COL skip_section_repusage clear
--
COL skip_section_repcost NEW_V skip_section_repcost
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_repcost
FROM   ALL_TABLES
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_REPORTS_COST';
COL skip_section_repcost clear
--
COL skip_section_monit NEW_V skip_section_monit
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_monit
FROM   ALL_TABLES
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_MONIT_METRIC_LIST';
COL skip_section_monit clear
--
COL skip_section_audit NEW_V skip_section_audit
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_audit
FROM   ALL_TABLES
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_AUDIT_EVENTS';
COL skip_section_audit clear
--
COL skip_section_billing NEW_V skip_section_billing
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_billing
FROM   ALL_TABLES
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_SERV_ENTITLEMENTS';
COL skip_section_billing clear
--
COL skip_section_bigdata NEW_V skip_section_bigdata
SELECT DECODE(count(*),0,'&&fc_skip_script.','') skip_section_bigdata
FROM   ALL_TAB_COLUMNS
WHERE  owner = SYS_CONTEXT('userenv','current_schema')
and    table_name = 'GCP360_BDS_INSTANCES'
AND    column_name = 'ID';
COL skip_section_bigdata clear
--

----------------------------------------
-- Skip all sections if exec_mode is LOAD_ONLY.
----------------------------------------

BEGIN
  IF '&&gcp360_exec_mode.' = 'LOAD_ONLY' THEN
    :moat369_sec_from := '9z';
    :moat369_sec_to := '9z';
  END IF;
END;
/

@@&&fc_def_empty_var. gcp360_skip_reexec_secvar
@@&&fc_set_value_var_decode. 'gcp360_skip_reexec_secvar' '&&gcp360_exec_mode.' 'LOAD_ONLY' '' '&&fc_skip_script.'
@@&&gcp360_skip_reexec_secvar.&&fc_section_variables.

----------------------------