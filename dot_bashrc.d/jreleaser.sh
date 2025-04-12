

# https://github.com/jreleaser/jreleaser/discussions/1851
function jreleaser(){
  (
    if [ "${JRELEASER_BASEDIR:-}" != "" ]; then
      if ! cd "$JRELEASER_BASEDIR"; then
        echo "$JRELEASER_BASEDIR does not exist"
        return 1
      fi
    fi
    if ! JRELEASER_PATH="$(which jreleaser)"; then
      echo "Jreleaser path not found"
      return 1
    fi
    "$JRELEASER_PATH" "$@"
  )
}