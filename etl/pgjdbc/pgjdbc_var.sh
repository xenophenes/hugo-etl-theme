#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="pgjdbc"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
JEKYLL="${DIR}/jekyll"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${PGJDBC_VERSION}/docs"
