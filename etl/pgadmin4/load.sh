#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pgadmin4_var.sh

export PGADMIN4_VERSION=$(echo ${PGADMIN4_VERSION} | sed 's/_/./g')
export PGADMIN4_DOCS=${DOCS}/${REPO}/${PGADMIN4_VERSION}

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${BUILD}/docs && sphinx-build -b latex en_US out)
    sed -Ei 's/chapter\{\\index\{(.*?)\}(.*?)}/chapter{\1}/g' ${BUILD}/docs/out/pgadmin4.tex
    (cd ${BUILD}/docs/out && pdflatex pgadmin4.tex && cp *.pdf ${DST}/static/pdf/${REPO}.pdf)

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${PGADMIN4_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    (cd ${BUILD}/docs && sphinx-build -b latex en_US out)
    sed -Ei 's/chapter\{\\index\{(.*?)\}(.*?)}/chapter{\1}/g' ${BUILD}/docs/out/pgadmin4.tex
    (cd ${BUILD}/docs/out && pandoc pgadmin4.tex -o ${DST}/static/epub/${REPO}.epub)

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${PGADMIN4_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${PGADMIN4_DOCS} --baseURL=${PGADMIN4_BASEURL}
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
