#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="pgaudit"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${PGAUDIT_VERSION}"
