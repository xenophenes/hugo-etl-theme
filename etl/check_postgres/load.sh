#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source check_postgres_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export CHECK_POSTGRES_VERSION=$(echo ${CHECK_POSTGRES_VERSION} | sed 's/_/./g')
export CHECK_POSTGRES_DOCS="${DOCS}/${REPO_DOCS}/${CHECK_POSTGRES_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    wkhtmltopdf toc ${CONTENT}/_index.html ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${CHECK_POSTGRES_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    pandoc ${CONTENT}/_index.html -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${CHECK_POSTGRES_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${CHECK_POSTGRES_DOCS} --baseURL=${CHECK_POSTGRES_BASEURL}
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
