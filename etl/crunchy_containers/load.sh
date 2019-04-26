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
source crunchy_containers_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export CRUNCHY_CONTAINERS_VERSION=$(echo ${CRUNCHY_CONTAINERS_VERSION} | sed 's/_/./g')
export CRUNCHY_CONTAINERS_DOCS="${DOCS}/${REPO_DOCS}/${CRUNCHY_CONTAINERS_VERSION}"

#===============================================
# 1) Functions
#===============================================

function search_for_index() {

    # Print out the index file to the list
    echo "${1}/_index.md" >> tmp_list

    # Print out all the other md files in this directory sorted by weight if they have any
    if [ $(find $1/*/ 2>/dev/null | grep .md | wc -l) != 0 ]  &&  [$(find $1/*/ 2>/dev/null | grep _index.md | wc -l ) == 0 ]; then
        for md_file in $(find $1/*/ 2>/dev/null | grep .md | egrep -v _index.md | xargs grep -H weight: | sed 's/:weight://' | awk '{print $2, $1}' | sort -n | awk '{print $2}'); do
            echo $md_file >> tmp_list
        done
    elif [ $(find $1 -maxdepth 1 | grep .md | egrep -v _index.md | xargs grep -H weight: | wc -l) == 0 ]; then
        for md_file in $(find $1 -maxdepth 1 | grep .md | egrep -v _index.md); do
            echo $md_file >> tmp_list
        done
    else
        for sorted_md_file in $(find $1 -maxdepth 1 | grep .md | egrep -v _index.md | xargs grep -H weight: | sed 's/:weight://' | awk '{print $2, $1}' | sort -n | awk '{print $2}'); do
            echo $sorted_md_file >> tmp_list
        done
    fi

    for index_file in $(find ${1}/*/ -name _index.md -maxdepth 1 2>/dev/null | xargs grep -H weight: | sed 's/:weight://' | awk '{print $2, $1}' | sort -n | awk '{print $2}'); do
        path=$(echo $index_file | sed 's/_index.md//')
        path_no_slash=$(echo $path | sed 's:/*$::')
        search_for_index $path_no_slash
    done

}

function create_pdf {
    mkdir -p ${DST}/static/pdf ${ETL_PATH}/pdf/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are at the top.

    rm -rf tmp_list
    search_for_index ${CONTENT}

    count=0
    while read md_file; do
        count=$((count+1))
        printf -v padded_count "%04d" $count
        cp $md_file ${DST}/static/pdf/${padded_count}.md
    done < tmp_list

    # Images need to be re-referenced to point to the correct location, so pandoc
    # finds them.

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/pdf/*.md

    # Remove instances of {{% notice X %}}, but not their content.

    sed -i "s/{{%[^%]*%}}//g" ${DST}/static/pdf/*.md

    # Including listings-setup to expand the margins and make sure code blocks are
    # not cut off.

    (cd ${DST}/static/pdf && \
    pandoc -s *.md --listings -H ${ETL_PATH}/etl/common/common.tex --toc --toc-depth=1 \
    --latex-engine=xelatex -o ${REPO}.pdf)

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are at the top.

    rm -rf tmp_list
    search_for_index ${CONTENT}

    count=0
    while read md_file; do
        count=$((count+1))
        printf -v padded_count "%04d" $count
        cp $md_file ${DST}/static/epub/${padded_count}.md
    done < tmp_list

    rm -rf tmp_list

    # Images need to be re-referenced to point to the correct location, so pandoc
    # finds them.

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/epub/*.md

    # Remove instances of {{% notice X %}}, but not their content.

    sed -i "s/{{%[^%]*%}}//g" ${DST}/static/epub/*.md

    (cd ${DST}/static/epub && pandoc -s *.md -o ${REPO}.epub)

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}.epub
}

function create_html {
    hugo --source=${DST} --destination=${CRUNCHY_CONTAINERS_DOCS} --baseURL=${CRUNCHY_CONTAINERS_BASEURL}
}

#===============================================
# 2) Generate the documentation
#===============================================

if [ "$1" == '--pdf' ]; then

    create_pdf

elif [ "$1" == '--epub' ]; then

    create_epub

elif [ "$1" == '--html' ]; then

    create_html

elif [ "$1" == '--all' ]; then

    if [[ ${CRUNCHY_CONTAINERS_VERSION} < 2.3.0 ]]; then
      create_html
    else
      create_pdf
      create_epub
      create_html
    fi

fi

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
