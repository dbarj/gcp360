#!/bin/sh
#
# ----------------------------------------------------------------------------
# Written by Rodrigo Jorge <http://www.dbarj.com.br/>
# ----------------------------------------------------------------------------
#
# This is a crontab script that will run the full GCP360 stack every X min.
# For more information how to deploy this, check:
#
# https://github.com/dbarj/gcp360/wiki/Install-GCP360
#
# ----------------------------------------------------------------------------
# v1.01
# ----------------------------------------------------------------------------
set -eo pipefail

# Directories

v_thisdir="$(dirname "$(readlink -f "$0")")"
v_basedir="$(readlink -f "$v_thisdir/../")"   # Folder of GCP360 Tool
v_confdir=$v_basedir/scripts                  # Folder of this script

if [ -n "$1" ]
then
  v_param1="$1"
  v_param1_lower=$(tr '[:upper:]' '[:lower:]' <<< "$v_param1")
  v_config_file=${v_param1_lower}.cfg
else
  v_config_file="gcp360.cfg"
fi

v_config_file="${v_confdir}/${v_config_file}"

GCP360_DB_STEP=5

if [ -f ${v_config_file} ]
then
  sed -i '/GCP360_LAST_EXEC_STEP=/d' ${v_config_file}
  echo "GCP360_LAST_EXEC_STEP=${GCP360_DB_STEP}" >> ${v_config_file}
fi

bash "${v_confdir}/gcp360_run.sh" "$@"