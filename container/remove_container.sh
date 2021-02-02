#!/bin/bash -x
# v1.0

set -eo pipefail
set -x

trap_err ()
{
  echo "Error on line $1 of \"remove_container.sh\"."
  exit 1
}

trap 'trap_err $LINENO' ERR

# Directory Paths
v_master_directory="/u01"
[ -n "${GCP360_ROOT_DIR}" ] && v_master_directory="${GCP360_ROOT_DIR}"

v_db_dir="${v_master_directory}/gcp360_database"
v_apache_dir="${v_master_directory}/gcp360_apache"

# Container names
v_gcp360_con_name="gcp360-tool"
v_apache_con_name="gcp360-apache"

docker images
docker ps

userdel -r gcp360 || true

rm -rf "${v_db_dir}"

docker stop ${v_gcp360_con_name} || true
docker rm ${v_gcp360_con_name} || true

rm -rf "${v_apache_dir}"

docker stop ${v_apache_con_name} || true
docker rm ${v_apache_con_name} || true

exit 0
#####