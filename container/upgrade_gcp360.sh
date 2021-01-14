#!/bin/bash
# v1.0
# This script will make the deployment and configuration of GCP360 files and folders.

# To execute the latest version of this script, execute the line below:
# bash -c "$(curl -L https://raw.githubusercontent.com/dbarj/gcp360/master/container/upgrade_gcp360.sh)"

set -eo pipefail
set -x

trap_err ()
{
  echo "Error on line $1 of \"upgrade_gcp360.sh\"."
  exit 1
}

trap 'trap_err $LINENO' ERR

[ "$(id -u -n)" != "root" ] && echo "Must be executed as root! Exiting..." && exit 1

# Directory Paths
v_master_directory="/u01"
[ -n "${GCP360_ROOT_DIR}" ] && v_master_directory="${GCP360_ROOT_DIR}"

v_gcp360_tool="${v_master_directory}/gcp360_tool"

v_exec_date=$(/bin/date '+%Y%m%d%H%M%S')

cd ${v_gcp360_tool}
git clone https://github.com/dbarj/gcp360.git
[ -d app ] && rm -rf app
mv gcp360 app

# If GCP360_BRANCH is defined, change to it.
if [ -n "${GCP360_BRANCH}" -a "${GCP360_BRANCH}" != "master" ]
then
  cd app
  git checkout ${GCP360_BRANCH}
  cd -
fi

cp -av ${v_gcp360_tool}/app/sh/gcp360_cron.sh ${v_gcp360_config}/gcp360_run.sh

chown gcp360: ${v_gcp360_config}/gcp360_run.sh
chown -R gcp360: ${v_gcp360_tool}/app/

##############