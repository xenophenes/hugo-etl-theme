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
source pg_cron_var.sh

export PG_CRON_VERSION=$(echo ${PG_CRON_VERSION} | sed 's/_/./g')
export PG_CRON_DOCS="${DOCS}/${REPO}/${PG_CRON_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/pdf

    pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/_index.md -o ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PG_CRON_VERSION}.pdf

elif [ "$1" == '--html' ]; then

    hugo --source=${DST} --destination=${PG_CRON_DOCS} --baseURL="/${REPO}/${PG_CRON_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    rm ${DST}/static/pdf/*.md

    hugo --source=${DST} --destination=${PG_CRON_DOCS} --baseURL="/${REPO}/${PG_CRON_VERSION}"

    cp ${PG_CRON_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PG_CRON_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
