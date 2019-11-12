#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source crunchy_postgresql_for_pcf_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export CRUNCHY_POSTGRESQL_FOR_PCF_VERSION=$(echo ${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION} | sed 's/_/./g')
export CRUNCHY_POSTGRESQL_FOR_PCF_DOCS="${DOCS}/${REPO_DOCS}/${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    pandoc --toc --pdf-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${CONTENT}/_index.md -o ${DST}/static/pdf/${REPO}.pdf

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    pandoc ${CONTENT}/_index.md -o ${DST}/static/epub/${REPO}.epub

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --config=config.yml --destination=${CRUNCHY_POSTGRESQL_FOR_PCF_DOCS} --baseURL=${CRUNCHY_POSTGRESQL_FOR_PCF_BASEURL}
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

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
