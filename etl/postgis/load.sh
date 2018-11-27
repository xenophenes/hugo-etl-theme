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
source postgis_var.sh

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf
    mkdir -p ${ETL_PATH}/pdf/${REPO}

    (cd ${TMP}/doc && make pdf)

    cp ${TMP}/doc/postgis-*.pdf ${DST}/static/pdf/${REPO}.pdf
    cp ${TMP}/doc/postgis-*.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${POSTGIS_VERSION}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${POSTGIS_DOCS}

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${POSTGIS_DOCS}

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
