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
source pgbouncer_var.sh

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

(cd ${BUILD} && git clone https://github.com/libusual/libusual && mv libusual/* lib)
(cd ${BUILD} && ./autogen.sh && ./configure && make htmls)
mv ${BUILD}/html/README.rst.html ${CONTENT}/_index.html
mv ${BUILD}/html/*.rst.html ${CONTENT}/

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html')
do
  # Process & clean up the files
  python ${ETL}/common/common.py $f ${REPO}
  rm $f && mv /tmp/document.modified $f

  # Save files for PDF processing
  cp $f ${BUILD_ROOT}
done

#===============================================
# Need _index.html for each directory of content
#===============================================

for f in $(find ${CONTENT} -name '*.html' ! -name '*index.html')
do
  # Place each file into its own folder
  FILE=$(basename "$f" | cut -f 1 -d '.')
  mkdir -p ${CONTENT}/${FILE,,}
  mv ${f} ${CONTENT}/${FILE,,}/_index.html
done
