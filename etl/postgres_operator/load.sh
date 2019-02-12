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
source postgres_operator_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export POSTGRES_OPERATOR_VERSION=$(echo ${POSTGRES_OPERATOR_VERSION} | sed 's/_/./g')
export POSTGRES_OPERATOR_DOCS="${DOCS}/${REPO_DOCS}/${POSTGRES_OPERATOR_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are organized.

    cp ${CONTENT}/_index.md ${DST}/static/pdf/1.md
    cp ${CONTENT}/Installation/_index.md ${DST}/static/pdf/2.md
    cp ${CONTENT}/Configuration/configuration.md ${DST}/static/pdf/3.md
    cp ${CONTENT}/Configuration/pgo-yaml-configuration.md ${DST}/static/pdf/4.md
    cp ${CONTENT}/Operator*CLI/_index.md ${DST}/static/pdf/5.md
    cp ${CONTENT}/Design/_index.md ${DST}/static/pdf/6.md
    cp ${CONTENT}/Developer*Setup/_index.md ${DST}/static/pdf/7.md
    cp ${CONTENT}/Security/_index.md ${DST}/static/pdf/8.md
    cp ${CONTENT}/Upgrade/_index.md ${DST}/static/pdf/9.md

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/pdf/*.md

    (cd ${DST}/static/pdf && \
    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    *.md -o ${REPO}.pdf)

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are organized.

    cp ${CONTENT}/_index.md ${DST}/static/epub/1.md
    cp ${CONTENT}/Installation/_index.md ${DST}/static/epub/2.md
    cp ${CONTENT}/Configuration/configuration.md ${DST}/static/epub/3.md
    cp ${CONTENT}/Configuration/pgo-yaml-configuration.md ${DST}/static/epub/4.md
    cp ${CONTENT}/Operator*CLI/_index.md ${DST}/static/epub/5.md
    cp ${CONTENT}/Design/_index.md ${DST}/static/epub/6.md
    cp ${CONTENT}/Developer*Setup/_index.md ${DST}/static/epub/7.md
    cp ${CONTENT}/Security/_index.md ${DST}/static/epub/8.md
    cp ${CONTENT}/Upgrade/_index.md ${DST}/static/epub/9.md

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/epub/*.md

    (cd ${DST}/static/epub && pandoc *.md -o ${REPO}.epub)

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}.epub
}

function create_html {
    hugo --source=${DST} --destination=${POSTGRES_OPERATOR_DOCS} --baseURL=${POSTGRES_OPERATOR_BASEURL}
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

elif [ "$1" == '--epub' ]; then

    create_epub

elif [ "$1" == '--html' ]; then

    create_html

elif [ "$1" == '--all' ]; then

  if [[ ${POSTGRES_OPERATOR_VERSION} < 3.5.0 ]]; then
    create_html
  else
    create_pdf
    create_epub
    create_html
  fi

fi

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
