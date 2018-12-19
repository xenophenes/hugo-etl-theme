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

import bs4
import sys
from bs4 import BeautifulSoup
from bs4 import Doctype

try:
    # Python 2.6-2.7
    from HTMLParser import HTMLParser
except ImportError:
    # Python 3
    from html.parser import HTMLParser

#===============================================
# 2) Variables
#===============================================

filename = sys.argv[1]
cleanup = sys.argv[2]

#===============================================
# 3) Functions
#===============================================

#==================
# 3.1 pgBackRest
#==================

def cleanup_backrest(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()
    pageTitle = pageTitle.replace("pgBackRest", "")

    soup.body.insert(0,
"""
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

    for tag in soup.findAll(attrs={'class':'section2-subtitle'}):
        tag['style'] = "color: #0167B3;font-weight: 600;padding-bottom: 1rem;"

    for tag in soup.findAll(attrs={'class':'section2-subsubtitle'}):
        tag['style'] = "padding-bottom: 1rem;"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
      filedata = file.read()

    filedata = filedata.replace("&amp;", "&")

    with open("/tmp/document.modified", "w") as file:
      file.write(filedata)


#==================
# 3.2 Patroni
#==================

def cleanup_patroni(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()

    soup.body.insert(0,
"""
---
title: "%s"
draft: false
---


""" % pageTitle)

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()
    soup.footer.decompose()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll("script"):
        tag.decompose()

    for tag in soup.findAll(attrs={'role':'search'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'role':'navigation'}):
        tag.decompose()

    for tag in soup.findAll('nav', {'class': 'wy-nav-side'}):
        tag.decompose()

    for tag in soup.findAll('nav', {'class': 'wy-nav-top'}):
        tag.decompose()

    for tag in soup.findAll('a', {'class': 'headerlink'}):
        tag.decompose()

    for tag in soup.findAll("cite"):
        tag.name = "code"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
        filedata = file.read()

    filedata = filedata.replace("&nbsp;", " ")
    filedata = filedata.replace("&ldquo;", '"')
    filedata = filedata.replace("&rdquo;", '"')
    filedata = filedata.replace("&amp;", "&")
    filedata = filedata.replace("&mdash;", "-")
    filedata = filedata.replace("&lt;", "<")
    filedata = filedata.replace("&gt;", ">")

    with open("/tmp/document.modified", "w") as file:
        file.write(filedata)

    with open("/tmp/document.modified", "a") as file:
        file.write("<p>&copy; Copyright 2015 Compose, Zalando SE</p>")

#==================
# 3.3 pgBadger
#==================

def cleanup_pgbadger(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    soup.body.insert(0,
"""
---
title: "pgBadger - A fast PostgreSQL Log Analyzer"
draft: false
---


<h1>pgBadger - A fast PostgreSQL Log Analyzer</h1>

""")

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup:
        if isinstance(tag, bs4.element.ProcessingInstruction):
            tag.extract()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll('ul', {'id': 'index'}):
        tag.decompose()

    for tag in soup.findAll('h1'):
        tag.name = "h2"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
        filedata = file.read()

    filedata = filedata.replace("&lt;", "<")
    filedata = filedata.replace("&gt;", ">")

    with open("/tmp/document.modified", "w") as file:
        file.write(filedata)

#==================
# 3.4 pgBouncer
#==================

def cleanup_pgbouncer(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()

    if "_index.html" in filename:
        soup.body.insert(0,
"""
---
title: "%s"
draft: false
---

<h1>pgBouncer - A Lightweight Connection Pooler for PostgreSQL</h1>

""" % pageTitle)
    elif "usage" in filename:
        soup.h1.decompose()

        soup.body.insert(0,
"""
---
title: "Usage"
draft: false
---

""")
    elif "config" in filename:
        soup.h1.decompose()

        soup.body.insert(0,
"""
---
title: "Configuration"
draft: false
---

""")
    else:
        soup.h1.decompose()

        soup.body.insert(0,
"""
---
title: "%s"
draft: false
---


""" % pageTitle)

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup:
        if isinstance(tag, bs4.element.ProcessingInstruction):
            tag.extract()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll("script"):
        tag.decompose()

    for tag in soup.findAll('h2'):
        tag.name = "h3"

    for tag in soup.findAll('h1'):
        tag.name = "h2"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
        filedata = file.read()

    filedata = filedata.replace("&lt;", "<")
    filedata = filedata.replace("&gt;", ">")

    with open("/tmp/document.modified", "w") as file:
        file.write(filedata)


#==================
# 3.5 pgJDBC
#==================

def cleanup_pgjdbc(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.h1.get_text()

    if "The PostgreSQL JDBC Interface" in pageTitle:
        soup.body.insert(0,
"""
---
title: "%s"
draft: false
---
""" % pageTitle)
    else:
        soup.body.insert(0,
"""
---
title: "%s"
draft: false
hidden: true
---
""" % pageTitle)

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll('span', {'class': 'txtOffScreen'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'pgSearch'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'pgHeader'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'docHeader'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'pgTopNav'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'pgSideWrap'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'pgFooter'}):
        tag.decompose()

    for tag in soup.findAll('div', {'id': 'docFooter'}):
        tag.decompose()

    for tag in soup.findAll('div', {'class': 'NAVHEADER'}):
        tag.decompose()

    for tag in soup.findAll('div', {'class': 'NAVFOOTER'}):
        tag.decompose()

    if "index" not in filename:
        soup.h1.decompose()

    for tag in soup.findAll('h2'):
        tag.name = "h3"

    for tag in soup.findAll('h1'):
        tag.name = "h2"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
        filedata = file.read()

    filedata = filedata.replace("&nbsp;", " ")
    filedata = filedata.replace("&ldquo;", '"')
    filedata = filedata.replace("&rdquo;", '"')
    filedata = filedata.replace("&amp;", "&")
    filedata = filedata.replace("&mdash;", "-")
    filedata = filedata.replace("&lt;", "<")
    filedata = filedata.replace("&gt;", ">")
    filedata = filedata.replace("&trade;", " ")

    with open("/tmp/document.modified", "w") as file:
        file.write(filedata)

#==================
# 3.6 pgPool
#==================

def cleanup_pgpool(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    try:
        pageTitle = soup.title.get_text()

        soup.body.insert(0,
"""
---
title: "%s"
draft: false
---


""" % pageTitle)
    except AttributeError:
        pass

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll(attrs={'class':'NAVFOOTER'}):
        tag.decompose()

    try:
        soup.h1.decompose()
    except AttributeError:
        pass

    for tag in soup.findAll('h2'):
        tag.name = "h3"

    for tag in soup.findAll('h1'):
        tag.name = "h2"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

#==================
# 3.7 PostGIS
#==================

def cleanup_postgis(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()

    if "_index.html" in filename:
        soup.body.insert(0,
"""
---
title: "%s"
draft: false
---


""" % pageTitle)
    else:
        soup.body.insert(0,
"""
---
title: "%s"
draft: false
hidden: true
---


""" % pageTitle)

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup.findAll(attrs={'class':'navheader'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'navfooter'}):
        tag.decompose()

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

#==================
# 3.8 PostgreSQL
#==================

def cleanup_postgresql(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    try:
        pageTitle = soup.title.get_text()

        if "_index.html" in filename:
            soup.body.insert(0,
"""
---
title: "%s"
draft: false
---


""" % pageTitle)
        else:
            soup.body.insert(0,
"""
---
title: "%s"
draft: false
hidden: true
---


""" % pageTitle)
    except AttributeError:
        pass

    soup.html.unwrap()
    soup.body.unwrap()
    soup.head.decompose()

    for tag in soup:
        if isinstance(tag, bs4.element.ProcessingInstruction):
            tag.extract()

    for tag in soup.contents:
        if isinstance(tag, Doctype):
            tag.extract()

    for tag in soup.findAll(attrs={'class':'navheader'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'navfooter'}):
        tag.decompose()

    for tag in soup.findAll(attrs={'class':'navfooter'}):
        tag.decompose()

    for tag in soup.findAll('h1'):
        tag.decompose()

    for tag in soup.findAll('h2', {'class': 'title'}):
        tag.decompose()

    for tag in soup.findAll('h3', {'class': 'title'}):
        if tag.contents[0] != "Tip" and tag.contents[0] != "Caution" and tag.contents[0] != "Note":
            tag.name = "h2"

    f = open("/tmp/document.modified", "w")
    f.write(soup.prettify(formatter="html5"))
    f.close()

    with open("/tmp/document.modified", "r") as file:
      filedata = file.read()

    filedata = filedata.replace("&nbsp;", " ")
    filedata = filedata.replace("&ldquo;", '"')
    filedata = filedata.replace("&rdquo;", '"')
    filedata = filedata.replace("&amp;", "&")
    filedata = filedata.replace("&mdash;", "-")
    filedata = filedata.replace("&lt;", "<")
    filedata = filedata.replace("&gt;", ">")

    with open("/tmp/document.modified", "w") as file:
      file.write(filedata)

#===============================================
# 4) Parsing
#===============================================

if cleanup == "backrest":
    cleanup_backrest(filename)
elif cleanup == "patroni":
    cleanup_patroni(filename)
elif cleanup == "pgbadger":
    cleanup_pgbadger(filename)
elif cleanup == "pgbouncer":
    cleanup_pgbouncer(filename)
elif cleanup == "pgjdbc":
    cleanup_pgjdbc(filename)
elif cleanup == "pgpool":
    cleanup_pgpool(filename)
elif cleanup == "postgis":
    cleanup_postgis(filename)
elif cleanup == "postgresql":
    cleanup_postgresql(filename)
else:
    print ("There is no cleanup function for that project.")
