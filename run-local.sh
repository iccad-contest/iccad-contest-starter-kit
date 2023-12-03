# Author: baichen.bai@alibaba-inc.com
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
# run-local.sh is a demo to demonstrate the usage of the ICCAD contest platform.


#!/bin/bash


set -o pipefail


submissions="example-submissions"
optimizer=${optimizer:-"random-search-optimizer"}
uuid=${uuid:-"null"}
solution_setting=${solution_setting:-"null"}


function set_env() {
    function handler() {
        exit 1
    }
    trap 'handler' SIGINT
}


function help() {
   	echo "Run ICCAD Contest Platform Locally."
   	echo
	echo "Usage: ${0} [-h] [-o optimizer] [-u uuid] [-q num-of-queries]"
   	echo "options:"
   	echo "-h     print the help menu."
   	echo "-o     optimizer specification."
	echo "       e.g., '-o cadc4444' specifies the cadc4444 under example-submissions/cadc4444"
	echo "       if you have a JSON configuration file, the script can automatically specify it."
	echo "       NOTICE: the optimizer entry file name should be the same as the folder name under example-submissions."
	echo "-u     uuid specification. (optional)"
   	echo
}


function validate_module() {
	function validate_py_module() {
		module=$1
		python3 -m ${module} > .test 2>&1
		if grep -q "No module named ${module}$" .test; then
			echo "[INFO]: please install requisite python packages: ${module}."
			echo "[INFO]: e.g., pip3 install ${module}"
			exit 1
		fi
		rm -f .test
	}
	validate_py_module iccad_contest
	validate_py_module openpyxl
}


function validate_optimizer() {
	if [[ ! -d ${submissions}/${optimizer} ]]; then
		echo "[ERROR]: your optimizer: ${optimizer} does not exsit under the folder: ${submissions}."
		exit 1
	fi
}


function main() {
	function get_json_if_any() {
		ls -al ${submissions}/${optimizer} | awk '{print $9}' > .list.temp
		cat .list.temp | while read line
		do
			if echo ${line} | grep -q -E '\.json$'; then
				solution_setting=${line}
				echo ${solution_setting}
				break
			fi
		done
		rm -f .list.temp
	}

	validate_module
	validate_optimizer
	solution_setting=$(get_json_if_any)
	num_of_queries=`cat ${submissions}/${optimizer}/num-of-query.txt`
	if [[ ${solution_setting} != "" ]]; then
		if [[ ${uuid} == "null" ]]; then
			set -x
			python3 ${submissions}/${optimizer}/${optimizer}.py \
				-o output \
				-s ${submissions}/${optimizer}/${solution_setting} \
				-q ${num_of_queries}
		else
			set -x
			python3 ${submissions}/${optimizer}/${optimizer}.py \
				-o output \
				-s ${submissions}/${optimizer}/${solution_setting} \
				-u ${uuid} \
				-q ${num_of_queries}
		fi
	else
		if [[ ${uuid} == "null" ]]; then
			set -x
			python3 ${submissions}/${optimizer}/${optimizer}.py -o output -q ${num_of_queries}
		else
			set -x
			python3 ${submissions}/${optimizer}/${optimizer}.py -o output -u ${uuid} -q ${num_of_queries}
		fi
	fi
}


while getopts "ho:u:" arg
do
    case ${arg} in
    	h)
			help
			exit 0
			;;
		u)
			uuid=${OPTARG}
			;;
        o)
            optimizer=${OPTARG}
            ;;
        *)
            echo "[ERROR]: ${arg} is invalid."
            exit
            ;;
    esac
done


set_env
main
