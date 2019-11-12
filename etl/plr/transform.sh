#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source plr_var.sh

#===============================================
# Set up the destination structure
#===============================================

cp -r ${TEMPLATE} ${DST}
yes | cp -f ${DIR}/config.toml ${DST}
cp ${TEMPLATE}/layouts/google-analytics.html ${DST}/themes/crunchy-hugo-theme/layouts/partials/google-analytics.html
cp ${TEMPLATE}/static/fonts/Fort-* ${DST}/themes/crunchy-hugo-theme/static/fonts/
cp ${TEMPLATE}/static/css/Fort-* ${DST}/themes/crunchy-hugo-theme/static/css/

#===============================================
# Move files to destination directory
#===============================================

mv ${BUILD}/userguide.md ${CONTENT}/_index.md

#===============================================
# Process the HTML files
#===============================================

sed -i "1,10d" ${CONTENT}/_index.md

sed -i '1s;^;<h1>PL/R User’s Guide - R Procedural Language</h1>\n\n;' ${CONTENT}/_index.md
sed -i '1s;^;---\ntitle: "PL/R User’s Guide - R Procedural Language"\ndraft: false\n---\n\n;' ${CONTENT}/_index.md
