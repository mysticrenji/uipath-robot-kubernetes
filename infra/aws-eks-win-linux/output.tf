
output "output_private_subnets" {
  value = [module.vpc.private_subnets]
}