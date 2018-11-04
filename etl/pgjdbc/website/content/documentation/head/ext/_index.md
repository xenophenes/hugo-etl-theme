---
layout: default_docs
title: Chapter 9. PostgreSQL™ Extensions to the JDBC API
header: Chapter 9. PostgreSQL™ Extensions to the JDBC API
resource: media
previoustitle: Escaped scalar functions
previous: escaped-functions
nexttitle: Geometric Data Types
next: geometric
weight: 9
---

PostgreSQL™ is an extensible database system. You can add your own functions to
the server, which can then be called from queries, or even add your own data types.
As these are facilities unique to PostgreSQL™, we support them from Java, with a
set of extension APIs. Some features within the core of the standard driver
actually use these extensions to implement Large Objects, etc.

<a name="extensions"></a>
## Accessing the Extensions

To access some of the extensions, you need to use some extra methods in the
`org.postgresql.PGConnection` class. In this case, you would need to case the
return value of `Driver.getConnection()`. For example:

```java
Connection db = Driver.getConnection(url, username, password);
// ...
// later on
Fastpath fp = db.unwrap(org.postgresql.PGConnection.class).getFastpathAPI();
```
