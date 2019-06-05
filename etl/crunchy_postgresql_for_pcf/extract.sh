#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
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
source crunchy_postgresql_for_pcf_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export REPO=$(echo $REPO | sed 's/\_/-/g')
export SRC_REPO="crunchy-pcf-doc"

export CRUNCHY_POSTGRESQL_FOR_PCF_VERSION=$(echo ${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION} | sed 's/_/./g')

(cd ${SRC}/${SRC_REPO} && git checkout ${CRUNCHY_POSTGRESQL_FOR_PCF_VERSION})

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${SRC_REPO}/content ${DST}
cp -r ${SRC}/${SRC_REPO}/static/* ${DST}/static/
cp -r ${SRC}/${SRC_REPO}/themes/crunchy-docs-theme ${DST}/themes/
yes | cp -f ${SRC}/${SRC_REPO}/config.yml ${DST}

export REPO=$(echo $REPO | sed 's/\-/_/g')
