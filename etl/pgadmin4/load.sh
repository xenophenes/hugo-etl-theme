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
source pgadmin4_var.sh

export PGADMIN4_VERSION=$(echo ${PGADMIN4_VERSION} | sed 's/_/./g')
export PGADMIN4_DOCS=${DOCS}/${REPO}/${PGADMIN4_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${BUILD}/docs && sphinx-build -b latex en_US out)
    sed -Ei 's/chapter\{\\index\{(.*?)\}(.*?)}/chapter{\1}/g' ${BUILD}/docs/out/pgadmin4.tex
    (cd ${BUILD}/docs/out && pdflatex pgadmin4.tex && cp *.pdf ${DST}/static/pdf/${REPO}.pdf)
}

function create_docs {
    hugo --source=${DST} --destination=${PGADMIN4_DOCS} --baseURL="/${REPO}/${PGADMIN4_VERSION}"
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGADMIN4_VERSION}.pdf

elif [ "$1" == '--html' ]; then

    create_docs

elif [ "$1" == '--all' ]; then

    create_pdf

    create_docs

    cp ${PGADMIN4_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGADMIN4_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
