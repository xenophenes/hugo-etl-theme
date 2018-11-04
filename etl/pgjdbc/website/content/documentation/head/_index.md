---
title: 'The PostgreSQL JDBC Interface'
draft: false
hidden: false
---

## Table of Contents

​1. [Introduction](intro)

​2. [Setting up the JDBC Driver](setup)

- [Getting the Driver](setup#build)

- [Setting up the Class Path](setup/classpath)

- [Preparing the Database Server for JDBC](setup/prepare)

- [Creating a Database](setup/your-database)

​3. [Initializing the Driver](use)

- [Importing JDBC](use#import)

- [Loading the Driver](use/load)

- [Connecting to the Database](use/connect)

- [Connection Parameters](use/connect#connection-parameters)

​4. [Using SSL](ssl)

- [Configuring the Server](ssl#ssl-server)

- [Configuring the Client](ssl/ssl-client)

- [Using SSL without Certificate Validation](ssl/ssl-client#nonvalidating)

- [Custom SSLSocketFactory](ssl/ssl-factory)

​5. [Issuing a Query and Processing the Result](query)

- [Getting results based on a cursor](query#query-with-cursor)

- [Using the Statement or PreparedStatement Interface](query/statement)

- [Using the ResultSet Interface](query/resultset)

- [Performing Updates](query/update)

- [Creating and Modifying Database Objects](query/ddl)

- [Using Java 8 Date and Time classes](query/java8-date-time)

​6. [Calling Stored Functions](callproc)

- [Obtaining a ResultSet from a stored function](callproc#callproc-resultset)

- [From a Function Returning SETOF type](callproc#callproc-resultset-setof)

- [From a Function Returning a refcursor](callproc#callproc-resultset-refcursor)

​7. [Storing Binary Data](binary-data)

​8. [JDBC escapes](escapes)

- [Escape for like escape character](escapes#like-escape)

- [Escape for outer joins](escapes/outer-joins-escape)

- [Date-time escapes](escapes/escapes-datetime)

- [Escaped scalar functions](escapes/escaped-functions)

​9. [PostgreSQL™ Extensions to the JDBC API](ext)

- [Accessing the Extensions](ext#extensions)

- [Geometric Data Types](ext/geometric)

- [Large Objects](ext/largeobjects)

- [Listen / Notify](ext/listennotify)

- [Server Prepared Statements](ext/server-prepare)

- [Physical and Logical replication API](ext/replication)

- [Arrays](ext/arrays)

​10. [Using the Driver in a Multithreaded or a Servlet Environment](thread)

​11. [Connection Pools and Data Sources](datasource)

- [Overview](datasource#ds-intro)

- [Application Servers: ConnectionPoolDataSource](datasource/ds-cpds)

- [Applications: DataSource](datasource/ds-ds)

- [Tomcat setup](datasource/tomcat)

- [Data Sources and JNDI](datasource/jndi)

​12. [Logging with java.util.logging](logging)

​13. [Further Reading](reading)

## List of Tables

8.1. [Supported escaped numeric functions](escapes/escaped-functions#escape-numeric-functions-table)

8.2. [Supported escaped string functions](escapes/escaped-functions#escape-string-functions-table)

8.3. [Supported escaped date/time functions](escapes/escaped-functions#escape-datetime-functions-table)

8.4. [Supported escaped misc functions](escapes/escaped-functions#escape-misc-functions-table)

11.1. [ConnectionPoolDataSource Configuration Properties](datasource/ds-cpds#ds-cpds-props)

11.2. [DataSource Implementations](datasource/ds-ds#ds-ds-imp)

11.3. [DataSource Configuration Properties](datasource/ds-ds#ds-ds-props)

11.4. [Additional Pooling DataSource Configuration Properties](datasource/ds-ds#ds-ds-xprops)

## List of Examples

5.1. [Processing a Simple Query in JDBC](query#query-example)

5.2. [Setting fetch size to turn cursors on and off.](query#fetchsize-example)

5.3. [Deleting Rows in JDBC](query/update#delete-example)

5.4. [Dropping a Table in JDBC](query/ddl#drop-table-example)

6.1. [Calling a built in stored function](callproc#call-function-example)

6.2. [Getting SETOF type values from a function](callproc#setof-resultset)

6.3. [Getting refcursor Value From a Function](callproc#get-refcursor-from-function-call)

6.4. [Treating refcursor as a cursor name](callproc#refcursor-string-example)

7.1. [Processing Binary Data in JDBC](binary-data#binary-data-example)

8.1. [Using jdbc escapes](escapes#escape-use-example)

9.1. [Using the CIRCLE datatype from JDBC](ext/geometric#geometric-circle-example)

9.2. [Receiving Notifications](ext/listennotify#listen-notify-example)

9.3. [Using server side prepared statements](ext/server-prepare#server-prepared-statement-example)

11.1. [DataSource Code Example](datasource/ds-ds#ds-example)

11.2. [DataSource JNDI Code Example](datasource/jndi#ds-jndi)

* * * * *

Copyright © 1996-2018 The PostgreSQL Global Development Group | © Crunchy Data Solutions, Inc.
