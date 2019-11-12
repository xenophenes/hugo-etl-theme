#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source pg_cron_var.sh

#===============================================
# Extract & transform the files
#===============================================

echo_begin ${REPO}

source ${DIR}/extract.sh
source ${DIR}/transform.sh
