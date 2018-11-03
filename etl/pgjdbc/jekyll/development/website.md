-   [Development](development.html)
-   [GIT](git.html)
-   [Translations](translations.html)
-   [Website](website.html)
-   [Todo](todo.html)
-   [Private API](privateapi/index.html)

Website
=======

* * * * *

-   [Building the Website](#website)
-   [Adding a Page](#addingpages)

* * * * *

Building the Website {.underlined_10}
--------------------

The website is produced with [Jekyll](http://jekyllrb.com). It allows
you to build a reasonably good looking website that is easy to maintain
and modular in nature. Templates are used from the \_layout and
\_includes directories which are then used in conjunction with content
that is created with
[Markdown](http://daringfireball.net/projects/markdown/),
[Textile](http://textile.sitemonks.com/), or just standard HTML for
input. Using Markdown or Textile allows the content to be generated with
simple rules that allow a more free flowing process of writing without
worrying about coding for the HTML.

To get started please read the [Jekyll website](http://jekyllrb.com) for
installation instructions for that tool. After installing Jekyll you
need to get the website project. This is available from the same [git
repository](../development/git.html) that the main source code is, it's
just a different module, www. Checkout this module and then within the
top level directory of the module simply run jekyll build. This should
produce the website in the \_site subdirectory.

* * * * *

Adding a Page {.underlined_10}
-------------

To add a page the easiest thing to do is copy an existing one from the
site like about/about.html and then rip out its contents. Once new
content is created and you have saved the new page you will need to add
the new file to the menu system of the appropriate \_includes
subdirectory submenu.\
\
 A good place to look for example content is [Jekyll's
wiki](https://github.com/mojombo/jekyll/wiki/sites) site where there is
a listing of real sites that use Jekyll. Many of these sites will have
their repositories available for review.

\

* * * * *

[Privacy Policy](https://www.postgresql.org/about/privacypolicy) |
[About PostgreSQL](https://www.postgresql.org/about/)\
 Copyright © 1996-2018 The PostgreSQL Global Development Group
