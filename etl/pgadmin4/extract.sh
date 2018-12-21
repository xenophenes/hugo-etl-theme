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
source pgadmin4_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT}
tar -xzf ${SRC}/${REPO}/${REPO}_${PGADMIN4_VERSION}*.tar.gz -C ${BUILD_ROOT}

#===============================================
# Build HTML from source
#===============================================

# Need a fix to repair a missing theme & orphaned document
sed -i "/html_theme = 'classic'/d" ${BUILD}/docs/en_US/conf.py
rm ${BUILD}/docs/en_US/tablespace_dialog.rst

(cd ${BUILD} && make docs)