#!/bin/bash
#************************************************************************
#
#   gcp_json_export.sh - Export all Google Cloud Infrastructure
#   metadata information into JSON files.
#
#   Copyright 2021  Rodrigo Jorge <http://www.dbarj.com.br/>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#************************************************************************
# Available at: https://github.com/dbarj/gcp-scripts
# Created on: Jan/2021 by Rodrigo Jorge
# Version 1.01
#************************************************************************
set -eo pipefail

# Define paths for gcloud and jq or put them on $PATH. Don't use relative PATHs in the variables below.
v_gcp="gcloud"
v_jq="jq"

if [ -z "${BASH_VERSION}" -o "${BASH}" = "/bin/sh" ]
then
  >&2 echo "Script must be executed in BASH shell."
  exit 1
fi

# Add any desired gcloud argument exporting GCP_CLI_ARGS. Keep default to avoid gcp_cli_rc usage.
[ -n "${GCP_CLI_ARGS}" ] && v_gcp_args="${GCP_CLI_ARGS}"
[ -z "${GCP_CLI_ARGS}" ] && v_gcp_args=""

# Don't change it.
v_min_gcloud="323.0.0"
v_gcp_margs="--format json --quiet" # Mandatory args for this tool

# Timeout for gcloud calls
v_gcp_timeout=600 # Seconds
v_gcp_parallel=10 # Default parallel if can't find # of cores or if GCP_JSON_PARALLEL is unset.

[[ "${TMPDIR}" == "" ]] && TMPDIR='/tmp/'
# Temporary Folder. Used to stage some repetitive jsons and save time. Empty to disable.
v_tmpfldr="$(mktemp -d -u -p ${TMPDIR}/.gcloud 2>&- || mktemp -d -u)"

# If DEBUG variable is undefined, change to 1.
[[ "${DEBUG}" == "" ]] && DEBUG=1
[ ! -z "${DEBUG##*[!0-9]*}" ] || DEBUG=1

# If GCP_JSON_EXCLUDE is unset, by default will exclude the following items.
[ -z "${GCP_JSON_EXCLUDE}" ] && GCP_JSON_EXCLUDE="OS-Objects"

# DEBUG - Will create a gcp_json_export.log file with DEBUG info.
#  1 = Executed commands.
#  2 = + Commands Queue + Stop
#  3 = + Subcalls Info
#  4 = + Parallel Lock/Release
#  ...
#  8 = + Job Wait Loop
#  9 = + Parallel Wait Loop
# 10 = + Lock/Unlock Loop

trap "trap - SIGTERM && cleanAllonAbort && kill -- -$$" SIGINT SIGTERM

function cleanAllonAbort ()
{
  if [ -n "${v_tmpfldr_root}" -a -d "${v_tmpfldr_root}" ]
  then
    rm -rf "${v_tmpfldr_root}" 2>&- || true
  fi
}

function echoError ()
{
  (>&2 echo "$1")
}

function echoDebug ()
{
  local v_msg="$1"
  local v_debug_lvl="$2"
  local v_filename="${v_this_script%.*}.log"
  [ -z "${v_debug_lvl}" ] && v_debug_lvl=1
  if [ $DEBUG -ge ${v_debug_lvl} ]
  then
    v_msg="$(date '+%Y%m%d_%H%M%S'): $v_msg"
    [ -n "${v_exec_id}" ] && v_msg="$v_msg (${v_exec_id})"
    echo "$v_msg" >> "${v_filename}"
    [ -f "../${v_filename}" ] && echo "$v_msg" >> "../${v_filename}"
  fi
  return 0
}

function funcCheckValueInRange ()
{
  [ "$#" -ne 2 -o -z "$1" -o -z "$2" ] && return 1
  local v_arg1 v_arg2 v_array v_opt
  v_arg1="$1" # Value
  v_arg2="$2" # Range
  v_array=$(tr "," "\n" <<< "${v_arg2}")
  for v_opt in $v_array
  do
    if [ "$v_opt" == "${v_arg1}" ]
    then
      echo "Y"
      return 0
    fi
  done
  echo "N"
}

function funcPrintRange ()
{
  [ "$#" -ne 1 -o -z "$1" ] && return 1
  local v_arg1 v_opt v_array
  v_arg1="$1" # Range
  v_array=$(tr "," "\n" <<< "${v_arg1}")
  for v_opt in $v_array
  do
    echo "- ${v_opt}"
  done
}

v_this_script="$(basename -- "$0")"

v_func_list=$(sed -e '1,/^# BEGIN DYNFUNC/d' -e '/^# END DYNFUNC/,$d' -e 's/^# *//' $0)
v_opt_list=$(echo "${v_func_list}" | cut -d ',' -f 1 | sort | tr "\n" ",")
v_valid_opts="ALL,ALL_PROJECTS"
v_valid_opts="${v_valid_opts},${v_opt_list}"

v_param1="$1"

v_check=$(funcCheckValueInRange "$v_param1" "$v_valid_opts") && v_ret=$? || v_ret=$?

if [ "$v_check" == "N" -o $v_ret -ne 0 ]
then
  echoError "Usage: ${v_this_script} <option>"
  echoError ""
  echoError "<option> - Execution Scope."
  echoError ""
  echoError "Valid <option> values are:"
  echoError "- ALL          - Execute json export for ALL possible options and compress output in a zip file."
  echoError "- ALL_PROJECTS - Same as ALL, but also loop over for all tenancy's subscribed projects."
  echoError "$(funcPrintRange "$v_opt_list")"
  echoError ""
  echoError "PS: it is possible to export the following variables to add/remove options when ALL/ALL_PROJECTS are used."
  echoError "GCP_JSON_INCLUDE  - Comma separated list of items to include."
  echoError "GCP_JSON_EXCLUDE  - Comma separated list of items to exclude."
  echoError ""
  echoError "GCP_JSON_PARALLEL - Parallel executions of gcloud."
  echoError ""
  echoError "GCP_CLI_ARGS      - All parameters provided will be appended to gcloud call."
  echoError "                    Eg: export GCP_CLI_ARGS='--account ACME'"
  exit 1
fi

if ! $(which ${v_gcp} >&- 2>&-)
then
  echoError "Could not find gcloud binary. Please adapt the path in the script if not in \$PATH."
  echoError "Download page: https://cloud.google.com/sdk/docs/install"
  exit 1
fi

if ! $(which ${v_jq} >&- 2>&-)
then
  echoError "Could not find jq binary. Please adapt the path in the script if not in \$PATH."
  echoError "Download page: https://github.com/stedolan/jq/releases"
  exit 1
fi

if ! $(which zip >&- 2>&-)
then
  if [ "${v_param1}" == "ALL" -o "${v_param1}" == "ALL_PROJECTS" ]
  then
    echoError "Could not find zip binary. Please include it in \$PATH."
    echoError "Zip binary is required to put all output json files together."
    exit 1
  fi
fi

v_zip="zip -9"

v_cur_gcloud=$(${v_gcp} -v)

if [ "${v_min_gcloud}" != "`echo -e "${v_min_gcloud}\n${v_cur_gcloud}" | sort -V | head -n1`" ]
then
  echoError "Minimal gcloud version required is ${v_min_gcloud}. Found: ${v_cur_gcloud}"
  exit 1
fi

[ -z "${v_gcp_margs}" ] || v_gcp="${v_gcp} ${v_gcp_margs}"
[ -z "${v_gcp_args}" ] || v_gcp="${v_gcp} ${v_gcp_args}"

v_test=$(${v_gcp} projects list 2>&1) && v_ret=$? || v_ret=$?
if [ $v_ret -ne 0 ]
then
  echoError "gcloud not able to run \"${v_gcp} projects list\". Please check error:"
  echoError "$v_test"
  exit 1
fi

