#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=miatoll
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Clean up unlisted blobs
PROP_DIR="${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/proprietary"
if [ -d "${PROP_DIR}" ]; then
    # Extract the list of expected files (ignoring comments and blank lines)
    EXPECTED_FILES=$(grep -vE '(^#|^$)' "${MY_DIR}/proprietary-files.txt" | awk '{print $1}' | sed 's/^-//')

    # Find all proprietary files
    find "${PROP_DIR}" -type f | while read -r FILE; do
        REL_PATH="${FILE#${PROP_DIR}/}"
        FILE_NAME="$(basename "${REL_PATH}")"

        # Ignore .part files silently
        [[ "${FILE_NAME}" == *.part* ]] && continue

        # Remove unlisted files
        if ! grep -qF "${REL_PATH}" <<< "${EXPECTED_FILES}"; then
            echo "Removing unlisted blob: ${FILE}"
            rm -f "${FILE}"
        fi
    done
fi

# Finish
write_footers
