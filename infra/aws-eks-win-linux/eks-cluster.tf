module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.eks_cluster_name
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = true
  enable_vpn_gateway     = true
  one_nat_gateway_per_az = false


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_ami" "lin_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_cluster_version}-*"]
  }
}
data "aws_ami" "win_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Core-EKS_Optimized-${var.eks_cluster_version}-*"]
  }
}

data "aws_subnet_ids" "vpc_id" {
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}

data "aws_subnet" "subnets" {
  count      = length(data.aws_subnet_ids.vpc_id.ids)
  id         = tolist(data.aws_subnet_ids.vpc_id.ids)[count.index]
  depends_on = [module.vpc]
}

module "cluster" {
  depends_on = [
    module.vpc
  ]
  source              = "./cluster"
  region              = var.region
  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version
  private_subnet_ids  = ["subnet-016ac324c2afdba94", "subnet-009426100486a51af"]
  vpc_id              = module.vpc.vpc_id
  lin_desired_size    = var.lin_desired_size
  lin_max_size        = var.lin_max_size
  lin_min_size        = var.lin_min_size
  lin_instance_type   = var.lin_instance_type
  win_desired_size    = var.win_desired_size
  win_max_size        = var.win_max_size
  win_min_size        = var.win_min_size
  win_instance_type   = var.win_instance_type
  node_host_key_name  = var.node_host_key_name
}

