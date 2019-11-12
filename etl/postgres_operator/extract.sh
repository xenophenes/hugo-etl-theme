#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgres_operator_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export POSTGRES_OPERATOR_VERSION=$(echo ${POSTGRES_OPERATOR_VERSION} | sed 's/_/./g')

export REPO=$(echo $REPO | sed 's/\_/-/g')

(cd ${SRC}/${REPO} && git checkout tags/${POSTGRES_OPERATOR_VERSION})

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${REPO}/hugo/content ${DST}
find ${SRC}/${REPO}/hugo/static ! -path *"pdf"* -exec cp -r {} ${DST}/static \;

if [[ ${POSTGRES_OPERATOR_VERSION} < 3.5.0 ]]; then
  yes | cp -f config_old.toml ${DST}/config.toml
else
  yes | cp -f config.toml ${DST}
fi

export POSTGRES_OPERATOR_VERSION=$(echo ${POSTGRES_OPERATOR_VERSION} | sed 's/./_/g')

export REPO=$(echo $REPO | sed 's/\-/_/g')
