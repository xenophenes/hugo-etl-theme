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
rm -rf ${BUILD}/images

cp ${BUILD}/index.html ${CONTENT}/_index.html
cp -r ${BUILD}/* ${CONTENT}/

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html')
do
  if [[ ${f} != *"index.html"* ]]
  then
    # Remove manually entered TOC if not the Index page
    sed -Ei 's/<div class="toc">.*?<\/div>//g' "${f}"
  fi
  # Convert from ISO-8859-1 to UTF-8 so pandoc can parse the content
  iconv -f ISO-8859-1 -t UTF-8 $f -o $f
  # Convert HTML to Markdown
  pandoc -f html -t markdown $f -o $f
done

find ${CONTENT} -name "*.html" -exec rename .html .md {} +

for f in $(find ${CONTENT} -name '*.md')
do
  # Get the name of the page
  TITLE=$(head -n 1 ${f})

  # Clean up content
  cleanup_postgres "${f}"

  # Check if it's the index page
  if [[ ${f} == *"_index.md"* ]]
  then
    # Substitute beginning of Index page
    sed -i "1s;^;---\ntitle: '${TITLE}'\ndraft: false\ntoc: false\n---\n\n;" ${f}

  else
    # Substitute beginning of side pages
    sed -i "1s;^;---\ntitle: '${TITLE}'\ndraft: false\nhidden: true\ntoc: true\n\n---\n\n;" ${f}
    
  fi
done
