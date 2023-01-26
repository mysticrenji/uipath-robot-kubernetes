data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  UsingDefaultBucket = var.qss3_bucket_name
  AZCondition        = var.number_of_a_zs
}


resource "aws_cloudformation_stack" "network_stack" {
  template_url = "https://${local.UsingDefaultBucket ? "${var.qss3_bucket_name}-${data.aws_region.current.name}" : var.qss3_bucket_name}.s3.${local.UsingDefaultBucket ? data.aws_region.current.name : var.qss3_bucket_region}.${data.aws_partition.current.dns_suffix}/${var.qss3_key_prefix}submodules/quickstart-aws-vpc/templates/aws-vpc.template.yaml"
  parameters = {
    AvailabilityZones = join(",", var.availability_zones)
    NumberOfAZs       = var.number_of_a_zs
    VPCCIDR           = "10.0.0.0/16"
  }
}

resource "aws_cloudformation_stack" "service_fabric_stack" {
  template_url = "https://${local.UsingDefaultBucket ? "${var.qss3_bucket_name}-${data.aws_region.current.name}" : var.qss3_bucket_name}.s3.${local.UsingDefaultBucket ? data.aws_region.current.name : var.qss3_bucket_region}.${data.aws_partition.current.dns_suffix}/${var.qss3_key_prefix}templates/uipath-sf.template.yaml"
  parameters = {
    VPCCIDR                       = "10.0.0.0/16"
    VPCID                         = aws_cloudformation_stack.network_stack.outputs.VPCID
    KeyPairName                   = var.key_pair_name
    PrivateSubnetIDs              = join(",", [aws_cloudformation_stack.network_stack.outputs.PrivateSubnet1AID, aws_cloudformation_stack.network_stack.outputs.PrivateSubnet2AID, local.AZCondition ? aws_cloudformation_stack.network_stack.outputs.PrivateSubnet3AID : null])
    PublicSubnetIDs               = join(",", [aws_cloudformation_stack.network_stack.outputs.PublicSubnet1ID, aws_cloudformation_stack.network_stack.outputs.PublicSubnet2ID, local.AZCondition ? aws_cloudformation_stack.network_stack.outputs.PublicSubnet3ID : null])
    NumberOfAZs                   = var.number_of_a_zs
    MultiNode                     = var.multi_node
    EnableBackup                  = var.enable_backup
    UseLevel7LoadBalancer         = var.use_level7_load_balancer
    PerformInstallation           = "true"
    AddGpu                        = var.add_gpu
    GpuAmiId                      = var.gpu_ami_id
    ExtraConfigKeys               = var.extra_config_keys
    SelfSignedCertificateValidity = var.self_signed_certificate_validity
    UiPathFQDN                    = var.ui_path_fqdn
    Orchestrator                  = var.orchestrator
    ActionCenter                  = var.action_center
    AutomationHub                 = var.automation_hub
    AutomationOps                 = var.automation_ops
    DataService                   = var.data_service
    Insights                      = var.insights
    TestManager                   = var.test_manager
    AiCenter                      = var.ai_center
    BusinessApps                  = var.business_apps
    DocumentUnderstanding         = var.document_understanding
    TaskMining                    = var.task_mining
    ASRobots                      = var.as_robots
    UseExternalOrchestrator       = var.use_external_orchestrator
    OrchestratorURL               = var.orchestrator_url
    IdentityURL                   = var.identity_url
    OrchestratorCertificate       = var.orchestrator_certificate
    IdentityCertificate           = var.identity_certificate
    ProcessMining                 = var.process_mining
    HostedZoneID                  = var.hosted_zone_id
    QSS3BucketName                = var.qss3_bucket_name
    QSS3KeyPrefix                 = var.qss3_key_prefix
    QSS3BucketRegion              = var.qss3_bucket_region
    InstallerDownloadUrl          = var.installer_download_url
    UiPathVersion                 = var.ui_path_version
    RDSEngine                     = var.rds_engine
    RDSVersion                    = var.rds_version
    AmiId                         = var.ami_id
    AcmCertificateArn             = var.acm_certificate_arn
    UseInternalLoadBalancer       = var.use_internal_load_balancer
    DatabaseKmsKeyId              = var.database_kms_key_id
    DeployBastion                 = var.deploy_bastion
    IamRoleArn                    = var.iam_role_arn
    IamRoleName                   = var.iam_role_name
    AcceptLicenseAgreement        = var.accept_license_agreement
  }
}
