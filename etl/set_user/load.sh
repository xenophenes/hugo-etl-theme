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
source set_user_var.sh

export SET_USER_VERSION=$(echo ${SET_USER_VERSION} | sed 's/_/./g')
export SET_USER_DOCS="${DOCS}/${REPO}${REPO_MAJOR}/${SET_USER_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    for f in $(find ${CONTENT} -name '*.md')
    do
      cp $f ${DST}/static/pdf
    done

    pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/*.md -o ${DST}/static/pdf/${REPO}.pdf
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${SET_USER_VERSION}.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${SET_USER_DOCS} --baseURL="/${REPO}/${SET_USER_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

    rm ${DST}/static/pdf/*.md

    hugo --source=${DST} --destination=${SET_USER_DOCS} --baseURL="/${REPO}/${SET_USER_VERSION}"

    cp ${SET_USER_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${SET_USER_VERSION}.pdf

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
