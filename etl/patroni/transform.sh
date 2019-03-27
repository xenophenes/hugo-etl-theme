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
source patroni_var.sh

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

mkdir -p ${BUILD} ${DST}/static/images

cp ${BUILD_SRC}/*.png ${DST}/static/images
cp -r ${BUILD_SRC} ${BUILD_ROOT}/src

sphinx-build -Q -b html ${BUILD_SRC} ${BUILD}

mv ${BUILD}/README.html ${CONTENT}/_index.html
rm ${BUILD}/search.html
cp ${BUILD}/*.html ${CONTENT}
rm ${CONTENT}/index.html ${CONTENT}/genindex.html

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.html')
do
  # Process & clean up the files
  python ${ETL}/common/common.py $f ${REPO}
  rm $f && mv /tmp/document.modified $f

  # Remove comments on top of file
  export VERS=$(echo ${PATRONI_VERSION} | sed 's/_/./g')
  sed -i '/<!--.*-->/d' $f
  sed -i 's/ - Patroni '${VERS}' documentation//g' $f

  # Temporary bugfix
  if [[ $f == *"replica_bootstrap"* ]]; then
    sed -i 's/Replica imaging and bootstrap//2g' $f
    sed -Ei 's/\{\{(.*)\}\}/\1/g' $f
  fi
done


for f in $(find ${CONTENT} -name '*.html' ! -name '*index.html')
do
  # Place each file into its own folder
  FILE=$(basename "$f" | cut -f 1 -d '.')
  mkdir -p ${CONTENT}/${FILE,,}
  mv ${f} ${CONTENT}/${FILE,,}/${FILE,,}.html
done

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
