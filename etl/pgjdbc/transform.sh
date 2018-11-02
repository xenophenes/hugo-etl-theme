#!/bin/bash

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

set -e
source ${ETL_PATH}/etl/common/common.sh
source pgjdbc_var.sh

# Template doesn't exist, copy it
cp -r ${TEMPLATE} ${DST}

# Config file needs to be specific, copy it
yes | cp -f ${DIR}/config.toml ${DST}

# Generate Jekyll pages for clean, parsed HTML files
jekyll b -s ${BUILD} -d ${JEKYLL}

# All source files aren't already in Markdown, so convert it
for f in $(find ${JEKYLL} -name '*.html'); do pandoc -f html -t markdown ${f} -o ${f}; done;
find ${JEKYLL} -name "*.html" -exec rename .html .md {} +

# Copy content
cp -r ${JEKYLL}/* ${CONTENT}

# Remove unnecessary subfolders
rm -rf ${CONTENT}/search ${CONTENT}/documentation/92 ${CONTENT}/documentation/93 ${CONTENT}/documentation/94
mv ${CONTENT}/documentation/head/* ${CONTENT}/documentation
rm -rf ${CONTENT}/documentation/head

# Rename new_release
mv ${CONTENT}/new_release ${CONTENT}/releases

# If a file is not _index.md and doesn't exist in a directory, put it in a directory
for f in $(find ${CONTENT} -maxdepth 1 -name '*.md' ! -name '_index.md' ! -name 'index.md')
do
  mkdir -p ${f%%.*}
  mv $f ${f%%.*}
done

for f in $(find ${CONTENT} -name '*.md')
do
  # Get the name of the page
  TITLE=$(basename "$f" | cut -f 1 -d '.')
  # Clean up content
  cleanup_pgjdbc "${f}"
  # Substitute beginning
  sed -i "1s;^;---\ntitle: '${TITLE^}'\ndraft: false\n---\n\n;" ${f}
done

# Need _index.md for each directory of content
for d in `find ${CONTENT} -type d ! -name 'media' ! -name 'releases' ! -name 'css' ! -name 'img'`
do
  NAME=$(echo ${d##*/})

  # Does index.md already exist?
  if [[ -f ${d}/index.md ]]; then
    mv ${d}/index.md ${d}/_index.md

  # Does _index.md already exist?
  elif [[ -f ${d}/_index.md ]]; then
  return

  # Does a file exist that matches the name of the directory?
  elif [[ -f ${d}/${NAME}.md ]]; then
    mv ${d}/${NAME}.md ${d}/_index.md

  # If the above conditions are false, then create a new _index.md.
  elif [[ ! -f ${d}/index.md || ! -f ${d}/_index.md || ! -f ${d}/${NAME}.md ]]; then
    cd ${DST} && hugo new ${d}/_index.md
  fi
done

# Move media folders
for d in `find ${CONTENT} -type d -name 'media'`
do
  mv ${d}/css ${DST}/static/css
  mv ${d}/img ${DST}/static/img
  mv ${d}/favicon.ico ${DST}/static
  rm -rf ${d}
done
