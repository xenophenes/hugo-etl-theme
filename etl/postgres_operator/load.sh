#!/bin/bash
#=========================================================================
# Copyright 2019 Crunchy Data Solutions, Inc.
#=========================================================================

source ${ETL_PATH}/etl/common/common.sh
source postgres_operator_var.sh

export REPO_DOCS=$(echo ${REPO} | sed 's/_/-/g')
export POSTGRES_OPERATOR_VERSION=$(echo ${POSTGRES_OPERATOR_VERSION} | sed 's/_/./g')
export POSTGRES_OPERATOR_DOCS="${DOCS}/${REPO_DOCS}/${POSTGRES_OPERATOR_VERSION}"

#===============================================
# 1) Functions
#===============================================

function search_for_index() {

    # Print out the index file to the list
    echo "${1}/_index.md" >> tmp_list

    # Print out all the other md files in this directory sorted by weight if they have any
    if [ $(find $1/*/ 2>/dev/null | grep .md | wc -l) != 0 ]  &&  [ $(find $1/*/ 2>/dev/null | grep _index.md | wc -l ) == 0 ]; then
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
    # and we want to make sure these files are organized.

    rm -rf tmp_list
    search_for_index ${CONTENT}

    count=0
    while read md_file; do
        count=$((count+1))
        printf -v padded_count "%02d" $count
        cp $md_file ${DST}/static/pdf/${padded_count}.md
    done < tmp_list

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/pdf/*.md

    (cd ${DST}/static/pdf && \
    pandoc --toc --latex-engine=xelatex \
    --listings -H ${ETL_PATH}/etl/common/common.tex \
    *.md -o ${REPO}.pdf)

    rm ${DST}/static/pdf/*.md

    cp ${DST}/static/pdf/${REPO}.pdf ${ETL_PATH}/pdf/${REPO}/${REPO}.pdf
}

function create_epub {
    mkdir -p ${DST}/static/epub ${ETL_PATH}/epub/${REPO}

    # Pandoc will default to gathering up all Markdown files alphabetically,
    # and we want to make sure these files are organized.

    rm -rf tmp_list
    search_for_index ${CONTENT}

    count=0
    while read md_file; do
        count=$((count+1))
        printf -v padded_count "%02d" $count
        cp $md_file ${DST}/static/epub/${padded_count}.md
    done < tmp_list

    rm -rf tmp_list

    sed -Ei 's/\/(.*?).png/..\/\1.png/g' ${DST}/static/epub/*.md

    (cd ${DST}/static/epub && pandoc *.md -o ${REPO}.epub)

    rm ${DST}/static/epub/*.md

    cp ${DST}/static/epub/${REPO}.epub ${ETL_PATH}/epub/${REPO}/${REPO}.epub
}

function create_html {
    hugo --source=${DST} --destination=${POSTGRES_OPERATOR_DOCS} --baseURL=${POSTGRES_OPERATOR_BASEURL}
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

  if [[ ${POSTGRES_OPERATOR_VERSION} < 3.5.0 ]]; then
    create_html
  else
    create_pdf
    create_epub
    create_html
  fi

fi

rm -rf ${BUILD} ${DST}

echo_end ${REPO}
