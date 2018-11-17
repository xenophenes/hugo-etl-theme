#!/bin/bash
#=========================================================================
# Copyright 2018 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=========================================================================

#===============================================
# Define folder locations
#===============================================

THEME="${ETL_PATH}/etl/template/themes/crunchy"
TEMPLATE="${ETL_PATH}/etl/template"
DOCS="${ETL_PATH}/docs"
SRC="${ETL_PATH}/src"
ETL="${ETL_PATH}/etl"

#===============================================
# General purpose & informational functions
#===============================================

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

function echo_err() {
    echo -e "${RED?}$(date) ERROR: ${1?}${RESET?}"
}

function echo_info() {
    echo -e "${GREEN?}$(date) INFO: ${1?}${RESET?}"
}

function echo_warn() {
    echo -e "${YELLOW?}$(date) WARN: ${1?}${RESET?}"
}

function echo_begin {
    echo_info "Initiating the ETL process for ${1}."
}

function echo_end {
    echo_info "ETL process for ${1} complete."
}

#===============================================
# Cleanup functions
#===============================================

function cleanup_postgres {
    # This is used for the PostgreSQL and PostGIS documentation.
    # Remove all instances of text within brackets starting with a ., indicating a HTML class
    sed -i "s/{\.[^)]*}//g" ${1}
    # All links need to be relative, not absolute
    sed -i "s/.html//g" ${1}
    # Remove footer content
    sed -zi 's/\* \* \* \* \*\n\n  ---.*\n[^\n]\+\n[^\n]\+\n  ---.*\n\n//g' ${1}
    # Remove header content by removing everything including / before the first occurrence
    # of * * * * *
    sed -i '0,/^\* \* \* \* \*$/d' ${1}
    # All images need to default to the root directory
    sed -i 's/]](images/]](\/images/g' ${1}
}
