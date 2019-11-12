#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgadmin4_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT}
tar -xzf ${SRC}/${REPO}/${REPO}_${PGADMIN4_VERSION}*.tar.gz -C ${BUILD_ROOT}

#===============================================
# Build HTML from source
#===============================================

# Need a fix to repair a missing theme & orphaned document
sed -i "/html_theme = 'classic'/d" ${BUILD}/docs/en_US/conf.py
rm ${BUILD}/docs/en_US/tablespace_dialog.rst

(cd ${BUILD} && make docs)
