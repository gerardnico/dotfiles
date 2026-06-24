---
name: MyBatis Migration
description: Toolkit to define SQL objects (table, view, index, ...) and manage database migration
---

Instructions for the database migration tool [MyBatis Migration](https://mybatis.org/migrations/)

## How to create a new SQL file

Example for a new `blog table`

* Create the file with the `migrate` command.

```bash
migrate new "create blog table"
# output example: 20090807221754_create_blog_table.sql
```

* Add the `up` (the change) and `undo` (the undo) statements. Statements must terminate with a colon. Example:

```sql
-- // create blog table
-- Migration SQL that makes the change goes here.
CREATE TABLE BLOG
(
    ID INT
);
-- //@UNDO
-- SQL to undo the change goes here.
DROP TABLE BLOG;
```

* Valide the SQL script with the following commands:

```bash
migrate up
migrate redo
```
