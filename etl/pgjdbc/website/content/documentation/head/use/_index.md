---
layout: default_docs
title: Chapter 3. Initializing the Driver
header: Chapter 3. Initializing the Driver
resource: media
previoustitle: Creating a Database
previous: your-database
nexttitle: Chapter 3. Loading the Driver
next: load
weight: 3
---

This section describes how to load and initialize the JDBC driver in your programs.

## Importing JDBC

Any source that uses JDBC needs to import the `java.sql` package, using:

```java
import java.sql.*;
```

## Note

You should not import the `org.postgresql` package unless you are not using standard
PostgreSQL™ extensions to the JDBC API.
