-   [Development](development.html)
-   [GIT](git.html)
-   [Translations](translations.html)
-   [Website](website.html)
-   [Todo](todo.html)
-   [Private API](privateapi/index.html)

Todo List
=========

* * * * *

-   [Known Bugs](#Known_Bugs)
-   [Compliance](#Compliance)
-   [Performance](#Performance)
-   [PG Extensions](#PG_Extensions)
-   [Other](#Other)
-   [Ideas](#Ideas)
-   [Documentation](#Documentation)
-   [Website](#Website)

* * * * *

Known Bugs
----------

-   **[bugs]** Deallocating large numbers of server side statements can
    break the connection by filling network buffers. This is a very,
    very low probability bug, but it is still possible.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2004-12/msg00115.php)
    →

* * * * *

Compliance
----------

-   **[JDBC1]** Implement Statement.setQueryTimeout. →
-   **[JDBC2]** Sort DatabaseMetaData.getTypeInfo properly (by closest
    match). →
-   **[JDBC2]** Implement SQLInput and SQLOutput to allow composite
    types to be used. →
-   **[JDBC3]** Implement Statement.getGeneratedKeys.
    [ref2](http://archives.postgresql.org/pgsql-jdbc/2004-09/msg00190.php)
    →
-   **[JDBC3]** The JDBC 3 DatabaseMetaData methods sometimes return
    additional information. Currently we only return JDBC 2 data for
    these methods.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2004-12/msg00038.php)
    →
-   **[JDBC3]** Implement Clob write/position methods. →

* * * * *

Performance
-----------

-   **[]** Add statement pooling to take advantage of server prepared
    statements. →
-   **[]** Allow scrollable ResultSets to not fetch all results in one
    batch. →
-   **[]** Allow refcursor ResultSets to not fetch all results in one
    batch. →
-   **[]** Allow binary data transfers for all datatypes not just bytea.
    →

* * * * *

PG Extensions
-------------

-   **[]** Allow configuration of GUC parameters via the Connection URL
    or Datasource. The most obvious example of usefulness is
    search\_path.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2004-02/msg00022.php)
    →

* * * * *

Other
-----

-   **[test]** Pass the JDBC CTS (Sun's test suite). →
-   **[code]** Allow SSL to use client certificates. This can probably
    be done with our existing SSLSocketFactory customization code, but
    it would be good to provide an example or other wrapper so a
    non-expert can set it up.
    [ref1](http://archives.postgresql.org/pgsql-jdbc/2004-12/msg00077.php),
    [ref2](http://archives.postgresql.org/pgsql-jdbc/2004-12/msg00083.php)
    →
-   **[code]** Currently the internal type cache is not schema aware. →
-   **[code]** Need a much better lexer/parser than the ad hoc stuff in
    the driver.
    [ref2](http://archives.postgresql.org/pgsql-jdbc/2004-09/msg00062.php)
    →

* * * * *

Ideas
-----

-   **[]** Allow Blob/Clob to operate on bytea/text data.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-01/msg00058.php)
    →
-   **[]** Allow getByte/getInt/... to work on boolean values
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-01/msg00254.php)
    →
-   **[]** Add a URL parameter to make the driver not force a rollback
    on error for compatibility with other dbs. The driver can wrap each
    statement in a Savepoint.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-01/msg00131.php)
    →
-   **[]** Combine DatabaseMetaData efforts with pl/java.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-02/msg00063.php)
    →
-   **[]** ResultSetMetaData calls that run queries are cached on a per
    column basis, but it seems likely that they're going to be called
    for all columns, so try to issue one query per ResultSet, not per
    column. →
-   **[]** Make PGConnection, PGStatement, ... extend java.sql.XXX
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-01/msg00223.php)
    →

* * * * *

Documentation
-------------

-   **[]** The PGResultSetMetaData interface is not mentioned. →
-   **[]** Timestamp +/- Infinity values are not mentioned. →
-   **[]** Async notifies are more async now.
    [ref](http://archives.postgresql.org/pgsql-jdbc/2005-04/msg00056.php)
    →

* * * * *

Website
-------

-   **[]** Setup a cron job somewhere to build and deploy the sight on a
    daily basis to keep API changes and translations up to date. →\
-   **[]** Add a daily git snapshot build to make the latest updates
    available. →

\

* * * * *

[Privacy Policy](https://www.postgresql.org/about/privacypolicy) |
[About PostgreSQL](https://www.postgresql.org/about/)\
 Copyright © 1996-2018 The PostgreSQL Global Development Group
