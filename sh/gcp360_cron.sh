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

source ~/.bash_profile
set -eo pipefail

## Default values. If you want to change them, modify in the .cfg file.

v_retention_period=30 # Number of days to keep past gcp360 executions.

# Funcions

echoTime ()
{
  echo "$(date '+%Y%m%d_%H%M%S'): $1"
}

exitError ()
{
  echoTime "$1"
  kill -9 $(ps -s $$ -o pid= | grep -v $$) 2>&-
  exit 1
}

trap_err ()
{
  conf_step_error
  exitError "Error on line $1."
}

# If script aborts, will call this function to write on cfg file the last executed step.
conf_step_error ()
{
  if [ -f ${v_config_file} -a -n "${GCP360_CRON_STEP}" ]
  then
    sed -i '/GCP360_LAST_EXEC_STEP=/d' ${v_config_file}
    echo "GCP360_LAST_EXEC_STEP=${GCP360_CRON_STEP}" >> ${v_config_file}
  fi
}

# Increment current step by 1.
incr_gcp360_step ()
{
  [ -z "$GCP360_CRON_STEP" ] && GCP360_CRON_STEP=1 || GCP360_CRON_STEP=$(($GCP360_CRON_STEP+1))
}

# Change shell encoding
export LC_ALL=en_US.UTF-8

# If unhandled error, code will stop and save current step.
trap 'trap_err $LINENO' ERR
trap 'exitError "Code interrupted."' SIGINT SIGTERM

# Directories

v_thisdir="$(dirname "$0")"
v_basedir="$(readlink -f "$v_thisdir/../")"   # Folder of GCP360 Tool
v_confdir=$v_basedir/scripts                  # Folder of this script

export TMPDIR=$v_basedir/tmp/
export GCP_CLI_ARGS=""

v_dir_www=/var/www/gcp360       # Apache output folder.
v_dir_gcp360=$v_basedir/app     # GCP360 github tool folder.
v_dir_gcpexp=$v_basedir/exp     # Output folder for exported json files.
v_dir_gcpout=$v_basedir/out     # Output folder of GCP360 execution.
v_dir_gcplog=$v_basedir/log     # Log folder of GCP360 execution.

v_timeout=$((24*3600)) # Timeout to run JSON exporter. 3600 = 1 hour

# Convert to original directory if symbolic link.
v_dir_www=$(readlink -f "${v_dir_www}")

# If you want to have multiple tenancies being executed for the same server, you can optionally pass the tenancy name as a parameter for this script.
# In this case, you must also create a profile for the tenancy on .oci/config and all the corresponding sub-folders.

if [ -n "$1" ]
then
  v_param1="$1"
  v_param1_lower=$(tr '[:upper:]' '[:lower:]' <<< "$v_param1")
  v_param1_upper=$(tr '[:lower:]' '[:upper:]' <<< "$v_param1")
  export GCP_CLI_ARGS="${GCP_CLI_ARGS} --profile ${v_param1_upper}"
  v_dir_gcpexp=${v_dir_gcpexp}/${v_param1_lower}
  v_dir_gcpout=${v_dir_gcpout}/${v_param1_lower}
  v_dir_gcplog=${v_dir_gcplog}/${v_param1_lower}
  v_dir_www=${v_dir_www}/${v_param1_lower}
  v_schema_name=${v_param1_upper}
  v_config_file=${v_param1_lower}.cfg
  export TMPDIR=${TMPDIR}/${v_param1_lower}
else
  v_schema_name="GCP360"
  v_config_file="gcp360.cfg"
fi

v_config_file="${v_confdir}/${v_config_file}"

[ ! -d "${v_dir_gcpexp}" ]   && { exitError "Folder \"${v_dir_gcpexp}\" was not created."; }
[ ! -d "${v_dir_gcpout}" ]   && { exitError "Folder \"${v_dir_gcpout}\" was not created."; }
[ ! -d "${v_dir_gcplog}" ]   && { exitError "Folder \"${v_dir_gcplog}\" was not created."; }
[ ! -d "${v_dir_www}" ]      && { exitError "Folder \"${v_dir_www}\" was not created."; }

set +x

v_script_runtime=$(/bin/date '+%Y%m%d%H%M%S')
v_script_log="${v_dir_gcplog}/run.${v_script_runtime}.log"
v_script_trc="${v_dir_gcplog}/run.${v_script_runtime}.trc"
echo "From this point, all the output will also be redirected to \"${v_script_log}\"."

