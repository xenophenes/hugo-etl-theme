#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
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
