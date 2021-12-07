#!/bin/bash

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

SCRIPT_PATH=$(dirname "${0}")
MODEL="${1}"
PROJECT_PATH="${2}"
PACKAGE=$(get_package_name)

CONTROLLER="${MODEL}Controller"
FACADE="${MODEL}Facade"
SERVICE="${MODEL}Service"
REPOSITORY="${MODEL}Repository"
DTO="${MODEL}Dto"
MAPPER="${MODEL}Mapper";
ADD_PARAM="Add${MODEL}Param"
UPDATE_PARAM="Update${MODEL}Param"

# FUNCTIONS FOR CONTROLLER

get_controller_parsed () {
    CONTROLLER_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/controller-template)
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    API_BASE_PATH=$(echo ${MODEL,} | sed -r 's/([a-z0-9])([A-Z])/\1-\L\2/g')
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{API_BASE_PATH\}/${API_BASE_PATH}}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{DTO_CLASS_NAME\}/$DTO}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{DTO_VAR_NAME\}/${DTO,}}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{CONTROLLER_CLASS_NAME\}/$CONTROLLER}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{FACADE_CLASS_NAME\}/$FACADE}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{FACADE_VAR_NAME\}/${FACADE,}}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{MODEL_NAME\}/$MODEL}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{MODEL_NAME_LOWER\}/${MODEL,}}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{UPDATE_MODEL_PARAM_CLASS_NAME\}/$UPDATE_PARAM}")
    CONTROLLER_TEMPLATE=$(echo "${CONTROLLER_TEMPLATE//\{ADD_MODEL_PARAM_CLASS_NAME\}/$ADD_PARAM}")

    echo "${CONTROLLER_TEMPLATE}"
}

