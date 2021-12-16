#!/bin/bash

# The function which prints the usage and exits with a non-zero status

usage () {
    echo "Usage: ${0} [-m MODEL] [p PROJECT_PATH]"
    echo 'Generate the model classes in the spring project'
    echo '     -m MODEL         Specify the model name'
    echo '     -p PROJECT_PATH  Specify the spring project path, including the package.'
    exit 1
}

readonly SCRIPT_PATH=$(dirname "${0}") ; export SCRIPT_PATH
readonly SCRIPT_NAME="$(basename "$0")"

# The function which checks if previously executed command was success, otherwise prints the given arguments as a message to STDERR

check_last_execution () {
    if [[ "${?}" -ne 0 ]]
    then
        echo "${@}" >&2
        exit 1
    fi
}

# Parse the user specified arguments. Check if user specified -m and -p flags only ( These flags are also mandatory )

while getopts "m:p:" OPTION
do
    case $OPTION in
        m) 
            readonly MODEL="${OPTARG^}"
            ;;
        p)
            readonly PROJECT_PATH="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

shift $(( OPTIND-1 ))
if [[ "${#}" -ne 0 || -z "$MODEL" || -z $PROJECT_PATH ]]
then
    usage
fi


# Based on the user given project path, returns the package name excluded. Package name is the path after /java directory
# If this the depth exceedes 4, then consider that package name could not be extracted

get_package_name () {
    local DEPTH=0
    local RESULT=''
    local PACKAGE="${PROJECT_PATH}"
    while [[ "$(basename "${PACKAGE}")" != "java" ]]
    do
        if [[ DEPTH -gt 3 ]]
        then
            echo "${SCRIPT_NAME}: Could not extract the package name" >&2
            exit 1
        fi
        RESULT="$(basename "${PACKAGE}").${RESULT}"
        PACKAGE=$(/usr/bin/dirname "${PACKAGE}")
        DEPTH=$((DEPTH+1))
    done
    RESULT="${RESULT::-1}"
    echo "${RESULT}"
}


# Check if user specified project path exists

if [[ ! -d "${PROJECT_PATH}" ]]
then
    echo "${SCRIPT_NAME}: ${PROJECT_PATH} does not exist"
    exit 1
fi

# The package based on the project path

readonly PACKAGE=$(get_package_name)


# Get the template parser functions, which are exported by template-parsers.sh

source "${SCRIPT_PATH}"/template-parsers.sh

check_last_execution "${SCRIPT_NAME}: some error occured by template parsers"

# Get the general project structure folder paths

readonly FOLDERS=$(cat "${SCRIPT_PATH}"/folder-paths)

check_last_execution "${SCRIPT_NAME}: some error occured by folder paths"


# Checking the project structure

for FOLDER in ${FOLDERS}
do
    case ${FOLDER} in 
        config|util)
            continue
            ;;
        *)
            if [[ ! -d "${PROJECT_PATH}/${FOLDER}" ]]
            then
                echo "${SCRIPT_NAME}: ${PACKAGE}/${FOLDER} does not exist" >&2
                exit 1
            fi
    esac
done


# Function which creates the ${1} and writes in ${1} the value of ${2}

create_and_write_file () {
    touch "${1}"
    echo "${2}" > "${1}"
}

# Accepts #1 as FILE_NAME, #2 as FOLDER. Returns the FILE_PATH

function get_file_path () {
    local CLASS_FILE_NAME=''
    local FILE_PATH=''
    
    CLASS_FILE_NAME="${1}.java"
    FILE_PATH="${PROJECT_PATH}/${FOLDER}/${CLASS_FILE_NAME}"

    echo "${FILE_PATH}"

}

# The main functionality. Creates all the model related objects in the project

for FOLDER in ${FOLDERS}
do
    CLASS_TYPE=$(basename "${FOLDER}")

    case "${CLASS_TYPE}" in
        config|util|model) 
            continue 
            ;;

        param)
            readonly PARAM_TYPES="add update"

                for PARAM_TYPE in ${PARAM_TYPES}
                do
                    CURR_TYPE="${PARAM_TYPE}_${CLASS_TYPE}"
                    TEMPLATE=$(get_"${CURR_TYPE}"_parsed)
                    CURR_TYPE="${PARAM_TYPE^}${MODEL}${CLASS_TYPE^}"
                    create_and_write_file "$(get_file_path "${CURR_TYPE}" "${FOLDER}")" "${TEMPLATE}"

                done
            ;;
        
        *)
            TEMPLATE=$(get_"$(basename "${FOLDER}")"_parsed)
            create_and_write_file "$(get_file_path "${MODEL}${CLASS_TYPE^}" "${FOLDER}")" "${TEMPLATE}"
            ;;
    esac

done   

exit 0
