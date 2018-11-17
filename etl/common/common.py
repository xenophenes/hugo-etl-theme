#=========================================================================
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
#=========================================================================

#===============================================
# 1) Imports
#===============================================

from bs4 import BeautifulSoup
from bs4 import Doctype
import sys

#===============================================
# 2) Variables
#===============================================

filename = sys.argv[1]
cleanup = sys.argv[2]

#===============================================
# 3) Functions
#===============================================

def cleanup_backrest(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()
    pageTitle = pageTitle.replace("pgBackRest", "")
    pageTitle = pageTitle.replace("&", "+")

    soup.body.insert(0, """
---
title: %s
draft: false
---
    """ % pageTitle)

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for item in soup.contents:
        if isinstance(item, Doctype):
            item.extract()

    for tag in soup.findAll(attrs={'class':'section1-title'}):
        tag.name = "h2"
        del tag['class']

    for tag in soup.findAll(attrs={'class':'section2-title'}):
        tag.name = "h3"
        del tag['class']

    for tag in soup.findAll(attrs={'class':'section3-title'}):
        tag.name = "h4"
        del tag['class']

    for tag in soup.findAll(attrs={'class':'section1-number'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'section2-number'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'section3-number'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'page-header'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'page-menu'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'page-toc'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'page-footer'}):
        tag.decompose()

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

#===============================================
# 4) Parsing
#===============================================

if cleanup == "backrest":
    cleanup_backrest(filename)
elif cleanup == "postgis":
    cleanup_postgis(filename)
elif cleanup == "postgresql":
    cleanup_postgresql(filename)
else:
    print ("There is no cleanup function for that project.")
