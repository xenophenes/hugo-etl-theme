#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgaudit_var.sh

export PGAUDIT_VERSION=$(echo ${PGAUDIT_VERSION} | sed 's/_/./g')
export PGAUDIT_DOCS="${DOCS}/${REPO}/${PGAUDIT_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/pdf

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${DST}/static/pdf/*.md -o ${DST}/static/pdf/${REPO}.pdf

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGAUDIT_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/epub

    pandoc ${DST}/static/epub/*.md -o ${DST}/static/epub/${REPO}.epub

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PGAUDIT_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGAUDIT_DOCS} --baseURL=${PGAUDIT_BASEURL}
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
