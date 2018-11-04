---
layout: default_docs
title: Chapter 4. Using SSL
header: Chapter 4. Using SSL
resource: media
previoustitle: Connecting to the Database
previous: connect
nexttitle: Configuring the Client
next: ssl-client
weight: 4
---

<a name="ssl-server"></a>
## Configuring the Server

Configuring the PostgreSQL™ server for SSL is covered in the [main
documentation](http://www.postgresql.org/docs/current/static/ssl-tcp),
so it will not be repeated here. Before trying to access your SSL enabled
server from Java, make sure you can get to it via **psql**. You should
see output like the following if you have established a SSL  connnection.

```
$ ./bin/psql -h localhost -U postgres
psql (9.6.2)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=#
```
