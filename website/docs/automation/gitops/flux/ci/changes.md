---
title: "Deploying a change"
sidebar_position: 30
---

Let's make a change to the sample application to see it being deployed. We'll do this by changing the default theme of the store UI.

We'll do this by making a change to the Dockerfile:

```file
manifests/modules/automation/gitops/flux/pipeline/Dockerfile-update
```

Copy this to the application sources repository:

```bash
$ cp ~/environment/eks-workshop/modules/automation/gitops/flux/pipeline/Dockerfile-update \
  ~/environment/retail-store-sample-codecommit/Dockerfile
```

Commit changes.

```bash
$ git -C ~/environment/retail-store-sample-codecommit commit -am "Change UI theme"
$ git -C ~/environment/retail-store-sample-codecommit push
```

Lets wait until the CodePipeline execution has finished:

```bash timeout=900 wait=30
$ REVISION_ID=$(git -C ~/environment/retail-store-sample-codecommit rev-parse HEAD)
$ while [[ "$(aws codepipeline list-pipeline-executions --pipeline-name eks-workshop-ui --query "pipelineExecutionSummaries[?sourceRevisions[?revisionId=='$REVISION_ID']].status" --output text)" != "Succeeded" ]]; do echo "Waiting for pipeline to execute..."; sleep 10; done; echo "Done!"
```

Then we can trigger Flux to make sure it reconciles the new image:

```bash
$ flux reconcile image repository ui
$ sleep 5
$ flux reconcile kustomization apps --with-source
$ kubectl wait deployment -n ui ui --for condition=Available=True --timeout=120s
```

After successful build and deployment (5-10 minutes) we will have the new version of UI application up and running.

![ui-after](../assets/ui-after.webp)

As before you can check the Git repository commit log to see the change made by Flux that drove this update.
