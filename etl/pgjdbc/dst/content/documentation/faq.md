---
title: 'FAQ'
draft: false
---

-   [Documentation](documentation)
-   [Changelog](changelog)
-   [FAQ](faq)

* * * * *

## Frequently Asked Questions

* * * * *

-   [1. New versioning scheme](#versioning)
    -   [1.1. Why the versioning change from 9.4.xxxx to
        42.x.x?](#version-change)
    -   [1.2. Why the number 42?](#why-42)
    -   [1.3. What is not the 42.0.0 release?](#42-is-not)
-   [2. XA](#xa)
    -   [2.1. Does the driver have XA support?](#xa-support)
    -   [2.2. What is "transaction
        interleaving"?](#transaction-interleaving)
-   [3. Problems](#problems)
    -   [3.1. executeBatch hangs without error Possible
        solutions](#executeBatch-hangs-without-error)
    -   [3.2. I upgraded from 7.x to 8.x. Why did my application
        break?](#upgradeTo80)

* * * * *

## 1. New versioning policy

### 1.1. Why the versioning change from 9.4.xxxx to 42.x.x?

We have three issues we are trying to address here.

​a) We do not want to be tied to the server release schedule.

Previously the version was based on the server release to declare some
kind of compatibility, from 9.4.xxxx this was no longer the case and the
increments was just in the last 4 digits, this leads us to the second
issue.

​b) Avoid confusion as to which version to use with which server
version.

The naming scheme previously has 9.4 in it which leads people to believe
it is for server version 9.4 only, when in fact it support PostgreSQL
8.2 and higher. That means that some users looking for PostgreSQL 9.5
were asking what is the version to use, and some users that still use
PostgreSQL 8.4 were using the JDBC driver 8.4 Build 703.

The driver is version agnostic for the most point so there is no reason
to tie it to a specific server version. Unless you have unusual
requirements (running old applications or JVMs), this is the driver you
should be using.

​c) The previous version policy don't leave room for differentiate from
bug fixes releases and feature releases.

The new version policy will allow us to use more or less [Semantic
Versioning](http://semver.org/), and have a more clear understanding of
the versions.

### 1.2. Why the number 42?

42 was more or less chosen at random. But it is large enough to avoid
any future conflicts with the server. Given current server project
policies, server version 42 should come out in 2049, plus or minus a
bit.

Some say that "The answer to the ultimate question of life, the universe
and everything is 42."

### 1.3. What is not the 42.0.0 release?

This release is not a rewrite of the driver, is not using a new
architecture, nor is using something special, it's the continuation of
the same driver following a better versioning policy.

## 2. XA

### 2.1. Does the driver have XA support?

Yes, starting with the 8.1dev-403 driver. However, transaction
interleaving is not supported.

### 2.2. What is "transaction interleaving"?

Transaction interleaving means that one database connection can be used
for multiple transactions at the same time, switching between the
transactions.

Transaction interleaving is mostly useless, but it's a required part of
the JTA specification. Some application servers use it to allow a bit
more concurrency without allocating a bigger jdbc connection pool.

Few JDBC drivers support transaction interleaving properly. Some fake it
by issuing early prepare commands, risking transaction integrity, some
give strange error messages, some fail in other, subtle ways. The
PostgreSQL JDBC driver does it's best to detect interleaving and throws
a proper error message when it can't do what's requested.

Because of the lack of driver support, all of the popular application
servers provide options to work around it, or don't use it at all.
Therefore, lack of transaction interleaving shouldn't affect your
application or data integrity.

See the JTA specification, section 3.4.4, or search the pgsql-jdbc
mailing list archives for more information.

* * * * *

## 3. Problems

### 3.1. executeBatch hangs without error Possible solutions

This is related to batched queries and synchronous TCP.

The thing to look at is setting the network buffer sizes to use to large
values to avoid the deadlock. The default values are machine dependent
which also explains it working or not on different machines (credit to
Kris Jurka)

### 3.2. I upgraded from 7.x to 8.x. Why did my application break?

By default, 8.x versions of the driver use protocol version 3 when
communicating with servers 7.4 or higher. This protocol allows for more
efficient query execution and enables true server-side prepared
statements, but also places some additional restrictions on queries.
Problems with upgrading the driver generally fall into one of two
categories:

**Parameter Typing.** Previous versions of the driver sent all
PreparedStatement parameters to the server as untyped strings, and
allowed the server to infer their types as appropriate. When running
protocol version 3 however, the driver specifies the type of each
parameter as it is being sent. The upshot of this is that code which was
previously able to call (for example): PreparedStatement.setObject(1,
"5") to set an integer parameter now breaks, because setting a String
value for an integer parameter is not allowed.

**Parameter Position.** Previous versions of the driver emulated
PreparedStatements by performing string replacements each time the query
was executed. Newer drivers using protocol 3 however actually use
server-side prepared statements with placeholders for the positional
parameters. The upshot of this is that '?' positional parameters are now
only allowed where the PostgreSQL back-end allows parameters.

In situations where it is difficult to modify the Java code and/or
queries to work with the newer protocol version, it is possible to force
the driver to use an older protocol version to restore the old behavior.
Look in the documentation for the protocolVersion connection parameter.

* * * * *

Copyright © 1996-2018 The PostgreSQL Global Development Group | © Crunchy Data Solutions, Inc.
