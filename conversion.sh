#!/bin/bash

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

function remove_project {
    if [[ -d ${ETL}/${1}/build ]] || [[ -d ${ETL}/${1}/dst ]]
    then
        rm -rf ${ETL}/${1}/build ${ETL}/${1}/dst && echo_info "Deleted the build artifacts from the data directory." || echo_err "The build artifacts were not successfully deleted from the data directory."
    fi
}

function usage {
    echo ""
    echo "Usage: $ ./conversion.sh [project_name] [project_version] [flags]"
    echo ""
    echo "Available project names:"
    echo ""
    echo "   pgaudit"
    echo "   pgaudit_analyze"
    echo "   set_user"
    echo "   backrest"
    echo "   postgis"
    echo "   postgresql"
    echo "   patroni"
    echo "   pgbadger"
    echo "   pgbouncer"
    echo "   pgjdbc"
    echo "   pg_partman"
    echo "   plr"
    echo "   pgpool"
    echo "   sec_install_n_config"
    echo ""
    echo "Available project versions:"
    echo ""
    echo "   All project versions available to be converted."
    echo "   Ensure the version number takes the format X.X.X, using periods as separators."
    echo ""
    echo "Available flags: "
    echo ""
    echo "   --no-html"
    echo "   --no-pdf"
    echo "   --all"
    echo ""
    exit 1
}

function run_script {
    # Run the conversion script
    mkdir -p ${ETL_PATH}/docs
    cd ${ETL}/${PROJECT_NAME} && ./run.sh
}

function generate_docs {
    # Run load.sh for that project and pass in the flag
    cd ${ETL}/${PROJECT_NAME} && ./load.sh ${1}
}

#====================
# 2) Install projects
#====================

if [ "$#" -ne 3 ]; then
    echo_err "Invalid number of flags."
    usage
fi

if [ "$1" == 'pgaudit' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'pgaudit_analyze' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_ANALYZE_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_ANALYZE_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'set_user' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export SET_USER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${SET_USER_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'backrest' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export BACKREST_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${BACKREST_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'postgis' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGIS_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGIS_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'postgresql' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGRESQL_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGRESQL_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'patroni' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PATRONI_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PATRONI_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'pgbadger' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGBADGER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGBADGER_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'pgbouncer' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGBOUNCER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGBOUNCER_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

  elif [ "$1" == 'pgjdbc' ]; then

      # Parameter setup
      export PROJECT_NAME=$1
      export PGJDBC_VERSION=$(echo $2 | sed 's/\./_/g')

      # Clean up build artifacts
      remove_project ${PROJECT_NAME} ${PGJDBC_VERSION}

      # Run the extract and transform scripts
      run_script

      # Generate the documentation, choosing whether HTML, PDF, or both should be generated
      generate_docs ${3}

elif [ "$1" == 'pg_partman' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PG_PARTMAN_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PG_PARTMAN_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'sec_install_n_config' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export SEC_INSTALL_N_CONFIG_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${SEC_INSTALL_N_CONFIG_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'plr' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PLR_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PLR_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

elif [ "$1" == 'pgpool' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGPOOL_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGPOOL_VERSION}

    # Run the extract and transform scripts
    run_script

    # Generate the documentation, choosing whether HTML, PDF, or both should be generated
    generate_docs ${3}

else
    usage
fi

#====================
# 3) Closing remarks
#====================

echo_info "Done!"
