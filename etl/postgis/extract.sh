#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
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
source postgis_var.sh

#===============================================
# Extract the files from /src/
#===============================================

mkdir -p ${BUILD_ROOT} ${BUILD}
tar -xzf ${SRC}/${REPO}/${REPO}_${POSTGIS_VERSION}.tar.gz -C /tmp/

#===============================================
# Build HTML from source
#===============================================

(cd ${TMP} && ./autogen.sh && ./configure --without-raster)

# Create new definition in Makefile, to install directly to BUILD
printf "
postgis-install: html/postgis.html
\tmkdir -p ${BUILD}/images
\t/usr/bin/install -c -m 644 html/postgis.html ${BUILD}
\t/usr/bin/install -c -m 644 html/images/* ${BUILD}/images/" >> ${TMP}/doc/Makefile

(cd ${TMP}/doc && make postgis-install)
