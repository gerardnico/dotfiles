---
name: code
description: General rules to use for code generation
---

## Development environment

* The developer is using the IntelliJ IDEA editor on Windows
* The projects are stored on Windows WSL.

## General Coding Guidelines

Don't use global scoped variables. You should pass the variables
in the function argument for instance via a context object

## Environment Variables

If you need to create environment variables, don't create a `.env` file.
Create a bash file with the extension `.sh` and store it in the directory `.envrc.d`

## Library Use

Uses an external library instead of writing your own function from scratch

## Null/None

When possible return optional construct instead of Null/None value

## Function Argumentation

Use high level type instead of basic type. Example for an image, don't pass the format, pass the image object
