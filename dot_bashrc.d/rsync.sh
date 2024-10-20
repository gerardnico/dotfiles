

# Rsync is mandatory for Python with the Intellij Idea
# See https://www.jetbrains.com/help/pycharm/using-wsl-as-a-remote-interpreter.html#prereq
if [ ! -x "$(command -v rsync)" ]; then
  echo "Rsync is not available"
fi
