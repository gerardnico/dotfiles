# Scripts

This directory contains scripts that are not [shims](../shims/README.md).

## Installation

All these files are installed with:

* a symlink created by [run_onchange_install-packages](../run_onchange_install-packages.sh)
* into `.local/bin`

# Why?

* No needs to pollute the PATH
* Files will be found by IDE (no need to set the PATH)
* This is the standard installation location of script such as Claude
