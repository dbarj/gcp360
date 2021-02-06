-- Required:
DEF gcp360_in_loader_p1   = "&&1."
UNDEF 1

COL gcp360_pre_loader_filename NEW_V gcp360_pre_loader_filename
COL gcp360_pre_loader_tab_type NEW_V gcp360_pre_loader_tab_type
COL gcp360_pre_loader_function NEW_V gcp360_pre_loader_function
COL gcp360_pre_loader_inzip    NEW_V gcp360_pre_loader_inzip

SELECT source                  gcp360_pre_loader_filename,
       in_zip                  gcp360_pre_loader_inzip,
       trim(lower(table_type)) gcp360_pre_loader_tab_type,
       decode(trim(table_type),'JSON','gcp360_fc_json_converter.sql','CSV',decode('&&gcp360_loc_skip.','','gcp360_fc_csv_converter_loc.sql','gcp360_fc_csv_converter_adb.sql'),'') gcp360_pre_loader_function
FROM   "&&gcp360_obj_jsontabs."
WHERE  table_name = '&&gcp360_in_loader_p1.';

COL gcp360_pre_loader_filename clear
COL gcp360_pre_loader_tab_type clear
COL gcp360_pre_loader_function clear
COL gcp360_pre_loader_inzip    clear

COL gcp360_skip_if_loaded NEW_V gcp360_skip_if_loaded

-- Don't load if source file not in zip or if is processed.
SELECT DECODE(COUNT(*),0,'','&&fc_skip_script.') gcp360_skip_if_loaded -- Skip if find any rows
FROM   "&&gcp360_obj_jsontabs."
WHERE  table_name = '&&gcp360_in_loader_p1.'
AND    (in_zip + in_col_csv = 0 or is_processed = 1);

-- Don't load if gcp360_pre_loader_filename is null.
SELECT DECODE('&&gcp360_pre_loader_filename.',NULL,'&&fc_skip_script.','&&gcp360_skip_if_loaded.') gcp360_skip_if_loaded FROM DUAL;

-- -- Don't load if table already loaded in this session.
-- SELECT DECODE(COUNT(*),0,'','&&fc_skip_script.') gcp360_skip_if_loaded
-- FROM   "&&gcp360_obj_metadata."
-- WHERE  source = '&&gcp360_pre_loader_filename.';

-- -- Don't load if gcp360_load_mode is OFF.
-- SELECT DECODE('&&gcp360_load_mode.','OFF','&&fc_skip_script.','') gcp360_skip_if_loaded
-- FROM   DUAL
-- WHERE  '&&gcp360_skip_if_loaded.' IS NULL;

HOS if [ -z "&&gcp360_skip_if_loaded." -a '&&gcp360_pre_loader_tab_type.' == 'json' -a '&&gcp360_pre_loader_inzip.' -eq 1 -a -z "&&gcp360_loc_skip." ]; then unzip -o -d &&moat369_sw_output_fdr. &&gcp360_json_zip. &&gcp360_pre_loader_filename.; fi

COL gcp360_skip_if_loaded clear

UPDATE "&&gcp360_obj_jsontabs."
SET    is_processed = 1
WHERE  '&&gcp360_skip_if_loaded.' IS NULL
AND    table_name = '&&gcp360_in_loader_p1.';

COMMIT;

@@&&gcp360_skip_if_loaded.&&moat369_sw_folder./gcp360_fc_prevexec_save.sql "&&gcp360_in_loader_p1."
@@&&gcp360_skip_if_loaded.&&moat369_sw_folder./&&gcp360_pre_loader_function. "&&gcp360_in_loader_p1." "&&gcp360_pre_loader_filename."

UPDATE "&&gcp360_obj_jsontabs."
SET    is_created = 1
WHERE  '&&gcp360_skip_if_loaded.' IS NULL
AND    table_name = '&&gcp360_in_loader_p1.'
AND    exists (SELECT 1
              FROM   ALL_TABLES
              where  owner = '&&gcp360_user_curschema.'
              and    table_name = '&&gcp360_in_loader_p1.');

COMMIT;

UNDEF gcp360_skip_if_loaded
UNDEF gcp360_in_loader_p1
UNDEF gcp360_pre_loader_filename
UNDEF gcp360_pre_loader_tab_type
UNDEF gcp360_pre_loader_function