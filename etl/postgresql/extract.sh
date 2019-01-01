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
source postgresql_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT} ${BUILD} ${TMP}
tar -xzf ${SRC}/${REPO}/*_${POSTGRESQL_VERSION}.tar.gz -C ${TMP}

#===============================================
# Build HTML from source
#===============================================

(cd ${TMP}/*_${POSTGRESQL_VERSION} && ./configure && make html)
cp -r ${TMP}/*_${POSTGRESQL_VERSION}/doc/src/sgml/html/* ${BUILD}/
