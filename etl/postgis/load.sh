#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgis_var.sh

export POSTGIS_VERSION=$(echo ${POSTGIS_VERSION} | sed 's/_/./g')
export POSTGIS_DOCS="${DOCS}/${REPO}/${POSTGIS_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${TMP}/doc && make pdf)

    cp ${TMP}/doc/postgis-*.pdf ${DST}/static/pdf/${REPO}.pdf
    cp ${TMP}/doc/postgis-*.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${POSTGIS_VERSION}.pdf
}

#function create_epub {
    #mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    #cp -r ${TMP}/doc/images ${TMP}/doc

    #(cd ${TMP}/doc && make epub)

    #cp ${TMP}/doc/postgi*.epub ${DST}/static/epub/${REPO}.epub
    #cp ${TMP}/doc/postgi*.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${POSTGIS_VERSION}.epub
#}

function create_html {
    hugo --source=${DST} --destination=${POSTGIS_DOCS} --baseURL=${POSTGIS_BASEURL}
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

#elif [ "$1" == '--epub' ]; then

#    create_epub

elif [ "$1" == '--html' ]; then

    create_html

elif [ "$1" == '--all' ]; then

    create_pdf

#    create_epub

    create_html

fi

rm -rf ${BUILD_ROOT} ${DST}

echo_end ${REPO}