# Redirect script STDOUT and STDERR to file.
exec 2>"${v_script_trc}"
exec > >(tee -a "${v_script_log}")

set -x

pid_check ()
{
  PIDFILE="${v_dir_gcplog}"/${v_schema_name}.pid
  [ -n "${v_pid_file}" ] && PIDFILE="${v_pid_file}"
  if [ -f $PIDFILE ]
  then
    PID=$(cat $PIDFILE)
    ps -p $PID > /dev/null 2>&1 && v_ret=$? || v_ret=$?
    if [ $v_ret -eq 0 ]
    then
      exitError "Process already running"
    else
      ## Process not found assume not running
      echo $1 > $PIDFILE && v_ret=$? || v_ret=$?
      if [ $v_ret -ne 0 ]
      then
        exitError "Could not create PID file"
      fi
    fi
  else
    echo $1 > $PIDFILE && v_ret=$? || v_ret=$?
    if [ $v_ret -ne 0 ]
    then
      exitError "Could not create PID file"
    fi
  fi
}

pid_check $$

# Create TMPDIR
[ ! -d ${TMPDIR} ] && mkdir -p ${TMPDIR}

# Clean past temp files.
rm -rf ${TMPDIR}/.oci/

# Load db.cfg if exists. db.cfg is a generic file that will apply to any GCP360 profile.
[ -f ${v_confdir}/db.cfg ] && source ${v_confdir}/db.cfg

# Load optional config file, if file is available.
[ -f ${v_config_file} ] && source ${v_config_file}

# Skip script export steps
[ "${GCP360_SKIP_EXP}" != "1" ] && GCP360_SKIP_EXP=0

# Skip script merge steps
[ "${GCP360_SKIP_MERGER_EXP}" != "1" ] && GCP360_SKIP_MERGER_EXP=0

# Skip script converter steps
[ "${GCP360_SKIP_CONVERT_EXP}" != "1" ] && GCP360_SKIP_CONVERT_EXP=0

# Skip other steps
[ "${GCP360_SKIP_CLEAN_START}" != "0" ] && GCP360_SKIP_CLEAN_START=1
[ "${GCP360_SKIP_PLACE_ZIPS}" != "1" ] && GCP360_SKIP_PLACE_ZIPS=0
[ "${GCP360_SKIP_SQLPLUS}" != "1" ] && GCP360_SKIP_SQLPLUS=0
[ "${GCP360_SKIP_PREP_APACHE}" != "1" ] && GCP360_SKIP_PREP_APACHE=0
[ "${GCP360_SKIP_OBFUSCATE}" != "1" ] && GCP360_SKIP_OBFUSCATE=0
[ "${GCP360_SKIP_MV_APACHE}" != "1" ] && GCP360_SKIP_MV_APACHE=0
[ "${GCP360_SKIP_MV_PROC}" != "1" ] && GCP360_SKIP_MV_PROC=0

# If there is no Last Exec Step Variable, set it to 0.
[ -z "$GCP360_LAST_EXEC_STEP" ] && GCP360_LAST_EXEC_STEP=0

[ $GCP360_LAST_EXEC_STEP -gt 0 ] && echoTime "Code aborted on last call and will resume now from step $GCP360_LAST_EXEC_STEP"

###
### Checks
###

[ -z "${v_conn}" ] && { exitError "Connection variable v_conn is undefined on \"${v_config_file}\"."; }

# Variables
v_dir_exp="${v_dir_gcpexp}/exp_tenancy"

##################
### Extraction ###
##################

echo_process_pid ()
{
  echoTime "Process \"${1}\" is running with PID ${2}."
}

echo_skip_section ()
{
  echoTime "Skip '${1}' execution."
}

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_CLEAN_START=1

if [ ${GCP360_SKIP_CLEAN_START} -eq 0 ]
then
  echoTime 'GCP360_SKIP_CLEAN_START is 0. Cleaning all staged files before starting.'
  rm -f "${v_dir_gcpexp}/*.zip"
  rm -rf "${v_dir_exp}"
fi

# Tenancy Collector

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_EXP=1

if [ ${GCP360_SKIP_EXP} -eq 0 ]
then
  [ ! -d "${v_dir_exp}" ] && mkdir "${v_dir_exp}"
  cd "${v_dir_exp}"

  echoTime "Calling gcp_json_export.sh."
  timeout ${v_timeout} bash ${v_dir_gcp360}/sh/gcp_json_export.sh ALL_PROJECTS > ${v_dir_gcplog}/gcp_json_export.log 2>&1 &
  v_pid_exp=$!
  echo_process_pid "gcp_json_export.sh" ${v_pid_exp}
