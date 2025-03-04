
##############################
# Kube Utilities
# https://github.com/gerardnico/kubee
##############################
export KUBEE_CHARTS_PATH="$HOME/code/argocd/charts:$HOME/code/kubee/resources/charts/incubator"
export KUBEE_CLUSTERS_PATH="$HOME/code/argocd/clusters"
export KUBEE_CLUSTER_NAME="beau"


# Alert Manager Connection for the API
export KUBEE_ALERT_MANAGER_URL=https://alertmanager.eraldy.com
export KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_PASSWORD=alert-manager/password

# Prometheus Connection for PromTool
export KUBEE_PROM_URL=https://prometheus.eraldy.com
export KUBEE_PROM_BASIC_AUTH_PASS_USER=alert-manager/user
export KUBEE_PROM_BASIC_AUTH_PASS_PASSWORD=alert-manager/password
