#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgstigcheck_inspec_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export PGSTIGCHECK_INSPEC_VERSION=$(echo ${PGSTIGCHECK_INSPEC_VERSION} | sed 's/_/./g')
export PGSTIGCHECK_INSPEC_DOCS="${DOCS}/${REPO_DOCS}/${PGSTIGCHECK_INSPEC_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${CONTENT}/_index.md -o ${DST}/static/pdf/${REPO_DOCS}.pdf

    cp ${DST}/static/pdf/${REPO_DOCS}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO_DOCS}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    pandoc ${CONTENT}/_index.md -o ${DST}/static/epub/${REPO_DOCS}.epub

    cp ${DST}/static/epub/${REPO_DOCS}.epub ${ETL_PATH}/epub/${REPO}/${REPO_DOCS}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGSTIGCHECK_INSPEC_DOCS} --baseURL=${PGSTIGCHECK_INSPEC_BASEURL}
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