else
  echo_skip_section "gcp_json_export.sh"
fi

##############
### Merger ###
##############

move_and_remove_folder ()
{
  # $1 -> Subfolder.
  # $2 -> File to move to parent folder.
  if ls "${1}"/${2} 1> /dev/null 2>&1
  then
    mv "${1}"/${2} .
    rmdir "${1}" || true
  fi
}

copy_json_from_zip1_to_zip2 ()
{
  # $1 -> Zip 1 (relative PATH).
  # $2 -> Zip 2 (full PATH).
  v_fdr=$(basename "${1}" .zip)
  mkdir "${v_fdr}"
  unzip -d "${v_fdr}" "${1}"
  cd "${v_fdr}"
  zip -m "${2}" *.json
  cd - > /dev/null
  rm -rf "${v_fdr}"
}

wait_pid_if_notnull ()
{
  # $1 -> Process.
  # $2 -> PID
  if [ -n "${2}" ]
  then
    echoTime "Waiting process \"${1}\" with PID ${2}. Hold on."
    wait ${2} && v_ret=$? || v_ret=$?
  else
    v_ret=0
  fi
}

echo_unable_find ()
{
  echoTime "Unable to find \"${1}\" files on \"$(pwd)\"."
}

echo_print_trace_log ()
{
  echoTime "Checking ${1}..."
  if [ -n "${2}" ]
  then
    echoTime "Trace File: tail -f ${2}"
  fi
  if [ -n "${3}" ]
  then
    echoTime "Log File: tail -f ${3}"
  fi
}

cd "${v_dir_gcpexp}"

# Organization Merger

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_MERGER_EXP=1

if [ ${GCP360_SKIP_EXP} -eq 0 ]
then
  echo_print_trace_log "gcp_json_export.sh" "${v_dir_exp}/gcp_json_export.log" "${v_dir_gcplog}/gcp_json_export.log"
  tail -f ${v_dir_gcplog}/gcp_json_export.log &
fi

wait_pid_if_notnull "gcp_json_export.sh" $v_pid_exp

if [ $v_ret -ne 0 ]
then
  echoTime "gcp_json_export.sh failed. Return: ${v_ret}. Code will stop here."
  cp -av "${v_dir_gcplog}/gcp_json_export.log" "${v_dir_gcplog}/gcp_json_export.${v_script_runtime}.log" || true
  exitError "Check logfile for more info: ${v_dir_gcplog}/gcp_json_export.${v_script_runtime}.log"
fi

move_and_remove_folder "${v_dir_exp}" "gcp_json_export_*_*.zip"

if [ ${GCP360_SKIP_MERGER_EXP} -eq 0 ]
then
  echoTime "Merging gcp_json_export.sh outputs."
  if ls gcp_json_export_*_*.zip 1> /dev/null 2>&1
  then
    v_prefix_file=$(ls -t1 gcp_json_export_*_*.zip | head -n 1 | sed 's/_[^_]*$//')
    v_exp_file="${v_prefix_file}.zip"
    bash ${v_dir_gcp360}/sh/gcp_json_merger.sh "${v_prefix_file}_*.zip" "${v_exp_file}"
  else
    echo_unable_find "gcp_json_export_*_*.zip"
    exitError "Restart the script removing GCP360_LAST_EXEC_STEP from ${v_config_file}."
  fi
else
  echo_skip_section "Export Merge"
fi

# CSV Converter

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_CONVERT_EXP=1

if [ ${GCP360_SKIP_CONVERT_EXP} -eq 0 ]
then

  if [ -z "${v_exp_file}" ]
  then
    if ls gcp_json_export_*.zip 1> /dev/null 2>&1
    then
      v_exp_file=$(ls -t1 gcp_json_export_*.zip | head -n 1)
    else
      echo_unable_find "gcp_json_export_*.zip"
      exitError "Restart the script removing GCP360_LAST_EXEC_STEP from ${v_config_file}."
    fi
  fi

  v_csv_file=$(sed 's/^gcp_json_export_/gcp_csv_export_/' <<< "${v_exp_file}")
  echoTime "Log File: tail -f ${v_dir_gcplog}/zip_json_to_csv.log"
  bash ${v_dir_gcp360}/sh/zip_json_to_csv.sh "${v_dir_gcpexp}/${v_exp_file}" "${v_dir_gcpexp}/${v_csv_file}" > ${v_dir_gcplog}/zip_json_to_csv.log 2>&1

