#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source amcheck_next_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export AMCHECK_NEXT_VERSION=$(echo ${AMCHECK_NEXT_VERSION} | sed 's/_/./g')
export AMCHECK_NEXT_DOCS="${DOCS}/${REPO_DOCS}/${AMCHECK_NEXT_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/pdf

    sed -i '/### Test status/d' ${DST}/static/pdf/_index.md
    sed -i '/\[\!\[Build Status\]/d' ${DST}/static/pdf/_index.md

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${DST}/static/pdf/_index.md -o ${DST}/static/pdf/${REPO}.pdf

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${AMCHECK_NEXT_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/epub

    sed -i '/### Test status/d' ${DST}/static/epub/_index.md
    sed -i '/\[\!\[Build Status\]/d' ${DST}/static/epub/_index.md

    pandoc ${DST}/static/epub/_index.md -o ${DST}/static/epub/${REPO}.epub

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${AMCHECK_NEXT_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${AMCHECK_NEXT_DOCS} --baseURL=${AMCHECK_NEXT_BASEURL}
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

    create_pdf

    create_epub

    create_html

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
