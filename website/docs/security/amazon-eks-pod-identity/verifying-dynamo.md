---
title: "Verifying DynamoDB access"
sidebar_position: 35
---

Now, with the `carts` Service Account associated with the authorized IAM role, the `carts` Pod has permission to access the DynamoDB table. Access the web store again and navigate to the shopping cart.

```bash
$ LB_HOSTNAME=$(kubectl -n ui get service ui-nlb -o jsonpath='{.status.loadBalancer.ingress[*].hostname}{"\n"}')
$ echo "http://$LB_HOSTNAME"
http://k8s-ui-uinlb-647e781087-6717c5049aa96bd9.elb.us-west-2.amazonaws.com
```

The `carts` Pod is able to reach the DynamoDB service and the shopping cart is now accessible!

<Browser url="http://k8s-ui-uinlb-647e781087-6717c5049aa96bd9.elb.us-west-2.amazonaws.com/cart">
<img src={require('@site/static/img/sample-app-screens/shopping-cart.webp').default}/>
</Browser>

After the AWS IAM role is associated with the Service Account, any newly created Pods using that Service Account will be intercepted by the [EKS Pod Identity webhook](https://github.com/aws/amazon-eks-pod-identity-webhook). This webhook runs on the Amazon EKS cluster's control plane and is fully managed by AWS. Let's take a closer look at the new `carts` Pod to see the environment variables injected by the Pod Identity agent:

```bash
$ kubectl -n carts exec deployment/carts -- env | grep AWS
AWS_STS_REGIONAL_ENDPOINTS=regional
AWS_DEFAULT_REGION=us-west-2
AWS_REGION=us-west-2
AWS_CONTAINER_CREDENTIALS_FULL_URI=http://169.254.170.23/v1/credentials
AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE=/var/run/secrets/pods.eks.amazonaws.com/serviceaccount/eks-pod-identity-token
```

These environment variables have been automatically set by EKS Pod Identity to allow AWS SDKs to obtain temporary credentials. Key points to note:

- `AWS_DEFAULT_REGION` and `AWS_REGION` are set automatically to the same region as your EKS cluster
- `AWS_STS_REGIONAL_ENDPOINTS` is configured as "regional" to avoid putting pressure on the global endpoint in `us-east-1`
- `AWS_CONTAINER_CREDENTIALS_FULL_URI` variable tells AWS SDKs how to obtain credentials using the [HTTP credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html)
- `AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE` points to the token file used to authenticate requests for credentials

Unlike IRSA which used web identity federation, EKS Pod Identity uses an HTTP credentials endpoint to provide temporary credentials to Pods. This means that Pod Identity doesn't need to inject credentials via something like an `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` pair. You can read more about how this mechanism works in the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html).

You have successfully configured Pod Identity for your application!