# Compute parallel
v_cpu_count=$(python -c 'import multiprocessing as mp; print(mp.cpu_count())' 2>&-) || true
[ ! -z "${v_cpu_count##*[!0-9]*}" ] && v_gcp_parallel_target=${v_cpu_count} || v_gcp_parallel_target=${v_gcp_parallel}
[ ! -z "${GCP_JSON_PARALLEL##*[!0-9]*}" ] && v_gcp_parallel_target=${GCP_JSON_PARALLEL}
v_gcp_parallel=${v_gcp_parallel_target}

# Global parallel temporary file
v_tmpfldr_root="${v_tmpfldr}"
v_parallel_file="${v_tmpfldr_root}/gcp_parallel.txt"

## Test if temp folder is writable
if [ -n "${v_tmpfldr}" ]
then
  mkdir -p "${v_tmpfldr}" 2>&- || true
else
  echoError "Temporary folder is DISABLED. Execution will take much longer."
  echoError "Press CTRL+C in next 10 seconds if you want to exit and fix this."
  sleep 10
fi

if [ -n "${v_tmpfldr}" -a ! -w "${v_tmpfldr}" ]
then
  echoError "Temporary folder \"${v_tmpfldr}\" is NOT WRITABLE. Execution will take much longer."
  echoError "Press CTRL+C in next 10 seconds if you want to exit and fix this."
  sleep 10
  # Unset variables if no temporary folder
  v_tmpfldr=""
  v_gcp_parallel=1
  v_parallel_file=""
  v_tmpfldr_root=""
fi

echoDebug "Temporary folder is: ${v_tmpfldr}"
echoDebug "GCP Parallel is: ${v_gcp_parallel}"
echoDebug "DEBUG level is: ${DEBUG}" 2
echoDebug "GCP JSON Include is: ${GCP_JSON_INCLUDE}" 2
echoDebug "GCP JSON Exclude is: ${GCP_JSON_EXCLUDE}" 2

if ! $(which timeout >&- 2>&-)
then
  function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }
fi

################################################
############## GENERIC FUNCTIONS ###############
################################################

## jsonSimple           -> Simply run the parameter with gcloud.
## jsonConcat           -> Concatenate 2 Jsons data vectors parameters into 1.

function genRandom ()
{
  # I use a function instead of simply giving $RANDOM as BASH 3 on MacOS is returning the same value for multiple calls of subfunc.
  echo $RANDOM
}

function jsonSimple ()
{
  # Call gcloud with all provided args in $1.
  set -e # Exit if error in any call.
  [ "$#" -eq 1 -a "$1" != "" ] || { echoError "${FUNCNAME[0]} needs 1 parameter"; return 1; }
  local v_arg1 v_next_page v_fout v_out v_ret
  v_arg1="$1"

  v_exec_id=$(genRandom) # For Debugging

  function err ()
  {
    echoError "## Command Failed:"
    echoError "${v_gcp} ${v_arg1}"
    echoError "########"
    return 1
  }

  set +e
  v_fout=$(callGcloud "${v_arg1}")
  v_ret=$?
  set -e
  [ $v_ret -ne 0 ] && err

  if [ -n "$v_fout" ]
  then
    echo "${v_fout}"
  fi
  return $v_ret
}

function jsonGenericMasterAdd ()
{
  jsonGenericMaster "$@" 1
}

