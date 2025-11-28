# The default llm to choose from with aider
export LLM="claude"

# Wrapper script to get the appropriate key
# by project
function aider() {

  # Project name should be in a envrc
  PROJECT_NAME=${PROJECT_NAME:-}
  if [ "$PROJECT_NAME" == "" ]; then
    echo "Project Name env (PROJECT_NAME) is missing"
    return 1
  fi
  ORGANIZATION_NAME=${ORGANIZATION_NAME:-}
  if [ "$ORGANIZATION_NAME" == "" ]; then
    echo "Organization Name env (ORGANIZATION_NAME) is missing"
    return 1
  fi
  if ! AIDER_PATH="$(which aider)"; then
    echo "Aider not found in PATH"
    return 1
  fi

  case "${LLM:-}" in
  "openai")
    ENV_NAME="OPENAI_API_KEY"
    PROJECT_NAME="${PROJECT_NAME}-project"
    PROVIDER="openai"
    ;;
  "claude")
    ENV_NAME="ANTHROPIC_API_KEY"
    PROVIDER="anthropic"
    ;;
  "openrouter")
    # 5% + .35 fee
    # use lite.llm
    ENV_NAME="OPENROUTER_API_KEY"
    PROVIDER="openrouter"
    ;;
  *)
    echo "LLM ${LLM:-} is unknown"
    return 1
    ;;
  esac

  LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/${PROJECT_NAME}"
  if ! LLM_KEY=$(pass "$LLM_KEY_PATH"); then
    echo "${LLM:-} Api Key Not Found at $LLM_KEY_PATH"
    LLM_KEY_PATH="${PROVIDER}/${ORGANIZATION_NAME}/default"
  fi
  if ! LLM_KEY=$(pass "$LLM_KEY_PATH"); then
    echo "${LLM:-} Api Key Not Found at $LLM_KEY_PATH"
    return 1
  fi

  eval "$ENV_NAME=$LLM_KEY $AIDER_PATH $*"

}
