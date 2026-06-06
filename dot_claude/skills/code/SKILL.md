---
name: code
description: General rules to use for code generation
---

## Development environment

The developer is using the IntelliJ IDEA on Windows
and the project are stored on WSL.

## General Coding Guidelines

* Don't use global scoped variables. You should pass the variables in the function argument for instance via a context
  object

## Environment Variables

If you need to create environment variables, don't create a `.env` file.
Create a bash file with the extension `.sh` and store it in the directory `.envrc.d`
