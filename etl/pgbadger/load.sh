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
source pgbadger_var.sh

export PGBADGER_VERSION=$(echo ${PGBADGER_VERSION} | sed 's/_/./g')
export PGBADGER_DOCS=${DOCS}/${REPO}/${PGBADGER_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO} ${BUILD_PDF}
    cp ${CONTENT}/_index.html ${BUILD_PDF}/_index.html

    sed -i "1,4d" ${BUILD_PDF}/_index.html
    xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf toc ${BUILD_PDF}/_index.html ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGBADGER_VERSION}.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${PGBADGER_DOCS} --baseURL="/${REPO}/${PGBADGER_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${PGBADGER_DOCS} --baseURL="/${REPO}/${PGBADGER_VERSION}"

    cp ${PGBADGER_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGBADGER_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST} pod2htmd.tmp

echo_end ${REPO}
