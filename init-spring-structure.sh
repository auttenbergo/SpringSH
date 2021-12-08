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
    echo "${SCRIPT_NAME}: ${FOLDER_PATH} project directory not found" >&2
    exit 1
fi

# Double checking the user decision

while true
do
    read -p "Are you sure you want to init the folder structure in ${FOLDER_PATH}? (y/N): " ANSWER

    case "$ANSWER" in
        y) break ;;
        N) echo "Exiting the program..."; exit 0 ;;
        *) echo 'not a valid answer, use (y/N)' ;;
    esac
done

# The creation of directories

readonly FOLDERS="/config /controller /facade /service /repository /util /model /model/dto /model/entity /model/mapper /model/param"

for FOLDER in ${FOLDERS}
do
    mkdir "${FOLDER_PATH}${FOLDER}" &> /dev/null
done

echo "Program has finished the execution"
exit 0

