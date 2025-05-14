---
title: "Automating the image update"
sidebar_position: 20
---

Now that we have a pipeline that publishes container images let's automate the image updates using [Flux Image Automation Controller](https://fluxcd.io/flux/guides/image-update/) which we installed during the initial Flux bootstrap process.

First we'll need to update the HelmRelease resource to enable updating the image:

::yaml{file="manifests/modules/automation/gitops/flux/pipeline/ui/helm.yaml" paths="spec.values.image"}

1. Use comments to indicate these fields are to be managed for automated image updates

Next there are several resources needed to configure Flux to handle these comments correctly.

An ImageRepository resource gives Flux the information about the ECR repository where our images are published:

::yaml{file="manifests/modules/automation/gitops/flux/pipeline/imagerepository.yaml"}

Let's copy that, populating the ECR repository URL:

```bash
$ cat ~/environment/eks-workshop/modules/automation/gitops/flux/pipeline/imagerepository.yaml | envsubst > ~/environment/flux/apps/ui/imagerepository.yaml
```

An ImagePolicy resource tells Flux how to filter the image tags in the ECR repository:

::yaml{file="manifests/modules/automation/gitops/flux/pipeline/ui/imagepolicy.yaml"}

Let's copy that and update the kustomization for our new files:

```bash
$ cp ~/environment/eks-workshop/modules/automation/gitops/flux/pipeline/ui/* \
  ~/environment/flux/apps/ui
```

And and `ImageUpdateAutomation` resource configures the overall automation:

```file
manifests/modules/automation/gitops/flux/pipeline/imageupdateautomation.yaml
```

Let's copy that file to our repository:

```bash
$ cp ~/environment/eks-workshop/modules/automation/gitops/flux/pipeline/imageupdateautomation.yaml \
  ~/environment/flux
```

Commit these changes to the Flux repository and trigger and reconcile:

```bash wait=60
$ git -C ~/environment/flux add .
$ git -C ~/environment/flux commit -am "Adding image updates"
$ git -C ~/environment/flux push
$ flux reconcile kustomization apps --with-source
```

After the changes are reconciled Flux will update our Helm chart configuration to use the image that was published to ECR by the pipeline. Let's pull the latest changes from the Flux source repository:

```bash
$ git -C ~/environment/flux pull
remote: Counting objects: 5, done.
Unpacking objects: 100% (5/5), 1.02 KiB | 1.02 MiB/s, done.
From ssh://git-codecommit.us-west-2.amazonaws.com/v1/repos/eks-workshop-gitops
   73aae2a..04b758e  main       -> origin/main
Updating 73aae2a..04b758e
Fast-forward
 apps/ui/helm.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
$ git -C ~/environment/flux log
commit 04b758ef30e4bdbed037f302367bc29ca7f46c5c (HEAD -> main, origin/main, origin/HEAD)
Author: fluxcdbot <fluxcdbot@users.noreply.github.com>
Date:   Wed May 7 20:15:01 2025 +0000

    1234567890.dkr.ecr.us-west-2.amazonaws.com/eks-workshop-ui:build-d35c8452
```

We can see from the `git log` output that a change was committed by Flux to update the container image. Check the contents of the Helm configuration and check the `image` values:

```bash
$ cat ~/environment/flux/apps/ui/helm.yaml
[...]
    image:
      repository: 1234567890.dkr.ecr.us-west-2.amazonaws.com/eks-workshop-ui # {"$imagepolicy": "flux-system:ui:name"}
      tag: build-d35c8452 # {"$imagepolicy": "flux-system:ui:tag"}
```

During its next reconcile Flux will pick up this change to the Helm configuration and deploy that to the cluster:

```bash
$ kubectl get deployment -n ui ui -o yaml | yq '.spec.template.spec.containers[0].image'
1234567890.dkr.ecr.us-west-2.amazonaws.com/eks-workshop-ui:build-d35c8452
```
