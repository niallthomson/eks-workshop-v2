# #!/bin/bash

# Anything user has created after prepare-environment

set -e

kubectl delete namespace ui --ignore-not-found

kubectl delete storageclass fsxz-vol-sc --ignore-not-found=true

uninstall-helm-chart aws-fsx-openzfs-csi-driver kube-system