#!/bin/bash
# Shebang is mandatory: https://github.com/twpayne/chezmoi/issues/666#issuecomment-612677019

# Install Package
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#install-packages-with-scripts
# You can do it also declaratively by using a yaml file [Package](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/)
# Run with `chezmoi apply` or `chezmoi update`

# The file run only if it has changed
# You can delete the script cache to run it again without changing the content
# See https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes
#
echo "OnChange Install Packages"

# Example
# A list of command
#sudo apt install git
#
# or a template should ends with `tmpl`
# {{ if eq .chezmoi.os "linux" -}}
# #!/bin/sh
# sudo apt install ripgrep
# {{ else if eq .chezmoi.os "darwin" -}}
# #!/bin/sh
#  brew install ripgrep
# {{ end -}}
