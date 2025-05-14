---
title: "Continuous Integration and GitOps"
sidebar_position: 50
---

We have successfully bootstrapped Flux on EKS cluster and deployed the application. To demonstrate how to make changes in the source code an application, build a new container images and leverage GitOps to deploy a new image to a cluster we introduce a continuous integration pipeline. We will leverage AWS Developer Tools and [DevOps principles](https://aws.amazon.com/devops/what-is-devops/) to build [multi-architecture container images](https://aws.amazon.com/blogs/containers/introducing-multi-architecture-container-images-for-amazon-ecr/) for Amazon ECR.

The pipeline was created during the lab preparation but we still have some steps to get it up and running.

![CI](../assets/ci-multi-arch.webp)
