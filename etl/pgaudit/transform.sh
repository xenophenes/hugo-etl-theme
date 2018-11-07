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
source pgaudit_var.sh

# Template doesn't exist, copy it
cp -r ${TEMPLATE} ${DST}

# Config file needs to be specific, copy it
yes | cp -f ${DIR}/config.toml ${DST}

# Move files to destination directory
cp ${BUILD}/README.md ${CONTENT}/_index.md

# Get the name of the page
TITLE=$(head -n 1 ${CONTENT}/_index.md)

# Substitute beginning of side pages
sed -i "1s;^;---\ntitle: 'pgAudit - Open Source PostgreSQL Audit Logging'\ndraft: false\ntoc: true\n\n---\n\n;" ${CONTENT}/_index.md

# Generate PDF files
for f in $(find ${CONTENT} -name '*.md')
do
  # Get the file name without the path
  file=$(basename -- "$f")
  # Convert Markdown to PDF
  pandoc ${CONTENT}/${file%.*}.md -o ${CONTENT}/${file%.*}.pdf
  # Hugo needs files to be in a folder
  mkdir ${CONTENT}/${file%.*}.files
  mv ${CONTENT}/${file%.*}.pdf ${CONTENT}/${file%.*}.files/
done
