-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP360_INSTANCES'
@@&&fc_json_loader. 'GCP360_VOLUMES'
@@&&fc_json_loader. 'GCP360_SECLISTS'
-----------------------------------------

DEF gcp360_func_1g = '&&moat369_sw_folder./gcp360_1g_changes_func.sql'

DEF title = 'Compute changes'
@@&&gcp360_func_1g. 'GCP360_INSTANCES'

DEF title = 'Volume changes'
@@&&gcp360_func_1g. 'GCP360_VOLUMES'

DEF title = 'Security Lists changes'
@@&&gcp360_func_1g. 'GCP360_SECLISTS'

-- DEF title = 'User changes'
-- @@&&gcp360_func_1g. 'GCP360_USERS'

-- DEF title = 'Policies changes'
-- @@&&gcp360_func_1g. 'GCP360_POLICIES'

UNDEF gcp360_func_1g