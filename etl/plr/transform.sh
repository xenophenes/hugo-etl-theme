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
source plr_var.sh

#===============================================
# Set up the destination structure
#===============================================

cp -r ${TEMPLATE} ${DST}
yes | cp -f ${DIR}/config.toml ${DST}

#===============================================
# Move files to destination directory
#===============================================

mv ${BUILD}/userguide.md ${CONTENT}/_index.md

#===============================================
# Process the HTML files
#===============================================

sed -i "1,10d" ${CONTENT}/_index.md

sed -i '1s;^;<h1>PL/R User’s Guide - R Procedural Language</h1>\n\n;' ${CONTENT}/_index.md
sed -i '1s;^;---\ntitle: "PL/R User’s Guide - R Procedural Language"\ndraft: false\n---\n\n;' ${CONTENT}/_index.md