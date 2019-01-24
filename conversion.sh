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

#==============
# 0) Sources
#==============

if [[ $(pwd) == *"priv-all-portal-docs"* ]]; then
    export ETL_PATH=$(echo $(pwd))
else
    echo "Error-- $0 must be called from inside the priv-all-portal-docs directory"
    exit 1
fi

source etl/common/common.sh

#==============
# 1) Functions
#==============

function usage {
    echo ""
    echo "Usage: $ ./conversion.sh [project_name] [project_version] [flags] (baseURL)"
    echo ""
    echo "Example of a command:"
    echo ""
    echo "./conversion.sh pgaudit 1.3.0 --all /examplesite/project"
    echo ""
    echo "Available project names:"
    echo ""
    echo "   amcheck_next"
    echo "   backrest"
    echo "   patroni"
    echo "   pgadmin4"
    echo "   pgaudit"
    echo "   pgaudit_analyze"
    echo "   pgbadger"
    echo "   pgbouncer"
    echo "   pg_partman"
    echo "   pgjdbc"
    echo "   pgmonitor"
    echo "   pgpool"
    echo "   pgrouting"
    echo "   pgstigcheck-inspec"
    echo "   plr"
    echo "   postgis"
    echo "   postgres_operator"
    echo "   postgresql"
    echo "   psycopg2"
    echo "   sec_install_n_config"
    echo "   set_user"
    echo ""
    echo "Available project versions:"
    echo ""
    echo "   All project versions available to be converted."
    echo "   Ensure the version number takes the format X.X.X, using periods as separators."
    echo ""
    echo "Available flags: "
    echo ""
    echo "   --pdf"
    echo "   --epub"
    echo "   --html"
    echo "   --all"
    echo ""
    echo "If baseURL is not specified, the default of \$PROJECT_NAME/\$PROJECT_VERSION is used."
    echo ""
    exit 1
}

function remove_project {
    # Clean up any and all leftover build artifacts from incomplete builds

    if [[ -d ${ETL}/${1}/build ]] || [[ -d ${ETL}/${1}/dst ]]
    then
        rm -rf ${ETL}/${1}/build ${ETL}/${1}/dst && echo_info "Deleted the build artifacts from the data directory." || echo_err "The build artifacts were not successfully deleted from the data directory."
    fi
}

function extract_transform {
    # Check if baseURL is specified; if so, set it in load.sh for that project

    if [ "$#" -eq 3 ]; then
      export PROJECT_BASEURL=$(echo ${2^^}\_BASEURL)
      export PROJECT_NAME=$2
      export PROJECT_DOCS=$(echo ${PROJECT_NAME} | sed 's/_/-/g')
      export PROJECT_VERSION=$3
      export ${PROJECT_BASEURL}=${1}/${PROJECT_DOCS}/${PROJECT_VERSION}
    elif [ "$#" -eq 2 ]; then
      export PROJECT_BASEURL=$(echo ${1^^}\_BASEURL)
      export PROJECT_NAME=$1
      export PROJECT_DOCS=$(echo ${PROJECT_NAME} | sed 's/_/-/g')
      export PROJECT_VERSION=$2
      export ${PROJECT_BASEURL}=${ETL_PATH}/docs/${PROJECT_DOCS}/${PROJECT_VERSION}
    fi

    # Run the conversion script
    SET_PROJECT_VERSION=${PROJECT_NAME^^}_VERSION
    export ${SET_PROJECT_VERSION}=$(echo $PROJECT_VERSION | sed 's/\./_/g')

    mkdir -p ${ETL_PATH}/docs
    cd ${ETL}/${PROJECT_NAME} && ./run.sh
}

function load {
    # Run load.sh for that project and pass in the flag

    cd ${ETL}/${PROJECT_NAME} && ./load.sh ${1}
}

function etl {
    # Parameter setup

    export PROJECT_NAME=$1
    export PROJECT_VERSION=$2

    # Clean up build artifacts

    remove_project ${PROJECT_NAME} ${PROJECT_VERSION}

    # Run the extract and transform scripts

    extract_transform ${4} ${PROJECT_NAME} ${PROJECT_VERSION}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated

    load ${3}

    exit
}

#====================
# 2) Install projects
#====================

# A user needs a minimum of 3 flags and shouldn't have more than 4

if [[ "$#" -lt 3 && "$#" -gt 4 ]]; then
    echo_err "Invalid number of flags."
    usage
fi

# Find all project directories under /etl
# If it exists, run the script; if not, run command guide

AllProjects=( $( find etl -maxdepth 1 -type d ! -name 'common' ! -name 'template' ! -name 'etl' | cut -d "/" -f 2 ) )

for project in "${AllProjects[@]}"; do
    if [[ " ${AllProjects[@]} " =~ " ${1} " ]]; then
        etl $1 $2 $3 $4
    else
        usage
    fi
done

#====================
# 3) Closing remarks
#====================

echo_info "Done!"
