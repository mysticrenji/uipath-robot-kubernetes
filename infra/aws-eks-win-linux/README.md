# Create an EKS Cluster with Linux nodes

## Pre-requisites
1. AWS Account 
2. Terraform CLI

## Terraform Execution

```
terraform init
terraform fmt -recursive
terraform plan -var-file=prod.tfvars
terraforma apply -var-file=prod.tfvars
```

## Update kubeconfig for eks cluster
```
aws eks --region eu-west-1 update-kubeconfig --name eks-dev-cluster
```