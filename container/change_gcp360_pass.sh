#!/bin/bash
# v1.0
# Script to change GCP360 database user password.

set -eo pipefail

trap_err ()
{
  echo "Error on line $1 of \"change_gcp360_pass.sh\"."
  exit 1
}

trap 'trap_err $LINENO' ERR

[ "$(id -u -n)" != "root" ] && echo "Must be executed as root! Exiting..." && exit 1

v_gcp360_pass="$1"

[ -z "$v_gcp360_pass" ] && echo "First parameter must be GCP360 new password." && exit 1

v_cmd=$(cat <<EOF
set -eo pipefail
. oraenv <<< "XE"

sqlplus /nolog <<EOM
whenever sqlerror exit sql.sqlcode
conn / as sysdba
alter session set container=XEPDB1;
alter user GCP360 identified by "${v_gcp360_pass}";
exit
EOM
EOF
)

su - oracle -c "bash -s" < <(echo "$v_cmd")

exit 0
##############