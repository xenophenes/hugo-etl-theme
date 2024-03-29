#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgresql_var.sh

export OLD_POSTGRESQL_VERSION=$(echo ${POSTGRESQL_VERSION})
export POSTGRESQL_VERSION=$(echo ${POSTGRESQL_VERSION} | sed 's/_/./g')
export POSTGRESQL_DOCS="${DOCS}/${REPO}${REPO_MAJOR}/${POSTGRESQL_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    (cd ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/ && make postgres-US.pdf)

    cp ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/postgres-US.pdf ${DST}/static/pdf/${REPO}.pdf
    cp ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/postgres-US.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}_${POSTGRESQL_VERSION}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    (cd ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/ && make postgres.epub)

    cp ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/postgre*.epub ${DST}/static/epub/${REPO}.epub
    cp ${TMP}/*_${OLD_POSTGRESQL_VERSION}/doc/src/sgml/postgre*.epub ${ETL_PATH}/epub/${REPO}/${REPO}_${POSTGRESQL_VERSION}.epub
}

function create_html {
    hugo --source=${DST} --destination=${POSTGRESQL_DOCS} --baseURL=${POSTGRESQL_BASEURL}
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
