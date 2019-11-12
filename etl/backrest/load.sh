#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source backrest_var.sh

export BACKREST_VERSION=$(echo ${BACKREST_VERSION} | sed 's/_/./g')
export BACKREST_DOCS=${DOCS}/${REPO}/${BACKREST_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO} ${BUILD_PDF}

    cp ${BUILD_ROOT}/user-guide.html ${BUILD_PDF}/1.html
    cp ${BUILD_ROOT}/command.html ${BUILD_PDF}/2.html
    cp ${BUILD_ROOT}/configuration.html ${BUILD_PDF}/3.html
    cp ${BUILD_ROOT}/release.html ${BUILD_PDF}/4.html

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${BUILD_PDF}/* -o ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${BACKREST_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO} ${BUILD_EPUB}

    cp ${BUILD_ROOT}/user-guide.html ${BUILD_EPUB}/1.html
    cp ${BUILD_ROOT}/command.html ${BUILD_EPUB}/2.html
    cp ${BUILD_ROOT}/configuration.html ${BUILD_EPUB}/3.html
    cp ${BUILD_ROOT}/release.html ${BUILD_EPUB}/4.html

    pandoc ${BUILD_EPUB}/* -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${BACKREST_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${BACKREST_DOCS} --baseURL=${BACKREST_BASEURL}
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
