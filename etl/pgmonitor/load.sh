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
source pgmonitor_var.sh

export PGMONITOR_VERSION=$(echo ${PGMONITOR_VERSION} | sed 's/_/./g')
export PGMONITOR_DOCS="${DOCS}/${REPO}/${PGMONITOR_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    cp -r ${DST}/static/images ${DST}/static/pdf
    cp ${CONTENT}/_index.md ${DST}/static/pdf/1.md
    cp ${CONTENT}/exporter/_index.md ${DST}/static/pdf/2.md
    cp ${CONTENT}/prometheus/_index.md ${DST}/static/pdf/3.md
    cp ${CONTENT}/grafana/_index.md ${DST}/static/pdf/4.md
    cp ${CONTENT}/changelog/_index.md ${DST}/static/pdf/5.md

    (cd ${DST}/static/pdf && pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/*.md -o ${DST}/static/pdf/${REPO}.pdf)

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    cp -r ${DST}/static/images ${DST}/static/epub
    cp ${CONTENT}/_index.md ${DST}/static/epub/1.md
    cp ${CONTENT}/exporter/_index.md ${DST}/static/epub/2.md
    cp ${CONTENT}/prometheus/_index.md ${DST}/static/epub/3.md
    cp ${CONTENT}/grafana/_index.md ${DST}/static/epub/4.md
    cp ${CONTENT}/changelog/_index.md ${DST}/static/epub/5.md

    (cd ${DST}/static/epub && pandoc ${DST}/static/epub/*.md -o ${DST}/static/epub/${REPO}.epub)

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGMONITOR_DOCS} --baseURL=${PGMONITOR_BASEURL}
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

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
