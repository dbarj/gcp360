@@&&fc_spool_start.
SPO &&gcp360_subsec_list. APP
PRO </ol>
SPO OFF
@@&&fc_spool_end.

DEF moat369_main_report = '&&gcp360_main_report_save.'

DEF one_spool_html_file = '&&gcp360_subsec_list.'
DEF one_spool_html_file_type = 'section'

@@&&fc_def_output_file. step_file 'step_file.sql'
HOS echo "DEF row_num_dif = '"$(($(cat &&gcp360_subsec_list. | grep '</li>' | wc -l)+1))"'" > &&step_file.
@&&step_file.
HOS rm -f &&step_file.
UNDEF step_file

DEF skip_html_file = ''
DEF skip_html = '--'
@@&&9a_pre_one.

UNDEF gcp360_subsec_list gcp360_main_report_save