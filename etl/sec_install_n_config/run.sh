#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source sec_install_n_config_var.sh

#===============================================
# Extract & transform the files
#===============================================

echo_begin ${REPO}

source ${DIR}/extract.sh
source ${DIR}/transform.sh
