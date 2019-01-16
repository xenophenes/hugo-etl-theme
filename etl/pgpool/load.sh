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
source pgpool_var.sh

export PGPOOL_VERSION=$(echo ${PGPOOL_VERSION} | sed 's/_/./g')
export PGPOOL_DOCS="${DOCS}/${REPO}/${PGPOOL_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${BUILD}/doc/src/sgml && make pgpool.html)
    wkhtmltopdf toc ${BUILD}/doc/src/sgml/pgpool-ii.html ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGPOOL_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    (cd ${BUILD}/doc/src/sgml && make pgpool.html)
    pandoc ${BUILD}/doc/src/sgml/pgpool-ii.html -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PGPOOL_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGPOOL_DOCS} --baseURL="/${REPO}/${PGPOOL_VERSION}"
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

elif [ "$1" == '--epub' ]; then

    create_epub

elif [ "$1" == '--html' ]; then

    create_html

elif [ "$1" == '--all' ]; then

    create_pdf

    create_epub

    create_html

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
