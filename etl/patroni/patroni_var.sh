#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="patroni"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD_SRC="${BUILD_ROOT}/${REPO}_${PATRONI_VERSION}/docs"
BUILD_PDF="${BUILD_ROOT}/pdf"
BUILD_EPUB="${BUILD_ROOT}/epub"
BUILD="${BUILD_ROOT}/output"
