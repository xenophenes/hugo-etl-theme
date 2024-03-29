#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pg_partman_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export PG_PARTMAN_VERSION=$(echo ${PG_PARTMAN_VERSION} | sed 's/_/./g')
export PG_PARTMAN_DOCS=${DOCS}/${REPO_DOCS}/${PG_PARTMAN_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO} ${BUILD_PDF}

    cp ${CONTENT}/_index.md ${BUILD_PDF}/1.md
    cp ${CONTENT}/pg_partman/_index.md ${BUILD_PDF}/2.md
    cp ${CONTENT}/pg_partman_howto/_index.md ${BUILD_PDF}/3.md
    cp ${CONTENT}/migration_to_partman/_index.md ${BUILD_PDF}/4.md

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${BUILD_PDF}/* -o ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PG_PARTMAN_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO} ${BUILD_EPUB}

    cp ${CONTENT}/_index.md ${BUILD_EPUB}/1.md
    cp ${CONTENT}/pg_partman/_index.md ${BUILD_EPUB}/2.md
    cp ${CONTENT}/pg_partman_howto/_index.md ${BUILD_EPUB}/3.md
    cp ${CONTENT}/migration_to_partman/_index.md ${BUILD_EPUB}/4.md

    pandoc ${BUILD_EPUB}/* -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PG_PARTMAN_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PG_PARTMAN_DOCS} --baseURL=${PG_PARTMAN_BASEURL}
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
