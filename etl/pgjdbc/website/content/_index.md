---
title: 'PostgreSQL JDBC Driver'
draft: false
---

# PostgreSQL JDBC Driver

**27 August 2018**

PostgreSQL JDBC Driver 42.2.5 Released
--------------------------------------

**Notable changes**

### Changed

-   `ssl=true` implies `sslmode=verify-full`, that is it requires valid
    server certificate
    [cdeeaca4](https://github.com/pgjdbc/pgjdbc/commit/cdeeaca47dc3bc6f727c79a582c9e4123099526e)

### Added

-   Support for `sslmode=allow/prefer/require`
    [cdeeaca4](https://github.com/pgjdbc/pgjdbc/commit/cdeeaca47dc3bc6f727c79a582c9e4123099526e)

### Fixed

-   Security: added server hostname verification for non-default SSL
    factories in `sslmode=verify-full` (CVE-2018-10936)
    [cdeeaca4](https://github.com/pgjdbc/pgjdbc/commit/cdeeaca47dc3bc6f727c79a582c9e4123099526e)
-   Updated documentation on SSL configuration
    [fa032732](https://github.com/pgjdbc/pgjdbc/commit/fa032732acfe51c6e663ee646dd5c1beaa1af857)
-   Updated Japanese translations [PR
    1275](https://github.com/pgjdbc/pgjdbc/pull/1275)
-   IndexOutOfBounds on prepared multistatement with insert values
    [c2885dd0](https://github.com/pgjdbc/pgjdbc/commit/c2885dd0cfc793f81e5dd3ed2300bb32476eb14a)

See full [changelog for 42.2.5](documentation/changelog#version_42.2.5)

* * * * *

**14 July 2018**

PostgreSQL JDBC Driver 42.2.4 Released
--------------------------------------

**Notable changes**

### Changed

-   PreparedStatement.setNull(int parameterIndex, int t, String
    typeName) no longer ignores the typeName argument if it is not null
    [PR 1160](https://github.com/pgjdbc/pgjdbc/pull/1160)

### Fixed

-   Fix treatment of SQL\_TSI\_YEAR, SQL\_TSI\_WEEK, SQL\_TSI\_MINUTE
    [PR 1250](https://github.com/pgjdbc/pgjdbc/pull/1250)
-   Map integrity constraint violation to XA\_RBINTEGRITY instead of
    XAER\_RMFAIL [PR 1175](https://github.com/pgjdbc/pgjdbc/pull/1175)
    [f2d1352c](https://github.com/pgjdbc/pgjdbc/commit/f2d1352c2b3ea98492beb6127cd6d95039a0b92f)

See full [changelog for 42.2.4](documentation/changelog#version_42.2.4)

* * * * *

**12 July 2018**

PostgreSQL JDBC Driver 42.2.3 Released
--------------------------------------

**Notable changes**

### Known issues

-   SQL\_TSI\_YEAR is treated as hour, SQL\_TSI\_WEEK is treated as
    hour, SQL\_TSI\_MINUTE is treated as second (fixed in 42.2.4)

### Changed

-   Reduce the severity of the error log messages when an exception is
    re-thrown. The error will be thrown to caller to be dealt with so no
    need to log at this verbosity by pgjdbc [PR
    1187](https://github.com/pgjdbc/pgjdbc/pull/1187)
-   Deprecate Fastpath API [PR
    903](https://github.com/pgjdbc/pgjdbc/pull/903)
-   Support parenthesis in  JDBC escape syntax [PR
    1204](https://github.com/pgjdbc/pgjdbc/pull/1204)
-   ubenchmark module moved pgjdbc/benchmarks repository due to
    licensing issues [PR
    1215](https://github.com/pgjdbc/pgjdbc/pull/1215)
-   Include section on how to submit a bug report in CONTRIBUTING.md [PR
    951](https://github.com/pgjdbc/pgjdbc/pull/951)

### Fixed

-   getString for PGObject-based types returned "null" string instead of
    null [PR 1154](https://github.com/pgjdbc/pgjdbc/pull/1154)
-   Field metadata cache can be disabled via
    databaseMetadataCacheFields=0 [PR
    1052](https://github.com/pgjdbc/pgjdbc/pull/1152)
-   Properly encode special symbols in passwords in BaseDataSource [PR
    1201](https://github.com/pgjdbc/pgjdbc/pull/1201)
-   Adjust date, hour, minute, second when rounding nanosecond part of a
    timestamp [PR 1212](https://github.com/pgjdbc/pgjdbc/pull/1212)
-   perf: reduce memory allocations in query cache [PR
    1227](https://github.com/pgjdbc/pgjdbc/pull/1227)
-   perf: reduce memory allocations in SQL parser [PR
    1230](https://github.com/pgjdbc/pgjdbc/pull/1230), [PR
    1233](https://github.com/pgjdbc/pgjdbc/pull/1233)
-   Encode URL parameters in BaseDataSource [PR
    1201](https://github.com/pgjdbc/pgjdbc/pull/1201)
-   Improve JavaDoc formatting [PR
    1236](https://github.com/pgjdbc/pgjdbc/pull/1236)

See full [changelog for 42.2.3](documentation/changelog#version_42.2.3)

* * * * *

The PostgreSQL JDBC group would like to thank YourKit for graciously providing licenses to the project.

<img src="https://www.yourkit.com/images/yklogo.png" alt="" style="
    text-align: left;
    margin: 0;
    width: 10rem;
">

Latest Releases
---------------

**42.2.5** · 27 Aug 2018 ·
[Notes](documentation/changelog#version_42.2.5) \
 **42.2.4** · 14 Jul 2018 ·
[Notes](documentation/changelog#version_42.2.4) \
 **42.2.3** · 12 Jul 2018 ·
[Notes](documentation/changelog#version_42.2.3) \
 **42.2.2** · 15 Mar 2018 ·
[Notes](documentation/changelog#version_42.2.2) \
 **42.2.1** · 25 Jan 2018 ·
[Notes](documentation/changelog#version_42.2.1) \

[Snapshots](https://oss.sonatype.org/content/repositories/snapshots/org/postgresql/postgresql/)

Shortcuts
---------

-   [GitHub project](https://github.com/pgjdbc/pgjdbc)
-   [Documentation](documentation/head/index)
-   [Mailing list](https://www.postgresql.org/list/pgsql-jdbc/)
-   [Report a bug](https://github.com/pgjdbc/pgjdbc/issues/new)
-   [FAQ](documentation/faq)

<img src="./images/img/slonik_duke.png" alt="" style="
    text-align: left !important;
    margin: 0;
    width: 5rem;
    padding-bottom: 2rem;
    padding-top: 1.5rem;
">

* * * * *

Copyright © 1996-2018 The PostgreSQL Global Development Group | © Crunchy Data Solutions, Inc.
