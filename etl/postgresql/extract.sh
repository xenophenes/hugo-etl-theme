#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgresql_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT} ${BUILD} ${TMP}
tar -xzf ${SRC}/${REPO}/*_${POSTGRESQL_VERSION}.tar.gz -C ${TMP}

#===============================================
# Build HTML from source
#===============================================

(cd ${TMP}/*_${POSTGRESQL_VERSION} && ./configure && make html)
cp -r ${TMP}/*_${POSTGRESQL_VERSION}/doc/src/sgml/html/* ${BUILD}/
