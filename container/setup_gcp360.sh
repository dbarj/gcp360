#!/bin/bash
# v1.1
# This script will deploy and configure of GCP360 files and folders.

set -eo pipefail
set -x

trap_err ()
{
  echo "Error on line $1 of \"setup_gcp360.sh\"."
  exit 1
}

trap 'trap_err $LINENO' ERR

[ "$(id -u -n)" != "root" ] && echo "Must be executed as root! Exiting..." && exit 1

v_gcp360_home='/home/gcp360'
v_gcp360_tool='/u01/gcp360_tool'
v_gcp360_www='/u01/www'
v_gcp360_config="${v_gcp360_tool}/scripts"
v_gcp360_netadmin="${v_gcp360_config}/network"
v_gcloud_dir="/u01/.gcloud"

# v_replace_config_files = true or false.
# Keep false to reuse your configuration. True to recreate default files.
v_replace_config_files=false

v_exec_date=$(/bin/date '+%Y%m%d%H%M%S')

yum install -y oraclelinux-developer-release-el7.x86_64
yum-config-manager --enable ol7_developer

tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

yum install -y --setopt=tsflags=nodocs google-cloud-sdk jq git which

mkdir -p ${v_gcp360_www}
mkdir -p ${v_gcp360_tool}
mkdir -p ${v_gcp360_tool}/{log,out,exp}
mkdir -p ${v_gcp360_config}
mkdir -p ${v_gcp360_netadmin}

mkdir -p /var/www/
rm -f /var/www/gcp360
ln -s ${v_gcp360_www} /var/www/gcp360

[ -z "${GCP360_UID}" ] && GCP360_UID=54322
if ! $(getent passwd gcp360 > /dev/null)
then
  useradd -u ${GCP360_UID} -g users -m -d ${v_gcp360_home} gcp360
fi
chown -R gcp360: ${v_gcp360_www} ${v_gcp360_home}

ORACLE_SID=`awk -F: "/^[^#].*:/ {print \$1}" /etc/oratab`
ORACLE_HOME=`awk -F: "/^[^#].*:/ {print \$2}" /etc/oratab`

echo "export ORACLE_HOME=${ORACLE_HOME}" >> ${v_gcp360_home}/.bash_profile
echo 'export PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch' >> ${v_gcp360_home}/.bash_profile
echo "export ORACLE_SID=${ORACLE_SID}" >> ${v_gcp360_home}/.bash_profile

source ${v_gcp360_home}/.bash_profile

# Backup previous files if v_replace_config_files is true
if $v_replace_config_files
then
  if [ -f ${v_gcp360_netadmin}/tnsnames.ora ]
  then
    mv ${v_gcp360_netadmin}/tnsnames.ora ${v_gcp360_netadmin}/tnsnames.ora.${v_exec_date}
  fi
  if [ -f ${v_gcp360_netadmin}/sqlnet.ora ]
  then
    mv ${v_gcp360_netadmin}/sqlnet.ora ${v_gcp360_netadmin}/sqlnet.ora.${v_exec_date}
  fi
  if [ -f ${v_gcp360_config}/gcp360.cfg ]
  then
    mv ${v_gcp360_config}/gcp360.cfg ${v_gcp360_config}/gcp360.cfg.${v_exec_date}
  fi
fi

# Wallet files must always be recreated as GCP360 user will have a new random pass.
if [ -f ${v_gcp360_netadmin}/cwallet.sso ]
then
  mkdir -p ${v_gcp360_netadmin}/old
  mv ${v_gcp360_netadmin}/cwallet.sso ${v_gcp360_netadmin}/old/cwallet.sso.${v_exec_date}
fi

if [ -f ${v_gcp360_netadmin}/ewallet.p12 ]
then
  mkdir -p ${v_gcp360_netadmin}/old
  mv ${v_gcp360_netadmin}/ewallet.p12 ${v_gcp360_netadmin}/old/ewallet.p12.${v_exec_date}
fi

# Create wallet files.
v_wallet_pass="Oracle.123.$(openssl rand -hex 4)"
orapki wallet create -wallet ${v_gcp360_netadmin} -auto_login -pwd ${v_wallet_pass}
mkstore -wrl ${v_gcp360_netadmin} -createCredential gcp360db gcp360 oracle <<< "${v_wallet_pass}"

if ! grep -qF 'GCP360DB' ${v_gcp360_netadmin}/tnsnames.ora
then
  echo 'GCP360DB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XEPDB1)
    )
  )' >> ${v_gcp360_netadmin}/tnsnames.ora
fi

if [ ! -f ${v_gcp360_netadmin}/sqlnet.ora ]
then
  cat << EOF > ${v_gcp360_netadmin}/sqlnet.ora
WALLET_LOCATION=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=${v_gcp360_netadmin})))
SQLNET.WALLET_OVERRIDE = TRUE
EOF
fi

if [ ! -f ${v_gcp360_config}/gcp360.cfg ]
then
  echo "export TNS_ADMIN=${v_gcp360_netadmin}" > ${v_gcp360_config}/gcp360.cfg
  echo "v_conn='/@gcp360db'" >> ${v_gcp360_config}/gcp360.cfg
fi

chmod 600 ${v_gcp360_config}/gcp360.cfg

mkdir -p ${v_gcloud_dir}
chown -R gcp360: ${v_gcloud_dir}
mkdir -p ${v_gcp360_home}/.config
rm -f ${v_gcp360_home}/.config/gcloud
ln -s ${v_gcloud_dir} ${v_gcp360_home}/.config/gcloud

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

ln -sf ${v_gcp360_tool}/app/sh/gcp360_cron.sh ${v_gcp360_config}/gcp360_run.sh
ln -sf ${v_gcp360_tool}/app/sh/gcp360_db_only.sh ${v_gcp360_config}/gcp360_db_only.sh
# cp -av ${v_gcp360_tool}/app/sh/gcp360_cron.sh ${v_gcp360_config}/gcp360_run.sh

# Change GCP360 password
v_gcp360_pass="$(openssl rand -hex 6)"
bash ${v_gcp360_tool}/app/container/change_gcp360_pass.sh "${v_gcp360_pass}"
mkstore -wrl ${v_gcp360_netadmin} -modifyCredential gcp360db gcp360 ${v_gcp360_pass} <<< "${v_wallet_pass}"

if [ -f ${v_gcp360_config}/credentials ]
then
  mv ${v_gcp360_config}/credentials ${v_gcp360_config}/credentials.${v_exec_date}
fi

echo "DB Wallet Pass is: ${v_wallet_pass}" > ${v_gcp360_config}/credentials
echo "GCP360 DB Pass is: ${v_gcp360_pass}" >> ${v_gcp360_config}/credentials
echo "SYS/SYSTEM DB Pass is: $ORACLE_PWD" >> ${v_gcp360_config}/credentials

chown -R gcp360: ${v_gcp360_home}
chown -R gcp360: ${v_gcp360_tool}

chown root: ${v_gcp360_config}/credentials*
chmod 600 ${v_gcp360_config}/credentials*

chgrp dba ${v_gcp360_tool}/out/
chmod g+w ${v_gcp360_tool}/out/

ln -s ${v_gcp360_tool} ${v_gcp360_home}/gcp360_tool

yum clean all

##############