#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source psycopg2_var.sh

export PSYCOPG2_VERSION=$(echo ${PSYCOPG2_VERSION} | sed 's/_/./g')
export PSYCOPG2_DOCS="${DOCS}/${REPO}/${PSYCOPG2_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${BUILD}/doc/src && make latex)
    (cd ${BUILD}/doc/src/_build/latex && make all-pdf)
    cp ${BUILD}/doc/src/_build/latex/*.pdf ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PSYCOPG2_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    pandoc ${BUILD}/doc/psycopg2.txt -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PSYCOPG2_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PSYCOPG2_DOCS} --baseURL=${PSYCOPG2_BASEURL}
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
