
# * https://github.com/ajeetdsouza/zoxide
# `brew install zoxide`
# It has fzf integration
if [ ! -x "$(command -v zoxide)" ]; then
  echo "Zoxide is not installed"
  brew install zoxide
fi

eval "$(zoxide init bash)"


# * Fuzzy cd at https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
# `cd yolo**` or `ALT-C`

# Concurrent, Others
# * https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/scd - smart change of directory

