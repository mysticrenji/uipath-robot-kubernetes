variable "availability_zones" {
  description = "Choose up to three Availability Zones to use for the VPC subnets."
  type        = string
}

variable "number_of_a_zs" {
  description = "Choose the number of Availability Zones to use in the VPC. This must match the number of AZs selected in the *Availability Zones* parameter."
  type        = string
  default     = "2"
}

variable "key_pair_name" {
  description = "Existing key pair to connect to virtual machine (VM) instances."
  type        = string
}

variable "ami_id" {
  description = "Enter the AMI Id to be used for the creation of the EC2 instances of the cluster.Leave empty to determine automatically the AMI to use."
  type        = string
}

variable "gpu_ami_id" {
  description = "Enter the AMI Id to be used for the creation of the GPU enabled EC2 instance.Leave empty to determine automatically the AMI to use."
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of a pre-deployed IAM Role with sufficient permissions for the deployment. Leave empty to create the role"
  type        = string
}

variable "iam_role_name" {
  description = "Name of a pre-deployed IAM Role with sufficient permissions for the deployment. Leave empty to create the role"
  type        = string
}

variable "multi_node" {
  description = "Install Automation Suite on a Single Node (recommended for evaluation/dev purposes) or Multi-node (recommended for production purposes)"
  type        = string
  default     = "Single Node"
}

variable "enable_backup" {
  description = "Choose false to disable cluster backup."
  type        = string
  default     = "true"
}

variable "use_level7_load_balancer" {
  description = "Select either an Application Load Balancer (ALB) or a Network Load Balancer (NLB)"
  type        = string
  default     = "ALB"
}

variable "ui_path_version" {
  description = "UiPath version to install"
  type        = string
  default     = "2022.10.1"
}

variable "installer_download_url" {
  description = "Custom URL for installer download. Leave empty to use the UiPathVersion, provide an URL to override the version."
  type        = string
}

variable "extra_config_keys" {
  description = "Extra configuration keys to add to the cluster config. Leave empty to use default config."
  type        = string
}

variable "self_signed_certificate_validity" {
  description = "Validity of the self signed certificate in days, used by the deployment to encrypt traffic inside the VPC."
  type        = string
  default     = "1825"
}

variable "orchestrator" {
  description = "Choose false to disable Orchestrator installation."
  type        = string
  default     = "true"
}

variable "action_center" {
  description = "Choose false to disable Action Center installation."
  type        = string
  default     = "true"
}

variable "insights" {
  description = "Choose false to disable Insights installation."
  type        = string
  default     = "true"
}

variable "automation_hub" {
  description = "Choose false to disable Automation Hub installation."
  type        = string
  default     = "true"
}

variable "automation_ops" {
  description = "Choose false to disable Automation Ops installation."
  type        = string
  default     = "true"
}

variable "test_manager" {
  description = "Choose false to disable Test Manager installation."
  type        = string
  default     = "true"
}

variable "data_service" {
  description = "Choose false to disable Data Service installation."
  type        = string
  default     = "true"
}

variable "ai_center" {
  description = "Choose false to disable AI Center installation."
  type        = string
  default     = "true"
}

variable "business_apps" {
  description = "Choose false to disable Apps installation."
  type        = string
  default     = "true"
}

variable "document_understanding" {
  description = "Choose false to disable Document Understanding installation."
  type        = string
  default     = "true"
}

variable "task_mining" {
  description = "Choose false to disable Task Mining installation."
  type        = string
  default     = "true"
}

variable "as_robots" {
  description = "Chose false to disable Automation Suite Robots installation."
  type        = string
  default     = "true"
}

variable "process_mining" {
  description = "Choose false to disable Process Mining installation."
  type        = string
  default     = "true"
}

variable "add_gpu" {
  description = "Choose true to add a GPU enabled VM to the deployment."
  type        = string
  default     = "false"
}

variable "use_external_orchestrator" {
  description = "Choose true to connect AiCenter to an external Orchestrator"
  type        = string
  default     = "false"
}

variable "orchestrator_url" {
  description = "URL of the Orchestrator to which AiCenter connects"
  type        = string
}

variable "identity_url" {
  description = "URL of the Identity server used to authorize AiCenter"
  type        = string
}

variable "orchestrator_certificate" {
  description = "Base64 encoded Orchestrator certificate"
  type        = string
}

variable "identity_certificate" {
  description = "Base64 encoded Identity certificate"
  type        = string
}

variable "hosted_zone_id" {
  description = "ID of Route 53 hosted zone. Leave empty to pause the deployment once the load balancer was created and manually configure the DNS."
  type        = string
}

variable "ui_path_fqdn" {
  description = "Fully qualified domain name (FQDN) for Automation Suite. This must be either a subdomain, or root domain, of the of ID of Route 53 hosted zone parameter."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of certificate present in the ACM (Amazon Certificate Manager) to use with the ALB.Leave empty to create the public certificate during deployment."
  type        = string
}

variable "use_internal_load_balancer" {
  description = "Deploy Internal Load Balancer"
  type        = string
  default     = "false"
}

variable "deploy_bastion" {
  description = "Deploy a bastion host inside the public subnet.Choose false to skip deploying the Bastion."
  type        = string
  default     = "true"
}

variable "rds_engine" {
  description = "RDS MS SQL engine"
  type        = string
  default     = "sqlserver-se"
}

variable "rds_version" {
  description = "RDS MS SQL version"
  type        = string
  default     = "15.00"
}

variable "database_kms_key_id" {
  description = "KMS Key Id to use for the encryption of the RDS storage. Leave empty to not encrypt the RDS storage"
  type        = string
}

variable "qss3_bucket_name" {
  description = "Name of the S3 bucket for your copy of the Quick Start assets. Do not modify."
  type        = string
  default     = "uipath-s3-quickstart"
}

variable "qss3_bucket_region" {
  description = "AWS Region where the Quick Start S3 bucket (QSS3BucketName) is hosted. Do not modify."
  type        = string
  default     = "us-east-1"
}

variable "qss3_key_prefix" {
  description = "S3 key prefix that is used to simulate a directory for your copy of the Quick Start assets. Do not modify."
  type        = string
  default     = "aws-quickstart-sf-v2022-10-3/"
}

variable "accept_license_agreement" {
  description = "Use of paid UiPath products and services is subject to the licensing agreement executed between you and UiPath. Unless otherwise indicated by UiPath, use of free UiPath products is subject to the associated licensing agreement available here: https://www.uipath.com/legal/trust-and-security/legal-terms (or successor website). Type true in the text input field to confirm that you agree to the applicable licensing agreement."
  type        = string
}
