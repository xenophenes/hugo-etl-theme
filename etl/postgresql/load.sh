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
source postgresql_var.sh

export POSTGRESQL_VERSION=$(echo ${POSTGRESQL_VERSION} | sed 's/_/./g')
export POSTGRESQL_DOCS="${DOCS}/${REPO}${REPO_MAJOR}/${POSTGRESQL_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${TMP}/*_${POSTGRESQL_VERSION}/doc/src/sgml/ && make postgres-US.pdf)

    cp ${TMP}/*_${POSTGRESQL_VERSION}/doc/src/sgml/postgres-US.pdf ${DST}/static/pdf/${REPO}.pdf
    cp ${TMP}/*_${POSTGRESQL_VERSION}/doc/src/sgml/postgres-US.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${POSTGRESQL_VERSION}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${POSTGRESQL_DOCS} --baseURL="/${REPO}${REPO_MAJOR}/${POSTGRESQL_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${POSTGRESQL_DOCS} --baseURL="/${REPO}${REPO_MAJOR}/${POSTGRESQL_VERSION}"

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
