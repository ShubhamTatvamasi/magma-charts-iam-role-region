#!/usr/bin/env bash

set -e

mkdir -p charts

MAGMA_ROOT=/Users/shubham/myfiles/magma-production/move-cert-manager-to-iam-role
CHARTS_REPO=${PWD}/charts

declare -A orc8r_helm_charts

orc8r_helm_charts=( 
  [orc8r]="orc8r/cloud/helm/orc8r"
  [lte-orc8r]="lte/cloud/helm/lte-orc8r"
  [feg-orc8r]="feg/cloud/helm/feg-orc8r"
  [cwf-orc8r]="cwf/cloud/helm/cwf-orc8r"
  [secrets]="orc8r/cloud/helm/orc8r/charts/secrets"
  [fbinternal-orc8r]="fbinternal/cloud/helm/fbinternal-orc8r"
)

for orc8r_chart in "${orc8r_helm_charts[@]}"
do
  cp -r ${MAGMA_ROOT}/${orc8r_chart} ${CHARTS_REPO}
done

# Delete Chart.lock files
find ${CHARTS_REPO} -type f -name 'Chart.lock' -delete

# Replace orc8rlib repo link
find ${CHARTS_REPO} -maxdepth 2 -type f -name 'Chart.yaml' -exec \
  yq e '(.dependencies[] | select(.name == "orc8rlib") | .repository) = "https://shubhamtatvamasi.github.io/magma-orc8rlib-chart-161"' -i {} \;
