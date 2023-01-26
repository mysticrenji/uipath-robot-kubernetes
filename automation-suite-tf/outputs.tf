output "interface_tour" {
  description = "The general-use Automation Suite user interface serves as a portal for both organization administrators and organization users.It is a common organization-level resource from where everyone can access all of your Automation Suite areas: administration pages,platform-level pages, service-specific pages, and user-specific pages."
  value       = "https://docs.uipath.com/automation-suite/docs/interface-tour"
}

output "automation_suite_url" {
  description = "Automation Suite Portal"
  value       = "https://${var.ui_path_fqdn}"
}

output "automation_suite_secret" {
  description = "Credentials for Automation Suite Portal"
  value       = join("", ["https://${data.aws_region.current.name}.console.aws.amazon.com/secretsmanager/home?region=${data.aws_region.current.name}#!/secret?name=", aws_cloudformation_stack.service_fabric_stack.outputs.OrgSecret])
}

output "host_administration_url" {
  description = "The host portal is for system administrators to configure the Automation Suite instance.The settings that you configure from this portal are inherited by all your organizations, and some can be overwritten at the organization level."
  value       = "https://${var.ui_path_fqdn}"
}

output "host_administration_secret" {
  description = "Credentials for Host Administration"
  value       = join("", ["https://${data.aws_region.current.name}.console.aws.amazon.com/secretsmanager/home?region=${data.aws_region.current.name}#!/secret?name=", aws_cloudformation_stack.service_fabric_stack.outputs.PlatformSecret])
}

output "argo_cd" {
  description = "You can use the ArgoCD console to manage installed products."
  value       = "https://alm.${var.ui_path_fqdn}"
}

output "argo_cd_secret" {
  description = "Secret storing the ArgoCD admin credentials"
  value       = join("", ["https://${data.aws_region.current.name}.console.aws.amazon.com/secretsmanager/home?region=${data.aws_region.current.name}#!/secret?name=", aws_cloudformation_stack.service_fabric_stack.outputs.ArgoCdSecret])
}

output "monitoring_fqdn" {
  description = "The Monitoring login page"
  value       = "https://monitoring.${var.ui_path_fqdn}"
}

output "input_json_secret" {
  description = "Secret storing the input.json content."
  value       = join("", ["https://${data.aws_region.current.name}.console.aws.amazon.com/secretsmanager/home?region=${data.aws_region.current.name}#!/secret?name=", aws_cloudformation_stack.service_fabric_stack.outputs.InputJsonSecret])
}

output "cluster_administration_url" {
  description = "The Unified UI for Cluster management page."
  value       = "https://${var.ui_path_fqdn}/uipath-management/"
}
