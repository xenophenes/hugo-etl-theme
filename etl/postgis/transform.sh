#!/bin/bash
#=========================================================================
# Copyright 2018 Crunchy Data Solutions, Inc.
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
source postgis_var.sh

#===============================================
# Set up the destination structure
#===============================================

cp -r ${TEMPLATE} ${DST}
yes | cp -f ${DIR}/config.toml ${DST}

#===============================================
# Move files to destination directory
#===============================================

mkdir -p ${DST}/static/images
cp ${BUILD}/images/* ${DST}/static/images/
cp ${BUILD}/postgis.html ${CONTENT}/_index.html

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
nav#TableOfContents div.h1 {
    display: block !important;
}

nav#TableOfContents div.h2, nav#TableOfContents div.h3, nav#TableOfContents div.h4 {
    display: none !important;
}

nav#TableOfContents div.h1, aside b {
    list-style: none;
    margin: 0.5rem 0px 0.5rem 20px;
    padding-left: 1rem;
}" >> ${DST}/themes/crunchy-hugo-theme/static/css/custom.css
