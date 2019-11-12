#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source check_postgres_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT}
tar -xzf ${SRC}/${REPO}/${REPO}_${CHECK_POSTGRES_VERSION}.tar.gz -C ${BUILD_ROOT}

#===============================================
# Build HTML from source
#===============================================

(cd ${BUILD} && perl Makefile.PL && make html)
