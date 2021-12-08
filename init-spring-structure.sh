#!/bin/bash

SCRIPT_NAME="$(basename "$0")"

# Checking that user is using the script correctly

if [[ ${#} -ne 1 ]]
then
    echo "Usage: ${SCRIPT_NAME} <DIRECTORY_PATH>"
    exit 1
fi


FOLDER_PATH="${1}"

# Checking that directory exists

if [[ ! -d "${FOLDER_PATH}" ]]
then
    echo "${SCRIPT_NAME}: ${FOLDER_PATH} directory not found" >&2
    exit 1
fi

mkdir "${FOLDER_PATH}/config"
mkdir "${FOLDER_PATH}/controller"
mkdir "${FOLDER_PATH}/facade"
mkdir "${FOLDER_PATH}/service"
mkdir "${FOLDER_PATH}/repository"
mkdir "${FOLDER_PATH}/util"

mkdir "${FOLDER_PATH}/model"
mkdir "${FOLDER_PATH}/model/dto"
mkdir "${FOLDER_PATH}/model/entity"
mkdir "${FOLDER_PATH}/model/mapper"
mkdir "${FOLDER_PATH}/model/param"


