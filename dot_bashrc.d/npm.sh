

# Adding global bin to the PATH
#
# Why? See  https://nixos.wiki/wiki/Node.js#Using_npm_install_-g_fails
# TLDR: With install prefix, the cli would be available at prefix/bin
#
#   npm install --prefix ~/.npm-global -g @yao-pkg/pkg
#
if [ -d "$HOME"/.npm-global/bin ]; then
  export PATH=$PATH:$HOME/.npm-global/bin
fi