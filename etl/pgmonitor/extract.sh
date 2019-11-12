#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgmonitor_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export PGMONITOR_VERSION=$(echo ${PGMONITOR_VERSION} | sed 's/_/./g')

(cd ${SRC}/${REPO} && git checkout tags/v${PGMONITOR_VERSION})

export PGMONITOR_VERSION=$(echo ${PGMONITOR_VERSION} | sed 's/./_/g')

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${REPO}/hugo/content ${DST}
cp -r ${SRC}/${REPO}/hugo/static/* ${DST}/static/
yes | cp -f ${SRC}/${REPO}/hugo/config.toml ${DST}
