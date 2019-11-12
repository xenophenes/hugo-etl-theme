#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

REPO="postgis"
DIR="${ETL}/${REPO}"
DST="${DIR}/dst"
CONTENT="${DST}/content"
BUILD_ROOT="${DIR}/build"
BUILD="${BUILD_ROOT}/${REPO}_${POSTGIS_VERSION}"
TMP="/tmp/${REPO}_${POSTGIS_VERSION}"
