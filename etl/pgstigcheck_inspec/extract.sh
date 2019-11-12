#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgstigcheck_inspec_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export REPO=$(echo $REPO | sed 's/\_/-/g')

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${REPO}/hugo/content/* ${DST}/content
cp -r ${SRC}/${REPO}/hugo/static/* ${DST}/static/
yes | cp -f ${SRC}/${REPO}/hugo/config.toml ${DST}

export REPO=$(echo $REPO | sed 's/\-/_/g')
