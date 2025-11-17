
# Use tabul outside of the ide project
BIN_TABUL_HOME=/opt/tabulify/bin
if [ -d "$BIN_TABUL_HOME" ]; then
  export PATH=$BIN_TABUL_HOME:$PATH
fi

