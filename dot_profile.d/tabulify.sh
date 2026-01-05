# Add ntabul to the PATH so that we can test it against external project

NTABUL_DIR=$HOME/code/tabulify/tabulify/contrib/script
if [ -d "$NTABUL_DIR" ] && [[ ":$PATH:" != *":$NTABUL_DIR:"* ]]; then
  export PATH="$NTABUL_DIR:$PATH"
fi
