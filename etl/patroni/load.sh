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
source patroni_var.sh

export PATRONI_VERSION=$(echo ${PATRONI_VERSION} | sed 's/_/./g')
export PATRONI_DOCS="${DOCS}/${REPO}/${PATRONI_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    sed -i '/:caption:/d' ${BUILD_PDF}/docs/index.rst
    sphinx-build -b latex ${BUILD_PDF}/docs ${BUILD_PDF}/pdfout

    sed -i '/usepackage{multirow}/r latex-add.txt' ${BUILD_PDF}/pdfout/Patroni.tex

    (cd ${BUILD_PDF}/pdfout && make all-pdf)
    cp ${BUILD_PDF}/pdfout/*.pdf ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PATRONI_VERSION}.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${PATRONI_DOCS} --baseURL="/${REPO}/${PATRONI_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${PATRONI_DOCS} --baseURL="/${REPO}/${PATRONI_VERSION}"

    cp ${PATRONI_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PATRONI_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
