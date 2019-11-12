#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgis_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT} ${BUILD}
tar -xzf ${SRC}/${REPO}/${REPO}_${POSTGIS_VERSION}.tar.gz -C /tmp/

#===============================================
# Build HTML from source
#===============================================

(cd ${TMP} && ./autogen.sh && ./configure --without-raster)

(cd ${TMP}/doc && make chunked-html)
