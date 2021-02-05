#!/bin/bash
#************************************************************************
#
#   zip_json_to_csv.sh - Convert all JSONs to CSVs in the zip file.
#
#   Copyright 2018  Rodrigo Jorge <http://www.dbarj.com.br/>
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
# Available at: https://github.com/dbarj/oci-scripts
# Created on: Aug/2018 by Rodrigo Jorge
# Version 1.01
#************************************************************************
set -eou pipefail

# Define paths for oci-cli and jq or put them on $PATH. Don't use relative PATHs in the variables below.
v_json2csv="json2csv"

if [ -z "${BASH_VERSION}" -o "${BASH}" = "/bin/sh" ]
then
  >&2 echo "Script must be executed in BASH shell."
  exit 1
fi

# If MERGE_UNIQUE variable is undefined, change to 1.
# 0 = Output JSON will be simply merged.
# 1 = Output JSON will be returned in sorted order, with duplicates removed.

function echoError ()
{
   (>&2 echo "$1")
}

function exitError ()
{
   echoError "$1"
   exit 1
}

if [ $# -ne 2 ]
then
  echoError "$0: One argument is needed.. given: $#"
  echoError "- 1st param = Input zip file name"
  echoError "- 2nd param = Output zip file name"
  exit 1
fi

v_zip_file_input="$1"
v_zip_file_output="$2"

[ ! -r "${v_zip_file_input}" ] && exitError "Can't find \"${v_zip_file_input}\"."

if ! $(which ${v_json2csv} >&- 2>&-)
then
  echoError "Could not find ${v_json2csv} npm program. Please adapt the path in the script if not in \$PATH."
  echoError "Download page: https://www.npmjs.com/package/json2csv"
  exit 1
fi

if ! $(which zip >&- 2>&-)
then
  echoError "Could not find zip binary. Please include it in \$PATH."
  exit 1
fi

v_json_files=$(unzip -Z -1 "${v_zip_file_input}" "*.json") && v_ret=$? || v_ret=$?
[ $v_ret -eq 0 -o $v_ret -eq 11 ] || exitError "Can't zip list ${v_zip_file_input}"

for v_json_file in $v_json_files
do
  v_csv_file="${v_json_file%.*}.csv"
  unzip -o -q "${v_zip_file_input}" "${v_json_file}" 2>&- || true
  if [ -s "${v_json_file}" ]
  then
    echo "Converting ${v_json_file} into ${v_csv_file}."
    set +e
    ${v_json2csv} -i "${v_json_file}" -o "${v_csv_file}" --unwind --flatten-objects
    set -e
    rm -f "${v_json_file}"
    if [ -f "${v_csv_file}" ]
    then
      gzip "${v_csv_file}"
      zip -qm -9 "$v_zip_file_output" "${v_csv_file}.gz"
    fi
  fi
done

exit 0
###