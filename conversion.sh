#!/bin/bash

#==============
# 0) Sources
#==============

source etl/common/common.sh

# TODO: set ETL_PATH here

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
    echo "Usage: $ ./conversion.sh <project_name> <project_version>"
    echo ""
    echo "Available project names:"
    echo ""
    echo "- pgaudit"
    echo "- pgaudit_analyze"
    echo "- set_user"
    echo "- backrest"
    echo "- postgis"
    echo "- postgresql"
    echo ""
    echo "Available project versions:"
    echo ""
    echo "- pgaudit: 1.0.6 | 1.1.1 | 1.2.0 | 1.3.0"
    echo "- pgaudit_analyze: 1.0.7"
    echo "- set_user: 1.6.1"
    echo "- backrest: 1.28 | 1.29 | 2.00 | 2.01 | 2.02 | 2.03 | 2.04"
    echo "- postgis: 2.2.7 | 2.3.7 | 2.4.5"
    echo "- postgresql: 9.3.24 | 9.4.19 | 9.5.14 | 9.6.10 | 10.5 | 11.0"
    exit 1
}

#====================
# 2) Install projects
#====================

if [ "$#" -ne 2 ]; then
    usage
fi

if [ "$1" == 'pgaudit' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${PGAUDIT_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${PGAUDIT_VERSION}.pdf

elif [ "$1" == 'pgaudit_analyze' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export PGAUDIT_ANALYZE_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${PGAUDIT_ANALYZE_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${PGAUDIT_ANALYZE_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${PGAUDIT_ANALYZE_VERSION}.pdf

elif [ "$1" == 'set_user' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export SET_USER_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${SET_USER_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${SET_USER_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${SET_USER_VERSION}.pdf

elif [ "$1" == 'backrest' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export BACKREST_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${BACKREST_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${BACKREST_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${BACKREST_VERSION}.pdf

elif [ "$1" == 'postgis' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGIS_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGIS_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${POSTGIS_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${POSTGIS_VERSION}.pdf

elif [ "$1" == 'postgresql' ]; then

    # Parameter setup
    export PROJECT_NAME=$1
    export POSTGRESQL_VERSION=$(echo $2 | sed 's/\./_/g')

    # Clean up build artifacts
    remove_project ${PROJECT_NAME} ${POSTGRESQL_VERSION}

    # Run the conversion script
    cd ${ETL}/${PROJECT_NAME} && ./run.sh

    # Collect generated PDF's
    mkdir -p ${ETL_PATH}/pdf/${PROJECT_NAME}
    cp ${DOCS}/${PROJECT_NAME}_${POSTGRESQL_VERSION}/pdf/${PROJECT_NAME}.pdf ${ETL_PATH}/pdf/${PROJECT_NAME}/${PROJECT_NAME}_${POSTGRESQL_VERSION}.pdf

else
    usage
fi

#====================
# 3) Closing remarks
#====================

echo_info "Done!"
