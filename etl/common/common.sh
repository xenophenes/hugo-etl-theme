#!/bin/bash
# Copyright 2018 Crunchy Data Solutions, Inc.
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

#====================================================
# Define project versions.
#====================================================

POSTGRES_VERSION="11_0"
POSTGIS_VERSION="2_3_7"
BACKREST_VERSION="2_06"
PGJDBC_VERSION="42_2_5"
PGAUDIT_VERSION="1_3_0"
PGAUDIT_ANALYZE_VERSION="1_0_7"
SET_USER_VERSION="1_6_1"

#====================================================
# Define folder locations referenced in scripts.
#====================================================

THEME="${ETL_PATH}/etl/template/themes/crunchy"
TEMPLATE="${ETL_PATH}/etl/template"
DOCS="${ETL_PATH}/docs"
SRC="${ETL_PATH}/src"
ETL="${ETL_PATH}/etl"

#====================================================
# General purpose / informational functions
#====================================================

function echo_info() {
    # Defining the terminal color Green.
    GREEN="\033[0;32m"
    # Defining the terminal color White.
    RESET="\033[0m"
    # Echo a green-colored terminal string selected by the user with the date/time.
    echo -e "${GREEN}$(date) INFO: ${1}${RESET}"
}

function echo_begin {
    echo_info "Initiating the ETL process for ${1}."
}

function echo_end {
    echo_info "ETL process for ${1} complete."
}

#====================================================
# Cleanup functions
#====================================================

function cleanup_postgres {
    # This is used for the PostgreSQL and PostGIS documentation.
    # Remove all instances of text within brackets starting with a ., indicating a HTML class
    sed -i "s/{\.[^)]*}//g" ${1}
    # All links need to be relative, not absolute
    sed -i "s/.html//g" ${1}
    # Remove footer content
    sed -zi 's/\* \* \* \* \*\n\n  ---.*\n[^\n]\+\n[^\n]\+\n  ---.*\n\n//g' ${1}
    # Remove header content by removing everything including / before the first occurrence
    # of * * * * *
    sed -i '0,/^\* \* \* \* \*$/d' ${1}
    # All images need to default to the root directory
    sed -i 's/]](images/]](\/images/g' ${1}
}

function cleanup_pgjdbc {
    # This is specific to the pgJDBC documentation.
    # Remove all instances of text within brackets starting with a ., indicating a HTML class
    sed -i "s/[{.][^)]*[}]//g" ${1}
    # All links need to be relative, not absolute
    sed -i "s/.html//g" ${1}
}

function cleanup_backrest {
    # This is specific to the pgBackRest documentation.
    # Removes everything between the tags <div class="page-menu">ARBITRARY CONTENT HERE</div>
    sed -Ei 's/<div class="page-menu">.*?<\/div><\/div><\/div>//g' ${1}
    # Removes everything between <span> tags to make it easier for subsequent sed matching.
    sed -Ei 's/<span class="[^"]*">([^>]*)<\/span>/\1/g' ${1}
    # Replaces section[1-3]-header with h[2-4] tags, and puts in-line with section[1-3]-number
    sed -Ei 's/<div class="section1-number">([^>]*)<\/div><div class="section1-title">([^>]*)<\/div>/<h2>\1 - \2<\/h2>/g' ${1}
    sed -Ei 's/<div class="section2-number">([^>]*)<\/div><div class="section2-title">([^>]*)<\/div>/<h3>\1 - \2<\/h3>/g' ${1}
    sed -Ei 's/<div class="section3-number">([^>]*)<\/div><div class="section3-title">([^>]*)<\/div>/<h4>\1 - \2<\/h4>/g' ${1}
    # The release page needs separate header substitutions, due to the lack of section[1-3]-number
    if [[ ${1} == *"release.html"* ]]
    then
      # Replaces section[1-3]-header with h[2-4] tags
      sed -Ei 's/<div class="section1-title">([^>]*)<\/div>/<h2>\1<\/h2>/g' ${1}
      sed -Ei 's/<div class="section2-title">([^>]*)<\/div>/<h3>\1<\/h3>/g' ${1}
      sed -Ei 's/<div class="section3-title">([^>]*)<\/div>/<h4>\1<\/h4>/g' ${1}
    fi
}
