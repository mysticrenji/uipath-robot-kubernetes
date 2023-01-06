# Create an EKS Cluster with Linux and Windows Node groups

The complete walkthrough for creating the Cluster and technical explation are mentioned in the below AWS Blog. Please read it
- https://aws.amazon.com/blogs/containers/running-windows-workloads-on-a-private-eks-cluster/ </br>
I slightly modified the terraform scripts to suit my needs of creating a cluster and running Gitlab runners on windows nodes.

## Pre-requisites
1. AWS Account 
2. Terraform CLI
3. Helm CLI

## Terraform Execution
The Terraform script in the repo will create a VPC and related subnets at first. Then secondly it will go ahead with the provisioning of EKS Cluster. The variables are passed from ```prod.tfvars```

```
terraform init
terraform fmt -recursive
terraform plan -var-file=prod.tfvars
terraforma apply -var-file=prod.tfvars
```

## Update kubeconfig for eks cluster
```
aws eks --region us-west-2 update-kubeconfig --name eks-linux-win
```

##  Install Gitlab Runner on EKS Cluster windows nodes

```
helm repo add gitlab https://charts.gitlab.io
helm repo update
cd /aws-eks-win-linux/tools/Gitlab
kubectl create -f secret.yaml
helm install gitlab-runner -f values.yaml gitlab/gitlab-runner
```

## References
1. https://docs.gitlab.com/runner/executors/docker.html#supported-windows-versions
2. https://docs.gitlab.com/runner/executors/kubernetes.html#example-for-windowsamd64