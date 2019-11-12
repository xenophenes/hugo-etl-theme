#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgaudit_analyze_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT}
tar -xzf ${SRC}/${REPO}/${REPO}_${PGAUDIT_ANALYZE_VERSION}.tar.gz -C ${BUILD_ROOT}
