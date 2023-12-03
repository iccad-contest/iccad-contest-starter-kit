# Author: baichen318@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# prepare-upload.sh is a tool to package your submission for upload.


#!/bin/bash


submissions="example-submissions"
team_name=${team_name:-"null"}


function set_env() {
    function handler() {
        exit 1
    }
    trap 'handler' SIGINT
}


function help() {
   	echo "Prepare Your Submission for Upload."
   	echo
   	echo "Usage: ${0} [-h] [-o optimizer]"
   	echo "options:"
   	echo "-h     print the help menu."
	echo "-t     team name specification."
   	echo
}


function main() {
	if [[ ! -d ${submissions}/${team_name} ]]; then
		echo "[ERROR]: your optimizer: ${team_name} does not exsit under the folder: ${submissions}."
		exit 1
	fi
	if [[ ${team_name} == "null" ]]; then
		echo "[ERROR]: please input your team name with '-t' option."
		exit 1
	fi
	cd ${submissions}/${team_name} && zip -r ../${team_name}.zip ./* > /dev/null 2>&1 && cd - > /dev/null 2>&1
	echo "[INFO]: build the archive: ${submissions}/${team_name}.zip of your submission for upload."
	echo "[INFO]: please upload the archive to http://47.93.191.38/submit/"
	echo "[INFO]: please visit http://47.93.191.38/ranking/ to check the result."
}

while getopts "ht:o:" arg
do
    case ${arg} in
    	h)
			help
			exit 0
			;;
		t)
			team_name=${OPTARG}
			;;
        *)
            echo "[ERROR]: ${arg} is invalid."
            exit
            ;;
    esac
done


set_env
main
