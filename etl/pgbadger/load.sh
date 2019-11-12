#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgbadger_var.sh

export PGBADGER_VERSION=$(echo ${PGBADGER_VERSION} | sed 's/_/./g')
export PGBADGER_DOCS=${DOCS}/${REPO}/${PGBADGER_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO} ${BUILD_PDF}
    cp ${CONTENT}/_index.html ${BUILD_PDF}/_index.html

    sed -i "1,4d" ${BUILD_PDF}/_index.html
    xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf toc ${BUILD_PDF}/_index.html ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGBADGER_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO} ${BUILD_EPUB}
    cp ${CONTENT}/_index.html ${BUILD_EPUB}/_index.html

    sed -i "1,4d" ${BUILD_EPUB}/_index.html
    pandoc ${BUILD_EPUB}/_index.html -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PGBADGER_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGBADGER_DOCS} --baseURL=${PGBADGER_BASEURL}
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

rm -rf ${BUILD_ROOT} ${DST} pod2htmd.tmp

echo_end ${REPO}
