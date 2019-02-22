#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
