#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="postgresql"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${POSTGRESQL_VERSION}"
TMP="/tmp/${REPO}_${POSTGRESQL_VERSION}"
if [[ "$POSTGRESQL_VERSION" == "9"* ]]; then
    REPO_MAJOR=$(echo ${POSTGRESQL_VERSION} | sed -r 's/([^_]*)_([^_]*).*/\1\2/')
else
    REPO_MAJOR=$(echo ${POSTGRESQL_VERSION} | sed -r 's/([^_]*).*/\1/')
fi
