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
source pgbouncer_var.sh

export PGBOUNCER_VERSION=$(echo ${PGBOUNCER_VERSION} | sed 's/_/./g')
export PGBOUNCER_DOCS=${DOCS}/${REPO}/${PGBOUNCER_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    mv ${BUILD_PDF}/_index.html ${BUILD_PDF}/1.html
    mv ${BUILD_PDF}/usage.rst.html ${BUILD_PDF}/2.html
    mv ${BUILD_PDF}/config.rst.html ${BUILD_PDF}/3.html
    mv ${BUILD_PDF}/todo.rst.html ${BUILD_PDF}/4.html

    xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf toc ${BUILD_PDF}/* ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGBOUNCER_VERSION}.pdf

elif [ "$1" == '--html' ]; then

    hugo --source=${DST} --destination=${PGBOUNCER_DOCS} --baseURL="/${REPO}/${PGBOUNCER_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${PGBOUNCER_DOCS} --baseURL="/${REPO}/${PGBOUNCER_VERSION}"

    cp ${PGBOUNCER_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGBOUNCER_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
