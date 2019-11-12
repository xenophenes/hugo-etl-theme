#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
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
