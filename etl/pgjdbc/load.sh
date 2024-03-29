#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgjdbc_var.sh

export PGJDBC_VERSION=$(echo ${PGJDBC_VERSION} | sed 's/_/./g')
export PGJDBC_DOCS="${DOCS}/${REPO}/${PGJDBC_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    #mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    echo "No PDF functionality for this project at this time."

    # No PDF functionality (yet)

    #rm ${DST}/static/pdf/*.md
    #cp ${PGJDBC_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGJDBC_VERSION}.pdf
}

function create_epub {
    #mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    echo "No EPUB functionality for this project at this time."

    # No PDF functionality (yet)

    #rm ${DST}/static/pdf/*.md
    #cp ${PGJDBC_DOCS}/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGJDBC_VERSION}.pdf
}

function create_html {
    hugo --source=${DST} --destination=${PGJDBC_DOCS} --baseURL=${PGJDBC_BASEURL}
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

    create_html

fi

rm -rf ${BUILD_ROOT} ${DST} ${JEKYLL}

echo_end ${REPO}
