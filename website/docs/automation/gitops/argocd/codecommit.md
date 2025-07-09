---
title: "Git repository"
sidebar_position: 5
---

Argo CD applies the GitOps methodology to Kubernetes, using Git as a source of truth for cluster desired state. You can use Argo CD to deploy applications, monitor their health, and sync them with the desired state. Kubernetes manifests can be specified in several ways:

- Kubernetes YAML files
- Kustomize applications
- Helm charts
- Jsonnet files

An AWS CodeCommit repository has been created in our lab environment, but we'll need to complete some steps before our IDE can connect to it.

We can add the SSH keys for CodeCommit to the known hosts file to prevent warnings later on:

```bash hook=ssh
$ ssh-keyscan -H git-codecommit.${AWS_REGION}.amazonaws.com &> ~/.ssh/known_hosts
```

And we can set up an identity that Git will use for our commits:

```bash
$ git config --global user.email "you@eksworkshop.com"
$ git config --global user.name "Your Name"
```

Now clone it and do some initial set-up:

```bash
$ git clone $GITOPS_REPO_URL_ARGOCD ~/environment/argocd
$ git -C ~/environment/argocd checkout -b main
Switched to a new branch 'main'
$ touch ~/environment/argocd/.gitkeep
$ git -C ~/environment/argocd add .
$ git -C ~/environment/argocd commit -am "Initial commit"
$ git -C ~/environment/argocd push --set-upstream origin main
```
