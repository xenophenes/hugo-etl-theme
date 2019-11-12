#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source backrest_var.sh

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
rm ${BUILD}/doc/output/html/default.css ${BUILD}/doc/output/html/index.html
mv ${BUILD}/doc/output/html/*.png ${DST}/static/images
mv ${ETL}/${REPO}/build/${REPO}_${BACKREST_VERSION}/README.md ${CONTENT}/_index.md
cp -r ${BUILD}/doc/output/html/* ${CONTENT}/

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html' ! -name '*index.md')
do
  # Process & clean up the files
  python ${ETL}/common/common.py $f ${REPO}
  rm $f && mv /tmp/document.modified $f

  # Need filenames intact before rename for PDF build
  cp -r $f ${BUILD_ROOT}

  # Place each file into its own folder
  FILE=$(basename "$f" | cut -f 1 -d '.')
  mkdir -p ${CONTENT}/${FILE}
  mv ${f} ${CONTENT}/${FILE}
done

cp ${CONTENT}/_index.md ${BUILD_ROOT}

#===============================================
# Need _index.html for each directory of content
#===============================================

for d in `find ${CONTENT} -type d`
do
  NAME=$(echo ${d##*/})
  if [[ -f ${d}/${NAME}.html ]]; then
    mv ${d}/${NAME}.html ${d}/_index.html
  fi
done
