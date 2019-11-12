#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source sec_install_n_config_var.sh

#===============================================
# Extract the files from /src/
#===============================================

cp -r ${TEMPLATE} ${DST}
(cd ${SRC}/${REPO} && git checkout hugo)
cp -r ${SRC}/${REPO}/content ${DST}
cp -r ${SRC}/${REPO}/static/* ${DST}/static/
yes | cp -f ${SRC}/${REPO}/config.toml ${DST}