else
  echo_skip_section "Convert JSON to CSV"
fi

###################
### Move Output ###
###################

# Move output to OCI Bucket or to output folder

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_PLACE_ZIPS=1

if [ $GCP360_SKIP_PLACE_ZIPS -eq 0 ]
then

  if [ -z "${v_csv_file}" ]
  then
    if ls gcp_csv_export_*.zip 1> /dev/null 2>&1
    then
      v_csv_file=$(ls -t1 gcp_csv_export_*.zip | head -n 1)
    else
      echo_unable_find "gcp_csv_export_*.zip"
      exitError "Restart the script removing GCP360_LAST_EXEC_STEP from ${v_config_file}."
    fi
  fi

  rm -f ${v_dir_gcpout}/gcp_csv_export_*.zip

  if [ -n "${v_gcp_bucket}" ]
  then
    [ -n "${GCP_CLI_ARGS_BUCKET}" ] && GCP_CLI_ARGS_BKP="${GCP_CLI_ARGS}" && export GCP_CLI_ARGS="${GCP_CLI_ARGS_BUCKET}"
    export GCP_UP_GZIP=1
    export GCP_CLEAN_BUCKET=1
    echoTime "Log File: tail -f ${v_dir_gcplog}/gcp_bucket_upload.log"
    bash ${v_dir_gcp360}/sh/gcp_bucket_upload.sh "${v_gcp_bucket}" "${v_dir_gcpexp}/${v_csv_file}" > ${v_dir_gcplog}/gcp_bucket_upload.log 2>&1
    unset GCP_CLEAN_BUCKET
    [ -n "${GCP_CLI_ARGS_BUCKET}" ] && export GCP_CLI_ARGS="${GCP_CLI_ARGS_BKP}"
  else
    cp -av ${v_dir_gcpexp}/${v_csv_file} ${v_dir_gcpout}
  fi
else
  echo_skip_section "Zip Prepare"
fi

####################################
### Reporter (GCP360 SQL script) ###
####################################

cd ${v_dir_gcp360}

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_SQLPLUS=1

if [ ${GCP360_SKIP_SQLPLUS} -eq 0 ]
then

  echoTime "Calling gcp360.sql. SQLPlus will be executed with the following options:"

  cat << EOF
--
DEF moat369_pre_sw_output_fdr = '${v_dir_gcpout}'
DEF gcp360_pre_obj_schema = '${v_schema_name}'
DEF gcp360_clean_on_exit = 'OFF'
${v_gcp360_opts}
@gcp360.sql
--
EOF

  sqlplus ${v_conn} > ${v_dir_gcplog}/gcp360.out << EOF &
DEF moat369_pre_sw_output_fdr = '${v_dir_gcpout}'
DEF gcp360_pre_obj_schema = '${v_schema_name}'
DEF gcp360_clean_on_exit = 'OFF'
${v_gcp360_opts}
@gcp360.sql
EOF

  v_pid_sqlp="$!"
  echo_process_pid "SQLPlus" ${v_pid_sqlp}
  echo_print_trace_log "SQLPlus" "" "${v_dir_gcplog}/gcp360.out"
  wait_pid_if_notnull "SQLPlus" ${v_pid_sqlp}

  if [ $v_ret -ne 0 ]
  then
    echoTime "GCP360 Database execution failed. Return: ${v_ret}. Code will stop here."
    cp -av "${v_dir_gcplog}/gcp360.out" "${v_dir_gcplog}/gcp360.${v_script_runtime}.out" || true
    conf_step_error
    exitError "Check logfile for more info: ${v_dir_gcplog}/gcp360.${v_script_runtime}.out"
  fi
else
  echo_skip_section "SQLPlus gcp360.sql"
fi

#############################
### Move result to Apache ###
#############################

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_PREP_APACHE=1

