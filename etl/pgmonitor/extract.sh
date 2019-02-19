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
source pgmonitor_var.sh

#===============================================
# Extract the files from /src/
#===============================================

export PGMONITOR_VERSION=$(echo ${PGMONITOR_VERSION} | sed 's/_/./g')

(cd ${SRC}/${REPO} && git checkout tags/v${PGMONITOR_VERSION})

export PGMONITOR_VERSION=$(echo ${PGMONITOR_VERSION} | sed 's/./_/g')

cp -r ${TEMPLATE} ${DST}
cp -r ${SRC}/${REPO}/hugo/content ${DST}
cp -r ${SRC}/${REPO}/hugo/static/* ${DST}/static/
yes | cp -f ${SRC}/${REPO}/hugo/config.toml ${DST}
