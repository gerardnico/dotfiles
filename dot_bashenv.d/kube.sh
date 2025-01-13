
##############################
# Kube Utilities
# https://github.com/gerardnico/kube-x
##############################
export KUBE_X_CHARTS_PATH="$HOME/code/argocd/charts"
export KUBE_X_CLUSTERS_PATH="$HOME/code/argocd/clusters"
export KUBE_X_CLUSTER="beau"
export KUBE_X_USER="default"

# Alert Manager Connection for the API
export KUBE_X_ALERT_MANAGER_URL=https://alertmanager.eraldy.com
export KUBE_X_ALERT_MANAGER_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBE_X_ALERT_MANAGER_BASIC_AUTH_PASS_PASSWORD=alert-manager/password

# Prometheus Connection for PromTool
export KUBE_X_PROM_URL=https://prometheus.eraldy.com
export KUBE_X_PROM_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBE_X_PROM_BASIC_AUTH_PASS_PASSWORD=alert-manager/password