if [ ${GCP360_SKIP_PREP_APACHE} -eq 0 ]
then
  echoTime "Prepare result for Apache."

  v_gcp_file=$(ls -1t ${v_dir_gcpout}/gcp360_*.zip | head -n 1)
  v_dir_name=$(basename $v_gcp_file .zip)
  v_dir_path=${v_dir_gcpout}/${v_dir_name}

  mkdir ${v_dir_path}
  unzip -q -d ${v_dir_path} ${v_gcp_file}
  chmod -R a+r ${v_dir_path}
  find ${v_dir_path} -type d | xargs chmod a+x
  mv ${v_dir_path}/00001_*.html ${v_dir_path}/index.html
else
  echo_skip_section "Prepare Apache"
fi

if [ -z "${v_gcp_file}" ]
then
  cd "${v_dir_gcpout}"
  if ls gcp360_*.zip 1> /dev/null 2>&1
  then
    v_gcp_file=$(ls -1t ${v_dir_gcpout}/gcp360_*.zip | head -n 1)
    v_dir_name=$(basename $v_gcp_file .zip)
    v_dir_path=${v_dir_gcpout}/${v_dir_name}
  else
    echo_unable_find "gcp360_*.zip"
    exitError "Restart the script removing GCP360_LAST_EXEC_STEP from ${v_config_file}."
  fi
  cd - > /dev/null
fi

#########################################
### Run obfuscation tool (if present) ###
#########################################

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_OBFUSCATE=1

if ! [ -f ${v_confdir}/gcp360_obfuscate.sh -a "${v_obfuscate}" == "yes" ]
then
  GCP360_SKIP_OBFUSCATE=1
fi

if [ ${GCP360_SKIP_OBFUSCATE} -eq 0 ]
then
  cd "${v_dir_path}"
  echoTime "Running obfuscation."
  source ${v_confdir}/gcp360_obfuscate.sh || true
  cd - > /dev/null
else
  echo_skip_section "Obfuscation"
fi

#############################
### Move result to Apache ###
#############################

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_MV_APACHE=1

if [ ${GCP360_SKIP_MV_APACHE} -eq 0 ]
then
  echoTime "Moving results to Apache."

  mv ${v_dir_path} ${v_dir_www}
  cd ${v_dir_www}
  rm -f latest
  ln -sf ${v_dir_name} latest
  /usr/sbin/restorecon -R ${v_dir_www} || true
  cd - > /dev/null
else
  echo_skip_section "Move Apache"
fi

#############################
### Cleanup for next Exec ###
#############################

# Create processed folders
[ ! -d "${v_dir_gcpout}/processed" ] && mkdir "${v_dir_gcpout}/processed"
[ ! -d "${v_dir_gcpexp}/processed" ] && mkdir "${v_dir_gcpexp}/processed"

# Clean based on retention period
find ${v_dir_gcplog}/ -maxdepth 1 -type f -mtime +${v_retention_period} -name *.log -exec rm -f {} \;
find ${v_dir_gcplog}/ -maxdepth 1 -type f -mtime +${v_retention_period} -name *.trc -exec rm -f {} \;
find ${v_dir_gcpout}/processed/ -maxdepth 1 -type f -mtime +${v_retention_period} -exec rm -f {} \;
find ${v_dir_gcpexp}/processed/ -maxdepth 1 -type f -mtime +${v_retention_period} -exec rm -f {} \;
find ${v_dir_www} -maxdepth 1 -type d -mtime +${v_retention_period} -exec rm -rf {} \;
[ -d "/opt/oracle/admin/XE/adump/" ] && find /opt/oracle/admin/XE/adump/ -type f -mtime +${v_retention_period} -name *.aud -exec rm -f {} \;

###############################
### Move processed ZIP file ###
###############################

move_exp_to_processed ()
{
  if ls ${1} 1> /dev/null 2>&1
  then
    mv ${1} ${v_dir_gcpexp}/processed/
  fi
}

incr_gcp360_step
[ $GCP360_LAST_EXEC_STEP -gt $GCP360_CRON_STEP ] && GCP360_SKIP_MV_PROC=1

if [ ${GCP360_SKIP_MV_PROC} -eq 0 ]
then
  echoTime "Moving processed files."

  move_exp_to_processed "${v_dir_gcpexp}/gcp_json_export_*.zip"
  move_exp_to_processed "${v_dir_gcpexp}/gcp_csv_export_*.zip"
  
  mv ${v_gcp_file} ${v_dir_gcpout}/processed/
else
  echo_skip_section "Move Processed Files"
fi

# Clean last execution step if exists.
sed -i '/GCP360_LAST_EXEC_STEP=/d' ${v_config_file}

echoTime "Script finished."

exit 0
####