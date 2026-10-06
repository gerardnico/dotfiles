---
name: sql
description: General rules for sql code generation
---

When generating SQL for a language, use a statement with parameters binding for all values.
Do not store the values in the SQL but in the parameters. For example, for Java, use a Prepared statement.
