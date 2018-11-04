---
title: 'Translations'
draft: false
---

-   [Development](development)
-   [GIT](git)
-   [Translations](translations)
-   [Website](website)
-   [Todo](todo)
-   [Private API](privateapi/index)

* * * * *

Overview
--------

Translations of driver specific error messages are available in a number
of languages. The following information is about how to update an
existing translation or to provide a translation to a new language.

The translations are done using the [GNU
gettext](http://www.gnu.org/software/gettext/gettext) tools. These
are not required to build or use the driver, only translators and
maintainers need them.

* * * * *

Developers
----------

When writing code for the driver you need to specially mark strings for
translation so they are picked up by the tools. In general any user
visible message should be made available for translation. Strings are
marked using the [GT.tr](privateapi/org/postgresql/util/GT) method.
The name means "gettext translate", but a shorter name was wanted
because this shows up in a lot of places.

To provide context sensitive information the standard Java
[MessageFormat](http://java.sun.com/j2se/1.4.2/docs/api/java/text/MessageFormat)
syntax is used in the error messages. Consider, for example, the error
message for calling ResultSet.getInt() with an invalid column number, we
want to helpfully report the column asked for and the number of columns
in the ResultSet.

```
if (column < 1 || column > fields.length) {
    String err = GT.tr(
        "The column index requested:  is out of range.",
        new Integer(column)
        );
    throw new PSQLException(err, PSQLState.INVALID_PARAMETER_VALID);
}

```

* * * * *

## Translators

Check the current [translation status](status) page to see if an
existing translation exists for your language, so you can update that
instead of starting from scratch. To start a new translation you can
download the template file and work on that instead.

Editing the .po file is a pretty straightforward process and a number of
tools exist to aid you in the process:

-   GNU Emacs and XEmacs have PO editing modes.
-   [KBabel](http://freecode.com/projects/kbabel) is a KDE-based editing
    tool.
-   [poEdit](http://poedit.sourceforge.net/) is another tool which can
    run on Windows.

Once you feel the translation is accurate and complete (or you get
tired), verify that the file by running msgfmt.

```
msgfmt -c -v -o /dev/null pofile

```

If everything checks out send the po file on over to the
[pgsql-jdbc@postgresql.org](mailto:pgsql-jdbc@postgresql.org) mailing
list. This list does have a size limit of 30k, so you will need to
compress the po file before sending it.

* * * * *

## Maintainers

To avoid requiring the gettext tools to compile the driver the decision
has been made to directly check in the compiled message catalogs to the
git repository. When you get a new or updated translation, first ensure
that it is valid by running the msgfmt command mentioned in the
translators section. If this looks correct drop it into the
src/org/postgresql/translation directory and run the
update-translations.sh script in the top level directory. This will
produce the compiled class file that contains the translated messages.
Then simply check in both the .po and .class files. Be sure to only
commit changes to the translations you've modified because the
update-translations.sh script modifies all the translations.

* * * * *

Copyright © 1996-2018 The PostgreSQL Global Development Group | © Crunchy Data Solutions, Inc.
