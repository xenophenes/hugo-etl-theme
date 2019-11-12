#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgrouting_var.sh

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

mkdir ${DST}/static/images
sphinx-build -b html ${BUILD}/build/doc ${BUILD}/output
cp ${BUILD}/output/index.html ${CONTENT}/_index.html
cp ${BUILD}/output/*.html ${CONTENT}
cp ${BUILD}/output/_images/*.png ${DST}/static/images
cp ${BUILD}/output/_static/images/*.png ${DST}/static/images
cp ${BUILD}/output/_static/images/developers/*.png ${DST}/static/images

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html' ! -name '*index.md')
do
  # Process & clean up the files
  python ${ETL}/common/common.py $f ${REPO}
  rm $f && mv /tmp/document.modified $f
done
