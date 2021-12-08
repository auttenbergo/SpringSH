#!/bin/bash


# Based on the user given project path, returns the package name excluded. Package name is the path after /java directory

get_package_name () {
    RESULT=''
    PACKAGE="${PROJECT_PATH}"
    while [[ "$(basename "${PACKAGE}")" != "java" ]]
    do
        RESULT="$(basename "${PACKAGE}").${RESULT}"
        PACKAGE=$(/usr/bin/dirname "${PACKAGE}")
    done
    RESULT="${RESULT::-1}"
    echo "${RESULT}"
}

readonly SCRIPT_PATH=$(dirname "${0}") ; export SCRIPT_PATH
readonly MODEL="${1}"
readonly PROJECT_PATH="${2}"
readonly PACKAGE=$(get_package_name)

readonly CONTROLLER="${MODEL}Controller"
readonly FACADE="${MODEL}Facade"
readonly SERVICE="${MODEL}Service"
readonly REPOSITORY="${MODEL}Repository"
readonly DTO="${MODEL}Dto"
readonly MAPPER="${MODEL}Mapper";
readonly ADD_PARAM="Add${MODEL}Param"
readonly UPDATE_PARAM="Update${MODEL}Param"

# Get Exported Parser Functions

source ./template-parsers.sh


# Function which creates the ${1} and writes in ${1} the value of ${2}
create_and_write_file () {
    touch "${1}"
    echo "${2}" > "${1}"
}


# Functions for controller class.

create_controller () {
    local FILE_PATH=''
    local CONTROLLER_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/controller/${CONTROLLER}.java"
    CONTROLLER_TEMPLATE="$(get_controller_parsed)"

    create_and_write_file "${FILE_PATH}" "${CONTROLLER_TEMPLATE}"
}

# Functions for dto class

create_dto () {
    local FILE_PATH=''
    local DTO_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/model/dto/${DTO}.java"
    DTO_TEMPLATE=$(get_dto_parsed)

    create_and_write_file "${FILE_PATH}" "${DTO_TEMPLATE}"
}

# Functions for facade class


create_facade () {
    local FILE_PATH=''
    local FACADE_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/facade/${FACADE}.java"
    FACADE_TEMPLATE=$(get_facade_parsed)

    create_and_write_file "${FILE_PATH}" "${FACADE_TEMPLATE}"
}

# Functions for add param class

create_add_param () {
    local FILE_PATH=''
    local ADD_PARAM_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/model/param/${ADD_PARAM}.java"
    ADD_PARAM_TEMPLATE=$(get_add_param_parsed)

    create_and_write_file "${FILE_PATH}" "${ADD_PARAM_TEMPLATE}"
}

# Functions for update param class

create_update_param () {
    local FILE_PATH=''
    local UPDATE_PARAM_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/model/param/${UPDATE_PARAM}.java"
    UPDATE_PARAM_TEMPLATE=$(get_update_param_parsed)

    create_and_write_file "${FILE_PATH}" "${UPDATE_PARAM_TEMPLATE}"
}

# Functions for service class

create_service () {
    local FILE_PATH=''
    local SERVICE_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/service/${SERVICE}.java"
    SERVICE_TEMPLATE=$(get_service_parsed)

    create_and_write_file "${FILE_PATH}" "${SERVICE_TEMPLATE}"
}

# Functions for entity class

create_entity () {
    local FILE_PATH=''
    local ENTITY_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/model/entity/${MODEL}.java"
    ENTITY_TEMPLATE=$(get_entity_parsed)

    create_and_write_file "${FILE_PATH}" "${ENTITY_TEMPLATE}"
}

# Functions for repository class

create_repository () {
    local FILE_PATH=''
    local REPOSITORY_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/repository/${REPOSITORY}.java"
    REPOSITORY_TEMPLATE=$(get_repository_parsed)

    create_and_write_file "${FILE_PATH}" "${REPOSITORY_TEMPLATE}"
}

# Functions for mapper class

create_mapper () {
    local FILE_PATH=''
    local MAPPER_TEMPLATE=''

    FILE_PATH="${PROJECT_PATH}/model/mapper/${MAPPER}.java"
    MAPPER_TEMPLATE=$(get_mapper_parsed)

    create_and_write_file "${FILE_PATH}" "${MAPPER_TEMPLATE}"
}

create_controller
create_dto
create_facade
create_add_param
create_update_param
create_service
create_entity
create_repository
create_mapper