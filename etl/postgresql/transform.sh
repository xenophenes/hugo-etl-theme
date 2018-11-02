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
source postgresql_var.sh

# Template doesn't exist, copy it
cp -r ${TEMPLATE} ${DST}

# Config file needs to be specific, copy it
yes | cp -f ${DIR}/config.toml ${DST}

# Remove unnecessary files
rm ${BUILD}/stylesheet.css

# All source files aren't already in Markdown, so convert it
for f in $(find ${BUILD} -name '*.html')
do
  pandoc -f html -t markdown $f -o $f
done

find ${BUILD} -name "*.html" -exec rename .html .md {} +

# Move files to destination directory
cp ${BUILD}/index.md ${CONTENT}/_index.md
cp -r ${BUILD}/*.md ${CONTENT}/

for f in $(find ${CONTENT} -name '*.md' ! -name '_index.md')
do
  # Get the name of the page
  TITLE=$(head -n 1 ${f})
  # Clean up content
  cleanup_postgres "${f}"
  # Substitute beginning
  sed -i "1s;^;---\ntitle: '${TITLE}'\ndraft: false\nhidden: true\n---\n\n;" ${f}
done

# Get the name of the page
TITLE=$(head -n 1 ${CONTENT}/_index.md)
# Clean up content
cleanup_postgres "${CONTENT}/_index.md"
# Substitute beginning
sed -i "1s;^;---\ntitle: '${TITLE}'\ndraft: false\n---\n\n;" ${CONTENT}/_index.md
