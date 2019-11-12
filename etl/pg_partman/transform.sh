#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pg_partman_var.sh

#===============================================
# Set up the destination structure
#===============================================

cp -r ${TEMPLATE} ${DST}
yes | cp -f ${DIR}/config.toml ${DST}
cp ${TEMPLATE}/layouts/google-analytics.html ${DST}/themes/crunchy-hugo-theme/layouts/partials/google-analytics.html
cp ${TEMPLATE}/static/fonts/Fort-* ${DST}/themes/crunchy-hugo-theme/static/fonts/
cp ${TEMPLATE}/static/css/Fort-* ${DST}/themes/crunchy-hugo-theme/static/css/

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
sed -i "1,2d" ${CONTENT}/pg_partman/_index.md
sed -i "1,2d" ${CONTENT}/pg_partman_howto/_index.md

sed -i '1s;^;---\ntitle: "Migrating An Existing Partition Set to PG Partition Manager"\ndraft: false\n---\n\n;' ${CONTENT}/migration_to_partman/_index.md
sed -i '1s;^;---\ntitle: "PostgreSQL Partition Manager Extension (`pg_partman`)"\ndraft: false\n---\n\n;' ${CONTENT}/pg_partman/_index.md
sed -i '1s;^;---\ntitle: "Example Guide On Setting Up Trigger-based Partitioning"\ndraft: false\n---\n\n;' ${CONTENT}/pg_partman_howto/_index.md
