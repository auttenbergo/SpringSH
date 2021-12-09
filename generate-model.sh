#!/bin/bash

readonly SCRIPT_PATH=$(dirname "${0}") ; export SCRIPT_PATH
readonly SCRIPT_NAME="$(basename "$0")"

readonly MODEL="${1^}"
readonly PROJECT_PATH="${2}"


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


# Check if project path exists

if [[ ! -d "${PROJECT_PATH}" ]]
then
    echo "${SCRIPT_NAME}: ${PROJECT_PATH} does not exist"
    exit 1
fi

readonly PACKAGE=$(get_package_name)



# Get Exported Parser Functions

source "${SCRIPT_PATH}"/template-parsers.sh

readonly FOLDERS=$(cat "${SCRIPT_PATH}"/folder-paths)

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

# Accepts #1 as FILE_NAME, #2 as FOLDER

function get_file_path () {
    local CLASS_FILE_NAME=''
    local FILE_PATH=''
    
    CLASS_FILE_NAME="${1}.java"
    FILE_PATH="${PROJECT_PATH}/${FOLDER}/${CLASS_FILE_NAME}"

    echo "${FILE_PATH}"

}

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

# create_controller
# create_dto
# create_facade
# create_add_param
# create_update_param
# create_service
# create_entity
# create_repository
# create_mapper