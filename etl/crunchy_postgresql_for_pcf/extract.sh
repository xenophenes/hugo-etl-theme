#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source crunchy_postgresql_for_pcf_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export REPO=$(echo $REPO | sed 's/\_/-/g')
export SRC_REPO="crunchy-pcf-doc"

export CRUNCHY_POSTGRESQL_FOR_PCF_VERSION=$(echo ${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION} | sed 's/_/./g')

(cd ${SRC}/${SRC_REPO} && git checkout ${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION})

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${SRC_REPO}/content ${DST}
cp -r ${SRC}/${SRC_REPO}/static/* ${DST}/static/
cp -r ${SRC}/${SRC_REPO}/themes/crunchy-docs-theme ${DST}/themes/
yes | cp -f ${SRC}/${SRC_REPO}/config.yml ${DST}

export REPO=$(echo $REPO | sed 's/\-/_/g')
