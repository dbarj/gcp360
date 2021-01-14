--------------------------
-- Check gcp360_adb_uri --
--------------------------

@@&&fc_def_output_file. gcp360_step_file 'gcp360_step_file.sql'
HOS touch "&&gcp360_step_file."

@@&&fc_set_term_off.

COL gcp360_adb_uri NEW_V gcp360_adb_uri
SELECT TRIM('/' FROM '&&gcp360_adb_uri.') || '/' gcp360_adb_uri FROM DUAL;
COL gcp360_adb_uri clear

DEF gcp360_adb_uri_pattern = 'https://objectstorage.[^.]*.oraclecloud.com/n/[^/]*/b/[^/]*/o/'

DEF gcp360_check = 0
COL gcp360_check NEW_V gcp360_check
SELECT count(*) gcp360_check
from DUAL
WHERE REGEXP_LIKE ('&&gcp360_adb_uri.','&&gcp360_adb_uri_pattern.');
COL gcp360_check clear

HOS if [ &&gcp360_check. -eq 0 ]; then printf 'PRO\nPRO Variable gcp360_adb_uri is with wrong pattern. It should be "https://objectstorage.REGION.oraclecloud.com/n/NAMESPACE/b/BUCKET/o/".\nHOS rm -f original_settings.sql "&&gcp360_step_file."\nEXIT 1' > &&gcp360_step_file.; fi

SET TERM ON

@@&&gcp360_step_file.
@@&&fc_set_term_off.

---------------------------
-- Check gcp360_adb_cred --
---------------------------

DEF gcp360_check = 0
COL gcp360_check NEW_V gcp360_check
SELECT count(*) gcp360_check
from all_credentials
WHERE CREDENTIAL_NAME = '&&gcp360_adb_cred.';
COL gcp360_check clear

HOS if [ &&gcp360_check. -eq 0 ]; then printf 'PRO\nPRO Could not find the credential gcp360_adb_cred: "&&gcp360_adb_cred.".\nHOS rm -f original_settings.sql "&&gcp360_step_file."\nEXIT 1' > &&gcp360_step_file.; fi

SET TERM ON

@@&&gcp360_step_file.
@@&&fc_set_term_off.

---------------------------
-- Check DBMS_CLOUD.LIST --
---------------------------

@@&&fc_def_output_file. gcp360_step_out 'gcp360_step_out.sql'

@@&&fc_spool_start.
SPO &&gcp360_step_file.
PRO @@&&fc_spool_start.
PRO SET ECHO OFF FEED ON VER ON HEAD ON SERVEROUT ON
PRO SPO &&gcp360_step_out.
PRO SELECT count(*) from 
PRO table(DBMS_CLOUD.LIST_OBJECTS (
PRO        credential_name      => '&&gcp360_adb_cred.',
PRO        location_uri         => '&&gcp360_adb_uri.'))
PRO ;;
PRO SPO OFF
PRO @@&&fc_spool_end.
SPO OFF
@@&&fc_spool_end.

@@&&gcp360_step_file.

HOS if [ $(cat "&&gcp360_step_out." | grep 'ORA-' | wc -l) -ge 1 ]; then printf 'PRO\nPRO Error when running DBMS_CLOUD.LIST_OBJECTS...\nPRO Check the credential permissions and the URL.\nPRO\nHOS cat "&&gcp360_step_out."\nHOS rm -f original_settings.sql "&&gcp360_step_file." "&&gcp360_step_out."\nEXIT 1' > &&gcp360_step_file.; fi
SET TERM ON

@@&&gcp360_step_file.
@@&&fc_set_term_off.

HOS rm -f &&gcp360_step_file.
HOS rm -f &&gcp360_step_out.

UNDEF gcp360_step_file gcp360_step_out