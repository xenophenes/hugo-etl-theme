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
source backrest_var.sh

# Template doesn't exist, copy it
cp -r ${TEMPLATE} ${DST}

# Config file needs to be specific, copy it
yes | cp -f ${DIR}/config.toml ${DST}

# Remove unnecessary files
rm ${BUILD}/default.css
rm ${BUILD}/index.html

# All source files aren't already in Markdown, so convert it
for f in $(find ${BUILD} -name '*.html')
do
  # Clean up content
  cleanup_backrest ${f}
  # Convert to Markdown
  pandoc -f html -t markdown $f -o $f
done

find ${BUILD} -name "*.html" -exec rename .html .md {} +

# Move files to destination directory
mv ${ETL}/${REPO}/build/${REPO}_${BACKREST_VERSION}/README.md ${CONTENT}/_index.md
mkdir -p ${DST}/static/images
mv ${BUILD}/*.png ${DST}/static/images
cp -r ${BUILD}/* ${CONTENT}/

sed -i "" "1s;^;---\ntitle: 'pgBackRest - Reliable PostgreSQL Backup and Restore'\ndraft: false\n---\n\n;" ${CONTENT}/_index.md

for f in $(find ${CONTENT} -name '*.md' ! -name _index.md)
do
  # Get the name of the page
  TITLE=$(head -n 1 ${f} | sed "s/pgBackRest //g")
  # Delete redundant header
  sed -i "" '1d' ${f}
  # Substitute beginning
  sed -i "" "1s;^;---\ntitle: '${TITLE}'\ndraft: false\n---\n\n;" ${f}
done

# Each file needs to be in its own folder
for f in $(find ${CONTENT} -name '*.md' ! -name _index.md ! -name index.md)
do
  FILE=$(basename "$f" | cut -f 1 -d '.')
  mkdir -p ${CONTENT}/${FILE}
  mv ${f} ${CONTENT}/${FILE}
done

# Need _index.md for each directory of content
for d in `find ${CONTENT} -type d`
do
  NAME=$(echo ${d##*/})

  # Does index.md already exist?
  if [[ -f ${d}/${NAME}.md ]]; then
    mv ${d}/${NAME}.md ${d}/_index.md
  fi
done
