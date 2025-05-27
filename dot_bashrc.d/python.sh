

if [ -x "$(command -v python3)" ]; then
  alias python=python3
fi

# Activate a venv
# so that we don't get any
# python externally managed
# when executing a `pip3 install`
# https://peps.python.org/pep-0668/
PYTHON_VENV="$HOME/.venv"
PYTHON_VENV_ACTIVATE="$PYTHON_VENV/bin/activate"
if [ ! -f "$PYTHON_VENV_ACTIVATE" ]; then
  python3 -m venv "$PYTHON_VENV"
fi
source "$PYTHON_VENV_ACTIVATE"
