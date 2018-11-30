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
source backrest_var.sh

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    mv ${BUILD_PDF}/_index.md ${BUILD_PDF}/1.md
    mv ${BUILD_PDF}/user-guide.html ${BUILD_PDF}/2.html
    mv ${BUILD_PDF}/command.html ${BUILD_PDF}/3.html
    mv ${BUILD_PDF}/configuration.html ${BUILD_PDF}/4.html
    mv ${BUILD_PDF}/release.html ${BUILD_PDF}/5.html

    pandoc --toc --latex-engine=xelatex ${BUILD_PDF}/* -o ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${BACKREST_VERSION}.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${BACKREST_DOCS}

elif [ "$1" == '--all' ]; then

    create_pdf

    hugo --source=${DST} --destination=${BACKREST_DOCS}

    cp ${BACKREST_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${BACKREST_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
