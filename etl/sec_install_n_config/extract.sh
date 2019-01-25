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
source sec_install_n_config_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${DST}
cp -r ${TEMPLATE}/* ${DST}
(cd ${SRC}/${REPO} && git checkout hugo)
cp -r ${SRC}/${REPO}/content ${DST}
cp -r ${SRC}/${REPO}/static/* ${DST}/static/
yes | cp -f ${SRC}/${REPO}/config.toml ${DST}
