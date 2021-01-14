-- Remove JSON files

---- Clean external table objects
@@&&moat369_sw_folder./gcp360_fc_exttables_drop.sql
--

-- If Local
@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_zip_file.sql'
@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO HOS cat "&&gcp360_json_files." | xargs -i rm -f &&moat369_sw_output_fdr./{}
SPO OFF
@@&&fc_spool_end.
@@&&gcp360_loc_skip.&&gcp360_step_file.
@@&&fc_zip_driver_files. &&gcp360_step_file.
UNDEF gcp360_step_file
--

HOS zip -mj &&moat369_zip_filename. &&gcp360_log_json. >> &&moat369_log3.
UNDEF gcp360_log_json

HOS zip -mj &&moat369_zip_filename. &&gcp360_log_csv.  >> &&moat369_log3.
UNDEF gcp360_log_csv

--
@@&&fc_zip_driver_files. &&gcp360_json_files. 
@@&&fc_zip_driver_files. &&gcp360_csv_files. 
--HOS rm -f &&gcp360_jsoncol_file.
--HOS rm -f &&gcp360_jsontab_file.

-- Undef variables
UNDEF gcp360_collector
UNDEF gcp360_tables
UNDEF fc_json_loader
UNDEF fc_json_metadata
UNDEF gcp360_tzcolformat
UNDEF skip_billing_sql

-- Undef config variables
UNDEF gcp360_exec_mode
UNDEF gcp360_load_mode
UNDEF gcp360_clean_on_exit
UNDEF gcp360_skip_billing

-- Undef other variables
UNDEF gcp360_json_zip
UNDEF gcp360_json_files
UNDEF gcp360_json_files_nopath
UNDEF gcp360_csv_report_zip
UNDEF gcp360_csv_files
UNDEF gcp360_csv_files_nopath

-- UNDEF gcp360_jsoncol_file
-- UNDEF gcp360_jsoncol_file_nopath
-- UNDEF gcp360_jsontab_file
-- UNDEF gcp360_jsontab_file_nopath