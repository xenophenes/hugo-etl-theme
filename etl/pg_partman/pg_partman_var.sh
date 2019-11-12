#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="pg_partman"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${PG_PARTMAN_VERSION}"
BUILD_PDF="${BUILD_ROOT}/pdf"
BUILD_EPUB="${BUILD_ROOT}/epub"
