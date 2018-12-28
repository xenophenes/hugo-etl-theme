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
source check_postgres_var.sh

export CHECK_POSTGRES_VERSION=$(echo ${CHECK_POSTGRES_VERSION} | sed 's/_/./g')
export CHECK_POSTGRES_DOCS="${DOCS}/${REPO}/${CHECK_POSTGRES_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    wkhtmltopdf toc ${CONTENT}/_index.html ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    #cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${CHECK_POSTGRES_VERSION}.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${CHECK_POSTGRES_DOCS} --baseURL="/${REPO}/${CHECK_POSTGRES_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    #rm ${DST}/static/pdf/*.md

    hugo --source=${DST} --destination=${CHECK_POSTGRES_DOCS} --baseURL="/${REPO}/${CHECK_POSTGRES_VERSION}"

    #cp ${CHECK_POSTGRES_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${CHECK_POSTGRES_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}