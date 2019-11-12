#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source crunchy_containers_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export CRUNCHY_CONTAINERS_VERSION=$(echo ${CRUNCHY_CONTAINERS_VERSION} | sed 's/_/./g')

export REPO=$(echo $REPO | sed 's/\_/-/g')

(cd ${SRC}/${REPO} && git checkout tags/${CRUNCHY_CONTAINERS_VERSION})

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${REPO}/hugo/content ${DST}
cp ${SRC}/${REPO}/hugo/static/* ${DST}/static/

if [[ ${CRUNCHY_CONTAINERS_VERSION} < 2.3.0 ]]; then
  yes | cp -f config_old.toml ${DST}/config.toml
else
  yes | cp -f config.toml ${DST}
fi

export CRUNCHY_CONTAINERS_VERSION=$(echo ${CRUNCHY_CONTAINERS_VERSION} | sed 's/./_/g')

export REPO=$(echo $REPO | sed 's/\-/_/g')
