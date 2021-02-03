#!/bin/bash -x
# v1.2

######################################################
#
# This script will create 2 containers:
# 1 - GCP360 engine with Oracle Database.
# 2 - Apache Webserver to expose gcp360 output.
#
# To execute the latest stable version of this script, run the line below:
# bash -c "$(curl -L https://raw.githubusercontent.com/dbarj/gcp360/v1.01/container/setup_container.sh)"
#
######################################################

set -eo pipefail
set -x

trap_err ()
{
  echo "Error on line $1 of \"setup_container.sh\"."
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

# Don't change unless asked.
v_git_branch="v1.01"
v_gcp360_uid=55555
v_git_oracle_commit_hash="4f064778150234ee2be2a1176b026c5e875965ac"

# DB Version
# v_db_version="18.4.0"
# v_db_version_param="${v_db_version} -x"
# v_db_version_container="${v_db_version}-xe"
v_db_version="19.3.0"
v_db_version_param="${v_db_version} -e"
v_db_version_container="${v_db_version}-ee"
v_db_version_file="LINUX.X64_193000_db_home.zip"

# Check if root
[ "$(id -u -n)" != "root" ] && echo "Must be executed as root! Exiting..." && exit 1

# Check Linux server release.
v_major_version=$(rpm -q --queryformat '%{RELEASE}' rpm | grep -o [[:digit:]]*\$)

if [ $v_major_version -lt 7 ]
then
  set +x
  echo "Linux 6 or lower does not support latest versions of Docker."
  echo "You will need to deploy GCP360 manually. Check the wiki page."
  exit 1
fi

rpm -q yum-utils || yum -y install yum-utils
rpm -q git || yum -y install git

if [ $v_major_version -eq 7 ]
then
  rpm -q docker-engine || yum -y install docker-engine
else
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  rpm -q docker-ce || yum -y install docker-ce
fi

systemctl enable docker
systemctl start docker

loop_wait_proc ()
{
  set +x
  while kill -0 "$1"
  do
    echo "$(date '+%Y%m%d_%H%M%S'): Process is still running. Please wait."
    sleep 30
  done
  set -x
}

#############################
# Docker Image for Database #
#############################

if [ $v_major_version -eq 8 ]
then
  # This is required on Linux 8 to allow the docker container to communicate with the internet.
  firewall-cmd --zone=public --add-masquerade --permanent
  firewall-cmd --reload
fi

if [ "$(docker images -q oracle/database:${v_db_version_container})" == "" ]
then
  rm -rf docker-images/
  git clone https://github.com/oracle/docker-images.git
  if [ -n "${v_git_oracle_commit_hash}" ]
  then
    cd docker-images
    git checkout ${v_git_oracle_commit_hash}
    cd -
  fi
  if [ -n "${v_db_version_file}" ]
  then
    if [ ! -r "${v_db_version_file}" ]
    then
      echo "Could not find \"${v_db_version_file}\" in current directory. Please download it."
      exit 1
    fi
    cp -av "${v_db_version_file}" ./docker-images/OracleDatabase/SingleInstance/dockerfiles/${v_db_version}/
  fi
  cd ./docker-images/OracleDatabase/SingleInstance/dockerfiles/
  ./buildContainerImage.sh -v ${v_db_version_param} &
  loop_wait_proc "$!"
  cd -
  rm -rf docker-images/
else
  echo "Docker image for the database is already created."
fi

docker images
docker ps -a

# Those IDs cannot be changed as they must be aligned with the docker image.
# 54321 -> User: oracle
# 55555 -> User: gcp360

if ! $(getent passwd gcp360 > /dev/null)
then
  useradd -u ${v_gcp360_uid} -g users -G docker gcp360
else
  v_gcp360_uid=$(id -u gcp360)
  gpasswd -a gcp360 docker
fi

rm -rf "${v_db_dir}"

mkdir -p "${v_master_directory}"
mkdir -p "${v_db_dir}/oradata/"
mkdir -p "${v_db_dir}/setup/"
chown -R 54321:54321 "${v_db_dir}"

cd "${v_db_dir}/setup/"

wget https://raw.githubusercontent.com/dbarj/gcp360/${v_git_branch}/container/enable_max_string.sql
wget https://raw.githubusercontent.com/dbarj/gcp360/${v_git_branch}/container/create_gcp360.sql
wget https://raw.githubusercontent.com/dbarj/gcp360/${v_git_branch}/container/setup_gcp360.sh

cd -

docker stop ${v_gcp360_con_name} || true
docker rm ${v_gcp360_con_name} || true

docker run \
--name ${v_gcp360_con_name} \
--restart unless-stopped \
-d \
-p 1521:1521 \
-e ORACLE_CHARACTERSET=AL32UTF8 \
-e GCP360_BRANCH=${v_git_branch} \
-e GCP360_UID=${v_gcp360_uid} \
-v ${v_db_dir}/oradata:/opt/oracle/oradata \
-v ${v_db_dir}/setup:/opt/oracle/scripts/setup \
-v ${v_master_directory}:/u01 \
oracle/database:${v_db_version_container}

docker logs -f ${v_gcp360_con_name} &
v_pid=$!

set +x
while :
do
  v_out=$(docker logs ${v_gcp360_con_name} 2>&1 >/dev/null)
  grep -qF 'DATABASE IS READY TO USE!' <<< "$v_out" && break || true
  if grep -qF 'DATABASE SETUP WAS NOT SUCCESSFUL!' <<< "$v_out" ||
     grep -qE 'Error on line [0-9]+ of "setup_gcp360.sh".' <<< "$v_out"
  then
    echo "Error while creating the ${v_gcp360_con_name} container. Check docker logs."
    exit 1
  fi
  echo "$(date '+%Y%m%d_%H%M%S'): Process is still running. Please wait."
  sleep 30
done
set -x

kill ${v_pid}

###########################
# Docker Image for APACHE #
###########################

rm -rf "${v_apache_dir}"
mkdir -p "${v_apache_dir}"

docker stop ${v_apache_con_name} || true
docker rm ${v_apache_con_name} || true

docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > "${v_apache_dir}/httpd.conf"
docker run --rm httpd:2.4 cat /usr/local/apache2/conf/extra/httpd-ssl.conf > "${v_apache_dir}/httpd-ssl.conf"

cat << 'EOF' >> "${v_apache_dir}/httpd.conf"
Alias /gcp360 "/usr/local/apache2/htdocs/gcp360/"
<Directory "/usr/local/apache2/htdocs/gcp360>
  Options +Indexes
  AllowOverride All
  Require all granted
  Order allow,deny
  Allow from all
</Directory>
EOF

cat << 'EOF' > "${v_master_directory}/www/.htaccess"
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /etc/httpd/.htpasswd
Require valid-user
EOF

SERVER_NAME=gcp360.example.com

sed -i "s%#ServerName www.example.com:80%ServerName ${SERVER_NAME}:80%" "${v_apache_dir}/httpd.conf"
sed -i "s%#\(Include conf/extra/httpd-ssl.conf\)%\1%" "${v_apache_dir}/httpd.conf"
sed -i "s%#\(LoadModule ssl_module modules/mod_ssl.so\)%\1%" "${v_apache_dir}/httpd.conf"
sed -i "s%#\(LoadModule socache_shmcb_module modules/mod_socache_shmcb.so\)%\1%" "${v_apache_dir}/httpd.conf"
sed -i "s%ServerName www.example.com:443%ServerName ${SERVER_NAME}:443%" "${v_apache_dir}/httpd-ssl.conf"

mkdir -p "${v_apache_dir}/ssl"

openssl req \
-x509 \
-nodes \
-days 1095 \
-newkey rsa:2048 \
-out "${v_apache_dir}/ssl/server.crt" \
-keyout "${v_apache_dir}/ssl/server.key" \
-subj "/C=BR/ST=RJ/L=RJ/O=GCP360/CN=${SERVER_NAME}"

chmod -R g-rwx "${v_apache_dir}"
chmod -R o-rwx "${v_apache_dir}"

touch "${v_apache_dir}/.htpasswd"

docker run \
-dit \
--name ${v_apache_con_name} \
--restart unless-stopped \
-p 443:443 \
-v "${v_master_directory}/www":/usr/local/apache2/htdocs/gcp360 \
-v "${v_apache_dir}/httpd.conf":/usr/local/apache2/conf/httpd.conf \
-v "${v_apache_dir}/httpd-ssl.conf":/usr/local/apache2/conf/extra/httpd-ssl.conf \
-v "${v_apache_dir}/ssl/server.crt":/usr/local/apache2/conf/server.crt \
-v "${v_apache_dir}/ssl/server.key":/usr/local/apache2/conf/server.key \
-v "${v_apache_dir}/.htpasswd":/etc/httpd/.htpasswd \
httpd:2.4

v_http_pass="$(openssl rand -hex 6)"

docker exec -it ${v_apache_con_name} htpasswd -b /etc/httpd/.htpasswd gcp360 ${v_http_pass}

chmod 644 "${v_apache_dir}/.htpasswd"

# Enable port 443
firewall-cmd --add-service=https || true
firewall-cmd --permanent --add-service=https || true

###############
# Info GCP360 #
###############

set +x

echo "
########################################
########################################

The instructions below will be saved on \"${v_master_directory}/INSTRUCTIONS.txt\".

GCP360 install/upgrade finished successfully.

To run GCP360, first setup the account credentials with \"gcloud auth login\" command:

[gcp360@localhost ]$ docker exec -it --user gcp360 ${v_gcp360_con_name} gcloud auth login

Then, connect locally in this compute as gcp360 user (\"sudo su - gcp360\") or ROOT and test gcloud:

[gcp360@localhost ]$ docker exec -it --user gcp360 ${v_gcp360_con_name} bash -c 'cd /tmp/; /u01/gcp360_tool/app/sh/gcp_json_export.sh organizations'

If the command above produce a JSON output with all your compute instances, everything is set correctly.

Finally, call the GCP360 tool:

[gcp360@localhost ]$ docker exec -it --user gcp360 ${v_gcp360_con_name} bash /u01/gcp360_tool/scripts/gcp360_run.sh

Optionally, you can add a crontab job for this collection to run every X hours (eg for 6 hours):

00 */6 * * * docker exec -it --user gcp360 ${v_gcp360_con_name} bash /u01/gcp360_tool/scripts/gcp360_run.sh

To access the GCP360 output, you can either:

- Connect on https://localhost/gcp360/
 * User: gcp360
 * Pass: ${v_http_pass}

- Download and open the zip file from ${v_master_directory}/gcp360_tool/out/processed/

To change GCP360 website password, run:
[gcp360@localhost ]$ docker exec -it ${v_apache_con_name} htpasswd -b /etc/httpd/.htpasswd gcp360 *new_password*

########################################
########################################
" | tee ${v_master_directory}/INSTRUCTIONS.txt

chmod 600 ${v_master_directory}/INSTRUCTIONS.txt

exit 0
#####