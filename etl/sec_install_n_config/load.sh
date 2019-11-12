#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source sec_install_n_config_var.sh

export SEC_INSTALL_N_CONFIG_VERSION=$(echo ${SEC_INSTALL_N_CONFIG_VERSION} | sed 's/_/./g')
export SEC_INSTALL_N_CONFIG_DOCS="${DOCS}/postgresql-security-guide/${SEC_INSTALL_N_CONFIG_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_10.md
    cp ${CONTENT}/96/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_96.md
    cp ${CONTENT}/95/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_95.md

    cp -r ${DST}/static/media .

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${DST}/static/pdf/crunchy_certified_postgresql_10.md -o ${DST}/static/pdf/crunchy_certified_postgresql_10.pdf

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${DST}/static/pdf/crunchy_certified_postgresql_96.md -o ${DST}/static/pdf/crunchy_certified_postgresql_96.pdf

    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    ${DST}/static/pdf/crunchy_certified_postgresql_95.md -o ${DST}/static/pdf/crunchy_certified_postgresql_95.pdf

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/crunchy_certified_postgresql_10.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_10.pdf
    cp ${DST}/static/pdf/crunchy_certified_postgresql_96.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_96.pdf
    cp ${DST}/static/pdf/crunchy_certified_postgresql_95.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_95.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    cp ${CONTENT}/_index.md ${DST}/static/epub/crunchy_certified_postgresql_10.md
    cp ${CONTENT}/96/_index.md ${DST}/static/epub/crunchy_certified_postgresql_96.md
    cp ${CONTENT}/95/_index.md ${DST}/static/epub/crunchy_certified_postgresql_95.md

    cp -r ${DST}/static/media .

    pandoc ${DST}/static/epub/crunchy_certified_postgresql_10.md -o ${DST}/static/epub/crunchy_certified_postgresql_10.epub
    pandoc ${DST}/static/epub/crunchy_certified_postgresql_96.md -o ${DST}/static/epub/crunchy_certified_postgresql_96.epub
    pandoc ${DST}/static/epub/crunchy_certified_postgresql_95.md -o ${DST}/static/epub/crunchy_certified_postgresql_95.epub

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/crunchy_certified_postgresql_10.epub ${ETL_PATH}/epub/${REPO}/crunchy_certified_postgresql_10.epub
    cp ${DST}/static/epub/crunchy_certified_postgresql_96.epub ${ETL_PATH}/epub/${REPO}/crunchy_certified_postgresql_96.epub
    cp ${DST}/static/epub/crunchy_certified_postgresql_95.epub ${ETL_PATH}/epub/${REPO}/crunchy_certified_postgresql_95.epub
}

function create_html {
    hugo --source=${DST} --destination=${SEC_INSTALL_N_CONFIG_DOCS} --baseURL=${SEC_INSTALL_N_CONFIG_BASEURL}
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

rm -rf ${BUILD} ${DST} media

echo_end ${REPO}
