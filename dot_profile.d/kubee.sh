##############################
# Kube Utilities
# https://github.com/bytle/kubee
# We keep kube in the name because this is how we search for kube related repo
##############################

# Adding nkubee in the PATH
NKUBEE_DIR=$HOME/code/bytle/kubee/contrib/scripts-global
if [[ ":$PATH:" != *":$NKUBEE_DIR:"* ]]; then
  # for an unknown reason, this script is called twice
  # we check if the nkubee dir is already in the PATH
  export PATH="$PATH:$NKUBEE_DIR"
fi

export KUBEE_CHARTS_PATH="$HOME/code/kube-argocd/charts"
export KUBEE_CLUSTERS_PATH="$HOME/code/kube-argocd/clusters"
export KUBEE_CLUSTER_NAME="beau"

# kube env
export HELM_BIN="kubee helm"
export HELM_MAX_HISTORY=3

# Alert Manager Connection for the API
export KUBEE_ALERT_MANAGER_URL=https://alertmanager.eraldy.com
export KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_PASSWORD=alert-manager/password

# Prometheus Connection for PromTool
export KUBEE_PROM_URL=https://prometheus.eraldy.com
export KUBEE_PROM_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBEE_PROM_BASIC_AUTH_PASS_PASSWORD=alert-manager/password
