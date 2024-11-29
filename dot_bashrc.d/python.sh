

if [ -x "$(command -v python3)" ]; then
  alias python=python3
fi

# Activate a venv
# so that we don't get any
# python externally managed
# when executing a `pip3 install`
# https://peps.python.org/pep-0668/
PYTHON_VENV="$HOME/.venv"
if [ ! -d "$PYTHON_VENV" ]; then
  python3 -m venv "$PYTHON_VENV"
fi
source "$PYTHON_VENV/bin/activate"
