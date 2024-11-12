#!/bin/bash

##############################
# Kube Utilities
# https://github.com/gerardnico/kube-x
##############################
export KUBE_X_APP_HOME="$HOME/code/argocd:$HOME/code/infra/kustomize"
export KUBE_X_CLUSTER="beau"
export KUBE_X_USER="default"
export KUBE_X_KUBECTL="kubectx"

# If not interactive, return
[[ "$-" != *i* ]] && return

##############################
# Kube
##############################
if [ -x "$(command -v kubectl)" ]; then

  # Kube editor
  # KUBE_EDITOR default to vi on Linux and notepad on Windows
  # https://kubernetes.io/docs/reference/kubectl/generated/kubectl_edit/
  if [ "$CYGWIN" = 1 ] ; then
    # kubectl a windows like style path
     export KUBE_EDITOR='c:/Notepad++/notepad++.exe -notabbar -multiInst -nosession -noPlugin'
  fi

  # Kubeconfig Completion and alias as k
  # shellcheck disable=SC1090
  source <(kubectl completion bash)
  alias k=kubectl
  complete -o default -F __start_kubectl k

fi


