#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgis_var.sh

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

mkdir -p ${DST}/static/images
cp ${TMP}/doc/html/images/* ${DST}/static/images/
cp ${TMP}/doc/html/index.html ${CONTENT}/_index.html
find ${TMP}/doc/html ! -name *"index"* -exec cp -r {} ${CONTENT} \;

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html')
do
  # Process & clean up the files
  python ${ETL}/common/common.py $f ${REPO}
  rm $f && mv /tmp/document.modified $f
done

#===============================================
# Needs unique style processing for headers
#===============================================

printf "
h1#TableOfContents0 {
    display: none;
}

div#top-bar {
    display: none;
}

div.note, div.warning, div.caution, div.tip {
    margin: 2rem 0 !important;
}

div.note > table > tbody > tr > td > a > img,
div.warning > table > tbody > tr > td > a > img,
div.caution > table > tbody > tr > td > a > img,
div.tip > table > tbody > tr > td > a > img,
div.note > table > tbody > tr > th,
div.warning > table > tbody > tr > th,
div.caution > table > tbody > tr > th,
div.tip > table > tbody > tr > th {
    display: none;
}
" >> ${DST}/themes/crunchy-hugo-theme/static/css/custom.css
