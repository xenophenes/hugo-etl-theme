#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="pgrouting"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${PGROUTING_VERSION}"
