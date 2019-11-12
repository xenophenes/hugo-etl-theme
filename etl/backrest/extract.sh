#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source backrest_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT}
tar -xzf ${SRC}/${REPO}/${REPO}_${BACKREST_VERSION}.tar.gz -C ${BUILD_ROOT}

export BACKREST_TAG=$(echo ${BACKREST_VERSION} | sed 's/_/./g')

if [[ ${BACKREST_TAG} > 2.07 ]]; then
  (cd ${BUILD}/doc && rm -rf output && ./doc.pl)
fi
