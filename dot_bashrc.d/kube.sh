#!/bin/bash

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

##############################
# Kube Utilities
# https://github.com/gerardnico/kube
##############################
export KUBE_APP_HOME=$HOME/code/argocd
export KUBE_PUBLIC_KEY=$HOME/.ssh/nico02_rsa.pub
