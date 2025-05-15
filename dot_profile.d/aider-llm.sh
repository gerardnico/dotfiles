
# The default llm to choose from with aider
export LLM="claude"


# Wrapper script to get the appropriate key
# by project
function aider(){

  # Projet name should be in a envrc
  PROJECT_NAME=${PROJECT_NAME:-}
  if [ "$PROJECT_NAME" == "" ]; then
    echo "Project Name is missing"
    return 1
  fi
  if ! AIDER_PATH="$(which aider)"; then
    echo "Aider path not found"
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
      exit 1
  esac


  LLM_KEY_PATH="${PROVIDER}/${PROJECT_NAME}"
  if ! LLM_KEY=$(pass "$LLM_KEY_PATH"); then
    echo "${LLM:-} Api Key Not Found for project ${PROJECT_NAME} at $LLM_KEY_PATH"
    exit 1
  fi

  eval "$ENV_NAME=$LLM_KEY $AIDER_PATH $*"

}
