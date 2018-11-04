---
layout: default_docs
title: Arrays
header: Chapter 9. PostgreSQL™ Extensions to the JDBC API
resource: media
previoustitle: Physical and Logical replication API
previous: replication
nexttitle: Chapter 10. Using the Driver in a Multithreaded or a Servlet Environment
next: thread
---

PostgreSQL™ provides robust support for array data types as column types, function arguments
and criteria in where clauses. There are several ways to create arrays with pgjdbc.

The [java.sql.Connection.createArrayOf(String, Object\[\])](https://docs.oracle.com/javase/8/docs/api/java/sql/Connection#createArrayOf-java.lang.String-java.lang.Object:A-) can be used to create an [java.sql.Array](https://docs.oracle.com/javase/8/docs/api/java/sql/Array) from `Object[]` instances (Note: this includes both primitive and object multi-dimensional arrays).
A similar method `org.postgresql.PGConnection.createArrayOf(String, Object)` provides support for primitive array types.
The `java.sql.Array` object returned from these methods can be used in other methods, such as [PreparedStatement.setArray(int, Array)](https://docs.oracle.com/javase/8/docs/api/java/sql/PreparedStatement#setArray-int-java.sql.Array-).

Additionally, the following types of arrays can be used in `PreparedStatement.setObject` methods and will use the defined type mapping:

Java Type | Default PostgreSQL™  Type
--- | ---
`short[]` | `int2[]`
`int[]` | `int4[]`
`long[]` | `int8[]`
`float[]` | `float4[]`
`double[]` | `float8[]`
`boolean[]` | `bool[]`
`String[]` | `varchar[]`
