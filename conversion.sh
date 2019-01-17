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
    echo "   pgpool"
    echo "   pgrouting"
    echo "   plr"
    echo "   postgis"
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
    echo "If baseURL is not specified, the default is used."
    echo ""
    exit 1
}

function run_script {
    # Check if baseURL is specified; if so, set it in load.sh for that project
    if [ -n ${1} ]; then
        export PROJECT_BASEURL=$(echo ${PROJECT_NAME}\_BASEURL)
        export ${PROJECT_BASEURL^^}=${1}
    else
        export ${PROJECT_BASEURL^^}='""'
    fi

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

if [ "$#" -lt 3 ]; then
    echo_err "Invalid number of flags."
    usage
fi

if [ "$1" == 'amcheck_next' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export AMCHECK_NEXT_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${AMCHECK_NEXT_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'backrest' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export BACKREST_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${BACKREST_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'check_postgres' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export CHECK_POSTGRES_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${CHECK_POSTGRES_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'patroni' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PATRONI_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PATRONI_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pg_cron' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PG_CRON_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PG_CRON_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgadmin4' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGADMIN4_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGADMIN4_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgaudit' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgaudit_analyze' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_ANALYZE_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_ANALYZE_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgbadger' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGBADGER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGBADGER_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgbouncer' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGBOUNCER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGBOUNCER_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pg_partman' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PG_PARTMAN_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PG_PARTMAN_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgjdbc' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGJDBC_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGJDBC_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgpool' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGPOOL_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGPOOL_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'pgrouting' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGROUTING_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGROUTING_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'plr' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PLR_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PLR_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'postgis' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGIS_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGIS_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'postgresql' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGRESQL_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGRESQL_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'psycopg2' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PSYCOPG2_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PSYCOPG2_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'sec_install_n_config' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export SEC_INSTALL_N_CONFIG_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${SEC_INSTALL_N_CONFIG_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

elif [ "$1" == 'set_user' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export SET_USER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${SET_USER_VERSION}

    # Run the extract and transform scripts
    run_script ${4}

    # Generate the documentation, choosing whether HTML, PDF, EPUB, or all should be generated
    generate_docs ${3}

else
    usage
fi

#====================
# 3) Closing remarks
#====================

echo_info "Done!"
