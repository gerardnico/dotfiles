
##############################
# Kube Utilities
# https://github.com/gerardnico/kubee
# We keep kube in the name because this is how we search for kube related repo
##############################
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
