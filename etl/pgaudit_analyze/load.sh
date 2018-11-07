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
source pgaudit_analyze_var.sh

mkdir -p ${DST}/static/pdf

for f in $(find ${CONTENT} -name '*.md')
do
  cp $f ${DST}/static/pdf
done

pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/*.md -o ${DST}/static/pdf/${REPO}.pdf

hugo --source=${DST} --destination=${PGAUDIT_ANALYZE_DOCS}

rm -rf ${BUILD_ROOT} ${DST}
