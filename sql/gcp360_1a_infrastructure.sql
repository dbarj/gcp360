-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP360_INSTANCES'
@@&&fc_table_loader. 'GCP360_SUBNETS'
@@&&fc_table_loader. 'GCP360_VCNS'
@@&&fc_table_loader. 'GCP360_PRIVATEIPS'
@@&&fc_table_loader. 'GCP360_REMOTE_PEERING'
@@&&fc_table_loader. 'GCP360_LOCAL_PEERING'
@@&&fc_table_loader. 'GCP360_PUBLICIPS'
@@&&fc_table_loader. 'GCP360_VNIC_ATTACHS'
@@&&fc_table_loader. 'GCP360_VNICS'
@@&&fc_table_loader. 'GCP360_DRG_ATTACHS'
@@&&fc_table_loader. 'GCP360_DB_NODES'
-----------------------------------------

DEF title = 'Infrastructure Visual Design'

-- Run GCP360 webvowl function.
DEF fc_webvowl    = '&&moat369_sw_folder./gcp360_fc_webvowl.sql'
@@&&fc_webvowl.

DEF gcp360_webvowl_index_file = 'webvowl_index.html'
DEF gcp360_webvowl_index_path = '&&moat369_sw_base./&&moat369_sw_misc_fdr./&&gcp360_webvowl_index_file.'
DEF gcp360_webvowl_filename = '&&gcp360_webvowl_index_file.'
@@&&fc_seq_output_file. gcp360_webvowl_filename
@@&&fc_def_output_file. gcp360_webvowl_fpath_filename '&&gcp360_webvowl_filename.'

HOS cat &&gcp360_webvowl_index_path. > &&gcp360_webvowl_fpath_filename.
HOS zip -mj &&moat369_zip_filename. &&gcp360_webvowl_fpath_filename. >> &&moat369_log3.

@@&&fc_def_output_file. one_spool_html_file 'infra_view_&&current_time..html'

HOS echo '<iframe src="&&gcp360_webvowl_filename." height="600" width="100%"></iframe>' > &&one_spool_html_file.

DEF row_num_dif    = 2
DEF skip_html      = '--'
DEF skip_html_file = ''

@@&&9a_pre_one.

UNDEF fc_webvowl