function jsonGenericMaster ()
{
  set -e # Exit if error in any call.
  [ "$#" -eq 4 -o "$#" -eq 5 ] || { echoError "${FUNCNAME[0]} needs 4 or 5 parameters"; return 1; }
  local v_arg1 v_arg2 v_arg3 v_arg4
  local v_out v_fout l_itens v_item
  local v_arg_vect v_param_vect v_newit_vect 
  local v_tags v_maps v_params v_newits
  local v_i v_chk
  local v_sub_pids_list v_sub_files_list v_sub_newits_list v_file_out
  local v_procs_tot v_procs_sub v_procs_counter

  # Used on while loop limit
  local wait_time=2
  local v_limit=300
  local v_counter=1

  v_exec_id=$(genRandom) # For Debugging

  v_arg1="$1" # Main gcloud call
  v_arg2="$2" # Subfunction 1 - FuncName
  v_arg3="$3" # Subfunction 1 - Vector
  v_arg4="$4" # Subfunction 2 - FuncName
  v_arg5="$5" # 0 = Normal mode | 1 = Tag mode

  echoDebug "Hello." 3

  [ -z "$v_arg5" ] && v_arg5=0
  [ $v_arg5 -eq 1 ] && v_tag_mode=true || v_tag_mode=false

  echoDebug "Tag mode: $v_tag_mode." 3

  function concat_out_fout ()
  {
    if $v_tag_mode
    then
      v_chk=$(${v_jq} '.data // empty' <<< "$v_out" | jq -r 'if type=="array" then "yes" else "no" end')
      [ "$v_chk" == "no" ] && v_out=$(${v_jq} '.data += {'${v_newits}'}' <<< "$v_out")
      [ "$v_chk" == "yes" ] && v_out=$(${v_jq} '.data[] += {'${v_newits}'}' <<< "$v_out")
      echoDebug "Check result: $v_chk." 3
    fi
    if ! $v_tag_mode || [ -n "$v_chk" ]
    then
      # I'm ignoring merge failures to not let the code stop here.
      set +e
      v_fout=$(jsonConcat "$v_fout" "$v_out")
      set -e
    fi
  }
  
  v_param_vect=() # Vector to hold v_arg3 every tag entries.
  v_newit_vect=() # Vector to hold v_arg3 every new_tag entries.
  v_arg_vect=(${v_arg3//:/ })

  if $v_tag_mode
  then
    # (Tag1 to get, Param1, Insert Tag Name 1, Tag2 to get, Param2, Insert Tag Name 2, ...)
    for v_i in "${!v_arg_vect[@]}"
    do
      [ $((v_i%3)) -eq 0 ] && v_tags="${v_tags}.\"${v_arg_vect[v_i]}\","
      [ $((v_i%3)) -eq 1 ] && v_param_vect+=(${v_arg_vect[v_i]})
      [ $((v_i%3)) -eq 2 ] && v_newit_vect+=(${v_arg_vect[v_i]})
    done
  else
    # (Tag1 to get, Param1, Tag2 to get, Param2, ...)
    for v_i in "${!v_arg_vect[@]}"
    do
      [ $((v_i%2)) -eq 0 ] && v_tags="${v_tags}.\"${v_arg_vect[v_i]}\","
      [ $((v_i%2)) -ne 0 ] && v_param_vect+=(${v_arg_vect[v_i]})
    done
  fi

  v_tags=$(sed 's/,$//' <<< "$v_tags")
  v_maps=$(sed 's/^.//; s/,./,/g' <<< "$v_tags")
  # l_itens=$(${v_arg2} | ${v_jq} -r '.data[] | '$v_tags' ')
  echoDebug "${v_arg2} | ${v_jq} -r '. |= map({$v_maps}) | . | unique | .[] | $v_tags '" 2
  l_itens=$(${v_arg2} | ${v_jq} -r '. |= map({'$v_maps'}) | . | unique | .[] | '$v_tags' ')
  v_i=0

  v_procs_counter=1
  v_procs_tot=$(($(wc -l <<< "$l_itens")/${#v_param_vect[@]}))
  echoDebug "Subcalls Total: ${v_procs_tot} - ${v_arg4} \"${v_arg1}\"" 2

  v_sub_pids_list=()
  v_sub_files_list=()
  v_sub_newits_list=()
  for v_item in $l_itens
  do
    # Dont add item if value is null.
    if [ "$v_item" != "null" ]
    then
      v_params="${v_params}--${v_param_vect[v_i]} $v_item "
      $v_tag_mode && v_newits="${v_newits}\"${v_newit_vect[v_i]}\":\"$v_item\","
    else
      echoDebug "Removing null \"${v_param_vect[v_i]}\"." 2
    fi
    v_i=$((v_i+1))
    if [ $v_i -eq ${#v_param_vect[@]} ]
    then
      v_params=$(sed 's/ $//' <<< "$v_params")
      $v_tag_mode && v_newits=$(sed 's/,$//' <<< "$v_newits")
      if [ $v_gcp_parallel -gt 1 ]
      then
        echoDebug "Background: ${v_arg4} \"${v_arg1} ${v_params}\"" 3
        v_file_out="${v_tmpfldr}/$(uuidgen)"
        ${v_arg4} "${v_arg1} ${v_params}" > "${v_file_out}.out" 2> "${v_file_out}.err" &
        v_sub_pids_list+=($!)
        v_sub_files_list+=("${v_file_out}")
        $v_tag_mode && v_sub_newits_list+=(${v_newits})
        while :
        do
          v_procs_sub=$(jobs -p | wc -l)
          [ $v_procs_sub -lt $v_gcp_parallel ] && break || echoDebug "Current child jobs: $v_procs_sub. Waiting slot." 8
          sleep $wait_time
          v_counter=$((v_counter+1))
          if [ ${v_counter} -gt ${v_limit} ]
          then
            echoDebug "Child jobs - Wait limit reached: $((v_limit*wait_time)) secs. Moving to next. Current child jobs: $v_procs_sub." 3
            break
          fi
        done
        v_counter=1
        echoDebug "Subcalls Left: $((${v_procs_tot}-${v_procs_counter})) - ${v_arg4} \"${v_arg1}\"" 3
      else
        set +e
        v_out=$(${v_arg4} "${v_arg1} ${v_params}")
        v_ret=$?
        set -e
        [ $v_ret -ne 0 ] && echoDebug "Failed: ${v_arg4} \"${v_arg1} ${v_params}\"" 3
        concat_out_fout
      fi
      v_i=0
      v_params=""
      $v_tag_mode && v_newits=""
      v_procs_counter=$((v_procs_counter+1))
    fi
  done

  # If parallel mode is on, concatenate generated files as executions finishes
  if [ $v_gcp_parallel -gt 1 ]
  then
    for v_i in "${!v_sub_pids_list[@]}"
    do
      set +e
      wait ${v_sub_pids_list[$v_i]}
      v_ret=$?
      set -e
      [ $v_ret -ne 0 ] && echoDebug "Failed background process: ${v_sub_pids_list[$v_i]}" 3
      v_out=$(< "${v_sub_files_list[$v_i]}.out")
      $v_tag_mode && v_newits="${v_sub_newits_list[$v_i]}"
      echoDebug "Merging File: $(($v_i+1)) of $v_procs_tot" 3
      concat_out_fout
      [ -r "${v_sub_files_list[$v_i]}.err" ] && cat "${v_sub_files_list[$v_i]}.err" >&2
      rm -f "${v_sub_files_list[$v_i]}.out" "${v_sub_files_list[$v_i]}.err"
    done
  fi
  echoDebug "Bye." 3
  [ -z "$v_fout" ] || echo "${v_fout}"
}

function jsonConcat ()
{
  set -e # Exit if error in any call.
  [ "$#" -eq 2 ] || { echoError "${FUNCNAME[0]} needs 2 parameters"; return 1; }
  local v_arg1 v_arg2 v_chk_json
  v_arg1="$1" # Json 1
  v_arg2="$2" # Json 2
  ## Concatenate if both not null.
  [ -z "${v_arg1}" -a -n "${v_arg2}" ] && echo "${v_arg2}" && return 0
  [ -n "${v_arg1}" -a -z "${v_arg2}" ] && echo "${v_arg1}" && return 0
  [ -z "${v_arg1}" -a -z "${v_arg2}" ] && return 0
  ## Check if it is a vector
  v_chk_json=$(${v_jq} -r '. | if type=="array" then "yes" else "no" end' <<< "$v_arg1")
  [ "${v_chk_json}" == "no" ] && v_arg1=$(${v_jq} '. | [.]' <<< "$v_arg1")
  v_chk_json=$(${v_jq} -r '. | if type=="array" then "yes" else "no" end' <<< "$v_arg2")
  [ "${v_chk_json}" == "no" ] && v_arg2=$(${v_jq} '. | [.]' <<< "$v_arg2")
  ${v_jq} 'reduce inputs as $i (.; . += $i)' <(echo "$v_arg1") <(echo "$v_arg2")
  return 0
}

function callGcloud ()
{
  ##########
  # This function will siply call the gcloud final command "arg1" and apply any JQ filter to it "arg2"
  ##########

  set +x # Debug can never be enabled here, or stderr will be a mess. It must be disabled even before calling this func to avoid this set +x to be printed.
  set -eo pipefail # Exit if error in any call.
  local v_arg1 v_ret
  [ "$#" -ne 1 -o "$1" = "" ] && { echoError "${FUNCNAME[0]} needs 1 parameters. Given: $#"; return 1; }
  v_arg1="$1"
  # echoDebug "${v_gcp} ${v_arg1}"
  echoDebug "Waiting: \"${v_gcp} ${v_arg1}\"" 2
  gcp_parallel_wait
  echoDebug "Starting: \"${v_gcp} ${v_arg1}\""
  set +e
  eval "timeout ${v_gcp_timeout} ${v_gcp} ${v_arg1}"
  v_ret=$?
  set -e
  [ $v_ret -ne 0 ] && echoDebug "Command failed: \"${v_gcp} ${v_arg1}\". Return code: $v_ret"
  echoDebug "Finished: \"${v_gcp} ${v_arg1}\"" 2
  gcp_parallel_release
  return $v_ret
}

function gcp_parallel_wait ()
{
  ##########
  # This function will check if it there is any slot to execute the gcloud command. If it has, will increase the counter in 1 and continue.
  # Otherwise, it will wait for the slot.
  ##########
  [ -z "${v_tmpfldr}" -o $v_gcp_parallel -le 1 ] && return 0

  local wait_time=3
  local v_parallel_count
  local v_limit=100
  local v_counter=1

  echoDebug "GCP Parallel - Getting slot.." 4
  while :
  do
    create_lock_or_wait parallel_file "${v_tmpfldr_root}"
    read v_parallel_count 2>&- < "${v_parallel_file}" || v_parallel_count=0
    if [ $v_parallel_count -lt $v_gcp_parallel ]
    then
      v_parallel_count=$((v_parallel_count+1))
      echo "${v_parallel_count}" > "${v_parallel_file}"
      echoDebug "GCP Parallel - Counter Increased. Current: $v_parallel_count/$v_gcp_parallel" 4
      remove_lock parallel_file "${v_tmpfldr_root}"
      break
    fi
    echoDebug "GCP Parallel - Waiting ${v_counter}/${v_limit}. Current: $v_parallel_count/$v_gcp_parallel" 9
    remove_lock parallel_file "${v_tmpfldr_root}"
    v_counter=$((v_counter+1))
    if [ ${v_counter} -gt ${v_limit} ]
    then
      create_lock_or_wait parallel_file "${v_tmpfldr_root}"
      echoDebug "GCP Parallel - Wait limit reached: $((v_limit*wait_time)) secs. Force setting v_parallel_count to 0" 4
      echo 0 > "${v_parallel_file}"
      remove_lock parallel_file "${v_tmpfldr_root}"
      break
    fi
    sleep $wait_time
  done
  echoDebug "GCP Parallel - Check Passed." 4
  return 0
}

function gcp_parallel_release ()
{
  ##########
  # This function will decrease the counter gcloud parallel counter in 1 and continue.
  ##########
  [ -z "${v_tmpfldr}" -o $v_gcp_parallel -le 1 ] && return 0

  local v_parallel_count

  echoDebug "GCP Parallel - Releasing slot.." 4
  create_lock_or_wait parallel_file "${v_tmpfldr_root}"
  read v_parallel_count < "${v_parallel_file}"
  v_parallel_count=$((v_parallel_count-1))
  if [ $v_parallel_count -lt 0 ]
  then
    echoDebug "GCP Parallel - Negative value detected. Force setting v_parallel_count to 0" 4
    v_parallel_count=0
  fi
  echo $v_parallel_count > "${v_parallel_file}"
  echoDebug "GCP Parallel - Counter Descreased. Current: $v_parallel_count/$v_gcp_parallel" 4
  remove_lock parallel_file "${v_tmpfldr_root}"
  return 0
}

################################################
################# OPTION LIST ##################
################################################

# Structure:
# 1st - Json Function Name.
# 2nd - Json Target File Name. Used when ALL parameter is passed to the shell.
# 3rd - Function to call. Can be one off the generics above or a custom one.
# 4th - gcloud command line to be executed.

# DON'T REMOVE/CHANGE THOSE COMMENTS. THEY ARE USED TO GENERATE DYNAMIC FUNCTIONS

# BEGIN DYNFUNC
# access-context-manager-cloud-bindings,gcp_access-context-manager-cloud-bindings.json,jsonSimple,"access-context-manager cloud-bindings list"
# access-context-manager-levels-conditions,gcp_access-context-manager-levels-conditions.json,jsonSimple,"access-context-manager levels conditions list"
# access-context-manager-levels,gcp_access-context-manager-levels.json,jsonSimple,"access-context-manager levels list"
# access-context-manager-perimeters-dry-run,gcp_access-context-manager-perimeters-dry-run.json,jsonSimple,"access-context-manager perimeters dry-run list"
# access-context-manager-perimeters,gcp_access-context-manager-perimeters.json,jsonSimple,"access-context-manager perimeters list"
# access-context-manager-policies,gcp_access-context-manager-policies.json,jsonSimple,"access-context-manager policies list"
# active-directory-domains,gcp_active-directory-domains.json,jsonSimple,"active-directory domains list"
# ai-platform-jobs,gcp_ai-platform-jobs.json,jsonSimple,"ai-platform jobs list"
# ai-platform-models,gcp_ai-platform-models.json,jsonSimple,"ai-platform models list"
# ai-platform-versions,gcp_ai-platform-versions.json,jsonSimple,"ai-platform versions list"
# apigee-apis,gcp_apigee-apis.json,jsonSimple,"apigee apis list"
# apigee-applications,gcp_apigee-applications.json,jsonSimple,"apigee applications list"
# apigee-deployments,gcp_apigee-deployments.json,jsonSimple,"apigee deployments list"
# apigee-developers,gcp_apigee-developers.json,jsonSimple,"apigee developers list"
# apigee-environments,gcp_apigee-environments.json,jsonSimple,"apigee environments list"
# apigee-organizations,gcp_apigee-organizations.json,jsonSimple,"apigee organizations list"
# apigee-products,gcp_apigee-products.json,jsonSimple,"apigee products list"
# app-domain-mappings,gcp_app-domain-mappings.json,jsonSimple,"app domain-mappings list"
# app-firewall-rules,gcp_app-firewall-rules.json,jsonSimple,"app firewall-rules list"
# app-instances,gcp_app-instances.json,jsonSimple,"app instances list"
# app-regions,gcp_app-regions.json,jsonSimple,"app regions list"
# app-services,gcp_app-services.json,jsonSimple,"app services list"
# app-ssl-certificates,gcp_app-ssl-certificates.json,jsonSimple,"app ssl-certificates list"
# app-versions,gcp_app-versions.json,jsonSimple,"app versions list"
# artifacts-docker-images,gcp_artifacts-docker-images.json,jsonSimple,"artifacts docker images list"
# artifacts-docker-tags,gcp_artifacts-docker-tags.json,jsonSimple,"artifacts docker tags list"
# artifacts-locations,gcp_artifacts-locations.json,jsonSimple,"artifacts locations list"
# artifacts-packages,gcp_artifacts-packages.json,jsonSimple,"artifacts packages list"
# artifacts-repositories,gcp_artifacts-repositories.json,jsonSimple,"artifacts repositories list"
# artifacts-tags,gcp_artifacts-tags.json,jsonSimple,"artifacts tags list"
# artifacts-versions,gcp_artifacts-versions.json,jsonSimple,"artifacts versions list"
# asset-feeds,gcp_asset-feeds.json,jsonSimple,"asset feeds list"
# auth,gcp_auth.json,jsonSimple,"auth list"
# bigtable-app-profiles,gcp_bigtable-app-profiles.json,jsonSimple,"bigtable app-profiles list"
# bigtable-backups,gcp_bigtable-backups.json,jsonSimple,"bigtable backups list"
# bigtable-clusters,gcp_bigtable-clusters.json,jsonSimple,"bigtable clusters list"
# bigtable-instances-tables,gcp_bigtable-instances-tables.json,jsonSimple,"bigtable instances tables list"
# bigtable-instances,gcp_bigtable-instances.json,jsonSimple,"bigtable instances list"
# billing-budgets,gcp_billing-budgets.json,jsonSimple,"billing budgets list"
# builds,gcp_builds.json,jsonSimple,"builds list"
# components-repositories,gcp_components-repositories.json,jsonSimple,"components repositories list"
# components,gcp_components.json,jsonSimple,"components list"
# composer-environments-storage-dags,gcp_composer-environments-storage-dags.json,jsonSimple,"composer environments storage dags list"
# composer-environments-storage-data,gcp_composer-environments-storage-data.json,jsonSimple,"composer environments storage data list"
# composer-environments-storage-plugins,gcp_composer-environments-storage-plugins.json,jsonSimple,"composer environments storage plugins list"
# composer-environments,gcp_composer-environments.json,jsonSimple,"composer environments list"
# compute-accelerator-types,gcp_compute-accelerator-types.json,jsonSimple,"compute accelerator-types list"
# compute-addresses,gcp_compute-addresses.json,jsonSimple,"compute addresses list"
# compute-backend-buckets,gcp_compute-backend-buckets.json,jsonSimple,"compute backend-buckets list"
# compute-backend-services,gcp_compute-backend-services.json,jsonSimple,"compute backend-services list"
# compute-commitments,gcp_compute-commitments.json,jsonSimple,"compute commitments list"
# compute-disk-types,gcp_compute-disk-types.json,jsonSimple,"compute disk-types list"
# compute-disks,gcp_compute-disks.json,jsonSimple,"compute disks list"
# compute-external-vpn-gateways,gcp_compute-external-vpn-gateways.json,jsonSimple,"compute external-vpn-gateways list"
# compute-firewall-rules,gcp_compute-firewall-rules.json,jsonSimple,"compute firewall-rules list"
# compute-forwarding-rules,gcp_compute-forwarding-rules.json,jsonSimple,"compute forwarding-rules list"
# compute-health-checks,gcp_compute-health-checks.json,jsonSimple,"compute health-checks list"
# compute-http-health-checks,gcp_compute-http-health-checks.json,jsonSimple,"compute http-health-checks list"
# compute-https-health-checks,gcp_compute-https-health-checks.json,jsonSimple,"compute https-health-checks list"
# compute-images,gcp_compute-images.json,jsonSimple,"compute images list"
# compute-instance-groups-managed-instance-configs,gcp_compute-instance-groups-managed-instance-configs.json,jsonSimple,"compute instance-groups managed instance-configs list"
# compute-instance-groups-managed,gcp_compute-instance-groups-managed.json,jsonSimple,"compute instance-groups managed list"
# compute-instance-groups-unmanaged,gcp_compute-instance-groups-unmanaged.json,jsonSimple,"compute instance-groups unmanaged list"
# compute-instance-groups,gcp_compute-instance-groups.json,jsonSimple,"compute instance-groups list"
# compute-instance-templates,gcp_compute-instance-templates.json,jsonSimple,"compute instance-templates list"
# compute-instances,gcp_compute-instances.json,jsonSimple,"compute instances list"
# compute-interconnects-attachments,gcp_compute-interconnects-attachments.json,jsonSimple,"compute interconnects attachments list"
# compute-interconnects-locations,gcp_compute-interconnects-locations.json,jsonSimple,"compute interconnects locations list"
# compute-interconnects,gcp_compute-interconnects.json,jsonSimple,"compute interconnects list"
# compute-machine-types,gcp_compute-machine-types.json,jsonSimple,"compute machine-types list"
# compute-network-endpoint-groups,gcp_compute-network-endpoint-groups.json,jsonSimple,"compute network-endpoint-groups list"
# compute-networks-peerings,gcp_compute-networks-peerings.json,jsonSimple,"compute networks peerings list"
# compute-networks-subnets,gcp_compute-networks-subnets.json,jsonSimple,"compute networks subnets list"
# compute-networks-vpc-access-connectors,gcp_compute-networks-vpc-access-connectors.json,jsonSimple,"compute networks vpc-access connectors list"
# compute-networks-vpc-access-locations,gcp_compute-networks-vpc-access-locations.json,jsonSimple,"compute networks vpc-access locations list"
# compute-networks,gcp_compute-networks.json,jsonSimple,"compute networks list"
# compute-os-config-patch-deployments,gcp_compute-os-config-patch-deployments.json,jsonSimple,"compute os-config patch-deployments list"
# compute-os-config-patch-jobs,gcp_compute-os-config-patch-jobs.json,jsonSimple,"compute os-config patch-jobs list"
# compute-os-login-ssh-keys,gcp_compute-os-login-ssh-keys.json,jsonSimple,"compute os-login ssh-keys list"
# compute-packet-mirrorings,gcp_compute-packet-mirrorings.json,jsonSimple,"compute packet-mirrorings list"
# compute-project-info,gcp_compute-project-info.json,jsonSimple,"compute project-info describe"
# compute-regions,gcp_compute-regions.json,jsonSimple,"compute regions list"
# compute-reservations,gcp_compute-reservations.json,jsonSimple,"compute reservations list"
# compute-resource-policies,gcp_compute-resource-policies.json,jsonSimple,"compute resource-policies list"
# compute-routers-nats,gcp_compute-routers-nats.json,jsonSimple,"compute routers nats list"
# compute-routers,gcp_compute-routers.json,jsonSimple,"compute routers list"
# compute-routes,gcp_compute-routes.json,jsonSimple,"compute routes list"
# compute-security-policies,gcp_compute-security-policies.json,jsonSimple,"compute security-policies list"
# compute-shared-vpc-associated-projects,gcp_compute-shared-vpc-associated-projects.json,jsonSimple,"compute shared-vpc associated-projects list"
# compute-snapshots,gcp_compute-snapshots.json,jsonSimple,"compute snapshots list"
# compute-sole-tenancy-node-groups,gcp_compute-sole-tenancy-node-groups.json,jsonSimple,"compute sole-tenancy node-groups list"
# compute-sole-tenancy-node-templates,gcp_compute-sole-tenancy-node-templates.json,jsonSimple,"compute sole-tenancy node-templates list"
# compute-sole-tenancy-node-types,gcp_compute-sole-tenancy-node-types.json,jsonSimple,"compute sole-tenancy node-types list"
# compute-ssl-certificates,gcp_compute-ssl-certificates.json,jsonSimple,"compute ssl-certificates list"
# compute-ssl-policies,gcp_compute-ssl-policies.json,jsonSimple,"compute ssl-policies list"
# compute-target-grpc-proxies,gcp_compute-target-grpc-proxies.json,jsonSimple,"compute target-grpc-proxies list"
# compute-target-http-proxies,gcp_compute-target-http-proxies.json,jsonSimple,"compute target-http-proxies list"
# compute-target-https-proxies,gcp_compute-target-https-proxies.json,jsonSimple,"compute target-https-proxies list"
# compute-target-instances,gcp_compute-target-instances.json,jsonSimple,"compute target-instances list"
# compute-target-pools,gcp_compute-target-pools.json,jsonSimple,"compute target-pools list"
# compute-target-ssl-proxies,gcp_compute-target-ssl-proxies.json,jsonSimple,"compute target-ssl-proxies list"
# compute-target-tcp-proxies,gcp_compute-target-tcp-proxies.json,jsonSimple,"compute target-tcp-proxies list"
# compute-target-vpn-gateways,gcp_compute-target-vpn-gateways.json,jsonSimple,"compute target-vpn-gateways list"
# compute-tpus-accelerator-types,gcp_compute-tpus-accelerator-types.json,jsonSimple,"compute tpus accelerator-types list"
# compute-tpus-locations,gcp_compute-tpus-locations.json,jsonSimple,"compute tpus locations list"
# compute-tpus-versions,gcp_compute-tpus-versions.json,jsonSimple,"compute tpus versions list"
# compute-tpus,gcp_compute-tpus.json,jsonSimple,"compute tpus list"
# compute-url-maps,gcp_compute-url-maps.json,jsonSimple,"compute url-maps list"
# compute-vpn-gateways,gcp_compute-vpn-gateways.json,jsonSimple,"compute vpn-gateways list"
# compute-vpn-tunnels,gcp_compute-vpn-tunnels.json,jsonSimple,"compute vpn-tunnels list"
# compute-zones,gcp_compute-zones.json,jsonSimple,"compute zones list"
# config-configurations,gcp_config-configurations.json,jsonSimple,"config configurations list"
# config,gcp_config.json,jsonSimple,"config list"
# container-binauthz-attestations,gcp_container-binauthz-attestations.json,jsonSimple,"container binauthz attestations list"
# container-binauthz-attestors,gcp_container-binauthz-attestors.json,jsonSimple,"container binauthz attestors list"
# container-clusters,gcp_container-clusters.json,jsonSimple,"container clusters list"
# container-hub-memberships,gcp_container-hub-memberships.json,jsonSimple,"container hub memberships list"
# container-images,gcp_container-images.json,jsonSimple,"container images list"
# container-node-pools,gcp_container-node-pools.json,jsonSimple,"container node-pools list"
# data-catalog-entries,gcp_data-catalog-entries.json,jsonSimple,"data-catalog entries list"
# data-catalog-entry-groups,gcp_data-catalog-entry-groups.json,jsonSimple,"data-catalog entry-groups list"
# data-catalog-tags,gcp_data-catalog-tags.json,jsonSimple,"data-catalog tags list"
# data-catalog-taxonomies-policy-tags,gcp_data-catalog-taxonomies-policy-tags.json,jsonSimple,"data-catalog taxonomies policy-tags list"
# data-catalog-taxonomies,gcp_data-catalog-taxonomies.json,jsonSimple,"data-catalog taxonomies list"
# dataflow-jobs,gcp_dataflow-jobs.json,jsonSimple,"dataflow jobs list"
# dataproc-autoscaling-policies,gcp_dataproc-autoscaling-policies.json,jsonSimple,"dataproc autoscaling-policies list"
# dataproc-clusters,gcp_dataproc-clusters.json,jsonSimple,"dataproc clusters list"
# dataproc-jobs,gcp_dataproc-jobs.json,jsonSimple,"dataproc jobs list"
# dataproc-workflow-templates,gcp_dataproc-workflow-templates.json,jsonSimple,"dataproc workflow-templates list"
# datastore-indexes,gcp_datastore-indexes.json,jsonSimple,"datastore indexes list"
# debug-logpoints,gcp_debug-logpoints.json,jsonSimple,"debug logpoints list"
# debug-snapshots,gcp_debug-snapshots.json,jsonSimple,"debug snapshots list"
# debug-targets,gcp_debug-targets.json,jsonSimple,"debug targets list"
# deployment-manager-deployments,gcp_deployment-manager-deployments.json,jsonSimple,"deployment-manager deployments list"
# deployment-manager-manifests,gcp_deployment-manager-manifests.json,jsonSimple,"deployment-manager manifests list"
# deployment-manager-resources,gcp_deployment-manager-resources.json,jsonSimple,"deployment-manager resources list"
# deployment-manager-types,gcp_deployment-manager-types.json,jsonSimple,"deployment-manager types list"
# dns-dns-keys,gcp_dns-dns-keys.json,jsonGenericMaster,"dns dns-keys list" "dns-managed-zones" "name:zone" "jsonSimple"
# dns-domains-list-user-verified,gcp_dns-domains-list-user-verified.json,jsonSimple,"dns domains list-user-verified"
# dns-managed-zones,gcp_dns-managed-zones.json,jsonSimple,"dns managed-zones list"
# dns-policies,gcp_dns-policies.json,jsonSimple,"dns policies list"
# dns-project-info,gcp_dns-project-info.json,jsonSimple,"dns project-info describe"
# dns-record-sets-changes,gcp_dns-record-sets-changes.json,jsonSimple,"dns record-sets changes list"
# dns-record-sets,gcp_dns-record-sets.json,jsonGenericMaster,"dns record-sets list" "dns-managed-zones" "name:zone" "jsonSimple"
# endpoints-configs,gcp_endpoints-configs.json,jsonSimple,"endpoints configs list"
# endpoints-services,gcp_endpoints-services.json,jsonSimple,"endpoints services list"
# eventarc-triggers,gcp_eventarc-triggers.json,jsonSimple,"eventarc triggers list"
# filestore-instances,gcp_filestore-instances.json,jsonSimple,"filestore instances list"
# filestore-locations,gcp_filestore-locations.json,jsonSimple,"filestore locations list"
# filestore-regions,gcp_filestore-regions.json,jsonSimple,"filestore regions list"
# filestore-zones,gcp_filestore-zones.json,jsonSimple,"filestore zones list"
# firebase-test-android-locales,gcp_firebase-test-android-locales.json,jsonSimple,"firebase test android locales list"
# firebase-test-android-models,gcp_firebase-test-android-models.json,jsonSimple,"firebase test android models list"
# firebase-test-android-versions,gcp_firebase-test-android-versions.json,jsonSimple,"firebase test android versions list"
# firebase-test-ios-locales,gcp_firebase-test-ios-locales.json,jsonSimple,"firebase test ios locales list"
# firebase-test-ios-models,gcp_firebase-test-ios-models.json,jsonSimple,"firebase test ios models list"
# firebase-test-ios-versions,gcp_firebase-test-ios-versions.json,jsonSimple,"firebase test ios versions list"
# firebase-test-network-profiles,gcp_firebase-test-network-profiles.json,jsonSimple,"firebase test network-profiles list"
# firestore-indexes-composite,gcp_firestore-indexes-composite.json,jsonSimple,"firestore indexes composite list"
# firestore-indexes-fields,gcp_firestore-indexes-fields.json,jsonSimple,"firestore indexes fields list"
# functions-event-types,gcp_functions-event-types.json,jsonSimple,"functions event-types list"
# functions-regions,gcp_functions-regions.json,jsonSimple,"functions regions list"
# functions,gcp_functions.json,jsonSimple,"functions list"
# game-locations,gcp_game-locations.json,jsonSimple,"game locations list"
# game-servers-clusters,gcp_game-servers-clusters.json,jsonSimple,"game servers clusters list"
# game-servers-configs,gcp_game-servers-configs.json,jsonSimple,"game servers configs list"
# game-servers-deployments,gcp_game-servers-deployments.json,jsonSimple,"game servers deployments list"
# game-servers-realms,gcp_game-servers-realms.json,jsonSimple,"game servers realms list"
# healthcare-datasets,gcp_healthcare-datasets.json,jsonSimple,"healthcare datasets list"
# healthcare-dicom-stores,gcp_healthcare-dicom-stores.json,jsonSimple,"healthcare dicom-stores list"
# healthcare-fhir-stores,gcp_healthcare-fhir-stores.json,jsonSimple,"healthcare fhir-stores list"
# healthcare-hl7v2-stores,gcp_healthcare-hl7v2-stores.json,jsonSimple,"healthcare hl7v2-stores list"
# iam-roles,gcp_iam-roles.json,jsonSimple,"iam roles list"
# iam-service-accounts-keys,gcp_iam-service-accounts-keys.json,jsonSimple,"iam service-accounts keys list"
# iam-service-accounts,gcp_iam-service-accounts.json,jsonSimple,"iam service-accounts list"
# iam-workload-identity-pools-providers,gcp_iam-workload-identity-pools-providers.json,jsonSimple,"iam workload-identity-pools providers list"
# iam-workload-identity-pools,gcp_iam-workload-identity-pools.json,jsonSimple,"iam workload-identity-pools list"
# identity-groups-memberships,gcp_identity-groups-memberships.json,jsonSimple,"identity groups memberships list"
# iot-devices-configs,gcp_iot-devices-configs.json,jsonSimple,"iot devices configs list"
# iot-devices-credentials,gcp_iot-devices-credentials.json,jsonSimple,"iot devices credentials list"
# iot-devices-states,gcp_iot-devices-states.json,jsonSimple,"iot devices states list"
# iot-devices,gcp_iot-devices.json,jsonSimple,"iot devices list"
# iot-registries-credentials,gcp_iot-registries-credentials.json,jsonSimple,"iot registries credentials list"
# iot-registries,gcp_iot-registries.json,jsonSimple,"iot registries list"
# kms-import-jobs,gcp_kms-import-jobs.json,jsonSimple,"kms import-jobs list"
# kms-keyrings,gcp_kms-keyrings.json,jsonSimple,"kms keyrings list"
# kms-keys-versions,gcp_kms-keys-versions.json,jsonSimple,"kms keys versions list"
# kms-keys,gcp_kms-keys.json,jsonSimple,"kms keys list"
# kms-locations,gcp_kms-locations.json,jsonSimple,"kms locations list"
# logging-logs,gcp_logging-logs.json,jsonSimple,"logging logs list"
# logging-metrics,gcp_logging-metrics.json,jsonSimple,"logging metrics list"
# logging-resource-descriptors,gcp_logging-resource-descriptors.json,jsonSimple,"logging resource-descriptors list"
# logging-sinks,gcp_logging-sinks.json,jsonSimple,"logging sinks list"
# meta-apis-collections,gcp_meta-apis-collections.json,jsonSimple,"meta apis collections list"
# meta-apis-discovery,gcp_meta-apis-discovery.json,jsonSimple,"meta apis discovery list"
# meta-apis-messages,gcp_meta-apis-messages.json,jsonSimple,"meta apis messages list"
# meta-apis-methods,gcp_meta-apis-methods.json,jsonSimple,"meta apis methods list"
# meta-apis,gcp_meta-apis.json,jsonSimple,"meta apis list"
# meta-cache-completers,gcp_meta-cache-completers.json,jsonSimple,"meta cache completers list"
# meta-cache,gcp_meta-cache.json,jsonSimple,"meta cache list"
# meta-cli-trees,gcp_meta-cli-trees.json,jsonSimple,"meta cli-trees list"
# ml-engine-jobs,gcp_ml-engine-jobs.json,jsonSimple,"ml-engine jobs list"
# ml-engine-models,gcp_ml-engine-models.json,jsonSimple,"ml-engine models list"
# ml-engine-versions,gcp_ml-engine-versions.json,jsonSimple,"ml-engine versions list"
# monitoring-dashboards,gcp_monitoring-dashboards.json,jsonSimple,"monitoring dashboards list"
# network-management-connectivity-tests,gcp_network-management-connectivity-tests.json,jsonSimple,"network-management connectivity-tests list"
# organizations,gcp_organizations.json,jsonSimple,"organizations list"
# projects,gcp_projects.json,jsonSimple,"projects list"
# pubsub-lite-subscriptions,gcp_pubsub-lite-subscriptions.json,jsonSimple,"pubsub lite-subscriptions list"
# pubsub-lite-topics,gcp_pubsub-lite-topics.json,jsonSimple,"pubsub lite-topics list"
# pubsub-snapshots,gcp_pubsub-snapshots.json,jsonSimple,"pubsub snapshots list"
# pubsub-subscriptions,gcp_pubsub-subscriptions.json,jsonSimple,"pubsub subscriptions list"
# pubsub-topics,gcp_pubsub-topics.json,jsonSimple,"pubsub topics list"
# recommender-insights,gcp_recommender-insights.json,jsonSimple,"recommender insights list"
# recommender-recommendations,gcp_recommender-recommendations.json,jsonSimple,"recommender recommendations list"
# redis-instances,gcp_redis-instances.json,jsonSimple,"redis instances list"
# redis-regions,gcp_redis-regions.json,jsonSimple,"redis regions list"
# redis-zones,gcp_redis-zones.json,jsonSimple,"redis zones list"
# resource-manager-folders,gcp_resource-manager-folders.json,jsonSimple,"resource-manager folders list"
# resource-manager-org-policies,gcp_resource-manager-org-policies.json,jsonSimple,"resource-manager org-policies list"
# run-configurations,gcp_run-configurations.json,jsonSimple,"run configurations list"
# run-domain-mappings,gcp_run-domain-mappings.json,jsonSimple,"run domain-mappings list"
# run-regions,gcp_run-regions.json,jsonSimple,"run regions list"
# run-revisions,gcp_run-revisions.json,jsonSimple,"run revisions list"
# run-routes,gcp_run-routes.json,jsonSimple,"run routes list"
# run-services,gcp_run-services.json,jsonSimple,"run services list"
# scc-assets,gcp_scc-assets.json,jsonSimple,"scc assets list"
# scc-findings,gcp_scc-findings.json,jsonSimple,"scc findings list"
# scc-notifications,gcp_scc-notifications.json,jsonSimple,"scc notifications list"
# scheduler-jobs,gcp_scheduler-jobs.json,jsonSimple,"scheduler jobs list"
# secrets-locations,gcp_secrets-locations.json,jsonSimple,"secrets locations list"
# secrets-versions,gcp_secrets-versions.json,jsonSimple,"secrets versions list"
# secrets,gcp_secrets.json,jsonSimple,"secrets list"
# service-directory-endpoints,gcp_service-directory-endpoints.json,jsonSimple,"service-directory endpoints list"
# service-directory-locations,gcp_service-directory-locations.json,jsonSimple,"service-directory locations list"
# service-directory-namespaces,gcp_service-directory-namespaces.json,jsonSimple,"service-directory namespaces list"
# service-directory-services,gcp_service-directory-services.json,jsonSimple,"service-directory services list"
# services-peered-dns-domains,gcp_services-peered-dns-domains.json,jsonSimple,"services peered-dns-domains list"
# services-vpc-peerings,gcp_services-vpc-peerings.json,jsonSimple,"services vpc-peerings list"
# services,gcp_services.json,jsonSimple,"services list"
# source-repos,gcp_source-repos.json,jsonSimple,"source repos list"
# spanner-backups,gcp_spanner-backups.json,jsonSimple,"spanner backups list"
# spanner-databases-sessions,gcp_spanner-databases-sessions.json,jsonSimple,"spanner databases sessions list"
# spanner-databases,gcp_spanner-databases.json,jsonSimple,"spanner databases list"
# spanner-instance-configs,gcp_spanner-instance-configs.json,jsonSimple,"spanner instance-configs list"
# spanner-instances,gcp_spanner-instances.json,jsonSimple,"spanner instances list"
# sql-backups,gcp_sql-backups.json,jsonSimple,"sql backups list"
# sql-databases,gcp_sql-databases.json,jsonSimple,"sql databases list"
# sql-flags,gcp_sql-flags.json,jsonSimple,"sql flags list"
# sql-instances,gcp_sql-instances.json,jsonSimple,"sql instances list"
# sql-ssl-certs,gcp_sql-ssl-certs.json,jsonSimple,"sql ssl-certs list"
# sql-ssl-client-certs,gcp_sql-ssl-client-certs.json,jsonSimple,"sql ssl client-certs list"
# sql-tiers,gcp_sql-tiers.json,jsonSimple,"sql tiers list"
# sql-users,gcp_sql-users.json,jsonSimple,"sql users list"
# tasks-locations,gcp_tasks-locations.json,jsonSimple,"tasks locations list"
# tasks-queues,gcp_tasks-queues.json,jsonSimple,"tasks queues list"
# tasks,gcp_tasks.json,jsonSimple,"tasks list"
# workspace-add-ons-deployments,gcp_workspace-add-ons-deployments.json,jsonSimple,"workspace-add-ons deployments list"
# END DYNFUNC

## jq -r '.. | .path? // empty | @csv' data/cli/gcloud.json | grep -E '"list"$'

# The while loop below will create a function for each line above.
# Using File Descriptor 3 to not interfere on "eval"
while read -u 3 -r c_line || [ -n "$c_line" ]
do
  c_name=$(cut -d ',' -f 1 <<< "$c_line")
  c_fname=$(cut -d ',' -f 2 <<< "$c_line")
  c_subfunc=$(cut -d ',' -f 3 <<< "$c_line")
  c_param=$(cut -d ',' -f 4 <<< "$c_line")
  if [ -z "${v_tmpfldr}" ]
  then
    eval "function ${c_name} ()
          {
            set +e
            (${c_subfunc} ${c_param})
            c_ret=\$?
            set -e
            return \${c_ret}
          }"
  else
    eval "function ${c_name} ()
          {
            stopIfProcessed ${c_fname} || return 0
            set +e
            (${c_subfunc} ${c_param} > \${v_tmpfldr}/.${c_fname})
            c_ret=\$?
            set -e
            cat \${v_tmpfldr}/.${c_fname}
            return \${c_ret}
          }"
  fi
done 3< <(echo "$v_func_list")

function stopIfProcessed ()
{
  # If function was executed before, print the output and return error. The dynamic eval function will stop if error is returned.
  local v_arg1="$1"
  [ -n "${v_tmpfldr}" ] || return 0
  if [ -f "${v_tmpfldr}/.${v_arg1}" ]
  then
    cat "${v_tmpfldr}/.${v_arg1}"
    return 1
  else
    return 0
  fi
}

function convertsecs()
{
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}

function runAndZip ()
{
  [ "$#" -eq 3 -a "$1" != "" -a "$2" != "" -a "$3" != "" ] || { echoError "${FUNCNAME[0]} needs 3 parameters"; return 1; }
  local v_arg1 v_arg2 v_arg3 v_ret v_time_begin v_time_end
  v_arg1="$1"
  v_arg2="$2"
  v_arg3="$3"
  [ -z "${v_project}" ] && echo -n "Processing \"${v_arg2}\" (${v_arg3}/${v_lsize})."
  [ -n "${v_project}" ] && echo "Processing \"${v_arg2}\" in ${v_project} (${v_arg3}/${v_lsize})."
  v_time_begin=$SECONDS
  set +e
  (${v_arg1} > "${v_arg2}" 2> "${v_arg2}.err")
  v_ret=$?
  set -e
  v_time_end=$SECONDS
  [ -z "${v_project}" ] && echo " Elapsed time: $(convertsecs $((v_time_end-v_time_begin)))."
  [ -n "${v_project}" ] && echo "Finished \"${v_arg2}\" in ${v_project}. Elapsed time: $(convertsecs $((v_time_end-v_time_begin)))."
  if [ $v_ret -eq 0 ]
  then
    if [ -s "${v_arg2}.err" ]
    then
      mv "${v_arg2}.err" "${v_arg2}.log"
      ${v_zip} -qm "$v_outfile" "${v_arg2}.log"
    fi
  else
    if [ -f "${v_arg2}.err" ]
    then
      echo "Skipped. Check \"${v_arg2}.err\" for more details."
      ${v_zip} -qm "$v_outfile" "${v_arg2}.err"
    fi
  fi
  [ ! -f "${v_arg2}.err" ] || rm -f "${v_arg2}.err"
  if [ -s "${v_arg2}" ]
  then
    ${v_zip} -qm "$v_outfile" "${v_arg2}"
  else
    rm -f "${v_arg2}"
  fi
}

if ! $(which flock >&- 2>&-)
then

  function create_lock_or_wait ()
  {
    [ -z "$1" -o -z "${v_tmpfldr}" ] && return 0
    local v_lock_name="$1"
    local v_dest_folder="$2"
    local wait_time=1
    local v_ret
    [ -z "${v_dest_folder}" ] && v_dest_folder="${v_tmpfldr}"
    [ -z "${v_dest_folder}" ] && v_msg="${v_lock_name}" || v_msg="${v_lock_name} (ROOT)"
    echoDebug "${v_msg} - Locking.." 10
    while :
    do
      mkdir "${v_dest_folder}/.${v_lock_name}.lock.d" 2>&- && v_ret=$? || v_ret=$?
      [ $v_ret -eq 0 ] && break
      sleep $wait_time
      echoDebug "${v_msg} - Waiting.." 10
    done
    echoDebug "${v_msg} - Locked" 10
    return 0
  }
  
  function remove_lock ()
  {
    [ -z "$1" -o -z "${v_tmpfldr}" ] && return 0
    local v_lock_name="$1"
    local v_dest_folder="$2"
    [ -z "${v_dest_folder}" ] && v_dest_folder="${v_tmpfldr}"
    [ -z "${v_dest_folder}" ] && v_msg="${v_lock_name}" || v_msg="${v_lock_name} (ROOT)"
    echoDebug "${v_msg} - Unlocking.." 10
    rmdir "${v_dest_folder}/.${v_lock_name}.lock.d"
    echoDebug "${v_msg} - Unlocked" 10
    return 0
  }

  echoDebug "Parallel semaphore method: mkdir" 3

else

  function create_lock_or_wait ()
  {
    [ -z "$1" -o -z "${v_tmpfldr}" ] && return 0
    local v_lock_name="$1"
    local v_dest_folder="$2"
    local wait_time=1
    local v_ret
    [ -z "${v_dest_folder}" ] && v_dest_folder="${v_tmpfldr}"
    [ -z "${v_dest_folder}" ] && v_msg="${v_lock_name}" || v_msg="${v_lock_name} (ROOT)"
    echoDebug "${v_msg} - Locking.." 10
    exec 7>"${v_dest_folder}/.${v_lock_name}.lock.d"
    flock -x 7
    echoDebug "${v_msg} - Locked" 10
    return 0
  }
  
  function remove_lock ()
  {
    [ -z "$1" -o -z "${v_tmpfldr}" ] && return 0
    local v_lock_name="$1"
    local v_dest_folder="$2"
    [ -z "${v_dest_folder}" ] && v_dest_folder="${v_tmpfldr}"
    [ -z "${v_dest_folder}" ] && v_msg="${v_lock_name}" || v_msg="${v_lock_name} (ROOT)"
    echoDebug "${v_msg} - Unlocking.." 10
    exec 7>&-
    echoDebug "${v_msg} - Unlocked" 10
    return 0
  }

  echoDebug "Parallel semaphore method: flock" 3

fi


function cleanTmpFiles ()
{
  # TODO: PRINT FILES IN DEBUG BEFORE REMOVING.
  [ -n "${v_tmpfldr}" ] && rm -f "${v_tmpfldr}"/.*.json 2>&- || true
  [ -n "${v_tmpfldr}" ] && rm -f "${v_tmpfldr}"/*.out 2>&- || true
  [ -n "${v_tmpfldr}" ] && rm -f "${v_tmpfldr}"/*.err 2>&- || true
  [ -f "${v_parallel_file}" ] && rm -f "${v_parallel_file}" 2>&- || true
  return 0
}

function main ()
{
  # If ALL or ALL_PROJECTS, loop over all defined options.
  local c_line c_name c_file
  if [ "${v_param1}" != "ALL" -a "${v_param1}" != "ALL_PROJECTS" ]
  then
    set +e
    ${v_param1}
    v_ret=$?
    set -e
  else
    [ -n "$v_outfile" ] || v_outfile="${v_this_script%.*}_$(date '+%Y%m%d%H%M%S').zip"
    v_lsize=$(echo "$v_func_list" | wc -l)
    c_counter=1
    while read -u 3 -r c_line || [ -n "$c_line" ]
    do
       c_name=$(cut -d ',' -f 1 <<< "$c_line")
       c_file=$(cut -d ',' -f 2 <<< "$c_line")
       [ -n "${GCP_JSON_INCLUDE}" ] && [[ ",${GCP_JSON_INCLUDE}," != *",${c_name},"* ]] && continue
       [ -n "${GCP_JSON_EXCLUDE}" ] && [[ ",${GCP_JSON_EXCLUDE}," = *",${c_name},"* ]] && continue
       runAndZip $c_name $c_file $c_counter
       c_counter=$((c_counter+1))
    done 3< <(echo "$v_func_list")
    v_ret=0
  fi
}

# Start code execution. If ALL_PROJECTS, call main for each project.
echoDebug "BEGIN"
cleanTmpFiles
if [ "${v_param1}" == "ALL_PROJECTS" ]
then
  l_projects=$(projects | ${v_jq} -r '.[]."projectId"')
  v_gcp_orig="$v_gcp"
  v_outfile_pref="${v_this_script%.*}_$(date '+%Y%m%d%H%M%S')"
  v_psize=$(echo "$l_projects" | wc -l)
  if [ ${v_psize} -gt 1 ]
  then
    for v_project in $l_projects
    do
      echo "Starting project \"${v_project}\"."
      v_gcp="${v_gcp_orig} --project ${v_project}"
      v_outfile="${v_outfile_pref}_${v_project}.zip"
      [ -n "${v_tmpfldr_root}" ] && { v_tmpfldr="${v_tmpfldr_root}/${v_project}"; mkdir "${v_tmpfldr}"; }
      mkdir ${v_project} 2>&- || true
      cd ${v_project}
      main &
      v_pids+=(${v_project}::$!)
      cd ..
    done
    for v_reg_ind in "${v_pids[@]}"
    do
        v_project="${v_reg_ind%%::*}"
        wait ${v_reg_ind##*::}
        [ -z "${v_project}" ] && echoError "v_project is empty." && continue
        mv ${v_project}/* ./
        rmdir ${v_project}
        [ -n "${v_tmpfldr_root}" ] && { v_tmpfldr="${v_tmpfldr_root}/${v_project}"; cleanTmpFiles; rmdir "${v_tmpfldr}"; }
    done
    v_tmpfldr="${v_tmpfldr_root}"
    echo "Export finished."
  elif [ ${v_psize} -eq 1 -a -n "$l_projects" ]
  then
    echo "Running in a single subscribed project \"$l_projects\"."
    v_gcp="${v_gcp_orig} --project ${l_projects}"
    v_outfile="${v_outfile_pref}_${l_projects}.zip"
    main
    echo "Export finished."
  else
    echoError "Problem detecting subscribed projects. Output: $l_projects."
  fi
else
  main
fi
cleanTmpFiles
echoDebug "END"

[ -f "${v_this_script%.*}.log" -a "${v_param1}" == "ALL_PROJECTS" ] && { mv "${v_this_script%.*}.log" "${v_this_script%.*}.full.log"; ${v_zip} -qm "$v_outfile" "${v_this_script%.*}.full.log"; }
[ -f "${v_this_script%.*}.log" -a -f "$v_outfile" ] && ${v_zip} -qm "$v_outfile" "${v_this_script%.*}.log"
[ -n "${v_tmpfldr}" ] && rmdir "${v_tmpfldr}" 2>&- || true

exit ${v_ret}
###