create_controller () {
    FILE_PATH="${PROJECT_PATH}/controller/${CONTROLLER}.java"
    CONTROLLER_TEMPLATE=$(get_controller_parsed)
    touch "${FILE_PATH}"
    echo "${CONTROLLER_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR DTO

get_dto_parsed () {
    DTO_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/dto-template)
    DTO_TEMPLATE=$(echo "${DTO_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    DTO_TEMPLATE=$(echo "${DTO_TEMPLATE//\{MODEL_NAME\}/$MODEL}")
    echo "${DTO_TEMPLATE}"
}

create_dto () {
    FILE_PATH="${PROJECT_PATH}/model/dto/${DTO}.java"
    DTO_TEMPLATE=$(get_dto_parsed)
    touch "${FILE_PATH}"
    echo "${DTO_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR FACADE

get_facade_parsed () {
    FACADE_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/facade-template)
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{FACADE_CLASS_NAME\}/${FACADE}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{MAPPER_CLASS_NAME\}/${MAPPER}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{SERVICE_CLASS_NAME\}/${SERVICE}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{SERVICE_VAR_NAME\}/${SERVICE,}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{DTO_CLASS_NAME\}/${DTO}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{MODEL_NAME\}/${MODEL}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{MODEL_NAME_LOWER\}/${MODEL,}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{ADD_MODEL_PARAM_CLASS_NAME\}/${ADD_PARAM}}")
    FACADE_TEMPLATE=$(echo "${FACADE_TEMPLATE//\{UPDATE_MODEL_PARAM_CLASS_NAME\}/${UPDATE_PARAM}}")

    echo "${FACADE_TEMPLATE}"

}

create_facade () {
    FILE_PATH="${PROJECT_PATH}/facade/${FACADE}.java"
    FACADE_TEMPLATE=$(get_facade_parsed)
    touch "${FILE_PATH}"
    echo "${FACADE_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR ADD PARAM

get_add_param_parsed () {
    ADD_PARAM_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/add-param-template)
    ADD_PARAM_TEMPLATE=$(echo "${ADD_PARAM_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    ADD_PARAM_TEMPLATE=$(echo "${ADD_PARAM_TEMPLATE//\{ADD_PARAM_CLASS_NAME\}/${ADD_PARAM}}")

    echo "${ADD_PARAM_TEMPLATE}"
}

create_add_param () {
    FILE_PATH="${PROJECT_PATH}/model/param/${ADD_PARAM}.java"
    ADD_PARAM_TEMPLATE=$(get_add_param_parsed)
    touch "${FILE_PATH}"
    echo "${ADD_PARAM_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR UPDATE PARAM

get_update_param_parsed () {
    UPDATE_PARAM_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/update-param-template)
    UPDATE_PARAM_TEMPLATE=$(echo "${UPDATE_PARAM_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    UPDATE_PARAM_TEMPLATE=$(echo "${UPDATE_PARAM_TEMPLATE//\{UPDATE_PARAM_CLASS_NAME\}/${UPDATE_PARAM}}")

    echo "${UPDATE_PARAM_TEMPLATE}"
}

create_update_param () {
    FILE_PATH="${PROJECT_PATH}/model/param/${UPDATE_PARAM}.java"
    UPDATE_PARAM_TEMPLATE=$(get_update_param_parsed)
    touch "${FILE_PATH}"
    echo "${UPDATE_PARAM_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR SERVICE

get_service_parsed () {
    SERVICE_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/service-template)
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{REPOSITORY_CLASS_NAME\}/${REPOSITORY}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{REPOSITORY_VAR_NAME\}/${REPOSITORY,}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{SERVICE_CLASS_NAME\}/${SERVICE}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{ENTITY_CLASS_NAME\}/${MODEL}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{MODEL_NAME\}/${MODEL}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{MODEL_NAME_LOWER\}/${MODEL,}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{ADD_MODEL_PARAM_CLASS_NAME\}/${ADD_PARAM}}")
    SERVICE_TEMPLATE=$(echo "${SERVICE_TEMPLATE//\{UPDATE_MODEL_PARAM_CLASS_NAME\}/${UPDATE_PARAM}}")

    echo "${SERVICE_TEMPLATE}"
}

create_service () {
    FILE_PATH="${PROJECT_PATH}/service/${SERVICE}.java"
    SERVICE=$(get_service_parsed)
    touch "${FILE_PATH}"
    echo "${SERVICE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR ENTITY

get_entity_parsed () {
    ENTITY_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/entity-template)

    ENTITY_TABLE_NAME=$(echo ${MODEL,} | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g')

    ENTITY_TEMPLATE=$(echo "${ENTITY_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    ENTITY_TEMPLATE=$(echo "${ENTITY_TEMPLATE//\{ENTITY_CLASS_NAME\}/${MODEL}}")
    ENTITY_TEMPLATE=$(echo "${ENTITY_TEMPLATE//\{ENTITY_TABLE_NAME\}/${ENTITY_TABLE_NAME,}}")

    echo "${ENTITY_TEMPLATE}"
}

create_entity () {
    FILE_PATH="${PROJECT_PATH}/model/entity/${MODEL}.java"
    ENTITY_TEMPLATE=$(get_entity_parsed)
    touch "${FILE_PATH}"
    echo "${ENTITY_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR REPOSITORY
get_repository_parsed () {
    REPOSITORY_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/repository-template)
    REPOSITORY_TEMPLATE=$(echo "${REPOSITORY_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    REPOSITORY_TEMPLATE=$(echo "${REPOSITORY_TEMPLATE//\{MODEL_NAME\}/${MODEL}}")

    echo "${REPOSITORY_TEMPLATE}"
}

create_repository () {
    FILE_PATH="${PROJECT_PATH}/repository/${REPOSITORY}.java"
    REPOSITORY_TEMPLATE=$(get_repository_parsed)
    touch "${FILE_PATH}"
    echo "${REPOSITORY_TEMPLATE}" > "${FILE_PATH}"
}

# FUNCTIONS FOR MAPPER
get_mapper_parsed () {
    MAPPER_TEMPLATE=$(/usr/bin/cat "${SCRIPT_PATH}"/templates/mapper-template)
    MAPPER_TEMPLATE=$(echo "${MAPPER_TEMPLATE//\{PACKAGE\}/${PACKAGE}}")
    MAPPER_TEMPLATE=$(echo "${MAPPER_TEMPLATE//\{MODEL_NAME\}/${MODEL}}")
    MAPPER_TEMPLATE=$(echo "${MAPPER_TEMPLATE//\{DTO_CLASS_NAME\}/${DTO}}")
    MAPPER_TEMPLATE=$(echo "${MAPPER_TEMPLATE//\{ENTITY_CLASS_NAME\}/${MODEL}}")
    MAPPER_TEMPLATE=$(echo "${MAPPER_TEMPLATE//\{ENTITY_VAR_NAME\}/${MODEL,}}")

    echo "${MAPPER_TEMPLATE}"
}

create_mapper () {
    FILE_PATH="${PROJECT_PATH}/model/mapper/${MAPPER}.java"
    MAPPER_TEMPLATE=$(get_mapper_parsed)
    touch "${FILE_PATH}"
    echo "${MAPPER_TEMPLATE}" > "${FILE_PATH}"
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