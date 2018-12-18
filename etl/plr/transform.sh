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

mv ${BUILD}/README.md ${CONTENT}/_index.md
mv ${BUILD}/doc/*.md ${CONTENT}

#===============================================
# Process the HTML files
#===============================================

for f in $(find ${CONTENT} -name '*.md' ! -name '*index.md')
do
  # Place each file into its own folder
  FILE=$(basename "$f" | cut -f 1 -d '.')
  mkdir -p ${CONTENT}/${FILE}
  mv ${f} ${CONTENT}/${FILE}/_index.md
done

sed -i '/PGXN/d' ${CONTENT}/_index.md
sed -i "1,2d" ${CONTENT}/migration_to_partman/_index.md
sed -i "1,2d" ${CONTENT}/plr/_index.md
sed -i "1,2d" ${CONTENT}/plr_howto/_index.md

sed -i '1s;^;---\ntitle: "Migrating An Existing Partition Set to PG Partition Manager"\ndraft: false\n---\n\n;' ${CONTENT}/migration_to_partman/_index.md
sed -i '1s;^;---\ntitle: "PostgreSQL Partition Manager Extension (`plr`)"\ndraft: false\n---\n\n;' ${CONTENT}/plr/_index.md
sed -i '1s;^;---\ntitle: "Example Guide On Setting Up Trigger-based Partitioning"\ndraft: false\n---\n\n;' ${CONTENT}/plr_howto/_index.md
