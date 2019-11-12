#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgrouting_var.sh

export PGROUTING_VERSION=$(echo ${PGROUTING_VERSION} | sed 's/_/./g')
export PGROUTING_DOCS="${DOCS}/${REPO}/${PGROUTING_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${BUILD}/build && sphinx-build -b singlehtml doc singlehtml)
    (cd ${BUILD}/build/singlehtml && \
    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${BUILD}/build/singlehtml/index.html -o ${DST}/static/pdf/${REPO}.pdf)

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGROUTING_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    (cd ${BUILD}/build && sphinx-build -b singlehtml doc singlehtml)
    (cd ${BUILD}/build/singlehtml && pandoc ${BUILD}/build/singlehtml/index.html -o ${DST}/static/epub/${REPO}.epub)

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PGROUTING_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGROUTING_DOCS} --baseURL=${PGROUTING_BASEURL}
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

#rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
