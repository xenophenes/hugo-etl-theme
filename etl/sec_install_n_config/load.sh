#!/bin/bash
#=========================================================================
# Copyright 2018 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source sec_install_n_config_var.sh

export SEC_INSTALL_N_CONFIG_VERSION=$(echo ${SEC_INSTALL_N_CONFIG_VERSION} | sed 's/_/./g')
export SEC_INSTALL_N_CONFIG_DOCS="${DOCS}/${REPO}/${SEC_INSTALL_N_CONFIG_VERSION}"

#===============================================
# 1) Functions
#===============================================

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

<<<<<<< a1617f7281cb60a1cd711f1d997d330ae82da77d
    cp ${CONTENT}/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_10.md
    cp ${CONTENT}/96/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_96.md
    cp ${CONTENT}/95/_index.md ${DST}/static/pdf/crunchy_certified_postgresql_95.md

    cp -r ${DST}/static/media .

    pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/crunchy_certified_postgresql_10.md -o ${DST}/static/pdf/crunchy_certified_postgresql_10.pdf
    pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/crunchy_certified_postgresql_96.md -o ${DST}/static/pdf/crunchy_certified_postgresql_96.pdf
    pandoc --toc --latex-engine=xelatex ${DST}/static/pdf/crunchy_certified_postgresql_95.md -o ${DST}/static/pdf/crunchy_certified_postgresql_95.pdf
=======
    cp ${CONTENT}/_index.html ${DST}/static/pdf/crunchy_certified_postgresql_10.html
    cp ${CONTENT}/96/_index.html ${DST}/static/pdf/crunchy_certified_postgresql_96.html
    cp ${CONTENT}/95/_index.html ${DST}/static/pdf/crunchy_certified_postgresql_95.html

    cp -r ${DST}/static/media ${DST}/static/pdf

    wkhtmltopdf toc ${DST}/static/pdf/crunchy_certified_postgresql_10.html ${DST}/static/pdf/crunchy_certified_postgresql_10.pdf
    wkhtmltopdf toc ${DST}/static/pdf/crunchy_certified_postgresql_96.html ${DST}/static/pdf/crunchy_certified_postgresql_96.pdf
    wkhtmltopdf toc ${DST}/static/pdf/crunchy_certified_postgresql_95.html ${DST}/static/pdf/crunchy_certified_postgresql_95.pdf
>>>>>>> Tie in sec_install_n_config
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--no-html' ]; then

    create_pdf

    cp ${DST}/static/pdf/crunchy_certified_postgresql_10.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_10.pdf
    cp ${DST}/static/pdf/crunchy_certified_postgresql_96.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_96.pdf
    cp ${DST}/static/pdf/crunchy_certified_postgresql_95.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_95.pdf

elif [ "$1" == '--no-pdf' ]; then

    hugo --source=${DST} --destination=${SEC_INSTALL_N_CONFIG_DOCS} --baseURL="/${REPO}/${SEC_INSTALL_N_CONFIG_VERSION}"

elif [ "$1" == '--all' ]; then

    create_pdf

<<<<<<< a1617f7281cb60a1cd711f1d997d330ae82da77d
    rm -rf ${DST}/static/pdf/*.md media
=======
    rm -rf ${DST}/static/pdf/*.html ${DST}/static/pdf/media
>>>>>>> Tie in sec_install_n_config

    hugo --source=${DST} --destination=${SEC_INSTALL_N_CONFIG_DOCS} --baseURL="/${REPO}/${SEC_INSTALL_N_CONFIG_VERSION}"

    cp ${SEC_INSTALL_N_CONFIG_DOCS}/pdf/crunchy_certified_postgresql_10.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_10.pdf
    cp ${SEC_INSTALL_N_CONFIG_DOCS}/pdf/crunchy_certified_postgresql_96.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_96.pdf
    cp ${SEC_INSTALL_N_CONFIG_DOCS}/pdf/crunchy_certified_postgresql_95.pdf ${ETL_PATH}/pdf/${REPO}/crunchy_certified_postgresql_95.pdf

fi

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
