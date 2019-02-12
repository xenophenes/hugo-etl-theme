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
source crunchy_containers_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export CRUNCHY_CONTAINERS_VERSION=$(echo ${CRUNCHY_CONTAINERS_VERSION} | sed 's/_/./g')
export CRUNCHY_CONTAINERS_DOCS="${DOCS}/${REPO_DOCS}/${CRUNCHY_CONTAINERS_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are at the top.

    cp ${CONTENT}/_index.md ${DST}/static/pdf/0001.md
    cp ${CONTENT}/overview/overview.md ${DST}/static/pdf/0002.md
    cp ${CONTENT}/overview/supported.md ${DST}/static/pdf/0003.md
    cp ${CONTENT}/client-user-guide/user-guide.md ${DST}/static/pdf/0004.md
    cp ${CONTENT}/client-user-guide/usage.md ${DST}/static/pdf/0005.md
    cp ${CONTENT}/troubleshooting/_index.md ${DST}/static/pdf/0006.md

    # The rest of the files are numbered and moved to the build location.

    find ${CONTENT} -name '*.md' ! -name "_index.md" ! -path "${CONTENT}/overview/*" \
    ! -path "${CONTENT}/troubleshooting/*" ! -path "${CONTENT}/client-user-guide/*" \
    ! -path "${CONTENT}/contributing/*" |
    gawk 'BEGIN{ a=7 }{ printf "cp %s '${DST}'/static/pdf/%04d.md\n", $0, a++ }' |
    bash

    # Images need to be re-referenced to point to the correct location, so pandoc
    # finds them.

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/pdf/*.md

    # Remove instances of {{% notice X %}}, but not their content.

    sed -i "s/{{%[^%]*%}}//g" ${DST}/static/pdf/*.md

    # Including listings-setup to expand the margins and make sure code blocks are
    # not cut off.

    (cd ${DST}/static/pdf && \
    pandoc -s *.md --listings -H ${ETL_PATH}/etl/common/common.tex --toc --toc-depth=1 \
    --latex-engine=xelatex -o ${REPO}.pdf)

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are at the top.

    cp ${CONTENT}/_index.md ${DST}/static/epub/0001.md
    cp ${CONTENT}/overview/overview.md ${DST}/static/epub/0002.md
    cp ${CONTENT}/overview/supported.md ${DST}/static/epub/0003.md
    cp ${CONTENT}/client-user-guide/user-guide.md ${DST}/static/epub/0004.md
    cp ${CONTENT}/client-user-guide/usage.md ${DST}/static/epub/0005.md
    cp ${CONTENT}/troubleshooting/_index.md ${DST}/static/epub/0006.md

    # The rest of the files are numbered and moved to the build location.

    find ${CONTENT} -name '*.md' ! -name "_index.md" ! -path "${CONTENT}/overview/*" \
    ! -path "${CONTENT}/troubleshooting/*" ! -path "${CONTENT}/client-user-guide/*" \
    ! -path "${CONTENT}/contributing/*" |
    gawk 'BEGIN{ a=7 }{ printf "cp %s '${DST}'/static/epub/%04d.md\n", $0, a++ }' |
    bash

    # Images need to be re-referenced to point to the correct location, so pandoc
    # finds them.

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/epub/*.md

    # Remove instances of {{% notice X %}}, but not their content.

    sed -i "s/{{%[^%]*%}}//g" ${DST}/static/epub/*.md

    (cd ${DST}/static/epub && pandoc -s *.md -o ${REPO}.epub)

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}.epub
}

function create_html {
    hugo --source=${DST} --destination=${CRUNCHY_CONTAINERS_DOCS} --baseURL=${CRUNCHY_CONTAINERS_BASEURL}
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

    if [[ ${CRUNCHY_CONTAINERS_VERSION} < 2.3.0 ]]; then
      create_html
    else
      create_pdf
      create_epub
      create_html
    fi

fi

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
