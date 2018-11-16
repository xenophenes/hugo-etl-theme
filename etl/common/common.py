#==============
# 1) Imports
#==============

from bs4 import BeautifulSoup
from bs4 import Doctype
import sys

#==============
# 2) Variables
#==============

filename = sys.argv[1]
cleanup = sys.argv[2]

#==============
# 3) Functions
#==============

def cleanup_backrest(filename):
    fh = open(filename, "r")

    soup = BeautifulSoup(fh, 'html.parser')

    pageTitle = soup.title.get_text()

    soup.body.insert(3, pageTitle)

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

#==============
# 4) Execution
#==============

if cleanup == "backrest":
    cleanup_backrest(filename)
elif cleanup == "postgis":
    cleanup_postgis(filename)
elif cleanup == "postgresql":
    cleanup_postgresql(filename)
else:
    print "There is no cleanup function for that project."
