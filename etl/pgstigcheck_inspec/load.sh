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
source pgstigcheck_inspec_var.sh

export PGSTIGCHECK_INSPEC_VERSION=$(echo ${PGSTIGCHECK_INSPEC_VERSION} | sed 's/_/./g')
export PGSTIGCHECK_INSPEC_DOCS="${DOCS}/${REPO}/${PGSTIGCHECK_INSPEC_VERSION}"
export REPO_ORIGINAL=$(echo $REPO | sed 's/\_/-/g')

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    pandoc --toc --latex-engine=xelatex ${CONTENT}/_index.md -o ${DST}/static/pdf/${REPO_ORIGINAL}.pdf

    cp ${DST}/static/pdf/${REPO_ORIGINAL}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO_ORIGINAL}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    pandoc ${CONTENT}/_index.md -o ${DST}/static/epub/${REPO_ORIGINAL}.epub

    cp ${DST}/static/epub/${REPO_ORIGINAL}.epub ${ETL_PATH}/epub/${REPO}/${REPO_ORIGINAL}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGSTIGCHECK_INSPEC_DOCS} --baseURL=${PGSTIGCHECK_INSPEC_BASEURL}
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
