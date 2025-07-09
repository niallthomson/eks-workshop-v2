---
title: "Argo CD"
sidebar_position: 3
sidebar_custom_props: { "module": true }
description: "Declarative, GitOps continuous delivery with ArgoCD on Amazon Elastic Kubernetes Service."
---

::required-time

:::tip Before you start
Prepare your environment for this section:

```bash timeout=300 wait=120
$ prepare-environment automation/gitops/argocd
```

This will make the following changes to your lab environment:

- Create an AWS CodeCommit repository
- Create an IAM user and SSH key to authenticate to the repository

You can view the Terraform that applies these changes [here](https://github.com/VAR::MANIFESTS_OWNER/VAR::MANIFESTS_REPOSITORY/tree/VAR::MANIFESTS_REF/manifests/modules/automation/gitops/argocd/.workshop/terraform).

:::

[Argo CD](https://argoproj.github.io/cd/) is a declarative continuous delivery tool for Kubernetes that follows GitOps principles. It runs as a controller in your cluster and monitors Git repositories for changes, automatically synchronizing applications to match the state defined in your Git repository.

Argo CD is a CNCF graduated project that provides a web UI for managing deployments, supports multi-cluster configurations, and can integrate with CI/CD pipelines. It includes features like access controls, drift detection, and support for different deployment strategies.
