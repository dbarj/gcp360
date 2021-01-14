DEF gcp360_in_comp_func = "&&1."
UNDEF 1

DEF gcp360_comp_func_prev_table = "&&gcp360_in_comp_func._PREV"

-- PAU
-- DEF DEBUG=ON
-- @@&&fc_spool_end.

-- First check if table from prev execution exists.
COL gcp360_tab_to_count  NEW_V gcp360_tab_to_count
SELECT DECODE(COUNT(*),0,'DUAL','&&gcp360_comp_func_prev_table.') gcp360_tab_to_count
FROM   ALL_TABLES
WHERE  OWNER      = '&&gcp360_user_curschema.'
AND    TABLE_NAME = '&&gcp360_comp_func_prev_table.';
COL gcp360_tab_to_count clear

-- And if it exists, check if has any rows.
COL gcp360_skip_if_empty NEW_V gcp360_skip_if_empty
SELECT DECODE(COUNT(*),0,'&&fc_skip_script.','') gcp360_skip_if_empty
FROM   &&gcp360_tab_to_count
WHERE  '&&gcp360_tab_to_count' != 'DUAL';
COL gcp360_skip_if_empty clear

-- Define the output file for CSV result.
@@&&fc_def_output_file. gcp360_csv_file 'compare_result.csv'

-- Compare both tables and place the result in the CSV file.
@@&&gcp360_skip_if_empty.&&moat369_sw_folder./gcp360_fc_compare_tables.sql "&&gcp360_comp_func_prev_table." "&&gcp360_in_comp_func." "&&gcp360_csv_file."

-- Define the output file for HTML result.
@@&&fc_def_output_file. one_spool_html_file 'compare_result.html'

-- Convert the CSV into HTML.
HOS sh &&sh_csv_to_html_table. ',' &&gcp360_csv_file. &&one_spool_html_file.
HOS rm -f &&gcp360_csv_file.

UNDEF gcp360_csv_file

-- Add tablefilter function into the HTML.
@@&&gcp360_skip_if_empty.&&fc_add_tablefilter. &&one_spool_html_file.

DEF main_table = '&&gcp360_in_comp_func.'
DEF skip_html = '--'
DEF skip_html_file = ''
DEF one_spool_html_desc_table = 'Y'
DEF sql_show = 'N'

@@&&gcp360_skip_if_empty.&&9a_pre_one.
@@&&fc_reset_defs.

UNDEF gcp360_skip_if_empty gcp360_tab_to_count
UNDEF gcp360_in_comp_func gcp360_comp_func_prev_table

-- PAU
-- DEF DEBUG=OFF
-- @@&&fc_spool_end.
