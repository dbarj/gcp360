DEF gcp360_6a_json_prefix = "gcp_dns_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------
DEF gcp360_6a_json_prefix = "gcp_email_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------
DEF gcp360_6a_json_prefix = "gcp_search_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------
DEF gcp360_6a_json_prefix = "gcp_limits_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------
DEF gcp360_6a_json_prefix = "gcp_audit_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------
DEF gcp360_6a_json_prefix = "gcp_monit_"
-----------------------------------------
@@&&fc_def_output_file. step_meta_pre_loader 'step_meta_pre_loader.sql'
HOS &&cmd_awk. -F',' '$1 ~ /^&&gcp360_6a_json_prefix./ { print "@@&&fc_json_metadata. \""$3"\" \""$1"\""; }' &&gcp360_tables. > &&step_meta_pre_loader.
@@&&step_meta_pre_loader.
@@&&fc_zip_driver_files. &&step_meta_pre_loader.
UNDEF step_meta_pre_loader
-----------------------------------------